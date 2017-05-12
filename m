From: Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH] hwrng: do not warn when there are no devices
Date: Fri, 12 May 2017 00:17:34 -0400
Message-ID: <20170512041734.31945-1-vapier@gentoo.org>
Cc: linux-crypto@vger.kernel.org, Mike Frysinger <vapier@chromium.org>
To: mpm@selenic.com, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:50474 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755728AbdELERq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 May 2017 00:17:46 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Mike Frysinger <vapier@chromium.org>

If you build in hwrng & tpm-rng, but boot on a system that doesn't
have a tpm (like via KVM), hwrng will spam the logs every 10 seconds
with the line:
	hwrng: no data available

This isn't terribly useful, so squelch the error in the ENODEV case.
For all other errors, we still warn, and include the actual error.

Signed-off-by: Mike Frysinger <vapier@chromium.org>
---
 drivers/char/hw_random/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 503a41dfa193..da24bd5a9902 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -392,7 +392,8 @@ static int hwrng_fillfn(void *unused)
 		mutex_unlock(&reading_mutex);
 		put_rng(rng);
 		if (rc <= 0) {
-			pr_warn("hwrng: no data available\n");
+			if (rc != -ENODEV)
+				pr_warn("hwrng: no data available: %li\n", rc);
 			msleep_interruptible(10000);
 			continue;
 		}
-- 
2.12.0
