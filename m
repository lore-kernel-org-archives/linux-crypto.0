Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2274933A704;
	Thu, 18 Dec 2025 13:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766065512; cv=none; b=kO1VaZUKOI3JASJ7o/HFIYQKRjxyYmQYMhes8X9BkK2q8IGarOSyZbSaecChALAULj59to38MBMxw13fSng3cNdAbpxPL+rMJB30Jq3d9BW+aVsePgMpv7zKrIf9c0c7LgugyoMdJXaxMxlyZk+I3wu3ADvfP7TE9NmTDwNqS6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766065512; c=relaxed/simple;
	bh=S2ZOsoHSvSPD2qOHStkOoj4DDCRo0E0CZZ9H9M2Wqvc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E+bJM2OG3UN094BwbjfN7I/lrnqwR8wK/jx/4QLnF6GqYNSwEL7viPCftEhHtL0rlzA0XvOTH277pG3FPIHX9XBEvNRF6ixIzp1AoKZe4igJ0zSxpHaDIGoJQvuh7KyNXwt2zZRtsXbJWDOD3UJ2boK+ldjtvkJ2C0gTVuKXK8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=6S1tbZ8B; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="6S1tbZ8B"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=NEIAocZX7oeYU53yZMufqMy2MJZzfMbXu7TR9A1HIz0=;
	b=6S1tbZ8Bf4a5ttzyIl+fT7wqM6eTx8qoHooaKL93yamZs1sjsn8bCAD0lDyxvsYT899oxGzCm
	jnv/FW6kydARL68Aw2Qs7Y9nXDusz28SkxLvkyO+eWXaZZMEATdWxeAgA+vb/NQpUbGGUEOVkfG
	hXIVWzN40AvOg6uwE2qInw0=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dXBgX1gynznTXC;
	Thu, 18 Dec 2025 21:42:48 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 02B7F1402C4;
	Thu, 18 Dec 2025 21:45:01 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Dec 2025 21:44:57 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Dec 2025 21:44:57 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<linwenkai6@hisilicon.com>, <wangzhou1@hisilicon.com>, <lizhi206@huawei.com>,
	<taoqi10@huawei.com>
Subject: [PATCH v4 09/11] crypto: hisilicon/zip - support fallback for zip
Date: Thu, 18 Dec 2025 21:44:50 +0800
Message-ID: <20251218134452.1125469-10-huangchenghai2@huawei.com>
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

When the hardware queue resource busy(no shareable queue)
or memery alloc fail in initialization of acomp_alg, use
soft algorithm to complete the work.

Fixes: 1a9e6f59caee ("crypto: hisilicon/zip - remove zlib and gzip")
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/Kconfig          |  1 +
 drivers/crypto/hisilicon/zip/zip_crypto.c | 50 +++++++++++++++++++----
 2 files changed, 43 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/hisilicon/Kconfig b/drivers/crypto/hisilicon/Kconfig
index 4835bdebdbb3..a0cb1a8186ac 100644
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
index 108ab667131d..e140d4f8afe0 100644
--- a/drivers/crypto/hisilicon/zip/zip_crypto.c
+++ b/drivers/crypto/hisilicon/zip/zip_crypto.c
@@ -84,6 +84,7 @@ struct hisi_zip_sqe_ops {
 struct hisi_zip_ctx {
 	struct hisi_zip_qp_ctx qp_ctx[HZIP_CTX_Q_NUM];
 	const struct hisi_zip_sqe_ops *ops;
+	bool fallback;
 };
 
 static int sgl_sge_nr_set(const char *val, const struct kernel_param *kp)
@@ -110,6 +111,24 @@ static u16 sgl_sge_nr = HZIP_SGL_SGE_NR;
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
@@ -313,10 +332,15 @@ static int hisi_zip_acompress(struct acomp_req *acomp_req)
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
@@ -334,10 +358,15 @@ static int hisi_zip_adecompress(struct acomp_req *acomp_req)
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
@@ -515,7 +544,7 @@ static int hisi_zip_acomp_init(struct crypto_acomp *tfm)
 	ret = hisi_zip_ctx_init(ctx, COMP_NAME_TO_TYPE(alg_name), tfm->base.node);
 	if (ret) {
 		pr_err("failed to init ctx (%d)!\n", ret);
-		return ret;
+		goto switch_to_soft;
 	}
 
 	dev = &ctx->qp_ctx[0].qp->qm->pdev->dev;
@@ -540,16 +569,20 @@ static int hisi_zip_acomp_init(struct crypto_acomp *tfm)
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
 
-	hisi_zip_release_sgl_pool(ctx);
-	hisi_zip_release_req_q(ctx);
-	hisi_zip_ctx_exit(ctx);
+	if (!ctx->fallback) {
+		hisi_zip_release_sgl_pool(ctx);
+		hisi_zip_release_req_q(ctx);
+		hisi_zip_ctx_exit(ctx);
+	}
 }
 
 static struct acomp_alg hisi_zip_acomp_deflate = {
@@ -560,7 +593,8 @@ static struct acomp_alg hisi_zip_acomp_deflate = {
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

