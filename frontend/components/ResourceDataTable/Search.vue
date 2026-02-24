<template>
  <q-input
    :label="$t('datatable.search')"
    dense
    debounce="500"
    color="primary"
    v-model="resource.search"
    :placeholder="$t('datatable.search')"
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

<style scoped>
  #datatable-search {
    margin: 0px 15px;
  }
</style>
