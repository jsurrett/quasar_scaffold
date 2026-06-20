# QuasarScaffold

QuasarScaffold is a full-stack scaffold for Rails API + Quasar/Vue 3 applications.

It provides:
- Dynamic Rails API controllers and response objects for configured resources
- Schema-driven form metadata from ActiveRecord models
- Reusable Quasar/Vue components and Pinia store helpers for CRUD tables/forms

## Requirements

- Ruby `>= 3.2`
- Rails `>= 7.1`
- A Rails API app using CanCanCan-style abilities (`current_ability`)
- A Quasar 2 + Vue 3 frontend (Vite)

## Install (Rails)

Add the gem to your Rails app:

```ruby
# Gemfile
gem 'quasar_scaffold'
```

Then install:

```bash
bundle install
bundle exec rails generate quasar_scaffold:install
```

This generator creates:
- `config/initializers/quasar_scaffold.rb`

## Configure (Rails)

Edit `config/initializers/quasar_scaffold.rb`.

Minimum required configuration:

```ruby
QuasarScaffold.configure do |config|
  config.api_version_module = 'V1'
  config.resource_modules = %w[Students Employees]

  config.jwt_header_key = 'token'
  config.jwt_decoder = ->(raw_token) {
    JWT.decode(raw_token, ENV.fetch('JWT_SECRET'), true, algorithm: 'HS256')[0]
  }
  config.current_user_resolver = ->(data) {
    User.find_by(auth_token: data['auth_token'])
  }
end
```

### Required API base controller

`QuasarScaffold` dynamically generates resource controllers inheriting from your API module base model controller.

Example:

```ruby
# app/controllers/v1/base_model_controller.rb
module V1
  class BaseModelController < ::BaseModelController
  end
end
```

### Routes

Inside your API namespace in `config/routes.rb`:

```ruby
namespace :v1 do
  quasar_scaffold_resources
end
```

This draws standard CRUD + collection routes (`batch_update`, `datatable_options`, `search`, `import`) for each configured module.

## Frontend integration (Quasar/Vite)

The gem ships UI modules under its `frontend/` directory. In your host Quasar app, add aliases so imports resolve:

```js
// quasar.config.js
import { execSync } from 'child_process'
import path from 'path'

const gemFrontendPath = execSync(
  "bundle exec ruby -e \"require 'bundler/setup'; print File.join(Gem.loaded_specs['quasar_scaffold'].gem_dir, 'frontend')\"",
  { cwd: path.resolve(__dirname, '..') }
).toString().trim()

export default {
  build: {
    extendViteConf (viteConf) {
      viteConf.resolve = viteConf.resolve || {}
      viteConf.resolve.alias = {
        ...(viteConf.resolve.alias || {}),
        'quasar-scaffold': gemFrontendPath,
        'quasar-scaffold-host': path.resolve(__dirname, 'src')
      }
    }
  }
}
```

### Frontend dependencies

Install peer dependencies in your host frontend app (if missing):

- `axios`
- `blitzar`
- `file-saver`
- `pinia`
- `quasar`
- `vue`
- `vue-csv-import`
- `vue-i18n`
- `vue-router`

### Required host stubs

Because `quasar-scaffold-host` points at your frontend `src/`, create these files in your host app if they do not exist:

- `src/stores/customResourceActions.js`
- `src/stores/customResourceGetters.js`
- `src/stores/resourceStores.js`
- `src/api/dataTables.js`
- `src/boot/i18n.js`
- `src/utils/authorizer.js`
- `src/resourceHelpers/actions.js`
- `src/resourceHelpers/memberActions.js`
- `src/resourceHelpers/dataTableNeededIdNameMappings.js`

At minimum, your custom action/getter stubs can export empty objects.

### API base URL

By default, frontend helpers use:
- `http://localhost:3000/v1` in development
- `/v1` in production

Override with:

```bash
VITE_API_BASE_URL=https://your-api.example.com/v1
```

## Basic usage example

```vue
<script setup>
import ResourceDataTable from 'quasar-scaffold/components/ResourceDataTable/Index.vue'
</script>

<template>
  <ResourceDataTable resourceName="students" />
</template>
```

Ensure your corresponding Pinia store is registered in `src/stores/resourceStores.js`.

## Notes

- Resource modules should be CamelCase strings (e.g. `Students`) in `config.resource_modules`.
- Authentication depends on `jwt_decoder` + `current_user_resolver`.
- Dynamic classes are created in Rails `to_prepare`, so changes are reload-friendly in development.

## License

MIT
