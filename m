From: Martin Willi <martin@strongswan.org>
Subject: [PATCH 02/10] crypto: chacha20 - Export common ChaCha20 helpers
Date: Tue,  7 Jul 2015 21:36:48 +0200
Message-ID: <1436297816-16414-3-git-send-email-martin@strongswan.org>
References: <1436297816-16414-1-git-send-email-martin@strongswan.org>
Cc: x86@kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from revosec.ch ([5.148.177.19]:44662 "EHLO revosec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933244AbbGGThU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Jul 2015 15:37:20 -0400
In-Reply-To: <1436297816-16414-1-git-send-email-martin@strongswan.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

As architecture specific drivers need a software fallback, export a
ChaCha20 en-/decryption function together with some helpers in a header
file.

Signed-off-by: Martin Willi <martin@strongswan.org>
---
 crypto/chacha20_generic.c | 28 ++++++++++++----------------
 crypto/chacha20poly1305.c |  3 +--
 include/crypto/chacha20.h | 25 +++++++++++++++++++++++++
 3 files changed, 38 insertions(+), 18 deletions(-)
 create mode 100644 include/crypto/chacha20.h

diff --git a/crypto/chacha20_generic.c b/crypto/chacha20_generic.c
index fa42e70..da9c899 100644
--- a/crypto/chacha20_generic.c
+++ b/crypto/chacha20_generic.c
@@ -13,14 +13,7 @@
 #include <linux/crypto.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-
-#define CHACHA20_NONCE_SIZE 16
-#define CHACHA20_KEY_SIZE   32
-#define CHACHA20_BLOCK_SIZE 64
-
-struct chacha20_ctx {
-	u32 key[8];
-};
+#include <crypto/chacha20.h>
 
 static inline u32 rotl32(u32 v, u8 n)
 {
@@ -108,7 +101,7 @@ static void chacha20_docrypt(u32 *state, u8 *dst, const u8 *src,
 	}
 }
 
-static void chacha20_init(u32 *state, struct chacha20_ctx *ctx, u8 *iv)
+void crypto_chacha20_init(u32 *state, struct chacha20_ctx *ctx, u8 *iv)
 {
 	static const char constant[16] = "expand 32-byte k";
 
@@ -129,8 +122,9 @@ static void chacha20_init(u32 *state, struct chacha20_ctx *ctx, u8 *iv)
 	state[14] = le32_to_cpuvp(iv +  8);
 	state[15] = le32_to_cpuvp(iv + 12);
 }
+EXPORT_SYMBOL_GPL(crypto_chacha20_init);
 
-static int chacha20_setkey(struct crypto_tfm *tfm, const u8 *key,
+int crypto_chacha20_setkey(struct crypto_tfm *tfm, const u8 *key,
 			   unsigned int keysize)
 {
 	struct chacha20_ctx *ctx = crypto_tfm_ctx(tfm);
@@ -144,8 +138,9 @@ static int chacha20_setkey(struct crypto_tfm *tfm, const u8 *key,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(crypto_chacha20_setkey);
 
-static int chacha20_crypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+int crypto_chacha20_crypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 			  struct scatterlist *src, unsigned int nbytes)
 {
 	struct blkcipher_walk walk;
@@ -155,7 +150,7 @@ static int chacha20_crypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt_block(desc, &walk, CHACHA20_BLOCK_SIZE);
 
-	chacha20_init(state, crypto_blkcipher_ctx(desc->tfm), walk.iv);
+	crypto_chacha20_init(state, crypto_blkcipher_ctx(desc->tfm), walk.iv);
 
 	while (walk.nbytes >= CHACHA20_BLOCK_SIZE) {
 		chacha20_docrypt(state, walk.dst.virt.addr, walk.src.virt.addr,
@@ -172,6 +167,7 @@ static int chacha20_crypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 
 	return err;
 }
+EXPORT_SYMBOL_GPL(crypto_chacha20_crypt);
 
 static struct crypto_alg alg = {
 	.cra_name		= "chacha20",
@@ -187,11 +183,11 @@ static struct crypto_alg alg = {
 		.blkcipher = {
 			.min_keysize	= CHACHA20_KEY_SIZE,
 			.max_keysize	= CHACHA20_KEY_SIZE,
-			.ivsize		= CHACHA20_NONCE_SIZE,
+			.ivsize		= CHACHA20_IV_SIZE,
 			.geniv		= "seqiv",
-			.setkey		= chacha20_setkey,
-			.encrypt	= chacha20_crypt,
-			.decrypt	= chacha20_crypt,
+			.setkey		= crypto_chacha20_setkey,
+			.encrypt	= crypto_chacha20_crypt,
+			.decrypt	= crypto_chacha20_crypt,
 		},
 	},
 };
diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
index 7b46ed7..c9a36a9 100644
--- a/crypto/chacha20poly1305.c
+++ b/crypto/chacha20poly1305.c
@@ -13,6 +13,7 @@
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
+#include <crypto/chacha20.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -23,8 +24,6 @@
 #define POLY1305_BLOCK_SIZE	16
 #define POLY1305_DIGEST_SIZE	16
 #define POLY1305_KEY_SIZE	32
-#define CHACHA20_KEY_SIZE	32
-#define CHACHA20_IV_SIZE	16
 #define CHACHAPOLY_IV_SIZE	12
 
 struct chachapoly_instance_ctx {
diff --git a/include/crypto/chacha20.h b/include/crypto/chacha20.h
new file mode 100644
index 0000000..274bbae
--- /dev/null
+++ b/include/crypto/chacha20.h
@@ -0,0 +1,25 @@
+/*
+ * Common values for the ChaCha20 algorithm
+ */
+
+#ifndef _CRYPTO_CHACHA20_H
+#define _CRYPTO_CHACHA20_H
+
+#include <linux/types.h>
+#include <linux/crypto.h>
+
+#define CHACHA20_IV_SIZE	16
+#define CHACHA20_KEY_SIZE	32
+#define CHACHA20_BLOCK_SIZE	64
+
+struct chacha20_ctx {
+	u32 key[8];
+};
+
+void crypto_chacha20_init(u32 *state, struct chacha20_ctx *ctx, u8 *iv);
+int crypto_chacha20_setkey(struct crypto_tfm *tfm, const u8 *key,
+			   unsigned int keysize);
+int crypto_chacha20_crypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+			  struct scatterlist *src, unsigned int nbytes);
+
+#endif
-- 
1.9.1
