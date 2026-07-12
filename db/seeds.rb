# Create default roles
admin_role = Role.find_or_create_by!(name: "admin")
user_role = Role.find_or_create_by!(name: "user")

# Create default admin user
User.find_or_create_by!(username: "admin") do |u|
  u.first_name = "Admin"
  u.last_name = "User"
  u.email = "admin@example.com"
  u.password = "password"
  u.password_confirmation = "password"
  u.role = admin_role
end

puts "Seeded #{Role.count} roles and #{User.count} users"
