From: Marek Vasut <marex@denx.de>
Subject: [PATCH] crypto: mxs-dcp: Align the bounce buffers
Date: Mon,  3 Mar 2014 01:23:15 +0100
Message-ID: <1393806195-6415-1-git-send-email-marex@denx.de>
Cc: linux-crypto@vger.kernel.org, Marek Vasut <marex@denx.de>,
	"David S. Miller" <davem@davemloft.net>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Shawn Guo <shawn.guo@linaro.org>,
	Tom Lendacky <thomas.lendacky@amd.com>
To: linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:34588 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbaCCAXY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 2 Mar 2014 19:23:24 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The DCP needs the bounce buffers, DMA descriptors and result buffers aligned
to 64 bytes (yet another hardware limitation). Make sure they are aligned by
properly aligning the structure which contains them during allocation.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/mxs-dcp.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index 08761d6..c7400fe 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -29,6 +29,8 @@
 #define DCP_MAX_CHANS	4
 #define DCP_BUF_SZ	PAGE_SIZE
 
+#define DCP_ALIGNMENT	64
+
 /* DCP DMA descriptor. */
 struct dcp_dma_desc {
 	uint32_t	next_cmd_addr;
@@ -947,12 +949,16 @@ static int mxs_dcp_probe(struct platform_device *pdev)
 	}
 
 	/* Allocate coherent helper block. */
-	sdcp->coh = devm_kzalloc(dev, sizeof(*sdcp->coh), GFP_KERNEL);
+	sdcp->coh = devm_kzalloc(dev, sizeof(*sdcp->coh) + DCP_ALIGNMENT,
+				   GFP_KERNEL);
 	if (!sdcp->coh) {
 		ret = -ENOMEM;
 		goto err_mutex;
 	}
 
+	/* Re-align the structure so it fits the DCP constraints. */
+	sdcp->coh = PTR_ALIGN(sdcp->coh, DCP_ALIGNMENT);
+
 	/* Restart the DCP block. */
 	ret = stmp_reset_block(sdcp->base);
 	if (ret)
-- 
1.8.5.2
