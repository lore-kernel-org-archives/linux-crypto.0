From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH V2 7/9] crypto: ccp - Enhance RSA support for a v5 CCP
Date: Fri, 4 Nov 2016 11:04:42 -0500
Message-ID: <20161104160442.18155.92936.stgit@taos>
References: <20161104160140.18155.75618.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0049.outbound.protection.outlook.com ([104.47.34.49]:2836
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S964842AbcKDQEt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Nov 2016 12:04:49 -0400
In-Reply-To: <20161104160140.18155.75618.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Take advantage of the increased RSA key size support in
the v5 CCP.

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-rsa.c |    5 ++
 drivers/crypto/ccp/ccp-crypto.h     |    1 
 drivers/crypto/ccp/ccp-dev-v3.c     |    1 
 drivers/crypto/ccp/ccp-dev-v5.c     |   10 +++--
 drivers/crypto/ccp/ccp-dev.h        |    2 +
 drivers/crypto/ccp/ccp-ops.c        |   76 ++++++++++++++++++++++-------------
 6 files changed, 61 insertions(+), 34 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-rsa.c b/drivers/crypto/ccp/ccp-crypto-rsa.c
index 6cb6c6f..5e68c8d 100644
--- a/drivers/crypto/ccp/ccp-crypto-rsa.c
+++ b/drivers/crypto/ccp/ccp-crypto-rsa.c
@@ -45,7 +45,10 @@ static int ccp_rsa_complete(struct crypto_async_request *async_req, int ret)
 
 static int ccp_rsa_maxsize(struct crypto_akcipher *tfm)
 {
-	return CCP_RSA_MAXMOD;
+	if (ccp_version() > CCP_VERSION(3, 0))
+		return CCP5_RSA_MAXMOD;
+	else
+		return CCP_RSA_MAXMOD;
 }
 
 static int ccp_rsa_crypt(struct akcipher_request *req, bool encrypt)
diff --git a/drivers/crypto/ccp/ccp-crypto.h b/drivers/crypto/ccp/ccp-crypto.h
index aa525e6..76d8b63 100644
--- a/drivers/crypto/ccp/ccp-crypto.h
+++ b/drivers/crypto/ccp/ccp-crypto.h
@@ -223,6 +223,7 @@ struct ccp_rsa_req_ctx {
 };
 
 #define	CCP_RSA_MAXMOD	(4 * 1024 / 8)
+#define	CCP5_RSA_MAXMOD	(16 * 1024 / 8)
 
 /***** Common Context Structure *****/
 struct ccp_ctx {
diff --git a/drivers/crypto/ccp/ccp-dev-v3.c b/drivers/crypto/ccp/ccp-dev-v3.c
index 7bc0998..3a55628 100644
--- a/drivers/crypto/ccp/ccp-dev-v3.c
+++ b/drivers/crypto/ccp/ccp-dev-v3.c
@@ -571,4 +571,5 @@ static irqreturn_t ccp_irq_handler(int irq, void *data)
 	.perform = &ccp3_actions,
 	.bar = 2,
 	.offset = 0x20000,
+	.rsamax = CCP_RSA_MAX_WIDTH,
 };
diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
index 05300a9..b31be75 100644
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ b/drivers/crypto/ccp/ccp-dev-v5.c
@@ -421,10 +421,10 @@ static int ccp5_perform_rsa(struct ccp_op *op)
 	CCP5_CMD_DST_HI(&desc) = ccp_addr_hi(&op->dst.u.dma);
 	CCP5_CMD_DST_MEM(&desc) = CCP_MEMTYPE_SYSTEM;
 
-	/* Exponent is in LSB memory */
-	CCP5_CMD_KEY_LO(&desc) = op->sb_key * LSB_ITEM_SIZE;
-	CCP5_CMD_KEY_HI(&desc) = 0;
-	CCP5_CMD_KEY_MEM(&desc) = CCP_MEMTYPE_SB;
+	/* Key (Exponent) is in external memory */
+	CCP5_CMD_KEY_LO(&desc) = ccp_addr_lo(&op->exp.u.dma);
+	CCP5_CMD_KEY_HI(&desc) = ccp_addr_hi(&op->exp.u.dma);
+	CCP5_CMD_KEY_MEM(&desc) = CCP_MEMTYPE_SYSTEM;
 
 	return ccp5_do_cmd(&desc, op->cmd_q);
 }
@@ -1013,6 +1013,7 @@ static void ccp5other_config(struct ccp_device *ccp)
 	.perform = &ccp5_actions,
 	.bar = 2,
 	.offset = 0x0,
+	.rsamax = CCP5_RSA_MAX_WIDTH,
 };
 
 const struct ccp_vdata ccpv5b = {
@@ -1021,4 +1022,5 @@ static void ccp5other_config(struct ccp_device *ccp)
 	.perform = &ccp5_actions,
 	.bar = 2,
 	.offset = 0x0,
+	.rsamax = CCP5_RSA_MAX_WIDTH,
 };
diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
index 830f35e..f2e9bcb 100644
--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -193,6 +193,7 @@
 #define CCP_SHA_SB_COUNT		1
 
 #define CCP_RSA_MAX_WIDTH		4096
+#define CCP5_RSA_MAX_WIDTH		16384
 
 #define CCP_PASSTHRU_BLOCKSIZE		256
 #define CCP_PASSTHRU_MASKSIZE		32
