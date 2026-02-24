export default function defaultState ({ defaultRecord }) {
  return {
    belongsTo: {
      id: null,
      name: null
    },
    columnsGroup: 'default',
    datatableOptions: {
      modelName: null,
      columns: {},
      filters: {},
      groups: {},
      selectOptions: {},
      booleanColumns: []
    },
    pagination: {
      sortBy: null,
      descending: false,
      page: 1,
      rowsPerPage: 20,
      rowsNumber: null,
    },
    loading: true,
    idNameMapping: [],
    records: {},
    record: defaultRecord || {},
    search: '',
    selected: [],
    selectedFilters: {
      id: null
    },
    showFilters: false,
    showSelectedOnly: false,
    visibleForm: null,
    formSchemas: [],
    formSchemaModels: {},
    previousSearchOptions: {}
  }
}
