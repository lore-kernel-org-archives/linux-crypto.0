Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076A22853E9;
	Sat, 18 Jul 2026 03:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784343927; cv=none; b=bFpjcjYbI3qsny0nmUi0sRZ/ju8dJlQJvNRHzo+icu7tBpVLL3FxsQx5biU2XwwRSFQ5c2k0lbL6GPL6ShV9WMzrmHN/GpcqAwx/4300Cd/8ZFbcM2WT26bpmQtCXT/mDbyN+XsuUVWcq7p54WSZ2Huwwc37YJeKzlC/aOHqE7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784343927; c=relaxed/simple;
	bh=4mm9C43Y9salZwV/Qk7LpmRUV9yRXIajgAj0tiI6OuE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ioC+YLVmgH+4VlrYufrAaxhuKNPVMI5s71oLIVokMwO0ihTZakvp8TfxNf9cJPUvlDzArc48kSSJ0hzWv9bxn6bvHgzeD19e/x1eJIBj/mechguVip3e+MCSchFwjTbGWZmHWkqFxOQZt0HsmC/I3MIVnn8lnINUkoTv+kyjVa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=O26B+/YZ; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="O26B+/YZ"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=XAxSGU3hFKXfpEqzTBfJA8k8iuWxoxqPnUaq53YyEXA=;
	b=O26B+/YZKKvd7Y1ruemOLZuknaY+pmvTksUkIgoSU8xVbCeEzRD0iWW2NbnhwMe5txsBoGzeU
	cuMjXts3pfdBPHs333WSiTbBCRAw1Nk+PUC6DnLeqKpWBjcyDLj5EmlTinCA6o117XhQRj1D5I+
	Ny0u5A8I+l/rGNZZuaGg9r8=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4h2BHG2VJrzcb3P;
	Sat, 18 Jul 2026 10:55:54 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 5808F203B8;
	Sat, 18 Jul 2026 11:05:15 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 18 Jul 2026 11:05:15 +0800
Received: from localhost.localdomain (10.50.163.32) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 18 Jul 2026 11:05:14 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>, <qianweili@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH 1/2] crypto: hisilicon/sec2 - fix uninitialized type_supported in sec_create_qp_ctx
Date: Sat, 18 Jul 2026 11:05:12 +0800
Message-ID: <20260718030513.3809002-2-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260718030513.3809002-1-huangchenghai2@huawei.com>
References: <20260718030513.3809002-1-huangchenghai2@huawei.com>
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

sec_create_qp_ctx() reads ctx->type_supported to pick its callback, but
sec_skcipher_init() and sec_aead_init() set it after sec_ctx_base_init()
has already walked the qp_ctx loop, so the value is uninitialized when
first consumed.  Set type_supported in sec_ctx_base_init() before the
loop; the alg init paths now just select req_op from it.

Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 24 +++++++++++-----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 77e0e03cbcab..5c2b9f710be0 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -672,6 +672,11 @@ static int sec_ctx_base_init(struct sec_ctx *ctx)
 	ctx->hlf_q_num = sec->ctx_q_num >> 1;
 
 	ctx->pbuf_supported = ctx->sec->iommu_used;
+	if (sec->qm.ver < QM_HW_V3)
+		ctx->type_supported = SEC_BD_TYPE2;
+	else
+		ctx->type_supported = SEC_BD_TYPE3;
+
 	ctx->qp_ctx = kzalloc_objs(struct sec_qp_ctx, sec->ctx_q_num);
 	if (!ctx->qp_ctx) {
 		ret = -ENOMEM;
@@ -2067,13 +2072,10 @@ static int sec_skcipher_ctx_init(struct crypto_skcipher *tfm)
 	if (!ctx->qps)
 		return 0;
 
-	if (ctx->sec->qm.ver < QM_HW_V3) {
-		ctx->type_supported = SEC_BD_TYPE2;
-		ctx->req_op = &sec_skcipher_req_ops;
-	} else {
-		ctx->type_supported = SEC_BD_TYPE3;
+	if (ctx->type_supported == SEC_BD_TYPE3)
 		ctx->req_op = &sec_skcipher_req_ops_v3;
-	}
+	else
+		ctx->req_op = &sec_skcipher_req_ops;
 
 	return 0;
 }
@@ -2100,13 +2102,11 @@ static int sec_aead_init(struct crypto_aead *tfm)
 	ret = sec_ctx_base_init(ctx);
 	if (ret)
 		return ret;
-	if (ctx->sec->qm.ver < QM_HW_V3) {
-		ctx->type_supported = SEC_BD_TYPE2;
-		ctx->req_op = &sec_aead_req_ops;
-	} else {
-		ctx->type_supported = SEC_BD_TYPE3;
+
+	if (ctx->type_supported == SEC_BD_TYPE3)
 		ctx->req_op = &sec_aead_req_ops_v3;
-	}
+	else
+		ctx->req_op = &sec_aead_req_ops;
 
 	ret = sec_auth_init(ctx);
 	if (ret)
-- 
2.43.0

