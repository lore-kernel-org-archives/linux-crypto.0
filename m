From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH] crypto: ccp: remove duplicate module version and author entry
Date: Wed, 19 Jul 2017 22:29:08 -0500
Message-ID: <20170720032908.48902-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary R Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-dm3nam03on0083.outbound.protection.outlook.com ([104.47.41.83]:62848
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932172AbdGTD3i (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Jul 2017 23:29:38 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

commit 720419f01832 ("crypto: ccp - Introduce the AMD Secure Processor device")
moved the module registeration from ccp-dev.c to sp-dev.c but patch missed
removing the module version and author entry from ccp-dev.c.

It causes the below warning during boot when CONFIG_CRYPTO_DEV_SP_CCP=y
and CONFIG_CRYPTO_DEV_CCP_CRYPTO=y is set.

[ 0.187825] sysfs: cannot create duplicate filename '/module/ccp/version'
[ 0.187825] sysfs: cannot create duplicate filename '/module/ccp/version'

Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Gary R Hook <gary.hook@amd.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 drivers/crypto/ccp/ccp-dev.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index b2d1761..b8695e7 100644
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -11,7 +11,6 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/kthread.h>
 #include <linux/sched.h>
@@ -30,12 +29,6 @@
 
 #include "ccp-dev.h"
 
-MODULE_AUTHOR("Tom Lendacky <thomas.lendacky@amd.com>");
-MODULE_AUTHOR("Gary R Hook <gary.hook@amd.com>");
-MODULE_LICENSE("GPL");
-MODULE_VERSION("1.1.0");
-MODULE_DESCRIPTION("AMD Cryptographic Coprocessor driver");
-
 struct ccp_tasklet_data {
 	struct completion completion;
 	struct ccp_cmd *cmd;
-- 
2.9.4
