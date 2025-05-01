<script lang="ts">
import { ref, onMounted } from 'vue'
import { supabase } from '@/lib/supabase'
import { useAuth } from '@/lib/auth'
import Alert from '@/components/Alert.vue'
import Task from '@/components/Task.vue'
import router from '@/router'
import type { AuthError, PostgrestError } from '@supabase/supabase-js'

export default {
  name: 'DashboardView',
  components: { Alert, Task },

  setup() {
    const { user } = useAuth()
    const tasks = ref<any[]>([])
    const loading = ref(true)
    const createTaskDialogVisible = ref(false)
    const updateProfileDialogVisible = ref(false)

    const alert = ref({
      title: '',
      message: '',
      isSuccess: false,
    })

    const alerts = {
      AuthError: (title: string, error: AuthError) => {
        alert.value.title = title
        alert.value.message = error.message
      },
      PostgrestError: (title: string, error: PostgrestError) => {
        alert.value.title = title
        alert.value.message = error.message
      },
      profileIncomplete: () => {
        alert.value.title = 'Profile details are incomplete.'
        alert.value.message =
          'People might not be able to identify you or reach out to you, as your profile details are incomplete.'
      },
      profileLocationIncomplete: () => {
        alert.value.title = 'Location-based task sorting is disabled!'
        alert.value.message =
          'Your profile details are incomplete. Location-based sorting of tasks rely on profile location and are disabled currently.'
      },
      geolocationNotSupported: () => {
        alert.value.message =
          'Geolocation is not supported by your browser. Please enter coordinates manually.'
      },
      locationNotAvailable: (error: GeolocationPositionError) => {
        alert.value.message = 'Unable to fetch location. Please enter coordinates manually.'
        console.error('Geolocation error:', error)
      },
    }

    const newTask = ref({
      title: '',
      description: '',
      location_lat: null as number | null,
      location_lng: null as number | null,
      is_completed: false,
    })

    const profile = ref({
      full_name: '',
      phone: '',
      location: null as string | null,
      location_lat: null as number | null,
      location_lng: null as number | null,
    })

    const fetchTasks = async () => {
      const { data: tasksData, error: tasksError } = await supabase.rpc(
        'get_sorted_tasks_by_location',
      )

      if (tasksError) {
        alerts.PostgrestError("Something's wrong! Error fetching tasks", tasksError)
        return
      }

      tasks.value = tasksData.map((task: any) => ({
        id: task.id,
        title: task.title,
        description: task.description,
        created_on: new Date(task.created_on).toLocaleString(),
        created_by: task.created_by || 'Anonymous',
        owns: task.self_created,
        distance: task.distance_km,
      }))

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
        } else alerts.PostgrestError("Something's wrong! Error fetching profile", error)
      } else {
        profile.value = data
        if (profile.value.location === null) {
          alerts.profileLocationIncomplete()
        } else if (profile.value.full_name === '' || profile.value.phone === '') {
          alerts.profileIncomplete()
        }
      }
    }

    const logout = async () => {
      const { error } = await supabase.auth.signOut()
      if (error) {
        alerts.AuthError("Oops! We couldn't log you out!", error)
      } else router.push('/join')
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

      const { location_lat, location_lng, ...taskData } = newTask.value

      const location =
        location_lat && location_lng ? `SRID=4326;POINT(${location_lng} ${location_lat})` : null

      const { error } = await supabase.from('tasks').insert([
        {
          ...taskData,
          location,
          created_by: user.value.id,
        },
      ])

      if (error) {
        alerts.PostgrestError("Something's wrong! Error creating task", error)
      } else {
        fetchTasks()
        closeCreateTaskDialog()
      }
    }

    const deleteTask = async (taskId: number) => {
      const { error } = await supabase.from('tasks').delete().eq('id', taskId)
      if (error) alerts.PostgrestError("Something's wrong! Error deleting task", error)
      else fetchTasks()
    }

    const showUpdateProfileDialog = async () => {
      if (!user.value) return

      const { data, error } = await supabase
        .from('profiles')
        .select('*')
        .eq('id', user.value.id)
        .single()

      if (error) alerts.PostgrestError("Something's wrong! Error fetching profile", error)
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

      const { location_lat, location_lng, ...profileData } = profile.value

      const location =
        location_lat && location_lng ? `SRID=4326;POINT(${location_lng} ${location_lat})` : null

      const { error } = await supabase
        .from('profiles')
        .update({
          ...profileData,
          location,
        })
        .eq('id', user.value.id)

      if (error) alerts.PostgrestError("Something's wrong! Error updating profile", error)
      else {
        closeUpdateProfileDialog()
      }
    }

    const fetchLocation = (target: {
      location_lat: number | null
      location_lng: number | null
    }) => {
      if (!navigator.geolocation) {
        alerts.geolocationNotSupported()
        return
      }

      navigator.geolocation.getCurrentPosition(
        (position) => {
          target.location_lat = position.coords.latitude
          target.location_lng = position.coords.longitude
        },
        (error) => {
          alerts.locationNotAvailable(error)
        },
      )
    }

    onMounted(() => {
      fetchProfile()
      fetchTasks()
    })

    return {
      alert,
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
      fetchLocation,
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
    <Alert
      v-if="alert.title || alert.message"
      :title="alert.title"
      :message="alert.message"
      :isSuccess="alert.isSuccess"
    />
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
          :distance="task.distance"
          :created-by="task.created_by"
          :created-on="task.created_on"
          @delete-task="deleteTask(task.id)"
        />
      </div>
    </main>

    <div v-if="createTaskDialogVisible" class="dialog">
      <div class="dialog-content">
        <h2>Create Task</h2>
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
            <button
              type="button"
              @click="fetchLocation(newTask)"
              class="location-button"
              aria-label="Fetch Location"
              title="Fetch Location"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                width="20"
                height="20"
                fill="currentColor"
                class="bi bi-crosshair"
                viewBox="0 0 16 16"
              >
                <path
                  d="M8.5.5a.5.5 0 0 0-1 0v.518A7 7 0 0 0 1.018 7.5H.5a.5.5 0 0 0 0 1h.518A7 7 0 0 0 7.5 14.982v.518a.5.5 0 0 0 1 0v-.518A7 7 0 0 0 14.982 8.5h.518a.5.5 0 0 0 0-1h-.518A7 7 0 0 0 8.5 1.018zm-6.48 7A6 6 0 0 1 7.5 2.02v.48a.5.5 0 0 0 1 0v-.48a6 6 0 0 1 5.48 5.48h-.48a.5.5 0 0 0 0 1h.48a6 6 0 0 1-5.48 5.48v-.48a.5.5 0 0 0-1 0v.48A6 6 0 0 1 2.02 8.5h.48a.5.5 0 0 0 0-1zM8 10a2 2 0 1 0 0-4 2 2 0 0 0 0 4"
                />
              </svg>
            </button>
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
        <h2>Update Profile</h2>
        <form @submit.prevent="updateProfile">
          <div class="form-group">
            <label for="full-name">Full Name</label>
            <input type="text" id="full-name" v-model="profile.full_name" required />
          </div>
          <div class="form-group">
            <label for="phone">Phone</label>
            <input type="text" id="phone" v-model="profile.phone" />
          </div>
          <div class="form-group">
            <label for="profile-location-lat">Latitude</label>
            <input
              type="number"
              id="profile-location-lat"
              v-model="profile.location_lat"
              step="any"
            />
          </div>
          <div class="form-group">
            <label for="profile-location-lng">Longitude</label>
            <input
              type="number"
              id="profile-location-lng"
              v-model="profile.location_lng"
              step="any"
            />
            <button
              type="button"
              @click="fetchLocation(profile)"
              class="location-button"
              title="Fetch Location"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                width="20"
                height="20"
                fill="currentColor"
                class="bi bi-crosshair"
                viewBox="0 0 16 16"
              >
                <path
                  d="M8.5.5a.5.5 0 0 0-1 0v.518A7 7 0 0 0 1.018 7.5H.5a.5.5 0 0 0 0 1h.518A7 7 0 0 0 7.5 14.982v.518a.5.5 0 0 0 1 0v-.518A7 7 0 0 0 14.982 8.5h.518a.5.5 0 0 0 0-1h-.518A7 7 0 0 0 8.5 1.018zm-6.48 7A6 6 0 0 1 7.5 2.02v.48a.5.5 0 0 0 1 0v-.48a6 6 0 0 1 5.48 5.48h-.48a.5.5 0 0 0 0 1h.48a6 6 0 0 1-5.48 5.48v-.48a.5.5 0 0 0-1 0v.48A6 6 0 0 1 2.02 8.5h.48a.5.5 0 0 0 0-1zM8 10a2 2 0 1 0 0-4 2 2 0 0 0 0 4"
                />
              </svg>
            </button>
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

.location-button {
  background: none;
  border: none;
  cursor: pointer;
}

.location-button:hover {
  background: none;
  color: #42b883;
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
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  padding: 20px;
  border-radius: 2em;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
  width: 35vw;
  border: 1px solid rgba(255, 255, 255, 0.2);
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
  border-radius: 1em;
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
