<script lang="ts">
import { ref, onMounted } from 'vue'
import { supabase } from '@/lib/supabase'
import { useAuth } from '@/lib/auth'
import Task from '@/components/Task.vue'
import router from '@/router'

export default {
  name: 'DashboardView',
  components: { Task },

  setup() {
    const { user } = useAuth()
    const tasks = ref<any[]>([])
    const loading = ref(true)
    const createTaskDialogVisible = ref(false)
    const updateProfileDialogVisible = ref(false)

    const newTask = ref({
      title: '',
      description: '',
      location_lat: null,
      location_lng: null,
      is_completed: false,
    })

    const profile = ref({
      full_name: '',
      phone: '',
    })

    const fetchTasks = async () => {
      const { data: tasksData, error: tasksError } = await supabase
        .from('tasks')
        .select('*, profiles(full_name)')

      if (tasksError) console.error('Error fetching tasks:', tasksError)
      else {
        tasks.value = tasksData.map((task) => ({
          ...task,
          created_by: task.profiles?.full_name || 'Anonymous',
          created_on: new Date(task.created_on).toLocaleString(),
          owns: task.created_by === user.value?.id,
        }))
      }
      loading.value = false
    }

    const fetchProfile = async () => {
      if (!user.value) return

      const { data, error } = await supabase
        .from('profiles')
        .select('*')
        .eq('id', user.value.id)
        .single()

      if (error) {
        if (error.code === 'PGRST116') {
          const { error: insertError } = await supabase.from('profiles').insert({
            id: user.value.id,
            full_name: '',
            phone: '',
          })
          if (insertError) console.error('Error inserting profile:', insertError)
          else console.log('Profile created')
        } else console.error('Error fetching profile:', error)
      } else profile.value = data
    }

    const logout = async () => {
      const { error } = await supabase.auth.signOut()
      if (error) console.error('Error logging out:', error)
      else router.push('/join')
    }

    const showCreateTaskDialog = () => {
      createTaskDialogVisible.value = true
    }

    const closeCreateTaskDialog = () => {
      createTaskDialogVisible.value = false
      newTask.value = {
        title: '',
        description: '',
        location_lat: null,
        location_lng: null,
        is_completed: false,
      }
    }

    const createTask = async () => {
      if (!user.value) return

      const { error } = await supabase.from('tasks').insert([
        {
          ...newTask.value,
          created_by: user.value.id,
        },
      ])
      if (error) console.error('Error creating task:', error)
      else {
        fetchTasks()
        closeCreateTaskDialog()
      }
    }

    const deleteTask = async (taskId: number) => {
      const { error } = await supabase.from('tasks').delete().eq('id', taskId)
      if (error) console.error('Error deleting task:', error)
      else fetchTasks()
    }

    const showUpdateProfileDialog = async () => {
      if (!user.value) return

      const { data, error } = await supabase
        .from('profiles')
        .select('*')
        .eq('id', user.value.id)
        .single()

      if (error) console.error('Error fetching profile:', error)
      else {
        profile.value = data
        updateProfileDialogVisible.value = true
      }
    }

    const closeUpdateProfileDialog = () => {
      updateProfileDialogVisible.value = false
    }

    const updateProfile = async () => {
      if (!user.value) return

      const { error } = await supabase
        .from('profiles')
        .update({
          full_name: profile.value.full_name,
          phone: profile.value.phone,
        })
        .eq('id', user.value.id)

      if (error) console.error('Error updating profile:', error)
      else closeUpdateProfileDialog()
    }

    onMounted(() => {
      fetchProfile()
      fetchTasks()
    })

    return {
      tasks,
      loading,
      createTaskDialogVisible,
      newTask,
      logout,
      showCreateTaskDialog,
      closeCreateTaskDialog,
      createTask,
      deleteTask,
      updateProfileDialogVisible,
      profile,
      showUpdateProfileDialog,
      closeUpdateProfileDialog,
      updateProfile,
    }
  },
}
</script>

