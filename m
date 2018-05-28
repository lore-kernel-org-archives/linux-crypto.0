From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] crypto: morus - Hide Kconfig option for glue code
Date: Mon, 28 May 2018 17:47:45 +0200
Message-ID: <20180528154806.2621106-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Ondrej Mosnacek <omosnacek@gmail.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Enabling the glue drivers for morus640 and/or morus1280 leads to a build failure
on all non-x86 architectures:

crypto/morus1280_glue.c:24:10: fatal error: asm/fpu/api.h: No such file or directory
scripts/Makefile.build:311: recipe for target 'crypto/morus1280_glue.o' failed
crypto/morus640_glue.c:24:10: fatal error: asm/fpu/api.h: No such file or directory
scripts/Makefile.build:311: recipe for target 'crypto/morus640_glue.o' failed

There really is no reason to enable these unless we also have a real
driver using the glue, so the Kconfig option can be hidden and remain
selected by the x86 specific SIMD drivers or any others getting added
in the future.

Fixes: 56e8e57fc3a7 ("crypto: morus - Add common SIMD glue code for MORUS")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 crypto/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 75f5efde9aa3..e11c59d26ac5 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -341,7 +341,7 @@ config CRYPTO_MORUS640
 	  Support for the MORUS-640 dedicated AEAD algorithm.
 
 config CRYPTO_MORUS640_GLUE
-	tristate "MORUS-640 AEAD algorithm (glue for SIMD optimizations)"
+	tristate
 	select CRYPTO_AEAD
 	select CRYPTO_CRYPTD
 	help
@@ -363,7 +363,7 @@ config CRYPTO_MORUS1280
 	  Support for the MORUS-1280 dedicated AEAD algorithm.
 
 config CRYPTO_MORUS1280_GLUE
-	tristate "MORUS-1280 AEAD algorithm (glue for SIMD optimizations)"
+	tristate
 	select CRYPTO_AEAD
 	select CRYPTO_CRYPTD
 	help
-- 
2.9.0
