import camelize from 'camelize'
import { t } from 'quasar-scaffold-host/boot/i18n'
import { compactObject } from 'quasar-scaffold/utils/index'

export default {
  modelName (state) {
    return state.datatableOptions.modelName
  },
  displayRecords (state) {
    const selectOptions = state.datatableOptions.selectOptions
    const selectOptionColumns = Object.keys(selectOptions)

    return Object.values(state.records).map(record => {
      const newRecord = {}
      Object.entries(record).forEach(field => {
        const [key, value] = field

        if (selectOptionColumns.includes(key)) {
          newRecord[key] = selectOptions[key][value]
        } else {
          newRecord[key] = value
        }
      })
      return newRecord
    })
  },
  reportOptions (state) {
    const selectedFilters = { ...state.selectedFilters }
    if (state.selectedIds.length > 0) {
      selectedFilters.id = state.selectedIds
    } else {
      selectedFilters.id = null
    }

    return {
      pagination: state.pagination,
      search: state.search,
      belongsTo: state.belongsTo,
      selectedFilters,
    }
  },
  showViewOptions (state) {
    return (this.viewOptions.length > 1)
  },
  viewOptions (state) {
    const views = Object.keys(state.datatableOptions.groups || {})

    return views.map(view => ({
      // title: t(`datatable.views.${view}`),
      title: view,
      value: view
    }))
  },
  selectedIds (state) {
    return state.selected.map(item => item.id)
  },
  filterKeys (state) {
    return Object.keys(state.datatableOptions.filters)
  },
  showFiltersButton (state) {
    return this.filterKeys.length > 0
  },
  tableFilter (state) {
    return compactObject({
      search: state.search,
      ...(compactObject(state.selectedFilters) || {})
    })
  },
  showFiltersSection (state) {
    return state.showFilters && this.showFiltersButton
  },
  activeFilterCount (state) {
    if (!state.selectedFilters) { return 0 }

    return Object.keys(state.selectedFilters).reduce((count, key) => {
      if ((state.selectedFilters[key] || []).length > 0) {
        count++
      }
      return count
    }, 0)
  },
  visibleHeaders (state) {
    try {
      const headers = state.datatableOptions.groups[state.columnsGroup].reduce((acc, column) => {
        column = camelize(column)
        if (state.belongsTo?.name !== column) {
          const columnOptions = state.datatableOptions.columns[column] || {
            name: column,
            label: column,
            field: column,
            sortable: true,
            align: 'left'
          }
          acc.push(columnOptions)
        }
        return acc
      }, [])

      headers.push({ label: t('datatable.actions'), name: 'actions' })

      return headers
    } catch {
      return []
    }
  }
}
