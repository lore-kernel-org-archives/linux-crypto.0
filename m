From: "Shasi Pulijala" <spulijala@amcc.com>
Subject: [PATCH 1/3] AMCC Crypto4xx Device Driver v7
Date: Mon, 15 Jun 2009 10:25:53 -0700
Message-ID: <DB599F406D04E34389140B7D99C71B1B07D83E96@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Cc: <kim.phillips@freescale.com>, <jwboyer@linux.vnet.ibm.com>,
	<linux-crypto@vger.kernel.org>, <linuxppc-dev@ozlabs.org>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sdcmail02.amcc.com ([198.137.200.90]:9821 "EHLO
	sdcmail02.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbZFORdd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2009 13:33:33 -0400
Content-class: urn:content-classes:message
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,
	I am re-sending this patch as a patch series of 3, I am assuming the earlier one did not go through the mailing lists
because it was over the size limit.

-Shasi

From: Shasi Pulijala <spulijala@amcc.com>

This is second release version for the PPC4XX Security driver that
adds aead type support and other algs to the security driver.

Signed-off-by: Shasi Pulijala <spulijala@amcc.com>
Acked-by: Loc Ho <lho@amcc.com>
---
 drivers/crypto/amcc/crypto4xx_core.c |  816 ++++++++++++++++++++++++++++++++--
 drivers/crypto/amcc/crypto4xx_core.h |   92 ++++
 drivers/crypto/amcc/crypto4xx_sa.c   |  114 +++++
 drivers/crypto/amcc/crypto4xx_sa.h   |  337 ++++++++++++++-
 4 files changed, 1323 insertions(+), 36 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 4c0dfb2..0fef1f2 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -28,13 +28,18 @@
 #include <linux/platform_device.h>
 #include <linux/init.h>
 #include <linux/of_platform.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/highmem.h>
 #include <asm/dcr.h>
 #include <asm/dcr-regs.h>
 #include <asm/cacheflush.h>
 #include <crypto/internal/hash.h>
 #include <crypto/algapi.h>
 #include <crypto/aes.h>
+#include <crypto/des.h>
 #include <crypto/sha.h>
+#include <crypto/ctr.h>
 #include "crypto4xx_reg_def.h"
 #include "crypto4xx_core.h"
 #include "crypto4xx_sa.h"
@@ -153,6 +158,8 @@ void crypto4xx_free_sa(struct crypto4xx_ctx *ctx)
 
 	ctx->sa_in_dma_addr = 0;
 	ctx->sa_out_dma_addr = 0;
+	ctx->sa_in = NULL;
+	ctx->sa_out = NULL;
 	ctx->sa_len = 0;
 }
 
@@ -178,6 +185,31 @@ void crypto4xx_free_state_record(struct crypto4xx_ctx *ctx)
 	ctx->state_record_dma_addr = 0;
 }
 
+u32 crypto4xx_alloc_arc4_state_record(struct crypto4xx_ctx *ctx)
+{
+	ctx->arc4_state_record = dma_alloc_coherent(ctx->dev->core_dev->device,
+			sizeof(struct arc4_sr),
+			&ctx->arc4_state_record_dma_addr,
+			GFP_ATOMIC);
+	if (!ctx->arc4_state_record_dma_addr)
+		return -ENOMEM;
+
+	memset(ctx->arc4_state_record, 0, sizeof(struct arc4_sr));
+
+	return 0;
+}
+
+void crypto4xx_free_arc4_state_record(struct crypto4xx_ctx *ctx)
+{
+	if (ctx->arc4_state_record != NULL) {
+		dma_free_coherent(ctx->dev->core_dev->device,
+				  sizeof(struct arc4_sr),
+				  ctx->arc4_state_record,
+				  ctx->arc4_state_record_dma_addr);
+	}
+	ctx->arc4_state_record_dma_addr = 0;
+}
+
 /**
  * alloc memory for the gather ring
  * no need to alloc buf for the ring
@@ -528,7 +560,7 @@ static u32 crypto4xx_fill_one_page(struct crypto4xx_device *dev,
 			(*idx)++;
 
 		return 0;
-    }
+	}
 }
 
 static void crypto4xx_copy_pkt_to_dst(struct crypto4xx_device *dev,
@@ -591,9 +623,25 @@ static u32 crypto4xx_copy_digest_to_dst(struct pd_uinfo *pd_uinfo,
 	struct sa_state_record *state_record =
 				(struct sa_state_record *) pd_uinfo->sr_va;
 
-	if (sa->sa_command_0.bf.hash_alg == SA_HASH_ALG_SHA1) {
-		memcpy((void *) pd_uinfo->dest_va, state_record->save_digest,
-		       SA_HASH_ALG_SHA1_DIGEST_SIZE);
+	switch (sa->sa_command_0.bf.hash_alg) {
+	case SA_HASH_ALG_KASUMI_f9:
+		crypto4xx_memcpy_le((void *)pd_uinfo->dest_va,
+				     (u8 *)state_record->save_digest, 8);
+		break;
+	case SA_HASH_ALG_AES_XCBC_MAC_128:
+		crypto4xx_memcpy_le((void *)pd_uinfo->dest_va,
+				     (u8 *) state_record->save_digest, 16);
+		break;
+	case SA_HASH_ALG_MD5:
+		crypto4xx_memcpy_le((void *)pd_uinfo->dest_va,
+				     (u8 *) state_record->save_digest,
+				     SA_HASH_ALG_MD5_DIGEST_SIZE);
+		break;
+	default:
+		memcpy((void *)pd_uinfo->dest_va,
+			state_record->save_digest,
+			crypto4xx_sa_hash_tbl[1][sa->sa_command_0.bf.hash_alg]);
+		break;
 	}
 
 	return 0;
@@ -618,6 +666,57 @@ static void crypto4xx_ret_sg_desc(struct crypto4xx_device *dev,
 	}
 }
 
+void crypto4xx_append_icv_to_end(struct crypto4xx_device *dev,
+				 struct scatterlist *dst,
+				 struct sa_state_record *sr,
+				 u32 offset,
+				 u32 len)
+{
+	struct scatterlist *sg;
+	int i = 0;
+	u32 cp_len;
+	dma_addr_t addr;
+
+	sg = &dst[i];
+	while (len) {
+		while (sg->length < offset) {
+			offset -= sg->length;
+			i++;
+			sg = &sg[i];
+		}
+		/* at here, icv could be in this sg,
+		* or icv could be in the next sg
+		*/
+		if (sg->length > offset) {
+			/* icv should be in middle of this sg */
+			addr = dma_map_page(dev->core_dev->device, sg_page(sg),
+					    sg->offset,
+					    sg->length, DMA_TO_DEVICE);
+			cp_len = (sg->length-offset >= len) ? len :
+					sg->length-offset;
+			len -= cp_len;
+			crypto4xx_memcpy_le((u32 *)(phys_to_virt(addr)
+					+ offset),
+					(u8 *)sr->save_digest, cp_len);
+		} else {
+			/* start from begin of next sg*/
+			i++;
+			sg = &sg[i];
+			offset = 0;
+			addr = dma_map_page(dev->core_dev->device, sg_page(sg),
+					    sg->offset,
+					    sg->length, DMA_FROM_DEVICE);
+			cp_len = (sg->length >= len) ? len : sg->length;
+			len -= cp_len;
+			crypto4xx_memcpy_le((u32 *) (phys_to_virt(addr)
+					+ offset),
+					(u8 *) sr->save_digest, cp_len);
+		}
+		i++;
+		sg = &sg[i];
+	}
+}
+
 static u32 crypto4xx_ablkcipher_done(struct crypto4xx_device *dev,
 				     struct pd_uinfo *pd_uinfo,
 				     struct ce_pd *pd)
@@ -664,18 +763,67 @@ static u32 crypto4xx_ahash_done(struct crypto4xx_device *dev,
 	return 0;
 }
 
