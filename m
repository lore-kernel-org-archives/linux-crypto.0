From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 5/6] crypto: marvell: fix missing cpu_to_le32() in
 mv_cesa_dma_add_op()
Date: Sun, 18 Oct 2015 18:31:20 +0100
Message-ID: <E1Znrnk-00064U-SZ@rmk-PC.arm.linux.org.uk>
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
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:45487 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087AbbJRRbb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Oct 2015 13:31:31 -0400
In-Reply-To: <20151018173039.GA9737@n2100.arm.linux.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When tdma->src is freed in mv_cesa_dma_cleanup(), we convert the DMA
address from a little-endian value prior to calling dma_pool_free().
However, mv_cesa_dma_add_op() assigns tdma->src without first converting
the DMA address to little endian.  Fix this.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/crypto/marvell/tdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/tdma.c b/drivers/crypto/marvell/tdma.c
index 2738e24bcc59..06bdeac27e3d 100644
--- a/drivers/crypto/marvell/tdma.c
+++ b/drivers/crypto/marvell/tdma.c
@@ -140,7 +140,7 @@ struct mv_cesa_op_ctx *mv_cesa_dma_add_op(struct mv_cesa_tdma_chain *chain,
 	tdma = chain->last;
 	tdma->op = op;
 	tdma->byte_cnt = (skip_ctx ? sizeof(op->desc) : sizeof(*op)) | BIT(31);
-	tdma->src = dma_handle;
+	tdma->src = cpu_to_le32(dma_handle);
 	tdma->flags = CESA_TDMA_DST_IN_SRAM | CESA_TDMA_OP;
 
 	return op;
-- 
2.1.0
