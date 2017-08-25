From: Christian Lamparter <chunkeey@googlemail.com>
Subject: [RFC PATCH 12/12] crypto: crypto4xx: pointer arithmetic overhaul
Date: Fri, 25 Aug 2017 15:47:25 +0200
Message-ID: <3e61a25c92a251553629d5f3702efd93c69df842.1503668705.git.chunkeey@googlemail.com>
References: <71020bd2e3f4100c3c0668a13fdad9d22c8884a7.1503668705.git.chunkeey@googlemail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:36988 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932795AbdHYNrf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Aug 2017 09:47:35 -0400
Received: by mail-wr0-f195.google.com with SMTP id p14so1519068wrg.4
        for <linux-crypto@vger.kernel.org>; Fri, 25 Aug 2017 06:47:35 -0700 (PDT)
In-Reply-To: <71020bd2e3f4100c3c0668a13fdad9d22c8884a7.1503668705.git.chunkeey@googlemail.com>
In-Reply-To: <e7da31017c70967765211867a902a09b2be82b2f.1503668705.git.chunkeey@googlemail.com>
References: <71020bd2e3f4100c3c0668a13fdad9d22c8884a7.1503668705.git.chunkeey@googlemail.com> <85532949069735593f777489c6efcb6d1b08cdec.1503668705.git.chunkeey@googlemail.com> <7f51944084eef13bebe5f052557533bf6ade4ebc.1503668705.git.chunkeey@googlemail.com> <44b9527904d134982932cb807a3fa6f36093acbf.1503668705.git.chunkeey@googlemail.com> <c623cda688571bc483f0c9a9fb4c17cda0514cdd.1503668705.git.chunkeey@googlemail.com> <575e998ebe72ea59e785263e11b2a44fb1c6d910.1503668705.git.chunkeey@googlemail.com> <0521bf298c4b6aeba2d1e1e89aac9929ebffd0d4.1503668705.git.chunkeey@googlemail.com> <668f5f89e62ccb2e410c5a63f35c64efe9bd0686.1503668705.git.chunkeey@googlemail.com> <26b1303367e13a4c0d61cdfbae90dbf588bcc9b5.1503668705.git.chunkeey@googlemail.com> <5ef8c95cbfd1d4e0c3aa3a4279af82a5d6ebbcc3.15036687
 05.git.chunkeey@googlemail.com> <e7da31017c70967765211867a902a09b2be82b2f.1503668705.git.chunkeey@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch improves the readability of various functions,
by replacing various void* pointers declarations with
their respective structs *. This makes it possible to go
for the eye-friendly array-indexing methods.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/crypto/amcc/crypto4xx_alg.c  | 26 ++++++++--------
 drivers/crypto/amcc/crypto4xx_core.c | 60 +++++++++++++++---------------------
 drivers/crypto/amcc/crypto4xx_core.h | 41 +++++++++++++-----------
 3 files changed, 59 insertions(+), 68 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_alg.c b/drivers/crypto/amcc/crypto4xx_alg.c
index c9597824a515..d08e4c94abed 100644
--- a/drivers/crypto/amcc/crypto4xx_alg.c
+++ b/drivers/crypto/amcc/crypto4xx_alg.c
@@ -134,7 +134,7 @@ static int crypto4xx_setkey_aes(struct crypto_ablkcipher *cipher,
 		}
 	}
 	/* Setup SA */
