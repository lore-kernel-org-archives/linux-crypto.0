Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21C1DC47087
	for <linux-crypto@archiver.kernel.org>; Fri, 28 May 2021 11:45:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB47F613DA
	for <linux-crypto@archiver.kernel.org>; Fri, 28 May 2021 11:45:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235898AbhE1Lqv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 May 2021 07:46:51 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:2396 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235690AbhE1Lqt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 May 2021 07:46:49 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Fs2p43dvhz65hN;
        Fri, 28 May 2021 19:41:32 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 28 May 2021 19:45:11 +0800
Received: from huawei.com (10.67.165.24) by dggpeml500012.china.huawei.com
 (7.185.36.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 28 May
 2021 19:45:11 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <yekai13@huawei.com>
Subject: [PATCH 1/3] crypto: hisilicon/sec - add new skcipher mode for SEC
Date:   Fri, 28 May 2021 19:42:04 +0800
Message-ID: <1622202126-19237-2-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1622202126-19237-1-git-send-email-yekai13@huawei.com>
References: <1622202126-19237-1-git-send-email-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500012.china.huawei.com (7.185.36.15)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add new skcipher algorithms for Kunpeng930 SEC:
OFB(AES), CFB(AES), CTR(AES),
OFB(SM4), CFB(SM4), CTR(SM4).

Signed-off-by: Kai Ye <yekai13@huawei.com>
Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 103 +++++++++++++++++++++++++----
 drivers/crypto/hisilicon/sec2/sec_crypto.h |   3 +
 2 files changed, 94 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index d9ab503..b399315 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -78,6 +78,9 @@
 #define SEC_SQE_CFLAG		2
 #define SEC_SQE_AEAD_FLAG	3
 #define SEC_SQE_DONE		0x1
+#define MAX_INPUT_DATA_LEN	0xFFFE00
+#define BITS_MASK		0xFF
+#define BYTE_BITS		0x8
 
 /* Get an en/de-cipher queue cyclically to balance load over queues of TFM */
 static inline int sec_alloc_queue_id(struct sec_ctx *ctx, struct sec_req *req)
@@ -751,12 +754,16 @@ static int sec_setkey_##name(struct crypto_skcipher *tfm, const u8 *key,\
 GEN_SEC_SETKEY_FUNC(aes_ecb, SEC_CALG_AES, SEC_CMODE_ECB)
 GEN_SEC_SETKEY_FUNC(aes_cbc, SEC_CALG_AES, SEC_CMODE_CBC)
 GEN_SEC_SETKEY_FUNC(aes_xts, SEC_CALG_AES, SEC_CMODE_XTS)
-
+GEN_SEC_SETKEY_FUNC(aes_ofb, SEC_CALG_AES, SEC_CMODE_OFB)
+GEN_SEC_SETKEY_FUNC(aes_cfb, SEC_CALG_AES, SEC_CMODE_CFB)
+GEN_SEC_SETKEY_FUNC(aes_ctr, SEC_CALG_AES, SEC_CMODE_CTR)
 GEN_SEC_SETKEY_FUNC(3des_ecb, SEC_CALG_3DES, SEC_CMODE_ECB)
 GEN_SEC_SETKEY_FUNC(3des_cbc, SEC_CALG_3DES, SEC_CMODE_CBC)
-
 GEN_SEC_SETKEY_FUNC(sm4_xts, SEC_CALG_SM4, SEC_CMODE_XTS)
 GEN_SEC_SETKEY_FUNC(sm4_cbc, SEC_CALG_SM4, SEC_CMODE_CBC)
+GEN_SEC_SETKEY_FUNC(sm4_ofb, SEC_CALG_SM4, SEC_CMODE_OFB)
+GEN_SEC_SETKEY_FUNC(sm4_cfb, SEC_CALG_SM4, SEC_CMODE_CFB)
+GEN_SEC_SETKEY_FUNC(sm4_ctr, SEC_CALG_SM4, SEC_CMODE_CTR)
 
 static int sec_cipher_pbuf_map(struct sec_ctx *ctx, struct sec_req *req,
 			struct scatterlist *src)
@@ -1154,6 +1161,17 @@ static int sec_skcipher_bd_fill_v3(struct sec_ctx *ctx, struct sec_req *req)
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
@@ -1177,10 +1195,17 @@ static void sec_update_iv(struct sec_req *req, enum sec_alg_type alg_type)
 		cryptlen = aead_req->cryptlen;
 	}
 
