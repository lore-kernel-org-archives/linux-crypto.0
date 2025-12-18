Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF203358CE;
	Thu, 18 Dec 2025 13:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766065507; cv=none; b=Ii+JZ96bq2e6uVZ3m5SjDgxYICaf8lwS79ra8YMjTgLPaYupaEev3V0LHHrhVB4P2CrwynF8uDTHqRKJpvfqx9RTxDR0HoOCmCpTivYA/FQRgAwUN6OVVqVWc7kZeTxHH99phvwtdVBv7ZYVDBsgrRHiOICE6wkjw7V1x7pSgso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766065507; c=relaxed/simple;
	bh=W5bdK9LMLKNosAGIK8uSbxEQ1gvRjelbXW1hrGlC//I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lHnkkGkoMZh07xIcrAuGqy2c/GfNtRGDPGRh+Iih0puqRDInv0miqtp1vfZI8ktharvW7trk+L7j9BUNTfavs/GC1TQXaWVh6akz12Oot+aGuvfOewAowL6JRhQgI2+pLvF5cPX+l4tA7LGAEZH/LivAm8xyylxTCuHc2iEbcIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=MEI0p+N0; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="MEI0p+N0"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=bdfIvkbhbhQHaorwRUFkOOSMlOD4Ol0bssvKbV67JkE=;
	b=MEI0p+N0wKv0YLtqMBVidlecEl0C7HmO1Dzj922FM8/6Ie/12ButDx91AMqBaovkGWuaSFpOl
	D3mPMf74CrSGqTkSnBAWRmDJifYLmauytsMVfeCXkfmmoZTQWIWWnjiTKZwMV5DGGz8RlfYa/KU
	X3TA4CQHqT8uroO8ntMPCgE=
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4dXBfS04C7zmV69;
	Thu, 18 Dec 2025 21:41:52 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 09E1A1800CF;
	Thu, 18 Dec 2025 21:44:56 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Dec 2025 21:44:54 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Dec 2025 21:44:53 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<linwenkai6@hisilicon.com>, <wangzhou1@hisilicon.com>, <lizhi206@huawei.com>,
	<taoqi10@huawei.com>
Subject: [PATCH v4 01/11] crypto: hisilicon/zip - adjust the way to obtain the req in the callback function
Date: Thu, 18 Dec 2025 21:44:42 +0800
Message-ID: <20251218134452.1125469-2-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20251218134452.1125469-1-huangchenghai2@huawei.com>
References: <20251218134452.1125469-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq200001.china.huawei.com (7.202.195.16)

In the shared queue design, multiple tfms use same qp, and one qp
need to corresponds to multiple qp_ctx. So use tag to obtain the
req virtual address. Build a one-to-one relationship between tfm
and qp_ctx. finaly remove the old get_tag operation.

Fixes: 2bcf36348ce5 ("crypto: hisilicon/zip - initialize operations about 'sqe' in 'acomp_alg.init'")
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/zip/zip_crypto.c | 24 +++++++++--------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/hisilicon/zip/zip_crypto.c b/drivers/crypto/hisilicon/zip/zip_crypto.c
index b97513981a3b..b4a656e0177d 100644
--- a/drivers/crypto/hisilicon/zip/zip_crypto.c
+++ b/drivers/crypto/hisilicon/zip/zip_crypto.c
@@ -39,6 +39,7 @@ enum {
 	HZIP_CTX_Q_NUM
 };
 
+#define GET_REQ_FROM_SQE(sqe)	((u64)(sqe)->dw26 | (u64)(sqe)->dw27 << 32)
 #define COMP_NAME_TO_TYPE(alg_name)					\
 	(!strcmp((alg_name), "deflate") ? HZIP_ALG_TYPE_DEFLATE : 0)
 
@@ -48,6 +49,7 @@ struct hisi_zip_req {
 	struct hisi_acc_hw_sgl *hw_dst;
 	dma_addr_t dma_src;
 	dma_addr_t dma_dst;
+	struct hisi_zip_qp_ctx *qp_ctx;
 	u16 req_id;
 };
 
@@ -74,7 +76,6 @@ struct hisi_zip_sqe_ops {
 	void (*fill_req_type)(struct hisi_zip_sqe *sqe, u8 req_type);
 	void (*fill_tag)(struct hisi_zip_sqe *sqe, struct hisi_zip_req *req);
 	void (*fill_sqe_type)(struct hisi_zip_sqe *sqe, u8 sqe_type);
-	u32 (*get_tag)(struct hisi_zip_sqe *sqe);
 	u32 (*get_status)(struct hisi_zip_sqe *sqe);
 	u32 (*get_dstlen)(struct hisi_zip_sqe *sqe);
 };
