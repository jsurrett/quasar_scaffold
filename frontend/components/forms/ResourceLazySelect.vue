<template>
  <q-select
    v-if="resourceName"
    v-bind="$attrs"
    :label="label"
    :model-value="modelValue"
    :options="selectOptions"
    @filter="filterFn"
    @update:model-value="updateValue"
    input-debounce="500"
    emit-value
    map-options
    use-input
    use-chips
  >
    <template v-slot:no-option>
      <q-item>
        <q-item-section class="text-grey">
          No results
        </q-item-section>
      </q-item>
    </template>
  </q-select>
</template>

<script>
import { ref, watch, onMounted } from 'vue'
import basicTableApi from 'quasar-scaffold-host/api/dataTables'

let previousSearch = null
let previousresourceName = null

const pagination = {
  sortBy: null,
  descending: false,
  page: 1,
  rowsPerPage: 20,
  rowsNumber: null,
}

export default {
  props: {
    modelValue: Number,
    label: String,
    resourceName: String,
    options: Array,
    labelField: {
      type: String,
      default: 'name',
    },
    valueField: {
      type: String,
      default: 'id',
    },
    disable: Boolean
  },
  setup (props, context) {
    const { emit } = context
    const selectOptions = ref(props.options || [])
    const paginationParams = { ...pagination, sortBy: props.labelField }
    const updateValue = (value, _reason, _details) => {
      emit('update:modelValue', value)
    }

    const loadOptionForValue = async (value) => {
      if (!value) return

      // Check if the current value already exists in selectOptions
      const optionExists = selectOptions.value.some(opt => opt.value === value)
      if (optionExists) return

      try {
        // Try fetching with search parameter
        const response = await basicTableApi[props.resourceName].fetch({
          pagination: { ...paginationParams, rowsPerPage: 100 },
          search: '',
          fields: [props.valueField, props.labelField]
        })

        const allRecords = Object.values(response.records)
        const record = allRecords.find(r => r[props.valueField] === value)

        if (record) {
          // Add the fetched record to selectOptions if not already there
          selectOptions.value = selectOptions.value.filter(opt => opt.value !== value)
          selectOptions.value.unshift({
            label: record[props.labelField],
            value: record[props.valueField]
          })
        }
      } catch (error) {
        console.error('Error loading option:', error)
      }
    }

    // Load option on mount if modelValue is provided
    onMounted(async () => {
      if (props.modelValue) {
        await loadOptionForValue(props.modelValue)
      }
    })

    // Watch for modelValue changes and ensure the option is loaded
    watch(() => props.modelValue, async (newValue) => {
      await loadOptionForValue(newValue)
    })

    return {
      selectOptions,
      updateValue,
      filterFn (val, update, abort) {
        update(async () => {
          const search = (val || '').toLocaleLowerCase()
          if (search === previousSearch && previousresourceName === props.resourceName) {
            abort()
            return
          }
          previousresourceName = props.resourceName
          previousSearch = search

          const response = await basicTableApi[props.resourceName].fetch({
            pagination: paginationParams,
            search,
            fields: [props.valueField, props.labelField]
          })
          selectOptions.value = Object.values(response.records).map(record => ({
            label: record[props.labelField], value: record[props.valueField]
          }))
        })
      },

    }
  }
}
</script>
