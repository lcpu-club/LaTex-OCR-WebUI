<script setup>
import { UploadFilled,CopyDocument } from '@element-plus/icons-vue'
import { computed, onMounted, ref,watch } from 'vue';

const currentFile = ref(null);
const imageURL = ref('');
let uploader = ref(null);

function handleChange(file, fileList) {
  currentFile.value = file;
}
function handleSelect(file) {
  currentFile.value = file;
}
function handleError(err) {
  console.log(err);
  ElMessage({
    message: '服务接口调用失败',
    type: 'error',
  })
}

async function copyResponse() {
  try {
    await navigator.clipboard.writeText(currentFile.value.response);
    console.log('response copied');
    ElMessage({
      message: '公式已复制到剪贴板',
      type: 'success',
    })
  } catch (err) {
    ElMessage({
      message: '公式复制失败',
      type: 'error',
    })
  }
}

function beforeUpload(file) {
  const isJPG = file.type === 'image/jpeg' || file.type === 'image/png';
  const isLt1M = file.size / 1024 / 1024 < 1;
  if (!isJPG) {
    ElMessage.error('上传图片只能是 JPG/PNG 格式!');
  }
  if (!isLt1M) {
    ElMessage.error('上传图片大小不能超过 1MB!');
  }
  return isJPG && isLt1M;
}

const generateFormula = computed(() => {
  if (currentFile.value.response) {
    return '$$ '+currentFile.value.response+' $$';
  }
  return '';
});
// watch currentFile
watch(currentFile, (newFile) => {
  if (newFile) {
    imageURL.value = URL.createObjectURL(newFile.raw);
  }
});

onMounted(() => {
  // 注入mathjax
  const script = document.createElement('script');
  // script.src = 'https://unpkg.com/mathjax@3/es5/tex-mml-chtml.js';
  script.src = 'https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.2/MathJax.js?config=TeX-AMS_HTML';
  script.async = true;
  document.head.appendChild(script);
  // 监听粘贴操作，识别到粘贴图片时调用uploader的handleStart方法上传文件
  document.addEventListener('paste', async (e) => {
    // 获取最近粘贴的文件
    const item = e.clipboardData.items[e.clipboardData.items.length - 1];
    if (item.kind === 'file') {
      const file = item.getAsFile();
      // 上传文件
      await uploader.value.handleStart(file)
      await uploader.value.submit();
    }
  });
});
</script>

<template>
  <div class="flex lg:grid flex-col lg:grid-cols-2 items-center px-10 space-x-10 justify-items-center mt-20">
    <el-upload
      drag
      class="my-10 w-full"
      action="/api/predict/"
      ref="uploader"
      :on-preview="handleSelect"
      :on-change="handleChange"
      :on-success="copyResponse"
      :on-error="handleError"
      :before-upload="beforeUpload"
      multiple
    >
      <el-icon class="el-icon--upload"><upload-filled /></el-icon>
      <div class="el-upload__text">
        Drop file here or <em>click to upload</em> or <p class="font-semibold">press ctrl+v</p>
      </div>
      <template #tip>
        <div class="el-upload__tip">
          jpg/png files with a size less than 1MB
        </div>
      </template>
    </el-upload>
    <!-- 图片展示 -->
    <div v-if="currentFile" class="w-full flex flex-col items-center">
      <!-- 展示currentFile.raw图片，raw为文件流 -->
      <h2 class="text-xl font-semibold mb-4">Original Image: </h2>
      <img :src="imageURL" alt="" />
      <div v-if="currentFile.response" class="w-full flex flex-col items-center px-10">
        <!-- 使用mathjax展示公式 -->
        <h2 class="text-xl font-semibold mt-4">Prediction Results: </h2>
        <!-- 复制框 -->
        <div class="flex items-center w-full my-4 mb-10">
          <el-input type="textarea" autosize readonly v-model="currentFile.response"  class="w-full font-serif text-2xl" />
          <div class="roundex-2xl px-2 py-1 ml-2 bg-blue-200 dark:bg-blue-800 cursor-pointer" @click="copyResponse">
            <el-icon><CopyDocument /></el-icon>
          </div>
        </div>
        <!-- 调用mathjaxqueue函数实现响应式数据渲染 -->
        <VueMathjax :formula="generateFormula" />
      </div>
    </div>
  </div>
</template>