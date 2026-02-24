<template v-slot:item="props">
  <div
    class="q-pa-xs col-xs-12 col-sm-6 col-md-4 col-lg-3 grid-style-transition"
    :style="props.selected ? 'transform: scale(0.95);' : ''"
  >
    <q-card :class="props.selected ? 'bg-grey-2' : ''">
      <!-- <q-card-section>
        <q-checkbox dense v-model="props.selected" :label="props.row.name" />
      </q-card-section> -->
      <!-- <q-separator /> -->
      <q-list dense>
        <q-item v-for="col in props.cols" :key="col.name">
          <div class="q-table__grid-item-row">
            <div class="q-table__grid-item-title">{{ col.label }}</div>
            <div class="q-table__grid-item-value" >
              <row-actions v-if="col.name === 'actions'" :resourceName="resourceName" :item="props.row" />
              <slot v-else :column="col" :row="props.row">
                {{ col.value }}
              </slot>
            </div>
          </div>
        </q-item>
      </q-list>
    </q-card>
  </div>
</template>

<script>
import RowActions from './RowActions.vue'

export default {
  props: {
    resourceName: String,
    props: Object,
  },
  components: {
    RowActions,
  }
}
</script>
