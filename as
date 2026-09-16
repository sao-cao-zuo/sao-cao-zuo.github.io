<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>我的个人站点</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      user-select: none;
    }
    body {
      font-family: system-ui, sans-serif;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      color: #fff;
    }
    /* 密码验证弹窗样式 */
    .password-modal {
      position: fixed;
      top: 0;
      left: 0;
      width: 100vw;
      height: 100vh;
      background: rgba(0,0,0,0.85);
      display: flex;
      align-items: center;
      justify-content: center;
      z-index: 999999;
    }
    .password-box {
      background: rgba(255,255,255,0.15);
      backdrop-filter: blur(16px);
      padding: 48px;
      border-radius: 16px;
      text-align: center;
      width: 90%;
      max-width: 420px;
    }
    .password-box h2 {
      margin-bottom: 24px;
      font-size: 24px;
    }
    .password-box input {
      width: 100%;
      padding: 14px 16px;
      border: none;
      border-radius: 8px;
      font-size: 16px;
      margin-bottom: 20px;
      outline: none;
    }
    .password-box .submit-btn {
      width: 100%;
      padding: 14px;
      background: #fff;
      color: #667eea;
      border: none;
      border-radius: 8px;
      font-weight: 600;
      font-size: 16px;
      cursor: pointer;
      transition: 0.3s;
    }
    .password-box .submit-btn:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 24px rgba(0,0,0,0.15);
    }
    .password-box .error-tip {
      margin-top: 12px;
      color: #ff6b6b;
      font-size: 14px;
      display: none;
    }
    /* 站点主内容默认隐藏，验证通过后才显示 */
    .site-content {
      display: none;
    }
    .container {
      background: rgba(255,255,255,0.15);
      backdrop-filter: blur(12px);
      padding: 48px;
      border-radius: 16px;
      text-align: center;
      width: 90%;
      max-width: 600px;
    }
    h1 {
      font-size: 36px;
      margin-bottom: 16px;
    }
    p {
      font-size: 18px;
      margin-bottom: 32px;
      line-height: 1.6;
    }
    .btn-group {
      display: flex;
      flex-direction: column;
      gap: 16px;
    }
    .btn {
      display: inline-block;
      padding: 14px 32px;
      background: #fff;
      color: #667eea;
      text-decoration: none;
      border-radius: 8px;
      font-weight: 600;
      transition: 0.3s;
    }
    .btn:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 24px rgba(0,0,0,0.15);
    }
    @media print {
      body {
        display: none !important;
      }
    }
  </style>