<template>
  <div class="dashboard-view">
    <header class="dashboard-header">
      <h1 class="dashboard-title">Dashboard</h1>
      <div class="header-actions">
        <button @click="showCreateTaskDialog" class="primarybtn">Create Task</button>
        <button @click="showUpdateProfileDialog">Manage Profile</button>
        <button @click="logout" class="warning-button">Log Out</button>
      </div>
    </header>
    <main>
      <h2>Your Tasks</h2>
      <div v-if="loading" class="loading">Loading tasks...</div>
      <div v-else-if="tasks.length === 0" class="no-tasks">No tasks available.</div>
      <div v-else class="tasks-list">
        <Task
          v-for="task in tasks"
          :key="task.id"
          :task="task"
          :owns="task.owns"
          :title="task.title"
          :description="task.description"
          :created-by="task.created_by"
          :created-on="task.created_on"
          @delete-task="deleteTask(task.id)"
        />
      </div>
    </main>

    <div v-if="createTaskDialogVisible" class="dialog">
      <div class="dialog-content">
        <h3>Create Task</h3>
        <form @submit.prevent="createTask">
          <div class="form-group">
            <label for="task-title">Title</label>
            <input type="text" id="task-title" v-model="newTask.title" required />
          </div>
          <div class="form-group">
            <label for="task-description">Description</label>
            <textarea id="task-description" v-model="newTask.description"></textarea>
          </div>
          <div class="form-group">
            <label for="task-location-lat">Latitude</label>
            <input type="number" id="task-location-lat" v-model="newTask.location_lat" step="any" />
          </div>
          <div class="form-group">
            <label for="task-location-lng">Longitude</label>
            <input type="number" id="task-location-lng" v-model="newTask.location_lng" step="any" />
          </div>
          <div class="form-group">
            <label>
              <input type="checkbox" v-model="newTask.is_completed" />
              Mark as Completed
            </label>
          </div>
          <div class="form-actions">
            <button type="submit" class="primarybtn">Create</button>
            <button type="button" @click="closeCreateTaskDialog" class="warning-button">
              Cancel
            </button>
          </div>
        </form>
      </div>
    </div>

    <div v-if="updateProfileDialogVisible" class="dialog">
      <div class="dialog-content">
        <h3>Update Profile</h3>
        <form @submit.prevent="updateProfile">
          <div class="form-group">
            <label for="full-name">Full Name</label>
            <input type="text" id="full-name" v-model="profile.full_name" required />
          </div>
          <div class="form-group">
            <label for="phone">Phone</label>
            <input type="text" id="phone" v-model="profile.phone" />
          </div>
          <div class="form-actions">
            <button type="submit" class="primarybtn">Update</button>
            <button type="button" @click="closeUpdateProfileDialog" class="warning-button">
              Cancel
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<style scoped>
.dashboard-view {
  width: 90vw;
  height: 85vh;
}

.dashboard-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0.1rem 0.1rem;
  border-bottom: 0.1rem solid;
}

.dashboard-title {
  font-size: 3em;
  padding: 0.5rem;
}

.tasks-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(20rem, 1fr));
  gap: 2rem;
}

.loading,
.no-tasks {
  text-align: center;
  margin-top: 3rem;
}

.header-actions {
  display: flex;
  align-items: center;
  gap: 1em;
}

button {
  background-color: #2a4747;
  border: none;
}

button:hover {
  background-color: #315b53;
}

.primarybtn {
  background-color: green;
  color: white;
}

.primarybtn:hover {
  background-color: #218838;
}

.warning-button {
  background-color: #dc3545;
  color: white;
}

.warning-button:hover {
  background-color: #e64555;
}

.dialog {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.dialog-content {
  background-color: rgb(30, 30, 30);
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
  width: 400px;
}

.form-group {
  margin-bottom: 15px;
}

label {
  display: block;
  margin-bottom: 5px;
  font-weight: bold;
}

input,
textarea {
  width: 100%;
  padding: 8px;
  box-sizing: border-box;
  border: 1px solid #ccc;
  border-radius: 4px;
}

textarea {
  resize: vertical;
}

.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 1em;
}
</style>
