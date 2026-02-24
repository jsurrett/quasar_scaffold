<template>
  <q-btn
    v-if="resource.showFiltersButton"
    size="sm"
    @click="handleToggleFilters"
    color='success'
    icon="mdi-filter"
    :label="$q.screen.gt.sm ? $t('datatable.filters') : void 0"
    :icon-right="resource.showFiltersSection ? 'mdi-eye-minus' : 'mdi-eye'"
  >
    <q-badge v-if="resource.activeFilterCount > 0" color="blue">
      {{resource.activeFilterCount}}
    </q-badge>
 </q-btn>
</template>

<script>
import resourceStores from 'quasar-scaffold-host/stores/resourceStores'

export default {
  props: {
    resourceName: String,
  },
  setup (props) {
    const resource = resourceStores[props.resourceName]()
    const handleToggleFilters = () => {
      resource.showFilters = !resource.showFilters
    }

    return {
      resource,
      handleToggleFilters
    }
  }
}
</script>

<style scoped>
  button {
    margin: 0px 3px;
  }
</style>
