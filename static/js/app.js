// ── Tab Navigation ──
function showTab(name) {
  document.querySelectorAll(".tab").forEach(t => t.classList.remove("active"));
  document.querySelectorAll(".nav-link").forEach(l => l.classList.remove("active"));
  document.getElementById("tab-" + name).classList.add("active");
  event.target.classList.add("active");

  if (name === "explore") loadDestinations();
  if (name === "history") loadPastTrips();
}

// ── Load Stats on page load ──
async function loadStats() {
  try {
    const res = await fetch("/stats");
    const data = await res.json();
    if (data.total_destinations) {
      document.getElementById("statDest").textContent = data.total_destinations.toLocaleString() + "+";
    }
    if (data.total_trips !== undefined) {
      document.getElementById("statTrips").textContent = data.total_trips.toLocaleString();
    }
  } catch (e) {
    console.log("Stats load failed:", e);
  }
}

// ── Generate Itinerary ──
async function generateItinerary() {
  const destination = document.getElementById("destination").value.trim();
  if (!destination) {
    alert("Please enter a destination!");
    return;
  }

  const btn = document.getElementById("generateBtn");
  btn.disabled = true;
  btn.innerHTML = '<span class="spinner"></span> Generating your trip...';

  const payload = {
    user_name:     document.getElementById("userName").value.trim() || "Traveler",
    destination,
    duration:      document.getElementById("duration").value,
    budget:        document.getElementById("budget").value,
    travel_style:  document.getElementById("travelStyle").value,
    num_travelers: document.getElementById("numTravelers").value,
    preferences:   document.getElementById("preferences").value.trim()
  };

  try {
    const res  = await fetch("/generate", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload)
    });
    const data = await res.json();

    if (data.error) {
      alert("Error: " + data.error);
      return;
    }

    // Render itinerary
    document.getElementById("resultTitle").textContent =
      `✈ ${data.destination} — ${data.duration}-Day Itinerary`;

    const content = document.getElementById("itineraryContent");
    content.innerHTML = formatItinerary(data.itinerary);

    document.getElementById("result").classList.remove("hidden");
    document.getElementById("result").scrollIntoView({ behavior: "smooth", block: "start" });

    // Refresh stats
    loadStats();

  } catch (e) {
    alert("Something went wrong. Is the Flask server running?");
    console.error(e);
  } finally {
    btn.disabled = false;
    btn.innerHTML = "✨ Generate Itinerary";
  }
}

// ── Format plain text itinerary into styled HTML ──
function formatItinerary(text) {
  return text
    .replace(/\*\*(.*?)\*\*/g, "<strong>$1</strong>")
    .replace(/^(Day \d+.*)/gim, '<h3 style="color:var(--accent);margin:20px 0 8px;font-family:var(--font-head);font-size:1.1rem;">$1</h3>')
    .replace(/^(Morning:|Afternoon:|Evening:|🌅|🌞|🌙|Packing|Tips?:|Budget|Note:)/gim,
      '<span style="color:var(--accent2);font-weight:600;">$1</span>')
    .replace(/\n/g, "<br/>");
}

// ── Copy itinerary to clipboard ──
function copyItinerary() {
  const text = document.getElementById("itineraryContent").innerText;
  navigator.clipboard.writeText(text).then(() => {
    const btn = event.target;
    btn.textContent = "✅ Copied!";
    setTimeout(() => btn.textContent = "📋 Copy", 2000);
  });
}

