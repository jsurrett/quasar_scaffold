import camelize from 'camelize'
import snakeize from 'snakeize'

import { isObject } from '../typeCheck'

export const prepareData = data => snakeize({
  ...data
})

export const prepareFormData = options => {
  const formData = new FormData()
  options = prepareData(options)

  if (options) {
    Object.keys(options).forEach(key => {
      const value = options[key]

      if (!value) return

      if (isObject(value)) {
        Object.keys(value).forEach(valueKey => {
          formData.append(`${key}[${valueKey}]`, value[valueKey])
        })
      } else {
        formData.append(key, value)
      }
    })
  }

  return formData
}

export const prepareFileFormData = ({ file, options }) => {
  const formData = new FormData()
  formData.append('file', file)

  if (options) {
    Object.entries(options).forEach(entry => {
      formData.append(entry[0], entry[1])
    })
  }

  return formData
}

export const parseResponse = ({ data }) => {
  return camelize(data)
}

export const processAxiosResponse = response => response.then(parseResponse)
