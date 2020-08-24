Return-Path: <SRS0=tkOt=CC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70643C433E3
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Aug 2020 03:14:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CE6C207CD
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Aug 2020 03:14:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbgHXDOv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 23 Aug 2020 23:14:51 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:43294 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728120AbgHXDOc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 23 Aug 2020 23:14:32 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id BDC52F07EDE23A515705;
        Mon, 24 Aug 2020 11:14:24 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Mon, 24 Aug 2020 11:14:15 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH RESEND 06/10] crypto: hisilicon/zip - add print for error branch
Date:   Mon, 24 Aug 2020 11:11:45 +0800
Message-ID: <1598238709-58699-7-git-send-email-shenyang39@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1598238709-58699-1-git-send-email-shenyang39@huawei.com>
References: <1598238709-58699-1-git-send-email-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add print for some error branches.

Signed-off-by: Yang Shen <shenyang39@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/zip/zip_crypto.c | 68 +++++++++++++++++++++++--------
 drivers/crypto/hisilicon/zip/zip_main.c   |  8 ++--
 2 files changed, 56 insertions(+), 20 deletions(-)

diff --git a/drivers/crypto/hisilicon/zip/zip_crypto.c b/drivers/crypto/hisilicon/zip/zip_crypto.c
index c2ea849..7aa8a55 100644
--- a/drivers/crypto/hisilicon/zip/zip_crypto.c
+++ b/drivers/crypto/hisilicon/zip/zip_crypto.c
@@ -146,7 +146,7 @@ static int hisi_zip_start_qp(struct hisi_qp *qp, struct hisi_zip_qp_ctx *ctx,
 
 	ret = hisi_qm_start_qp(qp, 0);
 	if (ret < 0) {
-		dev_err(dev, "start qp failed!\n");
+		dev_err(dev, "Start qp failed (%d)!\n", ret);
 		return ret;
 	}
 
@@ -169,7 +169,7 @@ static int hisi_zip_ctx_init(struct hisi_zip_ctx *hisi_zip_ctx, u8 req_type, int
 
 	ret = zip_create_qps(qps, HZIP_CTX_Q_NUM, node);
 	if (ret) {
-		pr_err("Can not create zip qps!\n");
+		pr_err("Can not create zip qps (%d)!\n", ret);
 		return -ENODEV;
 	}
 
@@ -380,19 +380,28 @@ static int hisi_zip_acomp_init(struct crypto_acomp *tfm)
 {
 	const char *alg_name = crypto_tfm_alg_name(&tfm->base);
 	struct hisi_zip_ctx *ctx = crypto_tfm_ctx(&tfm->base);
+	struct device *dev;
 	int ret;
 
 	ret = hisi_zip_ctx_init(ctx, COMP_NAME_TO_TYPE(alg_name), tfm->base.node);
-	if (ret)
+	if (ret) {
+		pr_err("Init ctx failed (%d)!\n", ret);
 		return ret;
+	}
+
+	dev = &ctx->qp_ctx[0].qp->qm->pdev->dev;
 
 	ret = hisi_zip_create_req_q(ctx);
-	if (ret)
+	if (ret) {
+		dev_err(dev, "Create request queue failed (%d)!\n", ret);
 		goto err_ctx_exit;
+	}
 
 	ret = hisi_zip_create_sgl_pool(ctx);
-	if (ret)
+	if (ret) {
+		dev_err(dev, "Create sgl pool failed (%d)!\n", ret);
 		goto err_release_req_q;
+	}
 
 	hisi_zip_set_acomp_cb(ctx, hisi_zip_acomp_cb);
 
@@ -422,8 +431,10 @@ static int add_comp_head(struct scatterlist *dst, u8 req_type)
 	int ret;
 
 	ret = sg_copy_from_buffer(dst, sg_nents(dst), head, head_size);
-	if (ret != head_size)
+	if (ret != head_size) {
+		pr_err("The head size of buffer is wrong (%d)!\n", ret);
 		return -ENOMEM;
+	}
 
 	return head_size;
 }
@@ -445,7 +456,7 @@ static size_t get_comp_head_size(struct scatterlist *src, u8 req_type)
 	case HZIP_ALG_TYPE_GZIP:
 		return get_gzip_head_size(src);
 	default:
-		pr_err("request type does not support!\n");
+		pr_err("Request type does not support!\n");
 		return -EINVAL;
 	}
 }
