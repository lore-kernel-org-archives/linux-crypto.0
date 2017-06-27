From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH 2] crypto: ccp - Provide a roll-back method for debugfs setup
Date: Tue, 27 Jun 2017 08:57:31 -0500
Message-ID: <149857183214.26572.8412877312728402721.stgit@sosxen.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-cys01nam02on0082.outbound.protection.outlook.com ([104.47.37.82]:36963
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751475AbdF0N5k (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Jun 2017 09:57:40 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Changes since v1:
 - Remove unneeded local variable

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-debugfs.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-debugfs.c b/drivers/crypto/ccp/ccp-debugfs.c
index 3cd6c83754e0..88191c45ca7d 100644
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
@@ -327,15 +327,22 @@ void ccp5_debugfs_setup(struct ccp_device *ccp)
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
+	return;
+
+err:
+	write_lock_irqsave(&ccp_debugfs_lock, flags);
+	debugfs_remove_recursive(ccp_debugfs_dir);
+	ccp_debugfs_dir = NULL;
+	write_unlock_irqrestore(&ccp_debugfs_lock, flags);
 }
 
 void ccp5_debugfs_destroy(void)
