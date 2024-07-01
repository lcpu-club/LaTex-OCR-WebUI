<template>
  <article class="prose dark:prose-invert prose-img:rounded-xl prose-a:text-sky-800 prose-a:dark:text-sky-200 prose-a:font-semibold">
    <h1 id='latex-ocr'>LaTex OCR</h1>
    <h2 id='这是什么'>这是什么？</h2>
    <p>这是基于开源项目<a href='https://github.com/lukas-blecher/LaTeX-OCR'>LaTex-OCR</a>搭建的<strong>公式图片转LaTex数学公式</strong>应用，并额外支持Typst数学表达式，LaTex到Typst的公式转换利用了<a href='https://github.com/mitex-rs/mitex'>mitex</a>构建的WASM文件。算力和技术支持——<a href='https://lcpu.   club/'>北京大学Linux俱乐部</a>。</p>  
    
    <p class="hidden dark:block"><img src="https://s2.loli.net/2024/06/30/Oecf1D6lsbANhUG.png" referrerpolicy="no-referrer" alt="图片.png"></p>

    <p class="block dark:hidden"><img src="https://s2.loli.net/2024/06/30/9FdebHPa6Lw2kyZ.png" referrerpolicy="no-referrer" alt="图片.png"></p>

    <p><strong>请勿上传非数学公式图片，请勿上传过大的文件！</strong></p>
    <h2 id='使用方法'>使用方法</h2>
    <ol start='' >
    <li>使用本地文件：拖拽或点击网页中的文件上传框，选择需要识别的公式图片，目前限制格式为jpg/png，上传后等待获得模型预测结果，结果会自动复制到剪贴板中。</li>
    <li>使用截图：利用截图工具截图后，直接在网页中粘贴，即可自动上传并识别。</li>

    </ol>
    <p>可以在左侧文件框内选择文件查看之前的预测结果，服务器不会保留识别记录，切换页面或刷新网页将会导致历史记录消失。选择框中选择的格式将会被用作自动复制的默认格式，此外仍然可以通过点击按钮的方式进行手动复制。</p>
    <h2 id='识别准确率'>识别准确率</h2>
    <p>实测准确率较高，对于复杂公式能够较好的完成识别，下面是一个成功的例子：</p>
    <p>原图：</p>
    <p><img width="420px" src="https://s2.loli.net/2024/06/30/X2ivRgf9IY3dz4l.png" referrerpolicy="no-referrer" alt="原图1.png"></p>
    <p>识别结果：</p>
    <pre><code class='language-latex' lang='latex'>f(x;\alpha,\beta,c,\mu)=\frac{1}{\pi}\Re\left[\int_{0}^{\infty}e^{i t(x-\mu)}\sum_{n=0}^{\infty}\frac{(-q t^{\alpha})^{n}}{n!}\right]
    </code></pre>
    <p>渲染为：</p>
    <p><img width="420px" src="https://s2.loli.net/2024/06/30/5HzJy32t6gWpEMO.png" referrerpolicy="no-referrer" alt="图片.png"></p>
    <p><strong>实测在少部分情况下会出现预测不准确的情况，经验表明对于简单公式的预测很容易失败，对于长度较短的公式，建议直接手搓。</strong>下面是一个预测失败的例子：</p>
    <p>原图：</p>
    <p><img width="360px" src="https://s2.loli.net/2024/06/30/kfs2Jo8Lzv5gDb7.png" referrerpolicy="no-referrer" alt="原图2.png"></p>
    <p>失败结果：</p>
    <p><img width="360px" src="https://s2.loli.net/2024/06/30/4rtqb8U6wkfE7cG.png" referrerpolicy="no-referrer" alt="图片.png"></p>
    <p>对于多行公式建议分开识别，否则可能需要等待较长时间才能获得识别结果。</p>
    <p>&nbsp;</p>
  </article>
</template>