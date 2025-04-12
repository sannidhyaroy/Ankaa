<script setup>
import { ref } from 'vue'
import { supabase } from '../lib/supabase'

const loading = ref(false)
const email = ref('')

const handleLogin = async () => {
  try {
    loading.value = true
    const { error } = await supabase.auth.signInWithOtp({
      email: email.value,
    })
    if (error) throw error
    alert('Check your email for the login link!')
  } catch (error) {
    if (error instanceof Error) {
      alert(error.message)
    }
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="join-view">
    <h1>Join the network</h1>
    <form @submit.prevent="handleLogin">
      <div class="form-group">
        <label for="email">Email ID</label>
        <input type="email" id="email" v-model="email" placeholder="Enter your email" required />
      </div>
      <button type="submit" class="join-button" :disabled="loading">
        {{ loading ? 'Loading' : 'Send magic link' }}
      </button>
    </form>
  </div>
</template>

<style scoped>
.join-view {
  max-width: 400px;
  margin: 0 auto;
  padding: 20px;
  border: 1px solid #ccc;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

h1 {
  text-align: center;
  margin-bottom: 20px;
}

.form-group {
  margin-bottom: 15px;
}

label {
  display: block;
  margin-bottom: 5px;
  font-weight: bold;
}

input {
  width: 100%;
  padding: 8px;
  box-sizing: border-box;
  border: 1px solid #ccc;
  border-radius: 4px;
}

button {
  width: 100%;
  padding: 10px;
  background-color: #2a4747;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

button:hover {
  background-color: #315b53;
}
</style>
