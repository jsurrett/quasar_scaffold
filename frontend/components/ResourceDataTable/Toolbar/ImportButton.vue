<template>
  <q-btn
    size="sm"
    @click="gotoImport"
    color="blue"
    :label="$q.screen.gt.sm ? $t('datatable.import') : void 0"
    icon="mdi-import"
  />
</template>

<script>
import { useRoute, useRouter } from 'vue-router'

export default {
  setup () {
    const route = useRoute()
    const router = useRouter()

    const gotoImport = () => {
      router.push({ path: `${route.fullPath}/import` })
    }

    return {
      gotoImport,
    }
  }
}
</script>

<style scoped>
  button {
    margin: 0px 3px;
  }
</style>
