From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 2/3] [v2] crypto: camellia-x86_64 - share common functions and
 move structures and function definitions to header file
Date: Fri, 26 Oct 2012 14:48:56 +0300
Message-ID: <20121026114856.3373.67242.stgit@localhost6.localdomain6>
References: <20121026114845.3373.17236.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:35678 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932403Ab2JZLs7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 26 Oct 2012 07:48:59 -0400
In-Reply-To: <20121026114845.3373.17236.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Prepare camellia-x86_64 functions to be reused from AVX/AESNI implementation
module.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/camellia_glue.c        |   80 +++++++++----------------------
 arch/x86/include/asm/crypto/camellia.h |   82 ++++++++++++++++++++++++++++++++
 2 files changed, 105 insertions(+), 57 deletions(-)
 create mode 100644 arch/x86/include/asm/crypto/camellia.h

diff --git a/arch/x86/crypto/camellia_glue.c b/arch/x86/crypto/camellia_glue.c
index 021a008..5cb86cc 100644
--- a/arch/x86/crypto/camellia_glue.c
+++ b/arch/x86/crypto/camellia_glue.c
@@ -32,53 +32,24 @@
 #include <crypto/algapi.h>
 #include <crypto/lrw.h>
 #include <crypto/xts.h>
+#include <asm/crypto/camellia.h>
 #include <asm/crypto/glue_helper.h>
 
-#define CAMELLIA_MIN_KEY_SIZE	16
-#define CAMELLIA_MAX_KEY_SIZE	32
-#define CAMELLIA_BLOCK_SIZE	16
-#define CAMELLIA_TABLE_BYTE_LEN	272
-
-struct camellia_ctx {
-	u64 key_table[CAMELLIA_TABLE_BYTE_LEN / sizeof(u64)];
-	u32 key_length;
-};
-
 /* regular block cipher functions */
 asmlinkage void __camellia_enc_blk(struct camellia_ctx *ctx, u8 *dst,
 				   const u8 *src, bool xor);
+EXPORT_SYMBOL_GPL(__camellia_enc_blk);
 asmlinkage void camellia_dec_blk(struct camellia_ctx *ctx, u8 *dst,
 				 const u8 *src);
+EXPORT_SYMBOL_GPL(camellia_dec_blk);
 
 /* 2-way parallel cipher functions */
 asmlinkage void __camellia_enc_blk_2way(struct camellia_ctx *ctx, u8 *dst,
 					const u8 *src, bool xor);
+EXPORT_SYMBOL_GPL(__camellia_enc_blk_2way);
 asmlinkage void camellia_dec_blk_2way(struct camellia_ctx *ctx, u8 *dst,
 				      const u8 *src);
-
-static inline void camellia_enc_blk(struct camellia_ctx *ctx, u8 *dst,
-				    const u8 *src)
-{
-	__camellia_enc_blk(ctx, dst, src, false);
-}
-
-static inline void camellia_enc_blk_xor(struct camellia_ctx *ctx, u8 *dst,
-					const u8 *src)
-{
-	__camellia_enc_blk(ctx, dst, src, true);
-}
-
-static inline void camellia_enc_blk_2way(struct camellia_ctx *ctx, u8 *dst,
-					 const u8 *src)
-{
-	__camellia_enc_blk_2way(ctx, dst, src, false);
-}
-
-static inline void camellia_enc_blk_xor_2way(struct camellia_ctx *ctx, u8 *dst,
-					     const u8 *src)
-{
-	__camellia_enc_blk_2way(ctx, dst, src, true);
-}
+EXPORT_SYMBOL_GPL(camellia_dec_blk_2way);
 
 static void camellia_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
@@ -1275,9 +1246,8 @@ static void camellia_setup192(const unsigned char *key, u64 *subkey)
 	camellia_setup256(kk, subkey);
 }
 
