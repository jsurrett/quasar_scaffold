<template>
  <q-btn-dropdown
    v-if="resource.showViewOptions"
    size="sm"
    align="left"
    color="secondary"
    icon="mdi-format-columns"
    :label="$q.screen.gt.sm ? activeViewLabel : void 0"
  >
    <q-list>
      <q-item
        v-for="(item, index) in resource.viewOptions"
        :key="index"
        @click="handleChooseView(item.value)"
        clickable
        v-close-popup
      >
        <q-item-section>
          <q-item-label>{{ $t(`datatable.views.${item.title}`) }}</q-item-label>
        </q-item-section>
      </q-item>
    </q-list>
  </q-btn-dropdown>
</template>

<script>
import { computed } from 'vue'
import { useI18n } from 'vue-i18n'
import resourceStores from 'quasar-scaffold-host/stores/resourceStores'

export default {
  props: {
    resourceName: String,
  },
  setup (props) {
    const { t } = useI18n()
    const resource = resourceStores[props.resourceName]()

    const activeViewLabel = computed(() => {
      const active = resource.viewOptions?.find(o => o.value === resource.columnsGroup)
      return active ? t(`datatable.views.${active.title}`) : t('datatable.views.button')
    })

    const handleChooseView = value => {
      resource.columnsGroup = value
    }

    return {
      resource,
      handleChooseView,
      activeViewLabel,
    }
  }
}
</script>

<style scoped>
  button {
    margin: 0px 3px;
  }
</style>
