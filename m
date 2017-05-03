From: Pushkar Jambhlekar <pushkar.iit@gmail.com>
Subject: [PATCH] drivers/crypto/ccp: return NULL instead of 0
Date: Wed,  3 May 2017 09:32:09 +0530
Message-ID: <1493784129-32613-1-git-send-email-pushkar.iit@gmail.com>
Cc: linux-crypto@vger.kernel.org (open list:AMD CRYPTOGRAPHIC COPROCESSOR
        (CCP) DRIVER), linux-kernel@vger.kernel.org (open list),
        Pushkar Jambhlekar <pushkar.iit@gmail.com>
To: Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35243 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750737AbdECECT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 May 2017 00:02:19 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This change is to handle sparse warning. Return type of function is a pointer to the structure and
it returns 0. Instead it should return NULL.

Signed-off-by: Pushkar Jambhlekar <pushkar.iit@gmail.com>
---
 drivers/crypto/ccp/ccp-platform.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-platform.c b/drivers/crypto/ccp/ccp-platform.c
index 351f28d8..e26969e 100644
--- a/drivers/crypto/ccp/ccp-platform.c
+++ b/drivers/crypto/ccp/ccp-platform.c
@@ -44,7 +44,7 @@ static struct ccp_vdata *ccp_get_of_version(struct platform_device *pdev)
 	if (match && match->data)
 		return (struct ccp_vdata *)match->data;
 #endif
-	return 0;
+	return NULL;
 }
 
 static struct ccp_vdata *ccp_get_acpi_version(struct platform_device *pdev)
@@ -56,7 +56,7 @@ static struct ccp_vdata *ccp_get_acpi_version(struct platform_device *pdev)
 	if (match && match->driver_data)
 		return (struct ccp_vdata *)match->driver_data;
 #endif
-	return 0;
+	return NULL;
 }
 
 static int ccp_get_irq(struct ccp_device *ccp)
-- 
2.7.4
