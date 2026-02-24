import { defineStore } from 'pinia'
import basicTableApi from 'quasar-scaffold-host/api/dataTables'
import defaultActions from './defaultActions'
import defaultState from './defaultState'
import defaultGetters from './defaultGetters'
import customResourceGetters from 'quasar-scaffold-host/stores/customResourceGetters'
import customResourceActions from 'quasar-scaffold-host/stores/customResourceActions'

export default function ({ resourceName, defaultRecord = {}, actions, getters }) {
  const API = basicTableApi[resourceName]

  return defineStore(resourceName, {
    state: () => defaultState({ defaultRecord }),
    actions: actions || {
      ...defaultActions({ endpoints: API, defaultRecord, resourceName }),
      ...customResourceActions[resourceName],
    },
    getters: getters || {
      ...defaultGetters,
      ...(customResourceGetters[resourceName] || {})
    }
  })
}
