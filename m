From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 4/7] crypto: serpent: export common functions for
	x86_64/i386-sse2 assembler implementations
Date: Tue, 18 Oct 2011 00:03:08 +0300
Message-ID: <20111017210308.13543.52813.stgit@localhost6.localdomain6>
References: <20111017210247.13543.75430.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Dag Arne Osvik <osvik@ii.uib.no>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:37706 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181Ab1JQVDK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Oct 2011 17:03:10 -0400
In-Reply-To: <20111017210247.13543.75430.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Serpent SSE2 assembler implementations only provide 4-way/8-way parallel
functions and need setkey and one-block encrypt/decrypt functions.

CC: Dag Arne Osvik <osvik@ii.uib.no>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/serpent.c         |   41 ++++++++++++++++++++++-------------------
 include/crypto/serpent.h |   25 +++++++++++++++++++++++++
 2 files changed, 47 insertions(+), 19 deletions(-)
 create mode 100644 include/crypto/serpent.h

diff --git a/crypto/serpent.c b/crypto/serpent.c
index b651a55..867ca93 100644
--- a/crypto/serpent.c
+++ b/crypto/serpent.c
@@ -21,16 +21,12 @@
 #include <asm/byteorder.h>
 #include <linux/crypto.h>
 #include <linux/types.h>
+#include <crypto/serpent.h>
 
 /* Key is padded to the maximum of 256 bits before round key generation.
  * Any key length <= 256 bits (32 bytes) is allowed by the algorithm.
  */
 
-#define SERPENT_MIN_KEY_SIZE		  0
-#define SERPENT_MAX_KEY_SIZE		 32
-#define SERPENT_EXPKEY_WORDS		132
-#define SERPENT_BLOCK_SIZE		 16
-
 #define PHI 0x9e3779b9UL
 
 #define keyiter(a,b,c,d,i,j) \
@@ -210,13 +206,7 @@
 	x1 ^= x4;	x3 ^= x4;	x4 &= x0;	\
 	x4 ^= x2;
 
-struct serpent_ctx {
-	u32 expkey[SERPENT_EXPKEY_WORDS];
-};
-
-
-static int serpent_setkey(struct crypto_tfm *tfm, const u8 *key,
-			  unsigned int keylen)
+int serpent_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen)
 {
 	struct serpent_ctx *ctx = crypto_tfm_ctx(tfm);
 	u32 *k = ctx->expkey;
@@ -359,12 +349,11 @@ static int serpent_setkey(struct crypto_tfm *tfm, const u8 *key,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(serpent_setkey);
 
-static void serpent_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+void __serpent_encrypt(struct serpent_ctx *ctx, u8 *dst, const u8 *src)
 {
-	struct serpent_ctx *ctx = crypto_tfm_ctx(tfm);
-	const u32
-		*k = ctx->expkey;
+	const u32 *k = ctx->expkey;
 	const __le32 *s = (const __le32 *)src;
 	__le32	*d = (__le32 *)dst;
 	u32	r0, r1, r2, r3, r4;
@@ -418,12 +407,18 @@ static void serpent_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	d[2] = cpu_to_le32(r2);
 	d[3] = cpu_to_le32(r3);
 }
+EXPORT_SYMBOL_GPL(__serpent_encrypt);
 
-static void serpent_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static void serpent_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct serpent_ctx *ctx = crypto_tfm_ctx(tfm);
-	const u32
-		*k = ((struct serpent_ctx *)ctx)->expkey;
+
+	__serpent_encrypt(ctx, dst, src);
+}
+
+void __serpent_decrypt(struct serpent_ctx *ctx, u8 *dst, const u8 *src)
+{
+	const u32 *k = ctx->expkey;
 	const __le32 *s = (const __le32 *)src;
 	__le32	*d = (__le32 *)dst;
 	u32	r0, r1, r2, r3, r4;
@@ -472,6 +467,14 @@ static void serpent_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	d[2] = cpu_to_le32(r1);
 	d[3] = cpu_to_le32(r4);
 }
+EXPORT_SYMBOL_GPL(__serpent_decrypt);
+
+static void serpent_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+{
+	struct serpent_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	__serpent_decrypt(ctx, dst, src);
+}
 
 static struct crypto_alg serpent_alg = {
 	.cra_name		=	"serpent",
diff --git a/include/crypto/serpent.h b/include/crypto/serpent.h
new file mode 100644
index 0000000..40df885
--- /dev/null
+++ b/include/crypto/serpent.h
@@ -0,0 +1,25 @@
+/*
+ * Common values for serpent algorithms
+ */
+
+#ifndef _CRYPTO_SERPENT_H
+#define _CRYPTO_SERPENT_H
+
+#include <linux/types.h>
+#include <linux/crypto.h>
+
+#define SERPENT_MIN_KEY_SIZE		  0
+#define SERPENT_MAX_KEY_SIZE		 32
+#define SERPENT_EXPKEY_WORDS		132
+#define SERPENT_BLOCK_SIZE		 16
+
+struct serpent_ctx {
+	u32 expkey[SERPENT_EXPKEY_WORDS];
+};
+
+int serpent_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen);
+
+void __serpent_encrypt(struct serpent_ctx *ctx, u8 *dst, const u8 *src);
+void __serpent_decrypt(struct serpent_ctx *ctx, u8 *dst, const u8 *src);
+
+#endif
