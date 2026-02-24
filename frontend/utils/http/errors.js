import camelize from 'camelize'
import { Notify } from 'quasar'
import { currentUserStore } from 'quasar-scaffold-host/stores/currentUserStore'
import { t } from 'quasar-scaffold-host/boot/i18n'

export const handle = error => {
  let errorObject = {}

  if (error.response.status === 401) {
    const currentUser = currentUserStore()

    currentUser.router.push('/')

    errorObject = {
      error: t('messages.unauthorizedAccessAttemptDetected'),
      status: error.response.status
    }
  } else if (
    error.response &&
      error.response.data &&
      error.response.data.errors
  ) {
    errorObject = {
      error: camelize(error.response.data.errors),
      status: error.response.status
    }
  } else if (
    error.response &&
      error.response.data &&
      error.response.data.error
  ) {
    // The request was made and the server responded with a status code
    // that falls out of the range of 2xx
    errorObject = {
      error: camelize(error.response.data.error),
      status: error.response.status
    }
  } else if (error.response) {
    // The request was made and the server responded with a status code
    // that falls out of the range of 2xx
    errorObject = {
      error: camelize(error.response),
      status: error.response.status
    }
  } else {
    // Something happened in setting up the request that triggered an Error
    errorObject = {
      error,
      status: null
    }
  }

  Notify.create({
    type: 'negative',
    message: JSON.stringify(errorObject.error)
  })

  throw errorObject
}
