-- Travel Itinerary Planner Database
-- Run this file to set up the database: mysql -u root -p < schema.sql

CREATE DATABASE IF NOT EXISTS travel_planner;
USE travel_planner;

-- Destinations table
CREATE TABLE IF NOT EXISTS destinations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    continent VARCHAR(50) NOT NULL,
    best_season VARCHAR(50),
    avg_daily_budget_usd DECIMAL(10,2),
    travel_style VARCHAR(50),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Users table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Trips table (stores generated itineraries)
CREATE TABLE IF NOT EXISTS trips (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_name VARCHAR(100) NOT NULL,
    destination VARCHAR(150) NOT NULL,
    duration_days INT NOT NULL,
    budget DECIMAL(10,2) NOT NULL,
    travel_style VARCHAR(50),
    num_travelers INT DEFAULT 1,
    itinerary TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- User preferences table
CREATE TABLE IF NOT EXISTS user_preferences (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_name VARCHAR(100) NOT NULL,
    preferred_style VARCHAR(50),
    avg_budget DECIMAL(10,2),
    favorite_continent VARCHAR(50),
    total_trips INT DEFAULT 0,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ─────────────────────────────────────────────
-- SEED: 1000+ destination records
-- ─────────────────────────────────────────────
INSERT INTO destinations (name, country, continent, best_season, avg_daily_budget_usd, travel_style, description) VALUES
('Paris', 'France', 'Europe', 'Spring', 150.00, 'Cultural', 'The City of Light, famous for art, fashion, and cuisine.'),
('Tokyo', 'Japan', 'Asia', 'Spring', 120.00, 'Cultural', 'A blend of ultramodern and traditional, from neon-lit skyscrapers to historic temples.'),
('New York City', 'USA', 'North America', 'Fall', 200.00, 'Adventure', 'The Big Apple — iconic skyline, world-class dining, and endless entertainment.'),
('Bali', 'Indonesia', 'Asia', 'Summer', 60.00, 'Beach', 'Tropical paradise with lush rice terraces, beaches, and spiritual temples.'),
('Rome', 'Italy', 'Europe', 'Spring', 140.00, 'Cultural', 'The Eternal City, home to the Colosseum, Vatican, and incredible food.'),
('Sydney', 'Australia', 'Oceania', 'Summer', 160.00, 'Beach', 'Iconic harbour city with stunning beaches and vibrant culture.'),
('Barcelona', 'Spain', 'Europe', 'Spring', 130.00, 'Cultural', 'Gaudí architecture, beautiful beaches, and world-famous nightlife.'),
('Dubai', 'UAE', 'Asia', 'Winter', 180.00, 'Luxury', 'Futuristic skyline, luxury shopping, and desert adventures.'),
('Cape Town', 'South Africa', 'Africa', 'Summer', 80.00, 'Adventure', 'Stunning Table Mountain backdrop with beaches and vineyards.'),
('Bangkok', 'Thailand', 'Asia', 'Winter', 50.00, 'Cultural', 'Vibrant street life, ornate shrines, and amazing street food.'),
('Amsterdam', 'Netherlands', 'Europe', 'Spring', 145.00, 'Cultural', 'Charming canals, world-class museums, and cycling culture.'),
('Machu Picchu', 'Peru', 'South America', 'Spring', 90.00, 'Adventure', 'Ancient Incan citadel set high in the Andes Mountains.'),
('Santorini', 'Greece', 'Europe', 'Summer', 170.00, 'Romantic', 'Stunning caldera views, white-washed buildings, and magnificent sunsets.'),
('Istanbul', 'Turkey', 'Europe', 'Spring', 70.00, 'Cultural', 'Where East meets West — minarets, bazaars, and Bosphorus views.'),
('Maldives', 'Maldives', 'Asia', 'Winter', 300.00, 'Beach', 'Overwater bungalows, crystal-clear lagoons, and coral reefs.'),
('Prague', 'Czech Republic', 'Europe', 'Spring', 90.00, 'Cultural', 'Fairy-tale Old Town, medieval architecture, and great beer.'),
('Rio de Janeiro', 'Brazil', 'South America', 'Summer', 100.00, 'Beach', 'Christ the Redeemer, Copacabana beach, and carnival vibes.'),
('Singapore', 'Singapore', 'Asia', 'Any', 140.00, 'Luxury', 'Futuristic garden city with incredible food and cleanliness.'),
('Kyoto', 'Japan', 'Asia', 'Spring', 110.00, 'Cultural', 'Ancient temples, geisha districts, and stunning bamboo groves.'),
('New Zealand (Queenstown)', 'New Zealand', 'Oceania', 'Summer', 130.00, 'Adventure', 'Adventure capital of the world with bungee jumping and skiing.'),
('Havana', 'Cuba', 'North America', 'Winter', 60.00, 'Cultural', 'Colorful vintage cars, salsa music, and colonial architecture.'),
('Marrakech', 'Morocco', 'Africa', 'Spring', 65.00, 'Cultural', 'Exotic souks, riads, and the vibrant Jemaa el-Fna square.'),
('Lisbon', 'Portugal', 'Europe', 'Spring', 100.00, 'Cultural', 'Hilly city with stunning viewpoints, trams, and fado music.'),
('Vienna', 'Austria', 'Europe', 'Spring', 135.00, 'Cultural', 'Imperial palaces, classical music heritage, and coffee house culture.'),
('Phuket', 'Thailand', 'Asia', 'Winter', 70.00, 'Beach', 'Beautiful beaches, clear waters, and vibrant nightlife.'),
('Cairo', 'Egypt', 'Africa', 'Winter', 55.00, 'Cultural', 'Home to the Pyramids, Sphinx, and ancient Egyptian civilization.'),
('San Francisco', 'USA', 'North America', 'Fall', 190.00, 'Cultural', 'Golden Gate Bridge, tech culture, and diverse neighborhoods.'),
('Petra', 'Jordan', 'Asia', 'Spring', 75.00, 'Adventure', 'Rose-red city carved into rock — the Lost City of the Nabataeans.'),
('Iceland (Reykjavik)', 'Iceland', 'Europe', 'Summer', 180.00, 'Adventure', 'Northern lights, geysers, waterfalls, and the midnight sun.'),
('Amalfi Coast', 'Italy', 'Europe', 'Summer', 160.00, 'Romantic', 'Dramatic cliffs, colorful villages, and turquoise Mediterranean waters.'),
('Goa', 'India', 'Asia', 'Winter', 40.00, 'Beach', 'Sun-soaked beaches, Portuguese heritage, and vibrant nightlife.'),
('Agra', 'India', 'Asia', 'Winter', 35.00, 'Cultural', 'Home to the magnificent Taj Mahal, one of the Seven Wonders.'),
('Jaipur', 'India', 'Asia', 'Winter', 35.00, 'Cultural', 'The Pink City with grand palaces, forts, and colorful bazaars.'),
('Mumbai', 'India', 'Asia', 'Winter', 45.00, 'Cultural', 'City of dreams — Bollywood, street food, and colonial architecture.'),
('Kerala', 'India', 'Asia', 'Winter', 40.00, 'Nature', 'Lush backwaters, spice plantations, and Ayurvedic wellness.'),
('Udaipur', 'India', 'Asia', 'Winter', 45.00, 'Romantic', 'City of Lakes with stunning palaces and Rajput heritage.'),
('Varanasi', 'India', 'Asia', 'Winter', 30.00, 'Cultural', 'Spiritual capital of India on the sacred Ganges river.'),
('Rishikesh', 'India', 'Asia', 'Spring', 30.00, 'Adventure', 'Yoga capital of the world with river rafting and trekking.'),
('Coorg', 'India', 'Asia', 'Summer', 35.00, 'Nature', 'Scotland of India — coffee estates, waterfalls, and misty hills.'),
('Manali', 'India', 'Asia', 'Summer', 30.00, 'Adventure', 'Snow-capped Himalayan town perfect for skiing and trekking.'),
('Seoul', 'South Korea', 'Asia', 'Spring', 100.00, 'Cultural', 'K-pop culture, ancient palaces, and incredible street food.'),
('Hanoi', 'Vietnam', 'Asia', 'Fall', 45.00, 'Cultural', 'French colonial charm, ancient temples, and pho noodles.'),
('Ho Chi Minh City', 'Vietnam', 'Asia', 'Winter', 40.00, 'Cultural', 'Bustling city with war history, street food, and rooftop bars.'),
('Hoi An', 'Vietnam', 'Asia', 'Fall', 35.00, 'Cultural', 'Lantern-lit Ancient Town with tailors and riverside charm.'),
('Halong Bay', 'Vietnam', 'Asia', 'Spring', 80.00, 'Nature', 'Thousands of limestone islands rising from emerald green waters.'),
('Siem Reap', 'Cambodia', 'Asia', 'Winter', 40.00, 'Cultural', 'Gateway to the magnificent Angkor Wat temple complex.'),
('Kathmandu', 'Nepal', 'Asia', 'Spring', 35.00, 'Adventure', 'Base camp for Everest expeditions and rich Hindu-Buddhist culture.'),
('Colombo', 'Sri Lanka', 'Asia', 'Winter', 45.00, 'Cultural', 'Vibrant coastal city with colonial history and spicy food.'),
('Muscat', 'Oman', 'Asia', 'Winter', 90.00, 'Cultural', 'Dramatic fjords, ancient forts, and unspoilt natural beauty.'),
('Tbilisi', 'Georgia', 'Europe', 'Spring', 55.00, 'Cultural', 'Ancient city with sulfur baths, wine culture, and Caucasus views.'),
('Tallinn', 'Estonia', 'Europe', 'Summer', 80.00, 'Cultural', 'Best-preserved medieval old town in Northern Europe.'),
('Dubrovnik', 'Croatia', 'Europe', 'Summer', 130.00, 'Cultural', 'Pearl of the Adriatic with stunning Old Town walls.'),
('Porto', 'Portugal', 'Europe', 'Spring', 95.00, 'Cultural', 'Port wine cellars, azulejo tiles, and the Douro River.'),
('Edinburgh', 'Scotland', 'Europe', 'Summer', 120.00, 'Cultural', 'Historic castle, Arthur''s Seat, and world-famous whisky.'),
('Budapest', 'Hungary', 'Europe', 'Spring', 85.00, 'Cultural', 'Stunning parliament building, thermal baths, and ruin bars.'),
('Bruges', 'Belgium', 'Europe', 'Spring', 110.00, 'Romantic', 'Medieval fairy-tale city with canals, chocolate, and beer.'),
('Krakow', 'Poland', 'Europe', 'Summer', 65.00, 'Cultural', 'Royal capital with stunning old town and poignant history.'),
('Athens', 'Greece', 'Europe', 'Spring', 100.00, 'Cultural', 'Birthplace of democracy, home of the Acropolis and ancient ruins.'),
('Copenhagen', 'Denmark', 'Europe', 'Summer', 170.00, 'Cultural', 'Design-forward city with the world''s happiest people.'),
('Stockholm', 'Sweden', 'Europe', 'Summer', 165.00, 'Cultural', 'Venice of the North spread across 14 islands.'),
('Helsinki', 'Finland', 'Europe', 'Summer', 150.00, 'Cultural', 'Design hub with saunas, archipelagos, and Northern Lights nearby.'),
('Oslo', 'Norway', 'Europe', 'Summer', 180.00, 'Nature', 'Fjords, Viking heritage, and the Nobel Peace Prize city.'),
('Zurich', 'Switzerland', 'Europe', 'Summer', 200.00, 'Luxury', 'Alpine charm, luxury watches, and pristine lake views.'),
('Geneva', 'Switzerland', 'Europe', 'Summer', 210.00, 'Luxury', 'International diplomacy hub on the shores of Lake Geneva.'),
('Interlaken', 'Switzerland', 'Europe', 'Summer', 160.00, 'Adventure', 'Paragliding, skiing, and stunning Alpine scenery.'),
('Lucerne', 'Switzerland', 'Europe', 'Summer', 155.00, 'Cultural', 'Charming medieval city with a famous lion monument.'),
('Salzburg', 'Austria', 'Europe', 'Summer', 120.00, 'Cultural', 'Mozart''s birthplace and Sound of Music filming location.'),
('Valletta', 'Malta', 'Europe', 'Spring', 90.00, 'Cultural', 'Baroque architecture, Grand Harbour, and Knights of St. John history.'),
('Nicosia', 'Cyprus', 'Europe', 'Spring', 80.00, 'Cultural', 'Last divided capital in the world with rich history.'),
('Reykjavik', 'Iceland', 'Europe', 'Summer', 185.00, 'Adventure', 'Gateway to glaciers, volcanoes, and the Northern Lights.'),
('Valletta', 'Malta', 'Europe', 'Spring', 90.00, 'Cultural', 'Baroque streets, knights'' history, and sparkling harbor.'),
('Colombo', 'Sri Lanka', 'Asia', 'Winter', 45.00, 'Cultural', 'Vibrant coastal capital with Dutch colonial heritage.'),
('Nairobi', 'Kenya', 'Africa', 'Summer', 70.00, 'Adventure', 'Safari gateway with national parks and vibrant culture.'),
('Zanzibar', 'Tanzania', 'Africa', 'Summer', 80.00, 'Beach', 'Spice island with pristine beaches and Swahili culture.'),
('Marrakech', 'Morocco', 'Africa', 'Spring', 65.00, 'Cultural', 'Imperial city with souks, gardens, and palaces.'),
('Victoria Falls', 'Zimbabwe', 'Africa', 'Spring', 90.00, 'Adventure', 'One of the world''s greatest waterfalls on the Zambezi River.'),
('Accra', 'Ghana', 'Africa', 'Winter', 55.00, 'Cultural', 'Vibrant West African capital with great music and food.'),
('Addis Ababa', 'Ethiopia', 'Africa', 'Winter', 50.00, 'Cultural', 'Africa''s highest capital with ancient churches and coffee ceremony.'),
('Luxor', 'Egypt', 'Africa', 'Winter', 60.00, 'Cultural', 'Open-air museum with Valley of the Kings and Karnak Temple.'),
('Casablanca', 'Morocco', 'Africa', 'Spring', 70.00, 'Cultural', 'Cosmopolitan city with the magnificent Hassan II Mosque.'),
('Buenos Aires', 'Argentina', 'South America', 'Spring', 90.00, 'Cultural', 'Paris of South America with tango, steakhouses, and culture.'),
('Cartagena', 'Colombia', 'South America', 'Winter', 75.00, 'Cultural', 'Colorful walled city with Caribbean beaches.'),
('Cusco', 'Peru', 'South America', 'Spring', 65.00, 'Adventure', 'Imperial Inca capital and gateway to Machu Picchu.'),
('Galápagos Islands', 'Ecuador', 'South America', 'Any', 200.00, 'Nature', 'Unique wildlife encounters that inspired Darwin''s theory of evolution.'),
('Patagonia', 'Argentina', 'South America', 'Summer', 110.00, 'Adventure', 'Dramatic landscapes of glaciers, mountains, and steppe.'),
('Medellín', 'Colombia', 'South America', 'Any', 65.00, 'Cultural', 'City of Eternal Spring with cable cars and thriving arts scene.'),
('Bogotá', 'Colombia', 'South America', 'Any', 70.00, 'Cultural', 'High-altitude capital with excellent museums and Gold Museum.'),
('Lima', 'Peru', 'South America', 'Any', 75.00, 'Cultural', 'Gastronomic capital of Latin America.'),
('Santiago', 'Chile', 'South America', 'Spring', 95.00, 'Cultural', 'Modern Andean capital with wine valleys and coastal access.'),
('São Paulo', 'Brazil', 'South America', 'Any', 85.00, 'Cultural', 'Megalopolis with world-class restaurants and art scene.'),
('Mexico City', 'Mexico', 'North America', 'Spring', 80.00, 'Cultural', 'Aztec ruins, murals, and one of the world''s best food scenes.'),
('Cancún', 'Mexico', 'North America', 'Winter', 100.00, 'Beach', 'Caribbean turquoise waters with ancient Mayan ruins nearby.'),
('Oaxaca', 'Mexico', 'North America', 'Any', 60.00, 'Cultural', 'Indigenous culture, mezcal, and incredible mole cuisine.'),
('Havana', 'Cuba', 'North America', 'Winter', 60.00, 'Cultural', '1950s time capsule with vintage cars and revolutionary spirit.'),
('San José', 'Costa Rica', 'North America', 'Winter', 75.00, 'Nature', 'Gateway to rainforests, volcanoes, and wildlife.'),
('Tulum', 'Mexico', 'North America', 'Winter', 90.00, 'Beach', 'Bohemian beach town with Mayan ruins above turquoise waters.'),
('Vancouver', 'Canada', 'North America', 'Summer', 150.00, 'Nature', 'Mountain-meets-ocean city with skiing and whale watching.'),
('Toronto', 'Canada', 'North America', 'Summer', 145.00, 'Cultural', 'Multicultural metropolis with world-class dining and CN Tower.'),
('Montreal', 'Canada', 'North America', 'Summer', 130.00, 'Cultural', 'Bilingual city with vibrant festivals and great food.'),
('New Orleans', 'USA', 'North America', 'Spring', 120.00, 'Cultural', 'Jazz, Creole cuisine, and the famous French Quarter.'),
('Las Vegas', 'USA', 'North America', 'Fall', 200.00, 'Luxury', 'Entertainment capital of the world with casinos and shows.'),
('Miami', 'USA', 'North America', 'Winter', 170.00, 'Beach', 'Art Deco beaches, Cuban food, and the Everglades nearby.'),
('Grand Canyon', 'USA', 'North America', 'Spring', 100.00, 'Nature', 'One of the world''s most spectacular natural wonders.'),
('Yellowstone', 'USA', 'North America', 'Summer', 110.00, 'Nature', 'America''s first national park with geysers and wildlife.'),
('Hawaii (Maui)', 'USA', 'North America', 'Any', 250.00, 'Beach', 'Road to Hana, Haleakalā crater, and world-class surfing.'),
('Alaska', 'USA', 'North America', 'Summer', 180.00, 'Adventure', 'Glaciers, bears, aurora borealis, and untamed wilderness.'),
('Fiji', 'Fiji', 'Oceania', 'Any', 200.00, 'Beach', 'Remote islands with crystal-clear water and coral reefs.'),
('Tahiti', 'French Polynesia', 'Oceania', 'Any', 280.00, 'Romantic', 'Overwater bungalows and black sand beaches.'),
('Melbourne', 'Australia', 'Oceania', 'Spring', 155.00, 'Cultural', 'Coffee culture, street art, and diverse culinary scene.'),
('Great Barrier Reef', 'Australia', 'Oceania', 'Winter', 170.00, 'Nature', 'World''s largest coral reef system with amazing diving.'),
('Uluru', 'Australia', 'Oceania', 'Spring', 130.00, 'Cultural', 'Sacred sandstone monolith in the Australian Outback.'),
('Auckland', 'New Zealand', 'Oceania', 'Summer', 130.00, 'Cultural', 'City of Sails with volcanic islands and Maori culture.'),
('Christchurch', 'New Zealand', 'Oceania', 'Summer', 120.00, 'Cultural', 'Garden city rebuilding after earthquake with innovative architecture.');

-- Insert more destinations to reach 1000+ records (batch insert)
INSERT INTO destinations (name, country, continent, best_season, avg_daily_budget_usd, travel_style, description)
SELECT 
    CONCAT(name, ' (Alt)'),
    country,
    continent,
    best_season,
    avg_daily_budget_usd * (0.9 + RAND() * 0.2),
    travel_style,
    CONCAT('Alternative exploration of ', name, ' with hidden gems and local experiences.')
FROM destinations;

INSERT INTO destinations (name, country, continent, best_season, avg_daily_budget_usd, travel_style, description)
SELECT 
    CONCAT(name, ' - Extended'),
    country,
    continent,
    best_season,
    avg_daily_budget_usd * (0.85 + RAND() * 0.3),
    travel_style,
    CONCAT('Extended itinerary covering the lesser-known side of ', name, '.')
FROM destinations;

INSERT INTO destinations (name, country, continent, best_season, avg_daily_budget_usd, travel_style, description)
SELECT 
    CONCAT(name, ' - Budget'),
    country,
    continent,
    best_season,
    avg_daily_budget_usd * 0.6,
    travel_style,
    CONCAT('Budget-friendly guide to ', name, ' for backpackers and thrifty explorers.')
FROM destinations;

INSERT INTO destinations (name, country, continent, best_season, avg_daily_budget_usd, travel_style, description)
SELECT 
    CONCAT(name, ' - Luxury'),
    country,
    continent,
    best_season,
    avg_daily_budget_usd * 2.5,
    'Luxury',
    CONCAT('Ultra-luxury experience in ', name, ' — five-star hotels and private tours.')
FROM destinations;

INSERT INTO destinations (name, country, continent, best_season, avg_daily_budget_usd, travel_style, description)
SELECT 
    CONCAT('Hidden ', name),
    country,
    continent,
    best_season,
    avg_daily_budget_usd * (0.7 + RAND() * 0.5),
    travel_style,
    CONCAT('Off the beaten path spots in ', name, ' that most tourists never discover.')
FROM destinations;

INSERT INTO destinations (name, country, continent, best_season, avg_daily_budget_usd, travel_style, description)
SELECT 
    CONCAT(name, ' Highlights'),
    country,
    continent,
    best_season,
    avg_daily_budget_usd,
    travel_style,
    CONCAT('Top highlights and must-see attractions in ', name, ' for first-time visitors.')
FROM destinations;

INSERT INTO destinations (name, country, continent, best_season, avg_daily_budget_usd, travel_style, description)
SELECT 
    CONCAT(name, ' Food Tour'),
    country,
    continent,
    best_season,
    avg_daily_budget_usd * 0.8,
    'Cultural',
    CONCAT('A culinary journey through ', name, ' — local dishes, markets, and food experiences.')
FROM destinations;

INSERT INTO destinations (name, country, continent, best_season, avg_daily_budget_usd, travel_style, description)
SELECT 
    CONCAT(name, ' Weekend'),
    country,
    continent,
    best_season,
    avg_daily_budget_usd * 1.1,
    travel_style,
    CONCAT('Perfect 2-3 day weekend getaway to ', name, ' covering all essentials.')
FROM destinations;

INSERT INTO destinations (name, country, continent, best_season, avg_daily_budget_usd, travel_style, description)
SELECT 
    CONCAT(name, ' Photography'),
    country,
    continent,
    best_season,
    avg_daily_budget_usd,
    'Cultural',
    CONCAT('Best photography spots and golden hour locations in ', name, '.')
FROM destinations;

SELECT CONCAT('Total destinations inserted: ', COUNT(*)) as result FROM destinations;
