From: Romain Perier <romain.perier@free-electrons.com>
Subject: [PATCH 7/9] hwrng: omap - Don't prefix the probe message with OMAP
Date: Tue,  6 Sep 2016 17:38:55 +0200
Message-ID: <20160906153857.5503-8-romain.perier@free-electrons.com>
References: <20160906153857.5503-1-romain.perier@free-electrons.com>
Cc: Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Romain Perier <romain.perier@free-electrons.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Omri Itach <omrii@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>,
        Yahuda Yitschak <yehuday@marvell.com>,
        Hanna Hawa <hannah@marvell.com>,
        Neta Zur Hershkovits <neta@marvell.com>,
        Igal Liberman <igall@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>, linux-crypto@vger.kernel.org
To: dsaxena@plexity.net, mpm@selenic.com,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:59308 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933412AbcIFPkU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Sep 2016 11:40:20 -0400
In-Reply-To: <20160906153857.5503-1-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

So far, this driver was only used for OMAP SoCs. However, if a device
variant is added for an IP block that has nothing to do with the OMAP
platform, the message "OMAP Random Number Generator Ver" is displayed
anyway. Instead of hardcoding "OMAP" into this message, we decide to
only display "Random Number Generator". As dev_info is already
pre-pending the message with the name of the device, we have enough
informations.

Signed-off-by: Romain Perier <romain.perier@free-electrons.com>
---
 drivers/char/hw_random/omap-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index 6a3aaad..f1dcdb3 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -392,7 +392,7 @@ static int omap_rng_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_register;
 
-	dev_info(&pdev->dev, "OMAP Random Number Generator ver. %02x\n",
+	dev_info(&pdev->dev, "Random Number Generator ver. %02x\n",
 		 omap_rng_read(priv, RNG_REV_REG));
 
 	return 0;
-- 
2.9.3
