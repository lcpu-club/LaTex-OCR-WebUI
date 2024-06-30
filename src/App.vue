<script setup>
import { RouterLink, RouterView } from 'vue-router'
import { Sunny,Moon } from '@element-plus/icons-vue';
import { onMounted,ref } from 'vue';

const isDark = ref(false);

function changeTheme() {
  const html = document.querySelector('html');
  html.classList.toggle('dark');
  isDark.value = html.classList.contains('dark');
  localStorage.setItem('theme', html.classList.contains('dark') ? 'dark' : 'light');
}

onMounted(() => {
  const html = document.querySelector('html');
  isDark.value = html.classList.contains('dark');
});
</script>

<template>
  <header class="flex flex-row justify-between items-center bg-white/70 dark:bg-black/50 border-b-2 border-slate-300 dark:border-slate-700 py-2 px-4 lg:px-10">
    <h1 class="text-2xl lg:text-3xl font-semibold bg-clip-text text-transparent bg-gradient-to-br from-indigo-500 to-slate-800 dark:from-pink-200 dark:to-slate-200">
      LaTex OCR
    </h1>
    <nav class="text-slate-800 dark:text-slate-200 lg:text-xl flex flex-row items-center space-x-4 lg:space-x-8">
      <RouterLink to="/" active-class="text-sky-800 dark:text-sky-300 font-semibold">OCR</RouterLink>
      <RouterLink to="/about" active-class="text-sky-800 dark:text-sky-300 font-semibold">About</RouterLink>
      <!-- 切换主题颜色的图标 -->
      <button @click="changeTheme" class="pt-2 text-2xl lg:text-3xl">
        <el-icon v-if="isDark">
          <Sunny />
        </el-icon>
        <el-icon v-else>
          <Moon />
        </el-icon>
      </button>
    </nav>
  </header>
  <main>
    <RouterView />
  </main>
</template>