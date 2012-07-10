From: Qiang Liu <qiang.liu@freescale.com>
Subject: [PATCH 4/4] Talitos: fix the issue of dma memory leak
Date: Tue, 10 Jul 2012 14:00:14 +0800
Message-ID: <1341900014-20915-1-git-send-email-qiang.liu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <leoli@freescale.com>, <kim.phillips@freescale.com>,
	Qiang Liu <qiang.liu@freescale.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:8162
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752733Ab2GJGVU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Jul 2012 02:21:20 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

An error will be happened when test with mass data:
"DMA-API: device driver tries to sync DMA memory it has not allocated";
"DMA-API: debugging out of memory - disabling"
dma mapping memory of request->desc is not released by right device,
it should be private->dev but not dev;

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
---
 drivers/crypto/talitos.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 81f8497..a7da48c 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -264,7 +264,7 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
 			else
 				status = error;

-		dma_unmap_single(dev, request->dma_desc,
+		 dma_unmap_single(priv->dev, request->dma_desc,
 				 sizeof(struct talitos_desc),
 				 DMA_BIDIRECTIONAL);

--
1.7.5.1
