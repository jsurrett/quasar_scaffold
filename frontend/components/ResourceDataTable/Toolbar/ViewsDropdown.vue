<template>
  <q-btn-dropdown
    v-if="resource.showViewOptions"
    size="sm"
    align="left"
    color="amber"
    icon="mdi-format-columns"
    :label="$q.screen.gt.sm ? $t('datatable.views.button') : void 0"
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
import resourceStores from 'quasar-scaffold-host/stores/resourceStores'

export default {
  props: {
    resourceName: String,
  },
  setup (props) {
    const resource = resourceStores[props.resourceName]()

    const handleChooseView = value => {
      resource.columnsGroup = value
    }

    return {
      resource,
      handleChooseView,
    }
  }
}
</script>

<style scoped>
  button {
    margin: 0px 3px;
  }
</style>
