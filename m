Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 322C4C64ED6
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Feb 2023 09:23:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbjB0JXt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Feb 2023 04:23:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjB0JXs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Feb 2023 04:23:48 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A9DB9
        for <linux-crypto@vger.kernel.org>; Mon, 27 Feb 2023 01:23:45 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pWYpa-00Fxmw-12; Mon, 27 Feb 2023 16:25:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 27 Feb 2023 16:25:58 +0800
Date:   Mon, 27 Feb 2023 16:25:58 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Horia Geanta <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>
Subject: [v2 PATCH] crypto: caam - Fix edesc/iv ordering mixup
Message-ID: <Y/xpFtBoamuBCNfi@gondor.apana.org.au>
References: <Y4nDL50nToBbi4DS@gondor.apana.org.au>
 <Y4xpGNNsfbucyUlt@infradead.org>
 <Y47BgCuZsYLX61A9@gondor.apana.org.au>
 <Y47g7qO8dsRdxCgf@infradead.org>
 <Y47+gxbdKR03EYCj@gondor.apana.org.au>
 <Y61WrVAjjtAMAvSh@gondor.apana.org.au>
 <Y651YoR58cCg3adj@gondor.apana.org.au>
 <DU0PR04MB95635D72885111458C50DB6F8EA89@DU0PR04MB9563.eurprd04.prod.outlook.com>
 <Y/iO3+HbrK0TnDln@gondor.apana.org.au>
 <DU0PR04MB9563F6D1EFBC6165087D51EF8EAF9@DU0PR04MB9563.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DU0PR04MB9563F6D1EFBC6165087D51EF8EAF9@DU0PR04MB9563.eurprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Feb 27, 2023 at 05:20:32AM +0000, Meenakshi Aggarwal wrote:
> Hi Herbert,
> 
> I have tested your changes, not facing a kernel crash now but still kernel warning messages are coming:

Thanks for testing! Indeed, I forgot to update the IV calculations
on the way out:

---8<---
The attempt to add DMA alignment padding by moving IV to the front
of edesc was completely broken as it didn't change the places where
edesc was freed.

It's also wrong as the IV may still share a cache-line with the
edesc.

Fix this by restoring the original layout and simply reserving
enough memmory so that the IV is on a DMA cache-line by itself.

Reported-by: Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>
Fixes: 199354d7fb6e ("crypto: caam - Remove GFP_DMA and add DMA alignment padding")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 4a9b998a8d26..12b1c8346243 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -60,7 +60,11 @@
 #include <crypto/xts.h>
 #include <asm/unaligned.h>
 #include <linux/dma-mapping.h>