@@ -638,6 +639,7 @@ struct ccp_vdata {
 	const struct ccp_actions *perform;
 	const unsigned int bar;
 	const unsigned int offset;
+	const unsigned int rsamax;
 };
 
 extern const struct ccp_vdata ccpv3;
diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index 213a752..f7398e9 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -1282,37 +1282,43 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	unsigned int sb_count, i_len, o_len;
 	int ret;
 
-	if (rsa->key_size > CCP_RSA_MAX_WIDTH)
+	/* Check against the maximum allowable size, in bits */
+	if (rsa->key_size > cmd_q->ccp->vdata->rsamax)
 		return -EINVAL;
 
 	if (!rsa->exp || !rsa->mod || !rsa->src || !rsa->dst)
 		return -EINVAL;
 
-	/* The RSA modulus must precede the message being acted upon, so
-	 * it must be copied to a DMA area where the message and the
-	 * modulus can be concatenated.  Therefore the input buffer
-	 * length required is twice the output buffer length (which
-	 * must be a multiple of 256-bits).
-	 */
-	o_len = ((rsa->key_size + 255) / 256) * 32;
-	i_len = o_len * 2;
-
-	sb_count = o_len / CCP_SB_BYTES;
-
 	memset(&op, 0, sizeof(op));
 	op.cmd_q = cmd_q;
-	op.jobid = ccp_gen_jobid(cmd_q->ccp);
-	op.sb_key = cmd_q->ccp->vdata->perform->sballoc(cmd_q, sb_count);
+	op.jobid = CCP_NEW_JOBID(cmd_q->ccp);
 
-	if (!op.sb_key)
-		return -EIO;
+	/* Compute o_len, i_len in bytes. */
+	if (cmd_q->ccp->vdata->version < CCP_VERSION(4, 0)) {
+		/* The RSA modulus must precede the message being acted upon, so
+		 * it must be copied to a DMA area where the message and the
+		 * modulus can be concatenated.  Therefore the input buffer
+		 * length required is twice the output buffer length (which
+		 * must be a multiple of 256-bits). sb_count is the
+		 * number of storage block slots required for the modulus
+		 */
+		o_len = ((rsa->key_size + 255) / 256) * CCP_SB_BYTES;
+		i_len = o_len * 2;
+		sb_count = o_len / CCP_SB_BYTES;
+
+		op.sb_key = cmd_q->ccp->vdata->perform->sballoc(cmd_q,
+								sb_count);
+		if (!op.sb_key)
+			return -EIO;
+	} else {
+		/* A version 5 device allows a modulus size that will not fit
+		 * in the LSB, so the command will transfer it from memory.
+		 */
+		o_len = rsa->mod_len;
+		i_len = o_len * 2; /* bytes */
+		op.sb_key = cmd_q->sb_key;
+	}
 
-	/* The RSA exponent may span multiple (32-byte) SB entries and must
-	 * be in little endian format. Reverse copy each 32-byte chunk
-	 * of the exponent (En chunk to E0 chunk, E(n-1) chunk to E1 chunk)
-	 * and each byte within that chunk and do not perform any byte swap
-	 * operations on the passthru operation.
-	 */
 	ret = ccp_init_dm_workarea(&exp, cmd_q, o_len, DMA_TO_DEVICE);
 	if (ret)
 		goto e_sb;
@@ -1320,11 +1326,23 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	ret = ccp_reverse_set_dm_area(&exp, 0, rsa->exp, 0, rsa->exp_len);
 	if (ret)
 		goto e_exp;
-	ret = ccp_copy_to_sb(cmd_q, &exp, op.jobid, op.sb_key,
-			     CCP_PASSTHRU_BYTESWAP_NOOP);
-	if (ret) {
-		cmd->engine_error = cmd_q->cmd_error;
-		goto e_exp;
+
+	if (cmd_q->ccp->vdata->version < CCP_VERSION(4, 0)) {
+		/* The RSA exponent may span multiple (32-byte) KSB entries and
+		 * must be in little endian format. Reverse copy each 32-byte
+		 * chunk of the exponent (En chunk to E0 chunk, E(n-1) chunk to
+		 * E1 chunk) and each byte within that chunk and do not perform
+		 * any byte swap operations on the passthru operation.
+		 */
+		ret = ccp_copy_to_sb(cmd_q, &exp, op.jobid, op.sb_key,
+				     CCP_PASSTHRU_BYTESWAP_NOOP);
+		if (ret) {
+			cmd->engine_error = cmd_q->cmd_error;
+			goto e_exp;
+		}
+	} else {
+		op.exp.u.dma.address = exp.dma.address;
+		op.exp.u.dma.offset = 0;
 	}
 
 	/* Concatenate the modulus and the message. Both the modulus and
@@ -1364,7 +1382,6 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 		cmd->engine_error = cmd_q->cmd_error;
 		goto e_dst;
 	}
-
 	ccp_reverse_get_dm_area(&dst.dm_wa, 0, rsa->dst, 0, rsa->mod_len);
 
 e_dst:
@@ -1377,7 +1394,8 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	ccp_dm_free(&exp);
 
 e_sb:
-	cmd_q->ccp->vdata->perform->sbfree(cmd_q, op.sb_key, sb_count);
+	if (cmd_q->ccp->vdata->version < CCP_VERSION(4, 0))
+		cmd_q->ccp->vdata->perform->sbfree(cmd_q, op.sb_key, sb_count);
 
 	return ret;
 }