-static u32 crypto4xx_pd_done(struct crypto4xx_device *dev, u32 idx)
+static u32 crypto4xx_aead_done(struct crypto4xx_device *dev,
+			struct pd_uinfo *pd_uinfo,
+			struct ce_pd *pd)
+{
+	struct aead_request *aead_req;
+	struct crypto4xx_ctx *ctx;
+	struct scatterlist *dst;
+	dma_addr_t addr;
+	struct crypto_aead *aead;
+
+	aead_req = container_of(pd_uinfo->async_req,
+				struct aead_request, base);
+	aead = crypto_aead_reqtfm(aead_req);
+	ctx  = crypto_tfm_ctx(aead_req->base.tfm);
+
+	if (pd_uinfo->using_sd) {
+		crypto4xx_copy_pkt_to_dst(dev, pd, pd_uinfo,
+					  pd->pd_ctl_len.bf.pkt_len,
+					  aead_req->dst);
+	} else {
+		dst = pd_uinfo->dest_va;
+		addr = dma_map_page(dev->core_dev->device, sg_page(dst),
+				    dst->offset,
+				    dst->length, DMA_FROM_DEVICE);
+	}
+
+	if (ctx->append_icv != 0) {
+		dst = pd_uinfo->dest_va;
+		crypto4xx_append_icv_to_end(dev, dst,
+					    (struct sa_state_record *)
+					    pd_uinfo->sr_va,
+					    aead_req->cryptlen,
+					    crypto_aead_authsize(aead));
+	}
+	crypto4xx_ret_sg_desc(dev, pd_uinfo);
+	/* call user provided callback function x */
+	if (aead_req->base.complete != NULL)
+		aead_req->base.complete(&aead_req->base, 0);
+
+	return 0;
+}
+
+u32 crypto4xx_pd_done(struct crypto4xx_device *dev, u32 idx)
 {
 	struct ce_pd *pd;
 	struct pd_uinfo *pd_uinfo;
 
 	pd =  dev->pdr + sizeof(struct ce_pd)*idx;
 	pd_uinfo = dev->pdr_uinfo + sizeof(struct pd_uinfo)*idx;
+
 	if (crypto_tfm_alg_type(pd_uinfo->async_req->tfm) ==
+			CRYPTO_ALG_TYPE_AEAD)
+		return crypto4xx_aead_done(dev, pd_uinfo, pd);
+	else if (crypto_tfm_alg_type(pd_uinfo->async_req->tfm) ==
 			CRYPTO_ALG_TYPE_ABLKCIPHER)
 		return crypto4xx_ablkcipher_done(dev, pd_uinfo, pd);
-	else
+	else if (crypto_tfm_alg_type(pd_uinfo->async_req->tfm) ==
+			CRYPTO_ALG_TYPE_AHASH)
 		return crypto4xx_ahash_done(dev, pd_uinfo);
+
+	return 0;
 }
 
 /**
@@ -777,12 +925,15 @@ u32 crypto4xx_build_pd(struct crypto_async_request *req,
 		       struct scatterlist *src,
 		       struct scatterlist *dst,
 		       unsigned int datalen,
+		       struct scatterlist *assoc,
+		       u32 aad_len,
 		       void *iv, u32 iv_len)
 {
 	struct crypto4xx_device *dev = ctx->dev;
 	dma_addr_t addr, pd_dma, sd_dma, gd_dma;
 	struct dynamic_sa_ctl *sa;
 	struct scatterlist *sg;
+	struct scatterlist *aad;
 	struct ce_gd *gd;
 	struct ce_pd *pd;
 	u32 num_gd, num_sd;
@@ -792,13 +943,18 @@ u32 crypto4xx_build_pd(struct crypto_async_request *req,
 	unsigned long flags;
 	struct pd_uinfo *pd_uinfo = NULL;
 	unsigned int nbytes = datalen, idx;
-	unsigned int ivlen = 0;
 	u32 gd_idx = 0;
+	unsigned int aadlen = 0;
 
 	/* figure how many gd is needed */