+#include <linux/device.h>
+#include <linux/err.h>
 #include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/string.h>
 
 /*
  * crypto alg
@@ -1000,6 +1004,13 @@ static void aead_crypt_done(struct device *jrdev, u32 *desc, u32 err,
 		crypto_finalize_aead_request(jrp->engine, req, ecode);
 }
 
+static inline u8 *skcipher_edesc_iv(struct skcipher_edesc *edesc)
+{
+
+	return PTR_ALIGN((u8 *)edesc->sec4_sg + edesc->sec4_sg_bytes,
+			 dma_get_cache_alignment());
+}
+
 static void skcipher_crypt_done(struct device *jrdev, u32 *desc, u32 err,
 				void *context)
 {
@@ -1027,8 +1038,7 @@ static void skcipher_crypt_done(struct device *jrdev, u32 *desc, u32 err,
 	 * This is used e.g. by the CTS mode.
 	 */
 	if (ivsize && !ecode) {
-		memcpy(req->iv, (u8 *)edesc->sec4_sg + edesc->sec4_sg_bytes,
-		       ivsize);
+		memcpy(req->iv, skcipher_edesc_iv(edesc), ivsize);
 
 		print_hex_dump_debug("dstiv  @" __stringify(__LINE__)": ",
 				     DUMP_PREFIX_ADDRESS, 16, 4, req->iv,
@@ -1683,18 +1693,19 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 	/*
 	 * allocate space for base edesc and hw desc commands, link tables, IV
 	 */
-	aligned_size = ALIGN(ivsize, __alignof__(*edesc));
-	aligned_size += sizeof(*edesc) + desc_bytes + sec4_sg_bytes;
+	aligned_size = sizeof(*edesc) + desc_bytes + sec4_sg_bytes;
 	aligned_size = ALIGN(aligned_size, dma_get_cache_alignment());
-	iv = kzalloc(aligned_size, flags);
-	if (!iv) {
+	aligned_size += ~(ARCH_KMALLOC_MINALIGN - 1) &
+			(dma_get_cache_alignment() - 1);
+	aligned_size += ALIGN(ivsize, dma_get_cache_alignment());
+	edesc = kzalloc(aligned_size, flags);
+	if (!edesc) {
 		dev_err(jrdev, "could not allocate extended descriptor\n");
 		caam_unmap(jrdev, req->src, req->dst, src_nents, dst_nents, 0,
 			   0, 0, 0);
 		return ERR_PTR(-ENOMEM);
 	}
 
-	edesc = (void *)(iv + ALIGN(ivsize, __alignof__(*edesc)));
 	edesc->src_nents = src_nents;
 	edesc->dst_nents = dst_nents;
 	edesc->mapped_src_nents = mapped_src_nents;
@@ -1706,6 +1717,7 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 
 	/* Make sure IV is located in a DMAable area */
 	if (ivsize) {
+		iv = skcipher_edesc_iv(edesc);
 		memcpy(iv, req->iv, ivsize);
 
 		iv_dma = dma_map_single(jrdev, iv, ivsize, DMA_BIDIRECTIONAL);
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index 5e218bf20d5b..743ce50c14f2 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -20,8 +20,11 @@
 #include "caamalg_desc.h"
 #include <crypto/xts.h>
 #include <asm/unaligned.h>
+#include <linux/device.h>
+#include <linux/err.h>
 #include <linux/dma-mapping.h>
 #include <linux/kernel.h>
+#include <linux/string.h>
 
 /*
  * crypto alg
@@ -1204,6 +1207,12 @@ static int ipsec_gcm_decrypt(struct aead_request *req)
 					   false);
 }
 
+static inline u8 *skcipher_edesc_iv(struct skcipher_edesc *edesc)
+{
+	return PTR_ALIGN((u8 *)&edesc->sgt[0] + edesc->qm_sg_bytes,
+			 dma_get_cache_alignment());
+}
+
 static void skcipher_done(struct caam_drv_req *drv_req, u32 status)
 {
 	struct skcipher_edesc *edesc;
@@ -1236,8 +1245,7 @@ static void skcipher_done(struct caam_drv_req *drv_req, u32 status)
 	 * This is used e.g. by the CTS mode.
 	 */
 	if (!ecode)
-		memcpy(req->iv, (u8 *)&edesc->sgt[0] + edesc->qm_sg_bytes,
-		       ivsize);
+		memcpy(req->iv, skcipher_edesc_iv(edesc), ivsize);
 
 	qi_cache_free(edesc);
 	skcipher_request_complete(req, ecode);
@@ -1259,6 +1267,7 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 	int dst_sg_idx, qm_sg_ents, qm_sg_bytes;
 	struct qm_sg_entry *sg_table, *fd_sgt;
 	struct caam_drv_ctx *drv_ctx;
+	unsigned int len;
 
 	drv_ctx = get_drv_ctx(ctx, encrypt ? ENCRYPT : DECRYPT);
 	if (IS_ERR(drv_ctx))
@@ -1319,9 +1328,12 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 		qm_sg_ents = 1 + pad_sg_nents(qm_sg_ents);
 
 	qm_sg_bytes = qm_sg_ents * sizeof(struct qm_sg_entry);
-	if (unlikely(ALIGN(ivsize, __alignof__(*edesc)) +
-		     offsetof(struct skcipher_edesc, sgt) + qm_sg_bytes >
-		     CAAM_QI_MEMCACHE_SIZE)) {
+
+	len = offsetof(struct skcipher_edesc, sgt) + qm_sg_bytes;
+	len = ALIGN(len, dma_get_cache_alignment());
+	len += ivsize;
+
+	if (unlikely(len > CAAM_QI_MEMCACHE_SIZE)) {
 		dev_err(qidev, "No space for %d S/G entries and/or %dB IV\n",
 			qm_sg_ents, ivsize);
 		caam_unmap(qidev, req->src, req->dst, src_nents, dst_nents, 0,
@@ -1330,18 +1342,24 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 	}
 
 	/* allocate space for base edesc, link tables and IV */
-	iv = qi_cache_alloc(flags);
-	if (unlikely(!iv)) {
+	edesc = qi_cache_alloc(flags);
+	if (unlikely(!edesc)) {
 		dev_err(qidev, "could not allocate extended descriptor\n");
 		caam_unmap(qidev, req->src, req->dst, src_nents, dst_nents, 0,
 			   0, DMA_NONE, 0, 0);
 		return ERR_PTR(-ENOMEM);
 	}
 
-	edesc = (void *)(iv + ALIGN(ivsize, __alignof__(*edesc)));
+	edesc->src_nents = src_nents;
+	edesc->dst_nents = dst_nents;
+	edesc->qm_sg_bytes = qm_sg_bytes;
+	edesc->drv_req.app_ctx = req;
+	edesc->drv_req.cbk = skcipher_done;
+	edesc->drv_req.drv_ctx = drv_ctx;
 
 	/* Make sure IV is located in a DMAable area */
 	sg_table = &edesc->sgt[0];
+	iv = skcipher_edesc_iv(edesc);
 	memcpy(iv, req->iv, ivsize);
 
 	iv_dma = dma_map_single(qidev, iv, ivsize, DMA_BIDIRECTIONAL);
@@ -1353,13 +1371,7 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 		return ERR_PTR(-ENOMEM);
 	}
 
-	edesc->src_nents = src_nents;
-	edesc->dst_nents = dst_nents;
 	edesc->iv_dma = iv_dma;
-	edesc->qm_sg_bytes = qm_sg_bytes;
-	edesc->drv_req.app_ctx = req;
-	edesc->drv_req.cbk = skcipher_done;
-	edesc->drv_req.drv_ctx = drv_ctx;
 
 	dma_to_qm_sg_one(sg_table, iv_dma, ivsize, 0);
 	sg_to_qm_sg(req->src, req->cryptlen, sg_table + 1, 0);
diff --git a/drivers/crypto/caam/qi.c b/drivers/crypto/caam/qi.c
index 4c52c9365558..2ad2c1035856 100644
--- a/drivers/crypto/caam/qi.c
+++ b/drivers/crypto/caam/qi.c
@@ -8,7 +8,13 @@
  */
 
 #include <linux/cpumask.h>
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
+#include <linux/kernel.h>
 #include <linux/kthread.h>
+#include <linux/netdevice.h>
+#include <linux/slab.h>
+#include <linux/string.h>
 #include <soc/fsl/qman.h>
 
 #include "debugfs.h"
@@ -755,8 +761,8 @@ int caam_qi_init(struct platform_device *caam_pdev)
 		napi_enable(irqtask);
 	}
 
-	qi_cache = kmem_cache_create("caamqicache", CAAM_QI_MEMCACHE_SIZE, 0,
-				     0, NULL);
+	qi_cache = kmem_cache_create("caamqicache", CAAM_QI_MEMCACHE_SIZE,
+				     dma_get_cache_alignment(), 0, NULL);
 	if (!qi_cache) {
 		dev_err(qidev, "Can't allocate CAAM cache\n");
 		free_rsp_fqs();
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
