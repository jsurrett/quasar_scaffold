<template>
  <label>
    {{label}}
    <q-editor v-bind="$attrs" :toolbar="toolbar"/>
  </label>
</template>

<script>
import { defaultToolbar } from 'quasar-scaffold-host/utils/quasarEditorSettings'
import { useQuasar } from 'quasar'

export default {
  props: {
    label: String
  },
  setup () {
    const quasar = useQuasar()

    return {
      toolbar: defaultToolbar(quasar)
    }
  }
}
</script>
