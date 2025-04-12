<script setup>
import { onMounted, ref } from 'vue'
import { RouterView, useRouter } from 'vue-router'
import { supabase } from './lib/supabase'

const session = ref()
const router = useRouter()
const message = ref('')

onMounted(() => {
  supabase.auth.getSession().then(({ data }) => {
    session.value = data.session
    if (session.value) {
      router.push('/dashboard') // Redirect to Dashboard if logged in
    }
  })

  supabase.auth.onAuthStateChange((_, _session) => {
    session.value = _session
    if (_session) {
      router.push('/dashboard') // Redirect to Dashboard on login
    }
  })

  // Handle error messages from URL
  const urlParams = new URLSearchParams(window.location.hash.substring(1))
  const error = urlParams.get('error')
  const errorDescription = urlParams.get('error_description')

  if (error && errorDescription) {
    message.value = decodeURIComponent(errorDescription.replace(/\+/g, ' '))
  }
})
</script>

<template>
  <div v-if="message" class="message-container">
    <p class="message-text">{{ message }}</p>
  </div>
  <RouterView :key="$route.fullPath" />
</template>

<style scoped>
.message-container {
  max-width: 80vw;
  margin: 0.5em auto;
  padding: 0.3em;
  border-radius: 1em;
  background-color: rgba(255, 181, 181, 0.2);
}
.message-text {
  text-align: center;
  margin: 1em 0;
}
</style>