-	num_gd = get_sg_count(src, datalen);
-	if (num_gd == 1)
-		num_gd = 0;
+	if (aad_len) {
+		num_gd = get_sg_count(assoc, aad_len) +
+				get_sg_count(src, datalen);
+	} else {
+		num_gd = get_sg_count(src, datalen);
+		if (num_gd == 1)
+			num_gd = 0;
+	}
 
 	/* figure how many sd is needed */
 	if (sg_is_last(dst) || ctx->is_hash) {
@@ -855,7 +1011,6 @@ u32 crypto4xx_build_pd(struct crypto_async_request *req,
 	pd_uinfo->num_sd = num_sd;
 
 	if (iv_len || ctx->is_hash) {
-		ivlen = iv_len;
 		pd->sa = pd_uinfo->sa_pa;
 		sa = (struct dynamic_sa_ctl *) pd_uinfo->sa_va;
 		if (ctx->direction == DIR_INBOUND)
@@ -866,8 +1021,26 @@ u32 crypto4xx_build_pd(struct crypto_async_request *req,
 		memcpy((void *) sa + ctx->offset_to_sr_ptr,
 			&pd_uinfo->sr_pa, 4);
 
-		if (iv_len)
-			crypto4xx_memcpy_le(pd_uinfo->sr_va, iv, iv_len);
+		if (iv_len) {
+			if (ctx->ctr_aes) {
+				/* First the nonce */
+				memcpy(pd_uinfo->sr_va, ctx->state_record,
+				       CTR_RFC3686_NONCE_SIZE);
+				/* Copy the IV that is passed through
+				 * each operation
+				 */
+				crypto4xx_memcpy_le(pd_uinfo->sr_va +
+					CTR_RFC3686_NONCE_SIZE, iv, iv_len);
+			} else
+				crypto4xx_memcpy_le(pd_uinfo->sr_va,
+						iv, iv_len);
+		}
+		if (ctx->is_gcm || ctx->ctr_aes) {
+			u32 seq = 1;
+			/*For GCM and CTR(AES) algs adding the counter value*/
+			crypto4xx_memcpy_le(pd_uinfo->sr_va + 12,
+					    (void *)&seq,  4);
+		}
 	} else {
 		if (ctx->direction == DIR_INBOUND) {
 			pd->sa = ctx->sa_in_dma_addr;
@@ -888,6 +1061,35 @@ u32 crypto4xx_build_pd(struct crypto_async_request *req,
 		/* enable gather */
 		sa->sa_command_0.bf.gather = 1;
 		idx = 0;
+		if (aad_len) {
+			aadlen = aad_len;
+			aad = assoc;
+			/* walk the sg, and setup gather array for aad*/
+			while (aadlen) {
+				sg = &aad[idx];
+				addr = dma_map_page(dev->core_dev->device,
+						sg_page(sg), sg->offset,
+						sg->length, DMA_TO_DEVICE);
+
+				gd->ptr = addr;
+				gd->ctl_len.len = sg->length;
+				gd->ctl_len.done = 0;
+				gd->ctl_len.ready = 1;
+
+				if (sg->length >= aadlen)
+					break;
+
+				aadlen -= sg->length;
+
+				gd_idx = get_next_gd(gd_idx);
+				gd = crypto4xx_get_gdp(dev, &gd_dma, gd_idx);
+				idx++;
+			}
+			/* prepare gd for src */
+			gd_idx = get_next_gd(gd_idx);
+			gd = crypto4xx_get_gdp(dev, &gd_dma, gd_idx);
+		}
+		idx = 0;
 		src = &src[0];
 		/* walk the sg, and setup gather array */
 		while (nbytes) {
@@ -972,9 +1174,10 @@ u32 crypto4xx_build_pd(struct crypto_async_request *req,
 		}
 	}
 
-	sa->sa_command_1.bf.hash_crypto_offset = 0;
+	sa->sa_command_1.bf.hash_crypto_offset = (aad_len >> 2);
 	pd->pd_ctl.w = ctx->pd_ctl;
-	pd->pd_ctl_len.w = 0x00400000 | (ctx->bypass << 24) | datalen;
+	pd->pd_ctl_len.w = 0x00400000 | (ctx->bypass << 24) |
+			(datalen + aad_len);
 	pd_uinfo->state = PD_ENTRY_INUSE;
 	wmb();
 	/* write any value to push engine to read a pd */
@@ -997,11 +1200,15 @@ static int crypto4xx_alg_init(struct crypto_tfm *tfm)
 	ctx->sa_in_dma_addr = 0;
 	ctx->sa_out_dma_addr = 0;
 	ctx->sa_len = 0;
+	ctx->is_gcm = 0;
+	ctx->append_icv = 0;
 
 	if (alg->cra_type == &crypto_ablkcipher_type)
 		tfm->crt_ablkcipher.reqsize = sizeof(struct crypto4xx_ctx);
 	else if (alg->cra_type == &crypto_ahash_type)
 		tfm->crt_ahash.reqsize = sizeof(struct crypto4xx_ctx);
+	else if (alg->cra_type == &crypto_aead_type)
+		tfm->crt_aead.reqsize = sizeof(struct crypto4xx_ctx);
 
 	return 0;
 }
@@ -1105,6 +1312,88 @@ static irqreturn_t crypto4xx_ce_interrupt_handler(int irq, void *data)
  * Supported Crypto Algorithms
  */
 struct crypto_alg crypto4xx_alg[] = {
+		/* Crypto DES ECB, CBC,  modes */
+
+	{.cra_name 		= "cbc(des)",
+	 .cra_driver_name 	= "ppc4xx-cbc-des",
+	 .cra_priority 		= CRYPTO4XX_CRYPTO_PRIORITY,
+	 .cra_flags 		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	 .cra_blocksize 	= DES_BLOCK_SIZE,
+	 .cra_ctxsize 		= sizeof(struct crypto4xx_ctx),
+	 .cra_alignmask 	= 0,
+	 .cra_type 		= &crypto_ablkcipher_type,
+	 .cra_module 		= THIS_MODULE,
+	 .cra_u 		= {
+		.ablkcipher = {
+				.min_keysize 	= DES_KEY_SIZE,
+				.max_keysize 	= DES_KEY_SIZE,
+				.ivsize 	= DES_BLOCK_SIZE,
+				.setkey 	= crypto4xx_setkey_3des_cbc,
+				.encrypt 	= crypto4xx_encrypt,
+				.decrypt 	= crypto4xx_decrypt,
+			}
+		}
+	},
+	{.cra_name 		= "ecb(des)",
+	 .cra_driver_name 	= "ppc4xx-ecb-des",
+	 .cra_priority 		= CRYPTO4XX_CRYPTO_PRIORITY,
+	 .cra_flags 		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	 .cra_blocksize 	= DES_BLOCK_SIZE,
+	 .cra_ctxsize 		= sizeof(struct crypto4xx_ctx),
+	 .cra_alignmask 	= 0,
+	 .cra_type 		= &crypto_ablkcipher_type,
+	 .cra_module 		= THIS_MODULE,
+	 .cra_u 		= {
+			.ablkcipher = {
+				.min_keysize 	= DES_KEY_SIZE,
+				.max_keysize 	= DES_KEY_SIZE,
+				.setkey 	= crypto4xx_setkey_3des_ecb,
+				.encrypt 	= crypto4xx_encrypt,
+				.decrypt 	= crypto4xx_decrypt,
+			}
+		}
+	},
+
+	/* Crypto 3DES ECB, CBC, CFB, and OFB modes */
+	{.cra_name 		= "cbc(des3_ede)",
+	 .cra_driver_name 	= "ppc4xx-cbc-3des",
+	 .cra_priority 		= CRYPTO4XX_CRYPTO_PRIORITY,
+	 .cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	 .cra_blocksize 	= DES3_EDE_BLOCK_SIZE,
+	 .cra_ctxsize 		= sizeof(struct crypto4xx_ctx),
+	 .cra_alignmask 	= 0,
+	 .cra_type 		= &crypto_ablkcipher_type,
+	 .cra_module 		= THIS_MODULE,
+	 .cra_u 		= {
+			.ablkcipher = {
+				.min_keysize 	= DES3_EDE_KEY_SIZE,
+				.max_keysize 	= DES3_EDE_KEY_SIZE,
+				.ivsize 	= DES3_EDE_BLOCK_SIZE,
+				.setkey 	= crypto4xx_setkey_3des_cbc,
+				.encrypt 	= crypto4xx_encrypt,
+				.decrypt 	= crypto4xx_decrypt,
+			}
+		}
+	},
+	{.cra_name 		= "ecb(des3_ede)",
+	 .cra_driver_name 	= "ppc4xx-ecb-3des",
+	 .cra_priority 		= CRYPTO4XX_CRYPTO_PRIORITY,
+	 .cra_flags 		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	 .cra_blocksize 	= DES3_EDE_BLOCK_SIZE,
+	 .cra_ctxsize 		= sizeof(struct crypto4xx_ctx),
+	 .cra_alignmask 	= 0,
+	 .cra_type 		= &crypto_ablkcipher_type,
+	 .cra_module 		= THIS_MODULE,
+	 .cra_u 		= {
+			.ablkcipher = {
+				.min_keysize 	= DES3_EDE_KEY_SIZE,
+				.max_keysize 	= DES3_EDE_KEY_SIZE,
+				.setkey 	= crypto4xx_setkey_3des_ecb,
+				.encrypt 	= crypto4xx_encrypt,
+				.decrypt 	= crypto4xx_decrypt,
+			}
+		}
+	},
 	/* Crypto AES modes */
 	{
 		.cra_name 	= "cbc(aes)",
@@ -1127,25 +1416,495 @@ struct crypto_alg crypto4xx_alg[] = {
 			}
 		}
 	},
-	/* Hash SHA1 */
-	{
-		.cra_name	= "sha1",
-		.cra_driver_name = "sha1-ppc4xx",
-		.cra_priority	= CRYPTO4XX_CRYPTO_PRIORITY,
-		.cra_flags	= CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
-		.cra_blocksize	= SHA1_BLOCK_SIZE,
-		.cra_ctxsize	= sizeof(struct crypto4xx_ctx),
-		.cra_alignmask	= 0,
-		.cra_type	= &crypto_ahash_type,
-		.cra_init	= crypto4xx_sha1_alg_init,
-		.cra_module	= THIS_MODULE,
-		.cra_u		= {
+	{.cra_name 		= "ofb(aes)",
+	 .cra_driver_name 	= "ppc4xx-ofb-aes",
+	 .cra_priority 		= CRYPTO4XX_CRYPTO_PRIORITY,
+	 .cra_flags 		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	 .cra_blocksize		= AES_BLOCK_SIZE,
+	 .cra_ctxsize 		= sizeof(struct crypto4xx_ctx),
+	 .cra_alignmask 	= 0,
+	 .cra_type 		= &crypto_ablkcipher_type,
+	 .cra_module 		= THIS_MODULE,
+	 .cra_u 		= {
+			.ablkcipher = {
+				.min_keysize 	= AES_MIN_KEY_SIZE,
+				.max_keysize 	= AES_MAX_KEY_SIZE,
+				.ivsize 	= AES_BLOCK_SIZE,
+				.setkey 	= crypto4xx_setkey_aes_ofb,
+				.encrypt 	= crypto4xx_encrypt,
+				.decrypt 	= crypto4xx_decrypt,
+			}
+		}
+	},
+	{.cra_name 		= "cfb(aes)",
+	 .cra_driver_name 	= "ppc4xx-cfb-aes",
+	 .cra_priority 		= CRYPTO4XX_CRYPTO_PRIORITY,
+	 .cra_flags 		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	 .cra_blocksize		= AES_BLOCK_SIZE,
+	 .cra_ctxsize 		= sizeof(struct crypto4xx_ctx),
+	 .cra_alignmask 	= 0,
+	 .cra_type 		= &crypto_ablkcipher_type,
+	 .cra_module 		= THIS_MODULE,
+	 .cra_u 		= {
+			.ablkcipher = {
+				.min_keysize 	= AES_MIN_KEY_SIZE,
+				.max_keysize 	= AES_MAX_KEY_SIZE,
+				.ivsize 	= AES_BLOCK_SIZE,
+				.setkey 	= crypto4xx_setkey_aes_cfb,
+				.encrypt 	= crypto4xx_encrypt,
+				.decrypt 	= crypto4xx_decrypt,
+			}
+		}
+	},
+	/* Crypto AES ECB, CBC, CTR, GCM, CCM, and GMAC modes */
+	{.cra_name 		= "ecb(aes)",
+	 .cra_driver_name 	= "ppc4xx-ecb-aes",
+	 .cra_priority 		= CRYPTO4XX_CRYPTO_PRIORITY,
+	 .cra_flags 		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	 .cra_blocksize 	= AES_BLOCK_SIZE,
+	 .cra_ctxsize 		= sizeof(struct crypto4xx_ctx),
+	 .cra_alignmask 	= 0,
+	 .cra_type 		= &crypto_ablkcipher_type,
+	 .cra_module 		= THIS_MODULE,
+	 .cra_u 		= {
+			.ablkcipher = {
+				.min_keysize 	= AES_MIN_KEY_SIZE,
+				.max_keysize 	= AES_MAX_KEY_SIZE,
+				.setkey 	= crypto4xx_setkey_aes_ecb,
+				.encrypt 	= crypto4xx_encrypt,
+				.decrypt 	= crypto4xx_decrypt,
+			}
+		}
+	},
+	{.cra_name 		= "rfc3686(ctr(aes))",
+	 .cra_driver_name 	= "ppc4xx-ctr-aes",
+	 .cra_priority 		= CRYPTO4XX_CRYPTO_PRIORITY,
+	 .cra_flags 		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	 .cra_blocksize 	= CTR_RFC3686_BLOCK_SIZE,
+	 .cra_ctxsize 		= sizeof(struct crypto4xx_ctx),
+	 .cra_alignmask 	= 0,
+	 .cra_type		= &crypto_ablkcipher_type,
+	 .cra_module 		= THIS_MODULE,
+	 .cra_u 		= {
+			.ablkcipher = {
+				.min_keysize 	= AES_MIN_KEY_SIZE,
+				.max_keysize 	= AES_MAX_KEY_SIZE,
+				.ivsize 	= CTR_RFC3686_BLOCK_SIZE,
+				.setkey 	= crypto4xx_setkey_aes_ctr,
+				.encrypt 	= crypto4xx_encrypt_ctr,
+				.decrypt 	= crypto4xx_decrypt_ctr,
+			}
+		}
+	},
+	/* AEAD Algorithms */
+	{.cra_name 		= "gcm(aes)",
+	 .cra_driver_name 	= "ppc4xx-gcm-aes",
+	 .cra_priority 		= CRYPTO4XX_CRYPTO_PRIORITY,
+	 .cra_flags 		= CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
+	 .cra_blocksize 	= AES_BLOCK_SIZE,
+	 .cra_ctxsize 		= sizeof(struct crypto4xx_ctx),
+	 .cra_alignmask 	= 0,
+	 .cra_type 		= &crypto_aead_type,
+	 .cra_module 		= THIS_MODULE,
+	 .cra_u 		= {
+			.aead = {
+				.maxauthsize	= 16,
+				.ivsize 	= 12,
+				.setkey 	= crypto4xx_setkey_aes_gcm,
+				.setauthsize	= crypto4xx_setauthsize_aes,
+				.encrypt 	= crypto4xx_encrypt_aes_gcm,
+				.decrypt 	= crypto4xx_decrypt_aes_gcm,
+				.givencrypt	= crypto4xx_givencrypt_aes_gcm,
+				.givdecrypt	= crypto4xx_givdecrypt_aes_gcm,
+			}
+		}
+	},
+	{.cra_name 		= "ccm(aes)",
+	 .cra_driver_name 	= "ppc4xx-ccm-aes",
+	 .cra_priority 		= CRYPTO4XX_CRYPTO_PRIORITY,
+	 .cra_flags 		= CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
+	 .cra_blocksize 	= AES_BLOCK_SIZE,
+	 .cra_ctxsize 		= sizeof(struct crypto4xx_ctx),
+	 .cra_alignmask 	= 0,
+	 .cra_type 		= &crypto_aead_type,
+	 .cra_module 		= THIS_MODULE,
+	 .cra_u 		= {
+			.aead = {
+				.ivsize 	= AES_BLOCK_SIZE,
+				.maxauthsize	= 16,
+				.setkey		= crypto4xx_setkey_aes_ccm,
+				.setauthsize	= crypto4xx_setauthsize_aes,
+				.encrypt	= crypto4xx_encrypt_aes_ccm,
+				.decrypt	= crypto4xx_decrypt_aes_ccm,
+				.givencrypt	= crypto4xx_givencrypt_aes_ccm,
+				.givdecrypt	= crypto4xx_givdecrypt_aes_ccm,
+			}
+		}
+	},
+	/* Hash MD5 */
+	{.cra_name 		= "md5",
+	 .cra_driver_name 	= "ppc4xx-md5",
+	 .cra_priority 		= CRYPTO4XX_CRYPTO_PRIORITY,
+	 .cra_flags 		= CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
+	 .cra_blocksize 	= 64,
+	 .cra_ctxsize 		= sizeof(struct crypto4xx_ctx),
+	 .cra_alignmask 	= 0,
+	 .cra_type 		= &crypto_ahash_type,
+	 .cra_init 		= crypto4xx_md5_alg_init,
+	 .cra_module 		= THIS_MODULE,
+	 .cra_u 		= {
+			.ahash = {
+				.digestsize 	= SA_HASH_ALG_MD5_DIGEST_SIZE,
+				.init		= crypto4xx_hash_init,
+				.update		= crypto4xx_hash_update,
+				.final 		= crypto4xx_hash_final,
+				.digest		= crypto4xx_hash_digest,
+			}
+		}
+	},
+	/* Hash MD5-HMAC */
+	{.cra_name 		= "hmac(md5)",
+	 .cra_driver_name 	= "ppc4xx-hmac-md5",
+	 .cra_priority 		= CRYPTO4XX_CRYPTO_PRIORITY,
+	 .cra_flags 		= CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
+	 .cra_blocksize 	= 64,
+	 .cra_ctxsize 		= sizeof(struct crypto4xx_ctx),
+	 .cra_alignmask 	= 0,
+	 .cra_type 		= &crypto_ahash_type,
+	 .cra_module 		= THIS_MODULE,
+	 .cra_u 		= {
+			.ahash = {
+				.digestsize	= SA_HASH_ALG_MD5_DIGEST_SIZE,
+				.init		= crypto4xx_hash_init,
+				.update		= crypto4xx_hash_update,
+				.final 		= crypto4xx_hash_final,
+				.digest		= crypto4xx_hash_digest,
+				.setkey		= crypto4xx_md5_hmac_setkey,
+			}
+		}
+	},
+	/* Hash SHA1, SHA2 and HMAC */
+	{.cra_name 		= "sha1",
+	 .cra_driver_name 	= "ppc4xx-sha1",
+	 .cra_priority 		= CRYPTO4XX_CRYPTO_PRIORITY,
+	 .cra_flags 		= CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
+	 .cra_blocksize 	= SHA1_BLOCK_SIZE,
+	 .cra_ctxsize 		= sizeof(struct crypto4xx_ctx),
+	 .cra_alignmask 	= 0,
+	 .cra_type   		= &crypto_ahash_type,
+	 .cra_init 		= crypto4xx_sha1_alg_init,
+	 .cra_module 		= THIS_MODULE,
+	 .cra_u  		= {
+			.ahash = {
+				.digestsize	= SHA1_DIGEST_SIZE,
+				.init   	= crypto4xx_hash_init,
+				.update 	= crypto4xx_hash_update,
+				.final  	= crypto4xx_hash_final,
+				.digest 	= crypto4xx_hash_digest,
+				}
+		}
+	},
+	{.cra_name 		= "hmac(sha1)",
+	 .cra_driver_name 	= "ppc4xx-hmac-sha1",
+	 .cra_priority 		= CRYPTO4XX_CRYPTO_PRIORITY,
+	 .cra_flags 		= CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
+	 .cra_blocksize 	= SHA1_BLOCK_SIZE,
+	 .cra_ctxsize 		= sizeof(struct crypto4xx_ctx),
+	 .cra_alignmask 	= 0,
+	 .cra_type   		= &crypto_ahash_type,
+	 .cra_module 		= THIS_MODULE,
+	 .cra_u  		= {
 			.ahash = {
 				.digestsize 	= SHA1_DIGEST_SIZE,
+				.init   	= crypto4xx_hash_init,
+				.update 	= crypto4xx_hash_update,
+				.final  	= crypto4xx_hash_final,
+				.digest 	= crypto4xx_hash_digest,
+				.setkey 	= crypto4xx_sha1_hmac_setkey,
+			}
+		}
+	},
+
+	{.cra_name 		= "sha224",
+	 .cra_driver_name 	= "ppc4xx-sha224",
+	 .cra_priority		= CRYPTO4XX_CRYPTO_PRIORITY,
+	 .cra_flags 		= CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
+	 .cra_blocksize 	= SHA224_BLOCK_SIZE,
+	 .cra_ctxsize 		= sizeof(struct crypto4xx_ctx),
+	 .cra_alignmask 	= 0,
+	 .cra_type 		= &crypto_ahash_type,
+	 .cra_init 		= crypto4xx_sha2_alg_init,
+	 .cra_module 		= THIS_MODULE,
+	 .cra_u 		= {
+			.ahash = {
+				.digestsize	= SHA224_DIGEST_SIZE,
+				.init		= crypto4xx_hash_init,
+				.update		= crypto4xx_hash_update,
+				.final 		= crypto4xx_hash_final,
+				.digest		= crypto4xx_hash_digest,
+			}
+		}
+	},
+	{.cra_name 		= "hmac(sha224)",
+	 .cra_driver_name 	= "ppc4xx-hmac-sha224",
+	 .cra_priority		= CRYPTO4XX_CRYPTO_PRIORITY,
+	 .cra_flags 		= CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
+	 .cra_blocksize 	= SHA224_BLOCK_SIZE,
+	 .cra_ctxsize 		= sizeof(struct crypto4xx_ctx),
+	 .cra_alignmask 	= 0,
+	 .cra_type 		= &crypto_ahash_type,
+	 .cra_module 		= THIS_MODULE,
+	 .cra_u 		= {
+			.ahash = {
+				.digestsize 	= SHA224_DIGEST_SIZE,
+				.init   	= crypto4xx_hash_init,
+				.update		= crypto4xx_hash_update,
+				.final 		= crypto4xx_hash_final,
+				.digest		= crypto4xx_hash_digest,
+				.setkey		= crypto4xx_sha2_hmac_setkey,
+			}
+		}
+	},
+	{.cra_name 		= "sha256",
+	 .cra_driver_name 	= "ppc4xx-sha256",
+	 .cra_priority 		= CRYPTO4XX_CRYPTO_PRIORITY,
+	 .cra_flags 		= CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
+	 .cra_blocksize 	= SHA256_BLOCK_SIZE,
+	 .cra_ctxsize 		= sizeof(struct crypto4xx_ctx),
+	 .cra_alignmask 	= 0,
+	 .cra_type 		= &crypto_ahash_type,
+	 .cra_init 		= crypto4xx_sha2_alg_init,
+	 .cra_module 		= THIS_MODULE,
+	 .cra_u 		= {
+			.ahash = {
+				.digestsize	= SHA256_DIGEST_SIZE,
+				.init		= crypto4xx_hash_init,
+				.update		= crypto4xx_hash_update,
+				.final 		= crypto4xx_hash_final,
+				.digest		= crypto4xx_hash_digest,
+			}
+		}
+	},
+	{.cra_name 		= "hmac(sha256)",
+	 .cra_driver_name 	= "ppc4xx-hmac-sha256",
+	 .cra_priority 		= CRYPTO4XX_CRYPTO_PRIORITY,
+	 .cra_flags 		= CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
+	 .cra_blocksize 	= SHA256_BLOCK_SIZE,
+	 .cra_ctxsize 		= sizeof(struct crypto4xx_ctx),
+	 .cra_alignmask 	= 0,
+	 .cra_type 		= &crypto_ahash_type,
+	 .cra_module 		= THIS_MODULE,
+	 .cra_u 		= {
+			.ahash = {
+				.digestsize	= SHA256_DIGEST_SIZE,
+				.init		= crypto4xx_hash_init,
+				.update		= crypto4xx_hash_update,
+				.final 		= crypto4xx_hash_final,
+				.digest		= crypto4xx_hash_digest,
+				.setkey		= crypto4xx_sha2_hmac_setkey,
+			}
+		}
+	},
+	{.cra_name 		= "sha384",
+	 .cra_driver_name 	= "ppc4xx-sha384",
+	 .cra_priority 		= CRYPTO4XX_CRYPTO_PRIORITY,
+	 .cra_flags 		= CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
+	 .cra_blocksize 	= SHA384_BLOCK_SIZE,
+	 .cra_ctxsize 		= sizeof(struct crypto4xx_ctx),
+	 .cra_alignmask 	= 0,
+	 .cra_type 		= &crypto_ahash_type,
+	 .cra_init 		= crypto4xx_sha2_alg_init,
+	 .cra_module 		= THIS_MODULE,
+	 .cra_u 		= {
+			.ahash = {
+				.digestsize	= SHA384_DIGEST_SIZE,
+				.init		= crypto4xx_hash_init,
+				.update		= crypto4xx_hash_update,
+				.final 		= crypto4xx_hash_final,
+				.digest		= crypto4xx_hash_digest,
+			}
+		}
+	},
+	{.cra_name 		= "hmac(sha384)",
+	 .cra_driver_name 	= "ppc4xx-hmac-sha384",
+	 .cra_priority 		= CRYPTO4XX_CRYPTO_PRIORITY,
+	 .cra_flags 		= CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
+	 .cra_blocksize 	= SHA384_BLOCK_SIZE,
+	 .cra_ctxsize 		= sizeof(struct crypto4xx_ctx),
+	 .cra_alignmask 	= 0,
+	 .cra_type 		= &crypto_ahash_type,
+	 .cra_module 		= THIS_MODULE,
+	 .cra_u 		= {
+			.ahash = {
+				.digestsize	= SHA384_DIGEST_SIZE,
+				.init		= crypto4xx_hash_init,
+				.update 	= crypto4xx_hash_update,
+				.final 		= crypto4xx_hash_final,
+				.digest		= crypto4xx_hash_digest,
+				.setkey		= crypto4xx_sha2_hmac_setkey,
+			}
+		}
+	},
+	{.cra_name 		= "sha512",
+	 .cra_driver_name 	= "ppc4xx-sha512",
+	 .cra_priority 		= CRYPTO4XX_CRYPTO_PRIORITY,
+	 .cra_flags 		= CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
+	 .cra_blocksize 	= SHA512_BLOCK_SIZE,
+	 .cra_ctxsize 		= sizeof(struct crypto4xx_ctx),
+	 .cra_alignmask 	= 0,
+	 .cra_type 		= &crypto_ahash_type,
+	 .cra_init 		= crypto4xx_sha2_alg_init,
+	 .cra_module 		= THIS_MODULE,
+	 .cra_u 		= {
+			.ahash = {
+				.digestsize 	= SHA512_DIGEST_SIZE,
+				.init		= crypto4xx_hash_init,
+				.update		= crypto4xx_hash_update,
+				.final 		= crypto4xx_hash_final,
+				.digest		= crypto4xx_hash_digest,
+			}
+		}
+	},
+	{.cra_name 		= "hmac(sha512)",
+	 .cra_driver_name 	= "ppc4xx-hmac-sha512",
+	 .cra_priority 		= CRYPTO4XX_CRYPTO_PRIORITY,
+	 .cra_flags 		= CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
+	 .cra_blocksize 	= SHA512_BLOCK_SIZE,
+	 .cra_ctxsize 		= sizeof(struct crypto4xx_ctx),
+	 .cra_alignmask 	= 0,
+	 .cra_type 		= &crypto_ahash_type,
+	 .cra_module 		= THIS_MODULE,
+	 .cra_u 		= {
+			.ahash = {
+				.digestsize 	= SHA512_DIGEST_SIZE,
 				.init		= crypto4xx_hash_init,
 				.update		= crypto4xx_hash_update,
+				.final		= crypto4xx_hash_final,
+				.digest 	= crypto4xx_hash_digest,
+				.setkey 	= crypto4xx_sha2_hmac_setkey,
+			}
+		}
+	},
+	/* Hash XCBC, GHASH, and Kasumi F9 */
+	{.cra_name 		= "xcbc(aes)",
+	.cra_driver_name	= "ppc4xx-xcbc-aes",
+	.cra_priority 		= CRYPTO4XX_CRYPTO_PRIORITY,
+	.cra_flags 		= CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
+	.cra_blocksize 	= AES_BLOCK_SIZE,
+	.cra_ctxsize 		= sizeof(struct crypto4xx_ctx),
+	.cra_alignmask 	= 0,
+	.cra_type 		= &crypto_ahash_type,
+	.cra_module 		= THIS_MODULE,
+	.cra_u 			= {
+			.ahash = {
+				.digestsize 	= 16,
+				.init   	= crypto4xx_hash_init,
+				.update 	= crypto4xx_hash_update,
 				.final  	= crypto4xx_hash_final,
 				.digest 	= crypto4xx_hash_digest,
+				.setkey 	= crypto4xx_xcbc_setkey,
+			}
+		}
+	},
+	/* Crypto Kasumi and Kasumi F8 */
+	{.cra_name 		= "kasumi",
+	.cra_driver_name 	= "ppc4xx-kasumi",
+	.cra_priority 		= CRYPTO4XX_CRYPTO_PRIORITY,
+	.cra_flags 		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= KASUMI_BLOCK_SIZE,
+	.cra_ctxsize 		= sizeof(struct crypto4xx_ctx),
+	.cra_alignmask 	= 0,
+	.cra_type 		= &crypto_ablkcipher_type,
+	.cra_module 		= THIS_MODULE,
+	.cra_u 			= {
+			.ablkcipher = {
+				.min_keysize 	= KASUMI_KEY_SIZE,
+				.max_keysize 	= KASUMI_KEY_SIZE,
+				.ivsize 	= KASUMI_BLOCK_SIZE,
+				.setkey 	= crypto4xx_setkey_kasumi_p,
+				.encrypt	= crypto4xx_encrypt,
+				.decrypt	= crypto4xx_decrypt,
+			}
+		}
+	},
+	{
+	.cra_name 		= "f8(kasumi)",
+	.cra_driver_name 	= "ppc4xx-f8-kasumi",
+	.cra_priority 		= CRYPTO4XX_CRYPTO_PRIORITY,
+	.cra_flags 		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= KASUMI_BLOCK_SIZE,
+	.cra_ctxsize 		= sizeof(struct crypto4xx_ctx),
+	.cra_alignmask 	= 0,
+	.cra_type 		= &crypto_ablkcipher_type,
+	.cra_module 		= THIS_MODULE,
+	.cra_u 			= {
+			.ablkcipher = {
+				.min_keysize	= KASUMI_KEY_SIZE,
+				.max_keysize	= KASUMI_KEY_SIZE,
+				.ivsize		= KASUMI_BLOCK_SIZE,
+				.setkey		= crypto4xx_setkey_kasumi_f8,
+				.encrypt	= crypto4xx_encrypt_kasumi_f8,
+				.decrypt	= crypto4xx_decrypt_kasumi_f8,
+			}
+		}
+	},
+	{.cra_name 		= "f9(kasumi)",
+	.cra_driver_name 	= "ppc4xx-f9-kasumi",
+	.cra_priority 		= CRYPTO4XX_CRYPTO_PRIORITY,
+	.cra_flags 		= CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= KASUMI_BLOCK_SIZE,
+	.cra_ctxsize 		= sizeof(struct crypto4xx_ctx),
+	.cra_alignmask		= 0,
+	.cra_type 		= &crypto_ahash_type,
+	.cra_module 		= THIS_MODULE,
+	.cra_u			= {
+			.ahash = {
+			.digestsize 	= 8,
+			.init   	= crypto4xx_hash_init,
+			.update 	= crypto4xx_hash_update,
+			.final  	= crypto4xx_hash_final,
+			.digest 	= crypto4xx_kasumi_f9_digest,
+			.setkey 	= crypto4xx_kasumi_f9_setkey,
+			}
+		}
+	},
+	/* Crypto ARC4 - stateless */
+	{.cra_name 		= "ecb(arc4)",
+	.cra_driver_name 	= "ppc4xx-arc4",
+	.cra_priority 		= CRYPTO4XX_CRYPTO_PRIORITY,
+	.cra_flags 		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize 		= 1,
+	.cra_ctxsize 		= sizeof(struct crypto4xx_ctx),
+	.cra_alignmask 		= 0,
+	.cra_type 		= &crypto_ablkcipher_type,
+	.cra_module 		= THIS_MODULE,
+	.cra_u 			= {
+			.ablkcipher = {
+				.min_keysize 	= 1,
+				.max_keysize 	= 16,
+				.setkey 	= crypto4xx_setkey_arc4,
+				.encrypt	= crypto4xx_arc4_encrypt,
+				.decrypt	= crypto4xx_arc4_decrypt,
+			}
+		}
+	},
+	/* Crypto ARC4 - statefull */
+	{.cra_name 		= "cbc(arc4)",
+	.cra_driver_name 	= "ppc4xx-arc4",
+	.cra_priority 		= CRYPTO4XX_CRYPTO_PRIORITY,
+	.cra_flags 		= CRYPTO_ALG_TYPE_BLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= 1,
+	.cra_ctxsize 		= sizeof(struct crypto4xx_ctx),
+	.cra_alignmask 		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module 		= THIS_MODULE,
+	.cra_u 			= {
+			.ablkcipher = {
+				.min_keysize 	= 1,
+				.max_keysize	= 16,
+				.setkey		= crypto4xx_setkey_arc4,
+				.encrypt 	= crypto4xx_arc4_encrypt,
+				.decrypt	= crypto4xx_arc4_decrypt,
 			}
 		}
 	},
@@ -1275,7 +2034,6 @@ static int __exit crypto4xx_remove(struct of_device *ofdev)
 	crypto4xx_unregister_alg(core_dev->dev);
 	/* Free all allocated memory */
 	crypto4xx_stop_all(core_dev);
-
 	return 0;
 }
 
diff --git a/drivers/crypto/amcc/crypto4xx_core.h b/drivers/crypto/amcc/crypto4xx_core.h
index 1ef1034..f3d04b6 100644
--- a/drivers/crypto/amcc/crypto4xx_core.h
+++ b/drivers/crypto/amcc/crypto4xx_core.h
@@ -116,6 +116,8 @@ struct crypto4xx_ctx {
 	dma_addr_t sa_in_dma_addr;
 	void *sa_out;
 	dma_addr_t sa_out_dma_addr;
+	void *arc4_state_record;
+	dma_addr_t arc4_state_record_dma_addr;
 	void *state_record;
 	dma_addr_t state_record_dma_addr;
 	u32 sa_len;
@@ -125,7 +127,11 @@ struct crypto4xx_ctx {
 	u32 save_iv;
 	u32 pd_ctl_len;
 	u32 pd_ctl;
+	u32 append_icv;
+	u32 is_gcm;
+	u32 ctr_aes;
 	u32 bypass;
+	u32 init_arc4;
 	u32 is_hash;
 	u32 hash_final;
 };
@@ -154,9 +160,12 @@ extern u32 crypto4xx_alloc_sa_rctx(struct crypto4xx_ctx *ctx,
 extern void crypto4xx_free_sa_rctx(struct crypto4xx_ctx *rctx);
 extern void crypto4xx_free_ctx(struct crypto4xx_ctx *ctx);
 extern u32 crypto4xx_alloc_state_record(struct crypto4xx_ctx *ctx);
+extern u32 crypto4xx_alloc_arc4_state_record(struct crypto4xx_ctx *ctx);
+extern void crypto4xx_free_arc4_state_record(struct crypto4xx_ctx *ctx);
 extern u32 get_dynamic_sa_offset_state_ptr_field(struct crypto4xx_ctx *ctx);
 extern u32 get_dynamic_sa_offset_key_field(struct crypto4xx_ctx *ctx);
 extern u32 get_dynamic_sa_iv_size(struct crypto4xx_ctx *ctx);
+u32 get_dynamic_sa_offset_arc4_state_ptr(struct crypto4xx_ctx *ctx);
 extern void crypto4xx_memcpy_le(unsigned int *dst,
 				const unsigned char *buf, int len);
 extern u32 crypto4xx_build_pd(struct crypto_async_request *req,
@@ -164,9 +173,15 @@ extern u32 crypto4xx_build_pd(struct crypto_async_request *req,
 			      struct scatterlist *src,
 			      struct scatterlist *dst,
 			      unsigned int datalen,
+			      struct scatterlist *assoc,
+			      u32 aad_len,
 			      void *iv, u32 iv_len);
 extern int crypto4xx_setkey_aes_cbc(struct crypto_ablkcipher *cipher,
 				    const u8 *key, unsigned int keylen);
+extern int crypto4xx_setkey_3des_cbc(struct crypto_ablkcipher *cipher,
+				     const u8 *key, unsigned int keylen);
+extern int crypto4xx_setkey_3des_ecb(struct crypto_ablkcipher *cipher,
+				     const u8 *key, unsigned int keylen);
 extern int crypto4xx_encrypt(struct ablkcipher_request *req);
 extern int crypto4xx_decrypt(struct ablkcipher_request *req);
 extern int crypto4xx_sha1_alg_init(struct crypto_tfm *tfm);
@@ -174,4 +189,81 @@ extern int crypto4xx_hash_digest(struct ahash_request *req);
 extern int crypto4xx_hash_final(struct ahash_request *req);
 extern int crypto4xx_hash_update(struct ahash_request *req);
 extern int crypto4xx_hash_init(struct ahash_request *req);
+extern int crypto4xx_md5_alg_init(struct crypto_tfm *tfm);
+extern int crypto4xx_hash_hmac_setkey(struct crypto_ahash *hash,
+			       const u8 *key,
+			       unsigned int keylen,
+			       unsigned int sa_len,
+			       unsigned char ha,
+			       unsigned char hm,
+			       unsigned int max_keylen);
+extern int crypto4xx_md5_hmac_setkey(struct crypto_ahash *hash, const u8 *key,
+			      unsigned int keylen);
+extern int crypto4xx_sha1_alg_init(struct crypto_tfm *tfm);
+extern int crypto4xx_sha2_alg_init(struct crypto_tfm *tfm);
+extern int crypto4xx_sha2_hmac_setkey(struct crypto_ahash *hash,
+			       const u8 *key,
+			       unsigned int keylen);
+extern int crypto4xx_sha1_hmac_setkey(struct crypto_ahash *hash, const u8 *key,
+			       unsigned int keylen);
+extern u32 get_dynamic_sa_offset_inner_digest(struct crypto4xx_ctx *ctx);
+extern u32 get_dynamic_sa_offset_outer_digest(struct crypto4xx_ctx *ctx);
+extern int crypto4xx_pre_compute_hmac(struct crypto4xx_ctx *ctx,
+			       void *key,
+			       unsigned int keylen,
+			       unsigned int bs,
+			       unsigned char ha,
+			       unsigned char digs);
+int crypto4xx_setkey_aes_ecb(struct crypto_ablkcipher *cipher,
+			     const u8 *key, unsigned int keylen);
+int crypto4xx_setkey_aes_ofb(struct crypto_ablkcipher *cipher,
+			     const u8 *key, unsigned int keylen);
+int crypto4xx_setkey_aes_cfb(struct crypto_ablkcipher *cipher,
+			     const u8 *key, unsigned int keylen);
+int crypto4xx_setkey_aes_ctr(struct crypto_ablkcipher *cipher,
+			     const u8 *key, unsigned int keylen);
+int crypto4xx_setkey_aes_gcm(struct crypto_aead *cipher,
+			     const u8 *key, unsigned int keylen);
+int crypto4xx_setkey_aes_ccm(struct crypto_aead *cipher,
+			     const u8 *key, unsigned int keylen);
+
+int crypto4xx_encrypt_aes_gcm(struct aead_request *req);
+int crypto4xx_decrypt_aes_gcm(struct aead_request *req);
+int crypto4xx_encrypt_aes_ccm(struct aead_request *req);
+int crypto4xx_decrypt_aes_ccm(struct aead_request *req);
+int crypto4xx_encrypt_ctr(struct ablkcipher_request *req);
+int crypto4xx_decrypt_ctr(struct ablkcipher_request *req);
+int crypto4xx_setauthsize_aes(struct crypto_aead *ciper,
+			      unsigned int authsize);
+int crypto4xx_givencrypt_aes_ccm(struct aead_givcrypt_request *req);
+int crypto4xx_givencrypt_aes_gcm(struct aead_givcrypt_request *req);
+int crypto4xx_givdecrypt_aes_ccm(struct aead_givcrypt_request *req);
+int crypto4xx_givdecrypt_aes_gcm(struct aead_givcrypt_request *req);
+int crypto4xx_setkey_kasumi_f8(struct crypto_ablkcipher *cipher,
+			       const u8 *key,
+			       unsigned int keylen);
+
+int crypto4xx_encrypt_kasumi_f8(struct ablkcipher_request *req);
+int crypto4xx_decrypt_kasumi_f8(struct ablkcipher_request *req);
+int crypto4xx_setkey_kasumi_p(struct crypto_ablkcipher *cipher,
+			      const u8 *key,
+			      unsigned int keylen);
+int crypto4xx_kasumi_f9_digest(struct ahash_request *req);
+int crypto4xx_kasumi_f9_setkey(struct crypto_ahash *hash,
+			       const u8 *key, unsigned int keylen);
+int crypto4xx_xcbc_setkey(struct crypto_ahash *hash,
+			  const u8 *key,
+			  unsigned int keylen);
+int crypto4xx_setkey_arc4(struct crypto_ablkcipher *cipher,
+			  const u8 *key, unsigned int keylen);
+int crypto4xx_arc4_decrypt(struct ablkcipher_request *req);
+int crypto4xx_arc4_encrypt(struct ablkcipher_request *req);
+u32 crypto4xx_alloc_arc4_state_record(struct crypto4xx_ctx *ctx);
+int crypto4xx_setauthsize_aes_ccm(struct crypto_aead *ciper,
+				  unsigned int authsize);
+
+/* From crypto/md5.c */
+extern void md5_get_immediate_hash(struct crypto_tfm *tfm, u8 *data);
+extern unsigned int crypto4xx_sa_hash_tbl[3][6];
+
 #endif
diff --git a/drivers/crypto/amcc/crypto4xx_sa.c b/drivers/crypto/amcc/crypto4xx_sa.c
index 466fd94..fa4ff7a 100644
--- a/drivers/crypto/amcc/crypto4xx_sa.c
+++ b/drivers/crypto/amcc/crypto4xx_sa.c
@@ -84,6 +84,119 @@ u32 get_dynamic_sa_offset_state_ptr_field(struct crypto4xx_ctx *ctx)
 	return sizeof(struct dynamic_sa_ctl) + offset * 4;
 }
 
+u32 get_dynamic_sa_offset_arc4_state_ptr(struct crypto4xx_ctx *ctx)
+{
+	u32 offset;
+	union dynamic_sa_contents cts;
+
+	if (ctx->direction == DIR_INBOUND)
+		cts.w = ((struct dynamic_sa_ctl *)(ctx->sa_in))->sa_contents;
+	else
+		cts.w = ((struct dynamic_sa_ctl *)(ctx->sa_out))->sa_contents;
+	offset = cts.bf.key_size
+		+ cts.bf.inner_size
+		+ cts.bf.outer_size
+		+ cts.bf.spi
+		+ cts.bf.seq_num0
+		+ cts.bf.seq_num1
+		+ cts.bf.seq_num_mask0
+		+ cts.bf.seq_num_mask1
+		+ cts.bf.seq_num_mask2
+		+ cts.bf.seq_num_mask3
+		+ cts.bf.iv0
+		+ cts.bf.iv1
+		+ cts.bf.iv2
+		+ cts.bf.iv3
+		+ cts.bf.state_ptr
+		+ cts.bf.arc4_ij_ptr;
+
+	return sizeof(struct dynamic_sa_ctl) + offset * 4;
+}
+
+u32 get_dynamic_sa_offset_inner_digest(struct crypto4xx_ctx *ctx)
+{
+	u32 offset;
+	union dynamic_sa_contents cts;
+
+	if (ctx->direction == DIR_INBOUND)
+		cts.w = ((struct dynamic_sa_ctl *)(ctx->sa_in))->sa_contents;
+	else
+		cts.w = ((struct dynamic_sa_ctl *)(ctx->sa_out))->sa_contents;
+	offset = cts.bf.key_size;
+
+	return sizeof(struct dynamic_sa_ctl) + offset * 4;
+}
+
+u32 get_dynamic_sa_offset_outer_digest(struct crypto4xx_ctx *ctx)
+{
+	u32 offset;
+	union dynamic_sa_contents cts;
+
+	if (ctx->direction == DIR_INBOUND)
+		cts.w = ((struct dynamic_sa_ctl *)(ctx->sa_in))->sa_contents;
+	else
+		cts.w = ((struct dynamic_sa_ctl *)(ctx->sa_out))->sa_contents;
+
+	offset = cts.bf.key_size
+		+ cts.bf.inner_size;
+
+	return sizeof(struct dynamic_sa_ctl) + offset * 4;
+}
+
+u32 get_dynamic_sa_offset_spi(struct crypto4xx_ctx *ctx)
+{
+	u32 offset;
+	union dynamic_sa_contents cts;
+
+	if (ctx->direction == DIR_INBOUND)
+		cts.w = ((struct dynamic_sa_ctl *)(ctx->sa_in))->sa_contents;
+	else
+		cts.w = ((struct dynamic_sa_ctl *)(ctx->sa_out))->sa_contents;
+
+	offset = cts.bf.key_size
+		+ cts.bf.inner_size
+		+ cts.bf.outer_size;
+
+	return sizeof(struct dynamic_sa_ctl) + offset * 4;
+}
+
+u32 get_dynamic_sa_offset_seq_num(struct crypto4xx_ctx *ctx)
+{
+	u32 offset;
+	union dynamic_sa_contents cts;
+
+	if (ctx->direction == DIR_INBOUND)
+		cts.w = ((struct dynamic_sa_ctl *)(ctx->sa_in))->sa_contents;
+	else
+		cts.w = ((struct dynamic_sa_ctl *)(ctx->sa_out))->sa_contents;
+
+	offset = cts.bf.key_size
+		+ cts.bf.inner_size
+		+ cts.bf.outer_size
+		+ cts.bf.spi;
+	return sizeof(struct dynamic_sa_ctl) + offset * 4;
+}
+
+u32 get_dynamic_sa_offset_seq_num_mask(struct crypto4xx_ctx *ctx)
+{
+	u32 offset;
+	union dynamic_sa_contents cts;
+
+	if (ctx->direction == DIR_INBOUND)
+		cts.w = ((struct dynamic_sa_ctl *)(ctx->sa_in))->sa_contents;
+	else
+		cts.w = ((struct dynamic_sa_ctl *)(ctx->sa_out))->sa_contents;
+
+	offset = cts.bf.key_size
+		+ cts.bf.inner_size
+		+ cts.bf.outer_size
+		+ cts.bf.spi
+		+ cts.bf.seq_num0
+		+ cts.bf.seq_num1;
+
+	return sizeof(struct dynamic_sa_ctl) + offset * 4;
+}
+
 u32 get_dynamic_sa_iv_size(struct crypto4xx_ctx *ctx)
 {
 	union dynamic_sa_contents cts;
@@ -92,6 +205,7 @@ u32 get_dynamic_sa_iv_size(struct crypto4xx_ctx *ctx)
 		cts.w = ((struct dynamic_sa_ctl *) ctx->sa_in)->sa_contents;
 	else
 		cts.w = ((struct dynamic_sa_ctl *) ctx->sa_out)->sa_contents;
+
 	return (cts.bf.iv0 + cts.bf.iv1 + cts.bf.iv2 + cts.bf.iv3) * 4;
 }
 
diff --git a/drivers/crypto/amcc/crypto4xx_sa.h b/drivers/crypto/amcc/crypto4xx_sa.h
index 4b83ed7..5a1e308 100644
--- a/drivers/crypto/amcc/crypto4xx_sa.h
+++ b/drivers/crypto/amcc/crypto4xx_sa.h
@@ -50,12 +50,42 @@ union dynamic_sa_contents {
 	u32 w;
 } __attribute__((packed));
 
+#define SA_OPCODE_ESP                   	0
+#define SA_OPCODE_AH                    	1
+#define SA_OPCODE_SSL                   	4
+#define SA_OPCODE_TLS                   	5
+#define SA_OPCODE_SRTP                  	7
+#define SA_OPCODE_DTLS                  	1
+#define SA_OPCODE_TLS1_1                	6
+
+#define SA_OP_GROUP_BASIC               	0
+#define SA_OP_GROUP_PROTOCOL            	1
+#define SA_OP_GROUP_EXTEND_PROTOCOL     	3
+
+#define SA_OPCODE_EXT_PROT_DTLS         	1
+#define SA_OPCODE_EXT_PROT_MACSEC       	2
+#define SA_OPCODE_EXT_PROT_SSL          	4
+#define SA_OPCODE_EXT_PROT_TLS10        	5
+#define SA_OPCODE_EXT_PROT_TLS11        	6
+
 #define DIR_OUTBOUND				0
 #define DIR_INBOUND				1
-#define SA_OP_GROUP_BASIC			0
 #define SA_OPCODE_ENCRYPT			0
 #define SA_OPCODE_DECRYPT			0
+#define SA_OPCODE_ENCRYPT_HASH          	1
+#define SA_OPCODE_HASH_DECRYPT			1
 #define SA_OPCODE_HASH				3
+#define SA_OPCODE_HASH_ENCRYPT          	4
+#define SA_OPCODE_DECRYPT_HASH			4
+
+#define SA_OPCODE_ESP                   	0
+#define SA_OPCODE_AH                    	1
+#define SA_OPCODE_SSL                   	4
+#define SA_OPCODE_TLS                   	5
+#define SA_OPCODE_SRTP                  	7
+#define SA_OPCODE_DTLS                  	1
+#define SA_OPCODE_TLS1_1                	6
+
 #define SA_CIPHER_ALG_DES			0
 #define SA_CIPHER_ALG_3DES			1
 #define SA_CIPHER_ALG_ARC4			2
@@ -65,8 +95,17 @@ union dynamic_sa_contents {
 
 #define SA_HASH_ALG_MD5				0
 #define SA_HASH_ALG_SHA1			1
+#define SA_HASH_ALG_SHA224              	2
+#define SA_HASH_ALG_SHA256              	3
+#define SA_HASH_ALG_SHA384              	4
+#define SA_HASH_ALG_SHA512              	5
+#define HASH_ALG_MAX_CNT			6
+#define SA_HASH_ALG_AES_XCBC_MAC_128    	8
+#define SA_HASH_ALG_KASUMI_f9           	9
+#define SA_HASH_ALG_GHASH			12
+#define SA_HASH_ALG_GMAC        		13
+#define SA_HASH_ALG_CBC_MAC			14
 #define SA_HASH_ALG_NULL			15
-#define SA_HASH_ALG_SHA1_DIGEST_SIZE		20
 
 #define SA_LOAD_HASH_FROM_SA			0
 #define SA_LOAD_HASH_FROM_STATE			2
@@ -87,6 +126,16 @@ union dynamic_sa_contents {
 #define SA_HEADER_PROC				1
 #define SA_NO_HEADER_PROC			0
 
+#define SA_HASH_ALG_MD5_DIGEST_SIZE		16
+#define SA_HASH_ALG_SHA1_DIGEST_SIZE		20
+#define SA_HASH_ALG_SHA224_DIGEST_SIZE		28
+#define SA_HASH_ALG_SHA256_DIGEST_SIZE		32
+#define SA_HASH_ALG_SHA384_DIGEST_SIZE		48
+#define SA_HASH_ALG_SHA512_DIGEST_SIZE		64
+
+
+#define CRYPTO4XX_MAC_ALGS	{ "md5", "sha1", \
+				"sha224", "sha256", "sha384", "sha512" }
 union sa_command_0 {
 	struct {
 		u32 scatter:1;
@@ -111,7 +160,13 @@ union sa_command_0 {
 } __attribute__((packed));
 
 #define CRYPTO_MODE_ECB				0
+#define CRYPTO_MODE_KASUMI			0
 #define CRYPTO_MODE_CBC				1
+#define CRYPTO_MODE_OFB                  	2
+#define CRYPTO_MODE_CFB                  	3
+#define CRYPTO_MODE_AES_CTR              	4
+#define CRYPTO_MODE_KASUMI_f8            	4
+#define CRYPTO_MODE_AES_ICM              	5
 
 #define CRYPTO_FEEDBACK_MODE_NO_FB		0
 #define CRYPTO_FEEDBACK_MODE_64BIT_OFB		0
@@ -124,7 +179,7 @@ union sa_command_0 {
 #define SA_AES_KEY_LEN_256			4
 
 #define SA_REV2					1
-/**
+/*
  * The follow defines bits sa_command_1
  * In Basic hash mode  this bit define simple hash or hmac.
  * In IPsec mode, this bit define muting control.
@@ -177,13 +232,46 @@ struct dynamic_sa_ctl {
 /**
  * State Record for Security Association (SA)
  */
-struct  sa_state_record {
+struct sa_state_record {
 	u32 save_iv[4];
 	u32 save_hash_byte_cnt[2];
 	u32 save_digest[16];
 } __attribute__((packed));
 
 /**
+ * Arc4 State Record for Security Association (SA)
+ */
+struct arc4_sr {
+	u32 arc4_state[64];
+} __attribute__((packed));
+
+/**
+ * Security Association (SA) for DES
+ */
+struct dynamic_sa_des {
+	struct dynamic_sa_ctl  ctrl;
+	u32 key[2];
+	u32 iv[2];
+	u32 state_ptr;
+	u32 reserved;
+} __attribute__((packed));
+#define SA_DES_LEN		(sizeof(struct dynamic_sa_des)/4)
+#define SA_DES_CONTENTS         0x26000022
+
+/**
+ * Security Association (SA) for 3DES
+ */
+struct dynamic_sa_3des {
+	struct dynamic_sa_ctl ctrl;
+	u32 key[6];
+	u32 iv[2]; /* for CBC, OFC, and CFB mode */
+	u32 state_ptr;
+	u32 reserved;
+} __attribute__((packed));
+#define SA_3DES_LEN		(sizeof(struct dynamic_sa_3des)/4)
+#define SA_3DES_CONTENTS        0x26000062
+
+/**
  * Security Association (SA) for AES128
  *
  */
@@ -194,11 +282,10 @@ struct dynamic_sa_aes128 {
 	u32 state_ptr;
 	u32 reserved;
 } __attribute__((packed));
-
 #define SA_AES128_LEN		(sizeof(struct dynamic_sa_aes128)/4)
 #define SA_AES128_CONTENTS	0x3e000042
 
-/*
+/**
  * Security Association (SA) for AES192
  */
 struct dynamic_sa_aes192 {
@@ -208,7 +295,6 @@ struct dynamic_sa_aes192 {
 	u32 state_ptr;
 	u32 reserved;
 } __attribute__((packed));
-
 #define SA_AES192_LEN		(sizeof(struct dynamic_sa_aes192)/4)
 #define SA_AES192_CONTENTS	0x3e000062
 
@@ -228,6 +314,19 @@ struct dynamic_sa_aes256 {
 #define SA_AES_CONTENTS		0x3e000002
 
 /**
+ * Security Association (SA) for HASH128: HMAC-MD5
+ */
+struct dynamic_sa_hash128 {
+	struct dynamic_sa_ctl ctrl;
+	u32 inner_digest[4];
+	u32 outer_digest[4];
+	u32 state_ptr;
+	u32 reserved;
+} __attribute__((packed));
+#define SA_HASH128_LEN		(sizeof(struct dynamic_sa_hash128)/4)
+#define SA_HASH128_CONTENTS     0x20008402
+
+/**
  * Security Association (SA) for HASH160: HMAC-SHA1
  */
 struct dynamic_sa_hash160 {
@@ -240,4 +339,228 @@ struct dynamic_sa_hash160 {
 #define SA_HASH160_LEN		(sizeof(struct dynamic_sa_hash160)/4)
 #define SA_HASH160_CONTENTS     0x2000a502
 
+/**
+ * Security Association (SA) for HASH256: HMAC-SHA224, HMAC-SHA256
+ */
+struct dynamic_sa_hash256 {
+	struct dynamic_sa_ctl ctrl;
+	u32 inner_digest[8];
+	u32 outer_digest[8];
+	u32 state_ptr;
+	u32 reserved;
+} __attribute__((packed));
+#define SA_HASH256_LEN		(sizeof(struct dynamic_sa_hash256)/4)
+#define SA_HASH256_CONTENTS     0x20010802
+
+/*
+ * Security Association (SA) for HASH512: HMAC-SHA512
+ */
+struct dynamic_sa_hash512 {
+	struct dynamic_sa_ctl ctrl;
+	u32 inner_digest[16];
+	u32 outer_digest[16];
+	u32 state_ptr;
+	u32 reserved;
+} __attribute__((packed));
+#define SA_HASH512_LEN		(sizeof(struct dynamic_sa_hash512)/4)
+#define SA_HASH512_CONTENTS     0x20021002
+
+/**
+ * Security Association (SA) for AES128_XCBC_MAC
+ */
+struct dynamic_sa_aes128_xcbc_mac {
+	struct dynamic_sa_ctl ctrl;
+	u32 key[4];
+	u32 inner_digest[8];
+	u32 outer_digest[8];
+	u32 iv[4]; /* for CBC, OFC, and CFB mode */
+	u32 state_ptr;
+	u32 reserved;
+} __attribute__((packed));
+#define SA_AES128_XCBC_MAC_LEN	(sizeof(struct dynamic_sa_aes128_xcbc_mac)/4)
+#define SA_AES128_XCBC_MAC_CONTENTS     0x3e010842
+
+/**
+ * Security Association (SA) for AES128_GCM
+ */
+struct dynamic_sa_aes128_gcm {
+	struct dynamic_sa_ctl ctrl;
+	u32 key[4];
+	u32 inner_digest[4];
+	u32 outer_digest[4];
+	u32 spi;
+	u32 seq;
+	u32 iv[4]; /* for CBC, OFC, and CFB mode */
+	u32 state_ptr;
+	u32 reserved;
+} __attribute__((packed));
+#define SA_AES128_GCM_LEN	(sizeof(struct dynamic_sa_aes128_gcm)/4)
+#define SA_AES128_GCM_CONTENTS          0x3e0c8442
+
+/**
+ * Security Association (SA) for AES192_XCBC_MAC
+ */
+struct dynamic_sa_aes192_xcbc_mac {
+	struct dynamic_sa_ctl ctrl;
+	u32 key[6];
+	u32 inner_digest[8];
+	u32 outer_digest[8];
+	u32 iv[4]; /* for CBC, OFC, and CFB mode */
+	u32 state_ptr;
+	u32 reserved;
+} __attribute__((packed));
+#define SA_AES192_XCBC_MAC_LEN	(sizeof(struct dynamic_sa_aes192_xcbc_mac)/4)
+#define SA_AES192_XCBC_MAC_CONTENTS     0x3e010862
+
+/**
+ * Security Association (SA) for AES192_GCM
+ */
+struct dynamic_sa_aes192_gcm {
+	struct dynamic_sa_ctl ctrl;
+	u32 key[6];
+	u32 inner_digest[4];
+	u32 outer_digest[4];
+	u32 spi;
+	u32 seq;
+	u32 iv[4]; /* for CBC, OFC, and CFB mode */
+	u32 state_ptr;
+	u32 reserved;
+} __attribute__((packed));
+#define SA_AES192_GCM_LEN	(sizeof(struct dynamic_sa_aes192_gcm)/4)
+#define SA_AES192_GCM_CONTENTS          0x3e0c8462
+
+
+/**
+ * Security Association (SA) for AES256_XCBC_MAC
+ */
+struct dynamic_sa_aes256_xcbc_mac {
+	struct dynamic_sa_ctl ctrl;
+	u32 key[8];
+	u32 inner_digest[8];
+	u32 outer_digest[8];
+	u32 iv[4]; /* for CBC, OFC, and CFB mode */
+	u32 state_ptr;
+	u32 reserved;
+} __attribute__((packed));
+#define SA_AES256_XCBC_MAC_LEN	(sizeof(struct dynamic_sa_aes256_xcbc_mac)/4)
+#define SA_AES256_XCBC_MAC_CONTENTS     0x3e010882
+
+/**
+ * Security Association (SA) for AES256_GCM
+ */
+struct dynamic_sa_aes256_gcm {
+	struct dynamic_sa_ctl ctrl;
+	u32 key[8];
+	u32 inner_digest[4];
+	u32 outer_digest[4];
+	u32 spi;
+	u32 seq;
+	u32 iv[4]; /* for CBC, OFC, and CFB mode */
+	u32 state_ptr;
+	u32 reserved;
+} __attribute__((packed));
+#define SA_AES256_GCM_LEN	(sizeof(struct dynamic_sa_aes256_gcm)/4)
+#define SA_AES256_GCM_CONTENTS          0x3e0c8482
+#define SA_AES_GCM_CONTENTS          0x3e0c8402
+
+/**
+ * Security Association (SA) for Kasumi
+ */
+struct dynamic_sa_kasumi {
+	struct dynamic_sa_ctl ctrl;
+	u32 key[4];
+	u32 state_ptr;
+	u32 reserved;
+} __attribute__((packed));
+#define SA_KASUMI_LEN		(sizeof(struct dynamic_sa_kasumi)/4)
+#define SA_KASUMI_CONTENTS              0x20000042
+
+/**
+ * Security Association (SA) for Kasumi f8
+ */
+struct dynamic_sa_kasumi_f8 {
+	struct dynamic_sa_ctl ctrl;
+	u32 key[4];
+	u32 iv[2];
+	u32 state_ptr;
+	u32 reserved;
+} __attribute__((packed));
+#define SA_KASUMI_F8_LEN	(sizeof(struct dynamic_sa_kasumi_f8)/4)
+#define SA_KASUMI_F8_CONTENTS           0x26000042
+
+#define KASUMI_BLOCK_SIZE 8
+#define KASUMI_KEY_SIZE   16
+
+/**
+ * Security Association (SA) for Kasumi f8
+ */
+struct dynamic_sa_kasumi_f9 {
+	struct dynamic_sa_ctl ctrl;
+	u32 inner_digest[4];
+	u32 outter_digest[3];
+	u32 state_ptr;
+	u32 reserved;
+} __attribute__((packed));
+#define SA_KASUMI_F9_LEN	(sizeof(struct dynamic_sa_kasumi_f9)/4)
+#define SA_KASUMI_F9_CONTENTS           0x20006402
+
+/**
+ * Security Association (SA) for AES256 CCM
+ */
+struct dynamic_sa_aes256_ccm {
+	struct dynamic_sa_ctl ctrl;
+	u32 key[8];
+	u32 iv[4]; /* for CBC, OFC, and CFB mode */
+	u32 state_ptr;
+	u32 reserved;
+} __attribute__((packed));
+#define SA_AES256_CCM_LEN	(sizeof(struct dynamic_sa_aes256_ccm)/4)
+#define SA_AES256_CCM_CONTENTS      0x3e000082
+#define SA_AES_CCM_CONTENTS      0x3e000002
+
+/**
+ * Security Association (SA) for AES192 CCM
+ */
+struct dynamic_sa_aes192_ccm {
+	struct dynamic_sa_ctl ctrl;
+	u32 key[6];
+	u32 iv[4]; /* for CBC, OFC, and CFB mode */
+	u32 state_ptr;
+	u32 reserved;
+} __attribute__((packed));
+#define SA_AES192_CCM_LEN           (sizeof(struct dynamic_sa_aes192_ccm)/4)
+#define SA_AES192_CCM_CONTENTS      0x3e000062
+
+/**
+ * Security Association (SA) for AES128 CCM
+ */
+struct dynamic_sa_aes128_ccm {
+	struct dynamic_sa_ctl ctrl;
+	u32 key[4];
+	u32 iv[4]; /* for CBC, OFC, and CFB mode */
+	u32 state_ptr;
+	u32 reserved;
+} __attribute__((packed));
+#define SA_AES128_CCM_LEN	(sizeof(struct dynamic_sa_aes128_ccm)/4)
+#define SA_AES128_CCM_CONTENTS      0x3e000042
+
+/**
+ * Security Association (SA) for ARC4
+ */
+struct arc4_ij_ptr {
+	u32 rsv:16;
+	u32 j:8;
+	u32 i:8;
+} __attribute__((packed));
+
+struct dynamic_sa_arc4 {
+	struct dynamic_sa_ctl ctrl;
+	u32 key[4];
+	struct arc4_ij_ptr ij;
+	u32 arc4_state_ptr;
+	u32 reserved;
+} __attribute__((packed));
+#define SA_ARC4_LEN		(sizeof(struct dynamic_sa_arc4)/4)
+#define SA_ARC4_CONTENTS        0xc0000042
+
 #endif
-- 
1.5.5

