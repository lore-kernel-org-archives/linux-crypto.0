From: Stefan Wahren <stefan.wahren@i2se.com>
Subject: [PATCH] hwrng: bcm2835: Handle deferred clock properly
Date: Mon, 12 Feb 2018 21:11:36 +0100
Message-ID: <1518466296-30161-1-git-send-email-stefan.wahren@i2se.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Anholt <eric@anholt.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Jon Mason <jonmason@broadcom.com>,
        linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-crypto@vger.kernel.org,
        Stefan Wahren <stefan.wahren@i2se.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Matt Mackall <mpm@selenic.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:56441 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751202AbeBLUMa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Feb 2018 15:12:30 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In case the probe of the clock is deferred, we would assume it is
optional. This is wrong, so defer the probe of this driver until
the clock is available.

Fixes: 791af4f4907a ("hwrng: bcm2835 - Manage an optional clock")
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
---
 drivers/char/hw_random/bcm2835-rng.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
index 7a84cec..6767d96 100644
--- a/drivers/char/hw_random/bcm2835-rng.c
+++ b/drivers/char/hw_random/bcm2835-rng.c
@@ -163,6 +163,8 @@ static int bcm2835_rng_probe(struct platform_device *pdev)
 
 	/* Clock is optional on most platforms */
 	priv->clk = devm_clk_get(dev, NULL);
+	if (IS_ERR(priv->clk) && PTR_ERR(priv->clk) == -EPROBE_DEFER)
+		return -EPROBE_DEFER;
 
 	priv->rng.name = pdev->name;
 	priv->rng.init = bcm2835_rng_init;
-- 
2.7.4
