From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v4 5/5] crypto: ccp - remove ccp_present() check from device initialize
Date: Thu,  6 Jul 2017 09:59:17 -0500
Message-ID: <20170706145917.98876-6-brijesh.singh@amd.com>
References: <20170706145917.98876-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: gary.hook@amd.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, thomas.lendacky@amd.com,
        Brijesh Singh <brijesh.singh@amd.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam01on0058.outbound.protection.outlook.com ([104.47.32.58]:2496
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751871AbdGFO7r (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Jul 2017 10:59:47 -0400
In-Reply-To: <20170706145917.98876-1-brijesh.singh@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Since SP device driver supports multiples devices (e.g CCP, PSP), we
should not fail the driver init just because CCP device is not found.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Acked-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/sp-dev.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/crypto/ccp/sp-dev.c b/drivers/crypto/ccp/sp-dev.c
index 1e5ffad..bef387c8 100644
--- a/drivers/crypto/ccp/sp-dev.c
+++ b/drivers/crypto/ccp/sp-dev.c
@@ -246,12 +246,6 @@ static int __init sp_mod_init(void)
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
 
@@ -262,12 +256,6 @@ static int __init sp_mod_init(void)
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
