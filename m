From: Christian Lamparter <chunkeey@googlemail.com>
Subject: [PATCH 04/12] crypto: crypto4xx: remove extern statement before function declaration
Date: Fri, 25 Aug 2017 15:47:17 +0200
Message-ID: <44b9527904d134982932cb807a3fa6f36093acbf.1503668705.git.chunkeey@googlemail.com>
References: <71020bd2e3f4100c3c0668a13fdad9d22c8884a7.1503668705.git.chunkeey@googlemail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:36219 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755752AbdHYNr3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Aug 2017 09:47:29 -0400
Received: by mail-wr0-f194.google.com with SMTP id p8so1524991wrf.3
        for <linux-crypto@vger.kernel.org>; Fri, 25 Aug 2017 06:47:28 -0700 (PDT)
In-Reply-To: <71020bd2e3f4100c3c0668a13fdad9d22c8884a7.1503668705.git.chunkeey@googlemail.com>
In-Reply-To: <7f51944084eef13bebe5f052557533bf6ade4ebc.1503668705.git.chunkeey@googlemail.com>
References: <71020bd2e3f4100c3c0668a13fdad9d22c8884a7.1503668705.git.chunkeey@googlemail.com> <85532949069735593f777489c6efcb6d1b08cdec.1503668705.git.chunkeey@googlemail.com> <7f51944084eef13bebe5f052557533bf6ade4ebc.1503668705.git.chunkeey@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

All function declarations are "extern" by default, there is no need to
specify it explicitly.

For C99 states in 6.2.2.5:
"If the declaration of an identifier for a function has no
storage-class specifier, its linkage is determined exactly
as if it were declared with the storage-class specifier
extern."

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/crypto/amcc/crypto4xx_core.h | 48 ++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.h b/drivers/crypto/amcc/crypto4xx_core.h
index 8230d3f7edbe..995f3da91cb2 100644
--- a/drivers/crypto/amcc/crypto4xx_core.h
+++ b/drivers/crypto/amcc/crypto4xx_core.h
@@ -157,28 +157,28 @@ static inline struct crypto4xx_alg *crypto_alg_to_crypto4xx_alg(
 	return container_of(x, struct crypto4xx_alg, alg.u.cipher);
 }
 
-extern int crypto4xx_alloc_sa(struct crypto4xx_ctx *ctx, u32 size);
-extern void crypto4xx_free_sa(struct crypto4xx_ctx *ctx);
-extern void crypto4xx_free_ctx(struct crypto4xx_ctx *ctx);
-extern u32 crypto4xx_alloc_state_record(struct crypto4xx_ctx *ctx);
-extern u32 get_dynamic_sa_offset_state_ptr_field(struct crypto4xx_ctx *ctx);
-extern u32 get_dynamic_sa_offset_key_field(struct crypto4xx_ctx *ctx);
-extern u32 get_dynamic_sa_iv_size(struct crypto4xx_ctx *ctx);
-extern void crypto4xx_memcpy_le(unsigned int *dst,
-				const unsigned char *buf, int len);
-extern u32 crypto4xx_build_pd(struct crypto_async_request *req,
-			      struct crypto4xx_ctx *ctx,
-			      struct scatterlist *src,
-			      struct scatterlist *dst,
-			      unsigned int datalen,
-			      void *iv, u32 iv_len);
-extern int crypto4xx_setkey_aes_cbc(struct crypto_ablkcipher *cipher,
-				    const u8 *key, unsigned int keylen);
-extern int crypto4xx_encrypt(struct ablkcipher_request *req);
-extern int crypto4xx_decrypt(struct ablkcipher_request *req);
-extern int crypto4xx_sha1_alg_init(struct crypto_tfm *tfm);
-extern int crypto4xx_hash_digest(struct ahash_request *req);
-extern int crypto4xx_hash_final(struct ahash_request *req);
-extern int crypto4xx_hash_update(struct ahash_request *req);
-extern int crypto4xx_hash_init(struct ahash_request *req);
+int crypto4xx_alloc_sa(struct crypto4xx_ctx *ctx, u32 size);
+void crypto4xx_free_sa(struct crypto4xx_ctx *ctx);
+void crypto4xx_free_ctx(struct crypto4xx_ctx *ctx);
+u32 crypto4xx_alloc_state_record(struct crypto4xx_ctx *ctx);
+u32 get_dynamic_sa_offset_state_ptr_field(struct crypto4xx_ctx *ctx);
+u32 get_dynamic_sa_offset_key_field(struct crypto4xx_ctx *ctx);
+u32 get_dynamic_sa_iv_size(struct crypto4xx_ctx *ctx);
+void crypto4xx_memcpy_le(unsigned int *dst,
+			 const unsigned char *buf, int len);
+u32 crypto4xx_build_pd(struct crypto_async_request *req,
+		       struct crypto4xx_ctx *ctx,
+		       struct scatterlist *src,
+		       struct scatterlist *dst,
+		       unsigned int datalen,
+		       void *iv, u32 iv_len);
+int crypto4xx_setkey_aes_cbc(struct crypto_ablkcipher *cipher,
+			     const u8 *key, unsigned int keylen);
+int crypto4xx_encrypt(struct ablkcipher_request *req);
+int crypto4xx_decrypt(struct ablkcipher_request *req);
+int crypto4xx_sha1_alg_init(struct crypto_tfm *tfm);
+int crypto4xx_hash_digest(struct ahash_request *req);
+int crypto4xx_hash_final(struct ahash_request *req);
+int crypto4xx_hash_update(struct ahash_request *req);
+int crypto4xx_hash_init(struct ahash_request *req);
 #endif
-- 
2.14.1
