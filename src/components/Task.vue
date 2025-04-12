<script>
export default {
  name: 'Task',
  props: {
    title: {
      type: String,
      required: true,
    },
    description: {
      type: String,
      required: true,
    },
    createdBy: {
      type: String,
      required: true,
    },
    createdOn: {
      type: String,
      required: true,
    },
  },
}
</script>

<template>
  <div class="task">
    <h2>{{ title }}</h2>
    <p>{{ description }}</p>
    <div class="meta">
      <p><strong>Created By:</strong> {{ createdBy }}</p>
      <p><strong>Created On:</strong> {{ createdOn }}</p>
    </div>
    <button @click="$emit('delete-task')" class="delete-button">Delete</button>
  </div>
</template>

<style scoped>
.task {
  border: 1px solid #ccc;
  padding: 16px;
  border-radius: 8px;
  margin: 16px 0;
}
.task h2 {
  margin: 0 0 8px;
}
.task .meta p {
  margin: 4px 0;
  font-size: 0.9em;
  color: #555;
}
</style>
