# Comprehensive fitness workout database
puts "🏋️  Seeding workout database..."

# Clear existing workouts in development
if Rails.env.development?
  puts "Clearing existing workouts..."
  Workout.destroy_all
end

# Workout data array
workouts_data = [
  # Chest workouts
  { name: "Push-ups", body_part: "chest", difficulty: "beginner", duration: 10, equipment_required: "none", instructions: "Classic push-up movement focusing on chest, shoulders, and triceps." },
  { name: "Incline Push-ups", body_part: "chest", difficulty: "beginner", duration: 12, equipment_required: "bench", instructions: "Easier push-up variation with hands elevated." },
  { name: "Diamond Push-ups", body_part: "chest", difficulty: "intermediate", duration: 15, equipment_required: "none", instructions: "Hands in diamond shape for tricep focus." },
  { name: "Dumbbell Bench Press", body_part: "chest", difficulty: "intermediate", duration: 25, equipment_required: "dumbbells", instructions: "Press dumbbells from chest to full extension." },
  { name: "Dumbbell Flyes", body_part: "chest", difficulty: "intermediate", duration: 20, equipment_required: "dumbbells", instructions: "Wide arm movement for chest isolation." },
  { name: "Chest Dips", body_part: "chest", difficulty: "advanced", duration: 18, equipment_required: "none", instructions: "Lower body between parallel bars or chairs." },
  
  # Back workouts
  { name: "Pull-ups", body_part: "back", difficulty: "intermediate", duration: 15, equipment_required: "pull_up_bar", instructions: "Pull body up until chin clears bar." },
  { name: "Assisted Pull-ups", body_part: "back", difficulty: "beginner", duration: 12, equipment_required: "resistance_bands", instructions: "Use band assistance for proper form." },
  { name: "Bent-over Rows", body_part: "back", difficulty: "intermediate", duration: 20, equipment_required: "dumbbells", instructions: "Pull weights to lower ribs, squeeze shoulder blades." },
  { name: "Superman", body_part: "back", difficulty: "beginner", duration: 10, equipment_required: "yoga_mat", instructions: "Lie face down, lift chest and legs simultaneously." },
  { name: "Single-arm Rows", body_part: "back", difficulty: "intermediate", duration: 18, equipment_required: "dumbbells", instructions: "Support on bench, row dumbbell to hip." },
  
  # Leg workouts
  { name: "Bodyweight Squats", body_part: "legs", difficulty: "beginner", duration: 12, equipment_required: "none", instructions: "Squat down keeping chest up, drive through heels." },
  { name: "Lunges", body_part: "legs", difficulty: "beginner", duration: 15, equipment_required: "none", instructions: "Step forward into lunge, alternate legs." },
  { name: "Jump Squats", body_part: "legs", difficulty: "intermediate", duration: 10, equipment_required: "none", instructions: "Explosive squat with jump, land softly." },
  { name: "Goblet Squats", body_part: "legs", difficulty: "intermediate", duration: 18, equipment_required: "dumbbells", instructions: "Hold weight at chest, perform deep squats." },
  { name: "Bulgarian Split Squats", body_part: "legs", difficulty: "intermediate", duration: 20, equipment_required: "bench", instructions: "Rear foot elevated, lunge with front leg." },
  { name: "Walking Lunges", body_part: "legs", difficulty: "intermediate", duration: 15, equipment_required: "none", instructions: "Continuous forward lunges." },
  { name: "Calf Raises", body_part: "legs", difficulty: "beginner", duration: 8, equipment_required: "none", instructions: "Rise up on toes, hold, lower with control." },
  
  # Core workouts
  { name: "Plank", body_part: "core", difficulty: "beginner", duration: 5, equipment_required: "yoga_mat", instructions: "Hold straight line from head to heels." },
  { name: "Side Plank", body_part: "core", difficulty: "intermediate", duration: 8, equipment_required: "yoga_mat", instructions: "Side position, hold straight line." },
  { name: "Bicycle Crunches", body_part: "core", difficulty: "beginner", duration: 10, equipment_required: "yoga_mat", instructions: "Alternate elbow to opposite knee." },
  { name: "Mountain Climbers", body_part: "core", difficulty: "intermediate", duration: 12, equipment_required: "none", instructions: "Plank position, alternate knee to chest." },
  { name: "Russian Twists", body_part: "core", difficulty: "intermediate", duration: 12, equipment_required: "none", instructions: "Seated, rotate torso side to side." },
  { name: "Dead Bug", body_part: "core", difficulty: "beginner", duration: 10, equipment_required: "yoga_mat", instructions: "Opposite arm/leg extensions from back." },
  
  # Arms workouts
  { name: "Tricep Dips", body_part: "arms", difficulty: "beginner", duration: 10, equipment_required: "bench", instructions: "Lower body by bending elbows, push back up." },
  { name: "Bicep Curls", body_part: "arms", difficulty: "beginner", duration: 15, equipment_required: "dumbbells", instructions: "Curl weights to shoulders, lower controlled." },
  { name: "Overhead Press", body_part: "arms", difficulty: "intermediate", duration: 18, equipment_required: "dumbbells", instructions: "Press dumbbells overhead from shoulders." },
  { name: "Tricep Extensions", body_part: "arms", difficulty: "intermediate", duration: 15, equipment_required: "dumbbells", instructions: "Lower weight behind head, extend back up." },
  { name: "Hammer Curls", body_part: "arms", difficulty: "beginner", duration: 12, equipment_required: "dumbbells", instructions: "Neutral grip curls, thumbs up." },
  { name: "Close-grip Push-ups", body_part: "arms", difficulty: "intermediate", duration: 12, equipment_required: "none", instructions: "Hands close together for tricep focus." },
  
  # Shoulders workouts
  { name: "Lateral Raises", body_part: "shoulders", difficulty: "beginner", duration: 12, equipment_required: "dumbbells", instructions: "Raise arms out to sides to shoulder height." },
  { name: "Front Raises", body_part: "shoulders", difficulty: "beginner", duration: 10, equipment_required: "dumbbells", instructions: "Raise arms forward to shoulder height." },
  { name: "Pike Push-ups", body_part: "shoulders", difficulty: "intermediate", duration: 15, equipment_required: "none", instructions: "Downward dog position, lower head down." },
  { name: "Reverse Flyes", body_part: "shoulders", difficulty: "intermediate", duration: 15, equipment_required: "dumbbells", instructions: "Bend forward, raise arms squeezing shoulder blades." },
  
  # Cardio workouts
  { name: "Jumping Jacks", body_part: "cardio", difficulty: "beginner", duration: 10, equipment_required: "none", instructions: "Jump feet apart while raising arms overhead." },
  { name: "High Knees", body_part: "cardio", difficulty: "beginner", duration: 8, equipment_required: "none", instructions: "Run in place bringing knees to waist level." },
  { name: "Burpees", body_part: "cardio", difficulty: "intermediate", duration: 15, equipment_required: "none", instructions: "Squat, jump back, push-up, jump forward, jump up." },
  { name: "Jump Rope", body_part: "cardio", difficulty: "beginner", duration: 15, equipment_required: "none", instructions: "Jump rope or simulate motion." },
  { name: "Sprint Intervals", body_part: "cardio", difficulty: "advanced", duration: 20, equipment_required: "none", instructions: "Alternate high-intensity sprints and recovery." },
  
  # Full body workouts
  { name: "Squat to Press", body_part: "full_body", difficulty: "beginner", duration: 15, equipment_required: "dumbbells", instructions: "Squat with weights, press overhead as you stand." },
  { name: "Burpee to Press", body_part: "full_body", difficulty: "intermediate", duration: 18, equipment_required: "dumbbells", instructions: "Burpee holding weights, add overhead press." },
  { name: "Deadlift to Row", body_part: "full_body", difficulty: "intermediate", duration: 20, equipment_required: "dumbbells", instructions: "Deadlift then bent-over row before standing." },
  { name: "Bear Crawl", body_part: "full_body", difficulty: "intermediate", duration: 12, equipment_required: "none", instructions: "Crawl on hands and feet, knees off ground." },
  
  # Glutes workouts
  { name: "Glute Bridges", body_part: "glutes", difficulty: "beginner", duration: 12, equipment_required: "yoga_mat", instructions: "Lift hips up squeezing glutes." },
  { name: "Single-leg Glute Bridges", body_part: "glutes", difficulty: "intermediate", duration: 15, equipment_required: "yoga_mat", instructions: "One leg extended, lift hips with single leg." },
  { name: "Clamshells", body_part: "glutes", difficulty: "beginner", duration: 10, equipment_required: "resistance_bands", instructions: "Side-lying, lift top knee keeping feet together." },
  { name: "Hip Thrusts", body_part: "glutes", difficulty: "intermediate", duration: 18, equipment_required: "bench", instructions: "Shoulders on bench, thrust hips up." },
  { name: "Fire Hydrants", body_part: "glutes", difficulty: "beginner", duration: 10, equipment_required: "yoga_mat", instructions: "On hands and knees, lift leg out to side." }
]

