from flask import Flask, render_template, request, redirect, session
import mysql.connector
from datetime import date

app = Flask(__name__)
app.secret_key = "secret123"

# ================= DATABASE =================
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="",
    database="db_monitoring_mahasiswa"
)

# ================= CEK ROLE =================
def cek_role(role):
    return "role" in session and session["role"] == role


# ================= LOGIN =================
@app.route("/", methods=["GET", "POST"])
def login():

    if request.method == "POST":

        email = request.form["email"]
        password = request.form["password"]

        cursor = db.cursor(dictionary=True, buffered=True)

        cursor.execute("""
            SELECT * FROM users
            WHERE email=%s AND password=%s
        """, (email, password))

        user = cursor.fetchone()

        if user:

            session["user_id"] = user["id"]
            session["role"] = user["role"]
            session["nama"] = user["nama"]

            # ROLE REDIRECT
            if user["role"] == "admin":
                return redirect("/dashboard")

            elif user["role"] == "dosen":
                return redirect("/dosen")

            elif user["role"] == "mahasiswa":
                return redirect("/mahasiswa")

        return "Email / Password salah ❌"

    return render_template("login.html")


# ================= SIGN UP =================
# ================= SIGN UP =================
@app.route("/signup", methods=["GET", "POST"])
def signup():

    # BUKA HALAMAN SIGNUP
    if request.method == "GET":
        return render_template("signup.html")

    # AMBIL DATA FORM
    nama = request.form.get("nama")
    email = request.form.get("email")
    password = request.form.get("password")
    role = request.form.get("role")

    cursor = db.cursor(dictionary=True, buffered=True)

    # CEK EMAIL
    cursor.execute(
        "SELECT * FROM users WHERE email=%s",
        (email,)
    )

    cek = cursor.fetchone()

    if cek:
        return "Email sudah digunakan ❌"

    # INSERT USER
    cursor.execute("""
        INSERT INTO users (nama, email, password, role)
        VALUES (%s,%s,%s,%s)
    """, (nama, email, password, role))

    user_id = cursor.lastrowid

    # AUTO MAHASISWA
    if role == "mahasiswa":

        cursor.execute("""
            INSERT INTO mahasiswa
            (user_id, nama, nim, kelas_id, status)
            VALUES (%s,%s,%s,%s,'aktif')
        """, (
            user_id,
            nama,
            "0000",
            1
        ))

    db.commit()

    return redirect("/")


# ================= DASHBOARD ADMIN =================
@app.route("/dashboard")
def dashboard():

    if not cek_role("admin"):
        return redirect("/")

    cursor = db.cursor(dictionary=True, buffered=True)

    # AMBIL KELAS
    cursor.execute("SELECT * FROM kelas")
    kelas = cursor.fetchall()

    # AMBIL MAHASISWA
    cursor.execute("""
        SELECT
            m.id,
            m.nama,
            m.nim,
            k.nama_kelas
        FROM mahasiswa m
        LEFT JOIN kelas k
        ON m.kelas_id = k.id
    """)

    mahasiswa = cursor.fetchall()

    return render_template(
        "admin.html",
        kelas=kelas,
        mahasiswa=mahasiswa
    )


# ================= FILTER KELAS =================
@app.route("/filter_kelas", methods=["POST"])
def filter_kelas():

    if not cek_role("admin"):
        return redirect("/")

    kelas_id = request.form["kelas_id"]

    cursor = db.cursor(dictionary=True, buffered=True)

    cursor.execute("SELECT * FROM kelas")
    kelas = cursor.fetchall()

    cursor.execute("""
        SELECT
            m.id,
            m.nama,
            m.nim,
            k.nama_kelas
        FROM mahasiswa m
        LEFT JOIN kelas k
        ON m.kelas_id = k.id
        WHERE m.kelas_id=%s
    """, (kelas_id,))

    mahasiswa = cursor.fetchall()

    return render_template(
        "admin.html",
        kelas=kelas,
        mahasiswa=mahasiswa
    )


