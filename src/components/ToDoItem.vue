<template>
  <div class="todo-item" :class="{ completed: todo.completed, important: todo.important }">
    <div class="todo-content">
      <input 
        type="checkbox" 
        :checked="todo.completed"
        @change="$emit('update', { ...todo, completed: !todo.completed })"
        class="todo-checkbox"
      >
      <input 
        v-if="editing"
        v-model="editText"
        @blur="finishEdit"
        @keyup.enter="finishEdit"
        @keyup.esc="cancelEdit"
        ref="editInput"
        class="edit-input"
      >
      <span v-else class="todo-text" :class="{ completed: todo.completed }">
        {{ todo.text }}
      </span>
    </div>
    
    <div class="actions">
      <!-- 编辑按钮 -->
      <button 
        @click="startEdit" 
        class="btn-edit" 
        v-if="!editing"
        data-tooltip="编辑"
      >
        ✎
      </button>
      <!-- 保存按钮 -->
      <button @click="finishEdit" class="btn-save" v-else>
        ✓
      </button>
      <!-- 重要标记按钮 -->
      <button @click="toggleImportant" class="btn-important">
        <span :class="{ active: todo.important }">★</span>
      </button>
      <!-- 删除按钮 -->
      <button 
        @click="$emit('remove')" 
        class="btn-delete"
        data-tooltip="删除"
      >
        ✕
      </button>
    </div>
  </div>
</template>

<style scoped>
.todo-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px;
  margin: 8px 0;
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  transition: all 0.3s ease;
}

.todo-item:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0,0,0,0.15);
}

.todo-content {
  display: flex;
  align-items: center;
  flex: 1;
  margin-right: 10px;
}

.todo-checkbox {
  margin-right: 12px;
  width: 18px;
  height: 18px;
  cursor: pointer;
}

.todo-text {
  font-size: 16px;
  color: #333;
  flex: 1;
}

.completed {
  text-decoration: line-through;
  color: #888;
}

.important {
  border-left: 4px solid #ff4757;
}

.actions {
  display: flex;
  gap: 8px;
}

.btn-edit,
.btn-save,
.btn-important,
.btn-delete {
  padding: 6px 10px;
  border: none;
  border-radius: 4px;
  background: #f8f9fa;
  cursor: pointer;
  transition: all 0.2s;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 2px;
  font-size: 18px;
  min-width: 32px;
  min-height: 32px;
}

.btn-edit {
  color: #3498db;
}

.btn-edit:hover {
  background: #e3f2fd;
}

.btn-save {
  color: #27ae60;
}

.btn-important {
  color: #f1c40f;
}

.btn-important .active {
  color: #f1c40f;
}

.btn-delete {
  color: #e74c3c;
}

.btn-delete:hover {
  background: #ffebee;
}

.edit-input {
  flex: 1;
  padding: 6px 10px;
  border: 2px solid #3498db;
  border-radius: 4px;
  font-size: 16px;
  outline: none;
}

.edit-input:focus {
  box-shadow: 0 0 0 2px rgba(52, 152, 219, 0.2);
}

.btn-edit::after,
.btn-delete::after {
  position: absolute;
  content: attr(data-tooltip);
  background: rgba(0, 0, 0, 0.8);
  color: white;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  opacity: 0;
  transform: translateY(10px);
  transition: all 0.2s;
  pointer-events: none;
}

.btn-edit:hover::after,
.btn-delete:hover::after {
  opacity: 1;
  transform: translateY(0);
}
</style>

<script>
export default {
  props: {
    todo: {
      type: Object,
      required: true
    }
  },
  data() {
    return {
      editing: false,
      editText: ''
    }
  },
  methods: {
    startEdit() {
      this.editing = true
      this.editText = this.todo.text
      this.$nextTick(() => {
        this.$refs.editInput?.focus()
      })
    },
    finishEdit() {
      if (!this.editText.trim()) {
        this.$emit('remove')
      } else {
        this.$emit('update', {
          ...this.todo,
          text: this.editText.trim()
        })
        this.editing = false
      }
    },
    cancelEdit() {
      this.editing = false
      this.editText = this.todo.text
    },
    toggleImportant() {
      this.$emit('update', {
        ...this.todo,
        important: !this.todo.important
      })
    }
  }
}
</script>
  