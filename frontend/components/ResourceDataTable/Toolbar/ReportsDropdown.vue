<template>
  <q-btn
    v-if="(resource.indexReportList || []).length  > 0"
    color="green"
    size="sm"
    :label="$q.screen.gt.sm ? $t('datatable.reports') : void 0"
    icon="mdi-file-document"
    icon-right="mdi-menu-down"
  >
    <q-menu>
      <q-list dense style="min-width: 150px">
        <template v-for="(item, index) in (resource.indexReportList || [])">
          <q-separator v-if="item.separator" :key="`separator${index}`"/>
          <q-item
            v-else-if="!item.items"
            :key="`item${index}`"
            @click="handleReport(item)"
            clickable
            v-close-popup
          >
            <q-item-section avatar>
              <q-avatar :icon="`mdi-${item.icon}`" />
            </q-item-section>
            <q-item-section>
              <q-item-label>{{ $t(item.title) }}</q-item-label>
            </q-item-section>
          </q-item>
          <q-item
            v-else
            :key="`nested${index}`"
            clickable
          >
            <q-item-section>{{ $t(item.title) }}</q-item-section>
            <q-item-section side>
              <q-icon name="keyboard_arrow_right" />
            </q-item-section>

            <q-menu auto-close anchor="top end" self="top start">
              <q-list style="min-width: 150px">
                <q-item
                  v-for="(nested_item, nested_index) in item.items"
                  :key="nested_index"
                  dense
                  clickable
                  @click="handleReport(nested_item)"
                >
                  <q-item-section avatar>
                    <q-avatar :icon="`mdi-${nested_item.icon}`" />
                  </q-item-section>
                  <q-item-section>
                    <q-item-label>{{ $t(nested_item.title) }}</q-item-label>
                  </q-item-section>
                </q-item>
              </q-list>
            </q-menu>
          </q-item>
        </template>
      </q-list>
    </q-menu>
  </q-btn>
</template>

<script>
import resourceStores from 'quasar-scaffold-host/stores/resourceStores'
import { useRoute, useRouter } from 'vue-router'
import { useI18n } from 'vue-i18n'
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

    function handleReport ({ action, areIdsOptional = true }) {
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
      handleReport
    }
  }
}
</script>

<style scoped>
  button {
    margin: 0px 3px;
  }
  .q-item__section--side {
    padding-right: 0px;
  }
  .q-item--dense {
    padding: 0px;
  }
</style>
