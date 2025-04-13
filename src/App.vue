<script setup>
import { useAuth } from './lib/auth'
import { RouterView, useRouter } from 'vue-router'
import { watch } from 'vue'

const { user } = useAuth() // Use the composable for user state
const router = useRouter()

// Watch for changes in the user state and handle routing
watch(user, (_user) => {
  if (_user) {
    router.push('/dashboard') // Redirect to Dashboard if logged in
  }
})
</script>

<template>
  <RouterView :key="$route.fullPath" />
</template>
