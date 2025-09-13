Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24162EA73B;
	Sat, 13 Sep 2025 10:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757761082; cv=none; b=eWeIl19/v74x0vUcj4CMF89xneUorPn9tL3FJhPum7oTiMfSFqhNGh4EpLDJXg1sMVOvsQ/rpyHgYJMX/8fa1NI4viP1iNo5u8FzwgGew3dNYOce0Kl0j4clxGprsvUvOBP07CQQlroINAdTLf0HDIDFPt7sQhUVi7M72w02D3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757761082; c=relaxed/simple;
	bh=M3FRSJWZeKZTtRZIliTlJm+yW9HaNj63ySPbrZgKzcA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sFDRu26vXI4X7au3PFmrs4zp0jJgB8gQoJmiyBNLfmnw6F4bPYKn7pa947E9OZV5d6hLaGzx1oL3uamumavp4/6HWA1VxiSn1ZM8u4NcHTSGJUKXxBLya9jXbg9L+FkuyRvmmGAyBfpLc33to2F1JJxQOk/zBNc+uwjL93eVMcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cP7SH40vxzQlLm;
	Sat, 13 Sep 2025 18:53:19 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id B60BB180B57;
	Sat, 13 Sep 2025 18:57:56 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 13 Sep 2025 18:57:56 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 13 Sep 2025 18:57:55 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linuxarm@openeuler.org>, <fanghao11@huawei.com>, <liulongfang@huawei.com>,
	<qianweili@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH 1/5] crypto: hisilicon/qm - invalidate queues in use
Date: Sat, 13 Sep 2025 18:57:50 +0800
Message-ID: <20250913105754.3862444-2-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250913105754.3862444-1-huangchenghai2@huawei.com>
References: <20250913105754.3862444-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq200001.china.huawei.com (7.202.195.16)

From: Weili Qian <qianweili@huawei.com>

Before the device reset, although the driver has set the queue
status to intercept doorbells sent by the task process, the reset
thread is isolated from the user-mode task process, so the task process
may still send doorbells. Therefore, before the reset, the queue is
directly invalidated, and the device directly discards the doorbells
sent by the process.

Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 53 ++++++++++++++++++++++++++---------
 1 file changed, 40 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 102aff9ea19a..822202e0f11b 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -45,6 +45,8 @@
 
 #define QM_SQ_TYPE_MASK			GENMASK(3, 0)
 #define QM_SQ_TAIL_IDX(sqc)		((le16_to_cpu((sqc).w11) >> 6) & 0x1)
+#define QM_SQC_DISABLE_QP		(1U << 6)
+#define QM_XQC_RANDOM_DATA		0xaaaa
 
 /* cqc shift */
 #define QM_CQ_HOP_NUM_SHIFT		0
@@ -3179,6 +3181,9 @@ static int qm_eq_aeq_ctx_cfg(struct hisi_qm *qm)
 
 	qm_init_eq_aeq_status(qm);
 
+	/* Before starting the dev, clear the memory and then configure to device using. */
+	memset(qm->qdma.va, 0, qm->qdma.size);
+
 	ret = qm_eq_ctx_cfg(qm);
 	if (ret) {
 		dev_err(dev, "Set eqc failed!\n");
@@ -3190,9 +3195,13 @@ static int qm_eq_aeq_ctx_cfg(struct hisi_qm *qm)
 
 static int __hisi_qm_start(struct hisi_qm *qm)
 {
+	struct device *dev = &qm->pdev->dev;
 	int ret;
 
-	WARN_ON(!qm->qdma.va);
+	if (!qm->qdma.va) {
+		dev_err(dev, "qm qdma is NULL!\n");
+		return -EINVAL;
+	}
 
 	if (qm->fun_type == QM_HW_PF) {
 		ret = hisi_qm_set_vft(qm, 0, qm->qp_base, qm->qp_num);
@@ -3266,7 +3275,7 @@ static int qm_restart(struct hisi_qm *qm)
 	for (i = 0; i < qm->qp_num; i++) {
 		qp = &qm->qp_array[i];
 		if (atomic_read(&qp->qp_status.flags) == QP_STOP &&
-		    qp->is_resetting == true) {
+		    qp->is_resetting == true && qp->is_in_kernel == true) {
 			ret = qm_start_qp_nolock(qp, 0);
 			if (ret < 0) {
 				dev_err(dev, "Failed to start qp%d!\n", i);
@@ -3298,24 +3307,44 @@ static void qm_stop_started_qp(struct hisi_qm *qm)
 }
 
 /**
- * qm_clear_queues() - Clear all queues memory in a qm.
- * @qm: The qm in which the queues will be cleared.
+ * qm_invalid_queues() - invalid all queues in use.
+ * @qm: The qm in which the queues will be invalidated.
  *
- * This function clears all queues memory in a qm. Reset of accelerator can
- * use this to clear queues.
+ * This function invalid all queues in use. If the doorbell command is sent
+ * to device in user space after the device is reset, the device discards
+ * the doorbell command.
  */
-static void qm_clear_queues(struct hisi_qm *qm)
+static void qm_invalid_queues(struct hisi_qm *qm)
 {
 	struct hisi_qp *qp;
+	struct qm_sqc *sqc;
+	struct qm_cqc *cqc;
 	int i;
 
+	/*
+	 * Normal stop queues is no longer used and does not need to be
+	 * invalid queues.
+	 */
+	if (qm->status.stop_reason == QM_NORMAL)
+		return;
+
+	if (qm->status.stop_reason == QM_DOWN)
+		hisi_qm_cache_wb(qm);
+
 	for (i = 0; i < qm->qp_num; i++) {
 		qp = &qm->qp_array[i];
-		if (qp->is_in_kernel && qp->is_resetting)
+		if (!qp->is_resetting)
+			continue;
+
+		/* Modify random data and set sqc close bit to invalid queue. */
+		sqc = qm->sqc + i;
+		cqc = qm->cqc + i;
+		sqc->w8 = cpu_to_le16(QM_XQC_RANDOM_DATA);
+		sqc->w13 = cpu_to_le16(QM_SQC_DISABLE_QP);
+		cqc->w8 = cpu_to_le16(QM_XQC_RANDOM_DATA);
+		if (qp->is_in_kernel)
 			memset(qp->qdma.va, 0, qp->qdma.size);
 	}
-
-	memset(qm->qdma.va, 0, qm->qdma.size);
 }
 
 /**
@@ -3372,7 +3401,7 @@ int hisi_qm_stop(struct hisi_qm *qm, enum qm_stop_reason r)
 		}
 	}
 
-	qm_clear_queues(qm);
+	qm_invalid_queues(qm);
 	qm->status.stop_reason = QM_NORMAL;
 
 err_unlock:
@@ -4770,8 +4799,6 @@ void hisi_qm_dev_shutdown(struct pci_dev *pdev)
 	ret = hisi_qm_stop(qm, QM_DOWN);
 	if (ret)
 		dev_err(&pdev->dev, "Fail to stop qm in shutdown!\n");
-
-	hisi_qm_cache_wb(qm);
 }
 EXPORT_SYMBOL_GPL(hisi_qm_dev_shutdown);
 
-- 
2.43.0

