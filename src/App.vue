<template>
  <div class="app-container">
    <h1>我的待办事项</h1>
    
    <div class="add-todo">
      <input 
        v-model="newTodo"
        @keyup.enter="addTodo"
        placeholder="添加新的待办事项..."
        class="add-input"
      >
      <button @click="addTodo" class="add-button">添加</button>
    </div>

    <div class="filters">
      <button 
        v-for="filter in filters" 
        :key="filter.value"
        @click="currentFilter = filter.value"
        :class="{ active: currentFilter === filter.value }"
        class="filter-btn"
      >
        {{ filter.label }}
      </button>
    </div>

    <div class="todo-list">
      <TransitionGroup name="list">
        <ToDoItem
          v-for="todo in filteredTodos"
          :key="todo.id"
          :todo="todo"
          @remove="removeTodo(todo)"
          @update="updateTodo"
        />
      </TransitionGroup>
    </div>

    <div class="todo-stats">
      <span>总计: {{ todos.length }}</span>
      <span>已完成: {{ completedCount }}</span>
      <span>未完成: {{ activeCount }}</span>
    </div>
  </div>
</template>

<style scoped>
.app-container {
  max-width: 600px;
  margin: 0 auto;
  padding: 20px;
}

.add-todo {
  display: flex;
  margin-bottom: 20px;
}

.add-input {
  flex: 1;
  padding: 10px;
  border: 2px solid #3498db;
  border-radius: 8px 0 0 8px;
  font-size: 16px;
}

.add-button {
  padding: 10px 20px;
  background: #3498db;
  color: white;
  border: none;
  border-radius: 0 8px 8px 0;
  cursor: pointer;
  transition: background 0.3s;
}

.add-button:hover {
  background: #2980b9;
}

.filters {
  margin-bottom: 20px;
  display: flex;
  gap: 10px;
}

.filter-btn {
  padding: 8px 16px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  background: #f1f1f1;
}

.filter-btn.active {
  background: #3498db;
  color: white;
}

.todo-stats {
  margin-top: 20px;
  display: flex;
  justify-content: space-around;
  padding: 10px;
  background: #f8f9fa;
  border-radius: 8px;
}

.list-enter-active,
.list-leave-active {
  transition: all 0.5s ease;
}

.list-enter-from,
.list-leave-to {
  opacity: 0;
  transform: translateX(30px);
}
</style>

<script>
import ToDoItem from './components/ToDoItem.vue'

export default {
  components: {
    ToDoItem
  },
  data() {
    return {
      newTodo: '',
      todos: [],
      currentFilter: 'all',
      filters: [
        { label: '全部', value: 'all' },
        { label: '待完成', value: 'active' },
        { label: '已完成', value: 'completed' }
      ]
    }
  },
  computed: {
    filteredTodos() {
      switch (this.currentFilter) {
        case 'completed':
          return this.todos.filter(todo => todo.completed)
        case 'active':
          return this.todos.filter(todo => !todo.completed)
        default:
          return this.todos
      }
    },
    completedCount() {
      return this.todos.filter(todo => todo.completed).length
    },
    activeCount() {
      return this.todos.filter(todo => !todo.completed).length
    }
  },
  methods: {
    addTodo() {
      if (!this.newTodo.trim()) return
      this.todos.push({
        id: Date.now(),
        text: this.newTodo.trim(),
        completed: false,
        important: false
      })
      this.newTodo = ''
    },
    removeTodo(todo) {
      const index = this.todos.indexOf(todo)
      if (index > -1) {
        this.todos.splice(index, 1)
      }
    },
    updateTodo(todo) {
      const index = this.todos.findIndex(t => t.id === todo.id)
      if (index > -1) {
        this.todos[index] = todo
      }
    }
  }
}
</script>
