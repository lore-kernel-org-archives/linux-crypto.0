Return-Path: <SRS0=wtno=S7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5C23C43219
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Apr 2019 15:44:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A639C20675
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Apr 2019 15:44:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbfD2Po1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Apr 2019 11:44:27 -0400
Received: from mga14.intel.com ([192.55.52.115]:4157 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728438AbfD2Po1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Apr 2019 11:44:27 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Apr 2019 08:44:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,410,1549958400"; 
   d="scan'208";a="319990378"
Received: from silvixa00391824.ir.intel.com (HELO silvixa00391824.ger.corp.intel.com) ([10.237.222.24])
  by orsmga005.jf.intel.com with ESMTP; 29 Apr 2019 08:44:25 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Conor Mcloughlin <conor.mcloughlin@intel.com>,
        Sergey Portnoy <sergey.portnoy@intel.com>
Subject: [PATCH 5/7] crypto: qat - return proper error code in setkey
Date:   Mon, 29 Apr 2019 16:43:19 +0100
Message-Id: <20190429154321.21098-5-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190429154321.21098-1-giovanni.cabiddu@intel.com>
References: <20190429154321.21098-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

If an invalid key is provided as input to the setkey function, the
function always failed returning -ENOMEM rather than -EINVAL.
Furthermore, if setkey was called multiple times with an invalid key,
the device instance was getting leaked.

This patch fixes the error paths in the setkey functions by returning
the correct error code in case of error and freeing all the resources
allocated in this function in case of failure.

This problem was found with by the new extra run-time crypto self test.

Reviewed-by: Conor Mcloughlin <conor.mcloughlin@intel.com>
Tested-by: Sergey Portnoy <sergey.portnoy@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/qat_algs.c | 173 ++++++++++++++---------
 1 file changed, 108 insertions(+), 65 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 5ca5cf9f6be5..f9a46918c9d1 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -595,45 +595,52 @@ static int qat_alg_ablkcipher_init_sessions(struct qat_alg_ablkcipher_ctx *ctx,
 	return -EINVAL;
 }
 
-static int qat_alg_aead_setkey(struct crypto_aead *tfm, const uint8_t *key,
+static int qat_alg_aead_rekey(struct crypto_aead *tfm, const uint8_t *key,
+			      unsigned int keylen)
+{
+	struct qat_alg_aead_ctx *ctx = crypto_aead_ctx(tfm);
+
+	memset(ctx->enc_cd, 0, sizeof(*ctx->enc_cd));
+	memset(ctx->dec_cd, 0, sizeof(*ctx->dec_cd));
+	memset(&ctx->enc_fw_req, 0, sizeof(ctx->enc_fw_req));
+	memset(&ctx->dec_fw_req, 0, sizeof(ctx->dec_fw_req));
+
+	return qat_alg_aead_init_sessions(tfm, key, keylen,
+					  ICP_QAT_HW_CIPHER_CBC_MODE);
+}
+
+static int qat_alg_aead_newkey(struct crypto_aead *tfm, const uint8_t *key,
 			       unsigned int keylen)
 {
 	struct qat_alg_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct qat_crypto_instance *inst = NULL;
+	int node = get_current_node();
 	struct device *dev;
+	int ret;
 
-	if (ctx->enc_cd) {
-		/* rekeying */
-		dev = &GET_DEV(ctx->inst->accel_dev);
-		memset(ctx->enc_cd, 0, sizeof(*ctx->enc_cd));
-		memset(ctx->dec_cd, 0, sizeof(*ctx->dec_cd));
-		memset(&ctx->enc_fw_req, 0, sizeof(ctx->enc_fw_req));
-		memset(&ctx->dec_fw_req, 0, sizeof(ctx->dec_fw_req));
-	} else {
-		/* new key */
-		int node = get_current_node();
-		struct qat_crypto_instance *inst =
-				qat_crypto_get_instance_node(node);
-		if (!inst) {
-			return -EINVAL;
-		}
-
-		dev = &GET_DEV(inst->accel_dev);
-		ctx->inst = inst;
-		ctx->enc_cd = dma_alloc_coherent(dev, sizeof(*ctx->enc_cd),
-						 &ctx->enc_cd_paddr,
-						 GFP_ATOMIC);
-		if (!ctx->enc_cd) {
-			return -ENOMEM;
-		}
-		ctx->dec_cd = dma_alloc_coherent(dev, sizeof(*ctx->dec_cd),
-						 &ctx->dec_cd_paddr,
-						 GFP_ATOMIC);
-		if (!ctx->dec_cd) {
-			goto out_free_enc;
-		}
+	inst = qat_crypto_get_instance_node(node);
+	if (!inst)
+		return -EINVAL;
+	dev = &GET_DEV(inst->accel_dev);
+	ctx->inst = inst;
+	ctx->enc_cd = dma_alloc_coherent(dev, sizeof(*ctx->enc_cd),
+					 &ctx->enc_cd_paddr,
+					 GFP_ATOMIC);
+	if (!ctx->enc_cd) {
+		ret = -ENOMEM;
+		goto out_free_inst;
+	}
+	ctx->dec_cd = dma_alloc_coherent(dev, sizeof(*ctx->dec_cd),
+					 &ctx->dec_cd_paddr,
+					 GFP_ATOMIC);
+	if (!ctx->dec_cd) {
+		ret = -ENOMEM;
+		goto out_free_enc;
 	}
-	if (qat_alg_aead_init_sessions(tfm, key, keylen,
-				       ICP_QAT_HW_CIPHER_CBC_MODE))
+
+	ret = qat_alg_aead_init_sessions(tfm, key, keylen,
+					 ICP_QAT_HW_CIPHER_CBC_MODE);
+	if (ret)
 		goto out_free_all;
 
 	return 0;
@@ -648,7 +655,21 @@ static int qat_alg_aead_setkey(struct crypto_aead *tfm, const uint8_t *key,
 	dma_free_coherent(dev, sizeof(struct qat_alg_cd),
 			  ctx->enc_cd, ctx->enc_cd_paddr);
 	ctx->enc_cd = NULL;
-	return -ENOMEM;
+out_free_inst:
+	ctx->inst = NULL;
+	qat_crypto_put_instance(inst);
+	return ret;
+}
+
+static int qat_alg_aead_setkey(struct crypto_aead *tfm, const uint8_t *key,
+			       unsigned int keylen)
+{
+	struct qat_alg_aead_ctx *ctx = crypto_aead_ctx(tfm);
+
+	if (ctx->enc_cd)
+		return qat_alg_aead_rekey(tfm, key, keylen);
+	else
+		return qat_alg_aead_newkey(tfm, key, keylen);
 }
 
 static void qat_alg_free_bufl(struct qat_crypto_instance *inst,
@@ -930,42 +951,49 @@ static int qat_alg_aead_enc(struct aead_request *areq)
 	return -EINPROGRESS;
 }
 
-static int qat_alg_ablkcipher_setkey(struct crypto_ablkcipher *tfm,
+static int qat_alg_ablkcipher_rekey(struct qat_alg_ablkcipher_ctx *ctx,
+				    const u8 *key, unsigned int keylen,
+				    int mode)
+{
+	memset(ctx->enc_cd, 0, sizeof(*ctx->enc_cd));
+	memset(ctx->dec_cd, 0, sizeof(*ctx->dec_cd));
+	memset(&ctx->enc_fw_req, 0, sizeof(ctx->enc_fw_req));
+	memset(&ctx->dec_fw_req, 0, sizeof(ctx->dec_fw_req));
+
+	return qat_alg_ablkcipher_init_sessions(ctx, key, keylen, mode);
+}
+
+static int qat_alg_ablkcipher_newkey(struct qat_alg_ablkcipher_ctx *ctx,
 				     const u8 *key, unsigned int keylen,
 				     int mode)
 {
-	struct qat_alg_ablkcipher_ctx *ctx = crypto_ablkcipher_ctx(tfm);
+	struct qat_crypto_instance *inst = NULL;
 	struct device *dev;
+	int node = get_current_node();
+	int ret;
 
-	if (ctx->enc_cd) {
-		/* rekeying */
-		dev = &GET_DEV(ctx->inst->accel_dev);
-		memset(ctx->enc_cd, 0, sizeof(*ctx->enc_cd));
-		memset(ctx->dec_cd, 0, sizeof(*ctx->dec_cd));
-		memset(&ctx->enc_fw_req, 0, sizeof(ctx->enc_fw_req));
-		memset(&ctx->dec_fw_req, 0, sizeof(ctx->dec_fw_req));
-	} else {
-		/* new key */
-		int node = get_current_node();
-		struct qat_crypto_instance *inst =
-				qat_crypto_get_instance_node(node);
-		if (!inst)
-			return -EINVAL;
-
-		dev = &GET_DEV(inst->accel_dev);
-		ctx->inst = inst;
-		ctx->enc_cd = dma_alloc_coherent(dev, sizeof(*ctx->enc_cd),
-						 &ctx->enc_cd_paddr,
-						 GFP_ATOMIC);
-		if (!ctx->enc_cd)
-			return -ENOMEM;
-		ctx->dec_cd = dma_alloc_coherent(dev, sizeof(*ctx->dec_cd),
-						 &ctx->dec_cd_paddr,
-						 GFP_ATOMIC);
-		if (!ctx->dec_cd)
-			goto out_free_enc;
+	inst = qat_crypto_get_instance_node(node);
+	if (!inst)
+		return -EINVAL;
+	dev = &GET_DEV(inst->accel_dev);
+	ctx->inst = inst;
+	ctx->enc_cd = dma_alloc_coherent(dev, sizeof(*ctx->enc_cd),
+					 &ctx->enc_cd_paddr,
+					 GFP_ATOMIC);
+	if (!ctx->enc_cd) {
+		ret = -ENOMEM;
+		goto out_free_instance;
+	}
+	ctx->dec_cd = dma_alloc_coherent(dev, sizeof(*ctx->dec_cd),
+					 &ctx->dec_cd_paddr,
+					 GFP_ATOMIC);
+	if (!ctx->dec_cd) {
+		ret = -ENOMEM;
+		goto out_free_enc;
 	}
-	if (qat_alg_ablkcipher_init_sessions(ctx, key, keylen, mode))
+
+	ret = qat_alg_ablkcipher_init_sessions(ctx, key, keylen, mode);
+	if (ret)
 		goto out_free_all;
 
 	return 0;
@@ -980,7 +1008,22 @@ static int qat_alg_ablkcipher_setkey(struct crypto_ablkcipher *tfm,
 	dma_free_coherent(dev, sizeof(*ctx->enc_cd),
 			  ctx->enc_cd, ctx->enc_cd_paddr);
 	ctx->enc_cd = NULL;
-	return -ENOMEM;
+out_free_instance:
+	ctx->inst = NULL;
+	qat_crypto_put_instance(inst);
+	return ret;
+}
+
+static int qat_alg_ablkcipher_setkey(struct crypto_ablkcipher *tfm,
+				     const u8 *key, unsigned int keylen,
+				     int mode)
+{
+	struct qat_alg_ablkcipher_ctx *ctx = crypto_ablkcipher_ctx(tfm);
+
+	if (ctx->enc_cd)
+		return qat_alg_ablkcipher_rekey(ctx, key, keylen, mode);
+	else
+		return qat_alg_ablkcipher_newkey(ctx, key, keylen, mode);
 }
 
 static int qat_alg_ablkcipher_cbc_setkey(struct crypto_ablkcipher *tfm,
-- 
2.20.1