# ================= TAMBAH KELAS =================
@app.route("/tambah_kelas", methods=["POST"])
def tambah_kelas():

    if not cek_role("admin"):
        return redirect("/")

    nama_kelas = request.form["nama_kelas"]

    cursor = db.cursor()

    cursor.execute("""
        INSERT INTO kelas (nama_kelas)
        VALUES (%s)
    """, (nama_kelas,))

    db.commit()

    return redirect("/dashboard")


# ================= TAMBAH MAHASISWA =================
@app.route("/tambah_mahasiswa", methods=["POST"])
def tambah_mahasiswa():

    if not cek_role("admin"):
        return redirect("/")

    nama = request.form["nama"]
    nim = request.form["nim"]
    kelas_id = request.form["kelas_id"]

    cursor = db.cursor()

    # INSERT MAHASISWA
    cursor.execute("""
        INSERT INTO mahasiswa
        (nama, nim, kelas_id, status)
        VALUES (%s,%s,%s,'aktif')
    """, (nama, nim, kelas_id))

    mahasiswa_id = cursor.lastrowid

    # AUTO AKUN LOGIN
    email = nim + "@mhs.com"
    password = "123"

    cursor.execute("""
        INSERT INTO users
        (nama, email, password, role)
        VALUES (%s,%s,%s,'mahasiswa')
    """, (nama, email, password))

    user_id = cursor.lastrowid

    # HUBUNGKAN USER
    cursor.execute("""
        UPDATE mahasiswa
        SET user_id=%s
        WHERE id=%s
    """, (user_id, mahasiswa_id))

    db.commit()

    return redirect("/dashboard")


# ================= HAPUS MAHASISWA =================
@app.route("/hapus_mahasiswa/<int:id>")
def hapus_mahasiswa(id):

    if not cek_role("admin"):
        return redirect("/")

    cursor = db.cursor()

    cursor.execute("""
        DELETE FROM mahasiswa
        WHERE id=%s
    """, (id,))

    db.commit()

    return redirect("/dashboard")


# ================= EDIT MAHASISWA =================
@app.route("/edit_mahasiswa/<int:id>", methods=["GET", "POST"])
def edit_mahasiswa(id):

    if not cek_role("admin"):
        return redirect("/")

    cursor = db.cursor(dictionary=True, buffered=True)

    # AMBIL KELAS
    cursor.execute("SELECT * FROM kelas")
    kelas = cursor.fetchall()

    # SAVE
    if request.method == "POST":

        nama = request.form["nama"]
        nim = request.form["nim"]
        kelas_id = request.form["kelas_id"]

        cursor2 = db.cursor()

        cursor2.execute("""
            UPDATE mahasiswa
            SET
                nama=%s,
                nim=%s,
                kelas_id=%s
            WHERE id=%s
        """, (nama, nim, kelas_id, id))

        db.commit()

        return redirect("/dashboard")

    # AMBIL DATA
    cursor.execute("""
        SELECT * FROM mahasiswa
        WHERE id=%s
    """, (id,))

    mahasiswa = cursor.fetchone()

    return render_template(
        "edit_mahasiswa.html",
        mahasiswa=mahasiswa,
        kelas=kelas
    )


# ================= MAHASISWA =================
@app.route("/mahasiswa")
def mahasiswa():

    if not cek_role("mahasiswa"):
        return redirect("/")

    cursor = db.cursor(dictionary=True, buffered=True)

    cursor.execute("""
        SELECT * FROM mahasiswa
        WHERE user_id=%s
    """, (session["user_id"],))

    mhs = cursor.fetchone()

    if not mhs:
        return "Data mahasiswa tidak ditemukan ❌"

    jadwal = []

    try:

        cursor.execute("""
            SELECT * FROM jadwal
            WHERE kelas_id=%s
        """, (mhs["kelas_id"],))

        jadwal = cursor.fetchall()

    except:
        pass

    return render_template(
        "mahasiswa.html",
        mhs=mhs,
        jadwal=jadwal
    )


