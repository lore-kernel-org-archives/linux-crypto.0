From: Martin Willi <martin@strongswan.org>
Subject: [PATCH v2 07/10] crypto: poly1305 - Export common Poly1305 helpers
Date: Thu, 16 Jul 2015 19:14:05 +0200
Message-ID: <1437066848-18048-8-git-send-email-martin@strongswan.org>
References: <1437066848-18048-1-git-send-email-martin@strongswan.org>
Cc: x86@kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from revosec.ch ([5.148.177.19]:45572 "EHLO revosec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755338AbbGPROW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Jul 2015 13:14:22 -0400
In-Reply-To: <1437066848-18048-1-git-send-email-martin@strongswan.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

As architecture specific drivers need a software fallback, export Poly1305
init/update/final functions together with some helpers in a header file.

Signed-off-by: Martin Willi <martin@strongswan.org>
---
 crypto/chacha20poly1305.c |  4 +--
 crypto/poly1305_generic.c | 73 +++++++++++++++++++++++------------------------
 include/crypto/poly1305.h | 41 ++++++++++++++++++++++++++
 3 files changed, 77 insertions(+), 41 deletions(-)
 create mode 100644 include/crypto/poly1305.h

diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
index 410554d..b71445f 100644
--- a/crypto/chacha20poly1305.c
+++ b/crypto/chacha20poly1305.c
@@ -14,6 +14,7 @@
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/chacha20.h>
+#include <crypto/poly1305.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -21,9 +22,6 @@
 
 #include "internal.h"
 
-#define POLY1305_BLOCK_SIZE	16
-#define POLY1305_DIGEST_SIZE	16
-#define POLY1305_KEY_SIZE	32
 #define CHACHAPOLY_IV_SIZE	12
 
 struct chachapoly_instance_ctx {
diff --git a/crypto/poly1305_generic.c b/crypto/poly1305_generic.c
index 387b5c8..2df9835d 100644
--- a/crypto/poly1305_generic.c
+++ b/crypto/poly1305_generic.c
@@ -13,31 +13,11 @@
 
 #include <crypto/algapi.h>
 #include <crypto/internal/hash.h>
+#include <crypto/poly1305.h>
 #include <linux/crypto.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 
-#define POLY1305_BLOCK_SIZE	16
-#define POLY1305_KEY_SIZE	32
-#define POLY1305_DIGEST_SIZE	16
-
-struct poly1305_desc_ctx {
-	/* key */
-	u32 r[5];
-	/* finalize key */
-	u32 s[4];
-	/* accumulator */
-	u32 h[5];
-	/* partial buffer */
-	u8 buf[POLY1305_BLOCK_SIZE];
-	/* bytes used in partial buffer */
-	unsigned int buflen;
-	/* r key has been set */
-	bool rset;
-	/* s key has been set */
-	bool sset;
-};
-
 static inline u64 mlt(u64 a, u64 b)
 {
 	return a * b;
@@ -58,7 +38,7 @@ static inline u32 le32_to_cpuvp(const void *p)
 	return le32_to_cpup(p);
 }
 
-static int poly1305_init(struct shash_desc *desc)
+int crypto_poly1305_init(struct shash_desc *desc)
 {
 	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
 
@@ -69,8 +49,9 @@ static int poly1305_init(struct shash_desc *desc)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(crypto_poly1305_init);
 
-static int poly1305_setkey(struct crypto_shash *tfm,
+int crypto_poly1305_setkey(struct crypto_shash *tfm,
 			   const u8 *key, unsigned int keylen)
 {
 	/* Poly1305 requires a unique key for each tag, which implies that
@@ -79,6 +60,7 @@ static int poly1305_setkey(struct crypto_shash *tfm,
 	 * the update() call. */
 	return -ENOTSUPP;
 }
+EXPORT_SYMBOL_GPL(crypto_poly1305_setkey);
 
 static void poly1305_setrkey(struct poly1305_desc_ctx *dctx, const u8 *key)
 {
@@ -98,16 +80,10 @@ static void poly1305_setskey(struct poly1305_desc_ctx *dctx, const u8 *key)
 	dctx->s[3] = le32_to_cpuvp(key + 12);
 }
 
-static unsigned int poly1305_blocks(struct poly1305_desc_ctx *dctx,
-				    const u8 *src, unsigned int srclen,
-				    u32 hibit)
+unsigned int crypto_poly1305_setdesckey(struct poly1305_desc_ctx *dctx,
+					const u8 *src, unsigned int srclen)
 {
-	u32 r0, r1, r2, r3, r4;
-	u32 s1, s2, s3, s4;
-	u32 h0, h1, h2, h3, h4;
-	u64 d0, d1, d2, d3, d4;
-
-	if (unlikely(!dctx->sset)) {
+	if (!dctx->sset) {
 		if (!dctx->rset && srclen >= POLY1305_BLOCK_SIZE) {
 			poly1305_setrkey(dctx, src);
 			src += POLY1305_BLOCK_SIZE;
@@ -121,6 +97,25 @@ static unsigned int poly1305_blocks(struct poly1305_desc_ctx *dctx,
 			dctx->sset = true;
 		}
 	}
+	return srclen;
+}
+EXPORT_SYMBOL_GPL(crypto_poly1305_setdesckey);
+
+static unsigned int poly1305_blocks(struct poly1305_desc_ctx *dctx,
+				    const u8 *src, unsigned int srclen,
+				    u32 hibit)
+{
+	u32 r0, r1, r2, r3, r4;
+	u32 s1, s2, s3, s4;
+	u32 h0, h1, h2, h3, h4;
+	u64 d0, d1, d2, d3, d4;
+	unsigned int datalen;
+
+	if (unlikely(!dctx->sset)) {
+		datalen = crypto_poly1305_setdesckey(dctx, src, srclen);
+		src += srclen - datalen;
+		srclen = datalen;
+	}
 
 	r0 = dctx->r[0];
 	r1 = dctx->r[1];
@@ -181,7 +176,7 @@ static unsigned int poly1305_blocks(struct poly1305_desc_ctx *dctx,
 	return srclen;
 }
 
-static int poly1305_update(struct shash_desc *desc,
+int crypto_poly1305_update(struct shash_desc *desc,
 			   const u8 *src, unsigned int srclen)
 {
 	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
@@ -214,8 +209,9 @@ static int poly1305_update(struct shash_desc *desc,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(crypto_poly1305_update);
 
-static int poly1305_final(struct shash_desc *desc, u8 *dst)
+int crypto_poly1305_final(struct shash_desc *desc, u8 *dst)
 {
 	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
 	__le32 *mac = (__le32 *)dst;
@@ -282,13 +278,14 @@ static int poly1305_final(struct shash_desc *desc, u8 *dst)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(crypto_poly1305_final);
 
 static struct shash_alg poly1305_alg = {
 	.digestsize	= POLY1305_DIGEST_SIZE,
-	.init		= poly1305_init,
-	.update		= poly1305_update,
-	.final		= poly1305_final,
-	.setkey		= poly1305_setkey,
+	.init		= crypto_poly1305_init,
+	.update		= crypto_poly1305_update,
+	.final		= crypto_poly1305_final,
+	.setkey		= crypto_poly1305_setkey,
 	.descsize	= sizeof(struct poly1305_desc_ctx),
 	.base		= {
 		.cra_name		= "poly1305",
diff --git a/include/crypto/poly1305.h b/include/crypto/poly1305.h
new file mode 100644
index 0000000..894df59
--- /dev/null
+++ b/include/crypto/poly1305.h
@@ -0,0 +1,41 @@
+/*
+ * Common values for the Poly1305 algorithm
+ */
+
+#ifndef _CRYPTO_POLY1305_H
+#define _CRYPTO_POLY1305_H
+
+#include <linux/types.h>
+#include <linux/crypto.h>
+
+#define POLY1305_BLOCK_SIZE	16
+#define POLY1305_KEY_SIZE	32
+#define POLY1305_DIGEST_SIZE	16
+
+struct poly1305_desc_ctx {
+	/* key */
+	u32 r[5];
+	/* finalize key */
+	u32 s[4];
+	/* accumulator */
+	u32 h[5];
+	/* partial buffer */
+	u8 buf[POLY1305_BLOCK_SIZE];
+	/* bytes used in partial buffer */
+	unsigned int buflen;
+	/* r key has been set */
+	bool rset;
+	/* s key has been set */
+	bool sset;
+};
+
+int crypto_poly1305_init(struct shash_desc *desc);
+int crypto_poly1305_setkey(struct crypto_shash *tfm,
+			   const u8 *key, unsigned int keylen);
+unsigned int crypto_poly1305_setdesckey(struct poly1305_desc_ctx *dctx,
+					const u8 *src, unsigned int srclen);
+int crypto_poly1305_update(struct shash_desc *desc,
+			   const u8 *src, unsigned int srclen);
+int crypto_poly1305_final(struct shash_desc *desc, u8 *dst);
+
+#endif
-- 
1.9.1
