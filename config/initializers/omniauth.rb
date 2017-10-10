#登陆失败处理
OmniAuth.config.on_failure do |env|
  [302, {'Location' => "/auth/#{env['omniauth.error.strategy'].name}/failure?message=#{env['omniauth.error.type']}"}, ["Redirecting..."]]
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, '11839b0310d13162d8df',
           '0e281a5f8b28bbb3a9d31323666ad2f947c4cc74'

  provider :identity, :fields => [:nickname, :email] #, on_failed_registration: UsersController.action(:new)
end
