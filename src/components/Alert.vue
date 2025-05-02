<script setup>
import { defineProps } from 'vue'

defineProps({
  title: String,
  message: String,
  isSuccess: Boolean,
})
</script>

<template>
  <div
    v-if="title || message"
    class="alert-container"
    :class="isSuccess ? 'green-alert' : 'red-alert'"
  >
    <h3 v-if="title" class="alert-title">{{ title }}</h3>
    <p v-if="message" class="alert-message">{{ message }}</p>
  </div>
</template>

<style scoped>
.alert-container {
  max-width: 80vw;
  margin: 0.5em auto;
  padding: 0.3em;
  border-radius: 1em;
  background-color: rgba(255, 255, 255, 0.2);
}
.green-alert {
  background-color: rgba(0, 128, 0, 0.2);
}
.red-alert {
  background-color: rgba(255, 181, 181, 0.2);
}
.alert-title {
  text-align: center;
  font-size: 1.25em;
}
.alert-message {
  text-align: center;
  margin: 1em 0;
}
</style>
