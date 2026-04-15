<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>The Archive Co. | Sign Up</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<%
    String error = request.getParameter("error");
%>

<div class="auth-container">
    <!-- Left: Dark Branding Panel -->
    <div class="auth-dark-panel">
        <div class="logo-section">
            <img src="img/logo-white.svg" class="logo-icon" alt="The Archive Co.">
            <div class="brand-name">The Archive Co.</div>
            <div class="brand-sub">Library</div>
        </div>
        <p class="switch-text">Already have an Account? Sign in now.</p>
        <a href="login.jsp?role=member" class="btn-switch">SIGN IN</a>
    </div>

    <!-- Right: Form Panel -->
    <div class="auth-light-panel">
        <img src="img/logo.svg" class="form-logo" alt="The Archive Co.">
        <h1>Sign Up</h1>
        <p class="form-subtitle">Member registration. Admin accounts are created by existing admins only.</p>

        <% if (error != null) { %>
            <div class="alert alert-error"><%= error %></div>
        <% } %>

        <!-- Member Register Form -->
        <form id="memberForm" class="auth-form" action="MemberRegisterServlet" method="post" onsubmit="return validatePhoto()">
            <div class="form-row">
                <div class="form-group"><input type="text" name="firstName" placeholder="First Name" required></div>
                <div class="form-group"><input type="text" name="lastName" placeholder="Last Name" required></div>
            </div>
            <div class="form-row">
                <div class="form-group"><input type="text" name="contactNo" placeholder="Contact No"></div>
                <div class="form-group"><input type="email" name="email" placeholder="Email" required></div>
            </div>
            <div class="form-row">
                <div class="form-group"><input type="text" name="username" placeholder="Username" required></div>
                <div class="form-group"><input type="password" name="password" placeholder="Password" required></div>
            </div>

            <!-- Face capture -->
            <div class="form-group" style="margin-top:8px">
                <label style="display:block;margin-bottom:6px;font-weight:600;font-size:13px">Capture Face Photo (required for virtual ID)</label>
                <div id="cameraBox" style="border:1px solid #ccc;border-radius:6px;padding:10px;background:#fafafa">
                    <div style="display:flex;gap:10px;align-items:flex-start;flex-wrap:wrap">
                        <video id="camVideo" autoplay playsinline muted style="width:180px;height:135px;background:#000;border-radius:4px;display:block"></video>
                        <canvas id="camCanvas" width="320" height="240" style="display:none"></canvas>
                        <img id="camPreview" alt="Preview" style="width:135px;height:135px;object-fit:cover;border:1px dashed #aaa;border-radius:4px;display:none;background:#eee">
                        <div style="flex:1;min-width:180px">
                            <div id="camStatus" style="font-size:12px;color:#666;margin-bottom:8px">Camera inactive</div>
                            <button type="button" id="camStartBtn" class="btn-borrow" style="width:100%;padding:6px;margin-bottom:6px">Start Camera</button>
                            <button type="button" id="camCaptureBtn" class="btn-borrow" style="width:100%;padding:6px;margin-bottom:6px" disabled>Capture</button>
                            <button type="button" id="camRetakeBtn" class="btn-borrow" style="width:100%;padding:6px;display:none">Retake</button>
                        </div>
                    </div>
                </div>
                <input type="hidden" name="photo" id="photoInput">
            </div>

            <button type="submit" class="btn-primary" id="submitBtn" disabled>SIGN UP</button>
        </form>
    </div>
</div>

<script src="js/main.js"></script>
<script>
var stream = null;
var video = document.getElementById('camVideo');
var canvas = document.getElementById('camCanvas');
var preview = document.getElementById('camPreview');
var statusEl = document.getElementById('camStatus');
var startBtn = document.getElementById('camStartBtn');
var captureBtn = document.getElementById('camCaptureBtn');
var retakeBtn = document.getElementById('camRetakeBtn');
var photoInput = document.getElementById('photoInput');
var submitBtn = document.getElementById('submitBtn');

startBtn.addEventListener('click', async function() {
    if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
        statusEl.textContent = 'Camera not supported by this browser.';
        statusEl.style.color = '#b00';
        return;
    }
    try {
        stream = await navigator.mediaDevices.getUserMedia({ video: { width: 320, height: 240 }, audio: false });
        video.srcObject = stream;
        statusEl.textContent = 'Camera active. Frame your face and Capture.';
        statusEl.style.color = '#080';
        captureBtn.disabled = false;
        startBtn.disabled = true;
    } catch (err) {
        statusEl.textContent = 'Permission denied or camera unavailable: ' + err.message;
        statusEl.style.color = '#b00';
    }
});

captureBtn.addEventListener('click', function() {
    var ctx = canvas.getContext('2d');
    ctx.drawImage(video, 0, 0, canvas.width, canvas.height);
    var dataUrl = canvas.toDataURL('image/jpeg', 0.85);
    photoInput.value = dataUrl;
    preview.src = dataUrl;
    preview.style.display = 'block';
    video.style.display = 'none';
    captureBtn.style.display = 'none';
    retakeBtn.style.display = 'block';
    submitBtn.disabled = false;
    statusEl.textContent = 'Photo captured. You can Retake or Sign Up.';
    statusEl.style.color = '#080';
    if (stream) { stream.getTracks().forEach(function(t){ t.stop(); }); stream = null; }
});

retakeBtn.addEventListener('click', function() {
    preview.style.display = 'none';
    video.style.display = 'block';
    captureBtn.style.display = 'block';
    retakeBtn.style.display = 'none';
    photoInput.value = '';
    submitBtn.disabled = true;
    startBtn.disabled = false;
    statusEl.textContent = 'Click Start Camera to retake.';
    statusEl.style.color = '#666';
});

function validatePhoto() {
    if (!photoInput.value) {
        alert('Please capture a face photo before signing up.');
        return false;
    }
    return true;
}
</script>
</body>
</html>
