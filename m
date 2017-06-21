From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH] crypto: ccp - Provide a roll-back method for debugfs setup
Date: Wed, 21 Jun 2017 17:39:14 -0500
Message-ID: <20170621223914.14697.61808.stgit@taos.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0068.outbound.protection.outlook.com ([104.47.34.68]:10606
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751963AbdFUWj0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Jun 2017 18:39:26 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-debugfs.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-debugfs.c b/drivers/crypto/ccp/ccp-debugfs.c
index 3cd6c83754e0..99aba1622613 100644
--- a/drivers/crypto/ccp/ccp-debugfs.c
+++ b/drivers/crypto/ccp/ccp-debugfs.c
@@ -291,6 +291,7 @@ void ccp5_debugfs_setup(struct ccp_device *ccp)
 	struct dentry *debugfs_q_instance;
 	struct dentry *debugfs_q_stats;
 	unsigned long flags;
+	int rc = 0;
 	int i;
 
 	if (!debugfs_initialized())
@@ -305,19 +306,19 @@ void ccp5_debugfs_setup(struct ccp_device *ccp)
 
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
@@ -327,15 +328,22 @@ void ccp5_debugfs_setup(struct ccp_device *ccp)
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
