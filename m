From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 1/6] crypto: marvell: use readl_relaxed()/writel_relaxed()
Date: Sun, 18 Oct 2015 18:31:00 +0100
Message-ID: <E1ZnrnQ-000641-A3@rmk-PC.arm.linux.org.uk>
References: <20151018173039.GA9737@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:45455 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087AbbJRRbJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Oct 2015 13:31:09 -0400
In-Reply-To: <20151018173039.GA9737@n2100.arm.linux.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use relaxed IO accessors where appropriate.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/crypto/marvell/cesa.h   |  2 +-
 drivers/crypto/marvell/cipher.c |  2 +-
 drivers/crypto/marvell/hash.c   |  7 +++----
 drivers/crypto/marvell/tdma.c   | 20 ++++++++++----------
 4 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/marvell/cesa.h b/drivers/crypto/marvell/cesa.h
index e9f732138ba3..e19877402ec9 100644
--- a/drivers/crypto/marvell/cesa.h
+++ b/drivers/crypto/marvell/cesa.h
@@ -677,7 +677,7 @@ static inline void mv_cesa_set_int_mask(struct mv_cesa_engine *engine,
 	if (int_mask == engine->int_mask)
 		return;
 
-	writel(int_mask, engine->regs + CESA_SA_INT_MSK);
+	writel_relaxed(int_mask, engine->regs + CESA_SA_INT_MSK);
 	engine->int_mask = int_mask;
 }
 
diff --git a/drivers/crypto/marvell/cipher.c b/drivers/crypto/marvell/cipher.c
index 3df2f4e7adb2..4db2d632204f 100644
--- a/drivers/crypto/marvell/cipher.c
+++ b/drivers/crypto/marvell/cipher.c
@@ -105,7 +105,7 @@ static void mv_cesa_ablkcipher_std_step(struct ablkcipher_request *req)
 	}
 
 	mv_cesa_set_int_mask(engine, CESA_SA_INT_ACCEL0_DONE);
-	writel(CESA_SA_CFG_PARA_DIS, engine->regs + CESA_SA_CFG);
+	writel_relaxed(CESA_SA_CFG_PARA_DIS, engine->regs + CESA_SA_CFG);
 	writel(CESA_SA_CMD_EN_CESA_SA_ACCL0, engine->regs + CESA_SA_CMD);
 }
 
diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
index 7cd0f0decf6c..84ddc4cbfa9d 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -281,7 +281,7 @@ static void mv_cesa_ahash_std_step(struct ahash_request *req)
 	creq->cache_ptr = new_cache_ptr;
 
 	mv_cesa_set_int_mask(engine, CESA_SA_INT_ACCEL0_DONE);
-	writel(CESA_SA_CFG_PARA_DIS, engine->regs + CESA_SA_CFG);
+	writel_relaxed(CESA_SA_CFG_PARA_DIS, engine->regs + CESA_SA_CFG);
 	writel(CESA_SA_CMD_EN_CESA_SA_ACCL0, engine->regs + CESA_SA_CMD);
 }
 
@@ -344,7 +344,7 @@ static int mv_cesa_ahash_process(struct crypto_async_request *req, u32 status)
 
 	digsize = crypto_ahash_digestsize(crypto_ahash_reqtfm(ahashreq));
 	for (i = 0; i < digsize / 4; i++)
-		creq->state[i] = readl(engine->regs + CESA_IVDIG(i));
+		creq->state[i] = readl_relaxed(engine->regs + CESA_IVDIG(i));
 
 	if (creq->cache_ptr)
 		sg_pcopy_to_buffer(ahashreq->src, creq->src_nents,
@@ -390,8 +390,7 @@ static void mv_cesa_ahash_prepare(struct crypto_async_request *req,
 
 	digsize = crypto_ahash_digestsize(crypto_ahash_reqtfm(ahashreq));
 	for (i = 0; i < digsize / 4; i++)
-		writel(creq->state[i],
-		       engine->regs + CESA_IVDIG(i));
+		writel_relaxed(creq->state[i], engine->regs + CESA_IVDIG(i));
 }
 
 static void mv_cesa_ahash_req_cleanup(struct crypto_async_request *req)
diff --git a/drivers/crypto/marvell/tdma.c b/drivers/crypto/marvell/tdma.c
index 64a366c50174..e8e8a7f7659b 100644
--- a/drivers/crypto/marvell/tdma.c
+++ b/drivers/crypto/marvell/tdma.c
@@ -41,18 +41,18 @@ void mv_cesa_dma_step(struct mv_cesa_tdma_req *dreq)
 {
 	struct mv_cesa_engine *engine = dreq->base.engine;
 
-	writel(0, engine->regs + CESA_SA_CFG);
+	writel_relaxed(0, engine->regs + CESA_SA_CFG);
 
 	mv_cesa_set_int_mask(engine, CESA_SA_INT_ACC0_IDMA_DONE);
-	writel(CESA_TDMA_DST_BURST_128B | CESA_TDMA_SRC_BURST_128B |
-	       CESA_TDMA_NO_BYTE_SWAP | CESA_TDMA_EN,
-	       engine->regs + CESA_TDMA_CONTROL);
-
-	writel(CESA_SA_CFG_ACT_CH0_IDMA | CESA_SA_CFG_MULTI_PKT |
-	       CESA_SA_CFG_CH0_W_IDMA | CESA_SA_CFG_PARA_DIS,
-	       engine->regs + CESA_SA_CFG);
-	writel(dreq->chain.first->cur_dma,
-	       engine->regs + CESA_TDMA_NEXT_ADDR);
+	writel_relaxed(CESA_TDMA_DST_BURST_128B | CESA_TDMA_SRC_BURST_128B |
+		       CESA_TDMA_NO_BYTE_SWAP | CESA_TDMA_EN,
+		       engine->regs + CESA_TDMA_CONTROL);
+
+	writel_relaxed(CESA_SA_CFG_ACT_CH0_IDMA | CESA_SA_CFG_MULTI_PKT |
+		       CESA_SA_CFG_CH0_W_IDMA | CESA_SA_CFG_PARA_DIS,
+		       engine->regs + CESA_SA_CFG);
+	writel_relaxed(dreq->chain.first->cur_dma,
+		       engine->regs + CESA_TDMA_NEXT_ADDR);
 	writel(CESA_SA_CMD_EN_CESA_SA_ACCL0, engine->regs + CESA_SA_CMD);
 }
 
-- 
2.1.0
