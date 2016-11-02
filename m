From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH] crypto: ccp - Update the command queue on errors
Date: Wed, 2 Nov 2016 10:14:03 -0500
Message-ID: <20161102151403.17167.72785.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <ghook@amd.com>, <thomas.lendacky@amd.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-cys01nam02on0088.outbound.protection.outlook.com ([104.47.37.88]:42144
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754748AbcKBP3Z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Nov 2016 11:29:25 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Move the command queue tail pointer when an error is
detected. Always return the error.

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-dev-v5.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
index ff7816a..0baa99e 100644
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ b/drivers/crypto/ccp/ccp-dev-v5.c
@@ -250,17 +250,20 @@ static int ccp5_do_cmd(struct ccp5_desc *desc,
 		ret = wait_event_interruptible(cmd_q->int_queue,
 					       cmd_q->int_rcvd);
 		if (ret || cmd_q->cmd_error) {
+			/* Log the error and flush the queue by
+			 * moving the head pointer
+			 */
 			if (cmd_q->cmd_error)
 				ccp_log_error(cmd_q->ccp,
 					      cmd_q->cmd_error);
-			/* A version 5 device doesn't use Job IDs... */
+			iowrite32(tail, cmd_q->reg_head_lo);
 			if (!ret)
 				ret = -EIO;
 		}
 		cmd_q->int_rcvd = 0;
 	}
 
-	return 0;
+	return ret;
 }
 
 static int ccp5_perform_aes(struct ccp_op *op)
