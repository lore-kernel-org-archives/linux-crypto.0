Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 813C6C64E7C
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Nov 2020 02:20:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6904720B1F
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Nov 2020 02:20:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732832AbgKZCTy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Nov 2020 21:19:54 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7686 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732814AbgKZCTx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Nov 2020 21:19:53 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4ChM004VNFz15R43;
        Thu, 26 Nov 2020 10:19:28 +0800 (CST)
Received: from huawei.com (10.67.165.24) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Thu, 26 Nov 2020
 10:19:45 +0800
From:   Longfang Liu <liulongfang@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] crypto: hisilicon/sec - add new type of sqe for Kunpeng930
Date:   Thu, 26 Nov 2020 10:18:03 +0800
Message-ID: <1606357086-9785-3-git-send-email-liulongfang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1606357086-9785-1-git-send-email-liulongfang@huawei.com>
References: <1606357086-9785-1-git-send-email-liulongfang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In the new generation of accelerator hardware, in order to
add new algorithm support, the hardware adds a new SQE data structure,
so the driver has been upgraded as needed.

Signed-off-by: Sihang Chen <chensihang1@hisilicon.com>
Signed-off-by: Longfang Liu <liulongfang@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec.h        |   6 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 325 ++++++++++++++++++++++-------
 drivers/crypto/hisilicon/sec2/sec_crypto.h | 169 +++++++++++++++
 3 files changed, 429 insertions(+), 71 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
