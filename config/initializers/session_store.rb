# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key    => '_week_01_session',
  :secret => 'c55d14e706a6590fe25b944e0dcb276a80b4fd664ba4de70458d8742dfca8cd7ae5667d1b215c3cbee70e8ea1ff7fd152da40e1c6ea0ac2a43b58fd1e4a5c930'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
