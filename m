Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4D02E7179;
	Sat, 17 Jan 2026 02:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768617282; cv=none; b=igctdxzXHzisIDWjXCo5Js0SWcZL+q+Ep4iPAq3Ni96BSsuxFUmijmDnCb9KbpCqHTNK0Ud7mu5cE8r0Nvi2G59N9SjAq5acPZ1PNRfcFAWrX0Lbz4jsMEan10m/ck/3lAhZlfWubKyICEeZ1U+nI8ZYTAma4od11jsvS2S8Azw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768617282; c=relaxed/simple;
	bh=Zq3cBwvm9g7oCq2u4WRTeIy0W/xOn3pqd0zDGAMwxQ8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Tw5fOeOkKbY6Fv/4EpR4GqpjlLK2mGB87kAKiwBYSMk7tLO3MXXrC7Yc95ZbLJs9cgi7zot7436RszySas0ABoUhX3wUb0UOhVhv5CuIOXSBQhT4df/UVwH6OBBeTihYZ0VbA46zr+Q6X5IQS4sdgp6nOFFYziIiQ9BtIwdJ55s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=L1AydMTx; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="L1AydMTx"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=d68i/E5BcourFXATqpM+JIKRQA3nBVE7rWAG+tkk2Zs=;
	b=L1AydMTxY7nbY3JXJaPfxRGfdj/GN26DG2BzyKCc+pO/gYXWjGu/uijZ96T4B4/UKhAaArdfv
	kAPhhZB7aomIyIzW1FBeI9zpNLSttA/YLgjIcStRtbX/oLgNx8ykSkTWaFrPfQnDbKSUV391Pbj
	Q8sFAZOEVyHPXK6GyQF/Nb0=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4dtLLn1cLXz1prMF;
	Sat, 17 Jan 2026 10:31:13 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 684D24056E;
	Sat, 17 Jan 2026 10:34:36 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 17 Jan 2026 10:34:36 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 17 Jan 2026 10:34:35 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<wangzhou1@hisilicon.com>
Subject: [PATCH] crypto: hisilicon/zip - add lz4 algorithm for hisi_zip
Date: Sat, 17 Jan 2026 10:34:35 +0800
Message-ID: <20260117023435.1616703-1-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq200001.china.huawei.com (7.202.195.16)

Add the "hisi-lz4-acomp" algorithm by the crypto acomp. When the
8th bit of the capability register is 1, the lz4 algorithm will
register to crypto acomp, and the window length is configured to
16K by default.

Since the "hisi-lz4-acomp" currently only support compression
direction, decompression is completed by the soft lz4 algorithm.

Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/Kconfig          |  1 +
 drivers/crypto/hisilicon/zip/zip_crypto.c | 91 +++++++++++++++++++++--
 2 files changed, 84 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/hisilicon/Kconfig b/drivers/crypto/hisilicon/Kconfig
index a0cb1a8186ac..1e6d772f4bb6 100644
--- a/drivers/crypto/hisilicon/Kconfig
+++ b/drivers/crypto/hisilicon/Kconfig
@@ -58,6 +58,7 @@ config CRYPTO_DEV_HISI_ZIP
 	depends on ACPI
 	select CRYPTO_DEV_HISI_QM
 	select CRYPTO_DEFLATE
+	select CRYPTO_LZ4
 	help
 	  Support for HiSilicon ZIP Driver
 
diff --git a/drivers/crypto/hisilicon/zip/zip_crypto.c b/drivers/crypto/hisilicon/zip/zip_crypto.c
index e140d4f8afe0..98a68e44ac34 100644
--- a/drivers/crypto/hisilicon/zip/zip_crypto.c
+++ b/drivers/crypto/hisilicon/zip/zip_crypto.c
@@ -17,13 +17,17 @@
 /* hisi_zip_sqe dw9 */
 #define HZIP_REQ_TYPE_M				GENMASK(7, 0)
 #define HZIP_ALG_TYPE_DEFLATE			0x01
