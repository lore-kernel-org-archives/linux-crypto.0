From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH] crypto: ccp - Release locks before returning
Date: Mon, 19 Jun 2017 12:31:17 -0500
Message-ID: <149789347689.1816.7826780806581292267.stgit@sosxen.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn3nam01on0088.outbound.protection.outlook.com ([104.47.33.88]:34103
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751081AbdFSRbW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jun 2017 13:31:22 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

krobot warning: make sure that all error return paths release locks.

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-debugfs.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-debugfs.c b/drivers/crypto/ccp/ccp-debugfs.c
index 6d86693b117f..3cd6c83754e0 100644
--- a/drivers/crypto/ccp/ccp-debugfs.c
+++ b/drivers/crypto/ccp/ccp-debugfs.c
@@ -297,12 +297,11 @@ void ccp5_debugfs_setup(struct ccp_device *ccp)
 		return;
 
 	write_lock_irqsave(&ccp_debugfs_lock, flags);
-	if (!ccp_debugfs_dir) {
+	if (!ccp_debugfs_dir)
 		ccp_debugfs_dir = debugfs_create_dir(KBUILD_MODNAME, NULL);
-		if (!ccp_debugfs_dir)
-			return;
-	}
 	write_unlock_irqrestore(&ccp_debugfs_lock, flags);
+	if (!ccp_debugfs_dir)
+		return;
 
 	ccp->debugfs_instance = debugfs_create_dir(ccp->name, ccp_debugfs_dir);
 	if (!ccp->debugfs_instance)
