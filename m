From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH v3 3/3] crypto: ccp - Add XTS-AES-256 support for CCP
 version 5
Date: Tue, 25 Jul 2017 14:21:43 -0500
Message-ID: <150101050323.39154.9626146588301092959.stgit@sosxen.amd.com>
References: <150100997531.39154.470521200404215266.stgit@sosxen.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam02on0050.outbound.protection.outlook.com ([104.47.36.50]:21344
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753021AbdGYTVt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Jul 2017 15:21:49 -0400
In-Reply-To: <150100997531.39154.470521200404215266.stgit@sosxen.amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-aes-xts.c |   26 ++++++++++++++++++++++----
 drivers/crypto/ccp/ccp-crypto.h         |    2 +-
 drivers/crypto/ccp/ccp-ops.c            |    2 ++
 3 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-aes-xts.c b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
index 5c2df880ab48..94b5bcf5b628 100644
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
@@ -105,6 +110,8 @@ static int ccp_aes_xts_crypt(struct ablkcipher_request *req,
 {
 	struct ccp_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
 	struct ccp_aes_req_ctx *rctx = ablkcipher_request_ctx(req);
+	unsigned int ccpversion = ccp_version();
+	unsigned int fallback = 0;
 	unsigned int unit;
 	u32 unit_size;
 	int ret;
@@ -131,8 +138,19 @@ static int ccp_aes_xts_crypt(struct ablkcipher_request *req,
 			break;
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
+	if (fallback) {
 		SKCIPHER_REQUEST_ON_STACK(subreq, ctx->u.aes.tfm_skcipher);
 
 		/* Use the fallback to process the request for any
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
index 6a2857274f61..6045e8c1d025 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -1065,6 +1065,8 @@ static int ccp_run_xts_aes_cmd(struct ccp_cmd_queue *cmd_q,
 
 	if (xts->key_len == AES_KEYSIZE_128)
 		aestype = CCP_AES_TYPE_128;
+	else if (xts->key_len == AES_KEYSIZE_256)
+		aestype = CCP_AES_TYPE_256;
 	else
 		return -EINVAL;
 
