From: Romain Perier <romain.perier@free-electrons.com>
Subject: [PATCH 2/7] crypto: marvell: Check engine is not already running when enabling a req
Date: Wed, 15 Jun 2016 21:15:29 +0200
Message-ID: <1466018134-10779-3-git-send-email-romain.perier@free-electrons.com>
References: <1466018134-10779-1-git-send-email-romain.perier@free-electrons.com>
Cc: Gregory Clement <gregory.clement@free-electrons.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	"David S. Miller" <davem@davemloft.net>,
	Russell King <linux@arm.linux.org.uk>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:52759 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932655AbcFOTQl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jun 2016 15:16:41 -0400
In-Reply-To: <1466018134-10779-1-git-send-email-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Adding BUG_ON() macro to be sure that the step operation is not about
to activate a request on the engine if the corresponding engine is
already processing a crypto request. This is helpful when the support
for chaining crypto requests will be added. Instead of hanging the
system when the engine is in an incoherent state, we add this macro
which throws an understandable error.

Signed-off-by: Romain Perier <romain.perier@free-electrons.com>
---
 drivers/crypto/marvell/cipher.c | 2 ++
 drivers/crypto/marvell/hash.c   | 2 ++
 drivers/crypto/marvell/tdma.c   | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/drivers/crypto/marvell/cipher.c b/drivers/crypto/marvell/cipher.c
index dcf1fce..8d0fabb 100644
--- a/drivers/crypto/marvell/cipher.c
+++ b/drivers/crypto/marvell/cipher.c
@@ -106,6 +106,8 @@ static void mv_cesa_ablkcipher_std_step(struct ablkcipher_request *req)
 
 	mv_cesa_set_int_mask(engine, CESA_SA_INT_ACCEL0_DONE);
 	writel_relaxed(CESA_SA_CFG_PARA_DIS, engine->regs + CESA_SA_CFG);
+	BUG_ON(readl(engine->regs + CESA_SA_CMD)
+				  & CESA_SA_CMD_EN_CESA_SA_ACCL0);
 	writel(CESA_SA_CMD_EN_CESA_SA_ACCL0, engine->regs + CESA_SA_CMD);
 }
 
diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
index 7ca2e0f..0fae351 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -237,6 +237,8 @@ static void mv_cesa_ahash_std_step(struct ahash_request *req)
 
 	mv_cesa_set_int_mask(engine, CESA_SA_INT_ACCEL0_DONE);
 	writel_relaxed(CESA_SA_CFG_PARA_DIS, engine->regs + CESA_SA_CFG);
+	BUG_ON(readl(engine->regs + CESA_SA_CMD)
+				  & CESA_SA_CMD_EN_CESA_SA_ACCL0);
 	writel(CESA_SA_CMD_EN_CESA_SA_ACCL0, engine->regs + CESA_SA_CMD);
 }
 
diff --git a/drivers/crypto/marvell/tdma.c b/drivers/crypto/marvell/tdma.c
index 7642798..d493714 100644
--- a/drivers/crypto/marvell/tdma.c
+++ b/drivers/crypto/marvell/tdma.c
@@ -53,6 +53,8 @@ void mv_cesa_dma_step(struct mv_cesa_tdma_req *dreq)
 		       engine->regs + CESA_SA_CFG);
 	writel_relaxed(dreq->chain.first->cur_dma,
 		       engine->regs + CESA_TDMA_NEXT_ADDR);
+	BUG_ON(readl(engine->regs + CESA_SA_CMD)
+				  & CESA_SA_CMD_EN_CESA_SA_ACCL0);
 	writel(CESA_SA_CMD_EN_CESA_SA_ACCL0, engine->regs + CESA_SA_CMD);
 }
 
-- 
2.7.4
