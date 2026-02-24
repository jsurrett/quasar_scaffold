<template>
  <div class="q-pa-md">
    <div class="text-h6 text-center">
      {{$t(`resources.${resourceName}`)}}: {{name}}
    </div>
    <slot></slot>
  </div>
</template>

<script>
import resourceStores from 'quasar-scaffold-host/stores/resourceStores'
import { useI18n } from 'vue-i18n'

export default {
  props: {
    resourceName: String,
    id: {
      type: [Number, String],
      default: null
    }
  },
  setup (props) {
    const { t } = useI18n()
    const resource = resourceStores[props.resourceName]()

    let displayName
    if (!props.id) {
      displayName = t('datatable.newRecord')
    } else if (props.id === 'batch') {
      displayName = t('datatable.recordsSelected', { count: resource.selectedIds.length })
    } else {
      displayName = resource.record.name || resource.records[`id${props.id}`]?.name
    }

    return {
      name: displayName
    }
  }
}
</script>
