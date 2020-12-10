Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96FC5C0018C
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Dec 2020 11:13:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5866F23DE4
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Dec 2020 11:13:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389130AbgLJLNA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Dec 2020 06:13:00 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8741 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389335AbgLJLMv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Dec 2020 06:12:51 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CsB7962xjzknVc;
        Thu, 10 Dec 2020 19:11:17 +0800 (CST)
Received: from huawei.com (10.67.165.24) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Thu, 10 Dec 2020
 19:11:54 +0800
From:   Longfang Liu <liulongfang@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 4/6] crypto: hisilicon/sec - add new AEAD mode for SEC
Date:   Thu, 10 Dec 2020 19:10:05 +0800
Message-ID: <1607598607-8728-5-git-send-email-liulongfang@huawei.com>
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

Add new AEAD algorithms to SEC:
CCM(AES), GCM(AES), CCM(SM4), GCM(SM4).

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec.h        |   4 +
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 382 ++++++++++++++++++++++++-----
 drivers/crypto/hisilicon/sec2/sec_crypto.h |   5 +
 3 files changed, 329 insertions(+), 62 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
index 7c40f8a..74f7eeb 100644
--- a/drivers/crypto/hisilicon/sec2/sec.h
+++ b/drivers/crypto/hisilicon/sec2/sec.h
@@ -15,6 +15,8 @@ struct sec_alg_res {
 	dma_addr_t pbuf_dma;
 	u8 *c_ivin;
 	dma_addr_t c_ivin_dma;
+	u8 *a_ivin;
+	dma_addr_t a_ivin_dma;
 	u8 *out_mac;
 	dma_addr_t out_mac_dma;
 };
@@ -35,6 +37,8 @@ struct sec_cipher_req {
 struct sec_aead_req {
 	u8 *out_mac;
 	dma_addr_t out_mac_dma;
+	u8 *a_ivin;
+	dma_addr_t a_ivin_dma;
 	struct aead_request *aead_req;
 };
 
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 1fcd2e5..f09f4d7 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -81,9 +81,22 @@
 #define SEC_SQE_CFLAG		2
 #define SEC_SQE_AEAD_FLAG	3
 #define SEC_SQE_DONE		0x1
+#define MIN_MAC_LEN		4
+#define MAC_LEN_MASK		0x1U
+#define MAX_INPUT_DATA_LEN	0xFFFE00
 #define BITS_MASK		0xFF
 #define BYTE_BITS		0x8
 
+#define IV_CM_CAL_NUM		2
+#define IV_CL_MASK		0x7
+#define IV_FLAGS_OFFSET	0x6
+#define IV_CM_OFFSET		0x3
+#define IV_LAST_BYTE1		1
+#define IV_LAST_BYTE2		2
+#define IV_LAST_BYTE2_MASK	0xFF00
+#define IV_LAST_BYTE1_MASK	0xFF
+#define IV_CTR_INIT		1
+
 /* Get an en/de-cipher queue cyclically to balance load over queues of TFM */
 static inline int sec_alloc_queue_id(struct sec_ctx *ctx, struct sec_req *req)
 {
@@ -231,7 +244,9 @@ static void sec_req_cb(struct hisi_qp *qp, void *resp)
 		atomic64_inc(&dfx->done_flag_cnt);
 	}
 
-	if (ctx->alg_type == SEC_AEAD && !req->c_req.encrypt)
+	if (ctx->alg_type == SEC_AEAD && !req->c_req.encrypt
+		&& ctx->c_ctx.c_mode != SEC_CMODE_CCM
+		&& ctx->c_ctx.c_mode != SEC_CMODE_GCM)
 		err = sec_aead_verify(req);
 
 	atomic64_inc(&dfx->recv_cnt);
@@ -300,6 +315,30 @@ static void sec_free_civ_resource(struct device *dev, struct sec_alg_res *res)
 				  res->c_ivin, res->c_ivin_dma);
 }
 
