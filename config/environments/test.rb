Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = ENV["CI"].present?
  config.consider_all_requests_local = true
  config.cache_store = :null_store

  # Let the API's own rescue_from handlers answer; anything else should fail the spec.
  config.action_dispatch.show_exceptions = :rescuable
  config.action_controller.allow_forgery_protection = false

  config.active_support.deprecation = :stderr
  config.action_controller.raise_on_missing_callback_actions = true
end
