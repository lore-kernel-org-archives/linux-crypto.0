Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E7C1C4167B
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Dec 2020 11:15:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B38A23D98
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Dec 2020 11:15:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733258AbgLJLPB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Dec 2020 06:15:01 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8742 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389334AbgLJLMt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Dec 2020 06:12:49 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CsB795rVfzknLG;
        Thu, 10 Dec 2020 19:11:17 +0800 (CST)
Received: from huawei.com (10.67.165.24) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Thu, 10 Dec 2020
 19:11:54 +0800
From:   Longfang Liu <liulongfang@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 5/6] crypto: hisilicon/sec - fixes some coding style
Date:   Thu, 10 Dec 2020 19:10:06 +0800
Message-ID: <1607598607-8728-6-git-send-email-liulongfang@huawei.com>
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

1. Fix a problem of error log printing
2. Modify error log printing style

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec.h        |  5 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 94 +++++++++++++++---------------
 drivers/crypto/hisilicon/sec2/sec_crypto.h |  4 +-
 3 files changed, 49 insertions(+), 54 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
index 74f7eeb..5563282 100644
--- a/drivers/crypto/hisilicon/sec2/sec.h
+++ b/drivers/crypto/hisilicon/sec2/sec.h
@@ -4,8 +4,6 @@
 #ifndef __HISI_SEC_V2_H
 #define __HISI_SEC_V2_H
 
-#include <linux/list.h>
-
 #include "../qm.h"
 #include "sec_crypto.h"
 
@@ -57,7 +55,7 @@ struct sec_req {
 
 	int err_type;
 	int req_id;
-	int flag;
+	u32 flag;
 
 	/* Status of the SEC request */
 	bool fake_busy;
@@ -147,6 +145,7 @@ struct sec_ctx {
 	struct sec_cipher_ctx c_ctx;
 	struct sec_auth_ctx a_ctx;
 	u8 type_supported;
+	struct device *dev;
 };
 
 enum sec_endian {
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index f09f4d7..87b0c56 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -41,7 +41,6 @@
 #define SEC_CKEY_OFFSET_V3	13
 #define SEC_SRC_SGL_OFFSET_V3	11
 #define SEC_DST_SGL_OFFSET_V3	14
-#define SEC_CI_GEN_OFFSET_V3	2
 #define SEC_CALG_OFFSET_V3	4
 
 #define SEC_AKEY_OFFSET_V3         9
@@ -58,7 +57,6 @@
 
 #define SEC_TOTAL_IV_SZ		(SEC_IV_SIZE * QM_Q_DEPTH)
 #define SEC_SGL_SGE_NR		128
-#define SEC_CTX_DEV(ctx)	(&(ctx)->sec->qm.pdev->dev)
 #define SEC_CIPHER_AUTH		0xfe
 #define SEC_AUTH_CIPHER		0x1
 #define SEC_MAX_MAC_LEN		64
@@ -126,7 +124,7 @@ static int sec_alloc_req_id(struct sec_req *req, struct sec_qp_ctx *qp_ctx)
 				  0, QM_Q_DEPTH, GFP_ATOMIC);
 	mutex_unlock(&qp_ctx->req_lock);
 	if (unlikely(req_id < 0)) {
-		dev_err(SEC_CTX_DEV(req->ctx), "alloc req id fail!\n");
+		dev_err(req->ctx->dev, "alloc req id fail!\n");
 		return req_id;
 	}
 
@@ -142,7 +140,7 @@ static void sec_free_req_id(struct sec_req *req)
 	int req_id = req->req_id;
 
 	if (unlikely(req_id < 0 || req_id >= QM_Q_DEPTH)) {
-		dev_err(SEC_CTX_DEV(req->ctx), "free request id invalid!\n");
+		dev_err(req->ctx->dev, "free request id invalid!\n");
 		return;
 	}
 
@@ -168,7 +166,7 @@ static int sec_aead_verify(struct sec_req *req)
 				aead_req->cryptlen + aead_req->assoclen -
 				authsize);
 	if (unlikely(sz != authsize || memcmp(mac_out, mac, sz))) {
-		dev_err(SEC_CTX_DEV(req->ctx), "aead verify failure!\n");
+		dev_err(req->ctx->dev, "aead verify failure!\n");
 		return -EBADMSG;
 	}
 
