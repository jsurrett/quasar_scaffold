<template>
  <edit-resource
    :id="id"
    :resourceName="resourceName"
  >
    <resource-schema-form
      :id="id"
      :resourceName="resourceName"
      :schemaBase="schemaBase"
      :belongsTo="belongsTo"
    />
  </edit-resource>
</template>

<script>
import ResourceSchemaForm from 'quasar-scaffold/components/ResourceSchemaForm.vue'
import EditResource from 'quasar-scaffold/components/EditResource.vue'
import { defineComponent } from 'vue'

export default defineComponent({
  components: {
    EditResource,
    ResourceSchemaForm
  },
  props: {
    resourceName: String,
    id: [Number, String],
    belongsTo: Object,
    schemaBase: {
      type: Object,
      default: () => ({})
    }
  }
})
</script>
