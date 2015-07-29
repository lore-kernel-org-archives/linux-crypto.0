From: Dan Streetman <ddstreet@ieee.org>
Subject: [PATCH] crypto: nx - use be32_to_cpu for __be32 field in debug msg
Date: Wed, 29 Jul 2015 19:43:29 -0400
Message-ID: <1438213409-6968-1-git-send-email-ddstreet@ieee.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dan Streetman <ddstreet@ieee.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:36329 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173AbbG2Xnm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jul 2015 19:43:42 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

One of the debug messages in the NX 842 PowerNV driver is missing
the required be32_to_cpu() wrapper when accessing the __be32 field
csb->count.  Add the wrapper so the message will show the correct count.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
---
 drivers/crypto/nx/nx-842-powernv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/nx/nx-842-powernv.c b/drivers/crypto/nx/nx-842-powernv.c
index 684ce51..3750e13 100644
--- a/drivers/crypto/nx/nx-842-powernv.c
+++ b/drivers/crypto/nx/nx-842-powernv.c
@@ -346,7 +346,8 @@ static int wait_for_csb(struct nx842_workmem *wmem,
 	}
 
 	/* successful completion */
-	pr_debug_ratelimited("Processed %u bytes in %lu us\n", csb->count,
+	pr_debug_ratelimited("Processed %u bytes in %lu us\n",
+			     be32_to_cpu(csb->count),
 			     (unsigned long)ktime_us_delta(now, start));
 
 	return 0;
-- 
2.1.0
