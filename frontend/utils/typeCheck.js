export const isObject = object =>
  object && ({}).toString.call(object) === '[object Object]'

export const isNumber = object =>
  object && ({}).toString.call(object) === '[object Number]'

export const isString = object =>
  object && ({}).toString.call(object) === '[object String]'

export const isArray = object =>
  object && ({}).toString.call(object) === '[object Array]'

export const isObjectWithValues = object =>
  isObject(object) && Object.entries(object).length > 0

export const isArrayWithValues = object =>
  isArray(object) && object.length > 0

export const validateZipCodeLength = ({ length, zip }) =>
  zip && zip.length > parseInt(length)
