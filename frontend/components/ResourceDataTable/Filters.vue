<template>
  <q-select
    class="filter-selects"
    v-for="(key, index) in resource.filterKeys"
    :key="index"
    filled
    clearable
    multiple
    use-chips
    emit-value
    map-options
    :options="resource.datatableOptions.filters[key].options"
    :label="resource.datatableOptions.filters[key].name"
    v-model="resource.selectedFilters[key]"
  />
</template>

<script>
import resourceStores from 'quasar-scaffold-host/stores/resourceStores'

export default {
  props: {
    resourceName: String,
  },
  setup (props) {
    const resource = resourceStores[props.resourceName]()

    return {
      resource,
    }
  },
}
</script>

<style scoped>
  .filter-selects {
    min-width: 10em;
    margin: 0px 10px;
  }
</style>
