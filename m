From: Romain Perier <romain.perier@free-electrons.com>
Subject: [PATCH v3 02/10] crypto: marvell: Check engine is not already running when enabling a req
Date: Tue, 21 Jun 2016 10:08:32 +0200
Message-ID: <1466496520-28806-3-git-send-email-romain.perier@free-electrons.com>
References: <1466496520-28806-1-git-send-email-romain.perier@free-electrons.com>
Cc: Gregory Clement <gregory.clement@free-electrons.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	"David S. Miller" <davem@davemloft.net>,
	Russell King <linux@arm.linux.org.uk>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:50122 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753746AbcFUIJa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Jun 2016 04:09:30 -0400
In-Reply-To: <1466496520-28806-1-git-send-email-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add a BUG_ON() call when the driver tries to launch a crypto request
while the engine is still processing the previous one. This replaces
a silent system hang by a verbose kernel panic with the associated
backtrace to let the user know that something went wrong in the CESA
driver.

Signed-off-by: Romain Perier <romain.perier@free-electrons.com>
Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---

Changes in v3:
  - Fixed incorrectly aligned parameter for BUG_ON in
    mv_cesa_ablkcipher_std_step

Changes in v2:
  - Reworded the commit message
  - Fixed cosmetic changes


 drivers/crypto/marvell/cipher.c | 2 ++
 drivers/crypto/marvell/hash.c   | 2 ++
 drivers/crypto/marvell/tdma.c   | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/drivers/crypto/marvell/cipher.c b/drivers/crypto/marvell/cipher.c
index dcf1fce..8c1432e 100644
--- a/drivers/crypto/marvell/cipher.c
+++ b/drivers/crypto/marvell/cipher.c
@@ -106,6 +106,8 @@ static void mv_cesa_ablkcipher_std_step(struct ablkcipher_request *req)
 
 	mv_cesa_set_int_mask(engine, CESA_SA_INT_ACCEL0_DONE);
 	writel_relaxed(CESA_SA_CFG_PARA_DIS, engine->regs + CESA_SA_CFG);
+	BUG_ON(readl(engine->regs + CESA_SA_CMD) &
+	       CESA_SA_CMD_EN_CESA_SA_ACCL0);
 	writel(CESA_SA_CMD_EN_CESA_SA_ACCL0, engine->regs + CESA_SA_CMD);
 }
 
diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
index 7ca2e0f..80bddd7 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -237,6 +237,8 @@ static void mv_cesa_ahash_std_step(struct ahash_request *req)
 
 	mv_cesa_set_int_mask(engine, CESA_SA_INT_ACCEL0_DONE);
 	writel_relaxed(CESA_SA_CFG_PARA_DIS, engine->regs + CESA_SA_CFG);
+	BUG_ON(readl(engine->regs + CESA_SA_CMD) &
+	       CESA_SA_CMD_EN_CESA_SA_ACCL0);
 	writel(CESA_SA_CMD_EN_CESA_SA_ACCL0, engine->regs + CESA_SA_CMD);
 }
 
diff --git a/drivers/crypto/marvell/tdma.c b/drivers/crypto/marvell/tdma.c
index 7642798..8c86bb6 100644
--- a/drivers/crypto/marvell/tdma.c
+++ b/drivers/crypto/marvell/tdma.c
@@ -53,6 +53,8 @@ void mv_cesa_dma_step(struct mv_cesa_tdma_req *dreq)
 		       engine->regs + CESA_SA_CFG);
 	writel_relaxed(dreq->chain.first->cur_dma,
 		       engine->regs + CESA_TDMA_NEXT_ADDR);
+	BUG_ON(readl(engine->regs + CESA_SA_CMD) &
+	       CESA_SA_CMD_EN_CESA_SA_ACCL0);
 	writel(CESA_SA_CMD_EN_CESA_SA_ACCL0, engine->regs + CESA_SA_CMD);
 }
 
-- 
2.7.4
