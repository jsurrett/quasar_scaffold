<template>
  <div class="q-pa-md">
    <q-table
      :dense="$q.screen.lt.md"
      :grid="$q.screen.lt.sm"
      :title="$t(`resources.${resource.$id}`)"
      :rows="resource.displayRecords"
      :columns="resource.visibleHeaders"
      row-key="id"
      v-model:pagination="resource.pagination"
      :loading="resource.loading"
      :filter="resource.tableFilter"
      @request="resource.fetch"
      binary-state-sort
      selection="multiple"
      v-model:selected="resource.selected"
      :wrap-cells="true"
    >
      <template v-slot:loading>
        <q-inner-loading showing color="primary" />
      </template>
      <template v-slot:top>
        <resources-toolbar :resourceName="resourceName" />
        <search :resourceName="resourceName"></search>
        <filters :resourceName="resourceName" v-if="resource.showFiltersSection"></filters>
      </template>

      <template v-slot:body-cell-actions="props">
        <q-td :props="props">
          <row-actions :resourceName="resourceName" :item="props.row"></row-actions>
        </q-td>
      </template>

      <template v-slot:item="props">
        <grid-slot :props="props" :resourceName="resourceName">
          <template v-slot="gridSlotProps">
            <slot name="gridFieldOverrides" v-bind="gridSlotProps">
            </slot>
          </template>
        </grid-slot>
      </template>

      <template
        v-for="columnName in resource.datatableOptions.booleanColumns"
        :key="columnName"
        v-slot:[columnSlotName(columnName)]="props"
      >
        <q-td :props="props">
          <q-checkbox v-model="props.row[columnName]" disabled />
        </q-td>
      </template>

      <template
        v-for="columnName in resource.datatableOptions.htmlColumns"
        :key="columnName"
        v-slot:[columnSlotName(columnName)]="props"
      >
        <q-td :props="props" v-html="props.row[columnName]" />
      </template>

      <template v-for="(_, name) in $slots" #[name]="slotData">
        <slot :name="name" v-bind="slotData || {}"></slot>
      </template>
    </q-table>
  </div>
</template>

<script>
import { onMounted } from 'vue'
import resourceStores from 'quasar-scaffold-host/stores/resourceStores'
import ResourcesToolbar from './Toolbar/ResourcesToolbar.vue'
import Search from './Search.vue'
import Filters from './Filters.vue'
import RowActions from 'quasar-scaffold/components/ResourceDataTable/RowActions.vue'
import GridSlot from './GridSlot.vue'
import dataTableNeededIdNameMappings from 'quasar-scaffold-host/resourceHelpers/dataTableNeededIdNameMappings'

export default {
  components: { ResourcesToolbar, Search, Filters, RowActions, GridSlot },
  props: {
    resourceName: String,
    belongsTo: Object,
    gridSlotComponent: Object
  },
  setup (props) {
    const resource = resourceStores[props.resourceName]()

    onMounted(async () => {
      if (!resource.datatableOptions.modelName) {
        dataTableNeededIdNameMappings[props.resourceName] && await dataTableNeededIdNameMappings[props.resourceName]()
        await resource.load({ pagination: resource.pagination, belongsTo: props.belongsTo })
      }
    })

    const columnSlotName = (columnName) => `body-cell-${columnName}`

    return {
      resource,
      columnSlotName,
      GridSlotComponent: props.gridSlotComponent || GridSlot
    }
  }
}
</script>
