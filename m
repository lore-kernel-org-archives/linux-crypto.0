From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v3 5/5] crypto: ccp - remove ccp_present() check from device initialize
Date: Thu, 29 Jun 2017 11:48:32 -0500
Message-ID: <20170629164832.13252-6-brijesh.singh@amd.com>
References: <20170629164832.13252-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: gary.hook@amd.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, Brijesh Singh <brijesh.singh@amd.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-cys01nam02on0066.outbound.protection.outlook.com ([104.47.37.66]:44199
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751690AbdF2Qs6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Jun 2017 12:48:58 -0400
In-Reply-To: <20170629164832.13252-1-brijesh.singh@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Since SP device driver supports multiples devices (e.g CCP, PSP), we
should not fail the driver init just because CCP device is not found.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 drivers/crypto/ccp/sp-dev.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/crypto/ccp/sp-dev.c b/drivers/crypto/ccp/sp-dev.c
index edbf1bd9..a017233 100644
--- a/drivers/crypto/ccp/sp-dev.c
+++ b/drivers/crypto/ccp/sp-dev.c
@@ -244,12 +244,6 @@ static int __init sp_mod_init(void)
 	if (ret)
 		return ret;
 
-	/* Don't leave the driver loaded if init failed */
-	if (ccp_present() != 0) {
-		sp_pci_exit();
-		return -ENODEV;
-	}
-
 	return 0;
 #endif
 
@@ -260,12 +254,6 @@ static int __init sp_mod_init(void)
 	if (ret)
 		return ret;
 
-	/* Don't leave the driver loaded if init failed */
-	if (ccp_present() != 0) {
-		sp_platform_exit();
-		return -ENODEV;
-	}
-
 	return 0;
 #endif
 
-- 
2.9.4
