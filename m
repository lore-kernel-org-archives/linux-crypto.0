From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v1 1/4] crypto: ccp - Replace BUG_ON with WARN_ON and a
 return code
Date: Thu, 1 Oct 2015 16:32:31 -0500
Message-ID: <20151001213231.4286.90968.stgit@tlendack-t1.amdoffice.net>
References: <20151001213225.4286.44278.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0056.outbound.protection.outlook.com ([207.46.100.56]:2086
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750767AbbJAVrm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 1 Oct 2015 17:47:42 -0400
In-Reply-To: <20151001213225.4286.44278.stgit@tlendack-t1.amdoffice.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Replace the usage of BUG_ON with WARN_ON and return an error.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c |   20 +++++-
 drivers/crypto/ccp/ccp-crypto-main.c     |    6 +-
 drivers/crypto/ccp/ccp-crypto-sha.c      |   13 ++++
 drivers/crypto/ccp/ccp-ops.c             |  108 +++++++++++++++++++-----------
 4 files changed, 105 insertions(+), 42 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
index ea7e844..d89f20c 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
@@ -118,10 +118,19 @@ static int ccp_do_cmac_update(struct ahash_request *req, unsigned int nbytes,
 	if (rctx->buf_count) {
 		sg_init_one(&rctx->buf_sg, rctx->buf, rctx->buf_count);
 		sg = ccp_crypto_sg_table_add(&rctx->data_sg, &rctx->buf_sg);
+		if (!sg) {
+			ret = -EINVAL;
+			goto e_free;
+		}
 	}
 
-	if (nbytes)
+	if (nbytes) {
 		sg = ccp_crypto_sg_table_add(&rctx->data_sg, req->src);
+		if (!sg) {
+			ret = -EINVAL;
+			goto e_free;
+		}
+	}
 
 	if (need_pad) {
 		int pad_length = block_size - (len & (block_size - 1));
@@ -132,6 +141,10 @@ static int ccp_do_cmac_update(struct ahash_request *req, unsigned int nbytes,
 		rctx->pad[0] = 0x80;
 		sg_init_one(&rctx->pad_sg, rctx->pad, pad_length);
 		sg = ccp_crypto_sg_table_add(&rctx->data_sg, &rctx->pad_sg);
+		if (!sg) {
+			ret = -EINVAL;
+			goto e_free;
+		}
 	}
 	if (sg) {
 		sg_mark_end(sg);
@@ -163,6 +176,11 @@ static int ccp_do_cmac_update(struct ahash_request *req, unsigned int nbytes,
 	ret = ccp_crypto_enqueue_request(&req->base, &rctx->cmd);
 
 	return ret;
+
+e_free:
+	sg_free_table(&rctx->data_sg);
+
+	return ret;
 }
 
 static int ccp_aes_cmac_init(struct ahash_request *req)
diff --git a/drivers/crypto/ccp/ccp-crypto-main.c b/drivers/crypto/ccp/ccp-crypto-main.c
index bdec01e..e0380e5 100644
--- a/drivers/crypto/ccp/ccp-crypto-main.c
+++ b/drivers/crypto/ccp/ccp-crypto-main.c
@@ -305,14 +305,16 @@ struct scatterlist *ccp_crypto_sg_table_add(struct sg_table *table,
 	for (sg = table->sgl; sg; sg = sg_next(sg))
 		if (!sg_page(sg))
 			break;
-	BUG_ON(!sg);
+	if (WARN_ON(!sg))
+		return NULL;
 
 	for (; sg && sg_add; sg = sg_next(sg), sg_add = sg_next(sg_add)) {
 		sg_set_page(sg, sg_page(sg_add), sg_add->length,
 			    sg_add->offset);
 		sg_last = sg;
 	}
-	BUG_ON(sg_add);
+	if (WARN_ON(sg_add))
+		return NULL;
 
 	return sg_last;
 }
diff --git a/drivers/crypto/ccp/ccp-crypto-sha.c b/drivers/crypto/ccp/ccp-crypto-sha.c
index 507b34e..d14b3f2 100644
--- a/drivers/crypto/ccp/ccp-crypto-sha.c
+++ b/drivers/crypto/ccp/ccp-crypto-sha.c
@@ -107,7 +107,15 @@ static int ccp_do_sha_update(struct ahash_request *req, unsigned int nbytes,
 
 		sg_init_one(&rctx->buf_sg, rctx->buf, rctx->buf_count);
 		sg = ccp_crypto_sg_table_add(&rctx->data_sg, &rctx->buf_sg);
+		if (!sg) {
+			ret = -EINVAL;
+			goto e_free;
+		}
 		sg = ccp_crypto_sg_table_add(&rctx->data_sg, req->src);
+		if (!sg) {
+			ret = -EINVAL;
+			goto e_free;
+		}
 		sg_mark_end(sg);
 
 		sg = rctx->data_sg.sgl;
@@ -142,6 +150,11 @@ static int ccp_do_sha_update(struct ahash_request *req, unsigned int nbytes,
 	ret = ccp_crypto_enqueue_request(&req->base, &rctx->cmd);
 
 	return ret;
+
+e_free:
+	sg_free_table(&rctx->data_sg);
+
+	return ret;
 }
 
 static int ccp_sha_init(struct ahash_request *req)
diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index d09c6c4..c6e883b 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -611,15 +611,16 @@ static void ccp_get_dm_area(struct ccp_dm_workarea *wa, unsigned int wa_offset,
 				 1);
 }
 
-static void ccp_reverse_set_dm_area(struct ccp_dm_workarea *wa,
-				    struct scatterlist *sg,
-				    unsigned int len, unsigned int se_len,
-				    bool sign_extend)
+static int ccp_reverse_set_dm_area(struct ccp_dm_workarea *wa,
+				   struct scatterlist *sg,
+				   unsigned int len, unsigned int se_len,
+				   bool sign_extend)
 {
 	unsigned int nbytes, sg_offset, dm_offset, ksb_len, i;
 	u8 buffer[CCP_REVERSE_BUF_SIZE];
 
-	BUG_ON(se_len > sizeof(buffer));
+	if (WARN_ON(se_len > sizeof(buffer)))
+		return -EINVAL;
 
 	sg_offset = len;
 	dm_offset = 0;
@@ -642,6 +643,8 @@ static void ccp_reverse_set_dm_area(struct ccp_dm_workarea *wa,
 				       se_len - ksb_len);
 		}
 	}
+
+	return 0;
 }
 
 static void ccp_reverse_get_dm_area(struct ccp_dm_workarea *wa,
@@ -1606,8 +1609,10 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	if (ret)
 		goto e_ksb;
 
-	ccp_reverse_set_dm_area(&exp, rsa->exp, rsa->exp_len, CCP_KSB_BYTES,
-				false);
+	ret = ccp_reverse_set_dm_area(&exp, rsa->exp, rsa->exp_len,
+				      CCP_KSB_BYTES, false);
+	if (ret)
+		goto e_exp;
 	ret = ccp_copy_to_ksb(cmd_q, &exp, op.jobid, op.ksb_key,
 			      CCP_PASSTHRU_BYTESWAP_NOOP);
 	if (ret) {
@@ -1623,11 +1628,15 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	if (ret)
 		goto e_exp;
 
-	ccp_reverse_set_dm_area(&src, rsa->mod, rsa->mod_len, CCP_KSB_BYTES,
-				false);
+	ret = ccp_reverse_set_dm_area(&src, rsa->mod, rsa->mod_len,
+				      CCP_KSB_BYTES, false);
+	if (ret)
+		goto e_src;
 	src.address += o_len;	/* Adjust the address for the copy operation */
-	ccp_reverse_set_dm_area(&src, rsa->src, rsa->src_len, CCP_KSB_BYTES,
-				false);
+	ret = ccp_reverse_set_dm_area(&src, rsa->src, rsa->src_len,
+				      CCP_KSB_BYTES, false);
+	if (ret)
+		goto e_src;
 	src.address -= o_len;	/* Reset the address to original value */
 
 	/* Prepare the output area for the operation */
@@ -1841,21 +1850,27 @@ static int ccp_run_ecc_mm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	save = src.address;
 
 	/* Copy the ECC modulus */
-	ccp_reverse_set_dm_area(&src, ecc->mod, ecc->mod_len,
-				CCP_ECC_OPERAND_SIZE, false);
+	ret = ccp_reverse_set_dm_area(&src, ecc->mod, ecc->mod_len,
+				      CCP_ECC_OPERAND_SIZE, false);
+	if (ret)
+		goto e_src;
 	src.address += CCP_ECC_OPERAND_SIZE;
 
 	/* Copy the first operand */
-	ccp_reverse_set_dm_area(&src, ecc->u.mm.operand_1,
-				ecc->u.mm.operand_1_len,
-				CCP_ECC_OPERAND_SIZE, false);
+	ret = ccp_reverse_set_dm_area(&src, ecc->u.mm.operand_1,
+				      ecc->u.mm.operand_1_len,
+				      CCP_ECC_OPERAND_SIZE, false);
+	if (ret)
+		goto e_src;
 	src.address += CCP_ECC_OPERAND_SIZE;
 
 	if (ecc->function != CCP_ECC_FUNCTION_MINV_384BIT) {
 		/* Copy the second operand */
-		ccp_reverse_set_dm_area(&src, ecc->u.mm.operand_2,
-					ecc->u.mm.operand_2_len,
-					CCP_ECC_OPERAND_SIZE, false);
+		ret = ccp_reverse_set_dm_area(&src, ecc->u.mm.operand_2,
+					      ecc->u.mm.operand_2_len,
+					      CCP_ECC_OPERAND_SIZE, false);
+		if (ret)
+			goto e_src;
 		src.address += CCP_ECC_OPERAND_SIZE;
 	}
 
@@ -1960,18 +1975,24 @@ static int ccp_run_ecc_pm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	save = src.address;
 
 	/* Copy the ECC modulus */
-	ccp_reverse_set_dm_area(&src, ecc->mod, ecc->mod_len,
-				CCP_ECC_OPERAND_SIZE, false);
+	ret = ccp_reverse_set_dm_area(&src, ecc->mod, ecc->mod_len,
+				      CCP_ECC_OPERAND_SIZE, false);
+	if (ret)
+		goto e_src;
 	src.address += CCP_ECC_OPERAND_SIZE;
 
 	/* Copy the first point X and Y coordinate */
-	ccp_reverse_set_dm_area(&src, ecc->u.pm.point_1.x,
-				ecc->u.pm.point_1.x_len,
-				CCP_ECC_OPERAND_SIZE, false);
+	ret = ccp_reverse_set_dm_area(&src, ecc->u.pm.point_1.x,
+				      ecc->u.pm.point_1.x_len,
+				      CCP_ECC_OPERAND_SIZE, false);
+	if (ret)
+		goto e_src;
 	src.address += CCP_ECC_OPERAND_SIZE;
-	ccp_reverse_set_dm_area(&src, ecc->u.pm.point_1.y,
-				ecc->u.pm.point_1.y_len,
-				CCP_ECC_OPERAND_SIZE, false);
+	ret = ccp_reverse_set_dm_area(&src, ecc->u.pm.point_1.y,
+				      ecc->u.pm.point_1.y_len,
+				      CCP_ECC_OPERAND_SIZE, false);
+	if (ret)
+		goto e_src;
 	src.address += CCP_ECC_OPERAND_SIZE;
 
 	/* Set the first point Z coordianate to 1 */
@@ -1980,13 +2001,17 @@ static int ccp_run_ecc_pm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 
 	if (ecc->function == CCP_ECC_FUNCTION_PADD_384BIT) {
 		/* Copy the second point X and Y coordinate */
-		ccp_reverse_set_dm_area(&src, ecc->u.pm.point_2.x,
-					ecc->u.pm.point_2.x_len,
-					CCP_ECC_OPERAND_SIZE, false);
+		ret = ccp_reverse_set_dm_area(&src, ecc->u.pm.point_2.x,
+					      ecc->u.pm.point_2.x_len,
+					      CCP_ECC_OPERAND_SIZE, false);
+		if (ret)
+			goto e_src;
 		src.address += CCP_ECC_OPERAND_SIZE;
-		ccp_reverse_set_dm_area(&src, ecc->u.pm.point_2.y,
-					ecc->u.pm.point_2.y_len,
-					CCP_ECC_OPERAND_SIZE, false);
+		ret = ccp_reverse_set_dm_area(&src, ecc->u.pm.point_2.y,
+					      ecc->u.pm.point_2.y_len,
+					      CCP_ECC_OPERAND_SIZE, false);
+		if (ret)
+			goto e_src;
 		src.address += CCP_ECC_OPERAND_SIZE;
 
 		/* Set the second point Z coordianate to 1 */
@@ -1994,16 +2019,21 @@ static int ccp_run_ecc_pm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 		src.address += CCP_ECC_OPERAND_SIZE;
 	} else {
 		/* Copy the Domain "a" parameter */
-		ccp_reverse_set_dm_area(&src, ecc->u.pm.domain_a,
-					ecc->u.pm.domain_a_len,
-					CCP_ECC_OPERAND_SIZE, false);
+		ret = ccp_reverse_set_dm_area(&src, ecc->u.pm.domain_a,
+					      ecc->u.pm.domain_a_len,
+					      CCP_ECC_OPERAND_SIZE, false);
+		if (ret)
+			goto e_src;
 		src.address += CCP_ECC_OPERAND_SIZE;
 
 		if (ecc->function == CCP_ECC_FUNCTION_PMUL_384BIT) {
 			/* Copy the scalar value */
-			ccp_reverse_set_dm_area(&src, ecc->u.pm.scalar,
-						ecc->u.pm.scalar_len,
-						CCP_ECC_OPERAND_SIZE, false);
+			ret = ccp_reverse_set_dm_area(&src, ecc->u.pm.scalar,
+						      ecc->u.pm.scalar_len,
+						      CCP_ECC_OPERAND_SIZE,
+						      false);
+			if (ret)
+				goto e_src;
 			src.address += CCP_ECC_OPERAND_SIZE;
 		}
 	}
