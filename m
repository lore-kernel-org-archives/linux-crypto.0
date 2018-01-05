From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH v2 2/3] crypto: salsa20 - export generic helpers
Date: Fri,  5 Jan 2018 11:09:58 -0800
Message-ID: <20180105190959.89682-3-ebiggers3@gmail.com>
References: <20180105190959.89682-1-ebiggers3@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:40190 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752231AbeAETLZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jan 2018 14:11:25 -0500
Received: by mail-io0-f195.google.com with SMTP id v30so6773201iov.7
        for <linux-crypto@vger.kernel.org>; Fri, 05 Jan 2018 11:11:25 -0800 (PST)
In-Reply-To: <20180105190959.89682-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Export the Salsa20 constants, transform context, and initialization
functions so that they can be reused by the x86 implementation.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/salsa20_generic.c | 20 +++++++-------------
 include/crypto/salsa20.h | 27 +++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 13 deletions(-)
 create mode 100644 include/crypto/salsa20.h

diff --git a/crypto/salsa20_generic.c b/crypto/salsa20_generic.c
index 8c77bc78a09f..5074006a56c3 100644
--- a/crypto/salsa20_generic.c
+++ b/crypto/salsa20_generic.c
@@ -21,17 +21,9 @@
 
 #include <asm/unaligned.h>
 #include <crypto/internal/skcipher.h>
+#include <crypto/salsa20.h>
 #include <linux/module.h>
 
-#define SALSA20_IV_SIZE        8
-#define SALSA20_MIN_KEY_SIZE  16
-#define SALSA20_MAX_KEY_SIZE  32
-#define SALSA20_BLOCK_SIZE    64
-
-struct salsa20_ctx {
-	u32 initial_state[16];
-};
-
 static void salsa20_block(u32 *state, __le32 *stream)
 {
 	u32 x[16];
@@ -101,15 +93,16 @@ static void salsa20_docrypt(u32 *state, u8 *dst, const u8 *src,
 	}
 }
 
-static void salsa20_init(u32 *state, const struct salsa20_ctx *ctx,
+void crypto_salsa20_init(u32 *state, const struct salsa20_ctx *ctx,
 			 const u8 *iv)
 {
 	memcpy(state, ctx->initial_state, sizeof(ctx->initial_state));
 	state[6] = get_unaligned_le32(iv + 0);
 	state[7] = get_unaligned_le32(iv + 4);
 }
+EXPORT_SYMBOL_GPL(crypto_salsa20_init);
 
-static int salsa20_setkey(struct crypto_skcipher *tfm, const u8 *key,
+int crypto_salsa20_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			  unsigned int keysize)
 {
 	static const char sigma[16] = "expand 32-byte k";
@@ -150,6 +143,7 @@ static int salsa20_setkey(struct crypto_skcipher *tfm, const u8 *key,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(crypto_salsa20_setkey);
 
 static int salsa20_crypt(struct skcipher_request *req)
 {
@@ -161,7 +155,7 @@ static int salsa20_crypt(struct skcipher_request *req)
 
 	err = skcipher_walk_virt(&walk, req, true);
 
-	salsa20_init(state, ctx, walk.iv);
+	crypto_salsa20_init(state, ctx, walk.iv);
 
 	while (walk.nbytes > 0) {
 		unsigned int nbytes = walk.nbytes;
@@ -189,7 +183,7 @@ static struct skcipher_alg alg = {
 	.max_keysize		= SALSA20_MAX_KEY_SIZE,
 	.ivsize			= SALSA20_IV_SIZE,
 	.chunksize		= SALSA20_BLOCK_SIZE,
-	.setkey			= salsa20_setkey,
+	.setkey			= crypto_salsa20_setkey,
 	.encrypt		= salsa20_crypt,
 	.decrypt		= salsa20_crypt,
 };
diff --git a/include/crypto/salsa20.h b/include/crypto/salsa20.h
new file mode 100644
index 000000000000..19ed48aefc86
--- /dev/null
+++ b/include/crypto/salsa20.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Common values for the Salsa20 algorithm
+ */
+
+#ifndef _CRYPTO_SALSA20_H
+#define _CRYPTO_SALSA20_H
+
+#include <linux/types.h>
+
+#define SALSA20_IV_SIZE		8
+#define SALSA20_MIN_KEY_SIZE	16
+#define SALSA20_MAX_KEY_SIZE	32
+#define SALSA20_BLOCK_SIZE	64
+
+struct crypto_skcipher;
+
+struct salsa20_ctx {
+	u32 initial_state[16];
+};
+
+void crypto_salsa20_init(u32 *state, const struct salsa20_ctx *ctx,
+			 const u8 *iv);
+int crypto_salsa20_setkey(struct crypto_skcipher *tfm, const u8 *key,
+			  unsigned int keysize);
+
+#endif /* _CRYPTO_SALSA20_H */
-- 
2.16.0.rc0.223.g4a4ac83678-goog
