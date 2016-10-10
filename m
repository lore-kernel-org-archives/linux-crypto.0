From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH] crypto: cmac - fix alignment of 'consts'
Date: Mon, 10 Oct 2016 10:15:15 -0700
Message-ID: <1476119715-71397-2-git-send-email-ebiggers@google.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The per-transform 'consts' array is accessed as __be64 in
crypto_cmac_digest_setkey() but was only guaranteed to be aligned to
__alignof__(long).  Fix this by aligning it to __alignof__(__be64).

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/cmac.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/crypto/cmac.c b/crypto/cmac.c
index b6c4059..04080dc 100644
--- a/crypto/cmac.c
+++ b/crypto/cmac.c
@@ -57,7 +57,8 @@ static int crypto_cmac_digest_setkey(struct crypto_shash *parent,
 	unsigned long alignmask = crypto_shash_alignmask(parent);
 	struct cmac_tfm_ctx *ctx = crypto_shash_ctx(parent);
 	unsigned int bs = crypto_shash_blocksize(parent);
-	__be64 *consts = PTR_ALIGN((void *)ctx->ctx, alignmask + 1);
+	__be64 *consts = PTR_ALIGN((void *)ctx->ctx,
+				   (alignmask | (__alignof__(__be64) - 1)) + 1);
 	u64 _const[2];
 	int i, err = 0;
 	u8 msb_mask, gfmask;
@@ -173,7 +174,8 @@ static int crypto_cmac_digest_final(struct shash_desc *pdesc, u8 *out)
 	struct cmac_desc_ctx *ctx = shash_desc_ctx(pdesc);
 	struct crypto_cipher *tfm = tctx->child;
 	int bs = crypto_shash_blocksize(parent);
-	u8 *consts = PTR_ALIGN((void *)tctx->ctx, alignmask + 1);
+	u8 *consts = PTR_ALIGN((void *)tctx->ctx,
+			       (alignmask | (__alignof__(__be64) - 1)) + 1);
 	u8 *odds = PTR_ALIGN((void *)ctx->ctx, alignmask + 1);
 	u8 *prev = odds + bs;
 	unsigned int offset = 0;
@@ -258,7 +260,8 @@ static int cmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (err)
 		goto out_free_inst;
 
-	alignmask = alg->cra_alignmask | (sizeof(long) - 1);
+	/* We access the data as u32s when xoring. */
+	alignmask = alg->cra_alignmask | (__alignof__(u32) - 1);
 	inst->alg.base.cra_alignmask = alignmask;
 	inst->alg.base.cra_priority = alg->cra_priority;
 	inst->alg.base.cra_blocksize = alg->cra_blocksize;
@@ -270,7 +273,9 @@ static int cmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 		+ alg->cra_blocksize * 2;
 
 	inst->alg.base.cra_ctxsize =
-		ALIGN(sizeof(struct cmac_tfm_ctx), alignmask + 1)
+		ALIGN(sizeof(struct cmac_tfm_ctx), crypto_tfm_ctx_alignment())
+		+ ((alignmask | (__alignof__(__be64) - 1)) &
+		   ~(crypto_tfm_ctx_alignment() - 1))
 		+ alg->cra_blocksize * 2;
 
 	inst->alg.base.cra_init = cmac_init_tfm;
-- 
2.8.0.rc3.226.g39d4020
