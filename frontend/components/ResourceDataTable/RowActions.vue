<template>
  <div>
    <q-btn-dropdown
      v-if="actionsList.length > 0"
      rounded
      flat
      size="xs"
      dropdown-icon="mdi-dots-vertical"
      style="padding: 4px"
      :data-testid="`dropdown_actions-for-${item.id}`"
    >
      <q-list>
        <q-item
          v-for="(action, index) in actionsList"
          :key="index"
          @click="action.action({ resource, router, item })"
          clickable
          :disable="!!item.permission && cannot({ action: item.permission, modelName, id: item.id })"
          v-close-popup
          :data-testid="`row-action-${action.title}-for-${item.id}`"
        >
          <q-item-section avatar>
            <q-avatar :icon="`mdi-${action.icon}`" />
          </q-item-section>
          <q-item-section>
            <q-item-label>{{ $t(action.title) }}</q-item-label>
          </q-item-section>
        </q-item>
      </q-list>
    </q-btn-dropdown>
  </div>
</template>

<script>
import resourceStores from 'quasar-scaffold-host/stores/resourceStores'
import { useRouter, useRoute } from 'vue-router'
import { useI18n } from 'vue-i18n'
import { memberActions } from 'quasar-scaffold-host/resourceHelpers/memberActions'
import { cannot } from 'quasar-scaffold-host/utils/authorizer'

export default {
  props: {
    item: Object,
    resourceName: String,
  },
  setup (props) {
    const router = useRouter()
    const route = useRoute()
    const { t } = useI18n()

    const resource = resourceStores[props.resourceName]()

    const editRecord = ({ router, item }) => router.push({ path: `${route.path}/${item.id}` })
    const deleteRecord = ({ resource, item }) => {
      confirm(
        t('messages.confirmSingleDelete')
      ) && resource.destroy(item.id)
    }

    const defaultMemberActions = [
      {
        icon: 'pencil',
        title: 'datatable.editRecord',
        action: editRecord,
        permission: 'update',
      },
      {
        icon: 'delete',
        title: 'datatable.deleteRecord',
        action: deleteRecord,
        permission: 'destroy',
      }
    ]

    const actionsList = memberActions(defaultMemberActions, props.resourceName)

    return {
      resource,
      modelName: resource.datatableOptions.modelName,
      router,
      editRecord,
      deleteRecord,
      actionsList,
      cannot
    }
  }
}
</script>
