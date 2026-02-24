import http from 'quasar-scaffold/utils/http'

export function basicRoutes (baseUrl) {
  return {
    fetch: options => http.get(baseUrl, options),
    export: options => http.getFile(`${baseUrl}.xlsx`, options),
    datatableOptions: options => http.post(`${baseUrl}/datatable_options`, options),
    search: options => http.post(baseUrl, options),
    show: id => http.get(`${baseUrl}/${id}`),
    create: attributes => http.post(baseUrl, attributes),
    import: records => http.post(`${baseUrl}/import`, { records }),
    edit: ({ id, attributes }) => http.get(`${baseUrl}/${id}/edit`, attributes),
    update: attributes => http.patch(`${baseUrl}/${attributes.id}`, attributes),
    updateBatch: params => http.patch(`${baseUrl}/batch_update`, params),
    destroy: id => http.delete(`${baseUrl}/${id}`)
  }
}
