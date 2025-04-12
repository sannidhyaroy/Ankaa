<script setup>
import { onMounted, ref } from 'vue'
import { RouterView } from 'vue-router'
import { supabase } from './lib/supabase'

const session = ref()

onMounted(() => {
  supabase.auth.getSession().then(({ data }) => {
    session.value = data.session
  })

  supabase.auth.onAuthStateChange((_, _session) => {
    session.value = _session
  })
})
</script>

<template>
  <RouterView />
</template>
