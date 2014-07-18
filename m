From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH 3/9] crypto: caam - code cleanup
Date: Fri, 18 Jul 2014 19:37:20 +0300
Message-ID: <1405701446-13656-4-git-send-email-horia.geanta@freescale.com>
References: <1405701446-13656-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "David S. Miller" <davem@davemloft.net>,
	Carmen Iorga <carmen.iorga@freescale.com>,
	Kim Phillips <kim.phillips@freescale.com>,
	Alexandru Porosanu <alexandru.porosanu@freescale.com>,
	Vakul Garg <vakul@freescale.com>,
	Ruchika Gupta <ruchika.gupta@freescale.com>,
	"Horia Geanta" <horia.geanta@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	<linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:52962
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756357AbaGRQyf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Jul 2014 12:54:35 -0400
In-Reply-To: <1405701446-13656-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

1. Fix the following sparse/smatch warnings:
drivers/crypto/caam/ctrl.c:365:5: warning: symbol 'caam_get_era' was not declared. Should it be static?
drivers/crypto/caam/ctrl.c:372 caam_get_era() info: loop could be replaced with if statement.
drivers/crypto/caam/ctrl.c:368 caam_get_era() info: ignoring unreachable code.
drivers/crypto/caam/jr.c:68:5: warning: symbol 'caam_jr_shutdown' was not declared. Should it be static?
drivers/crypto/caam/jr.c:475:23: warning: incorrect type in assignment (different address spaces)
drivers/crypto/caam/jr.c:475:23:    expected struct caam_job_ring [noderef] <asn:2>*rregs
drivers/crypto/caam/jr.c:475:23:    got struct caam_job_ring *<noident>
drivers/crypto/caam/caamrng.c:343 caam_rng_init() error: no modifiers for allocation.

2. remove unreachable code in report_ccb_status
ERRID is a 4-bit field.
Since err_id values are in [0..15] and err_id_list array size is 16,
the condition "err_id < ARRAY_SIZE(err_id_list)" is always true.

3. remove unused / unneeded variables

4. remove precision loss warning - offset field in HW s/g table

