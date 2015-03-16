From: Andre Wolokita <Andre.Wolokita@analog.com>
Subject: [PATCH] omap-rng: Change RNG_CONFIG_REG to RNG_CONTROL_REG in init
Date: Mon, 16 Mar 2015 12:54:50 +1100
Message-ID: <1426470890-26653-1-git-send-email-Andre.Wolokita@analog.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
	Andre Wolokita <Andre.Wolokita@analog.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0067.outbound.protection.outlook.com ([65.55.169.67]:19424
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751840AbbCPCKv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 15 Mar 2015 22:10:51 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

omap4_rng_init() checks bit 10 of the RNG_CONFIG_REG to determine whether
the RNG is already running before performing any initiliasation. This is not
the correct register to check, as the enable bit is in RNG_CONFIG_CONTROL.
Read from RNG_CONTROL_REG instead.

Signed-off-by: Andre Wolokita <Andre.Wolokita@analog.com>
---
 drivers/char/hw_random/omap-rng.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index d14dcf7..ff74e5d 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -236,7 +236,7 @@ static int omap4_rng_init(struct omap_rng_dev *priv)
 	u32 val;
 
 	/* Return if RNG is already running. */
-	if (omap_rng_read(priv, RNG_CONFIG_REG) & RNG_CONTROL_ENABLE_TRNG_MASK)
+	if (omap_rng_read(priv, RNG_CONTROL_REG) & RNG_CONTROL_ENABLE_TRNG_MASK)
 		return 0;
 
 	val = RNG_CONFIG_MIN_REFIL_CYCLES << RNG_CONFIG_MIN_REFIL_CYCLES_SHIFT;
-- 
1.7.9.5
