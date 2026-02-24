<template>
  <q-toolbar class="bg-primary text-white glossy">
    <q-toolbar-title>{{$t(`resources.${resourceName}`)}}</q-toolbar-title>
    <views-dropdown :resourceName="resourceName" />
    <filters-button :resourceName="resourceName" />
    <reports-dropdown :resourceName="resourceName" />
    <actions-dropdown :resourceName="resourceName" />
  </q-toolbar>
</template>

<script>
import FiltersButton from './FiltersButton.vue'
import ActionsDropdown from './ActionsDropdown.vue'
import ViewsDropdown from './ViewsDropdown.vue'
import ReportsDropdown from './ReportsDropdown.vue'

export default {
  components: {
    FiltersButton,
    ActionsDropdown,
    ReportsDropdown,
    ViewsDropdown
  },
  props: {
    resourceName: String,
  },
}
</script>
