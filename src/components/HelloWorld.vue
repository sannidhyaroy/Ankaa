<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'

defineProps<{
  msg: string
  tagline: string
}>()

const count = ref(0)
const router = useRouter()
const login = () => {
  router.push('/login')
}
const join = () => {
  router.push('/join')
}
</script>

<template>
  <h1>{{ msg }}</h1>
  <p>{{ tagline }}</p>

  <div class="card">
    <button class="login" type="button" @click="login()">Log into network</button>
    <button class="join" type="button" @click="join()">Join the network</button>
  </div>

  <p>
    Check out the
    <a href="https://github.com/sannidhyaroy/Ankaa" target="_blank">GitHub repository</a>
    of Ankaa to learn more.
  </p>
  <p class="license">
    Ankaa is licensed under the
    <a
      href="https://github.com/sannidhyaroy/Ankaa/blob/main/LICENSE"
      target="_blank"
      class="license-link"
      >GNU General Public License (GPL) v3.0</a
    >
    license.
  </p>
</template>

<style scoped>
.card {
  display: flex;
  gap: 0.6rem;
  justify-content: center;
}
.join {
  background: #2a4747;
}
.license {
  color: #888;
}
.license-link {
  color: #646cffaa;
}
</style>
