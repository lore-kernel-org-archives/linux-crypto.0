Return-Path: <SRS0=WlNz=3A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 592FFC33C9E
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Jan 2020 09:02:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CF312077C
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Jan 2020 09:02:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbgAKJCO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 11 Jan 2020 04:02:14 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8695 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728027AbgAKJCO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Jan 2020 04:02:14 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id D5226DF1A1B3DDEA7223;
        Sat, 11 Jan 2020 17:02:11 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.439.0; Sat, 11 Jan 2020 17:02:04 +0800
From:   Zaibo Xu <xuzaibo@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linuxarm@huawei.com>,
        <jonathan.cameron@huawei.com>, <wangzhou1@hisilicon.com>,
        <tanghui20@huawei.com>, <yekai13@huawei.com>,
        <liulongfang@huawei.com>, <qianweili@huawei.com>,
        <fanghao11@huawei.com>, <forest.zhouchang@huawei.com>
Subject: [PATCH 2/4] crypto: hisilicon - Fixed some tiny bugs of HPRE
Date:   Sat, 11 Jan 2020 16:58:16 +0800
Message-ID: <1578733098-13863-3-git-send-email-xuzaibo@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1578733098-13863-1-git-send-email-xuzaibo@huawei.com>
References: <1578733098-13863-1-git-send-email-xuzaibo@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

1.Use memzero_explicit to clear key;
2.Fix some little endian writings;
3.Fix some other bugs and stuff of code style;

Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 62 +++++++++++++----------------
 drivers/crypto/hisilicon/hpre/hpre_main.c   |  8 ++--
 2 files changed, 32 insertions(+), 38 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index d8b0152..76540a1 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -174,8 +174,8 @@ static struct hisi_qp *hpre_get_qp_and_start(void)
 }
 
 static int hpre_get_data_dma_addr(struct hpre_asym_request *hpre_req,
-			      struct scatterlist *data, unsigned int len,
-			      int is_src, dma_addr_t *tmp)
+				  struct scatterlist *data, unsigned int len,
+				  int is_src, dma_addr_t *tmp)
 {
 	struct hpre_ctx *ctx = hpre_req->ctx;
 	struct device *dev = HPRE_DEV(ctx);
@@ -199,8 +199,8 @@ static int hpre_get_data_dma_addr(struct hpre_asym_request *hpre_req,
 }
 
 static int hpre_prepare_dma_buf(struct hpre_asym_request *hpre_req,
-			       struct scatterlist *data, unsigned int len,
-			       int is_src, dma_addr_t *tmp)
+				struct scatterlist *data, unsigned int len,
+				int is_src, dma_addr_t *tmp)
 {
 	struct hpre_ctx *ctx = hpre_req->ctx;
 	struct device *dev = HPRE_DEV(ctx);
@@ -226,12 +226,12 @@ static int hpre_prepare_dma_buf(struct hpre_asym_request *hpre_req,
 }
 
 static int hpre_hw_data_init(struct hpre_asym_request *hpre_req,
-			 struct scatterlist *data, unsigned int len,
-			 int is_src, int is_dh)
+			     struct scatterlist *data, unsigned int len,
+			     int is_src, int is_dh)
 {
 	struct hpre_sqe *msg = &hpre_req->req;
 	struct hpre_ctx *ctx = hpre_req->ctx;
-	dma_addr_t tmp;
+	dma_addr_t tmp = 0;
 	int ret;
 
 	/* when the data is dh's source, we should format it */
@@ -253,8 +253,9 @@ static int hpre_hw_data_init(struct hpre_asym_request *hpre_req,
 }
 
 static void hpre_hw_data_clr_all(struct hpre_ctx *ctx,
-			     struct hpre_asym_request *req,
-			     struct scatterlist *dst, struct scatterlist *src)
+				 struct hpre_asym_request *req,
+				 struct scatterlist *dst,
+				 struct scatterlist *src)
 {
 	struct device *dev = HPRE_DEV(ctx);
 	struct hpre_sqe *sqe = &req->req;
@@ -288,7 +289,7 @@ static void hpre_hw_data_clr_all(struct hpre_ctx *ctx,
 }
 
 static int hpre_alg_res_post_hf(struct hpre_ctx *ctx, struct hpre_sqe *sqe,
-			    void **kreq)
+				void **kreq)
 {
 	struct hpre_asym_request *req;
 	int err, id, done;
@@ -375,7 +376,7 @@ static void hpre_alg_cb(struct hisi_qp *qp, void *resp)
 	struct hpre_ctx *ctx = qp->qp_ctx;
 	struct hpre_sqe *sqe = resp;
 
-	ctx->req_list[sqe->tag]->cb(ctx, resp);
+	ctx->req_list[le16_to_cpu(sqe->tag)]->cb(ctx, resp);
 }
 
 static int hpre_ctx_init(struct hpre_ctx *ctx)
