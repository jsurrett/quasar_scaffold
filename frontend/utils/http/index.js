import axios from 'axios'
import { currentUserStore } from 'quasar-scaffold-host/stores/currentUserStore'
import { tenant, apiBaseUrl } from 'quasar-scaffold-host/api/helpers'

import {
  prepareData,
  processAxiosResponse
} from './data'
import { handle as handleError } from './errors'

axios.defaults.baseURL = apiBaseUrl
axios.defaults.withCredentials = false

const errorOptions = ({ data, name, url }) => {
  const fingerprint = `${name}: ${url.replace(/\d+/g, 'XX')}`

  return {
    fingerprint,
    name: fingerprint,
    params: data
  }
}

const headers = () => {
  const currentUser = currentUserStore()
  return {
    token: currentUser.token,
    Tenant: tenant
  }
}

const axiosResponse = ({ method, url, data }) => processAxiosResponse(
  axios({ data: prepareData(data), method, url, headers: headers() })
).catch(error => handleError(error, errorOptions({
  data,
  name: `HttpAxiosResponse-${method}`,
  url
})))

const axiosGet = ({ url, data }) => processAxiosResponse(
  axios.get(url, { params: prepareData(data), headers: headers() })
).catch(handleError)

const axiosGetFile = ({ url, data }) => axios.get(
  url,
  {
    params: prepareData(data),
    headers: headers(),
    responseType: 'blob'
  }
).catch(handleError)

export default {
  delete: (url, data) => axiosResponse({ data, method: 'delete', url }),
  get: (url, data) => axiosGet({ data, url }),
  getFile: (url, data) => axiosGetFile({ data, url }),
  patch: (url, data) => axiosResponse({ data, method: 'patch', url }),
  put: (url, data) => axiosResponse({ data, method: 'put', url }),
  post: (url, data) => axiosResponse({ data, method: 'post', url })
}
