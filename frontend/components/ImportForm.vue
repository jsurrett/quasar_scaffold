<template>
  <q-card class="my-card">
    <q-card-section class="bg-primary text-white">
      <div class="text-h6">{{$t(`datatable.import`)}}</div>
    </q-card-section>

    <form-cancel-save :cancel="handleClose" :save="handleSubmit" :disabled="csv.length === 0" />

    <q-card-section>
      <vue-csv-import
        v-model="csv"
        :fields="{name: {required: false, label: 'Name'}, age: {required: true, label: 'Age'}}"
      >
        <vue-csv-toggle-headers></vue-csv-toggle-headers>
        <vue-csv-errors></vue-csv-errors>
        <vue-csv-input></vue-csv-input>
        <vue-csv-map></vue-csv-map>
      </vue-csv-import>
    </q-card-section>

    <form-cancel-save :cancel="handleClose" :save="handleSubmit" :disabled="csv.length === 0" />
  </q-card>
</template>

<script>
import FormCancelSave from 'quasar-scaffold/components/FormCancelSave.vue'
// import VueCsvImport from 'src/components/VueCsvImport.vue'
import { VueCsvToggleHeaders, VueCsvMap, VueCsvInput, VueCsvErrors, VueCsvImport } from 'vue-csv-import'

import resourceStores from 'quasar-scaffold-host/stores/resourceStores'
import { useI18n } from 'vue-i18n'
// import { ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { parentRoute } from 'quasar-scaffold-host/utils/routingHelpers'
import { Notify } from 'quasar'

export default {
  components: {
    FormCancelSave,
    VueCsvToggleHeaders,
    VueCsvMap,
    VueCsvInput,
    VueCsvErrors,
    VueCsvImport,
  },
  props: {
    resourceName: String,
  },
  setup (props) {
    const csv = []
    const { t } = useI18n()
    const route = useRoute()
    const router = useRouter()

    const resource = resourceStores[props.resourceName]()

    function handleClose () {
      router.push(parentRoute(route))
    }

    async function handleSubmit () {
      resource.loading = true

      try {
        await resource.import(csv.value)
        Notify.create({
          type: 'success',
          message: t('messages.recordsImported')
        })
        handleClose()
      } finally {
        resource.loading = false
      }
    }

    return {
      resource: { datatableOptions: { columns: ['name'] } },
      csv,
      handleClose,
      handleSubmit,
    }
  }
}
</script>
