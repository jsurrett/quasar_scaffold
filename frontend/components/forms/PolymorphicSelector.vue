<template>
  <resource-lazy-select
    v-bind="$attrs"
    :resourceName="modelToResourceMap[modelName]"
  />
</template>

<script>
import ResourceLazySelect from './ResourceLazySelect.vue'

const modelToResourceMap = {
  CarPool: 'car_pools',
  Contact: 'contacts',
  Employee: 'employees',
  Family: 'families',
  Group: 'groups',
  Homeroom: 'homerooms',
  Parent: 'parents',
  SchoolGrade: 'school_grades',
  SchoolLevel: 'school_levels',
  Section: 'sections',
  Student: 'students',
}

export default {
  components: { ResourceLazySelect },
  props: {
    modelName: String
  },
  setup () {
    return {
      modelToResourceMap
    }
  }
}
</script>
