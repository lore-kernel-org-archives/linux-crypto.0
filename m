From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH v2 4/4] crypto: ccp - Add XTS-AES-256 support for CCP
 version 5
Date: Fri, 21 Jul 2017 14:05:17 -0500
Message-ID: <150066391693.49973.13009982918500791325.stgit@sosxen.amd.com>
References: <150066355075.49973.1565434199212056832.stgit@sosxen.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0057.outbound.protection.outlook.com ([104.47.34.57]:43409
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752811AbdGUTFY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jul 2017 15:05:24 -0400
In-Reply-To: <150066355075.49973.1565434199212056832.stgit@sosxen.amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-aes-xts.c |   16 +++++++++++++---
 drivers/crypto/ccp/ccp-crypto.h         |    2 +-
 drivers/crypto/ccp/ccp-ops.c            |    3 +++
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-aes-xts.c b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
index 3c37794ffe2d..4a3fe4d5ac71 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-xts.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
@@ -80,19 +80,24 @@ static int ccp_aes_xts_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 {
 	struct crypto_tfm *xfm = crypto_ablkcipher_tfm(tfm);
 	struct ccp_ctx *ctx = crypto_tfm_ctx(xfm);
+	unsigned int ccpversion = ccp_version();
 	int ret;
 
 	ret = xts_check_key(xfm, key, key_len);
 	if (ret)
 		return ret;
 
-	/* Only support 128-bit AES key with a 128-bit Tweak key,
-	 * otherwise use the fallback
+	/* Version 3 devices support 128-bit keys; version 5 devices can
+	 * accommodate 128- and 256-bit keys.
 	 */
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
@@ -105,6 +110,7 @@ static int ccp_aes_xts_crypt(struct ablkcipher_request *req,
 {
 	struct ccp_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
 	struct ccp_aes_req_ctx *rctx = ablkcipher_request_ctx(req);
+	unsigned int ccpversion = ccp_version();
 	unsigned int fallback = 0;
 	unsigned int unit;
 	u32 block_size;
@@ -141,7 +147,11 @@ static int ccp_aes_xts_crypt(struct ablkcipher_request *req,
 	 */
 	if (unit_size == CCP_XTS_AES_UNIT_SIZE__LAST)
 		fallback = 1;
-	if (ctx->u.aes.key_len != AES_KEYSIZE_128)
+	if ((ccpversion < CCP_VERSION(5, 0)) &&
+	    (ctx->u.aes.key_len != AES_KEYSIZE_128))
+		fallback = 1;
+	if ((ctx->u.aes.key_len != AES_KEYSIZE_128) &&
+	    (ctx->u.aes.key_len != AES_KEYSIZE_256))
 		fallback = 1;
 	if (fallback) {
 		SKCIPHER_REQUEST_ON_STACK(subreq, ctx->u.aes.tfm_skcipher);
diff --git a/drivers/crypto/ccp/ccp-crypto.h b/drivers/crypto/ccp/ccp-crypto.h
index 156b8233853f..880f8acdd0cd 100644
--- a/drivers/crypto/ccp/ccp-crypto.h
+++ b/drivers/crypto/ccp/ccp-crypto.h
@@ -91,7 +91,7 @@ struct ccp_aes_ctx {
 
 	struct scatterlist key_sg;
 	unsigned int key_len;
-	u8 key[AES_MAX_KEY_SIZE];
+	u8 key[AES_MAX_KEY_SIZE * 2];
 
 	u8 nonce[CTR_RFC3686_NONCE_SIZE];
 
diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index 8113355151d2..fbd024f6e898 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -1065,6 +1065,8 @@ static int ccp_run_xts_aes_cmd(struct ccp_cmd_queue *cmd_q,
 
 	if (xts->key_len == AES_KEYSIZE_128)
 		aestype = CCP_AES_TYPE_128;
+	else if (xts->key_len == AES_KEYSIZE_256)
+		aestype = CCP_AES_TYPE_256;
 	else
 		return -EINVAL;
 
@@ -1089,6 +1091,7 @@ static int ccp_run_xts_aes_cmd(struct ccp_cmd_queue *cmd_q,
 	op.sb_ctx = cmd_q->sb_ctx;
 	op.init = 1;
 	op.u.xts.action = xts->action;
+	op.u.xts.type = aestype;
 	op.u.xts.unit_size = xts->unit_size;
 
 	/* A version 3 device only supports 128-bit keys, which fits into a
