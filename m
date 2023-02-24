Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92840C64ED8
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Feb 2023 10:18:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbjBXKSS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Feb 2023 05:18:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjBXKSS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Feb 2023 05:18:18 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D1AF77F
        for <linux-crypto@vger.kernel.org>; Fri, 24 Feb 2023 02:18:14 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pVV9T-00FBqn-FU; Fri, 24 Feb 2023 18:18:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 24 Feb 2023 18:18:07 +0800
Date:   Fri, 24 Feb 2023 18:18:07 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>
Subject: [PATCH] crypto: caam - Fix edesc/iv ordering mixup
Message-ID: <Y/iO3+HbrK0TnDln@gondor.apana.org.au>
References: <Y4nDL50nToBbi4DS@gondor.apana.org.au>
 <Y4xpGNNsfbucyUlt@infradead.org>
 <Y47BgCuZsYLX61A9@gondor.apana.org.au>
 <Y47g7qO8dsRdxCgf@infradead.org>
 <Y47+gxbdKR03EYCj@gondor.apana.org.au>
 <Y61WrVAjjtAMAvSh@gondor.apana.org.au>
 <Y651YoR58cCg3adj@gondor.apana.org.au>
 <DU0PR04MB95635D72885111458C50DB6F8EA89@DU0PR04MB9563.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DU0PR04MB95635D72885111458C50DB6F8EA89@DU0PR04MB9563.eurprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Meenakshi:

On Fri, Feb 24, 2023 at 06:23:15AM +0000, Meenakshi Aggarwal wrote:
>
> with this change, edesc is following IV but we need IV to follow edesc.
> Also, we are freeing edesc pointer in function, returning edesc pointer and calling function also free edesc pointer but you have allocated 
> IV . So we are facing kernel crash.
> 
> We need to fix this, please share why are you allocating IV in place of edesc ?

Sorry, my patch was completely broken.  I was trying to place the
IV at the front in a vain effort to reduce the total allocation size.

Anyhow, please let me know if this patch fixes the problem, and I
will push it to Linus.

BTW, should we add you to the list of maintainers for caam? Perhaps
next time we can spot the problem earlier.  Thanks!

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
index 4a9b998a8d26..c71955ac2252 100644
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
@@ -1683,18 +1687,19 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
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
@@ -1706,6 +1711,8 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 
 	/* Make sure IV is located in a DMAable area */
 	if (ivsize) {
+		iv = (u8 *)edesc->sec4_sg + sec4_sg_bytes;
+		iv = PTR_ALIGN(iv, dma_get_cache_alignment());
 		memcpy(iv, req->iv, ivsize);
 
 		iv_dma = dma_map_single(jrdev, iv, ivsize, DMA_BIDIRECTIONAL);
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index 5e218bf20d5b..5d17f5862b93 100644
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
@@ -1259,6 +1262,7 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 	int dst_sg_idx, qm_sg_ents, qm_sg_bytes;
 	struct qm_sg_entry *sg_table, *fd_sgt;
 	struct caam_drv_ctx *drv_ctx;
+	unsigned int len;
 
 	drv_ctx = get_drv_ctx(ctx, encrypt ? ENCRYPT : DECRYPT);
 	if (IS_ERR(drv_ctx))
@@ -1319,9 +1323,12 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
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
@@ -1330,18 +1337,18 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
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
-
 	/* Make sure IV is located in a DMAable area */
 	sg_table = &edesc->sgt[0];
+	iv = (u8 *)(sg_table + qm_sg_ents);
+	iv = PTR_ALIGN(iv, dma_get_cache_alignment());
 	memcpy(iv, req->iv, ivsize);
 
 	iv_dma = dma_map_single(qidev, iv, ivsize, DMA_BIDIRECTIONAL);
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