5. replace offsetof with container_of

Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
 drivers/crypto/caam/caamalg.c    | 59 ++++++++++++++++++----------------------
 drivers/crypto/caam/caamhash.c   | 12 +++-----
 drivers/crypto/caam/caamrng.c    |  2 +-
 drivers/crypto/caam/ctrl.c       |  8 ++++--
 drivers/crypto/caam/error.c      |  5 ++--
 drivers/crypto/caam/jr.c         |  4 +--
 drivers/crypto/caam/sg_sw_sec4.h |  2 +-
 7 files changed, 42 insertions(+), 50 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index a80ea853701d..c3a845856cd0 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -925,8 +925,7 @@ static void aead_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 	dev_err(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
 #endif
 
-	edesc = (struct aead_edesc *)((char *)desc -
-		 offsetof(struct aead_edesc, hw_desc));
+	edesc = container_of(desc, struct aead_edesc, hw_desc[0]);
 
 	if (err)
 		caam_jr_strstatus(jrdev, err);
@@ -964,8 +963,7 @@ static void aead_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 	dev_err(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
 #endif
 
-	edesc = (struct aead_edesc *)((char *)desc -
-		 offsetof(struct aead_edesc, hw_desc));
+	edesc = container_of(desc, struct aead_edesc, hw_desc[0]);
 
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "dstiv  @"__stringify(__LINE__)": ",
@@ -1019,8 +1017,7 @@ static void ablkcipher_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 	dev_err(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
 #endif
 
-	edesc = (struct ablkcipher_edesc *)((char *)desc -
-		 offsetof(struct ablkcipher_edesc, hw_desc));
+	edesc = container_of(desc, struct ablkcipher_edesc, hw_desc[0]);
 
 	if (err)
 		caam_jr_strstatus(jrdev, err);
@@ -1052,8 +1049,7 @@ static void ablkcipher_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 	dev_err(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
 #endif
 
-	edesc = (struct ablkcipher_edesc *)((char *)desc -
-		 offsetof(struct ablkcipher_edesc, hw_desc));
+	edesc = container_of(desc, struct ablkcipher_edesc, hw_desc[0]);
 	if (err)
 		caam_jr_strstatus(jrdev, err);
 
@@ -1286,7 +1282,6 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	int assoc_nents, src_nents, dst_nents = 0;
 	struct aead_edesc *edesc;
 	dma_addr_t iv_dma = 0;
-	int sgc;
 	bool all_contig = true;
 	bool assoc_chained = false, src_chained = false, dst_chained = false;
 	int ivsize = crypto_aead_ivsize(aead);
@@ -1308,16 +1303,16 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 				     &src_chained);
 	}
 
-	sgc = dma_map_sg_chained(jrdev, req->assoc, assoc_nents ? : 1,
-				 DMA_TO_DEVICE, assoc_chained);
+	dma_map_sg_chained(jrdev, req->assoc, assoc_nents ? : 1,
+			   DMA_TO_DEVICE, assoc_chained);
 	if (likely(req->src == req->dst)) {
-		sgc = dma_map_sg_chained(jrdev, req->src, src_nents ? : 1,
-					 DMA_BIDIRECTIONAL, src_chained);
+		dma_map_sg_chained(jrdev, req->src, src_nents ? : 1,
+				   DMA_BIDIRECTIONAL, src_chained);
 	} else {
-		sgc = dma_map_sg_chained(jrdev, req->src, src_nents ? : 1,
-					 DMA_TO_DEVICE, src_chained);
-		sgc = dma_map_sg_chained(jrdev, req->dst, dst_nents ? : 1,
-					 DMA_FROM_DEVICE, dst_chained);
+		dma_map_sg_chained(jrdev, req->src, src_nents ? : 1,
+				   DMA_TO_DEVICE, src_chained);
+		dma_map_sg_chained(jrdev, req->dst, dst_nents ? : 1,
+				   DMA_FROM_DEVICE, dst_chained);
 	}
 
 	iv_dma = dma_map_single(jrdev, req->iv, ivsize, DMA_TO_DEVICE);
@@ -1485,7 +1480,6 @@ static struct aead_edesc *aead_giv_edesc_alloc(struct aead_givcrypt_request
 	int assoc_nents, src_nents, dst_nents = 0;
 	struct aead_edesc *edesc;
 	dma_addr_t iv_dma = 0;
-	int sgc;
 	u32 contig = GIV_SRC_CONTIG | GIV_DST_CONTIG;
 	int ivsize = crypto_aead_ivsize(aead);
 	bool assoc_chained = false, src_chained = false, dst_chained = false;
@@ -1498,16 +1492,16 @@ static struct aead_edesc *aead_giv_edesc_alloc(struct aead_givcrypt_request
 		dst_nents = sg_count(req->dst, req->cryptlen + ctx->authsize,
 				     &dst_chained);
 
-	sgc = dma_map_sg_chained(jrdev, req->assoc, assoc_nents ? : 1,
-				 DMA_TO_DEVICE, assoc_chained);
+	dma_map_sg_chained(jrdev, req->assoc, assoc_nents ? : 1,
+			   DMA_TO_DEVICE, assoc_chained);
 	if (likely(req->src == req->dst)) {
-		sgc = dma_map_sg_chained(jrdev, req->src, src_nents ? : 1,
-					 DMA_BIDIRECTIONAL, src_chained);
+		dma_map_sg_chained(jrdev, req->src, src_nents ? : 1,
+				   DMA_BIDIRECTIONAL, src_chained);
 	} else {
-		sgc = dma_map_sg_chained(jrdev, req->src, src_nents ? : 1,
-					 DMA_TO_DEVICE, src_chained);
-		sgc = dma_map_sg_chained(jrdev, req->dst, dst_nents ? : 1,
-					 DMA_FROM_DEVICE, dst_chained);
+		dma_map_sg_chained(jrdev, req->src, src_nents ? : 1,
+				   DMA_TO_DEVICE, src_chained);
+		dma_map_sg_chained(jrdev, req->dst, dst_nents ? : 1,
+				   DMA_FROM_DEVICE, dst_chained);
 	}
 
 	iv_dma = dma_map_single(jrdev, greq->giv, ivsize, DMA_TO_DEVICE);
@@ -1655,7 +1649,6 @@ static struct ablkcipher_edesc *ablkcipher_edesc_alloc(struct ablkcipher_request
 	struct ablkcipher_edesc *edesc;
 	dma_addr_t iv_dma = 0;
 	bool iv_contig = false;
-	int sgc;
 	int ivsize = crypto_ablkcipher_ivsize(ablkcipher);
 	bool src_chained = false, dst_chained = false;
 	int sec4_sg_index;
@@ -1666,13 +1659,13 @@ static struct ablkcipher_edesc *ablkcipher_edesc_alloc(struct ablkcipher_request
 		dst_nents = sg_count(req->dst, req->nbytes, &dst_chained);
 
 	if (likely(req->src == req->dst)) {
-		sgc = dma_map_sg_chained(jrdev, req->src, src_nents ? : 1,
-					 DMA_BIDIRECTIONAL, src_chained);
+		dma_map_sg_chained(jrdev, req->src, src_nents ? : 1,
+				   DMA_BIDIRECTIONAL, src_chained);
 	} else {
-		sgc = dma_map_sg_chained(jrdev, req->src, src_nents ? : 1,
-					 DMA_TO_DEVICE, src_chained);
-		sgc = dma_map_sg_chained(jrdev, req->dst, dst_nents ? : 1,
-					 DMA_FROM_DEVICE, dst_chained);
+		dma_map_sg_chained(jrdev, req->src, src_nents ? : 1,
+				   DMA_TO_DEVICE, src_chained);
+		dma_map_sg_chained(jrdev, req->dst, dst_nents ? : 1,
+				   DMA_FROM_DEVICE, dst_chained);
 	}
 
 	iv_dma = dma_map_single(jrdev, req->info, ivsize, DMA_TO_DEVICE);
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 56ec534337b3..386efb9e192c 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -640,8 +640,7 @@ static void ahash_done(struct device *jrdev, u32 *desc, u32 err,
 	dev_err(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
 #endif
 
-	edesc = (struct ahash_edesc *)((char *)desc -
-		 offsetof(struct ahash_edesc, hw_desc));
+	edesc = container_of(desc, struct ahash_edesc, hw_desc[0]);
 	if (err)
 		caam_jr_strstatus(jrdev, err);
 
@@ -675,8 +674,7 @@ static void ahash_done_bi(struct device *jrdev, u32 *desc, u32 err,
 	dev_err(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
 #endif
 
-	edesc = (struct ahash_edesc *)((char *)desc -
-		 offsetof(struct ahash_edesc, hw_desc));
+	edesc = container_of(desc, struct ahash_edesc, hw_desc[0]);
 	if (err)
 		caam_jr_strstatus(jrdev, err);
 
@@ -710,8 +708,7 @@ static void ahash_done_ctx_src(struct device *jrdev, u32 *desc, u32 err,
 	dev_err(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
 #endif
 
-	edesc = (struct ahash_edesc *)((char *)desc -
-		 offsetof(struct ahash_edesc, hw_desc));
+	edesc = container_of(desc, struct ahash_edesc, hw_desc[0]);
 	if (err)
 		caam_jr_strstatus(jrdev, err);
 
@@ -745,8 +742,7 @@ static void ahash_done_ctx_dst(struct device *jrdev, u32 *desc, u32 err,
 	dev_err(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
 #endif
 
-	edesc = (struct ahash_edesc *)((char *)desc -
-		 offsetof(struct ahash_edesc, hw_desc));
+	edesc = container_of(desc, struct ahash_edesc, hw_desc[0]);
 	if (err)
 		caam_jr_strstatus(jrdev, err);
 
diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index 8b9df8deda67..5b288082e6ac 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -340,7 +340,7 @@ static int __init caam_rng_init(void)
 		pr_err("Job Ring Device allocation for transform failed\n");
 		return PTR_ERR(dev);
 	}
-	rng_ctx = kmalloc(sizeof(struct caam_rng_ctx), GFP_DMA);
+	rng_ctx = kmalloc(sizeof(*rng_ctx), GFP_KERNEL | GFP_DMA);
 	if (!rng_ctx)
 		return -ENOMEM;
 	err = caam_init_rng(rng_ctx, dev);
diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index cedb56500b61..be8c6c147395 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -15,6 +15,7 @@
 #include "jr.h"
 #include "desc_constr.h"
 #include "error.h"
+#include "ctrl.h"
 
 /*
  * Descriptor to instantiate RNG State Handle 0 in normal mode and
@@ -209,7 +210,7 @@ static int instantiate_rng(struct device *ctrldev, int state_handle_mask,
 		 * CAAM eras), then try again.
 		 */
 		rdsta_val =
-			rd_reg32(&topregs->ctrl.r4tst[0].rdsta) & RDSTA_IFMASK;
+			rd_reg32(&r4tst->rdsta) & RDSTA_IFMASK;
 		if (status || !(rdsta_val & (1 << sh_idx)))
 			ret = -EAGAIN;
 		if (ret)
@@ -365,10 +366,13 @@ static void kick_trng(struct platform_device *pdev, int ent_delay)
 int caam_get_era(void)
 {
 	struct device_node *caam_node;
-	for_each_compatible_node(caam_node, NULL, "fsl,sec-v4.0") {
+
+	caam_node = of_find_compatible_node(NULL, NULL, "fsl,sec-v4.0");
+	if (caam_node) {
 		const uint32_t *prop = (uint32_t *)of_get_property(caam_node,
 				"fsl,sec-era",
 				NULL);
+		of_node_put(caam_node);
 		return prop ? *prop : -ENOTSUPP;
 	}
 
diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c
index 6531054a44c8..7d6ed4722345 100644
--- a/drivers/crypto/caam/error.c
+++ b/drivers/crypto/caam/error.c
@@ -146,10 +146,9 @@ static void report_ccb_status(struct device *jrdev, const u32 status,
 	    strlen(rng_err_id_list[err_id])) {
 		/* RNG-only error */
 		err_str = rng_err_id_list[err_id];
-	} else if (err_id < ARRAY_SIZE(err_id_list))
+	} else {
 		err_str = err_id_list[err_id];
-	else
-		snprintf(err_err_code, sizeof(err_err_code), "%02x", err_id);
+	}
 
 	dev_err(jrdev, "%08x: %s: %s %d: %s%s: %s%s\n",
 		status, error, idx_str, idx,
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 50cd1b9af2ba..ec3652d62e93 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -65,7 +65,7 @@ static int caam_reset_hw_jr(struct device *dev)
 /*
  * Shutdown JobR independent of platform property code
  */
-int caam_jr_shutdown(struct device *dev)
+static int caam_jr_shutdown(struct device *dev)
 {
 	struct caam_drv_private_jr *jrp = dev_get_drvdata(dev);
 	dma_addr_t inpbusaddr, outbusaddr;
@@ -472,7 +472,7 @@ static int caam_jr_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	jrpriv->rregs = (struct caam_job_ring __force *)ctrl;
+	jrpriv->rregs = (struct caam_job_ring __iomem __force *)ctrl;
 
 	if (sizeof(dma_addr_t) == sizeof(u64))
 		if (of_device_is_compatible(nprop, "fsl,sec-v5.0-job-ring"))
diff --git a/drivers/crypto/caam/sg_sw_sec4.h b/drivers/crypto/caam/sg_sw_sec4.h
index b12ff85f4241..a6e5b94756d4 100644
--- a/drivers/crypto/caam/sg_sw_sec4.h
+++ b/drivers/crypto/caam/sg_sw_sec4.h
@@ -17,7 +17,7 @@ static inline void dma_to_sec4_sg_one(struct sec4_sg_entry *sec4_sg_ptr,
 	sec4_sg_ptr->len = len;
 	sec4_sg_ptr->reserved = 0;
 	sec4_sg_ptr->buf_pool_id = 0;
-	sec4_sg_ptr->offset = offset;
+	sec4_sg_ptr->offset = (u16)offset;
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "sec4_sg_ptr@: ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, sec4_sg_ptr,
-- 
1.8.3.1
