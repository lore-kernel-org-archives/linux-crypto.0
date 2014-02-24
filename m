From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 3/3] crypto: ccp - Account for CCP backlog processing
Date: Mon, 24 Feb 2014 08:42:14 -0600
Message-ID: <20140224144214.16181.69265.stgit@tlendack-t1.amdoffice.net>
References: <20140224144156.16181.81272.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-kernel@vger.kernel.org>
To: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:49148
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752687AbaBXOmW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Feb 2014 09:42:22 -0500
In-Reply-To: <20140224144156.16181.81272.stgit@tlendack-t1.amdoffice.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When the crypto layer is able to queue up a command for processing
by the CCP on the initial call to ccp_crypto_enqueue_request and
the CCP returns -EBUSY, then if the backlog flag is not set the
command needs to be freed and not added to the active command list.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-main.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-main.c b/drivers/crypto/ccp/ccp-crypto-main.c
index 7d98635..20dc848 100644
--- a/drivers/crypto/ccp/ccp-crypto-main.c
+++ b/drivers/crypto/ccp/ccp-crypto-main.c
@@ -205,6 +205,7 @@ static int ccp_crypto_enqueue_cmd(struct ccp_crypto_cmd *crypto_cmd)
 {
 	struct ccp_crypto_cmd *active = NULL, *tmp;
 	unsigned long flags;
+	bool free_cmd = true;
 	int ret;
 
 	spin_lock_irqsave(&req_queue_lock, flags);
@@ -231,7 +232,10 @@ static int ccp_crypto_enqueue_cmd(struct ccp_crypto_cmd *crypto_cmd)
 	if (!active) {
 		ret = ccp_enqueue_cmd(crypto_cmd->cmd);
 		if (!ccp_crypto_success(ret))
-			goto e_lock;
+			goto e_lock;	/* Error, don't queue it */
+		if ((ret == -EBUSY) &&
+		    !(crypto_cmd->cmd->flags & CCP_CMD_MAY_BACKLOG))
+			goto e_lock;	/* Not backlogging, don't queue it */
 	}
 
 	if (req_queue.cmd_count >= CCP_CRYPTO_MAX_QLEN) {
@@ -244,9 +248,14 @@ static int ccp_crypto_enqueue_cmd(struct ccp_crypto_cmd *crypto_cmd)
 	req_queue.cmd_count++;
 	list_add_tail(&crypto_cmd->entry, &req_queue.cmds);
 
+	free_cmd = false;
+
 e_lock:
 	spin_unlock_irqrestore(&req_queue_lock, flags);
 
+	if (free_cmd)
+		kfree(crypto_cmd);
+
 	return ret;
 }
 
@@ -262,7 +271,6 @@ int ccp_crypto_enqueue_request(struct crypto_async_request *req,
 {
 	struct ccp_crypto_cmd *crypto_cmd;
 	gfp_t gfp;
-	int ret;
 
 	gfp = req->flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL : GFP_ATOMIC;
 
@@ -287,11 +295,7 @@ int ccp_crypto_enqueue_request(struct crypto_async_request *req,
 	else
 		cmd->flags &= ~CCP_CMD_MAY_BACKLOG;
 
-	ret = ccp_crypto_enqueue_cmd(crypto_cmd);
-	if (!ccp_crypto_success(ret))
-		kfree(crypto_cmd);
-
-	return ret;
+	return ccp_crypto_enqueue_cmd(crypto_cmd);
 }
 
 struct scatterlist *ccp_crypto_sg_table_add(struct sg_table *table,