-	sz = sg_pcopy_to_buffer(sgl, sg_nents(sgl), iv, iv_size,
-				cryptlen - iv_size);
-	if (unlikely(sz != iv_size))
-		dev_err(req->ctx->dev, "copy output iv error!\n");
+	if (req->ctx->c_ctx.c_mode == SEC_CMODE_CBC) {
+		sz = sg_pcopy_to_buffer(sgl, sg_nents(sgl), iv, iv_size,
+					cryptlen - iv_size);
+		if (unlikely(sz != iv_size))
+			dev_err(req->ctx->dev, "copy output iv error!\n");
+	} else {
+		sz = cryptlen / iv_size;
+		if (cryptlen % iv_size)
+			sz += 1;
+		ctr_iv_inc(iv, iv_size, sz);
+	}
 }
 
 static struct sec_req *sec_back_req_clear(struct sec_ctx *ctx,
@@ -1211,8 +1236,9 @@ static void sec_skcipher_callback(struct sec_ctx *ctx, struct sec_req *req,
 
 	sec_free_req_id(req);
 
-	/* IV output at encrypto of CBC mode */
-	if (!err && ctx->c_ctx.c_mode == SEC_CMODE_CBC && req->c_req.encrypt)
+	/* IV output at encrypto of CBC/CTR mode */
+	if (!err && (ctx->c_ctx.c_mode == SEC_CMODE_CBC ||
+	    ctx->c_ctx.c_mode == SEC_CMODE_CTR) && req->c_req.encrypt)
 		sec_update_iv(req, SEC_SKCIPHER);
 
 	while (1) {
@@ -1422,7 +1448,8 @@ static int sec_process(struct sec_ctx *ctx, struct sec_req *req)
 		goto err_uninit_req;
 
 	/* Output IV as decrypto */
-	if (ctx->c_ctx.c_mode == SEC_CMODE_CBC && !req->c_req.encrypt)
+	if (!req->c_req.encrypt && (ctx->c_ctx.c_mode == SEC_CMODE_CBC ||
+	    ctx->c_ctx.c_mode == SEC_CMODE_CTR))
 		sec_update_iv(req, ctx->alg_type);
 
 	ret = ctx->req_op->bd_send(ctx, req);
@@ -1634,6 +1661,14 @@ static int sec_skcipher_cryptlen_ckeck(struct sec_ctx *ctx,
 			ret = -EINVAL;
 		}
 		break;
+	case SEC_CMODE_CFB:
+	case SEC_CMODE_OFB:
+	case SEC_CMODE_CTR:
+		if (unlikely(ctx->sec->qm.ver < QM_HW_V3)) {
+			dev_err(dev, "skcipher HW version error!\n");
+			ret = -EINVAL;
+		}
+		break;
 	default:
 		ret = -EINVAL;
 	}
@@ -1647,7 +1682,8 @@ static int sec_skcipher_param_check(struct sec_ctx *ctx, struct sec_req *sreq)
 	struct device *dev = ctx->dev;
 	u8 c_alg = ctx->c_ctx.c_alg;
 
-	if (unlikely(!sk_req->src || !sk_req->dst)) {
+	if (unlikely(!sk_req->src || !sk_req->dst ||
+		     sk_req->cryptlen > MAX_INPUT_DATA_LEN)) {
 		dev_err(dev, "skcipher input param error!\n");
 		return -EINVAL;
 	}
@@ -1762,6 +1798,32 @@ static struct skcipher_alg sec_skciphers[] = {
 			 AES_BLOCK_SIZE, AES_BLOCK_SIZE)
 };
 
+static struct skcipher_alg sec_skciphers_v3[] = {
+	SEC_SKCIPHER_ALG("ofb(aes)", sec_setkey_aes_ofb,
+			 AES_MIN_KEY_SIZE, AES_MAX_KEY_SIZE,
+			 SEC_MIN_BLOCK_SZ, AES_BLOCK_SIZE)
+
+	SEC_SKCIPHER_ALG("cfb(aes)", sec_setkey_aes_cfb,
+			 AES_MIN_KEY_SIZE, AES_MAX_KEY_SIZE,
+			 SEC_MIN_BLOCK_SZ, AES_BLOCK_SIZE)
+
+	SEC_SKCIPHER_ALG("ctr(aes)", sec_setkey_aes_ctr,
+			 AES_MIN_KEY_SIZE, AES_MAX_KEY_SIZE,
+			 SEC_MIN_BLOCK_SZ, AES_BLOCK_SIZE)
+
+	SEC_SKCIPHER_ALG("ofb(sm4)", sec_setkey_sm4_ofb,
+			 AES_MIN_KEY_SIZE, AES_MIN_KEY_SIZE,
+			 SEC_MIN_BLOCK_SZ, AES_BLOCK_SIZE)
+
+	SEC_SKCIPHER_ALG("cfb(sm4)", sec_setkey_sm4_cfb,
+			 AES_MIN_KEY_SIZE, AES_MIN_KEY_SIZE,
+			 SEC_MIN_BLOCK_SZ, AES_BLOCK_SIZE)
+
+	SEC_SKCIPHER_ALG("ctr(sm4)", sec_setkey_sm4_ctr,
+			 AES_MIN_KEY_SIZE, AES_MIN_KEY_SIZE,
+			 SEC_MIN_BLOCK_SZ, AES_BLOCK_SIZE)
+};
+
 static int sec_aead_param_check(struct sec_ctx *ctx, struct sec_req *sreq)
 {
 	struct aead_request *req = sreq->aead_req.aead_req;
@@ -1878,15 +1940,32 @@ int sec_register_to_crypto(struct hisi_qm *qm)
 	if (ret)
 		return ret;
 
+	if (qm->ver > QM_HW_V2) {
+		ret = crypto_register_skciphers(sec_skciphers_v3,
+						ARRAY_SIZE(sec_skciphers_v3));
+		if (ret)
+			goto reg_skcipher_fail;
+	}
 	ret = crypto_register_aeads(sec_aeads, ARRAY_SIZE(sec_aeads));
 	if (ret)
-		crypto_unregister_skciphers(sec_skciphers,
-					    ARRAY_SIZE(sec_skciphers));
+		goto reg_aead_fail;
+	return ret;
+
+reg_aead_fail:
+	if (qm->ver > QM_HW_V2)
+		crypto_unregister_skciphers(sec_skciphers_v3,
+					    ARRAY_SIZE(sec_skciphers_v3));
+reg_skcipher_fail:
+	crypto_unregister_skciphers(sec_skciphers,
+				    ARRAY_SIZE(sec_skciphers));
 	return ret;
 }
 
 void sec_unregister_from_crypto(struct hisi_qm *qm)
 {
+	if (qm->ver > QM_HW_V2)
+		crypto_unregister_skciphers(sec_skciphers_v3,
+					    ARRAY_SIZE(sec_skciphers_v3));
 	crypto_unregister_skciphers(sec_skciphers,
 				    ARRAY_SIZE(sec_skciphers));
 	crypto_unregister_aeads(sec_aeads, ARRAY_SIZE(sec_aeads));
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.h b/drivers/crypto/hisilicon/sec2/sec_crypto.h
index 163e813..c9bfe75 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.h
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.h
@@ -7,6 +7,7 @@
 #define SEC_IV_SIZE		24
 #define SEC_MAX_KEY_SIZE	64
 #define SEC_COMM_SCENE		0
+#define SEC_MIN_BLOCK_SZ	1
 
 enum sec_calg {
 	SEC_CALG_3DES = 0x1,
@@ -29,6 +30,8 @@ enum sec_mac_len {
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