index 17ddb20..7c40f8a 100644
--- a/drivers/crypto/hisilicon/sec2/sec.h
+++ b/drivers/crypto/hisilicon/sec2/sec.h
@@ -40,7 +40,10 @@ struct sec_aead_req {
 
 /* SEC request of Crypto */
 struct sec_req {
-	struct sec_sqe sec_sqe;
+	union {
+		struct sec_sqe sec_sqe;
+		struct sec_sqe3 sec_sqe3;
+	};
 	struct sec_ctx *ctx;
 	struct sec_qp_ctx *qp_ctx;
 
@@ -139,6 +142,7 @@ struct sec_ctx {
 	bool pbuf_supported;
 	struct sec_cipher_ctx c_ctx;
 	struct sec_auth_ctx a_ctx;
+	u8 type_supported;
 };
 
 enum sec_endian {
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index f835514..2d338a3 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -33,13 +33,28 @@
 #define SEC_CKEY_OFFSET		9
 #define SEC_CMODE_OFFSET	12
 #define SEC_AKEY_OFFSET         5
-#define SEC_AEAD_ALG_OFFSET     11
+#define SEC_AUTH_ALG_OFFSET	11
 #define SEC_AUTH_OFFSET		6
 
+#define SEC_DE_OFFSET_V3		9
+#define SEC_SCENE_OFFSET_V3	5
+#define SEC_CKEY_OFFSET_V3	13
+#define SEC_SRC_SGL_OFFSET_V3	11
+#define SEC_DST_SGL_OFFSET_V3	14
+#define SEC_CI_GEN_OFFSET_V3	2
+#define SEC_CALG_OFFSET_V3	4
+
+#define SEC_AKEY_OFFSET_V3         9
+#define SEC_MAC_OFFSET_V3         4
+#define SEC_AUTH_ALG_OFFSET_V3	15
+#define SEC_CIPHER_AUTH_V3	0xbf
+#define SEC_AUTH_CIPHER_V3	0x40
+
 #define SEC_FLAG_OFFSET		7
 #define SEC_FLAG_MASK		0x0780
 #define SEC_TYPE_MASK		0x0F
 #define SEC_DONE_MASK		0x0001
+#define SEC_SQE_LEN_RATE_MASK	0x3
 
 #define SEC_TOTAL_IV_SZ		(SEC_IV_SIZE * QM_Q_DEPTH)
 #define SEC_SGL_SGE_NR		128
@@ -145,41 +160,71 @@ static int sec_aead_verify(struct sec_req *req)
 	return 0;
 }
 
+static u8 pre_parse_finished_bd(struct bd_status *status, void *resp)
+{
+	struct sec_sqe *bd = resp;
+
+	status->done = le16_to_cpu(bd->type2.done_flag) & SEC_DONE_MASK;
+	status->flag = (le16_to_cpu(bd->type2.done_flag) &
+					SEC_FLAG_MASK) >> SEC_FLAG_OFFSET;
+	status->tag = le16_to_cpu(bd->type2.tag);
+	status->err_type = bd->type2.error_type;
+
+	return bd->type_cipher_auth & SEC_TYPE_MASK;
+}
+
+static u8 pre_parse_finished_bd3(struct bd_status *status, void *resp)
+{
+	struct sec_sqe3 *bd3 = resp;
+
+	status->done = le16_to_cpu(bd3->done_flag) & SEC_DONE_MASK;
+	status->flag = (le16_to_cpu(bd3->done_flag) &
+					SEC_FLAG_MASK) >> SEC_FLAG_OFFSET;
+	status->tag = le64_to_cpu(bd3->tag);
+	status->err_type = bd3->error_type;
+
+	return le32_to_cpu(bd3->bd_param) & SEC_TYPE_MASK;
+}
+
 static void sec_req_cb(struct hisi_qp *qp, void *resp)
 {
 	struct sec_qp_ctx *qp_ctx = qp->qp_ctx;
 	struct sec_dfx *dfx = &qp_ctx->ctx->sec->debug.dfx;
-	struct sec_sqe *bd = resp;
+	u8 type_supported = qp_ctx->ctx->type_supported;
+	struct bd_status status;
 	struct sec_ctx *ctx;
 	struct sec_req *req;
-	u16 done, flag;
 	int err = 0;
 	u8 type;
 
-	type = bd->type_cipher_auth & SEC_TYPE_MASK;
-	if (unlikely(type != SEC_BD_TYPE2)) {
+	if (type_supported == SEC_BD_TYPE2) {
+		type = pre_parse_finished_bd(&status, resp);
+		req = qp_ctx->req_list[status.tag];
+	} else {
+		type = pre_parse_finished_bd3(&status, resp);
+		req = (void *)(uintptr_t)status.tag;
+	}
+
+	if (unlikely(type != type_supported)) {
 		atomic64_inc(&dfx->err_bd_cnt);
-		pr_err("err bd type [%d]\n", type);
+		pr_err("err bd type [%u]\n", type);
 		return;
 	}
 
-	req = qp_ctx->req_list[le16_to_cpu(bd->type2.tag)];
 	if (unlikely(!req)) {
 		atomic64_inc(&dfx->invalid_req_cnt);
 		atomic_inc(&qp->qp_status.used);
 		return;
 	}
-	req->err_type = bd->type2.error_type;
+
+	req->err_type = status.err_type;
 	ctx = req->ctx;
-	done = le16_to_cpu(bd->type2.done_flag) & SEC_DONE_MASK;
-	flag = (le16_to_cpu(bd->type2.done_flag) &
-		SEC_FLAG_MASK) >> SEC_FLAG_OFFSET;
-	if (unlikely(req->err_type || done != SEC_SQE_DONE ||
-	    (ctx->alg_type == SEC_SKCIPHER && flag != SEC_SQE_CFLAG) ||
-	    (ctx->alg_type == SEC_AEAD && flag != SEC_SQE_AEAD_FLAG))) {
-		dev_err(SEC_CTX_DEV(ctx),
-			"err_type[%d],done[%d],flag[%d]\n",
-			req->err_type, done, flag);
+	if (unlikely(req->err_type || status.done != SEC_SQE_DONE ||
+	    (ctx->alg_type == SEC_SKCIPHER && status.flag != SEC_SQE_CFLAG) ||
+	    (ctx->alg_type == SEC_AEAD && status.flag != SEC_SQE_AEAD_FLAG))) {
+		dev_err_ratelimited(SEC_CTX_DEV(ctx),
+			"err_type[%d],done[%u],flag[%u]\n",
+			req->err_type, status.done, status.flag);
 		err = -EIO;
 		atomic64_inc(&dfx->done_flag_cnt);
 	}
@@ -382,10 +427,11 @@ static int sec_create_qp_ctx(struct hisi_qm *qm, struct sec_ctx *ctx,
 	qp = ctx->qps[qp_ctx_id];
 	qp->req_type = 0;
 	qp->qp_ctx = qp_ctx;
-	qp->req_cb = sec_req_cb;
 	qp_ctx->qp = qp;
 	qp_ctx->ctx = ctx;
 
+	qp->req_cb = sec_req_cb;
+
 	mutex_init(&qp_ctx->req_lock);
 	idr_init(&qp_ctx->req_idr);
 	INIT_LIST_HEAD(&qp_ctx->backlog);
@@ -668,23 +714,6 @@ static int sec_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	return 0;
 }
 
-#define GEN_SEC_SETKEY_FUNC(name, c_alg, c_mode)			\
-static int sec_setkey_##name(struct crypto_skcipher *tfm, const u8 *key,\
-	u32 keylen)							\
-{									\
-	return sec_skcipher_setkey(tfm, key, keylen, c_alg, c_mode);	\
-}
-
-GEN_SEC_SETKEY_FUNC(aes_ecb, SEC_CALG_AES, SEC_CMODE_ECB)
-GEN_SEC_SETKEY_FUNC(aes_cbc, SEC_CALG_AES, SEC_CMODE_CBC)
-GEN_SEC_SETKEY_FUNC(aes_xts, SEC_CALG_AES, SEC_CMODE_XTS)
-
-GEN_SEC_SETKEY_FUNC(3des_ecb, SEC_CALG_3DES, SEC_CMODE_ECB)
-GEN_SEC_SETKEY_FUNC(3des_cbc, SEC_CALG_3DES, SEC_CMODE_CBC)
-
-GEN_SEC_SETKEY_FUNC(sm4_xts, SEC_CALG_SM4, SEC_CMODE_XTS)
-GEN_SEC_SETKEY_FUNC(sm4_cbc, SEC_CALG_SM4, SEC_CMODE_CBC)
-
 static int sec_cipher_pbuf_map(struct sec_ctx *ctx, struct sec_req *req,
 			struct scatterlist *src)
 {
@@ -914,6 +943,12 @@ static int sec_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 		goto bad_key;
 	}
 
+	if ((ctx->a_ctx.mac_len & SEC_SQE_LEN_RATE_MASK)  ||
+		(ctx->a_ctx.a_key_len & SEC_SQE_LEN_RATE_MASK)) {
+		dev_err(SEC_CTX_DEV(ctx), "MAC or AUTH key length error!\n");
+		goto bad_key;
+	}
+
 	return 0;
 
 bad_key:
@@ -1013,29 +1048,75 @@ static int sec_skcipher_bd_fill(struct sec_ctx *ctx, struct sec_req *req)
 		cipher = SEC_CIPHER_DEC << SEC_CIPHER_OFFSET;
 	sec_sqe->type_cipher_auth = bd_type | cipher;
 
-	if (req->use_pbuf)
+	/* Set destination and source address type */
+	if (req->use_pbuf) {
 		sa_type = SEC_PBUF << SEC_SRC_SGL_OFFSET;
-	else
+		da_type = SEC_PBUF << SEC_DST_SGL_OFFSET;
+	} else {
 		sa_type = SEC_SGL << SEC_SRC_SGL_OFFSET;
+		da_type = SEC_SGL << SEC_DST_SGL_OFFSET;
+	}
+
+	sec_sqe->sdm_addr_type |= da_type;
 	scene = SEC_COMM_SCENE << SEC_SCENE_OFFSET;
 	if (c_req->c_in_dma != c_req->c_out_dma)
 		de = 0x1 << SEC_DE_OFFSET;
 
 	sec_sqe->sds_sa_type = (de | scene | sa_type);
 
-	/* Just set DST address type */
-	if (req->use_pbuf)
-		da_type = SEC_PBUF << SEC_DST_SGL_OFFSET;
-	else
-		da_type = SEC_SGL << SEC_DST_SGL_OFFSET;
-	sec_sqe->sdm_addr_type |= da_type;
-
 	sec_sqe->type2.clen_ivhlen |= cpu_to_le32(c_req->c_len);
 	sec_sqe->type2.tag = cpu_to_le16((u16)req->req_id);
 
 	return 0;
 }
 
+static int sec_skcipher_bd_fill_v3(struct sec_ctx *ctx, struct sec_req *req)
+{
+	struct sec_sqe3 *sec_sqe3 = &req->sec_sqe3;
+	struct sec_cipher_ctx *c_ctx = &ctx->c_ctx;
+	struct sec_cipher_req *c_req = &req->c_req;
+	u32 bd_param = 0;
+	u16 cipher = 0;
+
+	memset(sec_sqe3, 0, sizeof(struct sec_sqe3));
+
+	sec_sqe3->c_key_addr = cpu_to_le64(c_ctx->c_key_dma);
+	sec_sqe3->no_scene.c_ivin_addr = cpu_to_le64(c_req->c_ivin_dma);
+	sec_sqe3->data_src_addr = cpu_to_le64(c_req->c_in_dma);
+	sec_sqe3->data_dst_addr = cpu_to_le64(c_req->c_out_dma);
+
+	sec_sqe3->c_mode_alg = (c_ctx->c_alg << SEC_CALG_OFFSET_V3) |
+						c_ctx->c_mode;
+	sec_sqe3->c_icv_key |= cpu_to_le16(((u16)c_ctx->c_key_len) <<
+						SEC_CKEY_OFFSET_V3);
+
+	if (c_req->encrypt)
+		cipher = SEC_CIPHER_ENC;
+	else
+		cipher = SEC_CIPHER_DEC;
+	sec_sqe3->c_icv_key |= cpu_to_le16(cipher);
+
+	if (req->use_pbuf) {
+		bd_param |= SEC_PBUF << SEC_SRC_SGL_OFFSET_V3;
+		bd_param |= SEC_PBUF << SEC_DST_SGL_OFFSET_V3;
+	} else {
+		bd_param |= SEC_SGL << SEC_SRC_SGL_OFFSET_V3;
+		bd_param |= SEC_SGL << SEC_DST_SGL_OFFSET_V3;
+	}
+
+	bd_param |= SEC_COMM_SCENE << SEC_SCENE_OFFSET_V3;
+	if (c_req->c_in_dma != c_req->c_out_dma)
+		bd_param |= 0x1 << SEC_DE_OFFSET_V3;
+
+	bd_param |= SEC_BD_TYPE3;
+	sec_sqe3->bd_param = cpu_to_le32(bd_param);
+
+	sec_sqe3->c_len_ivin |= cpu_to_le32(c_req->c_len);
+	sec_sqe3->tag = cpu_to_le64(req);
+
+	return 0;
+}
+
 static void sec_update_iv(struct sec_req *req, enum sec_alg_type alg_type)
 {
 	struct aead_request *aead_req = req->aead_req.aead_req;
@@ -1136,7 +1217,7 @@ static void sec_auth_bd_fill_ex(struct sec_auth_ctx *ctx, int dir,
 			SEC_SQE_LEN_RATE) << SEC_AKEY_OFFSET);
 
 	sec_sqe->type2.mac_key_alg |=
-			cpu_to_le32((u32)(ctx->a_alg) << SEC_AEAD_ALG_OFFSET);
+			cpu_to_le32((u32)(ctx->a_alg) << SEC_AUTH_ALG_OFFSET);
 
 	sec_sqe->type_cipher_auth |= SEC_AUTH_TYPE1 << SEC_AUTH_OFFSET;
 
@@ -1169,6 +1250,56 @@ static int sec_aead_bd_fill(struct sec_ctx *ctx, struct sec_req *req)
 	return 0;
 }
 
+static void sec_auth_bd_fill_ex_v3(struct sec_auth_ctx *ctx, int dir,
+			       struct sec_req *req, struct sec_sqe3 *sec_sqe3)
+{
+	struct sec_aead_req *a_req = &req->aead_req;
+	struct sec_cipher_req *c_req = &req->c_req;
+	struct aead_request *aq = a_req->aead_req;
+
+	sec_sqe3->a_key_addr = cpu_to_le64(ctx->a_key_dma);
+
+	sec_sqe3->auth_mac_key = SEC_AUTH_TYPE1;
+	sec_sqe3->auth_mac_key |=
+			cpu_to_le32((u32)(ctx->mac_len /
+			SEC_SQE_LEN_RATE) << SEC_MAC_OFFSET_V3);
+
+	sec_sqe3->auth_mac_key |=
+			cpu_to_le32((u32)(ctx->a_key_len /
+			SEC_SQE_LEN_RATE) << SEC_AKEY_OFFSET_V3);
+
+	sec_sqe3->auth_mac_key |=
+			cpu_to_le32((u32)(ctx->a_alg) << SEC_AUTH_ALG_OFFSET_V3);
+
+	if (dir)
+		sec_sqe3->huk_iv_seq &= SEC_CIPHER_AUTH_V3;
+	else
+		sec_sqe3->huk_iv_seq |= SEC_AUTH_CIPHER_V3;
+
+	sec_sqe3->a_len_key = cpu_to_le32(c_req->c_len + aq->assoclen);
+
+	sec_sqe3->cipher_src_offset = cpu_to_le16((u16)aq->assoclen);
+
+	sec_sqe3->mac_addr = cpu_to_le64(a_req->out_mac_dma);
+}
+
+static int sec_aead_bd_fill_v3(struct sec_ctx *ctx, struct sec_req *req)
+{
+	struct sec_auth_ctx *auth_ctx = &ctx->a_ctx;
+	struct sec_sqe3 *sec_sqe3 = &req->sec_sqe3;
+	int ret;
+
+	ret = sec_skcipher_bd_fill_v3(ctx, req);
+	if (unlikely(ret)) {
+		dev_err(SEC_CTX_DEV(ctx), "skcipher bd3 fill is error!\n");
+		return ret;
+	}
+
+	sec_auth_bd_fill_ex_v3(auth_ctx, req->c_req.encrypt, req, sec_sqe3);
+
+	return 0;
+}
+
 static void sec_aead_callback(struct sec_ctx *c, struct sec_req *req, int err)
 {
 	struct aead_request *a_req = req->aead_req.aead_req;
@@ -1302,13 +1433,44 @@ static const struct sec_req_op sec_aead_req_ops = {
 	.process	= sec_process,
 };
 
+static const struct sec_req_op sec_skcipher_req_ops_v3 = {
+	.buf_map	= sec_skcipher_sgl_map,
+	.buf_unmap	= sec_skcipher_sgl_unmap,
+	.do_transfer	= sec_skcipher_copy_iv,
+	.bd_fill	= sec_skcipher_bd_fill_v3,
+	.bd_send	= sec_bd_send,
+	.callback	= sec_skcipher_callback,
+	.process	= sec_process,
+};
+
+static const struct sec_req_op sec_aead_req_ops_v3 = {
+	.buf_map	= sec_aead_sgl_map,
+	.buf_unmap	= sec_aead_sgl_unmap,
+	.do_transfer	= sec_aead_copy_iv,
+	.bd_fill	= sec_aead_bd_fill_v3,
+	.bd_send	= sec_bd_send,
+	.callback	= sec_aead_callback,
+	.process	= sec_process,
+};
+
 static int sec_skcipher_ctx_init(struct crypto_skcipher *tfm)
 {
 	struct sec_ctx *ctx = crypto_skcipher_ctx(tfm);
+	int ret;
 
-	ctx->req_op = &sec_skcipher_req_ops;
+	ret = sec_skcipher_init(tfm);
+	if (ret)
+		return ret;
 
-	return sec_skcipher_init(tfm);
+	if (ctx->sec->qm.ver < QM_HW_V3) {
+		ctx->type_supported = SEC_BD_TYPE2;
+		ctx->req_op = &sec_skcipher_req_ops;
+	} else {
+		ctx->type_supported = SEC_BD_TYPE3;
+		ctx->req_op = &sec_skcipher_req_ops_v3;
+	}
+
+	return ret;
 }
 
 static void sec_skcipher_ctx_exit(struct crypto_skcipher *tfm)
@@ -1329,11 +1491,18 @@ static int sec_aead_init(struct crypto_aead *tfm)
 		return -EINVAL;
 	}
 
-	ctx->req_op = &sec_aead_req_ops;
 	ret = sec_ctx_base_init(ctx);
 	if (ret)
 		return ret;
 
+	if (ctx->sec->qm.ver < QM_HW_V3) {
+		ctx->type_supported = SEC_BD_TYPE2;
+		ctx->req_op = &sec_aead_req_ops;
+	} else {
+		ctx->type_supported = SEC_BD_TYPE3;
+		ctx->req_op = &sec_aead_req_ops_v3;
+	}
+
 	ret = sec_auth_init(ctx);
 	if (ret)
 		goto err_auth_init;
@@ -1472,61 +1641,73 @@ static int sec_skcipher_decrypt(struct skcipher_request *sk_req)
 	return sec_skcipher_crypto(sk_req, false);
 }
 
-#define SEC_SKCIPHER_GEN_ALG(sec_cra_name, sec_set_key, sec_min_key_size, \
-	sec_max_key_size, ctx_init, ctx_exit, blk_size, iv_size)\
+#define GEN_SEC_SETKEY_FUNC(name, c_alg, c_mode)	                \
+static int sec_setkey_##name(struct crypto_skcipher *tfm,	        \
+	const u8 *key, u32 keylen)                                      \
+{	                                                                \
+	return sec_skcipher_setkey(tfm, key, keylen, c_alg, c_mode); \
+}
+
+GEN_SEC_SETKEY_FUNC(aes_ecb, SEC_CALG_AES, SEC_CMODE_ECB)
+GEN_SEC_SETKEY_FUNC(aes_cbc, SEC_CALG_AES, SEC_CMODE_CBC)
+GEN_SEC_SETKEY_FUNC(aes_xts, SEC_CALG_AES, SEC_CMODE_XTS)
+GEN_SEC_SETKEY_FUNC(3des_ecb, SEC_CALG_3DES, SEC_CMODE_ECB)
+GEN_SEC_SETKEY_FUNC(3des_cbc, SEC_CALG_3DES, SEC_CMODE_CBC)
+GEN_SEC_SETKEY_FUNC(sm4_xts, SEC_CALG_SM4, SEC_CMODE_XTS)
+GEN_SEC_SETKEY_FUNC(sm4_cbc, SEC_CALG_SM4, SEC_CMODE_CBC)
+
+#define SEC_SKCIPHER_ALG(sec_cra_name, sec_set_key, \
+	sec_min_key_size, sec_max_key_size, blk_size, iv_size)\
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
 	},\
