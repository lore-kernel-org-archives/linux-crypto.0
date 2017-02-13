From: Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH] hw_random: update help description for omap-rng
Date: Mon, 13 Feb 2017 12:04:08 +0000
Message-ID: <E1cdFMW-0004yZ-OB@rmk-PC.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: Matt Mackall <mpm@selenic.com>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Romain Perier <romain.perier@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45048 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752986AbdBMMER (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Feb 2017 07:04:17 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

omap-rng also supports Marvell Armada 7k/8k SoCs, but no mention of this
is made in the help text, despite the dependency being added. Explicitly
mention these SoCs in the help description so people know that it covers
more than just TI SoCs.

Fixes: 383212425c92 ("hwrng: omap - Add device variant for SafeXcel IP-76 found in Armada 8K")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/char/hw_random/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index ceff2fc524b1..0cafe08919c9 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -172,8 +172,8 @@ config HW_RANDOM_OMAP
 	default HW_RANDOM
  	---help---
  	  This driver provides kernel-side support for the Random Number
-	  Generator hardware found on OMAP16xx, OMAP2/3/4/5 and AM33xx/AM43xx
-	  multimedia processors.
+	  Generator hardware found on OMAP16xx, OMAP2/3/4/5, AM33xx/AM43xx
+	  multimedia processors, and Marvell Armada 7k/8k SoCs.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called omap-rng.
-- 
2.7.4