@@ -454,9 +455,6 @@ static int hpre_dh_compute_value(struct kpp_request *req)
 	int ctr = 0;
 	int ret;
 
-	if (!ctx)
-		return -EINVAL;
-
 	ret = hpre_msg_request_set(ctx, req, false);
 	if (ret)
 		return ret;
@@ -472,9 +470,9 @@ static int hpre_dh_compute_value(struct kpp_request *req)
 		goto clear_all;
 
 	if (ctx->crt_g2_mode && !req->src)
-		msg->dw0 |= HPRE_ALG_DH_G2;
+		msg->dw0 = cpu_to_le32(le32_to_cpu(msg->dw0) | HPRE_ALG_DH_G2);
 	else
-		msg->dw0 |= HPRE_ALG_DH;
+		msg->dw0 = cpu_to_le32(le32_to_cpu(msg->dw0) | HPRE_ALG_DH);
 	do {
 		ret = hisi_qp_send(ctx->qp, msg);
 	} while (ret == -EBUSY && ctr++ < HPRE_TRY_SEND_TIMES);
@@ -520,12 +518,12 @@ static int hpre_dh_set_params(struct hpre_ctx *ctx, struct dh *params)
 		return -EINVAL;
 
 	if (hpre_is_dh_params_length_valid(params->p_size <<
-		HPRE_BITS_2_BYTES_SHIFT))
+					   HPRE_BITS_2_BYTES_SHIFT))
 		return -EINVAL;
 
 	sz = ctx->key_sz = params->p_size;
 	ctx->dh.xa_p = dma_alloc_coherent(dev, sz << 1,
-				&ctx->dh.dma_xa_p, GFP_KERNEL);
+					  &ctx->dh.dma_xa_p, GFP_KERNEL);
 	if (!ctx->dh.xa_p)
 		return -ENOMEM;
 
