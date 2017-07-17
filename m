From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH] crypto: ccp - Fix XTS-AES support on a version 5 CCP
Date: Mon, 17 Jul 2017 15:08:27 -0500
Message-ID: <150032210775.102848.1585950131204303137.stgit@sosxen.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-co1nam03on0073.outbound.protection.outlook.com ([104.47.40.73]:9824
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751317AbdGQUIe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jul 2017 16:08:34 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Version 5 CCPs have differing requirements for XTS-AES: key components
are stored in a 512-bit vector. The context must be little-endian
justified. AES-256 is supported now, so propagate the cipher size to
the command descriptor.

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-aes-xts.c |   79 ++++++++++++++++---------------
 drivers/crypto/ccp/ccp-dev-v5.c         |    2 +
 drivers/crypto/ccp/ccp-dev.h            |    2 +
 drivers/crypto/ccp/ccp-ops.c            |   56 ++++++++++++++++++----
 4 files changed, 89 insertions(+), 50 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-aes-xts.c b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
index 58a4244b4752..8d248b198e22 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-xts.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
@@ -1,7 +1,7 @@
 /*
  * AMD Cryptographic Coprocessor (CCP) AES XTS crypto API support
  *
- * Copyright (C) 2013 Advanced Micro Devices, Inc.
+ * Copyright (C) 2013,2017 Advanced Micro Devices, Inc.
  *
  * Author: Tom Lendacky <thomas.lendacky@amd.com>
  *
@@ -37,46 +37,26 @@ struct ccp_unit_size_map {
 	u32 value;
 };
 
-static struct ccp_unit_size_map unit_size_map[] = {
+static struct ccp_unit_size_map xts_unit_sizes[] = {
 	{
-		.size	= 4096,
-		.value	= CCP_XTS_AES_UNIT_SIZE_4096,
-	},
-	{
-		.size	= 2048,
-		.value	= CCP_XTS_AES_UNIT_SIZE_2048,
-	},
-	{
-		.size	= 1024,
-		.value	= CCP_XTS_AES_UNIT_SIZE_1024,
+		.size   = 16,
+		.value	= CCP_XTS_AES_UNIT_SIZE_16,
 	},
 	{
-		.size	= 512,
+		.size   = 512,
 		.value	= CCP_XTS_AES_UNIT_SIZE_512,
 	},
 	{
-		.size	= 256,
-		.value	= CCP_XTS_AES_UNIT_SIZE__LAST,
-	},
-	{
-		.size	= 128,
-		.value	= CCP_XTS_AES_UNIT_SIZE__LAST,
-	},
-	{
-		.size	= 64,
-		.value	= CCP_XTS_AES_UNIT_SIZE__LAST,
-	},
-	{
-		.size	= 32,
-		.value	= CCP_XTS_AES_UNIT_SIZE__LAST,
+		.size   = 1024,
+		.value	= CCP_XTS_AES_UNIT_SIZE_1024,
 	},
 	{
-		.size	= 16,
-		.value	= CCP_XTS_AES_UNIT_SIZE_16,
+		.size   = 2048,
+		.value	= CCP_XTS_AES_UNIT_SIZE_2048,
 	},
 	{
-		.size	= 1,
-		.value	= CCP_XTS_AES_UNIT_SIZE__LAST,
+		.size   = 4096,
+		.value	= CCP_XTS_AES_UNIT_SIZE_4096,
 	},
 };
 
@@ -97,14 +77,20 @@ static int ccp_aes_xts_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 			      unsigned int key_len)
 {
 	struct ccp_ctx *ctx = crypto_tfm_ctx(crypto_ablkcipher_tfm(tfm));
+	unsigned int ccpversion = ccp_version();
 
 	/* Only support 128-bit AES key with a 128-bit Tweak key,
 	 * otherwise use the fallback
 	 */
+
 	switch (key_len) {
 	case AES_KEYSIZE_128 * 2:
 		memcpy(ctx->u.aes.key, key, key_len);
 		break;
+	case AES_KEYSIZE_256 * 2:
+		if (ccpversion > CCP_VERSION(3, 0))
+			memcpy(ctx->u.aes.key, key, key_len);
+		break;
 	}
 	ctx->u.aes.key_len = key_len / 2;
 	sg_init_one(&ctx->u.aes.key_sg, ctx->u.aes.key, key_len);
@@ -117,7 +103,10 @@ static int ccp_aes_xts_crypt(struct ablkcipher_request *req,
 {
 	struct ccp_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
 	struct ccp_aes_req_ctx *rctx = ablkcipher_request_ctx(req);
+	unsigned int ccpversion = ccp_version();
+	unsigned int fallback = 0;
 	unsigned int unit;
+	u32 block_size = 0;
 	u32 unit_size;
 	int ret;
 
@@ -131,17 +120,29 @@ static int ccp_aes_xts_crypt(struct ablkcipher_request *req,
 		return -EINVAL;
 
 	unit_size = CCP_XTS_AES_UNIT_SIZE__LAST;
-	if (req->nbytes <= unit_size_map[0].size) {
-		for (unit = 0; unit < ARRAY_SIZE(unit_size_map); unit++) {
-			if (!(req->nbytes & (unit_size_map[unit].size - 1))) {
-				unit_size = unit_size_map[unit].value;
-				break;
-			}
+	for (unit = ARRAY_SIZE(xts_unit_sizes); unit-- > 0; ) {
+		if (!(req->nbytes & (xts_unit_sizes[unit].size - 1))) {
+			unit_size = unit;
+			block_size = xts_unit_sizes[unit].size;
+			break;
 		}
 	}
 
-	if ((unit_size == CCP_XTS_AES_UNIT_SIZE__LAST) ||
-	    (ctx->u.aes.key_len != AES_KEYSIZE_128)) {
+	/* The CCP has restrictions on block sizes. Also, a version 3 device
+	 * only supports AES-128 operations; version 5 CCPs support both
+	 * AES-128 and -256 operations.
+	 */
+	if (unit_size == CCP_XTS_AES_UNIT_SIZE__LAST)
+		fallback = 1;
+	if ((ccpversion < CCP_VERSION(5, 0)) &&
+	    (ctx->u.aes.key_len != AES_KEYSIZE_128))
+		fallback = 1;
+	if ((ctx->u.aes.key_len != AES_KEYSIZE_128) &&
+	    (ctx->u.aes.key_len != AES_KEYSIZE_256))
+		fallback = 1;
+	if (req->nbytes != block_size)
+		fallback = 1;
+	if (fallback) {
 		SKCIPHER_REQUEST_ON_STACK(subreq, ctx->u.aes.tfm_skcipher);
 
 		/* Use the fallback to process the request for any
diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
index b3526336d608..11febe2bd07c 100644
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ b/drivers/crypto/ccp/ccp-dev-v5.c
@@ -144,6 +144,7 @@ union ccp_function {
 #define	CCP_AES_ENCRYPT(p)	((p)->aes.encrypt)
 #define	CCP_AES_MODE(p)		((p)->aes.mode)
 #define	CCP_AES_TYPE(p)		((p)->aes.type)
+#define	CCP_XTS_TYPE(p)		((p)->aes_xts.type)
 #define	CCP_XTS_SIZE(p)		((p)->aes_xts.size)
 #define	CCP_XTS_ENCRYPT(p)	((p)->aes_xts.encrypt)
 #define	CCP_DES3_SIZE(p)	((p)->des3.size)
@@ -344,6 +345,7 @@ static int ccp5_perform_xts_aes(struct ccp_op *op)
 	CCP5_CMD_PROT(&desc) = 0;
 
 	function.raw = 0;
+	CCP_XTS_TYPE(&function) = op->u.xts.type;
 	CCP_XTS_ENCRYPT(&function) = op->u.xts.action;
 	CCP_XTS_SIZE(&function) = op->u.xts.unit_size;
 	CCP5_CMD_FUNCTION(&desc) = function.raw;
diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
index 9320931d89da..3d51180199ac 100644
--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -194,6 +194,7 @@
 #define CCP_AES_CTX_SB_COUNT		1
 
 #define CCP_XTS_AES_KEY_SB_COUNT	1
+#define CCP5_XTS_AES_KEY_SB_COUNT	2
 #define CCP_XTS_AES_CTX_SB_COUNT	1
 
 #define CCP_DES3_KEY_SB_COUNT		1
@@ -497,6 +498,7 @@ struct ccp_aes_op {
 };
 
 struct ccp_xts_aes_op {
+	enum ccp_aes_type type;
 	enum ccp_aes_action action;
 	enum ccp_xts_aes_unit_size unit_size;
 };
diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index e23d138fc1ce..d1be07884a9b 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -1038,6 +1038,8 @@ static int ccp_run_xts_aes_cmd(struct ccp_cmd_queue *cmd_q,
 	struct ccp_op op;
 	unsigned int unit_size, dm_offset;
 	bool in_place = false;
+	unsigned int sb_count = 0;
+	enum ccp_aes_type aestype;
 	int ret;
 
 	switch (xts->unit_size) {
@@ -1056,12 +1058,15 @@ static int ccp_run_xts_aes_cmd(struct ccp_cmd_queue *cmd_q,
 	case CCP_XTS_AES_UNIT_SIZE_4096:
 		unit_size = 4096;
 		break;
-
 	default:
 		return -EINVAL;
 	}
 
-	if (xts->key_len != AES_KEYSIZE_128)
+	if (xts->key_len == AES_KEYSIZE_128)
+		aestype = CCP_AES_TYPE_128;
+	else if (xts->key_len == AES_KEYSIZE_256)
+		aestype = CCP_AES_TYPE_256;
+	else
 		return -EINVAL;
 
 	if (!xts->final && (xts->src_len & (AES_BLOCK_SIZE - 1)))
@@ -1084,22 +1089,50 @@ static int ccp_run_xts_aes_cmd(struct ccp_cmd_queue *cmd_q,
 	op.sb_ctx = cmd_q->sb_ctx;
 	op.init = 1;
 	op.u.xts.action = xts->action;
+	op.u.xts.type = aestype;
 	op.u.xts.unit_size = xts->unit_size;
 
-	/* All supported key sizes fit in a single (32-byte) SB entry
-	 * and must be in little endian format. Use the 256-bit byte
-	 * swap passthru option to convert from big endian to little
-	 * endian.
+	/* A version 3 device only supports 128-bit keys, which fits into a
+	 * single SB entry. A version 5 device uses a 512-bit vector, so two
+	 * SB entries.
 	 */
+	if (cmd_q->ccp->vdata->version == CCP_VERSION(3, 0))
+		sb_count = CCP_XTS_AES_KEY_SB_COUNT;
+	else
+		sb_count = CCP5_XTS_AES_KEY_SB_COUNT;
 	ret = ccp_init_dm_workarea(&key, cmd_q,
-				   CCP_XTS_AES_KEY_SB_COUNT * CCP_SB_BYTES,
+				   sb_count * CCP_SB_BYTES,
 				   DMA_TO_DEVICE);
 	if (ret)
 		return ret;
 
-	dm_offset = CCP_SB_BYTES - AES_KEYSIZE_128;
-	ccp_set_dm_area(&key, dm_offset, xts->key, 0, xts->key_len);
-	ccp_set_dm_area(&key, 0, xts->key, dm_offset, xts->key_len);
+	if (cmd_q->ccp->vdata->version == CCP_VERSION(3, 0)) {
+		/* All supported key sizes * must be in little endian format.
+		 * Use the 256-bit byte swap passthru option to convert from
+		 * big endian to little endian.
+		 */
+		dm_offset = CCP_SB_BYTES - AES_KEYSIZE_128;
+		ccp_set_dm_area(&key, dm_offset, xts->key, 0, xts->key_len);
+		ccp_set_dm_area(&key, 0, xts->key, xts->key_len, xts->key_len);
+	} else {
+		/* The AES key is at the little end and the tweak key is
+		 * at the big end. Since the byteswap operation is only
+		 * 256-bit, load the buffer according to the way things
+		 * will end up.
+		 */
+		unsigned int pad;
+
+		op.sb_key = cmd_q->ccp->vdata->perform->sballoc(cmd_q,
+								sb_count);
+		if (!op.sb_key)
+			return -EIO;
+
+		dm_offset = CCP_SB_BYTES;
+		pad = dm_offset - xts->key_len;
+		ccp_set_dm_area(&key, pad, xts->key, 0, xts->key_len);
+		ccp_set_dm_area(&key, dm_offset + pad, xts->key, xts->key_len,
+				xts->key_len);
+	}
 	ret = ccp_copy_to_sb(cmd_q, &key, op.jobid, op.sb_key,
 			     CCP_PASSTHRU_BYTESWAP_256BIT);
 	if (ret) {
@@ -1179,7 +1212,6 @@ static int ccp_run_xts_aes_cmd(struct ccp_cmd_queue *cmd_q,
 e_dst:
 	if (!in_place)
 		ccp_free_data(&dst, cmd_q);
-
 e_src:
 	ccp_free_data(&src, cmd_q);
 
@@ -1188,6 +1220,8 @@ static int ccp_run_xts_aes_cmd(struct ccp_cmd_queue *cmd_q,
 
 e_key:
 	ccp_dm_free(&key);
+	if (cmd_q->ccp->vdata->version > CCP_VERSION(3, 0))
+		cmd_q->ccp->vdata->perform->sbfree(cmd_q, op.sb_key, sb_count);
 
 	return ret;
 }