+#define HZIP_ALG_TYPE_LZ4			0x04
 #define HZIP_BUF_TYPE_M				GENMASK(11, 8)
 #define HZIP_SGL				0x1
+#define HZIP_WIN_SIZE_M				GENMASK(15, 12)
+#define HZIP_16K_WINSZ				0x2
 
 #define HZIP_ALG_PRIORITY			300
 #define HZIP_SGL_SGE_NR				10
 
 #define HZIP_ALG_DEFLATE			GENMASK(5, 4)
+#define HZIP_ALG_LZ4				BIT(8)
 
 static DEFINE_MUTEX(zip_algs_lock);
 static unsigned int zip_available_devs;
@@ -41,7 +45,8 @@ enum {
 
 #define GET_REQ_FROM_SQE(sqe)	((u64)(sqe)->dw26 | (u64)(sqe)->dw27 << 32)
 #define COMP_NAME_TO_TYPE(alg_name)					\
-	(!strcmp((alg_name), "deflate") ? HZIP_ALG_TYPE_DEFLATE : 0)
+	(!strcmp((alg_name), "deflate") ? HZIP_ALG_TYPE_DEFLATE :	\
+	(!strcmp((alg_name), "lz4") ? HZIP_ALG_TYPE_LZ4 : 0))
 
 struct hisi_zip_req {
 	struct acomp_req *req;
@@ -75,6 +80,7 @@ struct hisi_zip_sqe_ops {
 	void (*fill_buf_size)(struct hisi_zip_sqe *sqe, struct hisi_zip_req *req);
 	void (*fill_buf_type)(struct hisi_zip_sqe *sqe, u8 buf_type);
 	void (*fill_req_type)(struct hisi_zip_sqe *sqe, u8 req_type);
+	void (*fill_win_size)(struct hisi_zip_sqe *sqe, u8 win_size);
 	void (*fill_tag)(struct hisi_zip_sqe *sqe, struct hisi_zip_req *req);
 	void (*fill_sqe_type)(struct hisi_zip_sqe *sqe, u8 sqe_type);
 	u32 (*get_status)(struct hisi_zip_sqe *sqe);
@@ -201,6 +207,15 @@ static void hisi_zip_fill_req_type(struct hisi_zip_sqe *sqe, u8 req_type)
 	sqe->dw9 = val;
 }
 
+static void hisi_zip_fill_win_size(struct hisi_zip_sqe *sqe, u8 win_size)
+{
+	u32 val;
+
+	val = sqe->dw9 & ~HZIP_WIN_SIZE_M;
+	val |= FIELD_PREP(HZIP_WIN_SIZE_M, win_size);
+	sqe->dw9 = val;
+}
+
 static void hisi_zip_fill_tag(struct hisi_zip_sqe *sqe, struct hisi_zip_req *req)
 {
 	sqe->dw26 = lower_32_bits((u64)req);
@@ -227,6 +242,7 @@ static void hisi_zip_fill_sqe(struct hisi_zip_ctx *ctx, struct hisi_zip_sqe *sqe
 	ops->fill_buf_size(sqe, req);
 	ops->fill_buf_type(sqe, HZIP_SGL);
 	ops->fill_req_type(sqe, req_type);
+	ops->fill_win_size(sqe, HZIP_16K_WINSZ);
 	ops->fill_tag(sqe, req);
 	ops->fill_sqe_type(sqe, ops->sqe_type);
 }
@@ -381,12 +397,18 @@ static int hisi_zip_adecompress(struct acomp_req *acomp_req)
 	return ret;
 }
 
+static int hisi_zip_decompress(struct acomp_req *acomp_req)
+{
+	return hisi_zip_fallback_do_work(acomp_req, 1);
+}
+
 static const struct hisi_zip_sqe_ops hisi_zip_ops = {
 	.sqe_type		= 0x3,
 	.fill_addr		= hisi_zip_fill_addr,
 	.fill_buf_size		= hisi_zip_fill_buf_size,
 	.fill_buf_type		= hisi_zip_fill_buf_type,
 	.fill_req_type		= hisi_zip_fill_req_type,
+	.fill_win_size		= hisi_zip_fill_win_size,
 	.fill_tag		= hisi_zip_fill_tag,
 	.fill_sqe_type		= hisi_zip_fill_sqe_type,
 	.get_status		= hisi_zip_get_status,
@@ -578,11 +600,12 @@ static void hisi_zip_acomp_exit(struct crypto_acomp *tfm)
 {
 	struct hisi_zip_ctx *ctx = crypto_tfm_ctx(&tfm->base);
 
-	if (!ctx->fallback) {
-		hisi_zip_release_sgl_pool(ctx);
-		hisi_zip_release_req_q(ctx);
-		hisi_zip_ctx_exit(ctx);
-	}
+	if (ctx->fallback)
+		return;
+
+	hisi_zip_release_sgl_pool(ctx);
+	hisi_zip_release_req_q(ctx);
+	hisi_zip_ctx_exit(ctx);
 }
 
 static struct acomp_alg hisi_zip_acomp_deflate = {
@@ -623,18 +646,69 @@ static void hisi_zip_unregister_deflate(struct hisi_qm *qm)
 	crypto_unregister_acomp(&hisi_zip_acomp_deflate);
 }
 
+static struct acomp_alg hisi_zip_acomp_lz4 = {
+	.init			= hisi_zip_acomp_init,
+	.exit			= hisi_zip_acomp_exit,
+	.compress		= hisi_zip_acompress,
+	.decompress		= hisi_zip_decompress,
+	.base			= {
+		.cra_name		= "lz4",
+		.cra_driver_name	= "hisi-lz4-acomp",
+		.cra_flags		= CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_NEED_FALLBACK,
+		.cra_module		= THIS_MODULE,
+		.cra_priority		= HZIP_ALG_PRIORITY,
+		.cra_ctxsize		= sizeof(struct hisi_zip_ctx),
+	}
+};
+
+static int hisi_zip_register_lz4(struct hisi_qm *qm)
+{
+	int ret;
+
+	if (!hisi_zip_alg_support(qm, HZIP_ALG_LZ4))
+		return 0;
+
+	ret = crypto_register_acomp(&hisi_zip_acomp_lz4);
+	if (ret)
+		dev_err(&qm->pdev->dev, "failed to register to LZ4 (%d)!\n", ret);
+
+	return ret;
+}
+
+static void hisi_zip_unregister_lz4(struct hisi_qm *qm)
+{
+	if (!hisi_zip_alg_support(qm, HZIP_ALG_LZ4))
+		return;
+
+	crypto_unregister_acomp(&hisi_zip_acomp_lz4);
+}
+
 int hisi_zip_register_to_crypto(struct hisi_qm *qm)
 {
 	int ret = 0;
 
 	mutex_lock(&zip_algs_lock);
-	if (zip_available_devs++)
+	if (zip_available_devs) {
+		zip_available_devs++;
 		goto unlock;
+	}
 
 	ret = hisi_zip_register_deflate(qm);
 	if (ret)
-		zip_available_devs--;
+		goto unlock;
+
+	ret = hisi_zip_register_lz4(qm);
+	if (ret)
+		goto unreg_deflate;
+
+	zip_available_devs++;
+	mutex_unlock(&zip_algs_lock);
 
+	return 0;
+
+unreg_deflate:
+	hisi_zip_unregister_deflate(qm);
 unlock:
 	mutex_unlock(&zip_algs_lock);
 	return ret;
@@ -647,6 +721,7 @@ void hisi_zip_unregister_from_crypto(struct hisi_qm *qm)
 		goto unlock;
 
 	hisi_zip_unregister_deflate(qm);
+	hisi_zip_unregister_lz4(qm);
 
 unlock:
 	mutex_unlock(&zip_algs_lock);
-- 
2.33.0

