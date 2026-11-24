export type TaskStatus = 'todo' | 'done'

export interface Task {
  id: string
  user_id: string
  title: string
  description: string | null
  status: TaskStatus
  created_at: string
  updated_at: string
}

export interface TaskStats {
  total: number
  pending: number
  completed: number
}

