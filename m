From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v1 1/3] crypto: ccp - Remove manual check and set of
 dma_mask pointer
Date: Tue, 26 May 2015 13:06:24 -0500
Message-ID: <20150526180623.6527.66942.stgit@tlendack-t1.amdoffice.net>
References: <20150526180612.6527.53332.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bbn0103.outbound.protection.outlook.com ([157.56.111.103]:50329
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750845AbbEZSVz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 May 2015 14:21:55 -0400
In-Reply-To: <20150526180612.6527.53332.stgit@tlendack-t1.amdoffice.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The underlying device support will set the device dma_mask pointer
if DMA is set up properly for the device.  Remove the check for and
assignment of dma_mask when it is null. Instead, just error out if
the dma_set_mask_and_coherent function fails because dma_mask is null.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-platform.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-platform.c b/drivers/crypto/ccp/ccp-platform.c
index b1c20b2..c0aa5c5 100644
--- a/drivers/crypto/ccp/ccp-platform.c
+++ b/drivers/crypto/ccp/ccp-platform.c
@@ -174,8 +174,6 @@ static int ccp_platform_probe(struct platform_device *pdev)
 	}
 	ccp->io_regs = ccp->io_map;
 
-	if (!dev->dma_mask)
-		dev->dma_mask = &dev->coherent_dma_mask;
 	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(48));
 	if (ret) {
 		dev_err(dev, "dma_set_mask_and_coherent failed (%d)\n", ret);
