Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B0C18B484;
	Fri, 30 Aug 2024 10:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725013045; cv=none; b=i4sh3ed8II07gT8EH1AwXc7VDrmoBX9U8dVvunCWkHOGGjeTXja3v1Up8sE8lT3sQQ5wv7pjqfSgcGURTjMZc2FN9oSyToAVSToRlmnxniRAEHAO5jdt4Q0oV0xyC0XMUGzdPkA2zoLxWELpDR9AwYNFCakjF0Z8x0ClBXOZEMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725013045; c=relaxed/simple;
	bh=m8H5+E8AUe3Id9/5ApIQ6gFjMKxwwY1qibyI2zuoadE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mYoCBd7FnVRXs8aiOKowodLvUCkXdAhDEo7YnVyVkrvKkZF00wpaEJtOt87XU4rL2HJ/vvqiB0w+43hJ/lUDRzDjBqQCZk6skPypoMS2KgSzfE+4uNNg7eXSzPmLEjsSvMSSsr6/gXF0FKAtL0iB3XAJnhInck2rtCHdNjZEmLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4WwDV55BDwz20lDc;
	Fri, 30 Aug 2024 18:12:29 +0800 (CST)
Received: from kwepemd200024.china.huawei.com (unknown [7.221.188.85])
	by mail.maildlp.com (Postfix) with ESMTPS id 431941A0188;
	Fri, 30 Aug 2024 18:17:21 +0800 (CST)
Received: from localhost.huawei.com (10.90.30.45) by
 kwepemd200024.china.huawei.com (7.221.188.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 30 Aug 2024 18:17:20 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <shenyang39@huawei.com>,
	<songzhiqi1@huawei.com>, <qianweili@huawei.com>, <linwenkai6@hisilicon.com>,
	<taoqi10@huawei.com>, <wangzhou1@hisilicon.com>, <huangchenghai2@huawei.com>
Subject: [PATCH 2/3] crypto: hisilicon - add a lock for the qp send operation
Date: Fri, 30 Aug 2024 18:17:17 +0800
Message-ID: <20240830101718.3193159-3-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20240830101718.3193159-1-huangchenghai2@huawei.com>
References: <20240830101718.3193159-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemd200024.china.huawei.com (7.221.188.85)

Apply for a lock before the qp send operation to ensure no
resource competition in multi-concurrency situations.

This modification has almost no impact on performance.

Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 2 ++
 drivers/crypto/hisilicon/zip/zip_crypto.c   | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 764532a6ca82..c167dbd6c7d6 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -575,7 +575,9 @@ static int hpre_send(struct hpre_ctx *ctx, struct hpre_sqe *msg)
 
 	do {
 		atomic64_inc(&dfx[HPRE_SEND_CNT].value);
+		spin_lock_bh(&ctx->req_lock);
 		ret = hisi_qp_send(ctx->qp, msg);
+		spin_unlock_bh(&ctx->req_lock);
 		if (ret != -EBUSY)
 			break;
 		atomic64_inc(&dfx[HPRE_SEND_BUSY_CNT].value);
diff --git a/drivers/crypto/hisilicon/zip/zip_crypto.c b/drivers/crypto/hisilicon/zip/zip_crypto.c
index 94e2d66b04b6..e3a31e3416be 100644
--- a/drivers/crypto/hisilicon/zip/zip_crypto.c
+++ b/drivers/crypto/hisilicon/zip/zip_crypto.c
@@ -213,6 +213,7 @@ static int hisi_zip_do_work(struct hisi_zip_qp_ctx *qp_ctx,
 {
 	struct hisi_acc_sgl_pool *pool = qp_ctx->sgl_pool;
 	struct hisi_zip_dfx *dfx = &qp_ctx->zip_dev->dfx;
+	struct hisi_zip_req_q *req_q = &qp_ctx->req_q;
 	struct acomp_req *a_req = req->req;
 	struct hisi_qp *qp = qp_ctx->qp;
 	struct device *dev = &qp->qm->pdev->dev;
@@ -244,7 +245,9 @@ static int hisi_zip_do_work(struct hisi_zip_qp_ctx *qp_ctx,
 
 	/* send command to start a task */
 	atomic64_inc(&dfx->send_cnt);
+	write_lock(&req_q->req_lock);
 	ret = hisi_qp_send(qp, &zip_sqe);
+	write_unlock(&req_q->req_lock);
 	if (unlikely(ret < 0)) {
 		atomic64_inc(&dfx->send_busy_cnt);
 		ret = -EAGAIN;
-- 
2.33.0

