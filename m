From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH] hwrng: Clean up RNG list when last hwrng is unregisterd
Date: Tue, 12 Dec 2017 16:19:38 -0600
Message-ID: <151311717859.2551.8429053600468961607.stgit@sosxen2.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: thomas.lendacky@amd.com, prasannatsmkumar@gmail.com,
        herbert@gondor.apana.org.au, davem@davemloft.net
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam02on0070.outbound.protection.outlook.com ([104.47.36.70]:55814
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752320AbdLLWTo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Dec 2017 17:19:44 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Commit 142a27f0a731 added support for a "best" RNG, and in doing so
introduced a hang from rmmod/modprobe -r when the last RNG on the list
was unloaded.

When the hwrng list is depleted, return the global variables to their
original state and decrement all references to the object.

Fixes: 142a27f0a731 ("hwrng: core - Reset user selected rng by writing "" to rng_current")
Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/char/hw_random/core.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 657b8770b6b9..91bb98c42a1c 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -306,6 +306,10 @@ static int enable_best_rng(void)
 		ret = ((new_rng == current_rng) ? 0 : set_current_rng(new_rng));
 		if (!ret)
 			cur_rng_set_by_user = 0;
+	} else {
+		drop_current_rng();
+		cur_rng_set_by_user = 0;
+		ret = 0;
 	}
 
 	return ret;
