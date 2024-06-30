# 使用官方的 Node.js 运行时作为基础镜像
FROM node:18

# 设置工作目录
WORKDIR /app

# 复制 package.json 和 package-lock.json
COPY package*.json ./

# 安装项目依赖
RUN npm install

# 复制项目代码到工作目录
COPY . .

RUN npm run build

FROM nginx:alpine

# 复制构建好的 Vue.js 应用到 Nginx 的默认静态文件目录
COPY --from=0 /app/dist /usr/share/nginx/html

# 暴露 Nginx 的默认端口
EXPOSE 80

# 启动 Nginx
CMD ["nginx", "-g", "daemon off;"]