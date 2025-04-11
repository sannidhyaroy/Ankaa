<script>
import { ref } from 'vue'

export default {
  name: 'JoinView',
  setup() {
    const form = ref({
      name: '',
      email: '',
      password: '',
    })

    const handleSignup = () => {
      // TODO: Add signup logic here (remove console.log statements)
      console.log('Name:', form.value.name)
      console.log('Email:', form.value.email)
      console.log('Password:', form.value.password)
    }

    return {
      form,
      handleSignup,
    }
  },
}
</script>

<template>
  <div class="join-view">
    <h1>Join Us</h1>
    <form @submit.prevent="handleSignup">
      <div class="form-group">
        <label for="name">Name</label>
        <input type="text" id="name" v-model="form.name" placeholder="Enter your name" required />
      </div>
      <div class="form-group">
        <label for="email">Email</label>
        <input
          type="email"
          id="email"
          v-model="form.email"
          placeholder="Enter your email"
          required
        />
      </div>
      <div class="form-group">
        <label for="password">Password</label>
        <input
          type="password"
          id="password"
          v-model="form.password"
          placeholder="Enter your password"
          required
        />
      </div>
      <button type="submit" class="join-button">Join</button>
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
