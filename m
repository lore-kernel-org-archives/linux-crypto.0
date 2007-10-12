From: Sebastian Siewior <sebastian@breakpoint.cc>
Subject: [RFC 1/6] [crypto] AES: move common defines into a header file
Date: Fri, 12 Oct 2007 14:38:32 +0200
Message-ID: <E1IgMP3-0002ks-RJ@Chamillionaire.breakpoint.cc>
References: <1192202467-10335-1-git-send-email-linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------1.5.2.5"
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:50913 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753208AbXJLP0T (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Oct 2007 11:26:19 -0400
Received: id: bigeasy by Chamillionaire.breakpoint.cc authenticated by bigeasy with local
	(easymta 1.00 BETA 1)
	id 1IgMP3-0002ks-RJ
	for linux-crypto@vger.kernel.org; Fri, 12 Oct 2007 17:26:17 +0200
In-Reply-To: <1192202467-10335-1-git-send-email-linux-crypto@ml.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This is a multi-part message in MIME format.
--------------1.5.2.5
Content-Type: text/plain; charset=UTF-8; format=fixed
Content-Transfer-Encoding: 8bit


This three defines are used in every AES related implementation.

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 arch/i386/crypto/aes.c       |    4 +---
 arch/s390/crypto/aes_s390.c  |    7 +------
 arch/x86_64/crypto/aes.c     |    6 +-----
 crypto/aes.c                 |    6 +-----
 drivers/crypto/geode-aes.c   |    1 +
 drivers/crypto/padlock-aes.c |    4 +---
 include/crypto/aes.h         |   15 +++++++++++++++
 7 files changed, 21 insertions(+), 22 deletions(-)
 create mode 100644 include/crypto/aes.h
--------------1.5.2.5
Content-Type: text/x-patch; name="d9f0e2329449a5bc2ec784dfd666ad09ae150f0e.diff"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline; filename="d9f0e2329449a5bc2ec784dfd666ad09ae150f0e.diff"

diff --git a/arch/i386/crypto/aes.c b/arch/i386/crypto/aes.c
index 49aad93..9b0ab50 100644
--- a/arch/i386/crypto/aes.c
+++ b/arch/i386/crypto/aes.c
@@ -38,6 +38,7 @@
  */
 
 #include <asm/byteorder.h>
+#include <crypto/aes.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -48,9 +49,6 @@
 asmlinkage void aes_enc_blk(struct crypto_tfm *tfm, u8 *dst, const u8 *src);
 asmlinkage void aes_dec_blk(struct crypto_tfm *tfm, u8 *dst, const u8 *src);
 
-#define AES_MIN_KEY_SIZE	16
-#define AES_MAX_KEY_SIZE	32
-#define AES_BLOCK_SIZE		16
 #define AES_KS_LENGTH		4 * AES_BLOCK_SIZE
 #define RC_LENGTH		29
 
diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 3660ca6..a4eff57 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -16,17 +16,12 @@
  *
  */
 
+#include <crypto/aes.h>
 #include <crypto/algapi.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include "crypt_s390.h"
 
-#define AES_MIN_KEY_SIZE	16
-#define AES_MAX_KEY_SIZE	32
-
-/* data block size for all key lengths */
-#define AES_BLOCK_SIZE		16
-
 #define AES_KEYLEN_128		1
 #define AES_KEYLEN_192		2
 #define AES_KEYLEN_256		4
diff --git a/arch/x86_64/crypto/aes.c b/arch/x86_64/crypto/aes.c
index 5cdb13e..0b38a4c 100644
--- a/arch/x86_64/crypto/aes.c
+++ b/arch/x86_64/crypto/aes.c
@@ -54,6 +54,7 @@
 */
 
 #include <asm/byteorder.h>
+#include <crypto/aes.h>
 #include <linux/bitops.h>
 #include <linux/crypto.h>
 #include <linux/errno.h>
@@ -61,11 +62,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 
-#define AES_MIN_KEY_SIZE	16
-#define AES_MAX_KEY_SIZE	32
-
-#define AES_BLOCK_SIZE		16
-
 /*
  * #define byte(x, nr) ((unsigned char)((x) >> (nr*8)))
  */
diff --git a/crypto/aes.c b/crypto/aes.c
index e244077..9d486a3 100644
--- a/crypto/aes.c
+++ b/crypto/aes.c
@@ -52,6 +52,7 @@
     s/RIJNDAEL(d_key)/D_KEY/g
 */
 
+#include <crypto/aes.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/types.h>
@@ -59,11 +60,6 @@
 #include <linux/crypto.h>
 #include <asm/byteorder.h>
 
-#define AES_MIN_KEY_SIZE	16
-#define AES_MAX_KEY_SIZE	32
-
-#define AES_BLOCK_SIZE		16
-
 /*
  * #define byte(x, nr) ((unsigned char)((x) >> (nr*8))) 
  */
diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 6a86958..7c6f13f 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -13,6 +13,7 @@
 #include <linux/crypto.h>
 #include <linux/spinlock.h>
 #include <crypto/algapi.h>
+#include <crypto/aes.h>
 
 #include <asm/io.h>
 #include <asm/delay.h>
diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index d4501dc..50da8b6 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -44,6 +44,7 @@
  */
 
 #include <crypto/algapi.h>
+#include <crypto/aes.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/types.h>
@@ -53,9 +54,6 @@
 #include <asm/byteorder.h>
 #include "padlock.h"
 
-#define AES_MIN_KEY_SIZE	16	/* in uint8_t units */
-#define AES_MAX_KEY_SIZE	32	/* ditto */
-#define AES_BLOCK_SIZE		16	/* ditto */
 #define AES_EXTENDED_KEY_SIZE	64	/* in uint32_t units */
 #define AES_EXTENDED_KEY_SIZE_B	(AES_EXTENDED_KEY_SIZE * sizeof(uint32_t))
 
diff --git a/include/crypto/aes.h b/include/crypto/aes.h
new file mode 100644
index 0000000..9ff842f
--- /dev/null
+++ b/include/crypto/aes.h
@@ -0,0 +1,15 @@
+/*
+ * Common values for AES algorithms
+ */
+
+#ifndef _CRYPTO_AES_H
+#define _CRYPTO_AES_H
+
+#define AES_MIN_KEY_SIZE	16
+#define AES_MAX_KEY_SIZE	32
+#define AES_KEYSIZE_128		16
+#define AES_KEYSIZE_192		24
+#define AES_KEYSIZE_256		32
+#define AES_BLOCK_SIZE		16
+
+#endif

--------------1.5.2.5--