-	.init = ctx_init,\
-	.exit = ctx_exit,\
+	.init = sec_skcipher_ctx_init,\
+	.exit = sec_skcipher_ctx_exit,\
 	.setkey = sec_set_key,\
 	.decrypt = sec_skcipher_decrypt,\
 	.encrypt = sec_skcipher_encrypt,\
 	.min_keysize = sec_min_key_size,\
 	.max_keysize = sec_max_key_size,\
 	.ivsize = iv_size,\
-},
-
-#define SEC_SKCIPHER_ALG(name, key_func, min_key_size, \
-	max_key_size, blk_size, iv_size) \
-	SEC_SKCIPHER_GEN_ALG(name, key_func, min_key_size, max_key_size, \
-	sec_skcipher_ctx_init, sec_skcipher_ctx_exit, blk_size, iv_size)
+}
 
 static struct skcipher_alg sec_skciphers[] = {
 	SEC_SKCIPHER_ALG("ecb(aes)", sec_setkey_aes_ecb,
 			 AES_MIN_KEY_SIZE, AES_MAX_KEY_SIZE,
-			 AES_BLOCK_SIZE, 0)
+			 AES_BLOCK_SIZE, 0),
 
 	SEC_SKCIPHER_ALG("cbc(aes)", sec_setkey_aes_cbc,
 			 AES_MIN_KEY_SIZE, AES_MAX_KEY_SIZE,
-			 AES_BLOCK_SIZE, AES_BLOCK_SIZE)
+			 AES_BLOCK_SIZE, AES_BLOCK_SIZE),
 
 	SEC_SKCIPHER_ALG("xts(aes)", sec_setkey_aes_xts,
 			 SEC_XTS_MIN_KEY_SIZE, SEC_XTS_MAX_KEY_SIZE,
-			 AES_BLOCK_SIZE, AES_BLOCK_SIZE)
+			 AES_BLOCK_SIZE, AES_BLOCK_SIZE),
 
 	SEC_SKCIPHER_ALG("ecb(des3_ede)", sec_setkey_3des_ecb,
 			 SEC_DES3_2KEY_SIZE, SEC_DES3_3KEY_SIZE,
-			 DES3_EDE_BLOCK_SIZE, 0)
+			 DES3_EDE_BLOCK_SIZE, 0),
 
 	SEC_SKCIPHER_ALG("cbc(des3_ede)", sec_setkey_3des_cbc,
 			 SEC_DES3_2KEY_SIZE, SEC_DES3_3KEY_SIZE,
-			 DES3_EDE_BLOCK_SIZE, DES3_EDE_BLOCK_SIZE)
+			 DES3_EDE_BLOCK_SIZE, DES3_EDE_BLOCK_SIZE),
 
 	SEC_SKCIPHER_ALG("xts(sm4)", sec_setkey_sm4_xts,
 			 SEC_XTS_MIN_KEY_SIZE, SEC_XTS_MIN_KEY_SIZE,
-			 AES_BLOCK_SIZE, AES_BLOCK_SIZE)
+			 AES_BLOCK_SIZE, AES_BLOCK_SIZE),
 
 	SEC_SKCIPHER_ALG("cbc(sm4)", sec_setkey_sm4_cbc,
 			 AES_MIN_KEY_SIZE, AES_MIN_KEY_SIZE,
-			 AES_BLOCK_SIZE, AES_BLOCK_SIZE)
+			 AES_BLOCK_SIZE, AES_BLOCK_SIZE),
 };
 
 static int sec_aead_param_check(struct sec_ctx *ctx, struct sec_req *sreq)
