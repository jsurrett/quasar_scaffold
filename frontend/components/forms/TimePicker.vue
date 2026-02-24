<template>
  <q-input
    v-bind="$attrs"
    :label="label"
    :model-value="modelValue"
    @update:model-value="updateValue"
  >
    <template v-slot:append>
      <q-icon name="access_time" class="cursor-pointer">
        <q-popup-proxy cover transition-show="scale" transition-hide="scale">
          <q-time
            :model-value="modelValue"
            @update:model-value="updateValue"
            mask="HH:mm"
            format24h
          >
            <div class="row items-center justify-end">
              <q-btn v-close-popup label="Close" color="primary" flat />
            </div>
          </q-time>
        </q-popup-proxy>
      </q-icon>
    </template>
  </q-input>
</template>

<script>
export default {
  props: {
    label: String,
    modelValue: {
      type: String,
      default: '',
      required: false
    }
  },
  setup (_props, { emit }) {
    const updateValue = (value, _reason, _details) => {
      emit('update:modelValue', value)
    }

    return {
      updateValue,
    }
  }
}
</script>
