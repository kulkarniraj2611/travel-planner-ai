from flask import Flask, render_template, request, jsonify
import mysql.connector
import os
import requests
from datetime import datetime
from dotenv import load_dotenv
load_dotenv(override=True)
app = Flask(__name__)

# ─────────────────────────────────────────────
# DATABASE CONFIG — update password if needed
# ─────────────────────────────────────────────
DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": os.environ.get("DB_PASSWORD"),   # <-- Change this
    "database": "travel_planner"
}

# ─────────────────────────────────────────────
# Gemini API Config (reads GEMINI_API_KEY env var)
# ─────────────────────────────────────────────
GROQ_URL = "https://api.groq.com/openai/v1/chat/completions"

def get_db():
    return mysql.connector.connect(**DB_CONFIG)


def call_gemini(prompt):
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {os.environ.get('GROQ_API_KEY')}"
    }
    payload = {
        "model": "llama-3.1-8b-instant",
        "messages": [{"role": "user", "content": prompt}],
        "max_tokens": 2000,
        "temperature": 0.8
    }
    response = requests.post(
        GROQ_URL,
        headers=headers,
        json=payload,
        timeout=30
    )
    response.raise_for_status()
    result = response.json()
    return result["choices"][0]["message"]["content"]


# ─────────────────────────────────────────────
# ROUTES
# ─────────────────────────────────────────────

@app.route("/")
def index():
    return render_template("index.html")


@app.route("/generate", methods=["POST"])
def generate_itinerary():
    data = request.get_json()

    destination   = data.get("destination", "").strip()
    duration      = int(data.get("duration", 5))
    budget        = float(data.get("budget", 1000))
    travel_style  = data.get("travel_style", "Cultural")
    num_travelers = int(data.get("num_travelers", 1))
    user_name     = data.get("user_name", "Traveler").strip()
    preferences   = data.get("preferences", "")

    if not destination:
        return jsonify({"error": "Destination is required"}), 400

    # Build AI prompt
    prompt = f"""You are an expert travel planner. Create a detailed day-by-day travel itinerary.

Destination: {destination}
Duration: {duration} days
Total Budget: ₹{budget:,.0f} (Indian Rupees) for {num_travelers} traveler(s)
Travel Style: {travel_style}
Special Preferences: {preferences if preferences else 'None'}

Create a complete itinerary with:
1. A brief intro about the destination (2-3 sentences)
2. Day-by-day plan (each day with Morning, Afternoon, Evening activities)
3. Specific restaurant recommendations for each day
4. Estimated daily cost breakdown
5. Packing tips (5 items)
6. Best tips for this destination (3 tips)

Format clearly with Day 1, Day 2, etc. as headers. Be specific with place names, timings, and costs."""

    try:
        itinerary_text = call_gemini(prompt)
    except Exception as e:
        return jsonify({"error": f"AI error: {str(e)}"}), 500

    # Save to MySQL
    try:
        db = get_db()
        cursor = db.cursor()

        cursor.execute("""
            INSERT INTO trips (user_name, destination, duration_days, budget, travel_style, num_travelers, itinerary)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """, (user_name, destination, duration, budget, travel_style, num_travelers, itinerary_text))

        trip_id = cursor.lastrowid

        # Update user preferences
        cursor.execute("""
            INSERT INTO user_preferences (user_name, preferred_style, avg_budget, total_trips)
            VALUES (%s, %s, %s, 1)
            ON DUPLICATE KEY UPDATE
                preferred_style = %s,
                avg_budget = (avg_budget + %s) / 2,
                total_trips = total_trips + 1,
                updated_at = NOW()
        """, (user_name, travel_style, budget, travel_style, budget))

        db.commit()
        cursor.close()
        db.close()
    except Exception as e:
        return jsonify({"error": f"Database error: {str(e)}"}), 500

    return jsonify({
        "success": True,
        "trip_id": trip_id,
        "itinerary": itinerary_text,
        "destination": destination,
        "duration": duration
    })


@app.route("/past-trips", methods=["GET"])
def past_trips():
    try:
        db = get_db()
        cursor = db.cursor(dictionary=True)
        cursor.execute("""
            SELECT id, user_name, destination, duration_days, budget,
                   travel_style, num_travelers, created_at
            FROM trips
            ORDER BY created_at DESC
            LIMIT 20
        """)
        trips = cursor.fetchall()
        for t in trips:
            t["created_at"] = t["created_at"].strftime("%d %b %Y, %I:%M %p")
        cursor.close()
        db.close()
        return jsonify({"trips": trips})
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/trip/<int:trip_id>", methods=["GET"])
def get_trip(trip_id):
    try:
        db = get_db()
        cursor = db.cursor(dictionary=True)
        cursor.execute("SELECT * FROM trips WHERE id = %s", (trip_id,))
        trip = cursor.fetchone()
        cursor.close()
        db.close()
        if not trip:
            return jsonify({"error": "Trip not found"}), 404
        trip["created_at"] = trip["created_at"].strftime("%d %b %Y, %I:%M %p")
        return jsonify(trip)
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/destinations", methods=["GET"])
def get_destinations():
    style   = request.args.get("style", "")
    budget  = request.args.get("budget", 0, type=float)
    try:
        db = get_db()
        cursor = db.cursor(dictionary=True)
        query = """
            SELECT DISTINCT name, country, continent, best_season,
                   avg_daily_budget_usd, travel_style, description
            FROM destinations
            WHERE name NOT LIKE '% (Alt)%'
              AND name NOT LIKE '% - Extended%'
              AND name NOT LIKE '% - Budget%'
              AND name NOT LIKE '% - Luxury%'
              AND name NOT LIKE 'Hidden %'
              AND name NOT LIKE '% Highlights%'
              AND name NOT LIKE '% Food Tour%'
              AND name NOT LIKE '% Weekend%'
              AND name NOT LIKE '% Photography%'
        """
        params = []
        if style:
            query += " AND travel_style = %s"
            params.append(style)
        if budget > 0:
            query += " AND avg_daily_budget_usd <= %s"
            params.append(budget)
        query += " ORDER BY name LIMIT 50"
        cursor.execute(query, params)
        destinations = cursor.fetchall()
        cursor.close()
        db.close()
        return jsonify({"destinations": destinations})
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/stats", methods=["GET"])
def stats():
    try:
        db = get_db()
        cursor = db.cursor(dictionary=True)
        cursor.execute("SELECT COUNT(*) as total FROM destinations")
        total_dest = cursor.fetchone()["total"]
        cursor.execute("SELECT COUNT(*) as total FROM trips")
        total_trips = cursor.fetchone()["total"]
        cursor.execute("SELECT destination, COUNT(*) as cnt FROM trips GROUP BY destination ORDER BY cnt DESC LIMIT 5")
        popular = cursor.fetchall()
        cursor.close()
        db.close()
        return jsonify({
            "total_destinations": total_dest,
            "total_trips": total_trips,
            "popular_destinations": popular
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500


if __name__ == "__main__":
    app.run(debug=True, port=5000)
