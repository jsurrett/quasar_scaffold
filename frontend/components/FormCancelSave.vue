<template>
  <q-card-actions align="right">
    <q-btn :data-testid="`form-cancel-button-${testIdSuffix}`" flat color="red" @click="cancel" :disabled="disabled">{{$t('actions.cancel')}}</q-btn>
    <q-btn :data-testid="`form-save-button-${testIdSuffix}`" flat color="blue" @click="save" :disabled="disabled">{{$t('actions.save')}}</q-btn>
  </q-card-actions>
</template>

<script>
export default {
  props: {
    cancel: Function,
    save: Function,
    disabled: Boolean,
    testIdSuffix: {
      type: String,
      default: ''
    }
  }
}
</script>
