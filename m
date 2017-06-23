From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH] crypto: inside-secure - do not parse the dma mask from dt
Date: Fri, 23 Jun 2017 16:05:25 +0200
Message-ID: <20170623140525.360-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, arnd@arndb.de,
        linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:46018 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754200AbdFWOGI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Jun 2017 10:06:08 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Remove the dma mask parsing from dt as this should not be encoded into
the engine device tree node. Keep the fallback value for now, which
should work for the boards already supported upstream.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---

Hi Herbert,

As pointed our by Arnd (ic Cc) parsing the dma mask from the dt node of
the engine is broken. This property will be removed from the device
trees having an inside-secure safexcel engine node. While the
inside-secure won't fail because of this (as it will fallback to a
64 bits mask), the code handling the dma-mask property is dead. This
patch removes it.

Thanks!
Antoine

 drivers/crypto/inside-secure/safexcel.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index e7f87ac12685..1fabd4aee81b 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -773,7 +773,6 @@ static int safexcel_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct resource *res;
 	struct safexcel_crypto_priv *priv;
-	u64 dma_mask;
 	int i, ret;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
@@ -802,9 +801,7 @@ static int safexcel_probe(struct platform_device *pdev)
 			return -EPROBE_DEFER;
 	}
 
-	if (of_property_read_u64(dev->of_node, "dma-mask", &dma_mask))
-		dma_mask = DMA_BIT_MASK(64);
-	ret = dma_set_mask_and_coherent(dev, dma_mask);
+	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
 	if (ret)
 		goto err_clk;
 
-- 
2.9.4
