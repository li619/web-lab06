const { defineConfig } = require('@vue/cli-service')
module.exports = defineConfig({
  transpileDependencies: true,
  publicPath: process.env.NODE_ENV === 'production'
    ? '/web-lab06/'  // 替换成你的仓库名
    : '/',
  outputDir: 'dist'
})
