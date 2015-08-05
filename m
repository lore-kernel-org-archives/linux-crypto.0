From: Victoria Milhoan <vicki.milhoan@freescale.com>
Subject: [PATCH v2 01/14] crypto: caam - Add cache coherency support
Date: Wed, 5 Aug 2015 11:28:35 -0700
Message-ID: <1438799328-10757-2-git-send-email-vicki.milhoan@freescale.com>
References: <1438228709-27650-1-git-send-email-vicki.milhoan@freescale.com>
 <1438799328-10757-1-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.apana.org.au>, <horia.geanta@freescale.com>,
	<ruchika.gupta@freescale.com>, <shawnguo@kernel.org>,
	<kernel@pengutronix.de>, <linux@arm.linux.org.uk>,
	<robh+dt@kernel.org>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0138.outbound.protection.outlook.com ([157.56.110.138]:27851
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752803AbbHES24 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Aug 2015 14:28:56 -0400
In-Reply-To: <1438799328-10757-1-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Freescale i.MX6 ARM platforms do not support hardware cache coherency.
This patch adds cache coherency support to the CAAM driver.

Signed-off-by: Victoria Milhoan <vicki.milhoan@freescale.com>
---
 drivers/crypto/caam/caamhash.c |  2 +-
 drivers/crypto/caam/caamrng.c  |  4 ++++
 drivers/crypto/caam/jr.c       | 18 ++++++++++++++++++
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index dae1e80..9622a81 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -127,7 +127,7 @@ struct caam_hash_state {
 	int buflen_0;
 	u8 buf_1[CAAM_MAX_HASH_BLOCK_SIZE] ____cacheline_aligned;
 	int buflen_1;
-	u8 caam_ctx[MAX_CTX_LEN];
+	u8 caam_ctx[MAX_CTX_LEN] ____cacheline_aligned;
 	int (*update)(struct ahash_request *req);
 	int (*final)(struct ahash_request *req);
 	int (*finup)(struct ahash_request *req);
diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index 5095337..a1d21d5 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -108,6 +108,10 @@ static void rng_done(struct device *jrdev, u32 *desc, u32 err, void *context)
 
 	atomic_set(&bd->empty, BUF_NOT_EMPTY);
 	complete(&bd->filled);
+
+	/* Buffer refilled, invalidate cache */
+	dma_sync_single_for_cpu(jrdev, bd->addr, RN_BUF_SIZE, DMA_FROM_DEVICE);
+
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "rng refreshed buf@: ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, bd->buf, RN_BUF_SIZE, 1);
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index b8b5d47..b7ec1ad 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -202,6 +202,13 @@ static void caam_jr_dequeue(unsigned long devarg)
 		userdesc = jrp->entinfo[sw_idx].desc_addr_virt;
 		userstatus = jrp->outring[hw_idx].jrstatus;
 
+		/*
+		 * Make sure all information from the job has been obtained
+		 * before telling CAAM that the job has been removed from the
+		 * output ring.
+		 */
+		mb();
+
 		/* set done */
 		wr_reg32(&jrp->rregs->outring_rmvd, 1);
 
@@ -351,12 +358,23 @@ int caam_jr_enqueue(struct device *dev, u32 *desc,
 
 	jrp->inpring[jrp->inp_ring_write_index] = desc_dma;
 
+	/*
+	 * Guarantee that the descriptor's DMA address has been written to
+	 * the next slot in the ring before the write index is updated, since
+	 * other cores may update this index independently.
+	 */
 	smp_wmb();
 
 	jrp->inp_ring_write_index = (jrp->inp_ring_write_index + 1) &
 				    (JOBR_DEPTH - 1);
 	jrp->head = (head + 1) & (JOBR_DEPTH - 1);
 
+	/*
+	 * Ensure that all job information has been written before
+	 * notifying CAAM that a new job was added to the input ring.
+	 */
+	wmb();
+
 	wr_reg32(&jrp->rregs->inpring_jobadd, 1);
 
 	spin_unlock_bh(&jrp->inplock);
-- 
2.1.4
