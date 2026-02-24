<template>
  <q-input
    v-bind="$attrs"
    :label="label"
    :model-value="modelValue"
    @update:model-value="updateValue"
  >
    <template v-slot:append>
      <q-icon name="event" class="cursor-pointer">
        <q-popup-proxy ref="datePickerRef" cover transition-show="scale" transition-hide="scale">
          <q-date
            :model-value="modelValue"
            @update:model-value="updateValue"
            mask="YYYY-MM-DD"
          >
            <div class="row items-center justify-end">
              <q-btn v-close-popup label="Close" color="primary" flat />
            </div>
          </q-date>
        </q-popup-proxy>
      </q-icon>
    </template>
  </q-input>
</template>

<script>
import { ref } from 'vue'
export default {
  props: {
    label: String,
    modelValue: {
      type: String,
      default: '',
      required: true
    }
  },
  setup (_props, { emit }) {
    const datePickerRef = ref(null)

    const updateValue = value => {
      datePickerRef.value.hide()
      return emit('update:modelValue', value)
    }

    return {
      updateValue,
      datePickerRef
    }
  }
}
</script>
