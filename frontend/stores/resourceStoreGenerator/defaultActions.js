import { saveAs } from 'file-saver'
import { crudUpdaters } from 'quasar-scaffold-host/stores/customResourceActions'
import { resourceSingularName } from 'quasar-scaffold-host/api/dataTables'
import { compactObject } from 'quasar-scaffold/utils/index'

export default function defaultActions ({ endpoints, defaultRecord, resourceName }) {
  const updaterCallback = crudUpdaters[resourceName]

  // Helper function to wrap actions with loading state management
  const withLoading = (actionFn) => {
    return async function (...args) {
      this.loading = true
      try {
        return await actionFn.apply(this, args)
      } finally {
        this.loading = false
      }
    }
  }

  return {
    getDatatableOptions: async function () {
      const options = await endpoints.datatableOptions({})
      this.datatableOptions = {
        ...this.datatableOptions,
        ...options
      }

      const filterKeys = Object.keys(this.datatableOptions.filters)

      if (filterKeys.length === 0) {
        this.selectedFilters = {}
      } else if (Object.keys(this.selectedFilters).length === 0) {
        this.selectedFilters = filterKeys.reduce((acc, key) => {
          acc[key] = []
          return acc
        }, {})
      }
    },

    async load (options = {}) {
      this.belongsTo = options.belongsTo || {}

      Promise.all([
        this.getDatatableOptions(),
        this.fetch(options)
      ])
    },

    async fetch (props = {}) {
      this.loading = true
      const { force = false, ...rest } = props
      props = rest
      try {
        let data = {}
        delete props.getCellValue

        if (this.showSelectedOnly) {
          this.selectedFilters.id = this.selectedIds
          this.pagination.page = 1
        } else {
          this.selectedFilters.id = null
        }

        const { pagination, belongsTo, search, selectedFilters } = this
        const searchOptions = {
          pagination,
          search,
          belongsTo,
          selectedFilters: compactObject(selectedFilters),
          ...props
        }

        if (force || JSON.stringify(searchOptions) !== JSON.stringify(this.previousSearchOptions)) {
          this.previousSearchOptions = searchOptions
          data = await endpoints.fetch(searchOptions)

          const id = this.router.currentRoute.value.params.id
          this.pagination = { ...this.pagination, ...data.pagination }
          this.records = data.records
          this.record = id ? this.records[`id${id}`] : { ...defaultRecord }
        }
        return data
      } finally {
        this.loading = false
      }
    },

    fetchIdNameMapping: withLoading(async function () {
      const data = await endpoints.fetch({
        pagination: { rowsPerPage: 0 },
        fields: ['id', 'name']
      })
      this.idNameMapping = Object.values(data.records)

      return data
    }),

    show: withLoading(async function (id) {
      if (Object.keys(this.datatableOptions.columns).length === 0) {
        await this.getDatatableOptions
      }

      if (id) {
        const data = await endpoints.show(id)
        this.record = data
        this.visibleForm = 'update'
      } else {
        this.record = { ...defaultRecord }
        this.visibleForm = 'create'
      }
    }),

    edit: withLoading(async function ({ id, attributes }) {
      const response = await endpoints.edit({ id, attributes })

      this.record = response.model

      if (updaterCallback) { await updaterCallback() }

      return response
    }),

    create: withLoading(async function (item) {
      const response = await endpoints.create(item)

      if (updaterCallback) { await updaterCallback() }

      this.records[`id${response.id}`] = response
    }),

    destroy: withLoading(async function (id) {
      await endpoints.destroy(id)
      if (updaterCallback) { await updaterCallback() }

      this.records = Object.fromEntries(
        Object.entries(this.records).filter(([key]) => key !== `id${id}`)
      )
    }),

    updateResource: withLoading(async function (item) {
      try {
        const response = await endpoints.update({ id: item.id, [resourceSingularName[resourceName]]: item })

        if (updaterCallback) { await updaterCallback() }

        this.records[`id${item.id}`] = response

        return response
      } catch (error) {
        console.log(error)
      }
    }),
    async update (item) {
      await this.updateResource(item)
    },
    updateBatch: withLoading(async function (params) {
      await endpoints.updateBatch(params)
      if (updaterCallback) { await updaterCallback() }
      await this.fetch()
    }),
    export: withLoading(async function () {
      const { pagination, belongsTo, search, selectedFilters } = this

      const response = await endpoints.export({
        belongsTo,
        search,
        pagination,
        filters: selectedFilters,
      })

      saveAs(response.data, `${this.$id}.xlsx`)
    })
  }
}
