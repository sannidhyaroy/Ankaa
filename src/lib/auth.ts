import { ref, onMounted } from 'vue'
import { supabase } from './supabase'

const user = ref<any | null>(null)
const session = ref<any | null>(null)

export function useAuth() {
  const fetchUser = async () => {
    const { data, error } = await supabase.auth.getUser()
    if (data?.user) user.value = data.user
  }

  onMounted(async () => {
    const { data } = await supabase.auth.getSession()
    session.value = data.session
    user.value = data.session?.user ?? null

    supabase.auth.onAuthStateChange((_event, _session) => {
      session.value = _session
      user.value = _session?.user ?? null
    })
  })

  return { user, session }
}
