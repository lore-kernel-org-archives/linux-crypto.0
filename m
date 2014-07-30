From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH] crypto: ccp - Do not sign extend input data to CCP
Date: Wed, 30 Jul 2014 15:41:32 -0500
Message-ID: <20140730204132.11748.11340.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:1964
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750831AbaG3Ulo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 30 Jul 2014 16:41:44 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The CCP hardware interprets all numbers as unsigned numbers, therefore
sign extending input data is not valid.  Modify the function calls
for RSA and ECC to not perform sign extending.

This patch is based on the cryptodev-2.6 kernel tree.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-ops.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index 9ae006d..8729364 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -1606,7 +1606,7 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 		goto e_ksb;
 
 	ccp_reverse_set_dm_area(&exp, rsa->exp, rsa->exp_len, CCP_KSB_BYTES,
-				true);
+				false);
 	ret = ccp_copy_to_ksb(cmd_q, &exp, op.jobid, op.ksb_key,
 			      CCP_PASSTHRU_BYTESWAP_NOOP);
 	if (ret) {
@@ -1623,10 +1623,10 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 		goto e_exp;
 
 	ccp_reverse_set_dm_area(&src, rsa->mod, rsa->mod_len, CCP_KSB_BYTES,
-				true);
+				false);
 	src.address += o_len;	/* Adjust the address for the copy operation */
 	ccp_reverse_set_dm_area(&src, rsa->src, rsa->src_len, CCP_KSB_BYTES,
-				true);
+				false);
 	src.address -= o_len;	/* Reset the address to original value */
 
 	/* Prepare the output area for the operation */
@@ -1841,20 +1841,20 @@ static int ccp_run_ecc_mm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 
 	/* Copy the ECC modulus */
 	ccp_reverse_set_dm_area(&src, ecc->mod, ecc->mod_len,
-				CCP_ECC_OPERAND_SIZE, true);
+				CCP_ECC_OPERAND_SIZE, false);
 	src.address += CCP_ECC_OPERAND_SIZE;
 
 	/* Copy the first operand */
 	ccp_reverse_set_dm_area(&src, ecc->u.mm.operand_1,
 				ecc->u.mm.operand_1_len,
-				CCP_ECC_OPERAND_SIZE, true);
+				CCP_ECC_OPERAND_SIZE, false);
 	src.address += CCP_ECC_OPERAND_SIZE;
 
 	if (ecc->function != CCP_ECC_FUNCTION_MINV_384BIT) {
 		/* Copy the second operand */
 		ccp_reverse_set_dm_area(&src, ecc->u.mm.operand_2,
 					ecc->u.mm.operand_2_len,
-					CCP_ECC_OPERAND_SIZE, true);
+					CCP_ECC_OPERAND_SIZE, false);
 		src.address += CCP_ECC_OPERAND_SIZE;
 	}
 
@@ -1960,17 +1960,17 @@ static int ccp_run_ecc_pm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 
 	/* Copy the ECC modulus */
 	ccp_reverse_set_dm_area(&src, ecc->mod, ecc->mod_len,
-				CCP_ECC_OPERAND_SIZE, true);
+				CCP_ECC_OPERAND_SIZE, false);
 	src.address += CCP_ECC_OPERAND_SIZE;
 
 	/* Copy the first point X and Y coordinate */
 	ccp_reverse_set_dm_area(&src, ecc->u.pm.point_1.x,
 				ecc->u.pm.point_1.x_len,
-				CCP_ECC_OPERAND_SIZE, true);
+				CCP_ECC_OPERAND_SIZE, false);
 	src.address += CCP_ECC_OPERAND_SIZE;
 	ccp_reverse_set_dm_area(&src, ecc->u.pm.point_1.y,
 				ecc->u.pm.point_1.y_len,
-				CCP_ECC_OPERAND_SIZE, true);
+				CCP_ECC_OPERAND_SIZE, false);
 	src.address += CCP_ECC_OPERAND_SIZE;
 
 	/* Set the first point Z coordianate to 1 */
@@ -1981,11 +1981,11 @@ static int ccp_run_ecc_pm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 		/* Copy the second point X and Y coordinate */
 		ccp_reverse_set_dm_area(&src, ecc->u.pm.point_2.x,
 					ecc->u.pm.point_2.x_len,
-					CCP_ECC_OPERAND_SIZE, true);
+					CCP_ECC_OPERAND_SIZE, false);
 		src.address += CCP_ECC_OPERAND_SIZE;
 		ccp_reverse_set_dm_area(&src, ecc->u.pm.point_2.y,
 					ecc->u.pm.point_2.y_len,
-					CCP_ECC_OPERAND_SIZE, true);
+					CCP_ECC_OPERAND_SIZE, false);
 		src.address += CCP_ECC_OPERAND_SIZE;
 
 		/* Set the second point Z coordianate to 1 */
@@ -1995,14 +1995,14 @@ static int ccp_run_ecc_pm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 		/* Copy the Domain "a" parameter */
 		ccp_reverse_set_dm_area(&src, ecc->u.pm.domain_a,
 					ecc->u.pm.domain_a_len,
-					CCP_ECC_OPERAND_SIZE, true);
+					CCP_ECC_OPERAND_SIZE, false);
 		src.address += CCP_ECC_OPERAND_SIZE;
 
 		if (ecc->function == CCP_ECC_FUNCTION_PMUL_384BIT) {
 			/* Copy the scalar value */
 			ccp_reverse_set_dm_area(&src, ecc->u.pm.scalar,
 						ecc->u.pm.scalar_len,
-						CCP_ECC_OPERAND_SIZE, true);
+						CCP_ECC_OPERAND_SIZE, false);
 			src.address += CCP_ECC_OPERAND_SIZE;
 		}
 	}
