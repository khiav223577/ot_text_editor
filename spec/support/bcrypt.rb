# frozen_string_literal: true

# The default cost factor used by bcrypt-ruby is 12, which is fine for session-based authentication.
# Use lower cost factor in test case for better performance
BCrypt::Engine.cost = 3
