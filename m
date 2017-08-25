From: Christian Lamparter <chunkeey@googlemail.com>
Subject: [PATCH 02/12] crypto: crypto4xx: remove unused definitions and write-only variables
Date: Fri, 25 Aug 2017 15:47:15 +0200
Message-ID: <85532949069735593f777489c6efcb6d1b08cdec.1503668705.git.chunkeey@googlemail.com>
References: <71020bd2e3f4100c3c0668a13fdad9d22c8884a7.1503668705.git.chunkeey@googlemail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:32975 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755772AbdHYNra (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Aug 2017 09:47:30 -0400
Received: by mail-wm0-f66.google.com with SMTP id e67so2671436wmd.0
        for <linux-crypto@vger.kernel.org>; Fri, 25 Aug 2017 06:47:29 -0700 (PDT)
In-Reply-To: <71020bd2e3f4100c3c0668a13fdad9d22c8884a7.1503668705.git.chunkeey@googlemail.com>
In-Reply-To: <71020bd2e3f4100c3c0668a13fdad9d22c8884a7.1503668705.git.chunkeey@googlemail.com>
References: <71020bd2e3f4100c3c0668a13fdad9d22c8884a7.1503668705.git.chunkeey@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch removes several unused code and definitons
(structs, variables, ...).

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/crypto/amcc/crypto4xx_alg.c  |  6 ------
 drivers/crypto/amcc/crypto4xx_core.c |  2 +-
 drivers/crypto/amcc/crypto4xx_core.h | 16 ----------------
 3 files changed, 1 insertion(+), 23 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_alg.c b/drivers/crypto/amcc/crypto4xx_alg.c
index 4afca3968773..6da92321173b 100644
--- a/drivers/crypto/amcc/crypto4xx_alg.c
+++ b/drivers/crypto/amcc/crypto4xx_alg.c
@@ -75,7 +75,6 @@ int crypto4xx_encrypt(struct ablkcipher_request *req)
 	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
 
 	ctx->direction = DIR_OUTBOUND;
-	ctx->hash_final = 0;
 	ctx->is_hash = 0;
 	ctx->pd_ctl = 0x1;
 
@@ -89,7 +88,6 @@ int crypto4xx_decrypt(struct ablkcipher_request *req)
 	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
 
 	ctx->direction = DIR_INBOUND;
-	ctx->hash_final = 0;
 	ctx->is_hash = 0;
 	ctx->pd_ctl = 1;
 
@@ -136,7 +134,6 @@ static int crypto4xx_setkey_aes(struct crypto_ablkcipher *cipher,
 	}
 	/* Setup SA */
 	sa = (struct dynamic_sa_ctl *) ctx->sa_in;
-	ctx->hash_final = 0;
 
 	set_dynamic_sa_command_0(sa, SA_NOT_SAVE_HASH, SA_NOT_SAVE_IV,
 				 SA_LOAD_HASH_FROM_SA, SA_LOAD_IV_FROM_STATE,
@@ -191,7 +188,6 @@ static int crypto4xx_hash_alg_init(struct crypto_tfm *tfm,
 
 	ctx->dev   = my_alg->dev;
 	ctx->is_hash = 1;
-	ctx->hash_final = 0;
 
 	/* Create SA */
 	if (ctx->sa_in_dma_addr || ctx->sa_out_dma_addr)
@@ -256,7 +252,6 @@ int crypto4xx_hash_update(struct ahash_request *req)
 	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
 
 	ctx->is_hash = 1;
-	ctx->hash_final = 0;
 	ctx->pd_ctl = 0x11;
 	ctx->direction = DIR_INBOUND;
 
@@ -274,7 +269,6 @@ int crypto4xx_hash_digest(struct ahash_request *req)
 {
 	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
 
-	ctx->hash_final = 1;
 	ctx->pd_ctl = 0x11;
 	ctx->direction = DIR_INBOUND;
 
diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 3118cec0d81e..48215b8525a2 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -962,7 +962,7 @@ u32 crypto4xx_build_pd(struct crypto_async_request *req,
 
 	sa->sa_command_1.bf.hash_crypto_offset = 0;
 	pd->pd_ctl.w = ctx->pd_ctl;
-	pd->pd_ctl_len.w = 0x00400000 | (ctx->bypass << 24) | datalen;
+	pd->pd_ctl_len.w = 0x00400000 | datalen;
 	pd_uinfo->state = PD_ENTRY_INUSE;
 	wmb();
 	/* write any value to push engine to read a pd */
diff --git a/drivers/crypto/amcc/crypto4xx_core.h b/drivers/crypto/amcc/crypto4xx_core.h
index ecfdcfe3698d..8230d3f7edbe 100644
--- a/drivers/crypto/amcc/crypto4xx_core.h
+++ b/drivers/crypto/amcc/crypto4xx_core.h
@@ -72,7 +72,6 @@ struct pd_uinfo {
 struct crypto4xx_device {
 	struct crypto4xx_core_device *core_dev;
 	char *name;
-	u64  ce_phy_address;
 	void __iomem *ce_base;
 	void __iomem *trng_base;
 
@@ -127,21 +126,9 @@ struct crypto4xx_ctx {
 	u32 sa_len;
 	u32 offset_to_sr_ptr;           /* offset to state ptr, in dynamic sa */
 	u32 direction;
-	u32 next_hdr;
 	u32 save_iv;
-	u32 pd_ctl_len;
 	u32 pd_ctl;
-	u32 bypass;
 	u32 is_hash;
-	u32 hash_final;
-};
-
-struct crypto4xx_req_ctx {
-	struct crypto4xx_device *dev;	/* Device in which
-					operation to send to */
-	void *sa;
-	u32 sa_dma_addr;
-	u16 sa_len;
 };
 
 struct crypto4xx_alg_common {
@@ -172,9 +159,6 @@ static inline struct crypto4xx_alg *crypto_alg_to_crypto4xx_alg(
 
 extern int crypto4xx_alloc_sa(struct crypto4xx_ctx *ctx, u32 size);
 extern void crypto4xx_free_sa(struct crypto4xx_ctx *ctx);
-extern u32 crypto4xx_alloc_sa_rctx(struct crypto4xx_ctx *ctx,
-				   struct crypto4xx_ctx *rctx);
-extern void crypto4xx_free_sa_rctx(struct crypto4xx_ctx *rctx);
 extern void crypto4xx_free_ctx(struct crypto4xx_ctx *ctx);
 extern u32 crypto4xx_alloc_state_record(struct crypto4xx_ctx *ctx);
 extern u32 get_dynamic_sa_offset_state_ptr_field(struct crypto4xx_ctx *ctx);
-- 
2.14.1
