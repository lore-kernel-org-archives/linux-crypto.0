From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] properly indent the CRYPTO_RMD* kconfig entries
Date: Tue, 15 Jul 2008 13:05:21 +0300
Message-ID: <20080715100521.GC29742@cs181140183.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-crypto@vger.kernel.org
To: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>,
	herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp4.pp.htv.fi ([213.243.153.38]:53565 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754289AbYGOKF3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Jul 2008 06:05:29 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Instead of tabs there were two spaces.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 crypto/Kconfig |   77 +++++++++++++++++++++++++------------------------
 1 file changed, 40 insertions(+), 37 deletions(-)

af2ebd963fc1ab2e2a66852bae9d262ee0a5ea61 
diff --git a/crypto/Kconfig b/crypto/Kconfig
index ea50357..730a29b 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -243,55 +243,58 @@ config CRYPTO_MICHAEL_MIC
 	  of the algorithm.
 
 config CRYPTO_RMD128
-  tristate "RIPEMD-128 digest algorithm"
-  select CRYPTO_ALGAPI
-  help
-    RIPEMD-128 (ISO/IEC 10118-3:2004).
+	tristate "RIPEMD-128 digest algorithm"
+	select CRYPTO_ALGAPI
+	help
+	  RIPEMD-128 (ISO/IEC 10118-3:2004).
 
-    RIPEMD-128 is a 128-bit cryptographic hash function. It should only
-    to be used as a secure replacement for RIPEMD. For other use cases
-    RIPEMD-160 should be used.
+	  RIPEMD-128 is a 128-bit cryptographic hash function. It should only
+	  to be used as a secure replacement for RIPEMD. For other use cases
+	  RIPEMD-160 should be used.
 
-    Developed by Hans Dobbertin, Antoon Bosselaers and Bart Preneel.
-    See <http://home.esat.kuleuven.be/~bosselae/ripemd160.html>
+	  Developed by Hans Dobbertin, Antoon Bosselaers and Bart Preneel.
+	  See <http://home.esat.kuleuven.be/~bosselae/ripemd160.html>
 
 config CRYPTO_RMD160
-  tristate "RIPEMD-160 digest algorithm"
-  select CRYPTO_ALGAPI
-  help
-    RIPEMD-160 (ISO/IEC 10118-3:2004).
+	tristate "RIPEMD-160 digest algorithm"
+	select CRYPTO_ALGAPI
+	help
+	  RIPEMD-160 (ISO/IEC 10118-3:2004).
 
-    RIPEMD-160 is a 160-bit cryptographic hash function. It is intended
-    to be used as a secure replacement for the 128-bit hash functions
-    MD4, MD5 and it's predecessor RIPEMD (not to be confused with RIPEMD-128).
+	  RIPEMD-160 is a 160-bit cryptographic hash function. It is intended
+	  to be used as a secure replacement for the 128-bit hash functions
+	  MD4, MD5 and it's predecessor RIPEMD
+	  (not to be confused with RIPEMD-128).
 
-    It's speed is comparable to SHA1 and there are no known attacks against
-    RIPEMD-160.
+	  It's speed is comparable to SHA1 and there are no known attacks
+	  against RIPEMD-160.
 
-    Developed by Hans Dobbertin, Antoon Bosselaers and Bart Preneel.
-    See <http://home.esat.kuleuven.be/~bosselae/ripemd160.html>
+	  Developed by Hans Dobbertin, Antoon Bosselaers and Bart Preneel.
+	  See <http://home.esat.kuleuven.be/~bosselae/ripemd160.html>
 
 config CRYPTO_RMD256
-  tristate "RIPEMD-256 digest algorithm"
-  select CRYPTO_ALGAPI
-  help
-    RIPEMD-256 is an optional extension of RIPEMD-128 with a 256 bit hash.
-    It is intended for applications that require longer hash-results, without
-    needing a larger security level (than RIPEMD-128).
+	tristate "RIPEMD-256 digest algorithm"
+	select CRYPTO_ALGAPI
+	help
+	  RIPEMD-256 is an optional extension of RIPEMD-128 with a
+	  256 bit hash. It is intended for applications that require
+	  longer hash-results, without needing a larger security level
+	  (than RIPEMD-128).
 
-    Developed by Hans Dobbertin, Antoon Bosselaers and Bart Preneel.
-    See <http://home.esat.kuleuven.be/~bosselae/ripemd160.html>
+	  Developed by Hans Dobbertin, Antoon Bosselaers and Bart Preneel.
+	  See <http://home.esat.kuleuven.be/~bosselae/ripemd160.html>
 
 config CRYPTO_RMD320
-  tristate "RIPEMD-320 digest algorithm"
-  select CRYPTO_ALGAPI
-  help
-    RIPEMD-320 is an optional extension of RIPEMD-160 with a 320 bit hash.
-    It is intended for applications that require longer hash-results, without
-    needing a larger security level (than RIPEMD-160).
