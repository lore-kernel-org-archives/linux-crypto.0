From: Cristian Stoica <cristian.stoica@freescale.com>
Subject: [PATCH] crypto: remove double execution of the same test suite
Date: Thu, 18 Jul 2013 18:57:07 +0300
Message-ID: <1374163027-17201-1-git-send-email-cristian.stoica@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <horia.geanta@freescale.com>,
	Cristian Stoica <cristian.stoica@freescale.com>
To: <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:54710
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754643Ab3GRQKx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Jul 2013 12:10:53 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch removes redundant execution of the same test suite in cases
where alg and driver variables are the same (e.g. when alg_test is
called from tcrypt_test)

Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
---
 crypto/testmgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 2f00607..e091ef6 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -3234,7 +3234,7 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 	if (i >= 0)
 		rc |= alg_test_descs[i].test(alg_test_descs + i, driver,
 					     type, mask);
-	if (j >= 0)
+	if (j >= 0 && j != i)
 		rc |= alg_test_descs[j].test(alg_test_descs + j, driver,
 					     type, mask);
 
-- 
1.8.1.5
