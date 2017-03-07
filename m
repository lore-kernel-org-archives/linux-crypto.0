From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: [PATCH 3/4] hwrng: omap - Do not access INTMASK_REG on EIP76
Date: Tue,  7 Mar 2017 15:14:48 +0100
Message-ID: <1488896089-17586-4-git-send-email-thomas.petazzoni@free-electrons.com>
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
Received: from mail.free-electrons.com ([62.4.15.54]:58586 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754946AbdCGORb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Mar 2017 09:17:31 -0500
In-Reply-To: <1488896089-17586-1-git-send-email-thomas.petazzoni@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The INTMASK_REG register does not exist on EIP76. Due to this, the call:

   omap_rng_write(priv, RNG_INTMASK_REG, RNG_SHUTDOWN_OFLO_MASK);

ends up, through the reg_map_eip76[] array, in accessing the register at
offset 0, which is the RNG_OUTPUT_0_REG. This by itself doesn't cause
any problem, but clearly doesn't enable the interrupt as it was
expected.

On EIP76, the register that allows to enable the interrupt is
RNG_CONTROL_REG. And just like RNG_INTMASK_REG, it's bit 1 of this
register that allows to enable the shutdown_oflo interrupt.

Fixes: 383212425c926 ("hwrng: omap - Add device variant for SafeXcel IP-76 found in Armada 8K")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 drivers/char/hw_random/omap-rng.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index d286628..b1ad125 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -408,7 +408,18 @@ static int of_get_omap_rng_device_details(struct omap_rng_dev *priv,
 						    "err = %d\n", err);
 		}
 
-		omap_rng_write(priv, RNG_INTMASK_REG, RNG_SHUTDOWN_OFLO_MASK);
+		/*
+		 * On OMAP4, enabling the shutdown_oflo interrupt is
+		 * done in the interrupt mask register. There is no
+		 * such register on EIP76, and it's enabled by the
+		 * same bit in the control register
+		 */
+		if (priv->pdata->regs[RNG_INTMASK_REG])
+			omap_rng_write(priv, RNG_INTMASK_REG,
+				       RNG_SHUTDOWN_OFLO_MASK);
+		else
+			omap_rng_write(priv, RNG_CONTROL_REG,
+				       RNG_SHUTDOWN_OFLO_MASK);
 	}
 	return 0;
 }
-- 
2.7.4
