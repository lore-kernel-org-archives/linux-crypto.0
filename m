From: Romain Perier <romain.perier@free-electrons.com>
Subject: [PATCH v2 03/10] crypto: marvell: Fix wrong type check in dma functions
Date: Fri, 17 Jun 2016 13:24:02 +0200
Message-ID: <1466162649-29911-4-git-send-email-romain.perier@free-electrons.com>
References: <1466162649-29911-1-git-send-email-romain.perier@free-electrons.com>
Cc: Gregory Clement <gregory.clement@free-electrons.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	"David S. Miller" <davem@davemloft.net>,
	Russell King <linux@arm.linux.org.uk>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:47975 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753128AbcFQLYe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Jun 2016 07:24:34 -0400
In-Reply-To: <1466162649-29911-1-git-send-email-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

So far, the way that the type of a TDMA operation was checked was wrong.
We have to use the type mask in order to get the right part of the flag
containing the type of the operation.

Signed-off-by: Romain Perier <romain.perier@free-electrons.com>
---
 drivers/crypto/marvell/tdma.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/marvell/tdma.c b/drivers/crypto/marvell/tdma.c
index 8c86bb6..de8c253 100644
--- a/drivers/crypto/marvell/tdma.c
+++ b/drivers/crypto/marvell/tdma.c
@@ -64,8 +64,9 @@ void mv_cesa_dma_cleanup(struct mv_cesa_tdma_req *dreq)
 
 	for (tdma = dreq->chain.first; tdma;) {
 		struct mv_cesa_tdma_desc *old_tdma = tdma;
+		u32 type = tdma->flags & CESA_TDMA_TYPE_MSK;
 
-		if (tdma->flags & CESA_TDMA_OP)
+		if (type == CESA_TDMA_OP)
 			dma_pool_free(cesa_dev->dma->op_pool, tdma->op,
 				      le32_to_cpu(tdma->src));
 
@@ -90,7 +91,7 @@ void mv_cesa_dma_prepare(struct mv_cesa_tdma_req *dreq,
 		if (tdma->flags & CESA_TDMA_SRC_IN_SRAM)
 			tdma->src = cpu_to_le32(tdma->src + engine->sram_dma);
 
-		if (tdma->flags & CESA_TDMA_OP)
+		if ((tdma->flags & CESA_TDMA_TYPE_MSK) == CESA_TDMA_OP)
 			mv_cesa_adjust_op(engine, tdma->op);
 	}
 }
-- 
2.7.4
