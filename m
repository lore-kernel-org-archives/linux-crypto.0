From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH] crypto x86/camellia_aesni_avx: Fix CPU feature checks
Date: Tue, 06 Oct 2015 12:31:33 +0100
Message-ID: <1444131093.2956.122.camel@decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Fa6DacoiMNbJK4mhOcnq"
Cc: =?ISO-8859-1?Q?St=E9phane?= Glondu <glondu@debian.org>,
	stable <stable@vger.kernel.org>, x86@kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--=-Fa6DacoiMNbJK4mhOcnq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

We need to explicitly check the AVX and AES CPU features, as we can't
infer them from the related XSAVE feature flags.  For example, the
Core i3 2310M passes the XSAVE feature test but does not implement
AES-NI.

Reported-and-tested-by: St=C3=A9phane Glondu <glondu@debian.org>
References: https://bugs.debian.org/800934
Fixes: ce4f5f9b65ae ("x86/fpu, crypto x86/camellia_aesni_avx: Simplify...")
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: stable <stable@vger.kernel.org> # 4.2
---
 arch/x86/crypto/camellia_aesni_avx_glue.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/crypto/camellia_aesni_avx_glue.c b/arch/x86/crypto/ca=
mellia_aesni_avx_glue.c
index 80a0e43..bacaa13 100644
--- a/arch/x86/crypto/camellia_aesni_avx_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx_glue.c
@@ -554,6 +554,11 @@ static int __init camellia_aesni_init(void)
 {
 	const char *feature_name;
=20
+	if (!cpu_has_avx || !cpu_has_aes || !cpu_has_osxsave) {
+		pr_info("AVX or AES-NI instructions are not detected.\n");
+		return -ENODEV;
+	}
+
 	if (!cpu_has_xfeatures(XSTATE_SSE | XSTATE_YMM, &feature_name)) {
 		pr_info("CPU feature '%s' is not supported.\n", feature_name);
 		return -ENODEV;
--=20
Ben Hutchings
All the simple programs have been written, and all the good names taken.
--=-Fa6DacoiMNbJK4mhOcnq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAVhOxFee/yOyVhhEJAQrSrw/+KSXIeDOCyr4PusqtM1PE9r+X2T1dfz5X
tYaY+ePNeYiAnv8536d452Nul3X5sYZTlWnq7fSmxgeDfqO8Y1egaT7gyvqIi0Di
Yz18ROcW+vcda/Idzo6qDl9ixxVcUubzbbtck+3PnmDnv1Qolqa8tyGQlGJvQtEE
vBRVksggomFwS0XyV+xCAJ0i845Fds4nZahUjIqdp2IJoYIcJtZ5FSy9b5o3dFRz
7lUYwvOePdRpj2qNnP4C26A22nuY9KhUXDXAWr0EbqRuAsCMHiUYUWYF5ifAzOAI
bSfS0LydMyijBaKZVe3A3I2a0fKkPsoxQfCQQhdLbXPC/S3ElCEAQMj3utpBuwHW
BdCPXqZCPCJKQzYfym6U4Y5a5PNURZlmeD2PQNn/j1I889iB+nPlXm6guiZ5VuMz
IehyIugroOoMbHELy5rU2XlNNfI+ZhjFYcuoY3UwnrCYlCBS3Kzrfd2RogkqcENU
SlbiB+Dz8/GhZKTVrD8MzYmhChatkYiaBxkk1ef9we4rQZADOQOE25jiQGBx73nl
qhMyYjzc+Do1XRwDQdwN0CJZawh6l135DK7yB0LsdZ9DmYn7WZ/di632/0WctD+p
l24djA/g9gy7CdKlfCWDyIiBC7gGNNBaApjspY1ajr8Vnu7//RW80xtEhV4D6W5o
v3dNrzSsmTs=
=B5Gs
-----END PGP SIGNATURE-----

--=-Fa6DacoiMNbJK4mhOcnq--
