<script setup>
import { defineProps } from 'vue'

defineProps({
  message: String,
  isSuccess: Boolean,
})
</script>

<template>
  <div
    v-if="message"
    class="message-container"
    :class="isSuccess ? 'success-message' : 'failure-message'"
  >
    <p class="message-text">{{ message }}</p>
  </div>
</template>

<style scoped>
.message-container {
  max-width: 80vw;
  margin: 0.5em auto;
  padding: 0.3em;
  border-radius: 1em;
  background-color: rgba(255, 255, 255, 0.2);
}
.success-message {
  background-color: rgba(0, 128, 0, 0.2);
}
.failure-message {
  background-color: rgba(255, 181, 181, 0.2);
}
.message-text {
  text-align: center;
  margin: 1em 0;
}
</style>
