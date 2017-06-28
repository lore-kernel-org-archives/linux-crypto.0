From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH v3] crypto: ccp - Provide an error path for debugfs setup
 failure
Date: Wed, 28 Jun 2017 11:56:47 -0500
Message-ID: <20170628165504.27611.6825.stgit@taos.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam02on0047.outbound.protection.outlook.com ([104.47.36.47]:55568
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751618AbdF1Q5D (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Jun 2017 12:57:03 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Changes since v2:
  - On failure remove only the DebugFS heirarchy for this device 
Changes since v1:
  - Remove unneeded local variable

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-debugfs.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-debugfs.c b/drivers/crypto/ccp/ccp-debugfs.c
index 3cd6c83754e0..59d4ca4e72d8 100644
--- a/drivers/crypto/ccp/ccp-debugfs.c
+++ b/drivers/crypto/ccp/ccp-debugfs.c
@@ -305,19 +305,19 @@ void ccp5_debugfs_setup(struct ccp_device *ccp)
 
 	ccp->debugfs_instance = debugfs_create_dir(ccp->name, ccp_debugfs_dir);
 	if (!ccp->debugfs_instance)
-		return;
+		goto err;
 
 	debugfs_info = debugfs_create_file("info", 0400,
 					   ccp->debugfs_instance, ccp,
 					   &ccp_debugfs_info_ops);
 	if (!debugfs_info)
-		return;
+		goto err;
 
 	debugfs_stats = debugfs_create_file("stats", 0600,
 					    ccp->debugfs_instance, ccp,
 					    &ccp_debugfs_stats_ops);
 	if (!debugfs_stats)
-		return;
+		goto err;
 
 	for (i = 0; i < ccp->cmd_q_count; i++) {
 		cmd_q = &ccp->cmd_q[i];
@@ -327,15 +327,20 @@ void ccp5_debugfs_setup(struct ccp_device *ccp)
 		debugfs_q_instance =
 			debugfs_create_dir(name, ccp->debugfs_instance);
 		if (!debugfs_q_instance)
-			return;
+			goto err;
 
 		debugfs_q_stats =
 			debugfs_create_file("stats", 0600,
 					    debugfs_q_instance, cmd_q,
 					    &ccp_debugfs_queue_ops);
 		if (!debugfs_q_stats)
-			return;
+			goto err;
 	}
+
+	return;
+
+err:
+	debugfs_remove_recursive(ccp->debugfs_instance);
 }
 
 void ccp5_debugfs_destroy(void)
