<script>
export default {
  name: 'Task',
  props: {
    owns: {
      type: Boolean,
      required: true,
    },
    title: {
      type: String,
      required: true,
    },
    description: {
      type: String,
      required: true,
    },
    distance: {
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
    <button
      v-if="owns"
      @click="$emit('delete-task')"
      class="delete-button"
      aria-label="Delete Task"
      title="Delete Task"
    >
      <svg
        xmlns="http://www.w3.org/2000/svg"
        width="25"
        height="20"
        fill="currentColor"
        class="bi bi-trash"
        viewBox="0 0 16 16"
      >
        <path
          d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5m2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5m3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0z"
        />
        <path
          d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4zM2.5 3h11V2h-11z"
        />
      </svg>
    </button>
    <h2>{{ title }}</h2>
    <p>{{ description }}</p>
    <div class="meta">
      <strong v-if="!isNaN(parseFloat(distance))">
        {{ parseFloat(distance).toFixed(2) }} km away
      </strong>
      <p><strong>Created By:</strong> {{ createdBy }}</p>
      <p><strong>Created On:</strong> {{ createdOn }}</p>
    </div>
  </div>
</template>

<style scoped>
.task {
  position: relative;
  border: 1px solid #ccc;
  padding: 2em;
  border-radius: 2em;
}
.task .delete-button {
  position: absolute;
  top: 1em;
  right: 1em;
  background: none;
  border: none;
}
.task .delete-button:hover {
  color: #f00;
}
.task .meta p {
  margin: 4px 0;
  font-size: 0.9em;
  color: #555;
}
</style>
