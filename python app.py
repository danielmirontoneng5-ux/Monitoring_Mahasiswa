from flask import Flask, render_template_string, Response, request
import cv2
import os
from datetime import datetime

app = Flask(__name__)

# Kamera
camera = cv2.VideoCapture(0)

# Mode filter
mode = "normal"  # normal | gray | edge

# Folder simpan foto
SAVE_DIR = "hasil_foto"
os.makedirs(SAVE_DIR, exist_ok=True)

def gen_frames():
    global mode
    while True:
        success, frame = camera.read()
        if not success:
            break

        # MODE CERMIN (mirror)
        frame = cv2.flip(frame, 1)

        # FILTER
        if mode == "gray":
            frame = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        elif mode == "edge":
            gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
            frame = cv2.Canny(gray, 100, 200)

        ret, buffer = cv2.imencode('.jpg', frame)
        frame = buffer.tobytes()
        yield (b'--frame\r\n'
               b'Content-Type: image/jpeg\r\n\r\n' + frame + b'\r\n')

HTML_PAGE = """
<!DOCTYPE html>
<html lang=\"id\">
<head>
    <meta charset=\"UTF-8\">
    <title>MK Pengolahan Citra - Pengambilan Foto</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background:#f4f6f8; text-align:center; }
        h1 { color:#2c3e50; }
        .container { margin-top:40px; }
        img { border:6px solid #2c3e50; border-radius:12px; width:480px; }
        button {
            padding:10px 18px; margin:6px;
            border:none; border-radius:8px;
            background:#2c3e50; color:white;
            font-size:14px; cursor:pointer;
        }
        button:hover { background:#1a242f; }
        .footer { margin-top:30px; color:#777; }
    </style>
</head>
<body>
    <div class=\"container\">
        <h1>Website Pengambilan Foto</h1>
        <p>Mata Kuliah: <b>Pengolahan Citra</b></p>

        <img src=\"{{ url_for('video_feed') }}\">

        <div>
            <button onclick=\"setMode('normal')\">Normal</button>
            <button onclick=\"setMode('gray')\">Grayscale</button>
            <button onclick=\"setMode('edge')\">Edge Detection</button>
        </div>

        <div>
            <button onclick=\"capture()\">📸 Capture & Simpan</button>
        </div>

        <p id=\"status\"></p>

        <div class=\"footer\">© 2026 - MK Pengolahan Citra</div>
    </div>

<script>
function setMode(m) {
    fetch('/set_mode/' + m);
}

function capture() {
    fetch('/capture', { method: 'POST' })
    .then(response => response.json())
    .then(data => {
        document.getElementById('status').innerText = data.message;
    });
}
</script>

</body>
</html>
"""

@app.route('/')
def index():
    return render_template_string(HTML_PAGE)

@app.route('/video_feed')
def video_feed():
    return Response(gen_frames(), mimetype='multipart/x-mixed-replace; boundary=frame')

@app.route('/set_mode/<m>')
def set_mode(m):
    global mode
    mode = m
    return ('', 204)

@app.route('/capture')
def capture():
    success, frame = camera.read()
    if success:
        frame = cv2.flip(frame, 1)
        filename = datetime.now().strftime("foto_%Y%m%d_%H%M%S.jpg")
        cv2.imwrite(os.path.join(SAVE_DIR, filename), frame)
    return ('', 204)

if __name__ == '__main__':
    app.run(debug=True)
