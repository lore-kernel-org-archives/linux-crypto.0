Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8CE27A133;
	Mon, 18 Aug 2025 06:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755500241; cv=none; b=BcQ95d37JP4j+R9v4Xf5CVnfqH+DtGf/Sigpc6vR7N6UioqkR7horghe40sMmaqRilcJM68RITohYfxrLgzP+6QeYqttBzslINXXu/IgAQwdEUo9RLW0CP7J9kwqON7D+B3DYZ1obaC8cyF03A428A6dL2f9LFCknmRddQy7fmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755500241; c=relaxed/simple;
	bh=2Cw9VI5VxvYaqFG2/ZVeKaqKVO1Yna/O+5zgTQgi1qY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O+pOusHGwUKpDEdvN43eDQTvTdKjxBKWUAw45MHNyJQQZFG89O8wqIyA5K7U1pZwiqmQO4c2mQgfhYM9hSw21VGSe3+A6PSI+oaDf1UzmHU7fXOTW+BvVsE3NGzcTwhtx3qETSp9toRfZW6QtQtnBYAAByxnnJnLOm+zBHDnLLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4c53Rs42tnzvX2B;
	Mon, 18 Aug 2025 14:57:13 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 69C3E140158;
	Mon, 18 Aug 2025 14:57:16 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 18 Aug 2025 14:57:16 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 18 Aug 2025 14:57:15 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<qianweili@huawei.com>, <linwenkai6@hisilicon.com>,
	<wangzhou1@hisilicon.com>, <taoqi10@huawei.com>
Subject: [PATCH v2 1/3] crypto: hisilicon/zip - support fallback for zip
Date: Mon, 18 Aug 2025 14:57:12 +0800
Message-ID: <20250818065714.1916898-2-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250818065714.1916898-1-huangchenghai2@huawei.com>
References: <20250818065714.1916898-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq200001.china.huawei.com (7.202.195.16)

When the hardware queue resource or memery alloc fail in
initialization of acomp_alg, use soft algorithm to complete
the work.

Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/Kconfig          |  1 +
 drivers/crypto/hisilicon/zip/zip_crypto.c | 52 +++++++++++++++++++----
 2 files changed, 44 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/hisilicon/Kconfig b/drivers/crypto/hisilicon/Kconfig
index 4137a8bf131f..0d3e32ba6f61 100644
--- a/drivers/crypto/hisilicon/Kconfig
+++ b/drivers/crypto/hisilicon/Kconfig
@@ -57,6 +57,7 @@ config CRYPTO_DEV_HISI_ZIP
 	depends on UACCE || UACCE=n
 	depends on ACPI
 	select CRYPTO_DEV_HISI_QM
+	select CRYPTO_DEFLATE
 	help
 	  Support for HiSilicon ZIP Driver
 
