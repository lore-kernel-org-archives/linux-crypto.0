Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EACFC4361B
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Dec 2020 11:15:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1159123D98
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Dec 2020 11:15:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389336AbgLJLMr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Dec 2020 06:12:47 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9578 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389126AbgLJLMi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Dec 2020 06:12:38 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CsB742fNpzM2qn;
        Thu, 10 Dec 2020 19:11:12 +0800 (CST)
Received: from huawei.com (10.67.165.24) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Thu, 10 Dec 2020
 19:11:54 +0800
From:   Longfang Liu <liulongfang@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 3/6] crypto: hisilicon/sec - add new skcipher mode for SEC
Date:   Thu, 10 Dec 2020 19:10:04 +0800
Message-ID: <1607598607-8728-4-git-send-email-liulongfang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1607598607-8728-1-git-send-email-liulongfang@huawei.com>
References: <1607598607-8728-1-git-send-email-liulongfang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add new skcipher algorithms for Kunpeng930 SEC:
OFB(AES), CFB(AES), CTR(AES),
OFB(SM4), CFB(SM4), CTR(SM4).

Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
Signed-off-by: Longfang Liu <liulongfang@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 88 +++++++++++++++++++++++++++---
 drivers/crypto/hisilicon/sec2/sec_crypto.h |  2 +
 2 files changed, 82 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 2d338a3..1fcd2e5 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -81,6 +81,8 @@
 #define SEC_SQE_CFLAG		2
 #define SEC_SQE_AEAD_FLAG	3
 #define SEC_SQE_DONE		0x1
+#define BITS_MASK		0xFF
+#define BYTE_BITS		0x8
 
 /* Get an en/de-cipher queue cyclically to balance load over queues of TFM */
 static inline int sec_alloc_queue_id(struct sec_ctx *ctx, struct sec_req *req)
@@ -1117,6 +1119,17 @@ static int sec_skcipher_bd_fill_v3(struct sec_ctx *ctx, struct sec_req *req)
 	return 0;
 }
 
+/* increment counter (128-bit int) */
+static void ctr_iv_inc(__u8 *counter, __u8 bits, __u32 nums)
+{
+	do {
+		--bits;
+		nums += counter[bits];
+		counter[bits] = nums & BITS_MASK;
+		nums >>= BYTE_BITS;
+	} while (bits && nums);
+}
+
 static void sec_update_iv(struct sec_req *req, enum sec_alg_type alg_type)
 {
 	struct aead_request *aead_req = req->aead_req.aead_req;
@@ -1140,10 +1153,17 @@ static void sec_update_iv(struct sec_req *req, enum sec_alg_type alg_type)
 		cryptlen = aead_req->cryptlen;
 	}
 
