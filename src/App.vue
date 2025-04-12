<script setup>
import { onMounted, ref } from 'vue'
import { RouterView, useRouter } from 'vue-router'
import { supabase } from './lib/supabase'

const session = ref()
const router = useRouter()

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
})
</script>

<template>
  <RouterView />
</template>