@@ -1646,14 +1827,18 @@ int sec_register_to_crypto(struct hisi_qm *qm)
 
 	ret = crypto_register_aeads(sec_aeads, ARRAY_SIZE(sec_aeads));
 	if (ret)
-		crypto_unregister_skciphers(sec_skciphers,
-					    ARRAY_SIZE(sec_skciphers));
+		goto reg_aead_fail;
+	return ret;
+
+reg_aead_fail:
+	crypto_unregister_skciphers(sec_skciphers,
+					ARRAY_SIZE(sec_skciphers));
 	return ret;
 }
 
 void sec_unregister_from_crypto(struct hisi_qm *qm)
 {
-	crypto_unregister_skciphers(sec_skciphers,
-				    ARRAY_SIZE(sec_skciphers));
 	crypto_unregister_aeads(sec_aeads, ARRAY_SIZE(sec_aeads));
+	crypto_unregister_skciphers(sec_skciphers,
+					ARRAY_SIZE(sec_skciphers));
 }
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.h b/drivers/crypto/hisilicon/sec2/sec_crypto.h
index 0e933e7..712176b 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.h
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.h
@@ -44,6 +44,7 @@ enum sec_ckey_type {
 enum sec_bd_type {
 	SEC_BD_TYPE1 = 0x1,
 	SEC_BD_TYPE2 = 0x2,
+	SEC_BD_TYPE3 = 0x3,
 };
 
 enum sec_auth {
@@ -63,6 +64,13 @@ enum sec_addr_type {
 	SEC_PRP  = 0x2,
 };
 
+struct bd_status {
+	u64 tag;
+	u8 done;
+	u8 err_type;
+	u16 flag;
+};
+
 struct sec_sqe_type2 {
 
 	/*
@@ -211,6 +219,167 @@ struct sec_sqe {
 	struct sec_sqe_type2 type2;
 };
 
+#pragma pack(4)
+struct bd3_auth_ivin {
+	__le64 a_ivin_addr;
+	__le32 rsvd0;
+	__le32 rsvd1;
+};
+
+struct bd3_skip_data {
+	__le32 rsvd0;
+
+	/*
+	 * gran_num: 0~15 bits
+	 * reserved: 16~31 bits
+	 */
+	__le32 gran_num;
+
+	/*
+	 * src_skip_data_len: 0~24 bits
+	 * reserved: 25~31 bits
+	 */
+	__le32 src_skip_data_len;
+
+	/*
+	 * dst_skip_data_len: 0~24 bits
+	 * reserved: 25~31 bits
+	 */
+	__le32 dst_skip_data_len;
+};
+
+struct bd3_stream_scene {
+	__le64 c_ivin_addr;
+	__le64 long_a_data_len;
+
+	/*
+	 * auth_pad: 0~1 bits
+	 * stream_protocol: 2~4 bits
+	 * reserved: 5~7 bits
+	 */
+	__u8 stream_auth_pad;
+	__u8 plaintext_type;
+	__le16 pad_len_1p3;
+};
+
+struct bd3_no_scene {
+	__le64 c_ivin_addr;
+	__le32 rsvd0;
+	__le32 rsvd1;
+	__le32 rsvd2;
+};
+
+struct bd3_check_sum {
+	__le16 check_sum_i;
+	__u8 tls_pad_len_i;
+	__u8 rsvd0;
+};
+
+struct bd3_tls_type_back {
+	__u8 tls_1p3_type_back;
+	__u8 rsvd0;
+	__le16 pad_len_1p3_back;
+};
+
+struct sec_sqe3 {
+	/*
+	 * type: 0~3 bit
+	 * inveld: 4 bit
+	 * scene: 5~8 bit
+	 * de: 9~10 bit
+	 * src_addr_type: 11~13 bit
+	 * dst_addr_type: 14~16 bit
+	 * mac_addr_type: 17~19 bit
+	 * reserved: 20~31 bits
+	 */
+	__le32 bd_param;
+
+	/*
+	 * cipher: 0~1 bits
+	 * ci_gen: 2~3 bit
+	 * c_icv_len: 4~9 bit
+	 * c_width: 10~12 bits
+	 * c_key_len: 13~15 bits
+	 */
+	__le16 c_icv_key;
+
+	/*
+	 * c_mode : 0~3 bits
+	 * c_alg : 4~7 bits
+	 */
+	__u8 c_mode_alg;
+
+	/*
+	 * nonce_len : 0~3 bits
+	 * huk : 4 bits
+	 * cal_iv_addr_en : 5 bits
+	 * seq : 6 bits
+	 * reserved : 7 bits
+	 */
+	__u8 huk_iv_seq;
+
+	__le64 tag;
+	__le64 data_src_addr;
+	__le64 a_key_addr;
+	union {
+		struct bd3_auth_ivin auth_ivin;
+		struct bd3_skip_data skip_data;
+	};
+
+	__le64 c_key_addr;
+
+	/*
+	 * auth: 0~1 bits
+	 * ai_gen: 2~3 bits
+	 * mac_len: 4~8 bits
+	 * akey_len: 9~14 bits
+	 * a_alg: 15~20 bits
+	 * key_sel: 21~24 bits
+	 * updata_key: 25 bits
+	 * reserved: 26~31 bits
+	 */
+	__le32 auth_mac_key;
+	__le32 salt;
+	__le16 auth_src_offset;
+	__le16 cipher_src_offset;
+
+	/*
+	 * auth_len: 0~23 bit
+	 * auth_key_offset: 24~31 bits
+	 */
+	__le32 a_len_key;
+
+	/*
+	 * cipher_len: 0~23 bit
+	 * auth_ivin_offset: 24~31 bits
+	 */
+	__le32 c_len_ivin;
+	__le64 data_dst_addr;
+	__le64 mac_addr;
+	union {
+		struct bd3_stream_scene stream_scene;
+		struct bd3_no_scene no_scene;
+	};
+
+	/*
+	 * done: 0 bit
+	 * icv: 1~3 bit
+	 * csc: 4~6 bit
+	 * flag: 7~10 bit
+	 * reserved: 11~15 bit
+	 */
+	__le16 done_flag;
+	__u8 error_type;
+	__u8 warning_type;
+	__le32 mac_i;
+	union {
+		struct bd3_check_sum check_sum;
+		struct bd3_tls_type_back tls_type_back;
+	};
+	__le32 counter;
+};
+#pragma pack()
+
 int sec_register_to_crypto(struct hisi_qm *qm);
 void sec_unregister_from_crypto(struct hisi_qm *qm);
 #endif
-- 
2.8.1

