<template>
  <q-btn-dropdown
    color="red"
    size="sm"
    :label="$q.screen.gt.sm ? $t('datatable.actions') : void 0"
    icon="mdi-cogs"
    data-testid="actions-dropdown-button"
  >
    <q-list class="resource-table-actions">
      <q-item
        v-for="(item, index) in actionsList"
        :key="index"
        @click="handleMacro(item)"
        clickable
        :disable="!!item.permission && cannot({ action: item.permission, modelName: resource.datatableOptions.modelName })"
        v-close-popup
        :data-testid="`action-button-${item.title}`"
      >
        <q-item-section avatar>
          <q-avatar :icon="`mdi-${item.icon}`" />
        </q-item-section>
        <q-item-section>
          <q-item-label>{{ $t(item.title) }}</q-item-label>
        </q-item-section>
      </q-item>
    </q-list>
  </q-btn-dropdown>
</template>

<script>
import resourceStores from 'quasar-scaffold-host/stores/resourceStores'
import { useRoute, useRouter } from 'vue-router'
import { useI18n } from 'vue-i18n'
import { defaultTableActions } from './actionsHelper'
import actions from 'quasar-scaffold-host/resourceHelpers/actions'
import { cannot } from 'quasar-scaffold-host/utils/authorizer'

import { useQuasar } from 'quasar'

export default {
  props: {
    resourceName: String,
  },
  setup (props) {
    const $q = useQuasar()
    const { t } = useI18n()
    const resource = resourceStores[props.resourceName]()
    const route = useRoute()
    const router = useRouter()

    function handleMacro ({ action, areIdsOptional = false }) {
      if (!areIdsOptional && resource.selectedIds.length === 0) {
        $q.notify({
          type: 'warning',
          message: t('messages.noRecordsSelected')
        })
        return
      }
      action({ resource, route, router })
    }
    return {
      resource,
      cannot,
      handleMacro,
      actionsList: (actions[props.resourceName] || defaultTableActions)
    }
  }
}
</script>

<style scoped>
  button {
    margin: 0px 3px;
  }
</style>
