From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: [PATCH] hw_random: timeriomem-rng: Remove 'max < 4' condition check
Date: Tue, 22 Aug 2017 21:52:24 +0530
Message-ID: <20170822162224.26801-1-prasannatsmkumar@gmail.com>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
To: herbert@gondor.apana.org.au, raltherr@google.com,
        linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:36835 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750962AbdHVQWt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Aug 2017 12:22:49 -0400
Received: by mail-pg0-f65.google.com with SMTP id y129so27752574pgy.3
        for <linux-crypto@vger.kernel.org>; Tue, 22 Aug 2017 09:22:49 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In read routiene max is always >= 4. The check whether 'max < 4' is not
necessary. Remove it.

Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
---
 drivers/char/hw_random/timeriomem-rng.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/char/hw_random/timeriomem-rng.c b/drivers/char/hw_random/timeriomem-rng.c
index 03ff548..f615684 100644
--- a/drivers/char/hw_random/timeriomem-rng.c
+++ b/drivers/char/hw_random/timeriomem-rng.c
@@ -53,13 +53,6 @@ static int timeriomem_rng_read(struct hwrng *hwrng, void *data,
 	int period_us = ktime_to_us(priv->period);
 
 	/*
-	 * The RNG provides 32-bits per read.  Ensure there is enough space for
-	 * at minimum one read.
-	 */
-	if (max < sizeof(u32))
-		return 0;
-
-	/*
 	 * There may not have been enough time for new data to be generated
 	 * since the last request.  If the caller doesn't want to wait, let them
 	 * bail out.  Otherwise, wait for the completion.  If the new data has
-- 
2.10.0