// ── Load Destinations ──
async function loadDestinations() {
  const style  = document.getElementById("filterStyle").value;
  const budget = document.getElementById("filterBudget").value;

  let url = "/destinations?";
  if (style)  url += `style=${encodeURIComponent(style)}&`;
  if (budget) url += `budget=${budget}`;

  const grid = document.getElementById("destinationGrid");
  grid.innerHTML = '<p class="empty-state">Loading destinations...</p>';

  try {
    const res  = await fetch(url);
    const data = await res.json();

    if (!data.destinations || data.destinations.length === 0) {
      grid.innerHTML = '<p class="empty-state">No destinations found. Try different filters.</p>';
      return;
    }

    grid.innerHTML = data.destinations.map(d => `
      <div class="dest-card" onclick="quickPlan('${d.name}', '${d.travel_style}')">
        <div class="dest-name">${d.name}</div>
        <div class="dest-country">📍 ${d.country} · ${d.continent}</div>
        <div class="dest-tags">
          <span class="dest-tag">${d.travel_style}</span>
          <span class="dest-tag">${d.best_season}</span>
        </div>
        <div class="dest-budget">~$${parseFloat(d.avg_daily_budget_usd).toFixed(0)}/day</div>
        <div style="font-size:0.78rem;color:var(--muted);margin-top:8px;line-height:1.4;">${d.description ? d.description.substring(0, 80) + "..." : ""}</div>
      </div>
    `).join("");
  } catch (e) {
    grid.innerHTML = '<p class="empty-state">Failed to load. Is the server running?</p>';
  }
}

// ── Quick plan from destination card ──
function quickPlan(destination, style) {
  document.getElementById("destination").value = destination;
  document.getElementById("travelStyle").value = style;
  showTab("planner");
  // Trigger nav link active state manually
  document.querySelectorAll(".nav-link").forEach(l => l.classList.remove("active"));
  document.querySelectorAll(".nav-link")[0].classList.add("active");
  document.getElementById("generateBtn").scrollIntoView({ behavior: "smooth" });
}

// ── Load Past Trips ──
async function loadPastTrips() {
  const list = document.getElementById("tripsList");
  list.innerHTML = '<p class="empty-state">Loading your trips...</p>';

  try {
    const res  = await fetch("/past-trips");
    const data = await res.json();

    if (!data.trips || data.trips.length === 0) {
      list.innerHTML = '<p class="empty-state">No trips yet. Plan your first trip! ✈</p>';
      return;
    }

    list.innerHTML = data.trips.map(t => `
      <div class="trip-item" onclick="viewTrip(${t.id})">
        <div class="trip-info">
          <h3>✈ ${t.destination}</h3>
          <div class="trip-meta">
            👤 ${t.user_name} &nbsp;·&nbsp;
            📅 ${t.duration_days} days &nbsp;·&nbsp;
            💰 ₹${parseFloat(t.budget).toLocaleString()} &nbsp;·&nbsp;
            🗓 ${t.created_at}
          </div>
        </div>
        <span class="trip-badge">${t.travel_style}</span>
      </div>
    `).join("");
  } catch (e) {
    list.innerHTML = '<p class="empty-state">Failed to load trips.</p>';
  }
}

// ── View a single trip ──
async function viewTrip(id) {
  const modal = document.getElementById("tripModal");
  const content = document.getElementById("modalContent");
  content.innerHTML = '<p class="empty-state">Loading...</p>';
  modal.classList.remove("hidden");

  try {
    const res  = await fetch(`/trip/${id}`);
    const data = await res.json();

    if (data.error) {
      content.innerHTML = `<p class="empty-state">${data.error}</p>`;
      return;
    }

    content.innerHTML = `
      <h2 style="font-family:var(--font-head);font-size:1.4rem;margin-bottom:6px;">✈ ${data.destination}</h2>
      <p style="color:var(--muted);font-size:0.82rem;margin-bottom:20px;">
        ${data.duration_days} days · ₹${parseFloat(data.budget).toLocaleString()} · ${data.travel_style} · ${data.created_at}
      </p>
      <div style="white-space:pre-wrap;font-size:0.92rem;line-height:1.8;">
        ${formatItinerary(data.itinerary)}
      </div>
    `;
  } catch (e) {
    content.innerHTML = '<p class="empty-state">Failed to load trip details.</p>';
  }
}

function closeModal() {
  document.getElementById("tripModal").classList.add("hidden");
}

// Close modal on backdrop click
document.addEventListener("click", function(e) {
  const modal = document.getElementById("tripModal");
  if (e.target === modal) closeModal();
});

// ── Init ──
window.addEventListener("DOMContentLoaded", loadStats);
