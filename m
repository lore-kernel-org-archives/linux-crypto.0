From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH 2/6] crypto: ccp - Remove unneeded sign-extension support
Date: Thu, 13 Oct 2016 09:53:00 -0500
Message-ID: <20161013145300.19759.14061.stgit@taos>
References: <20161013144542.19759.6924.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam03on0072.outbound.protection.outlook.com ([104.47.42.72]:52172
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754424AbcJMP1z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Oct 2016 11:27:55 -0400
In-Reply-To: <20161013144542.19759.6924.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The reverse-get/set functions can be simplified by
eliminating unused code.


Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-ops.c |  145 +++++++++++++++++-------------------------
 1 file changed, 59 insertions(+), 86 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index 8fedb14..82cc637 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -198,62 +198,46 @@ static void ccp_get_dm_area(struct ccp_dm_workarea *wa, unsigned int wa_offset,
 }
 
 static int ccp_reverse_set_dm_area(struct ccp_dm_workarea *wa,
+				   unsigned int wa_offset,
 				   struct scatterlist *sg,
-				   unsigned int len, unsigned int se_len,
-				   bool sign_extend)
+				   unsigned int sg_offset,
+				   unsigned int len)
 {
-	unsigned int nbytes, sg_offset, dm_offset, sb_len, i;
-	u8 buffer[CCP_REVERSE_BUF_SIZE];
-
-	if (WARN_ON(se_len > sizeof(buffer)))
-		return -EINVAL;
-
-	sg_offset = len;
-	dm_offset = 0;
-	nbytes = len;
-	while (nbytes) {
-		sb_len = min_t(unsigned int, nbytes, se_len);
-		sg_offset -= sb_len;
-
-		scatterwalk_map_and_copy(buffer, sg, sg_offset, sb_len, 0);
-		for (i = 0; i < sb_len; i++)
-			wa->address[dm_offset + i] = buffer[sb_len - i - 1];
-
-		dm_offset += sb_len;
-		nbytes -= sb_len;
-
-		if ((sb_len != se_len) && sign_extend) {
-			/* Must sign-extend to nearest sign-extend length */
-			if (wa->address[dm_offset - 1] & 0x80)
-				memset(wa->address + dm_offset, 0xff,
-				       se_len - sb_len);
-		}
+	u8 *p, *q;
+
+	ccp_set_dm_area(wa, wa_offset, sg, sg_offset, len);
+
+	p = wa->address + wa_offset;
+	q = p + len - 1;
+	while (p < q) {
+		*p = *p ^ *q;
+		*q = *p ^ *q;
+		*p = *p ^ *q;
+		p++;
+		q--;
 	}
-
 	return 0;
 }
 
 static void ccp_reverse_get_dm_area(struct ccp_dm_workarea *wa,
+				    unsigned int wa_offset,
 				    struct scatterlist *sg,
+				    unsigned int sg_offset,
 				    unsigned int len)
 {
-	unsigned int nbytes, sg_offset, dm_offset, sb_len, i;
-	u8 buffer[CCP_REVERSE_BUF_SIZE];
-
-	sg_offset = 0;
-	dm_offset = len;
-	nbytes = len;
-	while (nbytes) {
-		sb_len = min_t(unsigned int, nbytes, sizeof(buffer));
-		dm_offset -= sb_len;
-
-		for (i = 0; i < sb_len; i++)
-			buffer[sb_len - i - 1] = wa->address[dm_offset + i];
-		scatterwalk_map_and_copy(buffer, sg, sg_offset, sb_len, 1);
-
-		sg_offset += sb_len;
-		nbytes -= sb_len;
+	u8 *p, *q;
+
+	p = wa->address + wa_offset;
+	q = p + len - 1;
+	while (p < q) {
+		*p = *p ^ *q;
+		*q = *p ^ *q;
+		*p = *p ^ *q;
+		p++;
+		q--;
 	}
+
+	ccp_get_dm_area(wa, wa_offset, sg, sg_offset, len);
 }
 
 static void ccp_free_data(struct ccp_data *data, struct ccp_cmd_queue *cmd_q)
@@ -1294,7 +1278,9 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	struct ccp_data dst;
 	struct ccp_op op;
 	unsigned int sb_count, i_len, o_len;
-	int ret;
+	unsigned int dm_offset;
+	int i = 0;
+	int ret = 0;
 
 	if (rsa->key_size > CCP_RSA_MAX_WIDTH)
 		return -EINVAL;
@@ -1331,8 +1317,7 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	if (ret)
 		goto e_sb;
 
-	ret = ccp_reverse_set_dm_area(&exp, rsa->exp, rsa->exp_len,
-				      CCP_SB_BYTES, false);
+	ret = ccp_reverse_set_dm_area(&exp, 0, rsa->exp, 0, rsa->exp_len);
 	if (ret)
 		goto e_exp;
 	ret = ccp_copy_to_sb(cmd_q, &exp, op.jobid, op.sb_key,
@@ -1350,13 +1335,10 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	if (ret)
 		goto e_exp;
 
-	ret = ccp_reverse_set_dm_area(&src, rsa->mod, rsa->mod_len,
-				      CCP_SB_BYTES, false);
+	ret = ccp_reverse_set_dm_area(&src, 0, rsa->mod, 0, rsa->mod_len);
 	if (ret)
 		goto e_src;
-	src.address += o_len;	/* Adjust the address for the copy operation */
-	ret = ccp_reverse_set_dm_area(&src, rsa->src, rsa->src_len,
-				      CCP_SB_BYTES, false);
+	ret = ccp_reverse_set_dm_area(&src, o_len, rsa->mod, 0, rsa->mod_len);
 	if (ret)
 		goto e_src;
 	src.address -= o_len;	/* Reset the address to original value */
@@ -1384,7 +1366,7 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 		goto e_dst;
 	}
 
-	ccp_reverse_get_dm_area(&dst.dm_wa, rsa->dst, rsa->mod_len);
+	ccp_reverse_get_dm_area(&dst.dm_wa, 0, rsa->dst, 0, rsa->mod_len);
 
 e_dst:
 	ccp_free_data(&dst, cmd_q);
@@ -1636,25 +1618,22 @@ static int ccp_run_ecc_mm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	save = src.address;
 
 	/* Copy the ECC modulus */
-	ret = ccp_reverse_set_dm_area(&src, ecc->mod, ecc->mod_len,
-				      CCP_ECC_OPERAND_SIZE, false);
+	ret = ccp_reverse_set_dm_area(&src, 0, ecc->mod, 0, ecc->mod_len);
 	if (ret)
 		goto e_src;
 	src.address += CCP_ECC_OPERAND_SIZE;
 
 	/* Copy the first operand */
-	ret = ccp_reverse_set_dm_area(&src, ecc->u.mm.operand_1,
-				      ecc->u.mm.operand_1_len,
-				      CCP_ECC_OPERAND_SIZE, false);
+	ret = ccp_reverse_set_dm_area(&src, 0, ecc->u.mm.operand_1, 0,
+				      ecc->u.mm.operand_1_len);
 	if (ret)
 		goto e_src;
 	src.address += CCP_ECC_OPERAND_SIZE;
 
 	if (ecc->function != CCP_ECC_FUNCTION_MINV_384BIT) {
 		/* Copy the second operand */
-		ret = ccp_reverse_set_dm_area(&src, ecc->u.mm.operand_2,
-					      ecc->u.mm.operand_2_len,
-					      CCP_ECC_OPERAND_SIZE, false);
+		ret = ccp_reverse_set_dm_area(&src, 0, ecc->u.mm.operand_2, 0,
+					      ecc->u.mm.operand_2_len);
 		if (ret)
 			goto e_src;
 		src.address += CCP_ECC_OPERAND_SIZE;
@@ -1693,7 +1672,8 @@ static int ccp_run_ecc_mm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	}
 
 	/* Save the ECC result */
-	ccp_reverse_get_dm_area(&dst, ecc->u.mm.result, CCP_ECC_MODULUS_BYTES);
+	ccp_reverse_get_dm_area(&dst, 0, ecc->u.mm.result, 0,
+				CCP_ECC_MODULUS_BYTES);
 
 e_dst:
 	ccp_dm_free(&dst);
@@ -1761,22 +1741,19 @@ static int ccp_run_ecc_pm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	save = src.address;
 
 	/* Copy the ECC modulus */
-	ret = ccp_reverse_set_dm_area(&src, ecc->mod, ecc->mod_len,
-				      CCP_ECC_OPERAND_SIZE, false);
+	ret = ccp_reverse_set_dm_area(&src, 0, ecc->mod, 0, ecc->mod_len);
 	if (ret)
 		goto e_src;
 	src.address += CCP_ECC_OPERAND_SIZE;
 
 	/* Copy the first point X and Y coordinate */
-	ret = ccp_reverse_set_dm_area(&src, ecc->u.pm.point_1.x,
-				      ecc->u.pm.point_1.x_len,
-				      CCP_ECC_OPERAND_SIZE, false);
+	ret = ccp_reverse_set_dm_area(&src, 0, ecc->u.pm.point_1.x, 0,
+				      ecc->u.pm.point_1.x_len);
 	if (ret)
 		goto e_src;
 	src.address += CCP_ECC_OPERAND_SIZE;
-	ret = ccp_reverse_set_dm_area(&src, ecc->u.pm.point_1.y,
-				      ecc->u.pm.point_1.y_len,
-				      CCP_ECC_OPERAND_SIZE, false);
+	ret = ccp_reverse_set_dm_area(&src, 0, ecc->u.pm.point_1.y, 0,
+				      ecc->u.pm.point_1.y_len);
 	if (ret)
 		goto e_src;
 	src.address += CCP_ECC_OPERAND_SIZE;
@@ -1787,15 +1764,13 @@ static int ccp_run_ecc_pm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 
 	if (ecc->function == CCP_ECC_FUNCTION_PADD_384BIT) {
 		/* Copy the second point X and Y coordinate */
-		ret = ccp_reverse_set_dm_area(&src, ecc->u.pm.point_2.x,
-					      ecc->u.pm.point_2.x_len,
-					      CCP_ECC_OPERAND_SIZE, false);
+		ret = ccp_reverse_set_dm_area(&src, 0, ecc->u.pm.point_2.x, 0,
+					      ecc->u.pm.point_2.x_len);
 		if (ret)
 			goto e_src;
 		src.address += CCP_ECC_OPERAND_SIZE;
-		ret = ccp_reverse_set_dm_area(&src, ecc->u.pm.point_2.y,
-					      ecc->u.pm.point_2.y_len,
-					      CCP_ECC_OPERAND_SIZE, false);
+		ret = ccp_reverse_set_dm_area(&src, 0, ecc->u.pm.point_2.y, 0,
+					      ecc->u.pm.point_2.y_len);
 		if (ret)
 			goto e_src;
 		src.address += CCP_ECC_OPERAND_SIZE;
@@ -1805,19 +1780,17 @@ static int ccp_run_ecc_pm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 		src.address += CCP_ECC_OPERAND_SIZE;
 	} else {
 		/* Copy the Domain "a" parameter */
-		ret = ccp_reverse_set_dm_area(&src, ecc->u.pm.domain_a,
-					      ecc->u.pm.domain_a_len,
-					      CCP_ECC_OPERAND_SIZE, false);
+		ret = ccp_reverse_set_dm_area(&src, 0, ecc->u.pm.domain_a, 0,
+					      ecc->u.pm.domain_a_len);
 		if (ret)
 			goto e_src;
 		src.address += CCP_ECC_OPERAND_SIZE;
 
 		if (ecc->function == CCP_ECC_FUNCTION_PMUL_384BIT) {
 			/* Copy the scalar value */
-			ret = ccp_reverse_set_dm_area(&src, ecc->u.pm.scalar,
-						      ecc->u.pm.scalar_len,
-						      CCP_ECC_OPERAND_SIZE,
-						      false);
+			ret = ccp_reverse_set_dm_area(&src, 0,
+						      ecc->u.pm.scalar, 0,
+						      ecc->u.pm.scalar_len);
 			if (ret)
 				goto e_src;
 			src.address += CCP_ECC_OPERAND_SIZE;
@@ -1862,10 +1835,10 @@ static int ccp_run_ecc_pm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	save = dst.address;
 
 	/* Save the ECC result X and Y coordinates */
-	ccp_reverse_get_dm_area(&dst, ecc->u.pm.result.x,
+	ccp_reverse_get_dm_area(&dst, 0, ecc->u.pm.result.x, 0,
 				CCP_ECC_MODULUS_BYTES);
 	dst.address += CCP_ECC_OUTPUT_SIZE;
-	ccp_reverse_get_dm_area(&dst, ecc->u.pm.result.y,
+	ccp_reverse_get_dm_area(&dst, 0, ecc->u.pm.result.y, 0,
 				CCP_ECC_MODULUS_BYTES);
 	dst.address += CCP_ECC_OUTPUT_SIZE;
 
