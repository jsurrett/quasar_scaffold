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
import { computed, ref, watch } from 'vue'
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
    const fetchedName = ref(null)

    const isExistingRecord = () => props.id && props.id !== 'batch'

    // Prefer a record already in the store; resource.record only counts when it
    // is this record, since it can still hold the last one opened
    const storedName = () => {
      if (String(resource.record?.id) === String(props.id)) return resource.record.name
      return resource.records[`id${props.id}`]?.name
    }

    const name = computed(() => {
      if (!props.id) return t('datatable.newRecord')
      if (props.id === 'batch') {
        return t('datatable.recordsSelected', { count: resource.selectedIds.length })
      }
      return storedName() ?? fetchedName.value
    })

    // Opened by URL (reload, bookmark, link) the store is empty, so fetch the
    // record for its name
    watch(() => props.id, async (id) => {
      fetchedName.value = null
      if (!isExistingRecord() || storedName()) return

      try {
        const record = await resource.fetchOne(id)
        if (props.id === id) fetchedName.value = record?.name
      } catch {
        // Leave the name blank rather than break the page
      }
    }, { immediate: true })

    return {
      name
    }
  }
}
</script>
