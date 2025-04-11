<script setup lang="ts">
import HelloWorld from '../components/HelloWorld.vue'
</script>

<template>
  <div>
    <a href="https://youtu.be/dQw4w9WgXcQ" target="_blank">
      <img src="../assets/logo.svg" class="logo vue" alt="Vue logo" />
    </a>
  </div>
  <HelloWorld msg="Ankaa" tagline="Bringing neighbours together - one task at a time" />
</template>

<style scoped>
.logo {
  height: 6em;
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
