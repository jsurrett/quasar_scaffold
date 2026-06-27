import gemEn from 'quasar-scaffold/i18n/en.json'
import gemEs from 'quasar-scaffold/i18n/es.json'

function deepMerge (base, override) {
  const result = { ...base }
  for (const key of Object.keys(override)) {
    if (override[key] && typeof override[key] === 'object' && !Array.isArray(override[key])) {
      result[key] = deepMerge(base[key] || {}, override[key])
    } else {
      result[key] = override[key]
    }
  }
  return result
}

export function createMessages ({ en, es }) {
  return {
    en: deepMerge(gemEn, en),
    es: deepMerge(gemEs, es),
  }
}