+static int sec_alloc_aiv_resource(struct device *dev, struct sec_alg_res *res)
+{
+	int i;
+
+	res->a_ivin = dma_alloc_coherent(dev, SEC_TOTAL_IV_SZ,
+					 &res->a_ivin_dma, GFP_KERNEL);
+	if (!res->a_ivin)
+		return -ENOMEM;
+
+	for (i = 1; i < QM_Q_DEPTH; i++) {
+		res[i].a_ivin_dma = res->a_ivin_dma + i * SEC_IV_SIZE;
+		res[i].a_ivin = res->a_ivin + i * SEC_IV_SIZE;
+	}
+
+	return 0;
+}
+
+static void sec_free_aiv_resource(struct device *dev, struct sec_alg_res *res)
+{
+	if (res->a_ivin)
+		dma_free_coherent(dev, SEC_TOTAL_IV_SZ,
+				  res->a_ivin, res->a_ivin_dma);
+}
+
 static int sec_alloc_mac_resource(struct device *dev, struct sec_alg_res *res)
 {
 	int i;
@@ -382,9 +421,13 @@ static int sec_alg_resource_alloc(struct sec_ctx *ctx,
 		return ret;
 
 	if (ctx->alg_type == SEC_AEAD) {
+		ret = sec_alloc_aiv_resource(dev, res);
+		if (ret)
+			goto alloc_aiv_fail;
+
 		ret = sec_alloc_mac_resource(dev, res);
 		if (ret)
-			goto alloc_fail;
+			goto alloc_mac_fail;
 	}
 	if (ctx->pbuf_supported) {
 		ret = sec_alloc_pbuf_resource(dev, res);
@@ -399,7 +442,10 @@ static int sec_alg_resource_alloc(struct sec_ctx *ctx,
 alloc_pbuf_fail:
 	if (ctx->alg_type == SEC_AEAD)
 		sec_free_mac_resource(dev, qp_ctx->res);
-alloc_fail:
+alloc_mac_fail:
+	if (ctx->alg_type == SEC_AEAD)
+		sec_free_aiv_resource(dev, res);
+alloc_aiv_fail:
 	sec_free_civ_resource(dev, res);
 	return ret;
 }
@@ -656,19 +702,25 @@ static int sec_skcipher_aes_sm4_setkey(struct sec_cipher_ctx *c_ctx,
 			return -EINVAL;
 		}
 	} else {
-		switch (keylen) {
-		case AES_KEYSIZE_128:
-			c_ctx->c_key_len = SEC_CKEY_128BIT;
-			break;
-		case AES_KEYSIZE_192:
-			c_ctx->c_key_len = SEC_CKEY_192BIT;
-			break;
-		case AES_KEYSIZE_256:
-			c_ctx->c_key_len = SEC_CKEY_256BIT;
-			break;
-		default:
-			pr_err("hisi_sec2: aes key error!\n");
+		if (c_ctx->c_alg == SEC_CALG_SM4 &&
+			keylen != AES_KEYSIZE_128) {
+			pr_err("hisi_sec2: sm4 key error!\n");
 			return -EINVAL;
+		} else {
+			switch (keylen) {
+			case AES_KEYSIZE_128:
+				c_ctx->c_key_len = SEC_CKEY_128BIT;
+				break;
+			case AES_KEYSIZE_192:
+				c_ctx->c_key_len = SEC_CKEY_192BIT;
+				break;
+			case AES_KEYSIZE_256:
+				c_ctx->c_key_len = SEC_CKEY_256BIT;
+				break;
+			default:
+				pr_err("hisi_sec2: aes key error!\n");
+				return -EINVAL;
+			}
 		}
 	}
 
@@ -790,6 +842,8 @@ static int sec_cipher_map(struct sec_ctx *ctx, struct sec_req *req,
 		c_req->c_ivin = res->pbuf + SEC_PBUF_IV_OFFSET;
 		c_req->c_ivin_dma = res->pbuf_dma + SEC_PBUF_IV_OFFSET;
 		if (ctx->alg_type == SEC_AEAD) {
+			a_req->a_ivin = res->a_ivin;
+			a_req->a_ivin_dma = res->a_ivin_dma;
 			a_req->out_mac = res->pbuf + SEC_PBUF_MAC_OFFSET;
 			a_req->out_mac_dma = res->pbuf_dma +
 					SEC_PBUF_MAC_OFFSET;
@@ -800,6 +854,8 @@ static int sec_cipher_map(struct sec_ctx *ctx, struct sec_req *req,
 	c_req->c_ivin = res->c_ivin;
 	c_req->c_ivin_dma = res->c_ivin_dma;
 	if (ctx->alg_type == SEC_AEAD) {
+		a_req->a_ivin = res->a_ivin;
+		a_req->a_ivin_dma = res->a_ivin_dma;
 		a_req->out_mac = res->out_mac;
 		a_req->out_mac_dma = res->out_mac_dma;
 	}
@@ -930,6 +986,17 @@ static int sec_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 	ctx->a_ctx.mac_len = mac_len;
 	c_ctx->c_mode = c_mode;
 
+	if (c_mode == SEC_CMODE_CCM || c_mode == SEC_CMODE_GCM) {
+		ret = sec_skcipher_aes_sm4_setkey(c_ctx, keylen, c_mode);
+		if (ret) {
+			dev_err(SEC_CTX_DEV(ctx), "set sec aes ccm cipher key err!\n");
+			return ret;
+		}
+		memcpy(c_ctx->c_key, key, keylen);
+
+		return 0;
+	}
+
 	if (crypto_authenc_extractkeys(&keys, key, keylen))
 		goto bad_key;
 
@@ -958,21 +1025,6 @@ static int sec_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 	return -EINVAL;
 }
 
-
-#define GEN_SEC_AEAD_SETKEY_FUNC(name, aalg, calg, maclen, cmode)	\
-static int sec_setkey_##name(struct crypto_aead *tfm, const u8 *key,	\
-	u32 keylen)							\
-{									\
-	return sec_aead_setkey(tfm, key, keylen, aalg, calg, maclen, cmode);\
-}
-
-GEN_SEC_AEAD_SETKEY_FUNC(aes_cbc_sha1, SEC_A_HMAC_SHA1,
-			 SEC_CALG_AES, SEC_HMAC_SHA1_MAC, SEC_CMODE_CBC)
-GEN_SEC_AEAD_SETKEY_FUNC(aes_cbc_sha256, SEC_A_HMAC_SHA256,
-			 SEC_CALG_AES, SEC_HMAC_SHA256_MAC, SEC_CMODE_CBC)
-GEN_SEC_AEAD_SETKEY_FUNC(aes_cbc_sha512, SEC_A_HMAC_SHA512,
-			 SEC_CALG_AES, SEC_HMAC_SHA512_MAC, SEC_CMODE_CBC)
-
 static int sec_aead_sgl_map(struct sec_ctx *ctx, struct sec_req *req)
 {
 	struct aead_request *aq = req->aead_req.aead_req;
@@ -1213,12 +1265,117 @@ static void sec_skcipher_callback(struct sec_ctx *ctx, struct sec_req *req,
 	sk_req->base.complete(&sk_req->base, err);
 }
 
-static void sec_aead_copy_iv(struct sec_ctx *ctx, struct sec_req *req)
+
+static void set_aead_auth_iv(struct sec_ctx *ctx, struct sec_req *req)
 {
 	struct aead_request *aead_req = req->aead_req.aead_req;
 	struct sec_cipher_req *c_req = &req->c_req;
+	struct sec_aead_req *a_req = &req->aead_req;
+	size_t authsize = ctx->a_ctx.mac_len;
+	u8 flage = 0;
+	u8 cm;
+
+	/* the last 3bit is L' */
+	flage |= c_req->c_ivin[0] & IV_CL_MASK;
+
+	/* the M' is bit3~bit5, the Flags is bit6 */
+	cm = (authsize - IV_CM_CAL_NUM) / IV_CM_CAL_NUM;
+	flage |= cm << IV_CM_OFFSET;
+	if (aead_req->assoclen)
+		flage |= 0x01 << IV_FLAGS_OFFSET;
+
+	memcpy(a_req->a_ivin, aead_req->iv, ctx->c_ctx.ivsize);
+	a_req->a_ivin[0] = flage;
+
+	/*
+	 * the last 32bit is counter's initial number,
+	 * but the nonce uses the first 16bit
+	 * the tail 16bit fill with the cipher length
+	 */
+	a_req->a_ivin[ctx->c_ctx.ivsize - IV_LAST_BYTE2] =
+		aead_req->cryptlen & IV_LAST_BYTE2_MASK;
+	a_req->a_ivin[ctx->c_ctx.ivsize - IV_LAST_BYTE1] =
+		aead_req->cryptlen & IV_LAST_BYTE1_MASK;
+}
+
+static void sec_aead_set_iv(struct sec_ctx *ctx, struct sec_req *req)
+{
+	struct aead_request *aead_req = req->aead_req.aead_req;
+	struct crypto_aead *tfm = crypto_aead_reqtfm(aead_req);
+	size_t authsize = crypto_aead_authsize(tfm);
+	struct sec_cipher_req *c_req = &req->c_req;
+	struct sec_aead_req *a_req = &req->aead_req;
 
 	memcpy(c_req->c_ivin, aead_req->iv, ctx->c_ctx.ivsize);
+
+	if (ctx->c_ctx.c_mode == SEC_CMODE_CCM) {
+		/*
+		 * CCM 16Byte Cipher_IV: {1B_Flage,13B_IV,2B_counter},
+		 * the  counter must set to 0x01
+		 */
+		ctx->a_ctx.mac_len = authsize;
+		c_req->c_ivin[ctx->c_ctx.ivsize - IV_LAST_BYTE2] = 0x00;
+		c_req->c_ivin[ctx->c_ctx.ivsize - IV_LAST_BYTE1] = IV_CTR_INIT;
+		/* CCM 16Byte Auth_IV: {1B_AFlage,13B_IV,2B_Ptext_length} */
+		set_aead_auth_iv(ctx, req);
+	}
+
+	/* GCM 12Byte Cipher_IV == Auth_IV */
+	if (ctx->c_ctx.c_mode == SEC_CMODE_GCM) {
+		ctx->a_ctx.mac_len = authsize;
+		memcpy(a_req->a_ivin, c_req->c_ivin, ctx->c_ctx.ivsize);
+	}
+}
+
+static void sec_auth_bd_fill_xcm(struct sec_auth_ctx *ctx, int dir,
+			       struct sec_req *req, struct sec_sqe *sec_sqe)
+{
+	struct sec_aead_req *a_req = &req->aead_req;
+	struct aead_request *aq = a_req->aead_req;
+
+	/* C_ICV_Len is MAC size, 0x4 ~ 0x10 */
+	sec_sqe->type2.icvw_kmode |= cpu_to_le16((u16)ctx->mac_len);
+
+	/* mode set to CCM/GCM, don't set {A_Alg, AKey_Len, MAC_Len} */
+	sec_sqe->type2.a_key_addr = sec_sqe->type2.c_key_addr;
+	sec_sqe->type2.a_ivin_addr = cpu_to_le64(a_req->a_ivin_dma);
+	sec_sqe->type_cipher_auth |= SEC_NO_AUTH << SEC_AUTH_OFFSET;
+
+	if (dir)
+		sec_sqe->sds_sa_type &= SEC_CIPHER_AUTH;
+	else
+		sec_sqe->sds_sa_type |= SEC_AUTH_CIPHER;
+
+	sec_sqe->type2.alen_ivllen = cpu_to_le32(aq->assoclen);
+	sec_sqe->type2.auth_src_offset = cpu_to_le32(0x0);
+	sec_sqe->type2.cipher_src_offset = cpu_to_le16((u16)aq->assoclen);
+
+	sec_sqe->type2.mac_addr = cpu_to_le64(a_req->out_mac_dma);
+}
+
+static void sec_auth_bd_fill_xcm_v3(struct sec_auth_ctx *ctx, int dir,
+			       struct sec_req *req, struct sec_sqe3 *sec_sqe)
+{
+	struct sec_aead_req *a_req = &req->aead_req;
+	struct aead_request *aq = a_req->aead_req;
+
+	/* C_ICV_Len is MAC size, 0x4 ~ 0x10 */
+	sec_sqe->c_icv_key |= cpu_to_le16((u16)ctx->mac_len << SEC_MAC_OFFSET_V3);
+
+	/* mode set to CCM/GCM, don't set {A_Alg, AKey_Len, MAC_Len} */
+	sec_sqe->a_key_addr = sec_sqe->c_key_addr;
+	sec_sqe->auth_ivin.a_ivin_addr = cpu_to_le64(a_req->a_ivin_dma);
+	sec_sqe->auth_mac_key = SEC_NO_AUTH;
+
+	if (dir)
+		sec_sqe->huk_iv_seq &= SEC_CIPHER_AUTH_V3;
+	else
+		sec_sqe->huk_iv_seq |= SEC_AUTH_CIPHER_V3;
+
+	sec_sqe->a_len_key = cpu_to_le32(aq->assoclen);
+	sec_sqe->auth_src_offset = cpu_to_le32(0x0);
+	sec_sqe->cipher_src_offset = cpu_to_le16((u16)aq->assoclen);
+	sec_sqe->mac_addr = cpu_to_le64(a_req->out_mac_dma);
 }
 
 static void sec_auth_bd_fill_ex(struct sec_auth_ctx *ctx, int dir,
@@ -1266,7 +1423,11 @@ static int sec_aead_bd_fill(struct sec_ctx *ctx, struct sec_req *req)
 		return ret;
 	}
 
-	sec_auth_bd_fill_ex(auth_ctx, req->c_req.encrypt, req, sec_sqe);
+	if (ctx->c_ctx.c_mode == SEC_CMODE_CCM ||
+		ctx->c_ctx.c_mode == SEC_CMODE_GCM)
+		sec_auth_bd_fill_xcm(auth_ctx, req->c_req.encrypt, req, sec_sqe);
+	else
+		sec_auth_bd_fill_ex(auth_ctx, req->c_req.encrypt, req, sec_sqe);
 
 	return 0;
 }
@@ -1316,7 +1477,13 @@ static int sec_aead_bd_fill_v3(struct sec_ctx *ctx, struct sec_req *req)
 		return ret;
 	}
 
-	sec_auth_bd_fill_ex_v3(auth_ctx, req->c_req.encrypt, req, sec_sqe3);
+	if (ctx->c_ctx.c_mode == SEC_CMODE_CCM ||
+		ctx->c_ctx.c_mode == SEC_CMODE_GCM)
+		sec_auth_bd_fill_xcm_v3(auth_ctx, req->c_req.encrypt,
+				req, sec_sqe3);
+	else
+		sec_auth_bd_fill_ex_v3(auth_ctx, req->c_req.encrypt,
+				req, sec_sqe3);
 
 	return 0;
 }
@@ -1448,7 +1615,7 @@ static const struct sec_req_op sec_skcipher_req_ops = {
 static const struct sec_req_op sec_aead_req_ops = {
 	.buf_map	= sec_aead_sgl_map,
 	.buf_unmap	= sec_aead_sgl_unmap,
-	.do_transfer	= sec_aead_copy_iv,
+	.do_transfer	= sec_aead_set_iv,
 	.bd_fill	= sec_aead_bd_fill,
 	.bd_send	= sec_bd_send,
 	.callback	= sec_aead_callback,
@@ -1468,7 +1635,7 @@ static const struct sec_req_op sec_skcipher_req_ops_v3 = {
 static const struct sec_req_op sec_aead_req_ops_v3 = {
 	.buf_map	= sec_aead_sgl_map,
 	.buf_unmap	= sec_aead_sgl_unmap,
-	.do_transfer	= sec_aead_copy_iv,
+	.do_transfer	= sec_aead_set_iv,
 	.bd_fill	= sec_aead_bd_fill_v3,
 	.bd_send	= sec_bd_send,
 	.callback	= sec_aead_callback,
@@ -1508,8 +1675,9 @@ static int sec_aead_init(struct crypto_aead *tfm)
 	crypto_aead_set_reqsize(tfm, sizeof(struct sec_req));
 	ctx->alg_type = SEC_AEAD;
 	ctx->c_ctx.ivsize = crypto_aead_ivsize(tfm);
-	if (ctx->c_ctx.ivsize > SEC_IV_SIZE) {
-		dev_err(SEC_CTX_DEV(ctx), "get error aead iv size!\n");
+	if (ctx->c_ctx.ivsize < SEC_AIV_SIZE ||
+		ctx->c_ctx.ivsize > SEC_IV_SIZE) {
+		pr_err("get error aead iv size!\n");
 		return -EINVAL;
 	}
 
@@ -1596,6 +1764,16 @@ static int sec_aead_sha512_ctx_init(struct crypto_aead *tfm)
 	return sec_aead_ctx_init(tfm, "sha512");
 }
 
+static int sec_aead_ccm_ctx_init(struct crypto_aead *tfm)
+{
+	return sec_aead_init(tfm);
+}
+
+static int sec_aead_gcm_ctx_init(struct crypto_aead *tfm)
+{
+	return sec_aead_init(tfm);
+}
+
 static int sec_skcipher_param_check(struct sec_ctx *ctx, struct sec_req *sreq)
 {
 	struct skcipher_request *sk_req = sreq->c_req.sk_req;
@@ -1767,40 +1945,67 @@ static struct skcipher_alg sec_skciphers_v3[] = {
 			 AES_BLOCK_SIZE, AES_BLOCK_SIZE)
 };
 
-static int sec_aead_param_check(struct sec_ctx *ctx, struct sec_req *sreq)
+static int sec_aead_spec_check(struct sec_ctx *ctx, struct sec_req *sreq)
 {
-	u8 c_alg = ctx->c_ctx.c_alg;
 	struct aead_request *req = sreq->aead_req.aead_req;
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	size_t authsize = crypto_aead_authsize(tfm);
+	u8 c_mode = ctx->c_ctx.c_mode;
 
-	if (unlikely(!req->src || !req->dst || !req->cryptlen ||
+	if (unlikely(req->cryptlen + req->assoclen > MAX_INPUT_DATA_LEN ||
 		req->assoclen > SEC_MAX_AAD_LEN)) {
-		dev_err(SEC_CTX_DEV(ctx), "aead input param error!\n");
+		dev_err(SEC_CTX_DEV(ctx), "aead input spec error!\n");
 		return -EINVAL;
 	}
 
-	if (ctx->pbuf_supported && (req->cryptlen + req->assoclen) <=
-		SEC_PBUF_SZ)
-		sreq->use_pbuf = true;
-	else
-		sreq->use_pbuf = false;
-
-	/* Support AES only */
-	if (unlikely(c_alg != SEC_CALG_AES)) {
-		dev_err(SEC_CTX_DEV(ctx), "aead crypto alg error!\n");
+	if (unlikely((c_mode == SEC_CMODE_GCM && authsize < DES_BLOCK_SIZE) ||
+		(c_mode == SEC_CMODE_CCM && (authsize < MIN_MAC_LEN ||
+		authsize & MAC_LEN_MASK)))) {
+		dev_err(SEC_CTX_DEV(ctx), "aead input mac length error!\n");
 		return -EINVAL;
 	}
+
 	if (sreq->c_req.encrypt)
 		sreq->c_req.c_len = req->cryptlen;
 	else
 		sreq->c_req.c_len = req->cryptlen - authsize;
 
-	if (unlikely(sreq->c_req.c_len & (AES_BLOCK_SIZE - 1))) {
-		dev_err(SEC_CTX_DEV(ctx), "aead crypto length error!\n");
+	if (c_mode == SEC_CMODE_CBC) {
+		if (unlikely(sreq->c_req.c_len & (AES_BLOCK_SIZE - 1) ||
+		    sreq->c_req.c_len <= 0)) {
+			dev_err(SEC_CTX_DEV(ctx), "aead crypto length error!\n");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static int sec_aead_param_check(struct sec_ctx *ctx, struct sec_req *sreq)
+{
+	struct aead_request *req = sreq->aead_req.aead_req;
+	u8 c_alg = ctx->c_ctx.c_alg;
+
+	if (unlikely(!req->src || !req->dst)) {
+		dev_err(SEC_CTX_DEV(ctx), "aead input param error!\n");
 		return -EINVAL;
 	}
 
+	/* Support AES or SM4 */
+	if (unlikely(c_alg != SEC_CALG_AES && c_alg != SEC_CALG_SM4)) {
+		dev_err(SEC_CTX_DEV(ctx), "aead crypto alg error!\n");
+		return -EINVAL;
+	}
+
+	if (unlikely(sec_aead_spec_check(ctx, sreq)))
+		return -EINVAL;
+
+	if (ctx->pbuf_supported && (req->cryptlen + req->assoclen) <=
+		SEC_PBUF_SZ)
+		sreq->use_pbuf = true;
+	else
+		sreq->use_pbuf = false;
+
 	return 0;
 }
 
@@ -1833,14 +2038,38 @@ static int sec_aead_decrypt(struct aead_request *a_req)
 	return sec_aead_crypto(a_req, false);
 }
 
-#define SEC_AEAD_GEN_ALG(sec_cra_name, sec_set_key, ctx_init,\
-			 ctx_exit, blk_size, iv_size, max_authsize)\
+#define GEN_SEC_AEAD_SETKEY_FUNC(name, aalg, calg, maclen, cmode)	\
+static int sec_setkey_##name(struct crypto_aead *tfm, const u8 *key,	\
+	u32 keylen)                                                     \
+{	                                                                \
+	return sec_aead_setkey(tfm, key, keylen, aalg, calg, maclen, cmode);\
+}
+
+GEN_SEC_AEAD_SETKEY_FUNC(aes_cbc_sha1, SEC_A_HMAC_SHA1,
+			SEC_CALG_AES, SEC_HMAC_SHA1_MAC, SEC_CMODE_CBC)
+GEN_SEC_AEAD_SETKEY_FUNC(aes_cbc_sha256, SEC_A_HMAC_SHA256,
+			SEC_CALG_AES, SEC_HMAC_SHA256_MAC, SEC_CMODE_CBC)
+GEN_SEC_AEAD_SETKEY_FUNC(aes_cbc_sha512, SEC_A_HMAC_SHA512,
+			SEC_CALG_AES, SEC_HMAC_SHA512_MAC, SEC_CMODE_CBC)
+GEN_SEC_AEAD_SETKEY_FUNC(aes_ccm, 0, SEC_CALG_AES,
+			SEC_HMAC_CCM_MAC, SEC_CMODE_CCM)
+GEN_SEC_AEAD_SETKEY_FUNC(aes_gcm, 0, SEC_CALG_AES,
+			SEC_HMAC_GCM_MAC, SEC_CMODE_GCM)
+GEN_SEC_AEAD_SETKEY_FUNC(sm4_ccm, 0, SEC_CALG_SM4,
+			SEC_HMAC_CCM_MAC, SEC_CMODE_CCM)
+GEN_SEC_AEAD_SETKEY_FUNC(sm4_gcm, 0, SEC_CALG_SM4,
+			SEC_HMAC_GCM_MAC, SEC_CMODE_GCM)
+
+#define SEC_AEAD_ALG(sec_cra_name, sec_set_key, ctx_init,\
+		      ctx_exit, blk_size, iv_size, max_authsize)\
 {\
 	.base = {\
 		.cra_name = sec_cra_name,\
 		.cra_driver_name = "hisi_sec_"sec_cra_name,\
 		.cra_priority = SEC_PRIORITY,\
-		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,\
+		.cra_flags = CRYPTO_ALG_ASYNC |\
+		 CRYPTO_ALG_ALLOCATES_MEMORY |\
+		 CRYPTO_ALG_NEED_FALLBACK,\
 		.cra_blocksize = blk_size,\
 		.cra_ctxsize = sizeof(struct sec_ctx),\
 		.cra_module = THIS_MODULE,\
@@ -1854,22 +2083,39 @@ static int sec_aead_decrypt(struct aead_request *a_req)
 	.maxauthsize = max_authsize,\
 }
 
-#define SEC_AEAD_ALG(algname, keyfunc, aead_init, blksize, ivsize, authsize)\
-	SEC_AEAD_GEN_ALG(algname, keyfunc, aead_init,\
-			sec_aead_ctx_exit, blksize, ivsize, authsize)
-
 static struct aead_alg sec_aeads[] = {
 	SEC_AEAD_ALG("authenc(hmac(sha1),cbc(aes))",
 		     sec_setkey_aes_cbc_sha1, sec_aead_sha1_ctx_init,
-		     AES_BLOCK_SIZE, AES_BLOCK_SIZE, SHA1_DIGEST_SIZE),
+		     sec_aead_ctx_exit, AES_BLOCK_SIZE,
+		     AES_BLOCK_SIZE, SHA1_DIGEST_SIZE),
 
 	SEC_AEAD_ALG("authenc(hmac(sha256),cbc(aes))",
 		     sec_setkey_aes_cbc_sha256, sec_aead_sha256_ctx_init,
-		     AES_BLOCK_SIZE, AES_BLOCK_SIZE, SHA256_DIGEST_SIZE),
+		     sec_aead_ctx_exit, AES_BLOCK_SIZE,
+		     AES_BLOCK_SIZE, SHA256_DIGEST_SIZE),
 
 	SEC_AEAD_ALG("authenc(hmac(sha512),cbc(aes))",
 		     sec_setkey_aes_cbc_sha512, sec_aead_sha512_ctx_init,
-		     AES_BLOCK_SIZE, AES_BLOCK_SIZE, SHA512_DIGEST_SIZE),
+		     sec_aead_ctx_exit, AES_BLOCK_SIZE,
+		     AES_BLOCK_SIZE, SHA512_DIGEST_SIZE),
+};
+
+static struct aead_alg sec_aeads_v3[] = {
+	SEC_AEAD_ALG("ccm(aes)", sec_setkey_aes_ccm, sec_aead_ccm_ctx_init,
+		     sec_aead_ctx_exit, AES_BLOCK_SIZE,
+		     AES_BLOCK_SIZE, AES_BLOCK_SIZE),
+
+	SEC_AEAD_ALG("gcm(aes)", sec_setkey_aes_gcm, sec_aead_gcm_ctx_init,
+		     sec_aead_ctx_exit, AES_BLOCK_SIZE,
+		     SEC_AIV_SIZE, AES_BLOCK_SIZE),
+
+	SEC_AEAD_ALG("ccm(sm4)", sec_setkey_sm4_ccm, sec_aead_ccm_ctx_init,
+		     sec_aead_ctx_exit, AES_BLOCK_SIZE,
+		     AES_BLOCK_SIZE, AES_BLOCK_SIZE),
+
+	SEC_AEAD_ALG("gcm(sm4)", sec_setkey_sm4_gcm, sec_aead_gcm_ctx_init,
+		     sec_aead_ctx_exit, AES_BLOCK_SIZE,
+		     SEC_AIV_SIZE, AES_BLOCK_SIZE)
 };
 
 int sec_register_to_crypto(struct hisi_qm *qm)
@@ -1892,8 +2138,17 @@ int sec_register_to_crypto(struct hisi_qm *qm)
 	ret = crypto_register_aeads(sec_aeads, ARRAY_SIZE(sec_aeads));
 	if (ret)
 		goto reg_aead_fail;
+
+	if (qm->ver > QM_HW_V2) {
+		ret = crypto_register_aeads(sec_aeads_v3, ARRAY_SIZE(sec_aeads_v3));
+		if (ret)
+			goto reg_aead_v3_fail;
+	}
+
 	return ret;
 
+reg_aead_v3_fail:
+	crypto_unregister_aeads(sec_aeads, ARRAY_SIZE(sec_aeads));
 reg_aead_fail:
 	if (qm->ver > QM_HW_V2)
 		crypto_unregister_skciphers(sec_skciphers_v3,
@@ -1906,6 +2161,9 @@ int sec_register_to_crypto(struct hisi_qm *qm)
 
 void sec_unregister_from_crypto(struct hisi_qm *qm)
 {
+	if (qm->ver > QM_HW_V2)
+		crypto_unregister_aeads(sec_aeads_v3,
+					ARRAY_SIZE(sec_aeads_v3));
 	crypto_unregister_aeads(sec_aeads, ARRAY_SIZE(sec_aeads));
 
 	if (qm->ver > QM_HW_V2)
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.h b/drivers/crypto/hisilicon/sec2/sec_crypto.h
index 90da1cc..e58008a 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.h
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.h
@@ -4,6 +4,7 @@
 #ifndef __HISI_SEC_V2_CRYPTO_H
 #define __HISI_SEC_V2_CRYPTO_H
 
+#define SEC_AIV_SIZE		12
 #define SEC_IV_SIZE		24
 #define SEC_MAX_KEY_SIZE	64
 #define SEC_COMM_SCENE		0
@@ -21,6 +22,8 @@ enum sec_hash_alg {
 };
 
 enum sec_mac_len {
+	SEC_HMAC_CCM_MAC   = 16,
+	SEC_HMAC_GCM_MAC   = 16,
 	SEC_HMAC_SHA1_MAC   = 20,
 	SEC_HMAC_SHA256_MAC = 32,
 	SEC_HMAC_SHA512_MAC = 64,
@@ -32,6 +35,8 @@ enum sec_cmode {
 	SEC_CMODE_CFB    = 0x2,
 	SEC_CMODE_OFB    = 0x3,
 	SEC_CMODE_CTR    = 0x4,
+	SEC_CMODE_CCM    = 0x5,
+	SEC_CMODE_GCM    = 0x6,
 	SEC_CMODE_XTS    = 0x7,
 };
 
-- 
2.8.1

