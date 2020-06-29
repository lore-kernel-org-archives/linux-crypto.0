Return-Path: <SRS0=qXKu=AK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0B70C433E3
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jun 2020 19:41:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C99B7207F9
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jun 2020 19:41:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbgF2Tlj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jun 2020 15:41:39 -0400
Received: from mga07.intel.com ([134.134.136.100]:58002 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387855AbgF2Tkt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:49 -0400
IronPort-SDR: 2O5etOzmuVoO9ICmNkVKwaiP6OKZo7cSlU1msHCnkW8shNV16+hj8TORJdZQEbeoeLaB04pZjm
 JGGHZhfB1m2w==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="211091703"
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="211091703"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 10:16:40 -0700
IronPort-SDR: WMiSeiuHUgZeFbfW0+caOsOqokkegT4puWofXHvZQ3X0jXi9qNUqZ6t6EJ7HGRJRwlA7pmOSpu
 +1XGqEBG9hxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="264891348"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga007.fm.intel.com with ESMTP; 29 Jun 2020 10:16:39 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v3 4/4] crypto: qat - fallback for xts with 192 bit keys
Date:   Mon, 29 Jun 2020 18:16:20 +0100
Message-Id: <20200629171620.2989-5-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200629171620.2989-1-giovanni.cabiddu@intel.com>
References: <20200629171620.2989-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Forward requests to another provider if the key length for AES-XTS is
192 bits as this is not supported by the QAT accelerators.

This fixes the following issue reported with the option
CONFIG_CRYPTO_MANAGER_EXTRA_TESTS:

  alg: skcipher: qat_aes_xts setkey failed on test vector "random: len=3204 klen=48"; expected_error=0, actual_error=-22, flags=0x1

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/qat_algs.c | 68 ++++++++++++++++++++++--
 1 file changed, 65 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 77bdff0118f7..2a353e249e1c 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -88,6 +88,8 @@ struct qat_alg_skcipher_ctx {
 	struct icp_qat_fw_la_bulk_req enc_fw_req;
 	struct icp_qat_fw_la_bulk_req dec_fw_req;
 	struct qat_crypto_instance *inst;
+	struct crypto_skcipher *ftfm;
+	bool fallback;
 };
 
 static int qat_get_inter_state_size(enum icp_qat_hw_auth_algo qat_hash_alg)
@@ -994,12 +996,25 @@ static int qat_alg_skcipher_ctr_setkey(struct crypto_skcipher *tfm,
 static int qat_alg_skcipher_xts_setkey(struct crypto_skcipher *tfm,
 				       const u8 *key, unsigned int keylen)
 {
+	struct qat_alg_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
 	int ret;
 
 	ret = xts_verify_key(tfm, key, keylen);
 	if (ret)
 		return ret;
 
+	if (keylen >> 1 == AES_KEYSIZE_192) {
+		ret = crypto_skcipher_setkey(ctx->ftfm, key, keylen);
+		if (ret)
+			return ret;
+
+		ctx->fallback = true;
+
+		return 0;
+	}
+
+	ctx->fallback = false;
+
 	return qat_alg_skcipher_setkey(tfm, key, keylen,
 				       ICP_QAT_HW_CIPHER_XTS_MODE);
 }
@@ -1066,9 +1081,19 @@ static int qat_alg_skcipher_blk_encrypt(struct skcipher_request *req)
 
 static int qat_alg_skcipher_xts_encrypt(struct skcipher_request *req)
 {
+	struct crypto_skcipher *stfm = crypto_skcipher_reqtfm(req);
+	struct qat_alg_skcipher_ctx *ctx = crypto_skcipher_ctx(stfm);
+	struct skcipher_request *nreq = skcipher_request_ctx(req);
+
 	if (req->cryptlen < XTS_BLOCK_SIZE)
 		return -EINVAL;
 
+	if (ctx->fallback) {
+		memcpy(nreq, req, sizeof(*req));
+		skcipher_request_set_tfm(nreq, ctx->ftfm);
+		return crypto_skcipher_encrypt(nreq);
+	}
+
 	return qat_alg_skcipher_encrypt(req);
 }
 
@@ -1134,9 +1159,19 @@ static int qat_alg_skcipher_blk_decrypt(struct skcipher_request *req)
 
 static int qat_alg_skcipher_xts_decrypt(struct skcipher_request *req)
 {
+	struct crypto_skcipher *stfm = crypto_skcipher_reqtfm(req);
+	struct qat_alg_skcipher_ctx *ctx = crypto_skcipher_ctx(stfm);
+	struct skcipher_request *nreq = skcipher_request_ctx(req);
+
 	if (req->cryptlen < XTS_BLOCK_SIZE)
 		return -EINVAL;
 
+	if (ctx->fallback) {
+		memcpy(nreq, req, sizeof(*req));
+		skcipher_request_set_tfm(nreq, ctx->ftfm);
+		return crypto_skcipher_decrypt(nreq);
+	}
+
 	return qat_alg_skcipher_decrypt(req);
 }
 
@@ -1200,6 +1235,24 @@ static int qat_alg_skcipher_init_tfm(struct crypto_skcipher *tfm)
 	return 0;
 }
 
+static int qat_alg_skcipher_init_xts_tfm(struct crypto_skcipher *tfm)
+{
+	struct qat_alg_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
+	int reqsize;
+
+	ctx->ftfm = crypto_alloc_skcipher("xts(aes)", 0,
+					  CRYPTO_ALG_NEED_FALLBACK);
+	if (IS_ERR(ctx->ftfm))
+		return PTR_ERR(ctx->ftfm);
+
+	reqsize = max(sizeof(struct qat_crypto_request),
+		      sizeof(struct skcipher_request) +
+		      crypto_skcipher_reqsize(ctx->ftfm));
+	crypto_skcipher_set_reqsize(tfm, reqsize);
+
+	return 0;
+}
+
 static void qat_alg_skcipher_exit_tfm(struct crypto_skcipher *tfm)
 {
 	struct qat_alg_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
@@ -1227,6 +1280,15 @@ static void qat_alg_skcipher_exit_tfm(struct crypto_skcipher *tfm)
 	qat_crypto_put_instance(inst);
 }
 
+static void qat_alg_skcipher_exit_xts_tfm(struct crypto_skcipher *tfm)
+{
+	struct qat_alg_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	if (ctx->ftfm)
+		crypto_free_skcipher(ctx->ftfm);
+
+	qat_alg_skcipher_exit_tfm(tfm);
+}
 
 static struct aead_alg qat_aeads[] = { {
 	.base = {
@@ -1321,14 +1383,14 @@ static struct skcipher_alg qat_skciphers[] = { {
 	.base.cra_name = "xts(aes)",
 	.base.cra_driver_name = "qat_aes_xts",
 	.base.cra_priority = 4001,
-	.base.cra_flags = CRYPTO_ALG_ASYNC,
+	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
 	.base.cra_blocksize = AES_BLOCK_SIZE,
 	.base.cra_ctxsize = sizeof(struct qat_alg_skcipher_ctx),
 	.base.cra_alignmask = 0,
 	.base.cra_module = THIS_MODULE,
 
-	.init = qat_alg_skcipher_init_tfm,
-	.exit = qat_alg_skcipher_exit_tfm,
+	.init = qat_alg_skcipher_init_xts_tfm,
+	.exit = qat_alg_skcipher_exit_xts_tfm,
 	.setkey = qat_alg_skcipher_xts_setkey,
 	.decrypt = qat_alg_skcipher_xts_decrypt,
 	.encrypt = qat_alg_skcipher_xts_encrypt,
-- 
2.26.2

