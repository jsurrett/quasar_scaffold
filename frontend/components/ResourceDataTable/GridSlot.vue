<template v-slot:item="props">
  <div
    class="q-pa-md col-xs-12 col-sm-6 col-md-4 col-lg-3 grid-style-transition"
    :style="props.selected ? 'transform: scale(0.95);' : ''"
  >
    <q-card
      :class="props.selected ? 'bg-primary text-white shadow-8' : 'bg-grey-1 shadow-2'"
      rounded
    >
      <q-card-section class="q-pb-xs">
        <div class="row justify-between items-start">
          <div class="col"></div>
          <div v-if="props.cols.some(col => col.name === 'actions')" class="col-auto q-ml-md">
            <row-actions
              :resourceName="resourceName"
              :item="props.row"
            />
          </div>
        </div>
      </q-card-section>

      <q-card-section class="q-pt-sm">
        <div
          v-for="(col, index) in props.cols.filter(c => c.name !== 'actions')"
          :key="col.name"
          :class="index < props.cols.length - 2 ? 'q-mb-lg' : ''"
        >
          <div class="text-caption text-weight-bold" :class="props.selected ? 'text-white' : 'text-grey-7'">
            {{ col.label }}
          </div>
          <div class="text-body2 text-weight-medium q-mt-xs">
            <slot :column="col" :row="props.row">
              {{ col.value }}
            </slot>
          </div>
        </div>
      </q-card-section>
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
