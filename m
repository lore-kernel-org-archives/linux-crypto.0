From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v1 3/5] crypto: ccp - Use dma_set_mask_and_coherent to set
 DMA mask
Date: Tue, 3 Feb 2015 13:07:17 -0600
Message-ID: <20150203190717.15045.89640.stgit@tlendack-t1.amdoffice.net>
References: <20150203190659.15045.21329.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bn0109.outbound.protection.outlook.com ([157.56.110.109]:38731
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965959AbbBCTW6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Feb 2015 14:22:58 -0500
In-Reply-To: <20150203190659.15045.21329.stgit@tlendack-t1.amdoffice.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Replace the setting of the DMA masks with the dma_set_mask_and_coherent
function call.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-platform.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-platform.c b/drivers/crypto/ccp/ccp-platform.c
index 9e09c50..04265a3 100644
--- a/drivers/crypto/ccp/ccp-platform.c
+++ b/drivers/crypto/ccp/ccp-platform.c
@@ -109,8 +109,11 @@ static int ccp_platform_probe(struct platform_device *pdev)
 
 	if (!dev->dma_mask)
 		dev->dma_mask = &dev->coherent_dma_mask;
-	*(dev->dma_mask) = DMA_BIT_MASK(48);
-	dev->coherent_dma_mask = DMA_BIT_MASK(48);
+	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(48));
+	if (ret) {
+		dev_err(dev, "dma_set_mask_and_coherent failed (%d)\n", ret);
+		goto e_free;
+	}
 
 	if (of_property_read_bool(dev->of_node, "dma-coherent"))
 		ccp->axcache = CACHE_WB_NO_ALLOC;
