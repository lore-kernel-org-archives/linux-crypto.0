From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH] crypto: ccp - Fix some line spacing
Date: Tue, 27 Jun 2017 08:58:04 -0500
Message-ID: <149857188462.26646.9081906171244927473.stgit@sosxen.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-cys01nam02on0060.outbound.protection.outlook.com ([104.47.37.60]:41696
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751492AbdF0N6M (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Jun 2017 09:58:12 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add/remove blank lines as appropriate.

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-dev.c |    1 +
 include/linux/ccp.h          |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index 2506b5025700..67cbb3e76888 100644
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -415,6 +415,7 @@ static void ccp_do_cmd_complete(unsigned long data)
 	struct ccp_cmd *cmd = tdata->cmd;
 
 	cmd->callback(cmd->data, cmd->ret);
+
 	complete(&tdata->completion);
 }
 
diff --git a/include/linux/ccp.h b/include/linux/ccp.h
index 3285c944194a..c03ee844a99d 100644
--- a/include/linux/ccp.h
+++ b/include/linux/ccp.h
@@ -20,7 +20,6 @@
 #include <crypto/aes.h>
 #include <crypto/sha.h>
 
-
 struct ccp_device;
 struct ccp_cmd;
 