# ================= ABSEN =================
@app.route("/absen/<int:id>")
def absen(id):

    if not cek_role("mahasiswa"):
        return redirect("/")

    cursor = db.cursor(dictionary=True, buffered=True)

    cursor.execute("""
        SELECT * FROM mahasiswa
        WHERE user_id=%s
    """, (session["user_id"],))

    mhs = cursor.fetchone()

    if not mhs:
        return "Mahasiswa tidak ditemukan ❌"

    # BLOKIR
    if mhs["status"] == "blokir":
        return "ANDA DIBLOK DOSEN ❌"

    # INSERT ABSEN
    cursor.execute("""
        INSERT INTO kehadiran
        (mahasiswa_id, mata_kuliah_id, tanggal, status)
        VALUES (%s,%s,%s,'hadir')
    """, (
        mhs["id"],
        id,
        date.today()
    ))

    db.commit()

    return redirect("/mahasiswa")


# ================= DOSEN =================
@app.route("/dosen")
def dosen():

    if not cek_role("dosen"):
        return redirect("/")

    cursor = db.cursor(dictionary=True, buffered=True)

    cursor.execute("""
        SELECT
            m.id,
            m.nama,
            COUNT(k.id) as hadir,
            ROUND(COUNT(k.id)*100/5,2) as persentase,
            m.status
        FROM mahasiswa m
        LEFT JOIN kehadiran k
        ON m.id = k.mahasiswa_id
        GROUP BY m.id
    """)

    data = cursor.fetchall()

    return render_template(
        "dosen.html",
        data=data
    )


# ================= BLOK =================
@app.route("/blok/<int:id>")
def blok(id):

    if not cek_role("dosen"):
        return redirect("/")

    cursor = db.cursor()

    cursor.execute("""
        UPDATE mahasiswa
        SET status='blokir'
        WHERE id=%s
    """, (id,))

    db.commit()

    return redirect("/dosen")


# ================= UNBLOK =================
@app.route("/unblok/<int:id>")
def unblok(id):

    if not cek_role("dosen"):
        return redirect("/")

    cursor = db.cursor()

    cursor.execute("""
        UPDATE mahasiswa
        SET status='aktif'
        WHERE id=%s
    """, (id,))

    db.commit()

    return redirect("/dosen")


# ================= QR DOSEN =================
@app.route("/dosen/generate_qr/<int:jadwal_id>")
def generate_qr(jadwal_id):

    if not cek_role("dosen"):
        return redirect("/")

    qr_link = f"http://127.0.0.1:5000/scan_absen/{jadwal_id}"

    return render_template(
        "dosen_qr.html",
        qr_data=qr_link,
        jadwal_id=jadwal_id
    )


# ================= SCAN ABSEN =================
@app.route("/scan_absen/<int:jadwal_id>")
def scan_absen(jadwal_id):

    if not cek_role("mahasiswa"):
        return redirect("/")

    cursor = db.cursor(dictionary=True, buffered=True)

    # AMBIL MAHASISWA
    cursor.execute("""
        SELECT id, status
        FROM mahasiswa
        WHERE user_id=%s
    """, (session["user_id"],))

    mhs = cursor.fetchone()

    if not mhs:
        return "Mahasiswa tidak ditemukan ❌"

    # BLOKIR
    if mhs["status"] == "blokir":
        return "Akun diblokir dosen ❌"

    # CEK SUDAH ABSEN
    today = date.today()

    cursor.execute("""
        SELECT *
        FROM absensi_qr
        WHERE mahasiswa_id=%s
        AND jadwal_id=%s
        AND tanggal=%s
    """, (
        mhs["id"],
        jadwal_id,
        today
    ))

    cek = cursor.fetchone()

    if cek:
        return "Anda sudah absen hari ini ✅"

    # INSERT ABSEN QR
    cursor.execute("""
        INSERT INTO absensi_qr
        (mahasiswa_id, jadwal_id, tanggal, jam_hadir, status)
        VALUES (%s,%s,%s,NOW(),'hadir')
    """, (
        mhs["id"],
        jadwal_id,
        today
    ))

    db.commit()

    return "Absensi QR berhasil ✅"

