From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH 3/4] crypto: ccp - Update the command queue on errors
Date: Mon, 30 Jan 2017 08:28:43 -0600
Message-ID: <20170130142843.8459.53690.stgit@taos>
References: <20170130142414.8459.71539.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam02on0081.outbound.protection.outlook.com ([104.47.36.81]:35664
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752959AbdA3O3C (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Jan 2017 09:29:02 -0500
In-Reply-To: <20170130142414.8459.71539.stgit@taos>
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