@@ -559,13 +557,12 @@ static void hpre_dh_clear_ctx(struct hpre_ctx *ctx, bool is_clear_all)
 		hisi_qm_stop_qp(ctx->qp);
 
 	if (ctx->dh.g) {
-		memset(ctx->dh.g, 0, sz);
 		dma_free_coherent(dev, sz, ctx->dh.g, ctx->dh.dma_g);
 		ctx->dh.g = NULL;
 	}
 
 	if (ctx->dh.xa_p) {
-		memset(ctx->dh.xa_p, 0, sz);
+		memzero_explicit(ctx->dh.xa_p, sz);
 		dma_free_coherent(dev, sz << 1, ctx->dh.xa_p,
 				  ctx->dh.dma_xa_p);
 		ctx->dh.xa_p = NULL;
@@ -661,9 +658,6 @@ static int hpre_rsa_enc(struct akcipher_request *req)
 	int ctr = 0;
 	int ret;
 
-	if (!ctx)
-		return -EINVAL;
-
 	/* For 512 and 1536 bits key size, use soft tfm instead */
 	if (ctx->key_sz == HPRE_RSA_512BITS_KSZ ||
 	    ctx->key_sz == HPRE_RSA_1536BITS_KSZ) {
@@ -680,7 +674,7 @@ static int hpre_rsa_enc(struct akcipher_request *req)
 	if (ret)
 		return ret;
 
-	msg->dw0 |= HPRE_ALG_NC_NCRT;
+	msg->dw0 |= cpu_to_le32(HPRE_ALG_NC_NCRT);
 	msg->key = cpu_to_le64((u64)ctx->rsa.dma_pubkey);
 
 	ret = hpre_hw_data_init(hpre_req, req->src, req->src_len, 1, 0);
@@ -716,9 +710,6 @@ static int hpre_rsa_dec(struct akcipher_request *req)
 	int ctr = 0;
 	int ret;
 
-	if (!ctx)
-		return -EINVAL;
-
 	/* For 512 and 1536 bits key size, use soft tfm instead */
 	if (ctx->key_sz == HPRE_RSA_512BITS_KSZ ||
 	    ctx->key_sz == HPRE_RSA_1536BITS_KSZ) {
@@ -737,10 +728,12 @@ static int hpre_rsa_dec(struct akcipher_request *req)
 
 	if (ctx->crt_g2_mode) {
 		msg->key = cpu_to_le64((u64)ctx->rsa.dma_crt_prikey);
-		msg->dw0 |= HPRE_ALG_NC_CRT;
+		msg->dw0 = cpu_to_le32(le32_to_cpu(msg->dw0) |
+				       HPRE_ALG_NC_CRT);
 	} else {
 		msg->key = cpu_to_le64((u64)ctx->rsa.dma_prikey);
-		msg->dw0 |= HPRE_ALG_NC_NCRT;
+		msg->dw0 = cpu_to_le32(le32_to_cpu(msg->dw0) |
+				       HPRE_ALG_NC_NCRT);
 	}
 
 	ret = hpre_hw_data_init(hpre_req, req->src, req->src_len, 1, 0);
@@ -811,10 +804,8 @@ static int hpre_rsa_set_e(struct hpre_ctx *ctx, const char *value,
 
 	hpre_rsa_drop_leading_zeros(&ptr, &vlen);
 
-	if (!ctx->key_sz || !vlen || vlen > ctx->key_sz) {
-		ctx->rsa.pubkey = NULL;
+	if (!ctx->key_sz || !vlen || vlen > ctx->key_sz)
 		return -EINVAL;
-	}
 
 	memcpy(ctx->rsa.pubkey + ctx->key_sz - vlen, ptr, vlen);
 
@@ -899,7 +890,7 @@ static int hpre_rsa_setkey_crt(struct hpre_ctx *ctx, struct rsa_key *rsa_key)
 
 free_key:
 	offset = hlf_ksz * HPRE_CRT_PRMS;
-	memset(ctx->rsa.crt_prikey, 0, offset);
+	memzero_explicit(ctx->rsa.crt_prikey, offset);
 	dma_free_coherent(dev, hlf_ksz * HPRE_CRT_PRMS, ctx->rsa.crt_prikey,
 			  ctx->rsa.dma_crt_prikey);
 	ctx->rsa.crt_prikey = NULL;
@@ -924,14 +915,15 @@ static void hpre_rsa_clear_ctx(struct hpre_ctx *ctx, bool is_clear_all)
 	}
 
 	if (ctx->rsa.crt_prikey) {
-		memset(ctx->rsa.crt_prikey, 0, half_key_sz * HPRE_CRT_PRMS);
+		memzero_explicit(ctx->rsa.crt_prikey,
+				 half_key_sz * HPRE_CRT_PRMS);
 		dma_free_coherent(dev, half_key_sz * HPRE_CRT_PRMS,
 				  ctx->rsa.crt_prikey, ctx->rsa.dma_crt_prikey);
 		ctx->rsa.crt_prikey = NULL;
 	}
 
 	if (ctx->rsa.prikey) {
-		memset(ctx->rsa.prikey, 0, ctx->key_sz);
+		memzero_explicit(ctx->rsa.prikey, ctx->key_sz);
 		dma_free_coherent(dev, ctx->key_sz << 1, ctx->rsa.prikey,
 				  ctx->rsa.dma_prikey);
 		ctx->rsa.prikey = NULL;
diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 753e43d..401747d 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -73,7 +73,7 @@
 #define HPRE_DBGFS_VAL_MAX_LEN		20
 #define HPRE_PCI_DEVICE_ID		0xa258
 #define HPRE_PCI_VF_DEVICE_ID		0xa259
-#define HPRE_ADDR(qm, offset)		(qm->io_base + (offset))
+#define HPRE_ADDR(qm, offset)		((qm)->io_base + (offset))
 #define HPRE_QM_USR_CFG_MASK		0xfffffffe
 #define HPRE_QM_AXI_CFG_MASK		0xffff
 #define HPRE_QM_VFG_AX_MASK		0xff
@@ -490,7 +490,7 @@ static ssize_t hpre_ctrl_debug_read(struct file *filp, char __user *buf,
 		return -EINVAL;
 	}
 	spin_unlock_irq(&file->lock);
-	ret = sprintf(tbuf, "%u\n", val);
+	ret = snprintf(tbuf, HPRE_DBGFS_VAL_MAX_LEN, "%u\n", val);
 	return simple_read_from_buffer(buf, count, pos, tbuf, ret);
 }
 
@@ -607,7 +607,9 @@ static int hpre_cluster_debugfs_init(struct hpre_debug *debug)
 	int i, ret;
 
 	for (i = 0; i < HPRE_CLUSTERS_NUM; i++) {
-		sprintf(buf, "cluster%d", i);
+		ret = snprintf(buf, HPRE_DBGFS_VAL_MAX_LEN, "cluster%d", i);
+		if (ret < 0)
+			return -EINVAL;
 		tmp_d = debugfs_create_dir(buf, debug->debug_root);
 
 		regset = devm_kzalloc(dev, sizeof(*regset), GFP_KERNEL);
-- 
2.8.1

