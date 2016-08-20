From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: [PATCH] hw_random: omap3-rom-rng.c: Remove obsoleted functions
Date: Sat, 20 Aug 2016 21:31:06 +0530
Message-ID: <1471708866-1423-1-git-send-email-prasannatsmkumar@gmail.com>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
To: linux-crypto@vger.kernel.org, aaro.koskinen@iki.fi,
        mpm@selenic.com, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:33961 "EHLO
        mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753142AbcHTQEF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 20 Aug 2016 12:04:05 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Remove omap3_rom_rng_data_present method as it was returning 1 always.
Use .read callback instead of .data_read callback. This avoids use of
obsolete callbacks.

This patch is not tested with hardware as I don't have access to it.

Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
---
 drivers/char/hw_random/omap3-rom-rng.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/char/hw_random/omap3-rom-rng.c b/drivers/char/hw_random/omap3-rom-rng.c
index 8da14f1..37a58d7 100644
--- a/drivers/char/hw_random/omap3-rom-rng.c
+++ b/drivers/char/hw_random/omap3-rom-rng.c
@@ -71,12 +71,7 @@ static int omap3_rom_rng_get_random(void *buf, unsigned int count)
 	return 0;
 }
 
-static int omap3_rom_rng_data_present(struct hwrng *rng, int wait)
-{
-	return 1;
-}
-
-static int omap3_rom_rng_data_read(struct hwrng *rng, u32 *data)
+static int omap3_rom_rng_read(struct hwrng *rng, void *data, size_t max, bool w)
 {
 	int r;
 
@@ -88,8 +83,7 @@ static int omap3_rom_rng_data_read(struct hwrng *rng, u32 *data)
 
 static struct hwrng omap3_rom_rng_ops = {
 	.name		= "omap3-rom",
-	.data_present	= omap3_rom_rng_data_present,
-	.data_read	= omap3_rom_rng_data_read,
+	.read		= omap3_rom_rng_read,
 };
 
 static int omap3_rom_rng_probe(struct platform_device *pdev)
-- 
2.5.0
