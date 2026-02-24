<template>
  <q-card class="my-card">
    <q-inner-loading :showing="isLoading">
      <q-spinner-gears size="50px" color="primary" />
    </q-inner-loading>
    <q-card-section class="bg-primary text-white">
      <div class="text-h6">{{ formTitle }}</div>
    </q-card-section>

    <form-cancel-save v-if="mode === 'edit'" :cancel="close" :save="submit" testIdSuffix="top" />

    <q-card-section
      v-for="(form, index) in resource.formSchemas"
      :key="form.label || index"
    >
      <div v-if="!form.skipTitle" class="text-h6">{{form.label}}</div>
      <BlitzForm
        :key="JSON.stringify(remountCounter)"
        v-model="resource.formSchemaModels[form.label]"
        :schema="form.schema"
        :columnCount="form.columnCount || 2"
        :internalLabels="true"
        :mode="mode"
        gridGap="2rem"
      />
    </q-card-section>

    <q-separator />

    <form-cancel-save v-if="mode === 'edit'" :cancel="close" :save="submit" testIdSuffix="bottom" />
  </q-card>
</template>

<script>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import resourceStores from 'quasar-scaffold-host/stores/resourceStores'
import { useI18n } from 'vue-i18n'

import { BlitzForm } from 'blitzar'
import merge from 'lodash/merge'
import { cannot } from 'quasar-scaffold-host/utils/authorizer'
import FormCancelSave from 'quasar-scaffold/components/FormCancelSave.vue'

import 'blitzar/dist/style.css'

export default {
  components: { BlitzForm, FormCancelSave },
  props: {
    resourceName: String,
    id: {
      type: [Number, String],
      default: null
    },
    schemaBase: Object,
    belongsTo: Object
  },
  setup (props) {
    const resource = resourceStores[props.resourceName]()
    const route = useRoute()
    const router = useRouter()
    const { t } = useI18n()
    const isLoading = ref(true)

    const isBatchUpdate = props.id === 'batch'
    const isCreateRecord = !isBatchUpdate && props.id === null

    const remountCounter = ref(0)

    function mergeSchemas (schema) {
      const schemaKeys = Object.keys(schema)
      const propertiesToMerge = Object.fromEntries(
        Object.entries(props.schemaBase).filter(([key]) => schemaKeys.includes(key))
      )

      return Object.values(merge(schema, propertiesToMerge))
    }

    let isReadOnly = false
    if (isCreateRecord) {
      isReadOnly = cannot({ action: 'create', modelName: resource.datatableOptions.modelName })
    } else {
      isReadOnly = cannot({ action: 'update', modelName: resource.datatableOptions.modelName })
    }

    let label
    if (isReadOnly) {
      label = 'viewRecord'
    } else if (isBatchUpdate) {
      label = 'batchEdit'
    } else if (isCreateRecord) {
      label = 'newRecord'
    } else {
      label = 'editRecord'
    }
    const formTitle = t(`datatable.${label}`)

    onMounted(async () => {
      isLoading.value = true
      const attributes = props.belongsTo ? { [`${props.belongsTo.name}Id`]: props.belongsTo.id } : {}

      const response = await resource.edit({ id: props.id, attributes })

      resource.formSchemas = response.schemas.map(schemaSection => {
        return { ...schemaSection, schema: mergeSchemas(schemaSection.schema) }
      })
      resource.formSchemaModels = response.schemas.reduce((acc, schemaSection) => {
        const schemaKeys = Object.keys(schemaSection.schema)
        acc[schemaSection.label] = Object.fromEntries(
          Object.entries(resource.record).filter(([key]) => schemaKeys.includes(key))
        )
        return acc
      }, {})
      remountCounter.value += 1
      isLoading.value = false
    })

    function close () {
      const currentPath = route.fullPath
      const splitPath = currentPath.split('/')
      const parentPath = splitPath.slice(0, splitPath.length - 1).join('/')

      router.push(parentPath)
    }

    async function submit () {
      // if(!this.$refs.form.validate()) { return }

      resource.record = Object.values(resource.formSchemaModels).reduce((acc, values) => {
        acc = { ...acc, ...values }
        return acc
      }, resource.record)

      if (isBatchUpdate) {
        const attributes = Object.entries(
          resource.record
        ).reduce((acc, [k, v]) => {
          if (v) {
            acc[k] = v
          }
          return acc
        }, {})

        await resource.updateBatch(
          {
            ids: resource.selectedIds,
            attributes
          }
        )
      } else {
        await resource[isCreateRecord ? 'create' : 'updateResource'](resource.record)
      }
      close()
    }

    return {
      isLoading,
      formTitle,
      resource,
      remountCounter,
      submit,
      close,
      mode: isReadOnly ? 'readonly' : 'edit'
    }
  },
}
</script>