@@ -464,7 +475,7 @@ static struct hisi_zip_req *hisi_zip_create_req(struct acomp_req *req,
 	req_id = find_first_zero_bit(req_q->req_bitmap, req_q->size);
 	if (req_id >= req_q->size) {
 		write_unlock(&req_q->req_lock);
-		dev_dbg(&qp_ctx->qp->qm->pdev->dev, "req cache is full!\n");
+		dev_dbg(&qp_ctx->qp->qm->pdev->dev, "Req cache is full!\n");
 		return ERR_PTR(-EBUSY);
 	}
 	set_bit(req_id, req_q->req_bitmap);
@@ -504,14 +515,19 @@ static int hisi_zip_do_work(struct hisi_zip_req *req,
 
 	req->hw_src = hisi_acc_sg_buf_map_to_hw_sgl(dev, a_req->src, pool,
 						    req->req_id << 1, &input);
-	if (IS_ERR(req->hw_src))
+	if (IS_ERR(req->hw_src)) {
+		dev_err(dev, "The src map to hw SGL failed (%ld)!\n",
+			PTR_ERR(req->hw_src));
 		return PTR_ERR(req->hw_src);
+	}
 	req->dma_src = input;
 
 	req->hw_dst = hisi_acc_sg_buf_map_to_hw_sgl(dev, a_req->dst, pool,
 						    (req->req_id << 1) + 1,
 						    &output);
 	if (IS_ERR(req->hw_dst)) {
+		dev_err(dev, "The dst map to hw SGL failed (%ld)!\n",
+			PTR_ERR(req->hw_dst));
 		ret = PTR_ERR(req->hw_dst);
 		goto err_unmap_input;
 	}
@@ -527,6 +543,7 @@ static int hisi_zip_do_work(struct hisi_zip_req *req,
 	ret = hisi_qp_send(qp, &zip_sqe);
 	if (ret < 0) {
 		atomic64_inc(&dfx->send_busy_cnt);
+		dev_dbg_ratelimited(dev, "Send task message failed!\n");
 		goto err_unmap_output;
 	}
 
@@ -543,22 +560,32 @@ static int hisi_zip_acompress(struct acomp_req *acomp_req)
 {
 	struct hisi_zip_ctx *ctx = crypto_tfm_ctx(acomp_req->base.tfm);
 	struct hisi_zip_qp_ctx *qp_ctx = &ctx->qp_ctx[HZIP_QPC_COMP];
+	struct device *dev = &qp_ctx->qp->qm->pdev->dev;
 	struct hisi_zip_req *req;
 	int head_size;
 	int ret;
 
 	/* let's output compression head now */
 	head_size = add_comp_head(acomp_req->dst, qp_ctx->qp->req_type);
-	if (head_size < 0)
-		return -ENOMEM;
+	if (head_size < 0) {
+		dev_err_ratelimited(dev, "Add comp head failed (%d)!\n",
+				    head_size);
+		return head_size;
+	}
 
 	req = hisi_zip_create_req(acomp_req, qp_ctx, (size_t)head_size, true);
-	if (IS_ERR(req))
+	if (IS_ERR(req)) {
+		dev_err_ratelimited(dev, "Create request before compress failed (%ld)!\n",
+				    PTR_ERR(req));
 		return PTR_ERR(req);
+	}
 
 	ret = hisi_zip_do_work(req, qp_ctx);
-	if (ret != -EINPROGRESS)
+	if (ret != -EINPROGRESS) {
+		dev_err_ratelimited(dev, "Do compress work failed (%d)!\n",
+				    ret);
 		hisi_zip_remove_req(qp_ctx, req);
+	}
 
 	return ret;
 }
@@ -567,6 +594,7 @@ static int hisi_zip_adecompress(struct acomp_req *acomp_req)
 {
 	struct hisi_zip_ctx *ctx = crypto_tfm_ctx(acomp_req->base.tfm);
 	struct hisi_zip_qp_ctx *qp_ctx = &ctx->qp_ctx[HZIP_QPC_DECOMP];
+	struct device *dev = &qp_ctx->qp->qm->pdev->dev;
 	struct hisi_zip_req *req;
 	size_t head_size;
 	int ret;
@@ -574,12 +602,18 @@ static int hisi_zip_adecompress(struct acomp_req *acomp_req)
 	head_size = get_comp_head_size(acomp_req->src, qp_ctx->qp->req_type);
 
 	req = hisi_zip_create_req(acomp_req, qp_ctx, head_size, false);
-	if (IS_ERR(req))
+	if (IS_ERR(req)) {
+		dev_err_ratelimited(dev, "Create request before decompress failed (%ld)!\n",
+				    PTR_ERR(req));
 		return PTR_ERR(req);
+	}
 
 	ret = hisi_zip_do_work(req, qp_ctx);
-	if (ret != -EINPROGRESS)
+	if (ret != -EINPROGRESS) {
+		dev_err_ratelimited(dev, "Do decompress work failed (%d)!\n",
+				    ret);
 		hisi_zip_remove_req(qp_ctx, req);
+	}
 
 	return ret;
 }
@@ -618,13 +652,13 @@ int hisi_zip_register_to_crypto(void)
 
 	ret = crypto_register_acomp(&hisi_zip_acomp_zlib);
 	if (ret) {
-		pr_err("Zlib acomp algorithm registration failed\n");
+		pr_err("Zlib acomp algorithm registration failed (%d)!\n", ret);
 		return ret;
 	}
 
 	ret = crypto_register_acomp(&hisi_zip_acomp_gzip);
 	if (ret) {
-		pr_err("Gzip acomp algorithm registration failed\n");
+		pr_err("Gzip acomp algorithm registration failed (%d)!\n", ret);
 		crypto_unregister_acomp(&hisi_zip_acomp_zlib);
 	}
 
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 1883d1b..7697fa5 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -807,18 +807,20 @@ static int hisi_zip_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	ret = hisi_zip_debugfs_init(qm);
 	if (ret)
-		dev_err(&pdev->dev, "Failed to init debugfs (%d)!\n", ret);
+		pci_err(pdev, "Failed to init debugfs (%d)!\n", ret);
 
 	ret = hisi_qm_alg_register(qm, &zip_devices);
 	if (ret < 0) {
-		pci_err(pdev, "Failed to register driver to crypto.\n");
+		pci_err(pdev, "Failed to register driver to crypto!\n");
 		goto err_qm_stop;
 	}
 
 	if (qm->uacce) {
 		ret = uacce_register(qm->uacce);
-		if (ret)
+		if (ret) {
+			pci_err(pdev, "Failed to register uacce (%d)!\n", ret);
 			goto err_qm_alg_unregister;
+		}
 	}
 
 	if (qm->fun_type == QM_HW_PF && vfs_num > 0) {
-- 
2.7.4

