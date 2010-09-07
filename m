From: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]crypto/Kconfig update broken web addresses.
Date: Mon,  6 Sep 2010 21:16:59 -0700
Message-ID: <1283833019-26155-1-git-send-email-justinmattock@gmail.com>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, davem@davemloft.net,
	"Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Below is a patch to update the broken web addresses, in crypto/*
that I could locate. Some are just simple typos that needed to be
fixed, and some had a change in location altogether..
let me know if any of them need to be changed and such. 

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 crypto/Kconfig |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 1cd497d..925da03 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -365,7 +365,7 @@ config CRYPTO_RMD128
 	  RIPEMD-160 should be used.
 
 	  Developed by Hans Dobbertin, Antoon Bosselaers and Bart Preneel.
-	  See <http://home.esat.kuleuven.be/~bosselae/ripemd160.html>
+	  See <http://homes.esat.kuleuven.be/~bosselae/ripemd160.html>
 
 config CRYPTO_RMD160
 	tristate "RIPEMD-160 digest algorithm"
@@ -382,7 +382,7 @@ config CRYPTO_RMD160
 	  against RIPEMD-160.
 
 	  Developed by Hans Dobbertin, Antoon Bosselaers and Bart Preneel.
-	  See <http://home.esat.kuleuven.be/~bosselae/ripemd160.html>
+	  See <http://homes.esat.kuleuven.be/~bosselae/ripemd160.html>
 
 config CRYPTO_RMD256
 	tristate "RIPEMD-256 digest algorithm"
@@ -394,7 +394,7 @@ config CRYPTO_RMD256
 	  (than RIPEMD-128).
 
 	  Developed by Hans Dobbertin, Antoon Bosselaers and Bart Preneel.
-	  See <http://home.esat.kuleuven.be/~bosselae/ripemd160.html>
+	  See <http://homes.esat.kuleuven.be/~bosselae/ripemd160.html>
 
 config CRYPTO_RMD320
 	tristate "RIPEMD-320 digest algorithm"
@@ -406,7 +406,7 @@ config CRYPTO_RMD320
 	  (than RIPEMD-160).
 
 	  Developed by Hans Dobbertin, Antoon Bosselaers and Bart Preneel.
-	  See <http://home.esat.kuleuven.be/~bosselae/ripemd160.html>
+	  See <http://homes.esat.kuleuven.be/~bosselae/ripemd160.html>
 
 config CRYPTO_SHA1
 	tristate "SHA1 digest algorithm"
@@ -461,7 +461,7 @@ config CRYPTO_WP512
 	  Whirlpool will be part of the ISO/IEC 10118-3:2003(E) standard
 
 	  See also:
-	  <http://planeta.terra.com.br/informatica/paulobarreto/WhirlpoolPage.html>
+	  <http://www.larc.usp.br/~pbarreto/WhirlpoolPage.html>
 
 config CRYPTO_GHASH_CLMUL_NI_INTEL
 	tristate "GHASH digest algorithm (CLMUL-NI accelerated)"
@@ -579,8 +579,8 @@ config CRYPTO_ANUBIS
 	  in the NESSIE competition.
 
 	  See also:
-	  <https://www.cosic.esat.kuleuven.ac.be/nessie/reports/>
-	  <http://planeta.terra.com.br/informatica/paulobarreto/AnubisPage.html>
+	  <https://www.cosic.esat.kuleuven.be/nessie/reports/>
+	  <http://www.larc.usp.br/~pbarreto/AnubisPage.html>
 
 config CRYPTO_ARC4
 	tristate "ARC4 cipher algorithm"
@@ -659,7 +659,7 @@ config CRYPTO_KHAZAD
 	  on 32-bit processors.  Khazad uses an 128 bit key size.
 
 	  See also:
-	  <http://planeta.terra.com.br/informatica/paulobarreto/KhazadPage.html>
+	  <http://www.larc.usp.br/~pbarreto/KhazadPage.html>
 
 config CRYPTO_SALSA20
 	tristate "Salsa20 stream cipher algorithm (EXPERIMENTAL)"
-- 
1.7.2.1
