From: Keith Packard <keithp@keithp.com>
Subject: [PATCH] hwrng: core - allow perfect entropy from hardware devices
Date: Wed, 18 Mar 2015 00:17:00 -0700
Message-ID: <1426663020-10646-1-git-send-email-keithp@keithp.com>
Cc: Keith Packard <keithp@keithp.com>, linux-crypto@vger.kernel.org
To: Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from home.keithp.com ([63.227.221.253]:46936 "EHLO elaine.keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237AbbCRH0Z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Mar 2015 03:26:25 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hardware random number quality is measured from 0 (no entropy) to 1024
(perfect entropy). Allow hardware devices to assert the full range by
truncating the device-provided value at 1024 instead of 1023.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/char/hw_random/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 1500cfd..b726683 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -98,7 +98,8 @@ static inline int hwrng_init(struct hwrng *rng)
 	add_early_randomness(rng);
 
 	current_quality = rng->quality ? : default_quality;
-	current_quality &= 1023;
+	if (current_quality > 1024)
+		current_quality = 1024;
 
 	if (current_quality == 0 && hwrng_fill)
 		kthread_stop(hwrng_fill);
-- 
2.1.4