-	sz = sg_pcopy_to_buffer(sgl, sg_nents(sgl), iv, iv_size,
+	if (req->ctx->c_ctx.c_mode == SEC_CMODE_CBC) {
+		sz = sg_pcopy_to_buffer(sgl, sg_nents(sgl), iv, iv_size,
 				cryptlen - iv_size);
-	if (unlikely(sz != iv_size))
-		dev_err(SEC_CTX_DEV(req->ctx), "copy output iv error!\n");
+		if (unlikely(sz != iv_size))
+			dev_err(SEC_CTX_DEV(req->ctx), "copy output iv error!\n");
+	} else {
+		sz = cryptlen / iv_size;
+		if (cryptlen % iv_size)
+			sz += 1;
+		ctr_iv_inc(iv, iv_size, sz);
+	}
 }
 
 static struct sec_req *sec_back_req_clear(struct sec_ctx *ctx,
@@ -1174,8 +1194,9 @@ static void sec_skcipher_callback(struct sec_ctx *ctx, struct sec_req *req,
 
 	sec_free_req_id(req);
 
-	/* IV output at encrypto of CBC mode */
-	if (!err && ctx->c_ctx.c_mode == SEC_CMODE_CBC && req->c_req.encrypt)
+	/* IV output at encrypto of CBC/CTR mode */
+	if (!err && (ctx->c_ctx.c_mode == SEC_CMODE_CBC ||
+	    ctx->c_ctx.c_mode == SEC_CMODE_CTR) && req->c_req.encrypt)
 		sec_update_iv(req, SEC_SKCIPHER);
 
 	while (1) {
@@ -1384,7 +1405,8 @@ static int sec_process(struct sec_ctx *ctx, struct sec_req *req)
 		goto err_uninit_req;
 
 	/* Output IV as decrypto */
-	if (ctx->c_ctx.c_mode == SEC_CMODE_CBC && !req->c_req.encrypt)
+	if (!req->c_req.encrypt && (ctx->c_ctx.c_mode == SEC_CMODE_CBC ||
+	    ctx->c_ctx.c_mode == SEC_CMODE_CTR))
 		sec_update_iv(req, ctx->alg_type);
 
 	ret = ctx->req_op->bd_send(ctx, req);
@@ -1579,8 +1601,10 @@ static int sec_skcipher_param_check(struct sec_ctx *ctx, struct sec_req *sreq)
 	struct skcipher_request *sk_req = sreq->c_req.sk_req;
 	struct device *dev = SEC_CTX_DEV(ctx);
 	u8 c_alg = ctx->c_ctx.c_alg;
+	u8 c_mode = ctx->c_ctx.c_mode;
 
-	if (unlikely(!sk_req->src || !sk_req->dst)) {
+	if (unlikely(!sk_req->src || !sk_req->dst ||
+		sk_req->cryptlen > MAX_INPUT_DATA_LEN)) {
 		dev_err(dev, "skcipher input param error!\n");
 		return -EINVAL;
 	}
@@ -1598,7 +1622,8 @@ static int sec_skcipher_param_check(struct sec_ctx *ctx, struct sec_req *sreq)
 		}
 		return 0;
 	} else if (c_alg == SEC_CALG_AES || c_alg == SEC_CALG_SM4) {
-		if (unlikely(sk_req->cryptlen & (AES_BLOCK_SIZE - 1))) {
+		if (unlikely(sk_req->cryptlen & (AES_BLOCK_SIZE - 1) &&
+		    c_mode == SEC_CMODE_CBC)) {
 			dev_err(dev, "skcipher aes input length error!\n");
 			return -EINVAL;
 		}
@@ -1651,10 +1676,16 @@ static int sec_setkey_##name(struct crypto_skcipher *tfm,	        \
 GEN_SEC_SETKEY_FUNC(aes_ecb, SEC_CALG_AES, SEC_CMODE_ECB)
 GEN_SEC_SETKEY_FUNC(aes_cbc, SEC_CALG_AES, SEC_CMODE_CBC)
 GEN_SEC_SETKEY_FUNC(aes_xts, SEC_CALG_AES, SEC_CMODE_XTS)
+GEN_SEC_SETKEY_FUNC(aes_ofb, SEC_CALG_AES, SEC_CMODE_OFB)
+GEN_SEC_SETKEY_FUNC(aes_cfb, SEC_CALG_AES, SEC_CMODE_CFB)
+GEN_SEC_SETKEY_FUNC(aes_ctr, SEC_CALG_AES, SEC_CMODE_CTR)
 GEN_SEC_SETKEY_FUNC(3des_ecb, SEC_CALG_3DES, SEC_CMODE_ECB)
 GEN_SEC_SETKEY_FUNC(3des_cbc, SEC_CALG_3DES, SEC_CMODE_CBC)
 GEN_SEC_SETKEY_FUNC(sm4_xts, SEC_CALG_SM4, SEC_CMODE_XTS)
 GEN_SEC_SETKEY_FUNC(sm4_cbc, SEC_CALG_SM4, SEC_CMODE_CBC)
+GEN_SEC_SETKEY_FUNC(sm4_ofb, SEC_CALG_SM4, SEC_CMODE_OFB)
+GEN_SEC_SETKEY_FUNC(sm4_cfb, SEC_CALG_SM4, SEC_CMODE_CFB)
+GEN_SEC_SETKEY_FUNC(sm4_ctr, SEC_CALG_SM4, SEC_CMODE_CTR)
 
 #define SEC_SKCIPHER_ALG(sec_cra_name, sec_set_key, \
 	sec_min_key_size, sec_max_key_size, blk_size, iv_size)\
@@ -1710,6 +1741,32 @@ static struct skcipher_alg sec_skciphers[] = {
 			 AES_BLOCK_SIZE, AES_BLOCK_SIZE),
 };
 
+static struct skcipher_alg sec_skciphers_v3[] = {
+	SEC_SKCIPHER_ALG("ofb(aes)", sec_setkey_aes_ofb,
+			 AES_MIN_KEY_SIZE, AES_MAX_KEY_SIZE,
+			 AES_BLOCK_SIZE, AES_BLOCK_SIZE),
+
+	SEC_SKCIPHER_ALG("cfb(aes)", sec_setkey_aes_cfb,
+			 AES_MIN_KEY_SIZE, AES_MAX_KEY_SIZE,
+			 AES_BLOCK_SIZE, AES_BLOCK_SIZE),
+
+	SEC_SKCIPHER_ALG("ctr(aes)", sec_setkey_aes_ctr,
+			 AES_MIN_KEY_SIZE, AES_MAX_KEY_SIZE,
+			 AES_BLOCK_SIZE, AES_BLOCK_SIZE),
+
+	SEC_SKCIPHER_ALG("ofb(sm4)", sec_setkey_sm4_ofb,
+			 AES_MIN_KEY_SIZE, AES_MIN_KEY_SIZE,
+			 AES_BLOCK_SIZE, AES_BLOCK_SIZE),
+
+	SEC_SKCIPHER_ALG("cfb(sm4)", sec_setkey_sm4_cfb,
+			 AES_MIN_KEY_SIZE, AES_MIN_KEY_SIZE,
+			 AES_BLOCK_SIZE, AES_BLOCK_SIZE),
+
+	SEC_SKCIPHER_ALG("ctr(sm4)", sec_setkey_sm4_ctr,
+			 AES_MIN_KEY_SIZE, AES_MIN_KEY_SIZE,
+			 AES_BLOCK_SIZE, AES_BLOCK_SIZE)
+};
+
 static int sec_aead_param_check(struct sec_ctx *ctx, struct sec_req *sreq)
 {
 	u8 c_alg = ctx->c_ctx.c_alg;
@@ -1825,12 +1882,23 @@ int sec_register_to_crypto(struct hisi_qm *qm)
 	if (ret)
 		return ret;
 
+	if (qm->ver > QM_HW_V2) {
+		ret = crypto_register_skciphers(sec_skciphers_v3,
+					ARRAY_SIZE(sec_skciphers_v3));
+		if (ret)
+			goto reg_skcipher_fail;
+	}
+
 	ret = crypto_register_aeads(sec_aeads, ARRAY_SIZE(sec_aeads));
 	if (ret)
 		goto reg_aead_fail;
 	return ret;
 
 reg_aead_fail:
+	if (qm->ver > QM_HW_V2)
+		crypto_unregister_skciphers(sec_skciphers_v3,
+					ARRAY_SIZE(sec_skciphers_v3));
+reg_skcipher_fail:
 	crypto_unregister_skciphers(sec_skciphers,
 					ARRAY_SIZE(sec_skciphers));
 	return ret;
@@ -1839,6 +1907,10 @@ int sec_register_to_crypto(struct hisi_qm *qm)
 void sec_unregister_from_crypto(struct hisi_qm *qm)
 {
 	crypto_unregister_aeads(sec_aeads, ARRAY_SIZE(sec_aeads));
+
+	if (qm->ver > QM_HW_V2)
+		crypto_unregister_skciphers(sec_skciphers_v3,
+					ARRAY_SIZE(sec_skciphers_v3));
 	crypto_unregister_skciphers(sec_skciphers,
 					ARRAY_SIZE(sec_skciphers));
 }
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.h b/drivers/crypto/hisilicon/sec2/sec_crypto.h
index e2250c6..90da1cc 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.h
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.h
@@ -29,6 +29,8 @@ enum sec_mac_len {
 enum sec_cmode {
 	SEC_CMODE_ECB    = 0x0,
 	SEC_CMODE_CBC    = 0x1,
+	SEC_CMODE_CFB    = 0x2,
+	SEC_CMODE_OFB    = 0x3,
 	SEC_CMODE_CTR    = 0x4,
 	SEC_CMODE_XTS    = 0x7,
 };
-- 
2.8.1