# Create workouts
created_count = 0
workouts_data.each do |workout_data|
  Workout.create!(workout_data)
  created_count += 1
  print "." if created_count % 10 == 0
end

puts "\n✅ Created #{created_count} workouts!"

# Create sample users with profiles
sample_users = [
  { email: "admin@test.com", admin: true },
  { email: "john@test.com", admin: false },
  { email: "sarah@test.com", admin: false },
  { email: "mike@test.com", admin: false }
]

sample_users.each do |user_data|
  unless User.exists?(email: user_data[:email])
    user = User.create!(
      email: user_data[:email],
      password: "password123",
      password_confirmation: "password123",
      admin: user_data[:admin]
    )
    
    # Create profile for non-admin users
    unless user_data[:admin]
      user.create_profile!(
        age: rand(18..65),
        weight: rand(50.0..120.0).round(1),
        gender: ["male", "female"].sample,
        goals: "Get stronger and build muscle",
        muscle_focus: ["chest", "back", "legs", "arms", "core"].sample,
        intensity: ["low", "medium", "high"].sample
      )
    end
    
    puts "👤 Created #{user_data[:admin] ? 'admin' : 'user'}: #{user_data[:email]}"
  end
end

puts "\n🎉 Database seeded successfully!"
puts "📊 Total workouts: #{Workout.count}"
puts "👥 Total users: #{User.count}"
puts "📝 Total profiles: #{Profile.count}"

puts "\n📈 Workout Distribution:"
Workout.group(:body_part).count.each do |body_part, count|
  puts "  #{body_part.capitalize}: #{count} workouts"
end

puts "\n🔑 Login credentials:"
puts "  Admin: admin@test.com / password123"
puts "  Users: john@test.com, sarah@test.com, mike@test.com / password123"
