<script setup lang="ts">
import { onMounted, ref } from 'vue'
import Landing from '../components/Landing.vue'
import Alert from '../components/Alert.vue'
const message = ref({
  text: '',
  type: false,
})

onMounted(() => {
  // Handle error messages from URL
  const urlParams = new URLSearchParams(window.location.hash.substring(1))
  const error = urlParams.get('error')
  const errorDescription = urlParams.get('error_description')

  if (error && errorDescription) {
    message.value.text = decodeURIComponent(errorDescription.replace(/\+/g, ' '))
  }
})
</script>

<template>
  <Alert v-if="message.text" :message="message.text" :isSuccess="message.type" />
  <div>
    <a href="/">
      <img src="../assets/logo.png" class="logo vue" alt="Vue logo" />
    </a>
  </div>
  <Landing msg="Ankaa" tagline="Bringing neighbours together - one task at a time" />
</template>

<style scoped>
.logo {
  height: 12em;
  padding: 1.5em;
  will-change: filter;
  transition: filter 300ms;
}
.logo:hover {
  filter: drop-shadow(0 0 2em #646cffaa);
}
.logo.vue:hover {
  filter: drop-shadow(0 0 2em #42b883aa);
}
</style>
