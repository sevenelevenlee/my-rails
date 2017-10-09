Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, '11839b0310d13162d8df',
           '0e281a5f8b28bbb3a9d31323666ad2f947c4cc74'
end