-static int __camellia_setkey(struct camellia_ctx *cctx,
-			     const unsigned char *key,
-			     unsigned int key_len, u32 *flags)
+int __camellia_setkey(struct camellia_ctx *cctx, const unsigned char *key,
+		      unsigned int key_len, u32 *flags)
 {
 	if (key_len != 16 && key_len != 24 && key_len != 32) {
 		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
@@ -1300,6 +1270,7 @@ static int __camellia_setkey(struct camellia_ctx *cctx,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(__camellia_setkey);
 
 static int camellia_setkey(struct crypto_tfm *tfm, const u8 *in_key,
 			   unsigned int key_len)
@@ -1308,7 +1279,7 @@ static int camellia_setkey(struct crypto_tfm *tfm, const u8 *in_key,
 				 &tfm->crt_flags);
 }
 
-static void camellia_decrypt_cbc_2way(void *ctx, u128 *dst, const u128 *src)
+void camellia_decrypt_cbc_2way(void *ctx, u128 *dst, const u128 *src)
 {
 	u128 iv = *src;
 
@@ -1316,8 +1287,9 @@ static void camellia_decrypt_cbc_2way(void *ctx, u128 *dst, const u128 *src)
 
 	u128_xor(&dst[1], &dst[1], &iv);
 }
+EXPORT_SYMBOL_GPL(camellia_decrypt_cbc_2way);
 
-static void camellia_crypt_ctr(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+void camellia_crypt_ctr(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 {
 	be128 ctrblk;
 
@@ -1329,9 +1301,9 @@ static void camellia_crypt_ctr(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 
 	camellia_enc_blk_xor(ctx, (u8 *)dst, (u8 *)&ctrblk);
 }
+EXPORT_SYMBOL_GPL(camellia_crypt_ctr);
 
-static void camellia_crypt_ctr_2way(void *ctx, u128 *dst, const u128 *src,
-				    le128 *iv)
+void camellia_crypt_ctr_2way(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 {
 	be128 ctrblks[2];
 
@@ -1347,6 +1319,7 @@ static void camellia_crypt_ctr_2way(void *ctx, u128 *dst, const u128 *src,
 
 	camellia_enc_blk_xor_2way(ctx, (u8 *)dst, (u8 *)ctrblks);
 }
+EXPORT_SYMBOL_GPL(camellia_crypt_ctr_2way);
 
 static const struct common_glue_ctx camellia_enc = {
 	.num_funcs = 2,
@@ -1464,13 +1437,8 @@ static void decrypt_callback(void *priv, u8 *srcdst, unsigned int nbytes)
 		camellia_dec_blk(ctx, srcdst, srcdst);
 }
 
-struct camellia_lrw_ctx {
-	struct lrw_table_ctx lrw_table;
-	struct camellia_ctx camellia_ctx;
-};
-
-static int lrw_camellia_setkey(struct crypto_tfm *tfm, const u8 *key,
-			      unsigned int keylen)
+int lrw_camellia_setkey(struct crypto_tfm *tfm, const u8 *key,
+			unsigned int keylen)
 {
 	struct camellia_lrw_ctx *ctx = crypto_tfm_ctx(tfm);
 	int err;
@@ -1484,6 +1452,7 @@ static int lrw_camellia_setkey(struct crypto_tfm *tfm, const u8 *key,
 	return lrw_init_table(&ctx->lrw_table,
 			      key + keylen - CAMELLIA_BLOCK_SIZE);
 }
+EXPORT_SYMBOL_GPL(lrw_camellia_setkey);
 
 static int lrw_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 		       struct scatterlist *src, unsigned int nbytes)
@@ -1519,20 +1488,16 @@ static int lrw_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 	return lrw_crypt(desc, dst, src, nbytes, &req);
 }
 
-static void lrw_exit_tfm(struct crypto_tfm *tfm)
+void lrw_camellia_exit_tfm(struct crypto_tfm *tfm)
 {
 	struct camellia_lrw_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	lrw_free_table(&ctx->lrw_table);
 }
+EXPORT_SYMBOL_GPL(lrw_camellia_exit_tfm);
 
-struct camellia_xts_ctx {
-	struct camellia_ctx tweak_ctx;
-	struct camellia_ctx crypt_ctx;
-};
-
-static int xts_camellia_setkey(struct crypto_tfm *tfm, const u8 *key,
-			      unsigned int keylen)
+int xts_camellia_setkey(struct crypto_tfm *tfm, const u8 *key,
+			unsigned int keylen)
 {
 	struct camellia_xts_ctx *ctx = crypto_tfm_ctx(tfm);
 	u32 *flags = &tfm->crt_flags;
@@ -1555,6 +1520,7 @@ static int xts_camellia_setkey(struct crypto_tfm *tfm, const u8 *key,
 	return __camellia_setkey(&ctx->tweak_ctx, key + keylen / 2, keylen / 2,
 				flags);
 }
+EXPORT_SYMBOL_GPL(xts_camellia_setkey);
 
 static int xts_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 		       struct scatterlist *src, unsigned int nbytes)
@@ -1679,7 +1645,7 @@ static struct crypto_alg camellia_algs[6] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_blkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_exit		= lrw_exit_tfm,
+	.cra_exit		= lrw_camellia_exit_tfm,
 	.cra_u = {
 		.blkcipher = {
 			.min_keysize	= CAMELLIA_MIN_KEY_SIZE +
diff --git a/arch/x86/include/asm/crypto/camellia.h b/arch/x86/include/asm/crypto/camellia.h
new file mode 100644
index 0000000..98038ad
--- /dev/null
+++ b/arch/x86/include/asm/crypto/camellia.h
@@ -0,0 +1,82 @@
+#ifndef ASM_X86_CAMELLIA_H
+#define ASM_X86_CAMELLIA_H
+
+#include <linux/kernel.h>
+#include <linux/crypto.h>
+
+#define CAMELLIA_MIN_KEY_SIZE	16
+#define CAMELLIA_MAX_KEY_SIZE	32
+#define CAMELLIA_BLOCK_SIZE	16
+#define CAMELLIA_TABLE_BYTE_LEN	272
+#define CAMELLIA_PARALLEL_BLOCKS 2
+
+struct camellia_ctx {
+	u64 key_table[CAMELLIA_TABLE_BYTE_LEN / sizeof(u64)];
+	u32 key_length;
+};
+
+struct camellia_lrw_ctx {
+	struct lrw_table_ctx lrw_table;
+	struct camellia_ctx camellia_ctx;
+};
+
+struct camellia_xts_ctx {
+	struct camellia_ctx tweak_ctx;
+	struct camellia_ctx crypt_ctx;
+};
+
+extern int __camellia_setkey(struct camellia_ctx *cctx,
+			     const unsigned char *key,
+			     unsigned int key_len, u32 *flags);
+
+extern int lrw_camellia_setkey(struct crypto_tfm *tfm, const u8 *key,
+			       unsigned int keylen);
+extern void lrw_camellia_exit_tfm(struct crypto_tfm *tfm);
+
+extern int xts_camellia_setkey(struct crypto_tfm *tfm, const u8 *key,
+			       unsigned int keylen);
+
+/* regular block cipher functions */
+asmlinkage void __camellia_enc_blk(struct camellia_ctx *ctx, u8 *dst,
+				   const u8 *src, bool xor);
+asmlinkage void camellia_dec_blk(struct camellia_ctx *ctx, u8 *dst,
+				 const u8 *src);
+
+/* 2-way parallel cipher functions */
+asmlinkage void __camellia_enc_blk_2way(struct camellia_ctx *ctx, u8 *dst,
+					const u8 *src, bool xor);
+asmlinkage void camellia_dec_blk_2way(struct camellia_ctx *ctx, u8 *dst,
+				      const u8 *src);
+
+static inline void camellia_enc_blk(struct camellia_ctx *ctx, u8 *dst,
+				    const u8 *src)
+{
+	__camellia_enc_blk(ctx, dst, src, false);
+}
+
+static inline void camellia_enc_blk_xor(struct camellia_ctx *ctx, u8 *dst,
+					const u8 *src)
+{
+	__camellia_enc_blk(ctx, dst, src, true);
+}
+
+static inline void camellia_enc_blk_2way(struct camellia_ctx *ctx, u8 *dst,
+					 const u8 *src)
+{
+	__camellia_enc_blk_2way(ctx, dst, src, false);
+}
+
+static inline void camellia_enc_blk_xor_2way(struct camellia_ctx *ctx, u8 *dst,
+					     const u8 *src)
+{
+	__camellia_enc_blk_2way(ctx, dst, src, true);
+}
+
+/* glue helpers */
+extern void camellia_decrypt_cbc_2way(void *ctx, u128 *dst, const u128 *src);
+extern void camellia_crypt_ctr(void *ctx, u128 *dst, const u128 *src,
+			       le128 *iv);
+extern void camellia_crypt_ctr_2way(void *ctx, u128 *dst, const u128 *src,
+				    le128 *iv);
+
+#endif /* ASM_X86_CAMELLIA_H */