diff --git a/drivers/crypto/hisilicon/zip/zip_crypto.c b/drivers/crypto/hisilicon/zip/zip_crypto.c
index b97513981a3b..dfc8b59b07ac 100644
--- a/drivers/crypto/hisilicon/zip/zip_crypto.c
+++ b/drivers/crypto/hisilicon/zip/zip_crypto.c
@@ -82,6 +82,7 @@ struct hisi_zip_sqe_ops {
 struct hisi_zip_ctx {
 	struct hisi_zip_qp_ctx qp_ctx[HZIP_CTX_Q_NUM];
 	const struct hisi_zip_sqe_ops *ops;
+	bool fallback;
 };
 
 static int sgl_sge_nr_set(const char *val, const struct kernel_param *kp)
@@ -108,6 +109,24 @@ static u16 sgl_sge_nr = HZIP_SGL_SGE_NR;
 module_param_cb(sgl_sge_nr, &sgl_sge_nr_ops, &sgl_sge_nr, 0444);
 MODULE_PARM_DESC(sgl_sge_nr, "Number of sge in sgl(1-255)");
 
+static int hisi_zip_fallback_do_work(struct acomp_req *acomp_req, bool is_decompress)
+{
+	ACOMP_FBREQ_ON_STACK(fbreq, acomp_req);
+	int ret;
+
+	if (!is_decompress)
+		ret = crypto_acomp_compress(fbreq);
+	else
+		ret = crypto_acomp_decompress(fbreq);
+	if (ret) {
+		pr_err("failed to do fallback work, ret=%d\n", ret);
+		return ret;
+	}
+
+	acomp_req->dlen = fbreq->dlen;
+	return ret;
+}
+
 static struct hisi_zip_req *hisi_zip_create_req(struct hisi_zip_qp_ctx *qp_ctx,
 						struct acomp_req *req)
 {
@@ -319,10 +338,15 @@ static int hisi_zip_acompress(struct acomp_req *acomp_req)
 {
 	struct hisi_zip_ctx *ctx = crypto_tfm_ctx(acomp_req->base.tfm);
 	struct hisi_zip_qp_ctx *qp_ctx = &ctx->qp_ctx[HZIP_QPC_COMP];
-	struct device *dev = &qp_ctx->qp->qm->pdev->dev;
 	struct hisi_zip_req *req;
+	struct device *dev;
 	int ret;
 
+	if (ctx->fallback)
+		return hisi_zip_fallback_do_work(acomp_req, 0);
+
+	dev = &qp_ctx->qp->qm->pdev->dev;
+
 	req = hisi_zip_create_req(qp_ctx, acomp_req);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
@@ -340,10 +364,15 @@ static int hisi_zip_adecompress(struct acomp_req *acomp_req)
 {
 	struct hisi_zip_ctx *ctx = crypto_tfm_ctx(acomp_req->base.tfm);
 	struct hisi_zip_qp_ctx *qp_ctx = &ctx->qp_ctx[HZIP_QPC_DECOMP];
-	struct device *dev = &qp_ctx->qp->qm->pdev->dev;
 	struct hisi_zip_req *req;
+	struct device *dev;
 	int ret;
 
+	if (ctx->fallback)
+		return hisi_zip_fallback_do_work(acomp_req, 1);
+
+	dev = &qp_ctx->qp->qm->pdev->dev;
+
 	req = hisi_zip_create_req(qp_ctx, acomp_req);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
@@ -549,7 +578,7 @@ static int hisi_zip_acomp_init(struct crypto_acomp *tfm)
 	ret = hisi_zip_ctx_init(ctx, COMP_NAME_TO_TYPE(alg_name), tfm->base.node);
 	if (ret) {
 		pr_err("failed to init ctx (%d)!\n", ret);
-		return ret;
+		goto switch_to_soft;
 	}
 
 	dev = &ctx->qp_ctx[0].qp->qm->pdev->dev;
@@ -574,17 +603,21 @@ static int hisi_zip_acomp_init(struct crypto_acomp *tfm)
 	hisi_zip_release_req_q(ctx);
 err_ctx_exit:
 	hisi_zip_ctx_exit(ctx);
-	return ret;
+switch_to_soft:
+	ctx->fallback = true;
+	return 0;
 }
 
 static void hisi_zip_acomp_exit(struct crypto_acomp *tfm)
 {
 	struct hisi_zip_ctx *ctx = crypto_tfm_ctx(&tfm->base);
 
-	hisi_zip_set_acomp_cb(ctx, NULL);
-	hisi_zip_release_sgl_pool(ctx);
-	hisi_zip_release_req_q(ctx);
-	hisi_zip_ctx_exit(ctx);
+	if (!ctx->fallback) {
+		hisi_zip_set_acomp_cb(ctx, NULL);
+		hisi_zip_release_sgl_pool(ctx);
+		hisi_zip_release_req_q(ctx);
+		hisi_zip_ctx_exit(ctx);
+	}
 }
 
 static struct acomp_alg hisi_zip_acomp_deflate = {
@@ -595,7 +628,8 @@ static struct acomp_alg hisi_zip_acomp_deflate = {
 	.base			= {
 		.cra_name		= "deflate",
 		.cra_driver_name	= "hisi-deflate-acomp",
-		.cra_flags		= CRYPTO_ALG_ASYNC,
+		.cra_flags		= CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_NEED_FALLBACK,
 		.cra_module		= THIS_MODULE,
 		.cra_priority		= HZIP_ALG_PRIORITY,
 		.cra_ctxsize		= sizeof(struct hisi_zip_ctx),
-- 
2.33.0