@@ -237,7 +235,7 @@ static void sec_req_cb(struct hisi_qp *qp, void *resp)
 	if (unlikely(req->err_type || status.done != SEC_SQE_DONE ||
 	    (ctx->alg_type == SEC_SKCIPHER && status.flag != SEC_SQE_CFLAG) ||
 	    (ctx->alg_type == SEC_AEAD && status.flag != SEC_SQE_AEAD_FLAG))) {
-		dev_err_ratelimited(SEC_CTX_DEV(ctx),
+		dev_err_ratelimited(ctx->dev,
 			"err_type[%d],done[%u],flag[%u]\n",
 			req->err_type, status.done, status.flag);
 		err = -EIO;
@@ -412,8 +410,8 @@ static int sec_alloc_pbuf_resource(struct device *dev, struct sec_alg_res *res)
 static int sec_alg_resource_alloc(struct sec_ctx *ctx,
 				  struct sec_qp_ctx *qp_ctx)
 {
-	struct device *dev = SEC_CTX_DEV(ctx);
 	struct sec_alg_res *res = qp_ctx->res;
+	struct device *dev = ctx->dev;
 	int ret;
 
 	ret = sec_alloc_civ_resource(dev, res);
@@ -453,7 +451,7 @@ static int sec_alg_resource_alloc(struct sec_ctx *ctx,
 static void sec_alg_resource_free(struct sec_ctx *ctx,
 				  struct sec_qp_ctx *qp_ctx)
 {
-	struct device *dev = SEC_CTX_DEV(ctx);
+	struct device *dev = ctx->dev;
 
 	sec_free_civ_resource(dev, qp_ctx->res);
 
@@ -466,7 +464,7 @@ static void sec_alg_resource_free(struct sec_ctx *ctx,
 static int sec_create_qp_ctx(struct hisi_qm *qm, struct sec_ctx *ctx,
 			     int qp_ctx_id, int alg_type)
 {
-	struct device *dev = SEC_CTX_DEV(ctx);
+	struct device *dev = ctx->dev;
 	struct sec_qp_ctx *qp_ctx;
 	struct hisi_qp *qp;
 	int ret = -ENOMEM;
@@ -522,7 +520,7 @@ static int sec_create_qp_ctx(struct hisi_qm *qm, struct sec_ctx *ctx,
 static void sec_release_qp_ctx(struct sec_ctx *ctx,
 			       struct sec_qp_ctx *qp_ctx)
 {
-	struct device *dev = SEC_CTX_DEV(ctx);
+	struct device *dev = ctx->dev;
 
 	hisi_qm_stop_qp(qp_ctx->qp);
 	sec_alg_resource_free(ctx, qp_ctx);
@@ -546,6 +544,7 @@ static int sec_ctx_base_init(struct sec_ctx *ctx)
 
 	sec = container_of(ctx->qps[0]->qm, struct sec_dev, qm);
 	ctx->sec = sec;
+	ctx->dev = &sec->qm.pdev->dev;
 	ctx->hlf_q_num = sec->ctx_q_num >> 1;
 
 	ctx->pbuf_supported = ctx->sec->iommu_used;
@@ -570,11 +569,9 @@ static int sec_ctx_base_init(struct sec_ctx *ctx)
 err_sec_release_qp_ctx:
 	for (i = i - 1; i >= 0; i--)
 		sec_release_qp_ctx(ctx, &ctx->qp_ctx[i]);
-
 	kfree(ctx->qp_ctx);
 err_destroy_qps:
 	sec_destroy_qps(ctx->qps, sec->ctx_q_num);
-
 	return ret;
 }
 
@@ -593,7 +590,7 @@ static int sec_cipher_init(struct sec_ctx *ctx)
 {
 	struct sec_cipher_ctx *c_ctx = &ctx->c_ctx;
 
-	c_ctx->c_key = dma_alloc_coherent(SEC_CTX_DEV(ctx), SEC_MAX_KEY_SIZE,
+	c_ctx->c_key = dma_alloc_coherent(ctx->dev, SEC_MAX_KEY_SIZE,
 					  &c_ctx->c_key_dma, GFP_KERNEL);
 	if (!c_ctx->c_key)
 		return -ENOMEM;
@@ -606,15 +603,16 @@ static void sec_cipher_uninit(struct sec_ctx *ctx)
 	struct sec_cipher_ctx *c_ctx = &ctx->c_ctx;
 
 	memzero_explicit(c_ctx->c_key, SEC_MAX_KEY_SIZE);
-	dma_free_coherent(SEC_CTX_DEV(ctx), SEC_MAX_KEY_SIZE,
+	dma_free_coherent(ctx->dev, SEC_MAX_KEY_SIZE,
 			  c_ctx->c_key, c_ctx->c_key_dma);
 }
 
 static int sec_auth_init(struct sec_ctx *ctx)
 {
 	struct sec_auth_ctx *a_ctx = &ctx->a_ctx;
+	struct device *dev = ctx->dev;
 
-	a_ctx->a_key = dma_alloc_coherent(SEC_CTX_DEV(ctx), SEC_MAX_KEY_SIZE,
+	a_ctx->a_key = dma_alloc_coherent(dev, SEC_MAX_KEY_SIZE,
 					  &a_ctx->a_key_dma, GFP_KERNEL);
 	if (!a_ctx->a_key)
 		return -ENOMEM;
@@ -625,9 +623,10 @@ static int sec_auth_init(struct sec_ctx *ctx)
 static void sec_auth_uninit(struct sec_ctx *ctx)
 {
 	struct sec_auth_ctx *a_ctx = &ctx->a_ctx;
+	struct device *dev = ctx->dev;
 
 	memzero_explicit(a_ctx->a_key, SEC_MAX_KEY_SIZE);
-	dma_free_coherent(SEC_CTX_DEV(ctx), SEC_MAX_KEY_SIZE,
+	dma_free_coherent(dev, SEC_MAX_KEY_SIZE,
 			  a_ctx->a_key, a_ctx->a_key_dma);
 }
 
@@ -640,7 +639,7 @@ static int sec_skcipher_init(struct crypto_skcipher *tfm)
 	crypto_skcipher_set_reqsize(tfm, sizeof(struct sec_req));
 	ctx->c_ctx.ivsize = crypto_skcipher_ivsize(tfm);
 	if (ctx->c_ctx.ivsize > SEC_IV_SIZE) {
-		dev_err(SEC_CTX_DEV(ctx), "get error skcipher iv size!\n");
+		pr_err("get error skcipher iv size!\n");
 		return -EINVAL;
 	}
 
@@ -733,12 +732,13 @@ static int sec_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 {
 	struct sec_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct sec_cipher_ctx *c_ctx = &ctx->c_ctx;
+	struct device *dev = ctx->dev;
 	int ret;
 
 	if (c_mode == SEC_CMODE_XTS) {
 		ret = xts_verify_key(tfm, key, keylen);
 		if (ret) {
-			dev_err(SEC_CTX_DEV(ctx), "xts mode key err!\n");
+			dev_err(dev, "xts mode key err!\n");
 			return ret;
 		}
 	}
@@ -759,7 +759,7 @@ static int sec_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	}
 
 	if (ret) {
-		dev_err(SEC_CTX_DEV(ctx), "set sec key err!\n");
+		dev_err(dev, "set sec key err!\n");
 		return ret;
 	}
 
@@ -774,7 +774,7 @@ static int sec_cipher_pbuf_map(struct sec_ctx *ctx, struct sec_req *req,
 	struct aead_request *aead_req = req->aead_req.aead_req;
 	struct sec_cipher_req *c_req = &req->c_req;
 	struct sec_qp_ctx *qp_ctx = req->qp_ctx;
-	struct device *dev = SEC_CTX_DEV(ctx);
+	struct device *dev = ctx->dev;
 	int copy_size, pbuf_length;
 	int req_id = req->req_id;
 
@@ -784,9 +784,7 @@ static int sec_cipher_pbuf_map(struct sec_ctx *ctx, struct sec_req *req,
 		copy_size = c_req->c_len;
 
 	pbuf_length = sg_copy_to_buffer(src, sg_nents(src),
-				qp_ctx->res[req_id].pbuf,
-				copy_size);
-
+			qp_ctx->res[req_id].pbuf, copy_size);
 	if (unlikely(pbuf_length != copy_size)) {
 		dev_err(dev, "copy src data to pbuf error!\n");
 		return -EINVAL;
@@ -810,7 +808,6 @@ static void sec_cipher_pbuf_unmap(struct sec_ctx *ctx, struct sec_req *req,
 	struct aead_request *aead_req = req->aead_req.aead_req;
 	struct sec_cipher_req *c_req = &req->c_req;
 	struct sec_qp_ctx *qp_ctx = req->qp_ctx;
-	struct device *dev = SEC_CTX_DEV(ctx);
 	int copy_size, pbuf_length;
 	int req_id = req->req_id;
 
@@ -820,11 +817,9 @@ static void sec_cipher_pbuf_unmap(struct sec_ctx *ctx, struct sec_req *req,
 		copy_size = c_req->c_len;
 
 	pbuf_length = sg_copy_from_buffer(dst, sg_nents(dst),
-				qp_ctx->res[req_id].pbuf,
-				copy_size);
-
+			qp_ctx->res[req_id].pbuf, copy_size);
 	if (unlikely(pbuf_length != copy_size))
-		dev_err(dev, "copy pbuf data to dst error!\n");
+		dev_err(ctx->dev, "copy pbuf data to dst error!\n");
 }
 
 static int sec_cipher_map(struct sec_ctx *ctx, struct sec_req *req,
@@ -834,7 +829,7 @@ static int sec_cipher_map(struct sec_ctx *ctx, struct sec_req *req,
 	struct sec_aead_req *a_req = &req->aead_req;
 	struct sec_qp_ctx *qp_ctx = req->qp_ctx;
 	struct sec_alg_res *res = &qp_ctx->res[req->req_id];
-	struct device *dev = SEC_CTX_DEV(ctx);
+	struct device *dev = ctx->dev;
 	int ret;
 
 	if (req->use_pbuf) {
@@ -893,7 +888,7 @@ static void sec_cipher_unmap(struct sec_ctx *ctx, struct sec_req *req,
 			     struct scatterlist *src, struct scatterlist *dst)
 {
 	struct sec_cipher_req *c_req = &req->c_req;
-	struct device *dev = SEC_CTX_DEV(ctx);
+	struct device *dev = ctx->dev;
 
 	if (req->use_pbuf) {
 		sec_cipher_pbuf_unmap(ctx, req, dst);
@@ -978,6 +973,7 @@ static int sec_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 {
 	struct sec_ctx *ctx = crypto_aead_ctx(tfm);
 	struct sec_cipher_ctx *c_ctx = &ctx->c_ctx;
+	struct device *dev = ctx->dev;
 	struct crypto_authenc_keys keys;
 	int ret;
 
@@ -989,7 +985,7 @@ static int sec_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 	if (c_mode == SEC_CMODE_CCM || c_mode == SEC_CMODE_GCM) {
 		ret = sec_skcipher_aes_sm4_setkey(c_ctx, keylen, c_mode);
 		if (ret) {
-			dev_err(SEC_CTX_DEV(ctx), "set sec aes ccm cipher key err!\n");
+			dev_err(dev, "set sec aes ccm cipher key err!\n");
 			return ret;
 		}
 		memcpy(c_ctx->c_key, key, keylen);
@@ -1002,19 +998,19 @@ static int sec_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 
 	ret = sec_aead_aes_set_key(c_ctx, &keys);
 	if (ret) {
-		dev_err(SEC_CTX_DEV(ctx), "set sec cipher key err!\n");
+		dev_err(dev, "set sec cipher key err!\n");
 		goto bad_key;
 	}
 
 	ret = sec_aead_auth_set_key(&ctx->a_ctx, &keys);
 	if (ret) {
-		dev_err(SEC_CTX_DEV(ctx), "set sec auth key err!\n");
+		dev_err(dev, "set sec auth key err!\n");
 		goto bad_key;
 	}
 
 	if ((ctx->a_ctx.mac_len & SEC_SQE_LEN_RATE_MASK)  ||
 		(ctx->a_ctx.a_key_len & SEC_SQE_LEN_RATE_MASK)) {
-		dev_err(SEC_CTX_DEV(ctx), "MAC or AUTH key length error!\n");
+		dev_err(dev, "MAC or AUTH key length error!\n");
 		goto bad_key;
 	}
 
@@ -1130,7 +1126,7 @@ static int sec_skcipher_bd_fill_v3(struct sec_ctx *ctx, struct sec_req *req)
 	struct sec_cipher_ctx *c_ctx = &ctx->c_ctx;
 	struct sec_cipher_req *c_req = &req->c_req;
 	u32 bd_param = 0;
-	u16 cipher = 0;
+	u16 cipher;
 
 	memset(sec_sqe3, 0, sizeof(struct sec_sqe3));
 
@@ -1139,7 +1135,7 @@ static int sec_skcipher_bd_fill_v3(struct sec_ctx *ctx, struct sec_req *req)
 	sec_sqe3->data_src_addr = cpu_to_le64(c_req->c_in_dma);
 	sec_sqe3->data_dst_addr = cpu_to_le64(c_req->c_out_dma);
 
-	sec_sqe3->c_mode_alg = (c_ctx->c_alg << SEC_CALG_OFFSET_V3) |
+	sec_sqe3->c_mode_alg = ((u8)c_ctx->c_alg << SEC_CALG_OFFSET_V3) |
 						c_ctx->c_mode;
 	sec_sqe3->c_icv_key |= cpu_to_le16(((u16)c_ctx->c_key_len) <<
 						SEC_CKEY_OFFSET_V3);
@@ -1209,7 +1205,7 @@ static void sec_update_iv(struct sec_req *req, enum sec_alg_type alg_type)
 		sz = sg_pcopy_to_buffer(sgl, sg_nents(sgl), iv, iv_size,
 				cryptlen - iv_size);
 		if (unlikely(sz != iv_size))
-			dev_err(SEC_CTX_DEV(req->ctx), "copy output iv error!\n");
+			dev_err(req->ctx->dev, "copy output iv error!\n");
 	} else {
 		sz = cryptlen / iv_size;
 		if (cryptlen % iv_size)
@@ -1419,7 +1415,7 @@ static int sec_aead_bd_fill(struct sec_ctx *ctx, struct sec_req *req)
 
 	ret = sec_skcipher_bd_fill(ctx, req);
 	if (unlikely(ret)) {
-		dev_err(SEC_CTX_DEV(ctx), "skcipher bd fill is error!\n");
+		dev_err(ctx->dev, "skcipher bd fill is error!\n");
 		return ret;
 	}
 
@@ -1473,7 +1469,7 @@ static int sec_aead_bd_fill_v3(struct sec_ctx *ctx, struct sec_req *req)
 
 	ret = sec_skcipher_bd_fill_v3(ctx, req);
 	if (unlikely(ret)) {
-		dev_err(SEC_CTX_DEV(ctx), "skcipher bd3 fill is error!\n");
+		dev_err(ctx->dev, "skcipher bd3 fill is error!\n");
 		return ret;
 	}
 
@@ -1513,7 +1509,7 @@ static void sec_aead_callback(struct sec_ctx *c, struct sec_req *req, int err)
 					  a_req->assoclen);
 
 		if (unlikely(sz != authsize)) {
-			dev_err(SEC_CTX_DEV(req->ctx), "copy out mac err!\n");
+			dev_err(c->dev, "copy out mac err!\n");
 			err = -EINVAL;
 		}
 	}
@@ -1579,7 +1575,7 @@ static int sec_process(struct sec_ctx *ctx, struct sec_req *req)
 	ret = ctx->req_op->bd_send(ctx, req);
 	if (unlikely((ret != -EBUSY && ret != -EINPROGRESS) ||
 		(ret == -EBUSY && !(req->flag & CRYPTO_TFM_REQ_MAY_BACKLOG)))) {
-		dev_err_ratelimited(SEC_CTX_DEV(ctx), "send sec request failed!\n");
+		dev_err_ratelimited(ctx->dev, "send sec request failed!\n");
 		goto err_send_req;
 	}
 
@@ -1733,7 +1729,7 @@ static int sec_aead_ctx_init(struct crypto_aead *tfm, const char *hash_name)
 
 	auth_ctx->hash_tfm = crypto_alloc_shash(hash_name, 0, 0);
 	if (IS_ERR(auth_ctx->hash_tfm)) {
-		dev_err(SEC_CTX_DEV(ctx), "aead alloc shash error!\n");
+		dev_err(ctx->dev, "aead alloc shash error!\n");
 		sec_aead_exit(tfm);
 		return PTR_ERR(auth_ctx->hash_tfm);
 	}
@@ -1777,7 +1773,7 @@ static int sec_aead_gcm_ctx_init(struct crypto_aead *tfm)
 static int sec_skcipher_param_check(struct sec_ctx *ctx, struct sec_req *sreq)
 {
 	struct skcipher_request *sk_req = sreq->c_req.sk_req;
-	struct device *dev = SEC_CTX_DEV(ctx);
+	struct device *dev = ctx->dev;
 	u8 c_alg = ctx->c_ctx.c_alg;
 	u8 c_mode = ctx->c_ctx.c_mode;
 
@@ -1951,17 +1947,18 @@ static int sec_aead_spec_check(struct sec_ctx *ctx, struct sec_req *sreq)
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	size_t authsize = crypto_aead_authsize(tfm);
 	u8 c_mode = ctx->c_ctx.c_mode;
+	struct device *dev = ctx->dev;
 
 	if (unlikely(req->cryptlen + req->assoclen > MAX_INPUT_DATA_LEN ||
 		req->assoclen > SEC_MAX_AAD_LEN)) {
-		dev_err(SEC_CTX_DEV(ctx), "aead input spec error!\n");
+		dev_err(dev, "aead input spec error!\n");
 		return -EINVAL;
 	}
 
 	if (unlikely((c_mode == SEC_CMODE_GCM && authsize < DES_BLOCK_SIZE) ||
 		(c_mode == SEC_CMODE_CCM && (authsize < MIN_MAC_LEN ||
 		authsize & MAC_LEN_MASK)))) {
-		dev_err(SEC_CTX_DEV(ctx), "aead input mac length error!\n");
+		dev_err(dev, "aead input mac length error!\n");
 		return -EINVAL;
 	}
 
@@ -1973,7 +1970,7 @@ static int sec_aead_spec_check(struct sec_ctx *ctx, struct sec_req *sreq)
 	if (c_mode == SEC_CMODE_CBC) {
 		if (unlikely(sreq->c_req.c_len & (AES_BLOCK_SIZE - 1) ||
 		    sreq->c_req.c_len <= 0)) {
-			dev_err(SEC_CTX_DEV(ctx), "aead crypto length error!\n");
+			dev_err(dev, "aead crypto length error!\n");
 			return -EINVAL;
 		}
 	}
@@ -1985,15 +1982,16 @@ static int sec_aead_param_check(struct sec_ctx *ctx, struct sec_req *sreq)
 {
 	struct aead_request *req = sreq->aead_req.aead_req;
 	u8 c_alg = ctx->c_ctx.c_alg;
+	struct device *dev = ctx->dev;
 
 	if (unlikely(!req->src || !req->dst)) {
-		dev_err(SEC_CTX_DEV(ctx), "aead input param error!\n");
+		dev_err(dev, "aead input param error!\n");
 		return -EINVAL;
 	}
 
 	/* Support AES or SM4 */
 	if (unlikely(c_alg != SEC_CALG_AES && c_alg != SEC_CALG_SM4)) {
-		dev_err(SEC_CTX_DEV(ctx), "aead crypto alg error!\n");
+		dev_err(dev, "aead crypto alg error!\n");
 		return -EINVAL;
 	}
 
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.h b/drivers/crypto/hisilicon/sec2/sec_crypto.h
index e58008a..0115584 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.h
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.h
@@ -79,7 +79,6 @@ struct bd_status {
 };
 
 struct sec_sqe_type2 {
-
 	/*
 	 * mac_len: 0~4 bits
 	 * a_key_len: 5~10 bits
@@ -135,7 +134,6 @@ struct sec_sqe_type2 {
 	/* c_pad_len_field: 0~1 bits */
 	__le16 c_pad_len_field;
 
-
 	__le64 long_a_data_len;
 	__le64 a_ivin_addr;
 	__le64 a_key_addr;
@@ -290,7 +288,7 @@ struct bd3_tls_type_back {
 struct sec_sqe3 {
 	/*
 	 * type: 0~3 bit
-	 * inveld: 4 bit
+	 * bd_invalid: 4 bit
 	 * scene: 5~8 bit
 	 * de: 9~10 bit
 	 * src_addr_type: 11~13 bit
-- 
2.8.1

