Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ED99C433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 05:22:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D162E238D6
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 05:22:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726015AbhAUFWW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Jan 2021 00:22:22 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:49054 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727378AbhAUFRu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Jan 2021 00:17:50 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1l2SKs-0006Kh-VG; Thu, 21 Jan 2021 16:16:48 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 21 Jan 2021 16:16:46 +1100
Date:   Thu, 21 Jan 2021 16:16:46 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>
Subject: [PATCH] crypto: marvell/cesa - Fix use of sg_pcopy on iomem pointer
Message-ID: <20210121051646.GA24114@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The cesa driver mixes use of iomem pointers and normal kernel
pointers.  Sometimes it uses memcpy_toio/memcpy_fromio on both
while other times it would use straight memcpy on both, through
the sg_pcopy_* helpers.

This patch fixes this by adding a new field sram_pool to the engine
for the normal pointer case which then allows us to use the right
interface depending on the value of engine->pool.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/marvell/cesa/cesa.c b/drivers/crypto/marvell/cesa/cesa.c
index 06211858bf2e..f14aac532f53 100644
--- a/drivers/crypto/marvell/cesa/cesa.c
+++ b/drivers/crypto/marvell/cesa/cesa.c
@@ -381,10 +381,10 @@ static int mv_cesa_get_sram(struct platform_device *pdev, int idx)
 	engine->pool = of_gen_pool_get(cesa->dev->of_node,
 				       "marvell,crypto-srams", idx);
 	if (engine->pool) {
-		engine->sram = gen_pool_dma_alloc(engine->pool,
-						  cesa->sram_size,
-						  &engine->sram_dma);
-		if (engine->sram)
+		engine->sram_pool = gen_pool_dma_alloc(engine->pool,
+						       cesa->sram_size,
+						       &engine->sram_dma);
+		if (engine->sram_pool)
 			return 0;
 
 		engine->pool = NULL;
@@ -422,7 +422,7 @@ static void mv_cesa_put_sram(struct platform_device *pdev, int idx)
 	struct mv_cesa_engine *engine = &cesa->engines[idx];
 
 	if (engine->pool)
-		gen_pool_free(engine->pool, (unsigned long)engine->sram,
+		gen_pool_free(engine->pool, (unsigned long)engine->sram_pool,
 			      cesa->sram_size);
 	else
 		dma_unmap_resource(cesa->dev, engine->sram_dma,
diff --git a/drivers/crypto/marvell/cesa/cesa.h b/drivers/crypto/marvell/cesa/cesa.h
index fabfaaccca87..5c5eff0adbcc 100644
--- a/drivers/crypto/marvell/cesa/cesa.h
+++ b/drivers/crypto/marvell/cesa/cesa.h
@@ -428,6 +428,7 @@ struct mv_cesa_dev {
  * @id:			engine id
  * @regs:		engine registers
  * @sram:		SRAM memory region
+ * @sram_pool:		SRAM memory region from pool
  * @sram_dma:		DMA address of the SRAM memory region
  * @lock:		engine lock
  * @req:		current crypto request
@@ -448,7 +449,10 @@ struct mv_cesa_dev {
 struct mv_cesa_engine {
 	int id;
 	void __iomem *regs;
-	void __iomem *sram;
+	union {
+		void __iomem *sram;
+		void *sram_pool;
+	};
 	dma_addr_t sram_dma;
 	spinlock_t lock;
 	struct crypto_async_request *req;
@@ -867,6 +871,31 @@ int mv_cesa_dma_add_op_transfers(struct mv_cesa_tdma_chain *chain,
 				 struct mv_cesa_sg_dma_iter *sgiter,
 				 gfp_t gfp_flags);
 
+size_t mv_cesa_sg_copy(struct mv_cesa_engine *engine,
+		       struct scatterlist *sgl, unsigned int nents,
+		       unsigned int sram_off, size_t buflen, off_t skip,
+		       bool to_sram);
+
+static inline size_t mv_cesa_sg_copy_to_sram(struct mv_cesa_engine *engine,
+					     struct scatterlist *sgl,
+					     unsigned int nents,
+					     unsigned int sram_off,
+					     size_t buflen, off_t skip)
+{
+	return mv_cesa_sg_copy(engine, sgl, nents, sram_off, buflen, skip,
+			       true);
+}
+
+static inline size_t mv_cesa_sg_copy_from_sram(struct mv_cesa_engine *engine,
+					       struct scatterlist *sgl,
+					       unsigned int nents,
+					       unsigned int sram_off,
+					       size_t buflen, off_t skip)
+{
+	return mv_cesa_sg_copy(engine, sgl, nents, sram_off, buflen, skip,
+			       false);
+}
+
 /* Algorithm definitions */
 
 extern struct ahash_alg mv_md5_alg;
diff --git a/drivers/crypto/marvell/cesa/cipher.c b/drivers/crypto/marvell/cesa/cipher.c
index b4a6ff9dd6d5..b739d3b873dc 100644
--- a/drivers/crypto/marvell/cesa/cipher.c
+++ b/drivers/crypto/marvell/cesa/cipher.c
@@ -89,22 +89,29 @@ static void mv_cesa_skcipher_std_step(struct skcipher_request *req)
 			    CESA_SA_SRAM_PAYLOAD_SIZE);
 
 	mv_cesa_adjust_op(engine, &sreq->op);
-	memcpy_toio(engine->sram, &sreq->op, sizeof(sreq->op));
+	if (engine->pool)
+		memcpy(engine->sram_pool, &sreq->op, sizeof(sreq->op));
+	else
+		memcpy_toio(engine->sram, &sreq->op, sizeof(sreq->op));
 
-	len = sg_pcopy_to_buffer(req->src, creq->src_nents,
-				 engine->sram + CESA_SA_DATA_SRAM_OFFSET,
-				 len, sreq->offset);
+	len = mv_cesa_sg_copy_to_sram(engine, req->src, creq->src_nents,
+				      CESA_SA_DATA_SRAM_OFFSET, len,
+				      sreq->offset);
 
 	sreq->size = len;
 	mv_cesa_set_crypt_op_len(&sreq->op, len);
 
 	/* FIXME: only update enc_len field */
 	if (!sreq->skip_ctx) {
-		memcpy_toio(engine->sram, &sreq->op, sizeof(sreq->op));
+		if (engine->pool)
+			memcpy(engine->sram_pool, &sreq->op, sizeof(sreq->op));
+		else
+			memcpy_toio(engine->sram, &sreq->op, sizeof(sreq->op));
 		sreq->skip_ctx = true;
-	} else {
+	} else if (engine->pool)
+		memcpy(engine->sram_pool, &sreq->op, sizeof(sreq->op.desc));
+	else
 		memcpy_toio(engine->sram, &sreq->op, sizeof(sreq->op.desc));
-	}
 
 	mv_cesa_set_int_mask(engine, CESA_SA_INT_ACCEL0_DONE);
 	writel_relaxed(CESA_SA_CFG_PARA_DIS, engine->regs + CESA_SA_CFG);
@@ -121,9 +128,9 @@ static int mv_cesa_skcipher_std_process(struct skcipher_request *req,
 	struct mv_cesa_engine *engine = creq->base.engine;
 	size_t len;
 
-	len = sg_pcopy_from_buffer(req->dst, creq->dst_nents,
-				   engine->sram + CESA_SA_DATA_SRAM_OFFSET,
-				   sreq->size, sreq->offset);
+	len = mv_cesa_sg_copy_from_sram(engine, req->dst, creq->dst_nents,
+					CESA_SA_DATA_SRAM_OFFSET, sreq->size,
+					sreq->offset);
 
 	sreq->offset += len;
 	if (sreq->offset < req->cryptlen)
@@ -214,11 +221,14 @@ mv_cesa_skcipher_complete(struct crypto_async_request *req)
 		basereq = &creq->base;
 		memcpy(skreq->iv, basereq->chain.last->op->ctx.skcipher.iv,
 		       ivsize);
-	} else {
+	} else if (engine->pool)
+		memcpy(skreq->iv,
+		       engine->sram_pool + CESA_SA_CRYPT_IV_SRAM_OFFSET,
+		       ivsize);
+	else
 		memcpy_fromio(skreq->iv,
 			      engine->sram + CESA_SA_CRYPT_IV_SRAM_OFFSET,
 			      ivsize);
-	}
 }
 
 static const struct mv_cesa_req_ops mv_cesa_skcipher_req_ops = {
diff --git a/drivers/crypto/marvell/cesa/hash.c b/drivers/crypto/marvell/cesa/hash.c
index 8cf9fd518d86..c72b0672fc71 100644
--- a/drivers/crypto/marvell/cesa/hash.c
+++ b/drivers/crypto/marvell/cesa/hash.c
@@ -168,7 +168,12 @@ static void mv_cesa_ahash_std_step(struct ahash_request *req)
 	int i;
 
 	mv_cesa_adjust_op(engine, &creq->op_tmpl);
-	memcpy_toio(engine->sram, &creq->op_tmpl, sizeof(creq->op_tmpl));
+	if (engine->pool)
+		memcpy(engine->sram_pool, &creq->op_tmpl,
+		       sizeof(creq->op_tmpl));
+	else
+		memcpy_toio(engine->sram, &creq->op_tmpl,
+			    sizeof(creq->op_tmpl));
 
 	if (!sreq->offset) {
 		digsize = crypto_ahash_digestsize(crypto_ahash_reqtfm(req));
@@ -177,9 +182,14 @@ static void mv_cesa_ahash_std_step(struct ahash_request *req)
 				       engine->regs + CESA_IVDIG(i));
 	}
 
-	if (creq->cache_ptr)
-		memcpy_toio(engine->sram + CESA_SA_DATA_SRAM_OFFSET,
-			    creq->cache, creq->cache_ptr);
+	if (creq->cache_ptr) {
+		if (engine->pool)
+			memcpy(engine->sram_pool + CESA_SA_DATA_SRAM_OFFSET,
+			       creq->cache, creq->cache_ptr);
+		else
+			memcpy_toio(engine->sram + CESA_SA_DATA_SRAM_OFFSET,
+				    creq->cache, creq->cache_ptr);
+	}
 
 	len = min_t(size_t, req->nbytes + creq->cache_ptr - sreq->offset,
 		    CESA_SA_SRAM_PAYLOAD_SIZE);
@@ -190,12 +200,10 @@ static void mv_cesa_ahash_std_step(struct ahash_request *req)
 	}
 
 	if (len - creq->cache_ptr)
-		sreq->offset += sg_pcopy_to_buffer(req->src, creq->src_nents,
-						   engine->sram +
-						   CESA_SA_DATA_SRAM_OFFSET +
-						   creq->cache_ptr,
-						   len - creq->cache_ptr,
-						   sreq->offset);
+		sreq->offset += mv_cesa_sg_copy_to_sram(
+			engine, req->src, creq->src_nents,
+			CESA_SA_DATA_SRAM_OFFSET + creq->cache_ptr,
+			len - creq->cache_ptr, sreq->offset);
 
 	op = &creq->op_tmpl;
 
@@ -220,16 +228,28 @@ static void mv_cesa_ahash_std_step(struct ahash_request *req)
 			if (len + trailerlen > CESA_SA_SRAM_PAYLOAD_SIZE) {
 				len &= CESA_HASH_BLOCK_SIZE_MSK;
 				new_cache_ptr = 64 - trailerlen;
-				memcpy_fromio(creq->cache,
-					      engine->sram +
-					      CESA_SA_DATA_SRAM_OFFSET + len,
-					      new_cache_ptr);
+				if (engine->pool)
+					memcpy(creq->cache,
+					       engine->sram_pool +
+					       CESA_SA_DATA_SRAM_OFFSET + len,
+					       new_cache_ptr);
+				else
+					memcpy_fromio(creq->cache,
+						      engine->sram +
+						      CESA_SA_DATA_SRAM_OFFSET +
+						      len,
+						      new_cache_ptr);
 			} else {
 				i = mv_cesa_ahash_pad_req(creq, creq->cache);
 				len += i;
-				memcpy_toio(engine->sram + len +
-					    CESA_SA_DATA_SRAM_OFFSET,
-					    creq->cache, i);
+				if (engine->pool)
+					memcpy(engine->sram_pool + len +
+					       CESA_SA_DATA_SRAM_OFFSET,
+					       creq->cache, i);
+				else
+					memcpy_toio(engine->sram + len +
+						    CESA_SA_DATA_SRAM_OFFSET,
+						    creq->cache, i);
 			}
 
 			if (frag_mode == CESA_SA_DESC_CFG_LAST_FRAG)
@@ -243,7 +263,10 @@ static void mv_cesa_ahash_std_step(struct ahash_request *req)
 	mv_cesa_update_op_cfg(op, frag_mode, CESA_SA_DESC_CFG_FRAG_MSK);
 
 	/* FIXME: only update enc_len field */
-	memcpy_toio(engine->sram, op, sizeof(*op));
+	if (engine->pool)
+		memcpy(engine->sram_pool, op, sizeof(*op));
+	else
+		memcpy_toio(engine->sram, op, sizeof(*op));
 
 	if (frag_mode == CESA_SA_DESC_CFG_FIRST_FRAG)
 		mv_cesa_update_op_cfg(op, CESA_SA_DESC_CFG_MID_FRAG,
diff --git a/drivers/crypto/marvell/cesa/tdma.c b/drivers/crypto/marvell/cesa/tdma.c
index 0e0d63359798..f0b5537038c2 100644
--- a/drivers/crypto/marvell/cesa/tdma.c
+++ b/drivers/crypto/marvell/cesa/tdma.c
@@ -350,3 +350,53 @@ int mv_cesa_dma_add_op_transfers(struct mv_cesa_tdma_chain *chain,
 
 	return 0;
 }
+
+size_t mv_cesa_sg_copy(struct mv_cesa_engine *engine,
+		       struct scatterlist *sgl, unsigned int nents,
+		       unsigned int sram_off, size_t buflen, off_t skip,
+		       bool to_sram)
+{
+	unsigned int sg_flags = SG_MITER_ATOMIC;
+	struct sg_mapping_iter miter;
+	unsigned int offset = 0;
+
+	if (to_sram)
+		sg_flags |= SG_MITER_FROM_SG;
+	else
+		sg_flags |= SG_MITER_TO_SG;
+
+	sg_miter_start(&miter, sgl, nents, sg_flags);
+
+	if (!sg_miter_skip(&miter, skip))
+		return 0;
+
+	while ((offset < buflen) && sg_miter_next(&miter)) {
+		unsigned int len;
+
+		len = min(miter.length, buflen - offset);
+
+		if (to_sram) {
+			if (engine->pool)
+				memcpy(engine->sram_pool + sram_off + offset,
+				       miter.addr, len);
+			else
+				memcpy_toio(engine->sram + sram_off + offset,
+					    miter.addr, len);
+		} else {
+			if (engine->pool)
+				memcpy(miter.addr,
+				       engine->sram_pool + sram_off + offset,
+				       len);
+			else
+				memcpy_fromio(miter.addr,
+					      engine->sram + sram_off + offset,
+					      len);
+		}
+
+		offset += len;
+	}
+
+	sg_miter_stop(&miter);
+
+	return offset;
+}
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
