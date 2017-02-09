From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH v2 2/3] crypto: ccp - Update the command queue on errors
Date: Thu, 9 Feb 2017 15:49:57 -0600
Message-ID: <20170209214957.11781.30020.stgit@taos>
References: <20170209214704.11781.28640.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-cys01nam02on0069.outbound.protection.outlook.com ([104.47.37.69]:51472
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752301AbdBIVvK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Feb 2017 16:51:10 -0500
In-Reply-To: <20170209214704.11781.28640.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Move the command queue tail pointer when an error is
detected. Always return the error.

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-dev-v5.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
index 5fb6c8c..d9e1876 100644
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