@@ -131,6 +132,7 @@ static struct hisi_zip_req *hisi_zip_create_req(struct hisi_zip_qp_ctx *qp_ctx,
 	req_cache = q + req_id;
 	req_cache->req_id = req_id;
 	req_cache->req = req;
+	req_cache->qp_ctx = qp_ctx;
 
 	return req_cache;
 }
@@ -181,7 +183,8 @@ static void hisi_zip_fill_req_type(struct hisi_zip_sqe *sqe, u8 req_type)
 
 static void hisi_zip_fill_tag(struct hisi_zip_sqe *sqe, struct hisi_zip_req *req)
 {
-	sqe->dw26 = req->req_id;
+	sqe->dw26 = lower_32_bits((u64)req);
+	sqe->dw27 = upper_32_bits((u64)req);
 }
 
 static void hisi_zip_fill_sqe_type(struct hisi_zip_sqe *sqe, u8 sqe_type)
@@ -237,7 +240,7 @@ static int hisi_zip_do_work(struct hisi_zip_qp_ctx *qp_ctx,
 						    &req->dma_dst, DMA_FROM_DEVICE);
 	if (IS_ERR(req->hw_dst)) {
 		ret = PTR_ERR(req->hw_dst);
-		dev_err(dev, "failed to map the dst buffer to hw slg (%d)!\n",
+		dev_err(dev, "failed to map the dst buffer to hw sgl (%d)!\n",
 			ret);
 		goto err_unmap_input;
 	}
@@ -265,11 +268,6 @@ static int hisi_zip_do_work(struct hisi_zip_qp_ctx *qp_ctx,
 	return ret;
 }
 
-static u32 hisi_zip_get_tag(struct hisi_zip_sqe *sqe)
-{
-	return sqe->dw26;
-}
-
 static u32 hisi_zip_get_status(struct hisi_zip_sqe *sqe)
 {
 	return sqe->dw3 & HZIP_BD_STATUS_M;
@@ -282,14 +280,12 @@ static u32 hisi_zip_get_dstlen(struct hisi_zip_sqe *sqe)
 
 static void hisi_zip_acomp_cb(struct hisi_qp *qp, void *data)
 {
-	struct hisi_zip_qp_ctx *qp_ctx = qp->qp_ctx;
+	struct hisi_zip_sqe *sqe = data;
+	struct hisi_zip_req *req = (struct hisi_zip_req *)GET_REQ_FROM_SQE(sqe);
+	struct hisi_zip_qp_ctx *qp_ctx = req->qp_ctx;
 	const struct hisi_zip_sqe_ops *ops = qp_ctx->ctx->ops;
 	struct hisi_zip_dfx *dfx = &qp_ctx->zip_dev->dfx;
-	struct hisi_zip_req_q *req_q = &qp_ctx->req_q;
 	struct device *dev = &qp->qm->pdev->dev;
-	struct hisi_zip_sqe *sqe = data;
-	u32 tag = ops->get_tag(sqe);
-	struct hisi_zip_req *req = req_q->q + tag;
 	struct acomp_req *acomp_req = req->req;
 	int err = 0;
 	u32 status;
@@ -393,7 +389,6 @@ static const struct hisi_zip_sqe_ops hisi_zip_ops = {
 	.fill_req_type		= hisi_zip_fill_req_type,
 	.fill_tag		= hisi_zip_fill_tag,
 	.fill_sqe_type		= hisi_zip_fill_sqe_type,
-	.get_tag		= hisi_zip_get_tag,
 	.get_status		= hisi_zip_get_status,
 	.get_dstlen		= hisi_zip_get_dstlen,
 };
@@ -581,7 +576,6 @@ static void hisi_zip_acomp_exit(struct crypto_acomp *tfm)
 {
 	struct hisi_zip_ctx *ctx = crypto_tfm_ctx(&tfm->base);
 
-	hisi_zip_set_acomp_cb(ctx, NULL);
 	hisi_zip_release_sgl_pool(ctx);
 	hisi_zip_release_req_q(ctx);
 	hisi_zip_ctx_exit(ctx);
-- 
2.33.0

