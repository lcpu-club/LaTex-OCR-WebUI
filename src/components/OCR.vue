<script setup>
import { UploadFilled,CopyDocument } from '@element-plus/icons-vue'
import { computed, onMounted, ref,watch } from 'vue';
import { convert_math } from "mitex-wasm";

const currentFile = ref(null);
const imageURL = ref('');
const typstFormula = ref('');
const isError = ref(false)
const language = ref('LaTex');
let uploader = ref(null);

function handleProgress() {
  currentFile.value = null;
}
function handleChange(file, fileList) {
  currentFile.value = file;
}
function handleSelect(file) {
  isError.value = false
  currentFile.value = file;
  typstFormula.value = convert_math(file.response,new Uint8Array())
}
function handleError(err) {
  console.log(err);
  ElMessage({
    message: '服务接口调用失败',
    type: 'error',
  })
}

async function handleSuccess(response) {
  try{
    typstFormula.value = await convert_math(response,new Uint8Array());
  }
  catch (err) {
    ElMessage({
      message: '公式转换失败，预测结果有格式错误',
      type: 'error',
    })
    isError.value = true;
    return;
  }
  if (language.value === 'LaTex') {
    copyResponse(1);
  }
  else {
    copyResponse(2);
  }
}

async function copyResponse(id) {
  try {
    if (id === 1) {
      await navigator.clipboard.writeText(currentFile.value.response);
      console.log('response copied');
      ElMessage({
        message: '公式已复制到剪贴板',
        type: 'success',
      })
    } else {
      await navigator.clipboard.writeText(typstFormula.value);
      console.log('response copied');
      ElMessage({
        message: '公式已复制到剪贴板',
        type: 'success',
      })
    }
  } catch (err) {
    ElMessage({
      message: '公式复制失败',
      type: 'error',
    })
  }
}

function beforeUpload(file) {
  isError.value = false;
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
watch(language, (newLanguage) => {
  localStorage.setItem('formulalanguage', newLanguage);
});

onMounted(() => {
  // 注入mathjax
  const script = document.createElement('script');
  // script.src = 'https://unpkg.com/mathjax@3/es5/tex-mml-chtml.js';
  script.src = 'https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.2/MathJax.js?config=TeX-AMS_HTML';
  script.async = true;
  if (localStorage.getItem('formulalanguage')) {
    language.value = localStorage.getItem('formulalanguage');
  }
  document.head.appendChild(script);
  // 监听粘贴操作，识别到粘贴图片时调用uploader的handleStart方法上传文件，只上传最近的一个文件
  document.addEventListener('paste', async (e) => {
    
  });
  document.addEventListener('paste', async (e) => {
    e.preventDefault();
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
  <div class="flex lg:grid flex-col lg:grid-cols-2 items-center justify-items-center px-10 space-x-10 mt-20">
    <el-upload
      drag
      class="my-10 w-full self-start"
      action="/latex-ocr/api/predict/"
      ref="uploader"
      :on-preview="handleSelect"
      :on-change="handleChange"
      :on-success="handleSuccess"
      :on-error="handleError"
      :on-progress="handleProgress"
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
    <div class="w-full flex flex-col items-center">
      <!-- 展示currentFile.raw图片，raw为文件流 -->
      <h2 class="text-xl font-semibold mb-4">Original Image: </h2>
      <img v-if="currentFile" :src="imageURL" alt="" />
      <!-- 骨架屏 -->
      <el-skeleton v-else class="w-full mt-12 px-10">
        <template #template>
          <el-skeleton-item variant="image" style="height: 80px;"/>
        </template>
      </el-skeleton>
      <div class="w-full flex flex-col items-center px-10 mb-20">
        <!-- 使用mathjax展示公式 -->
        <h2 class="text-xl font-semibold mt-4">Prediction Results: </h2>
        <!-- 复制框 -->
        <div class="flex flex-row w-full items-center space-x-4">
          <h3 class="text-nowrap mt-4">Default Copy Format: </h3>
          <el-select
            v-model="language"
            placeholder="Select Format"
            size="large"
            class="w-full mt-4"
          >
            <el-option value="LaTex"/>
            <el-option value="Typst"/>
          </el-select>
        </div>
        <template v-if="currentFile">
          <h3  class="mt-2 text-sm">LaTex</h3>
          <div class="flex items-center w-full my-4">
            <el-input type="textarea" v-if="currentFile.response" autosize readonly v-model="currentFile.response"  class="w-full font-serif text-2xl" />
            <div v-if="currentFile.response" class="roundex-2xl px-2 py-1 ml-2 bg-blue-100 dark:bg-blue-800 cursor-pointer" @click="copyResponse(1)">
              <el-icon><CopyDocument /></el-icon>
            </div>
          </div>
          <!-- typst -->
          <h3 class="mb-2 text-sm">Typst</h3>
          <div class="flex items-center w-full mb-10">
            <el-input type="textarea" autosize readonly class="w-full font-serif text-2xl" v-model="typstFormula" />
            <div class="roundex-2xl px-2 py-1 ml-2 bg-blue-100 dark:bg-blue-800 cursor-pointer" @click="copyResponse(2)">
              <el-icon><CopyDocument /></el-icon>
            </div>
          </div>
          <!-- 调用mathjaxqueue函数实现响应式数据渲染 -->
          <!-- 如果isError -->
          <div v-if="isError" class="w-full text-center text-red-500 font-semibold">Error: Invalid Format</div>
          <VueMathjax v-else :formula="generateFormula" />
        </template>
        <!-- 图片骨架 -->
        <el-skeleton v-else class="w-full mt-12">
          <template #template>
            <el-skeleton-item variant="image" style="height: 80px;"/>
          </template>
        </el-skeleton>
      </div>
    </div>
  </div>
</template>