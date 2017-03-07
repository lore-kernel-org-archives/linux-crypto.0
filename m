From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: [PATCH 1/4] hwrng: omap - write registers after enabling the clock
Date: Tue,  7 Mar 2017 15:14:46 +0100
Message-ID: <1488896089-17586-2-git-send-email-thomas.petazzoni@free-electrons.com>
References: <1488896089-17586-1-git-send-email-thomas.petazzoni@free-electrons.com>
Cc: linux-crypto@vger.kernel.org, romain.perier@collabora.com,
        Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Hanna Hawa <hannah@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        stable@vger.kernel.org
To: Deepak Saxena <dsaxena@plexity.net>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:58562 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751270AbdCGORa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Mar 2017 09:17:30 -0500
In-Reply-To: <1488896089-17586-1-git-send-email-thomas.petazzoni@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Commit 383212425c926 ("hwrng: omap - Add device variant for SafeXcel
IP-76 found in Armada 8K") added support for the SafeXcel IP-76 variant
of the IP. This modification included getting a reference and enabling a
clock. Unfortunately, this was done *after* writing to the
RNG_INTMASK_REG register. This generally works fine when the driver is
built-in because the clock might have been left enabled by the
bootloader, but fails short when the driver is built as a module: it
causes a system hang because a register is being accessed while the
clock is not enabled.

This commit fixes that by making the register access *after* enabling
the clock.

This issue was found by the kernelci.org testing effort.

Fixes: 383212425c926 ("hwrng: omap - Add device variant for SafeXcel IP-76 found in Armada 8K")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 drivers/char/hw_random/omap-rng.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index 3ad86fd..efa3747 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -397,7 +397,6 @@ static int of_get_omap_rng_device_details(struct omap_rng_dev *priv,
 				irq, err);
 			return err;
 		}
-		omap_rng_write(priv, RNG_INTMASK_REG, RNG_SHUTDOWN_OFLO_MASK);
 
 		priv->clk = of_clk_get(pdev->dev.of_node, 0);
 		if (IS_ERR(priv->clk) && PTR_ERR(priv->clk) == -EPROBE_DEFER)
@@ -408,6 +407,8 @@ static int of_get_omap_rng_device_details(struct omap_rng_dev *priv,
 				dev_err(&pdev->dev, "unable to enable the clk, "
 						    "err = %d\n", err);
 		}
+
+		omap_rng_write(priv, RNG_INTMASK_REG, RNG_SHUTDOWN_OFLO_MASK);
 	}
 	return 0;
 }
-- 
2.7.4
