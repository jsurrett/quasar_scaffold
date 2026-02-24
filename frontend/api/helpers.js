// Default helpers — override in your host app via the quasar-scaffold-host alias.
// See README for instructions on setting VITE_API_BASE_URL.

export const tenant = window.location.host.split('.')[0]

export const apiBaseUrl =
  import.meta.env.VITE_API_BASE_URL ||
  (import.meta.env.DEV ? 'http://localhost:3000/v1' : '/v1')