-	sa = (struct dynamic_sa_ctl *) ctx->sa_in;
+	sa = ctx->sa_in;
 
 	set_dynamic_sa_command_0(sa, SA_NOT_SAVE_HASH, SA_NOT_SAVE_IV,
 				 SA_LOAD_HASH_FROM_SA, SA_LOAD_IV_FROM_STATE,
@@ -159,7 +159,7 @@ static int crypto4xx_setkey_aes(struct crypto_ablkcipher *cipher,
 	ctx->offset_to_sr_ptr = get_dynamic_sa_offset_state_ptr_field(sa);
 
 	memcpy(ctx->sa_out, ctx->sa_in, ctx->sa_len * 4);
-	sa = (struct dynamic_sa_ctl *) ctx->sa_out;
+	sa = ctx->sa_out;
 	sa->sa_command_0.bf.dir = DIR_OUTBOUND;
 
 	return 0;
@@ -248,8 +248,7 @@ static int crypto4xx_hash_alg_init(struct crypto_tfm *tfm,
 	struct crypto_alg *alg = tfm->__crt_alg;
 	struct crypto4xx_alg *my_alg = crypto_alg_to_crypto4xx_alg(alg);
 	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct dynamic_sa_ctl *sa;
-	struct dynamic_sa_hash160 *sa_in;
+	struct dynamic_sa_hash160 *sa;
 	int rc;
 
 	ctx->dev   = my_alg->dev;
@@ -273,25 +272,24 @@ static int crypto4xx_hash_alg_init(struct crypto_tfm *tfm,
 
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
 				 sizeof(struct crypto4xx_ctx));
-	sa = (struct dynamic_sa_ctl *) ctx->sa_in;
-	set_dynamic_sa_command_0(sa, SA_SAVE_HASH, SA_NOT_SAVE_IV,
+	sa = (struct dynamic_sa_hash160 *)ctx->sa_in;
+	set_dynamic_sa_command_0(&sa->ctrl, SA_SAVE_HASH, SA_NOT_SAVE_IV,
 				 SA_NOT_LOAD_HASH, SA_LOAD_IV_FROM_SA,
 				 SA_NO_HEADER_PROC, ha, SA_CIPHER_ALG_NULL,
 				 SA_PAD_TYPE_ZERO, SA_OP_GROUP_BASIC,
 				 SA_OPCODE_HASH, DIR_INBOUND);
-	set_dynamic_sa_command_1(sa, 0, SA_HASH_MODE_HASH,
+	set_dynamic_sa_command_1(&sa->ctrl, 0, SA_HASH_MODE_HASH,
 				 CRYPTO_FEEDBACK_MODE_NO_FB, SA_EXTENDED_SN_OFF,
 				 SA_SEQ_MASK_OFF, SA_MC_ENABLE,
 				 SA_NOT_COPY_PAD, SA_NOT_COPY_PAYLOAD,
 				 SA_NOT_COPY_HDR);
 	ctx->direction = DIR_INBOUND;
-	sa->sa_contents.w = SA_HASH160_CONTENTS;
-	sa_in = (struct dynamic_sa_hash160 *) ctx->sa_in;
 	/* Need to zero hash digest in SA */
-	memset(sa_in->inner_digest, 0, sizeof(sa_in->inner_digest));
-	memset(sa_in->outer_digest, 0, sizeof(sa_in->outer_digest));
-	sa_in->state_ptr = ctx->state_record_dma_addr;
-	ctx->offset_to_sr_ptr = get_dynamic_sa_offset_state_ptr_field(sa);
+	memset(sa->inner_digest, 0, sizeof(sa->inner_digest));
+	memset(sa->outer_digest, 0, sizeof(sa->outer_digest));
+	sa->state_ptr = ctx->state_record_dma_addr;
+	ctx->offset_to_sr_ptr =
+		get_dynamic_sa_offset_state_ptr_field(&sa->ctrl);
 
 	return 0;
 }
@@ -302,7 +300,7 @@ int crypto4xx_hash_init(struct ahash_request *req)
 	int ds;
 	struct dynamic_sa_ctl *sa;
 
-	sa = (struct dynamic_sa_ctl *) ctx->sa_in;
+	sa = ctx->sa_in;
 	ds = crypto_ahash_digestsize(
 			__crypto_ahash_cast(req->base.tfm));
 	sa->sa_command_0.bf.digest_len = ds >> 2;
diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 817c44703a07..773e5faebc47 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -211,7 +211,7 @@ static u32 crypto4xx_build_pdr(struct crypto4xx_device *dev)
 	}
 	memset(dev->pdr, 0, sizeof(struct ce_pd) * PPC4XX_NUM_PD);
 	dev->shadow_sa_pool = dma_alloc_coherent(dev->core_dev->device,
-				   256 * PPC4XX_NUM_PD,
+				   sizeof(union shadow_sa_buf) * PPC4XX_NUM_PD,
 				   &dev->shadow_sa_pool_pa,
 				   GFP_ATOMIC);
 	if (!dev->shadow_sa_pool)
@@ -223,16 +223,14 @@ static u32 crypto4xx_build_pdr(struct crypto4xx_device *dev)
 	if (!dev->shadow_sr_pool)
 		return -ENOMEM;
 	for (i = 0; i < PPC4XX_NUM_PD; i++) {
-		pd_uinfo = (struct pd_uinfo *) (dev->pdr_uinfo +
-						sizeof(struct pd_uinfo) * i);
+		pd_uinfo = &dev->pdr_uinfo[i];
 
 		/* alloc 256 bytes which is enough for any kind of dynamic sa */
-		pd_uinfo->sa_va = dev->shadow_sa_pool + 256 * i;
+		pd_uinfo->sa_va = &dev->shadow_sa_pool[i].sa;
 		pd_uinfo->sa_pa = dev->shadow_sa_pool_pa + 256 * i;
 
 		/* alloc state record */
-		pd_uinfo->sr_va = dev->shadow_sr_pool +
-		    sizeof(struct sa_state_record) * i;
+		pd_uinfo->sr_va = &dev->shadow_sr_pool[i];
 		pd_uinfo->sr_pa = dev->shadow_sr_pool_pa +
 		    sizeof(struct sa_state_record) * i;
 	}
@@ -248,8 +246,9 @@ static void crypto4xx_destroy_pdr(struct crypto4xx_device *dev)
 				  dev->pdr, dev->pdr_pa);
 
 	if (dev->shadow_sa_pool)
-		dma_free_coherent(dev->core_dev->device, 256 * PPC4XX_NUM_PD,
-				  dev->shadow_sa_pool, dev->shadow_sa_pool_pa);
+		dma_free_coherent(dev->core_dev->device,
+			sizeof(union shadow_sa_buf) * PPC4XX_NUM_PD,
+			dev->shadow_sa_pool, dev->shadow_sa_pool_pa);
 
 	if (dev->shadow_sr_pool)
 		dma_free_coherent(dev->core_dev->device,
@@ -277,11 +276,9 @@ static u32 crypto4xx_get_pd_from_pdr_nolock(struct crypto4xx_device *dev)
 
 static u32 crypto4xx_put_pd_to_pdr(struct crypto4xx_device *dev, u32 idx)
 {
-	struct pd_uinfo *pd_uinfo;
+	struct pd_uinfo *pd_uinfo = &dev->pdr_uinfo[idx];
 	unsigned long flags;
 
-	pd_uinfo = (struct pd_uinfo *)(dev->pdr_uinfo +
-				       sizeof(struct pd_uinfo) * idx);
 	spin_lock_irqsave(&dev->core_dev->lock, flags);
 	if (dev->pdr_tail != PPC4XX_LAST_PD)
 		dev->pdr_tail++;
@@ -298,7 +295,7 @@ static struct ce_pd *crypto4xx_get_pdp(struct crypto4xx_device *dev,
 {
 	*pd_dma = dev->pdr_pa + sizeof(struct ce_pd) * idx;
 
-	return dev->pdr + sizeof(struct ce_pd) * idx;
+	return &dev->pdr[idx];
 }
 
 /**
@@ -376,7 +373,7 @@ static inline struct ce_gd *crypto4xx_get_gdp(struct crypto4xx_device *dev,
 {
 	*gd_dma = dev->gdr_pa + sizeof(struct ce_gd) * idx;
 
-	return (struct ce_gd *) (dev->gdr + sizeof(struct ce_gd) * idx);
+	return &dev->gdr[idx];
 }
 
 /**
@@ -387,7 +384,6 @@ static inline struct ce_gd *crypto4xx_get_gdp(struct crypto4xx_device *dev,
 static u32 crypto4xx_build_sdr(struct crypto4xx_device *dev)
 {
 	int i;
-	struct ce_sd *sd_array;
 
 	/* alloc memory for scatter descriptor ring */
 	dev->sdr = dma_alloc_coherent(dev->core_dev->device,
@@ -407,10 +403,8 @@ static u32 crypto4xx_build_sdr(struct crypto4xx_device *dev)
 		return -ENOMEM;
 	}
 
-	sd_array = dev->sdr;
-
 	for (i = 0; i < PPC4XX_NUM_SD; i++) {
-		sd_array[i].ptr = dev->scatter_buffer_pa +
+		dev->sdr[i].ptr = dev->scatter_buffer_pa +
 				  PPC4XX_SD_BUFFER_SIZE * i;
 	}
 
@@ -480,7 +474,7 @@ static inline struct ce_sd *crypto4xx_get_sdp(struct crypto4xx_device *dev,
 {
 	*sd_dma = dev->sdr_pa + sizeof(struct ce_sd) * idx;
 
-	return  (struct ce_sd *)(dev->sdr + sizeof(struct ce_sd) * idx);
+	return &dev->sdr[idx];
 }
 
 static void crypto4xx_copy_pkt_to_dst(struct crypto4xx_device *dev,
@@ -529,11 +523,10 @@ static u32 crypto4xx_copy_digest_to_dst(struct pd_uinfo *pd_uinfo,
 					struct crypto4xx_ctx *ctx)
 {
 	struct dynamic_sa_ctl *sa = (struct dynamic_sa_ctl *) ctx->sa_in;
-	struct sa_state_record *state_record =
-				(struct sa_state_record *) pd_uinfo->sr_va;
 
 	if (sa->sa_command_0.bf.hash_alg == SA_HASH_ALG_SHA1) {
-		memcpy((void *) pd_uinfo->dest_va, state_record->save_digest,
+		memcpy((void *) pd_uinfo->dest_va,
+		       pd_uinfo->sr_va->save_digest,
 		       SA_HASH_ALG_SHA1_DIGEST_SIZE);
 	}
 
@@ -607,11 +600,9 @@ static u32 crypto4xx_ahash_done(struct crypto4xx_device *dev,
 
 static u32 crypto4xx_pd_done(struct crypto4xx_device *dev, u32 idx)
 {
-	struct ce_pd *pd;
-	struct pd_uinfo *pd_uinfo;
+	struct ce_pd *pd = &dev->pdr[idx];
+	struct pd_uinfo *pd_uinfo = &dev->pdr_uinfo[idx];
 
-	pd =  dev->pdr + sizeof(struct ce_pd)*idx;
-	pd_uinfo = dev->pdr_uinfo + sizeof(struct pd_uinfo)*idx;
 	if (crypto_tfm_alg_type(pd_uinfo->async_req->tfm) ==
 			CRYPTO_ALG_TYPE_ABLKCIPHER)
 		return crypto4xx_ablkcipher_done(dev, pd_uinfo, pd);
@@ -712,7 +703,6 @@ u32 crypto4xx_build_pd(struct crypto_async_request *req,
 	unsigned long flags;
 	struct pd_uinfo *pd_uinfo = NULL;
 	unsigned int nbytes = datalen, idx;
-	unsigned int ivlen = 0;
 	u32 gd_idx = 0;
 
 	/* figure how many gd is needed */
@@ -771,17 +761,15 @@ u32 crypto4xx_build_pd(struct crypto_async_request *req,
 	}
 	spin_unlock_irqrestore(&dev->core_dev->lock, flags);
 
-	pd_uinfo = (struct pd_uinfo *)(dev->pdr_uinfo +
-				       sizeof(struct pd_uinfo) * pd_entry);
+	pd_uinfo = &dev->pdr_uinfo[pd_entry];
 	pd = crypto4xx_get_pdp(dev, &pd_dma, pd_entry);
 	pd_uinfo->async_req = req;
 	pd_uinfo->num_gd = num_gd;
 	pd_uinfo->num_sd = num_sd;
 
 	if (iv_len || ctx->is_hash) {
-		ivlen = iv_len;
 		pd->sa = pd_uinfo->sa_pa;
-		sa = (struct dynamic_sa_ctl *) pd_uinfo->sa_va;
+		sa = pd_uinfo->sa_va;
 		if (ctx->direction == DIR_INBOUND)
 			memcpy(sa, ctx->sa_in, ctx->sa_len * 4);
 		else
@@ -791,14 +779,15 @@ u32 crypto4xx_build_pd(struct crypto_async_request *req,
 			&pd_uinfo->sr_pa, 4);
 
 		if (iv_len)
-			crypto4xx_memcpy_le(pd_uinfo->sr_va, iv, iv_len);
+			crypto4xx_memcpy_le(pd_uinfo->sr_va->save_iv,
+					    iv, iv_len);
 	} else {
 		if (ctx->direction == DIR_INBOUND) {
 			pd->sa = ctx->sa_in_dma_addr;
-			sa = (struct dynamic_sa_ctl *) ctx->sa_in;
+			sa = ctx->sa_in;
 		} else {
 			pd->sa = ctx->sa_out_dma_addr;
-			sa = (struct dynamic_sa_ctl *) ctx->sa_out;
+			sa = ctx->sa_out;
 		}
 	}
 	pd->sa_len = ctx->sa_len;
@@ -1006,9 +995,8 @@ static void crypto4xx_bh_tasklet_cb(unsigned long data)
 
 	while (core_dev->dev->pdr_head != core_dev->dev->pdr_tail) {
 		tail = core_dev->dev->pdr_tail;
-		pd_uinfo = core_dev->dev->pdr_uinfo +
-			sizeof(struct pd_uinfo)*tail;
-		pd =  core_dev->dev->pdr + sizeof(struct ce_pd) * tail;
+		pd_uinfo = &core_dev->dev->pdr_uinfo[tail];
+		pd = &core_dev->dev->pdr[tail];
 		if ((pd_uinfo->state == PD_ENTRY_INUSE) &&
 				   pd->pd_ctl.bf.pe_done &&
 				   !pd->pd_ctl.bf.host_ready) {
diff --git a/drivers/crypto/amcc/crypto4xx_core.h b/drivers/crypto/amcc/crypto4xx_core.h
index dc8452be1003..97fb8288ab30 100644
--- a/drivers/crypto/amcc/crypto4xx_core.h
+++ b/drivers/crypto/amcc/crypto4xx_core.h
@@ -23,6 +23,8 @@
 #define __CRYPTO4XX_CORE_H__
 
 #include <crypto/internal/hash.h>
+#include "crypto4xx_reg_def.h"
+#include "crypto4xx_sa.h"
 
 #define MODULE_NAME "crypto4xx"
 
@@ -48,6 +50,13 @@
 
 struct crypto4xx_device;
 
+union shadow_sa_buf {
+	struct dynamic_sa_ctl sa;
+
+	/* alloc 256 bytes which is enough for any kind of dynamic sa */
+	u8 buf[256];
+} __packed;
+
 struct pd_uinfo {
 	struct crypto4xx_device *dev;
 	u32   state;
@@ -60,9 +69,9 @@ struct pd_uinfo {
 				used by this packet */
 	u32 num_sd;		/* number of scatter discriptors
 				used by this packet */
-	void *sa_va;		/* shadow sa, when using cp from ctx->sa */
+	struct dynamic_sa_ctl *sa_va;	/* shadow sa */
 	u32 sa_pa;
-	void *sr_va;		/* state record for shadow sa */
+	struct sa_state_record *sr_va;	/* state record for shadow sa */
 	u32 sr_pa;
 	struct scatterlist *dest_va;
 	struct crypto_async_request *async_req; 	/* base crypto request
@@ -75,22 +84,18 @@ struct crypto4xx_device {
 	void __iomem *ce_base;
 	void __iomem *trng_base;
 
-	void *pdr;			/* base address of packet
-					descriptor ring */
-	dma_addr_t pdr_pa;		/* physical address used to
-					program ce pdr_base_register */
-	void *gdr;                      /* gather descriptor ring */
-	dma_addr_t gdr_pa;		/* physical address used to
-					program ce gdr_base_register */
-	void *sdr;			/* scatter descriptor ring */
-	dma_addr_t sdr_pa;		/* physical address used to
-					program ce sdr_base_register */
+	struct ce_pd *pdr;	/* base address of packet descriptor ring */
+	dma_addr_t pdr_pa;	/* physical address of pdr_base_register */
+	struct ce_gd *gdr;	/* gather descriptor ring */
+	dma_addr_t gdr_pa;	/* physical address of gdr_base_register */
+	struct ce_sd *sdr;	/* scatter descriptor ring */
+	dma_addr_t sdr_pa;	/* physical address of sdr_base_register */
 	void *scatter_buffer_va;
 	dma_addr_t scatter_buffer_pa;
 
-	void *shadow_sa_pool;		/* pool of memory for sa in pd_uinfo */
+	union shadow_sa_buf *shadow_sa_pool;
 	dma_addr_t shadow_sa_pool_pa;
-	void *shadow_sr_pool;		/* pool of memory for sr in pd_uinfo */
+	struct sa_state_record *shadow_sr_pool;
 	dma_addr_t shadow_sr_pool_pa;
 	u32 pdr_tail;
 	u32 pdr_head;
@@ -98,7 +103,7 @@ struct crypto4xx_device {
 	u32 gdr_head;
 	u32 sdr_tail;
 	u32 sdr_head;
-	void *pdr_uinfo;
+	struct pd_uinfo *pdr_uinfo;
 	struct list_head alg_list;	/* List of algorithm supported
 					by this device */
 };
@@ -116,11 +121,11 @@ struct crypto4xx_core_device {
 
 struct crypto4xx_ctx {
 	struct crypto4xx_device *dev;
-	void *sa_in;
+	struct dynamic_sa_ctl *sa_in;
 	dma_addr_t sa_in_dma_addr;
-	void *sa_out;
+	struct dynamic_sa_ctl *sa_out;
 	dma_addr_t sa_out_dma_addr;
-	void *state_record;
+	struct sa_state_record *state_record;
 	dma_addr_t state_record_dma_addr;
 	u32 sa_len;
 	u32 offset_to_sr_ptr;           /* offset to state ptr, in dynamic sa */
-- 
2.14.1
