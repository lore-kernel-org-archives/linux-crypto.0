From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 2/6] crypto: marvell: use dma_addr_t for cur_dma
Date: Sun, 18 Oct 2015 18:31:05 +0100
Message-ID: <E1ZnrnV-00064B-EH@rmk-PC.arm.linux.org.uk>
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
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:45466 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087AbbJRRbQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Oct 2015 13:31:16 -0400
In-Reply-To: <20151018173039.GA9737@n2100.arm.linux.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

cur_dma is part of the software state, not read by the hardware.
Storing it in LE32 format is wrong, use dma_addr_t for this.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/crypto/marvell/cesa.h | 4 +++-
 drivers/crypto/marvell/tdma.c | 6 +++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/marvell/cesa.h b/drivers/crypto/marvell/cesa.h
index e19877402ec9..dbe4970d6c64 100644
--- a/drivers/crypto/marvell/cesa.h
+++ b/drivers/crypto/marvell/cesa.h
@@ -297,7 +297,9 @@ struct mv_cesa_tdma_desc {
 	u32 src;
 	u32 dst;
 	u32 next_dma;
-	u32 cur_dma;
+
+	/* Software state */
+	dma_addr_t cur_dma;
 	struct mv_cesa_tdma_desc *next;
 	union {
 		struct mv_cesa_op_ctx *op;
diff --git a/drivers/crypto/marvell/tdma.c b/drivers/crypto/marvell/tdma.c
index e8e8a7f7659b..c8256f5916b0 100644
--- a/drivers/crypto/marvell/tdma.c
+++ b/drivers/crypto/marvell/tdma.c
@@ -69,7 +69,7 @@ void mv_cesa_dma_cleanup(struct mv_cesa_tdma_req *dreq)
 
 		tdma = tdma->next;
 		dma_pool_free(cesa_dev->dma->tdma_desc_pool, old_tdma,
-			      le32_to_cpu(old_tdma->cur_dma));
+			      old_tdma->cur_dma);
 	}
 
 	dreq->chain.first = NULL;
@@ -105,9 +105,9 @@ mv_cesa_dma_add_desc(struct mv_cesa_tdma_chain *chain, gfp_t flags)
 		return ERR_PTR(-ENOMEM);
 
 	memset(new_tdma, 0, sizeof(*new_tdma));
-	new_tdma->cur_dma = cpu_to_le32(dma_handle);
+	new_tdma->cur_dma = dma_handle;
 	if (chain->last) {
-		chain->last->next_dma = new_tdma->cur_dma;
+		chain->last->next_dma = cpu_to_le32(dma_handle);
 		chain->last->next = new_tdma;
 	} else {
 		chain->first = new_tdma;
-- 
2.1.0
