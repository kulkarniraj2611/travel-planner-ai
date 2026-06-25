# WanderAI — AI-Powered Travel Itinerary Planner

A full-stack travel planner built with **Python (Flask)**, **MySQL**, and **Claude AI (Anthropic API)**.

---

## Tech Stack
- **Backend:** Python, Flask
- **Database:** MySQL (1000+ destination records)
- **AI:** Anthropic Claude API (claude-sonnet-4-6)
- **Frontend:** HTML, CSS, Vanilla JavaScript

---

## Project Structure

```
travel_planner/
├── app.py                  ← Flask backend (API routes)
├── schema.sql              ← MySQL database + 1000+ records
├── requirements.txt        ← Python dependencies
├── setup_and_run.bat       ← One-click Windows setup script
├── templates/
│   └── index.html          ← Main frontend page
└── static/
    ├── css/
    │   └── style.css       ← Styling
    └── js/
        └── app.js          ← Frontend logic
```

---

## Setup Instructions (Windows)

### Option A — Automatic (Recommended)
1. Double-click `setup_and_run.bat`
2. Follow the prompts (enter MySQL password + Anthropic API key)
3. Open `http://localhost:5000` in your browser

---

### Option B — Manual Setup

#### Step 1: Install Python packages
```bash
pip install flask mysql-connector-python anthropic
```

#### Step 2: Get your Anthropic API Key
- Go to https://console.anthropic.com
- Create an account and generate an API key
- Set it as an environment variable:
```cmd
set ANTHROPIC_API_KEY=sk-ant-your-key-here
```

#### Step 3: Set up the MySQL database
```bash
mysql -u root -p < schema.sql
```
This creates the `travel_planner` database with 1000+ destination records.

#### Step 4: Update your MySQL password in app.py
Open `app.py` and find this line near the top:
```python
"password": "your_mysql_password",
```
Replace `your_mysql_password` with your actual MySQL root password.

#### Step 5: Run the server
```bash
python app.py
```

#### Step 6: Open in browser
Go to: `http://localhost:5000`

---

## Features

### 1. Plan Trip (Main Page)
- Enter destination, duration, budget, travel style, number of travelers
- AI generates a full day-by-day itinerary
- Trip is automatically saved to the MySQL database

### 2. Explore Destinations
- Browse 1000+ destinations from the database
- Filter by travel style (Cultural, Adventure, Beach, etc.)
- Filter by budget
- Click any destination to auto-fill the planner

### 3. My Trips (History)
- View all past trips stored in MySQL
- Click any trip to see the full saved itinerary

---

## Database Tables

| Table | Purpose |
|-------|---------|
| `destinations` | 1000+ travel destinations with metadata |
| `trips` | Every itinerary generated (saved automatically) |
| `user_preferences` | Tracks user travel style & budget preferences |
| `users` | Optional user table for future auth |

---

## API Endpoints

| Method | Route | Description |
|--------|-------|-------------|
| GET | `/` | Main frontend page |
| POST | `/generate` | Generate AI itinerary + save to DB |
| GET | `/past-trips` | Fetch last 20 trips from DB |
| GET | `/trip/<id>` | Get a single trip by ID |
| GET | `/destinations` | Browse destinations (with filters) |
| GET | `/stats` | Total destinations + trips count |

---

## Common Issues

**MySQL connection error:**
- Make sure MySQL service is running: open Task Manager → Services → look for MySQL
- Double-check password in `app.py`

**Anthropic API error:**
- Make sure `ANTHROPIC_API_KEY` environment variable is set
- Run `set ANTHROPIC_API_KEY=your-key` in the same terminal before `python app.py`

**Port already in use:**
- Change `port=5000` to `port=5001` in the last line of `app.py`

---

## How to explain this project in interviews

> "I built a full-stack travel itinerary planner where users input their destination, budget, travel style, and duration. The Flask backend sends this to the Claude AI API which generates a personalized day-by-day itinerary. Every generated trip is stored in a MySQL database with 1000+ pre-seeded destination records, and users can browse past trips and explore destinations by style and budget."
