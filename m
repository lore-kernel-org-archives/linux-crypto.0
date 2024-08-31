Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55A716A940;
	Sat, 31 Aug 2024 09:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725097818; cv=none; b=dfdzUehabJ5ckF5oIsSHSsu2Agk8FANM0BP59BwNwOzolm0o7B7Fv+0m/O4NkKXKxEbfa/BrsVLlT+TP+hWm2I0F04SoU40BIYEZg/FIChsCIbW0Jxyt49gwDp/YAkF34K06Ef2OlUAuqS3ufqH+vfdzwvTFg2eJK8evDpeaJoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725097818; c=relaxed/simple;
	bh=NWhtZ/Bj5G8xe/nOcPTyigY9psQjLUTolLVJnHofZXc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nr6EO1Th4zz4qDDQxukruk3l+YhPlvNe231t7KJECMSBxUdILwbGRX+fMY1MQ7HsgasJ6bEnM9yweH9RSiobuHge/Bh8JW9VkJqHtdbE949iHces57f6VzdvmqOsKBY1AKGIDTK2Qw/4cMkBh2lGcLk2AjQ/rI3nvNwNoMQRWbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Wwqvs3G8KzpVCx;
	Sat, 31 Aug 2024 17:48:25 +0800 (CST)
Received: from kwepemd200024.china.huawei.com (unknown [7.221.188.85])
	by mail.maildlp.com (Postfix) with ESMTPS id EF10B1400DC;
	Sat, 31 Aug 2024 17:50:11 +0800 (CST)
Received: from localhost.huawei.com (10.90.30.45) by
 kwepemd200024.china.huawei.com (7.221.188.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 31 Aug 2024 17:50:11 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <shenyang39@huawei.com>,
	<songzhiqi1@huawei.com>, <qianweili@huawei.com>, <linwenkai6@hisilicon.com>,
	<taoqi10@huawei.com>, <wangzhou1@hisilicon.com>, <huangchenghai2@huawei.com>
Subject: [PATCH v2 2/3] crypto: hisilicon - add a lock for the qp send operation
Date: Sat, 31 Aug 2024 17:50:08 +0800
Message-ID: <20240831095009.446780-3-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20240831095009.446780-1-huangchenghai2@huawei.com>
References: <20240831095009.446780-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemd200024.china.huawei.com (7.221.188.85)

Apply for a lock before the qp send operation to ensure no
resource race in multi-concurrency situations.

This modification has almost no impact on performance.

Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---

v2:
- Rebased on top of the merged spin_lock type.

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
index 92d3bd0dfe1b..7327f8f29b01 100644
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
+	spin_lock_bh(&req_q->req_lock);
 	ret = hisi_qp_send(qp, &zip_sqe);
+	spin_unlock_bh(&req_q->req_lock);
 	if (unlikely(ret < 0)) {
 		atomic64_inc(&dfx->send_busy_cnt);
 		ret = -EAGAIN;
-- 
2.33.0

