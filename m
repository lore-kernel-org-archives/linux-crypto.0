Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4753074BB;
	Sat, 25 Oct 2025 16:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409168; cv=none; b=qaF4P/CyRYC9Bk8cHPofa+DmUj7VgDotQddGJyoj4Ae7UjSDVByJnG8YYdvxrI4MUM4XeA6/LhHFBe0bo3JKMHu5gB7Lq5iJDqZIcixFBfRNzri1E18Y2ae4NFfPt8c/98+YxYZj5oi/CnArJIn30ryiQTi7ApTw95x4jR5DL50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409168; c=relaxed/simple;
	bh=RnLW4VlW/C3o9OSMXfdYsZDPzhUUmupmizxMfYKB3Fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DSr0wN3xi7ipCGwQz2A+FsUK9VNinylQzT87o1LjR4Bu+2mdiXzz9vYpYON/ifSP/byVgBaqdIyI+nZQbLgv1RADObyRjn+/gogvrvCyoyEE6bvnNHB+TLi4N/vx0627rRCqNzRxelef383EjDZPlw9pOlTCUDy2TQP6YJXz6Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BjxXc6ug; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BjxXc6ug"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D8CC4CEFF;
	Sat, 25 Oct 2025 16:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409168;
	bh=RnLW4VlW/C3o9OSMXfdYsZDPzhUUmupmizxMfYKB3Fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BjxXc6ugz6f+c/XwCAcKrOLw/R2oUQa3OQEmoxaz6Gj8ML8aDgWF2Cmv9svku8QVq
	 TJLiJasGaVBHZP7TnK9cYBuLCus8g3qkUUa5pGBwKKFsCWk2C3JMX7nWmfk7pBvfaI
	 Rtqhc8woESX/EVg2iajxWtlCB3NYVHlP32fGC73Vwe1avWZV7Uk061iHfe5JZKAiwP
	 6cvKtjavfsU9iiOYPnn+AXvBWtxCdv8hzlTj8W06WF9DrfVTfkbaWD11MlfdeyrR9u
	 KqkRJ6Nh8rl/bZboaA2GuCkfR/E/DBYFtudK3u44aDxDAM9DBrJCfWO0G5DJiUidBo
	 gQFdswgq80+ug==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Weili Qian <qianweili@huawei.com>,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	wangzhou1@hisilicon.com,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.12] crypto: hisilicon/qm - invalidate queues in use
Date: Sat, 25 Oct 2025 11:57:39 -0400
Message-ID: <20251025160905.3857885-228-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Weili Qian <qianweili@huawei.com>

[ Upstream commit 85acd1b26b8f5b838887dc965dc3aa2c0253f4d1 ]

Before the device reset, although the driver has set the queue
status to intercept doorbells sent by the task process, the reset
thread is isolated from the user-mode task process, so the task process
may still send doorbells. Therefore, before the reset, the queue is
directly invalidated, and the device directly discards the doorbells
sent by the process.

Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES – the patch fixes a real race in the HiSilicon QM reset path and
stays tightly scoped to that driver.

- `qm_invalid_queues()` now actively invalidates any queue flagged as
  resetting by poisoning the software queue/cq contexts and setting the
  hardware disable bit, so doorbells that user space might still issue
  during a reset are discarded instead of touching stale DMA memory
  (`drivers/crypto/hisilicon/qm.c:3331-3361`). Flushing the on-device
  cache when the stop reason is `QM_DOWN` guarantees the device sees the
  new context before the reset proceeds.
- Only kernel-owned queues are auto-restarted after a reset
  (`drivers/crypto/hisilicon/qm.c:3288-3300`), which keeps user queues
  quiesced until user space explicitly re-initialises them, avoiding re-
  enabling a queue whose doorbells were just invalidated.
- The qdma backing store is cleared right before programming EQ/AEQ
  contexts and the start routine now fails cleanly if that buffer were
  ever missing (`drivers/crypto/hisilicon/qm.c:3198-3236`), preserving
  the old “clear then program” behaviour without leaving a window where
  fresh doorbells see zeroed contexts.
- The shutdown path simply reuses the new invalidation logic, so
  removing the extra cache writeback is safe
  (`drivers/crypto/hisilicon/qm.c:4836-4845`).

These adjustments address a user-visible bug (queue doorbells getting
through during reset) without touching shared infrastructure or altering
APIs. The changes are confined to the HiSilicon QM driver, rely only on
existing fields, and align with stable-tree policy for targeted hardware
fixes. Suggest backporting.

 drivers/crypto/hisilicon/qm.c | 53 ++++++++++++++++++++++++++---------
 1 file changed, 40 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 102aff9ea19a0..822202e0f11b6 100644
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
2.51.0

