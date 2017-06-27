From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH] crypto: ccp - Change all references to use the JOB ID macro
Date: Tue, 27 Jun 2017 08:58:16 -0500
Message-ID: <149857189631.26668.7228199918497769629.stgit@sosxen.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-cys01nam02on0050.outbound.protection.outlook.com ([104.47.37.50]:11840
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751515AbdF0N60 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Jun 2017 09:58:26 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use the CCP_NEW_JOBID() macro when assigning an identifier

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-ops.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index c0dfdacbdff5..78f29d459df8 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -1756,7 +1756,7 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 
 	memset(&op, 0, sizeof(op));
 	op.cmd_q = cmd_q;
-	op.jobid = ccp_gen_jobid(cmd_q->ccp);
+	op.jobid = CCP_NEW_JOBID(cmd_q->ccp);
 	op.sb_key = cmd_q->ccp->vdata->perform->sballoc(cmd_q, sb_count);
 
 	if (!op.sb_key)
@@ -1992,7 +1992,7 @@ static int ccp_run_passthru_nomap_cmd(struct ccp_cmd_queue *cmd_q,
 
 	memset(&op, 0, sizeof(op));
 	op.cmd_q = cmd_q;
-	op.jobid = ccp_gen_jobid(cmd_q->ccp);
+	op.jobid = CCP_NEW_JOBID(cmd_q->ccp);
 
 	if (pt->bit_mod != CCP_PASSTHRU_BITWISE_NOOP) {
 		/* Load the mask */
