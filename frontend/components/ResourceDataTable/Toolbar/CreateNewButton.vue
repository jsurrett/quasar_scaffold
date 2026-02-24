<template>
  <q-btn
    size="sm"
    @click="gotoNew()"
    color="blue"
    :label="$q.screen.gt.sm ? $t('datatable.createNew') : void 0"
    icon="mdi-plus-circle"
    data-testid="create-new-button"
  />
</template>

<script>
import { useRouter, useRoute } from 'vue-router'

export default {
  setup () {
    const router = useRouter()
    const route = useRoute()

    const gotoNew = () => router.push({ path: `${route.path}/new` })

    return {
      gotoNew,
    }
  }
}
</script>

<style scoped>
  button {
    margin: 0px 3px;
  }
</style>
