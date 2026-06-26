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
        <filters :resourceName="resourceName"></filters>
        <active-filter-summary :resourceName="resourceName"></active-filter-summary>
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
import { onMounted, computed } from 'vue'
import { useRoute } from 'vue-router'
import resourceStores from 'quasar-scaffold-host/stores/resourceStores'
import ResourcesToolbar from './Toolbar/ResourcesToolbar.vue'
import Filters from './Filters.vue'
import ActiveFilterSummary from './ActiveFilterSummary.vue'
import RowActions from 'quasar-scaffold/components/ResourceDataTable/RowActions.vue'
import GridSlot from './GridSlot.vue'
import dataTableNeededIdNameMappings from 'quasar-scaffold-host/resourceHelpers/dataTableNeededIdNameMappings'

export default {
  components: { ResourcesToolbar, Filters, ActiveFilterSummary, RowActions, GridSlot },
  props: {
    resourceName: String,
    belongsTo: Object,
    isNested: Boolean,
    gridSlotComponent: Object
  },
  setup (props) {
    const route = useRoute()
    const resource = resourceStores[props.resourceName]()

    const effectiveBelongsTo = computed(() => {
      if (props.belongsTo) return props.belongsTo
      return route.query.belongsTo ? JSON.parse(route.query.belongsTo) : undefined
    })

    const effectiveIsNested = computed(() => props.isNested || !!props.belongsTo)

    onMounted(async () => {
      if (!resource.datatableOptions.modelName) {
        dataTableNeededIdNameMappings[props.resourceName] && await dataTableNeededIdNameMappings[props.resourceName]()
        await resource.load({ pagination: resource.pagination, belongsTo: effectiveBelongsTo.value, isNested: effectiveIsNested.value })
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
