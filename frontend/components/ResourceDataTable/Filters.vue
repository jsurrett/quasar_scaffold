<template>
  <div class="filter-panel full-width q-pa-sm q-mt-xs row q-gutter-sm">
    <template v-for="key in resource.filterKeys" :key="key">
      <lazy-filter-select
        v-if="resource.datatableOptions.filters[key].resource"
        class="filter-select"
        :filter="resource.datatableOptions.filters[key]"
        v-model="resource.selectedFilters[key]"
      />
      <q-select
        v-else
        class="filter-select"
        filled
        dense
        clearable
        multiple
        emit-value
        map-options
        :options="resource.datatableOptions.filters[key].options"
        :label="resource.datatableOptions.filters[key].name"
        v-model="resource.selectedFilters[key]"
      >
        <template v-slot:selected>
          <template v-if="(resource.selectedFilters[key] || []).length > 0">
            <q-chip
              v-for="(val, i) in (resource.selectedFilters[key] || []).slice(0, 2)"
              :key="i"
              removable
              dense
              size="sm"
              @remove="removeValue(key, val)"
            >
              {{ getOptionLabel(key, val) }}
            </q-chip>
            <q-chip
              v-if="(resource.selectedFilters[key] || []).length > 2"
              dense
              size="sm"
              color="grey-5"
              text-color="white"
            >
              +{{ (resource.selectedFilters[key] || []).length - 2 }}
            </q-chip>
          </template>
        </template>
      </q-select>
    </template>
  </div>
</template>

<script>
import LazyFilterSelect from './LazyFilterSelect.vue'
import resourceStores from 'quasar-scaffold-host/stores/resourceStores'

export default {
  components: { LazyFilterSelect },
  props: {
    resourceName: String,
  },
  setup (props) {
    const resource = resourceStores[props.resourceName]()

    function getOptionLabel (key, value) {
      const filter = resource.datatableOptions.filters[key]
      return filter?.options?.find(o => o.value === value)?.label ?? value
    }

    function removeValue (key, value) {
      resource.selectedFilters[key] = (resource.selectedFilters[key] || []).filter(v => v !== value)
    }

    return { resource, getOptionLabel, removeValue }
  },
}
</script>

<style scoped>
.filter-panel {
  background: #f0f4f8;
  border-radius: 8px;
}
.filter-select {
  min-width: 200px;
  flex: 1 1 200px;
}
</style>
