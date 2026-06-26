<template>
  <div v-if="hasActiveItems" class="active-filter-summary full-width row items-center q-py-xs q-gutter-xs">
    <span class="text-caption text-grey-7 q-mr-xs">{{ $t('datatable.activeFilters') }}:</span>
    <q-chip
      v-if="resource.search"
      removable
      dense
      size="sm"
      color="secondary"
      text-color="white"
      icon="mdi-magnify"
      @remove="resource.search = ''"
    >
      {{ resource.search }}
    </q-chip>
    <q-chip
      v-for="key in activeFilterKeys"
      :key="key"
      removable
      dense
      size="sm"
      color="primary"
      text-color="white"
      @remove="clearFilter(key)"
    >
      {{ summaryLabel(key) }}
    </q-chip>
    <q-btn flat dense size="xs" :label="$t('datatable.clearAll')" color="negative" @click="clearAll" />
  </div>
</template>

<script>
import { computed } from 'vue'
import resourceStores from 'quasar-scaffold-host/stores/resourceStores'

export default {
  props: {
    resourceName: String,
  },
  setup (props) {
    const resource = resourceStores[props.resourceName]()

    const activeFilterKeys = computed(() =>
      Object.keys(resource.selectedFilters).filter(key =>
        (resource.selectedFilters[key] || []).length > 0
      )
    )

    const hasActiveItems = computed(() =>
      !!resource.search || activeFilterKeys.value.length > 0
    )

    function summaryLabel (key) {
      const filter = resource.datatableOptions.filters[key]
      const selected = resource.selectedFilters[key] || []
      const filterName = filter?.name ?? key

      if (filter?.options) {
        const labels = selected.map(v => filter.options.find(o => o.value === v)?.label ?? v)
        if (labels.length <= 2) return `${filterName}: ${labels.join(', ')}`
        return `${filterName}: ${labels.slice(0, 2).join(', ')} +${labels.length - 2}`
      }
      return `${filterName} (${selected.length})`
    }

    function clearFilter (key) {
      resource.selectedFilters[key] = null
    }

    function clearAll () {
      resource.search = ''
      Object.keys(resource.selectedFilters).forEach(key => {
        resource.selectedFilters[key] = null
      })
    }

    return { resource, activeFilterKeys, hasActiveItems, summaryLabel, clearFilter, clearAll }
  },
}
</script>

<style scoped>
.active-filter-summary {
  border-top: 1px solid #e0e0e0;
  padding-top: 4px;
  margin-top: 4px;
}
</style>
