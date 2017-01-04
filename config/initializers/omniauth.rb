Rails.application.config.middleware.use OmniAuth::Builder do
  provider :weibo, '4007340133', 'd38e58e1e262323bd737c78b7aba1656',
                    token_params: {redirect_uri: "https://course-select2-kzncu.c9users.io" }
end