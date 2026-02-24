# frozen_string_literal: true

require_relative 'lib/quasar_scaffold/version'

Gem::Specification.new do |s|
  s.name        = 'quasar_scaffold'
  s.version     = QuasarScaffold::VERSION
  s.authors     = ['Jason Surrett']
  s.email       = ['']
  s.summary     = 'Full-stack CRUD scaffold for Rails API + Quasar/Vue 3 applications'
  s.description = <<~DESC
    QuasarScaffold provides a dynamic controller/response pattern for Rails API apps
    paired with a Vue 3 + Quasar 2 + Pinia frontend. It generates controllers,
    serializers, and form schemas automatically from your ActiveRecord models.
  DESC
  s.homepage    = ''
  s.license     = 'MIT'

  s.files = Dir[
    'lib/**/*',
    'app/**/*',
    'frontend/**/*',
    'README.md',
    'LICENSE.txt'
  ]

  s.required_ruby_version = '>= 3.2'

  s.add_dependency 'rails',            '>= 7.1'
  s.add_dependency 'panko_serializer'
  s.add_dependency 'pagy',             '~> 3.5'
  s.add_dependency 'memoist'
  s.add_dependency 'cancancan'
  s.add_dependency 'jwt'
  s.add_dependency 'bcrypt',           '~> 3.1'
  s.add_dependency 'rack-cors'

  # Soft dependencies — host app provides these if needed
  # ros-apartment (multitenancy): gem checks `defined?(Apartment)` at runtime
  # paper_trail: gem checks `defined?(PaperTrail)` at runtime

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'factory_bot_rails'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rubocop-rails'
end
