require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = "spec/support/fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.ignore_localhost = true
  config.default_cassette_options = { record: :new_episodes }

  # Removes all private data (Basic Auth, Set-Cookie headers...)
  config.before_record do |i|
    i.response.headers.delete("Set-Cookie")
    i.request.headers.delete("Authorization")

    u = URI.parse(i.request.uri)
    i.request.uri.sub!(/:\/\/.*#{Regexp.escape(u.host)}/, "://#{u.host}")
  end

  config.filter_sensitive_data("<YOUTUBE_API_KEY>") { ENV["YOUTUBE_API_KEY"] }
end
