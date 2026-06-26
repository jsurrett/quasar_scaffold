<template>
  <q-input
    :label="$t('datatable.search')"
    clearable
    dense
    debounce="500"
    color="primary"
    v-model="resource.search"
  >
    <template v-slot:append>
      <q-icon name="mdi-magnify" />
    </template>
  </q-input>
</template>

<script>
import resourceStores from 'quasar-scaffold-host/stores/resourceStores'

export default {
  props: {
    resourceName: String
  },
  setup (props) {
    const resource = resourceStores[props.resourceName]()

    return {
      resource
    }
  }
}
</script>