# ================= AKTIVITAS ORGANISASI =================
@app.route("/organisasi")
def organisasi():

    if not cek_role("mahasiswa"):
        return redirect("/")

    cursor = db.cursor(dictionary=True)

    # ambil data mahasiswa login
    cursor.execute("""
        SELECT * FROM mahasiswa
        WHERE user_id=%s
    """, (session["user_id"],))

    mhs = cursor.fetchone()

    cursor.execute("""
    SELECT ao.id,
           o.nama_organisasi,
           o.jenis,
           ao.jabatan,
           ao.status
    FROM aktivitas_organisasi ao
    JOIN organisasi o
    ON ao.organisasi_id = o.id
    WHERE ao.mahasiswa_id=%s
""", (mhs["id"],))
    data = cursor.fetchall()

    # ambil semua organisasi
    cursor.execute("SELECT * FROM organisasi")
    organisasi = cursor.fetchall()

    return render_template(
        "organisasi.html",
        data=data,
        organisasi=organisasi
    )


# ================= TAMBAH ORGANISASI =================
@app.route("/tambah_organisasi", methods=["POST"])
def tambah_organisasi():

    if not cek_role("mahasiswa"):
        return redirect("/")

    organisasi_id = request.form["organisasi_id"]
    jabatan = request.form["jabatan"]
    status = request.form["status"]

    cursor = db.cursor(dictionary=True)

    # ambil mahasiswa login
    cursor.execute("""
        SELECT * FROM mahasiswa
        WHERE user_id=%s
    """, (session["user_id"],))

    mhs = cursor.fetchone()

    # insert
    cursor.execute("""
        INSERT INTO aktivitas_organisasi
        (mahasiswa_id, organisasi_id, jabatan, status)
        VALUES (%s,%s,%s,%s)
    """, (
        mhs["id"],
        organisasi_id,
        jabatan,
        status
    ))

    db.commit()

    return redirect("/organisasi")
# ================= DATA ORGANISASI =================
@app.route("/data_organisasi")
def data_organisasi():

    if "role" not in session or session["role"] is None:
        return redirect("/")

    cursor = db.cursor(dictionary=True)

    cursor.execute("""
        SELECT 
            ao.id,
            m.nama,
            k.nama_kelas,
            o.nama_organisasi,
            o.jenis,
            ao.jabatan,
            ao.status,
            ao.periode_mulai,
            ao.periode_selesai,
            ao.deskripsi_tugas,
            ao.bukti
        FROM aktivitas_organisasi ao
        JOIN mahasiswa m ON ao.mahasiswa_id = m.id
        JOIN kelas k ON m.kelas_id = k.id
        JOIN organisasi o ON ao.organisasi_id = o.id
    """)

    data = cursor.fetchall()

    cursor.execute("SELECT id, nama FROM mahasiswa")
    mahasiswa = cursor.fetchall()

    cursor.execute("SELECT * FROM organisasi")
    organisasi = cursor.fetchall()

    return render_template(
        "aktivitas_organisasi.html",
        data=data,
        mahasiswa=mahasiswa,
        organisasi=organisasi
    )
    
@app.route("/form_aktivitas")
def form_aktivitas():

    if "role" not in session:
        return redirect("/")

    cursor = db.cursor(dictionary=True)

    cursor.execute("SELECT id, nama FROM mahasiswa")
    mahasiswa = cursor.fetchall()

    cursor.execute("SELECT * FROM organisasi")
    organisasi = cursor.fetchall()

    return render_template(
        "form_aktivitas.html",
        mahasiswa=mahasiswa,
        organisasi=organisasi
    )

    
    # ================= TAMBAH AKTIVITAS ORGANISASI =================
