<template>
  <q-select
    class="filter-select"
    filled
    dense
    clearable
    multiple
    use-input
    emit-value
    map-options
    input-debounce="500"
    :options="selectOptions"
    :label="filter.name"
    :model-value="modelValue"
    @update:model-value="$emit('update:modelValue', $event)"
    @filter="filterFn"
  >
    <template v-slot:selected>
      <template v-if="(modelValue || []).length > 0">
        <q-chip
          v-for="(val, i) in (modelValue || []).slice(0, 2)"
          :key="i"
          removable
          dense
          size="sm"
          @remove="removeValue(val)"
        >
          {{ getChipLabel(val) }}
        </q-chip>
        <q-chip
          v-if="(modelValue || []).length > 2"
          dense
          size="sm"
          color="grey-5"
          text-color="white"
        >
          +{{ (modelValue || []).length - 2 }}
        </q-chip>
      </template>
    </template>
    <template v-slot:no-option>
      <q-item>
        <q-item-section class="text-grey">No results</q-item-section>
      </q-item>
    </template>
  </q-select>
</template>

<script>
import { ref } from 'vue'
import basicTableApi from 'quasar-scaffold-host/api/dataTables'

const pagination = { sortBy: null, descending: false, page: 1, rowsPerPage: 20, rowsNumber: null }

export default {
  props: {
    filter: Object,
    modelValue: Array,
  },
  emits: ['update:modelValue'],
  setup (props, { emit }) {
    const selectOptions = ref([])
    const paginationParams = { ...pagination, sortBy: props.filter.labelField }

    function getChipLabel (value) {
      return selectOptions.value.find(o => o.value === value)?.label ?? `#${value}`
    }

    function removeValue (value) {
      emit('update:modelValue', (props.modelValue || []).filter(v => v !== value))
    }

    return {
      selectOptions,
      getChipLabel,
      removeValue,
      filterFn (val, update) {
        update(async () => {
          const search = (val || '').toLocaleLowerCase()
          const response = await basicTableApi[props.filter.resource].fetch({
            pagination: paginationParams,
            search,
            fields: [props.filter.valueField, props.filter.labelField],
          })
          selectOptions.value = Object.values(response.records).map(record => ({
            label: record[props.filter.labelField],
            value: record[props.filter.valueField],
          }))
        })
      },
    }
  },
}
</script>