</head>
<body>
  <!-- 密码验证层 -->
  <div class="password-modal" id="passwordModal">
    <div class="password-box">
      <h2>请输入访问密码</h2>
      <input type="password" id="passwordInput" placeholder="输入站点访问密码">
      <button class="submit-btn" id="passwordSubmit">确认进入</button>
      <div class="error-tip" id="errorTip">密码错误，请重新输入</div>
    </div>
  </div>

  <!-- 站点主内容，验证通过后才会显示 -->
  <div class="site-content" id="siteContent">
    <div class="container">
      <h1>无聊的玩具</h1>
      <p>欢迎来到我的个人站点。</p>
      <div class="btn-group">
        <a href="#" class="btn">查看我的项目作品</a>
        <a href="3d-print-report.html" class="btn">3D打印工程实践实验报告</a>
      </div>
    </div>
  </div>

  <script>
    // ========== 在这里修改你的站点访问密码 ==========
    const SITE_PASSWORD = 'beihang2026'

    // 密码验证逻辑
    const passwordModal = document.getElementById('passwordModal')
    const siteContent = document.getElementById('siteContent')
    const passwordInput = document.getElementById('passwordInput')
    const passwordSubmit = document.getElementById('passwordSubmit')
    const errorTip = document.getElementById('errorTip')

    // 检查本地缓存，验证通过过的用户7天内不用重复输入密码
    const checkLocalAuth = () => {
      const authExpire = localStorage.getItem('siteAuthExpire')
      if(authExpire && Date.now() < parseInt(authExpire)) {
        unlockSite()
        return true
      }
      return false
    }

    const unlockSite = () => {
      passwordModal.style.display = 'none'
      siteContent.style.display = 'flex'
      // 验证通过后才加载防截屏防护逻辑，避免密码页就生成水印
      loadAntiScreenshotProtection()
    }

    passwordSubmit.addEventListener('click', () => {
      if(passwordInput.value.trim() === SITE_PASSWORD) {
        // 写入7天有效期的本地授权标记
        localStorage.setItem('siteAuthExpire', Date.now() + 7 * 24 * 60 * 60 * 1000)
        unlockSite()
      } else {
        errorTip.style.display = 'block'
        passwordInput.value = ''
      }
    })

    // 支持按回车键直接提交密码
    passwordInput.addEventListener('keydown', e => {
      if(e.key === 'Enter') passwordSubmit.click()
    })

    // 页面加载时自动检查授权状态
    window.addEventListener('load', () => {
      if(!checkLocalAuth()) {
        passwordInput.focus()
      }
    })

    // 完整防截屏防护逻辑，仅在验证通过后加载
    function loadAntiScreenshotProtection() {
      // 1. 禁用右键菜单
      document.addEventListener('contextmenu', e => e.preventDefault())

      // 2. 拦截截屏、调试类快捷键
      document.addEventListener('keydown', e => {
        const blockKeys = [44, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123]
        if(blockKeys.includes(e.keyCode)) {
          e.preventDefault()
          return false
        }
        if(e.ctrlKey && e.shiftKey && ['I','S','J'].includes(e.key.toUpperCase())) {
          e.preventDefault()
          return false
        }
      })

      // 3. 动态全屏溯源水印
      const createAntiScreenshotWatermark = () => {
        const watermarkCanvas = document.createElement('canvas')
        watermarkCanvas.style.cssText = `
          position: fixed;
          top: 0;
          left: 0;
          width: 100vw;
          height: 100vh;
          z-index: 99999;
          pointer-events: none;
        `
        document.body.appendChild(watermarkCanvas)
        const ctx = watermarkCanvas.getContext('2d')
        
        const renderWatermark = () => {
          watermarkCanvas.width = window.innerWidth * window.devicePixelRatio
          watermarkCanvas.height = window.innerHeight * window.devicePixelRatio
          ctx.clearRect(0, 0, watermarkCanvas.width, watermarkCanvas.height)
          ctx.globalAlpha = 0.08
          ctx.font = `${16 * window.devicePixelRatio}px Microsoft YaHei`
          ctx.fillStyle = '#000'
          ctx.rotate(-Math.PI / 12)
          const watermarkText = `访问时间: ${new Date().toLocaleString()} | 设备ID: ${navigator.userAgent.slice(0,12)}`
          for(let i = 0; i < watermarkCanvas.width; i += 250 * window.devicePixelRatio) {
            for(let j = 0; j < watermarkCanvas.height; j += 180 * window.devicePixelRatio) {
              const offsetX = (Math.random() - 0.5) * 40 * window.devicePixelRatio
              const offsetY = (Math.random() - 0.5) * 40 * window.devicePixelRatio
              ctx.fillText(watermarkText, i + offsetX, j + offsetY)
            }
          }
        }
        renderWatermark()
        setInterval(renderWatermark, 300)
        window.addEventListener('resize', renderWatermark)
      }
      createAntiScreenshotWatermark()

      // 4. 页面失焦自动模糊敏感内容
      document.addEventListener('visibilitychange', () => {
        if(document.hidden) {
          document.body.style.filter = 'blur(20px)'
        } else {
          document.body.style.filter = 'blur(0px)'
        }
      })
    }
  </script>
</body>
</html>