@app.route("/tambah_aktivitas", methods=["POST"])
def tambah_aktivitas():

    if "role" not in session:
        return redirect("/")

    if session["role"] not in ["admin", "dosen"]:
        return redirect("/")

    mahasiswa_id = request.form["mahasiswa_id"]
    organisasi_id = request.form["organisasi_id"]
    jabatan = request.form["jabatan"]
    status = request.form["status"]

    # 🔥 BARU
    periode_mulai = request.form["periode_mulai"]
    periode_selesai = request.form.get("periode_selesai")
    deskripsi_tugas = request.form.get("deskripsi_tugas")

    # upload file
    bukti_file = request.files.get("bukti")
    filename = None

    if bukti_file and bukti_file.filename != "":
        import os
        os.makedirs("static/bukti", exist_ok=True)

        filename = bukti_file.filename
        bukti_file.save("static/bukti/" + filename)

    cursor = db.cursor()

    cursor.execute("""
        INSERT INTO aktivitas_organisasi
        (mahasiswa_id, organisasi_id, jabatan, status,
         periode_mulai, periode_selesai, deskripsi_tugas, bukti)
        VALUES (%s,%s,%s,%s,%s,%s,%s,%s)
    """, (
        mahasiswa_id,
        organisasi_id,
        jabatan,
        status,
        periode_mulai,
        periode_selesai,
        deskripsi_tugas,
        filename
    ))

    db.commit()

    return redirect("/data_organisasi")

# ================= EDIT AKTIVITAS =================
@app.route("/edit_aktivitas/<int:id>", methods=["GET", "POST"])
def edit_aktivitas(id):

    if "role" not in session:
        return redirect("/")

    if session["role"] not in ["admin", "dosen"]:
        return redirect("/")

    cursor = db.cursor(dictionary=True)

    # ambil organisasi
    cursor.execute("SELECT * FROM organisasi")
    organisasi = cursor.fetchall()

    # ambil mahasiswa
    cursor.execute("""
        SELECT id, nama
        FROM mahasiswa
    """)
    mahasiswa = cursor.fetchall()

    # save edit
    if request.method == "POST":

        mahasiswa_id = request.form["mahasiswa_id"]
        organisasi_id = request.form["organisasi_id"]
        jabatan = request.form["jabatan"]
        status = request.form["status"]

        cursor2 = db.cursor()

        cursor2.execute("""
            UPDATE aktivitas_organisasi
            SET
                mahasiswa_id=%s,
                organisasi_id=%s,
                jabatan=%s,
                status=%s
            WHERE id=%s
        """, (
            mahasiswa_id,
            organisasi_id,
            jabatan,
            status,
            id
        ))

        db.commit()

        return redirect("/data_organisasi")

    # ambil data aktivitas
    cursor.execute("""
        SELECT *
        FROM aktivitas_organisasi
        WHERE id=%s
    """, (id,))

    aktivitas = cursor.fetchone()

    return render_template(
        "edit_aktivitas.html",
        aktivitas=aktivitas,
        organisasi=organisasi,
        mahasiswa=mahasiswa
    )


# ================= HAPUS AKTIVITAS =================
@app.route("/hapus_aktivitas/<int:id>")
def hapus_aktivitas(id):

    if "role" not in session:
        return redirect("/")

    if session["role"] not in ["admin", "dosen"]:
        return redirect("/")

    cursor = db.cursor()

    cursor.execute("""
        DELETE FROM aktivitas_organisasi
        WHERE id=%s
    """, (id,))

    db.commit()

    return redirect("/data_organisasi")


# ================= LOGOUT =================
@app.route("/logout")
def logout():

    session.clear()

    return redirect("/")


# ================= RUN =================
if __name__ == "__main__":
    app.run(debug=True)