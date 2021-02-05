Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E17C7C433DB
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Feb 2021 10:33:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9984A64F3B
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Feb 2021 10:33:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbhBEKdA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Feb 2021 05:33:00 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:12856 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbhBEKQC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Feb 2021 05:16:02 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DXB8l5fqQz7hTw;
        Fri,  5 Feb 2021 18:13:59 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Fri, 5 Feb 2021 18:15:13 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH 2/6] crypto: hisilicon/qm - fix request missing error
Date:   Fri, 5 Feb 2021 18:12:54 +0800
Message-ID: <1612519978-33340-3-git-send-email-qianweili@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1612519978-33340-1-git-send-email-qianweili@huawei.com>
References: <1612519978-33340-1-git-send-email-qianweili@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add 'qp_stop_fail_cb' to ensure it is called as device is resetting.

Signed-off-by: Weili Qian <qianweili@huawei.com>
Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index e659436..108fc0e 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -622,6 +622,9 @@ static void qm_cq_head_update(struct hisi_qp *qp)
 
 static void qm_poll_qp(struct hisi_qp *qp, struct hisi_qm *qm)
 {
+	if (unlikely(atomic_read(&qp->qp_status.flags) == QP_STOP))
+		return;
+
 	if (qp->event_cb) {
 		qp->event_cb(qp);
 		return;
@@ -1868,6 +1871,28 @@ int hisi_qm_start_qp(struct hisi_qp *qp, unsigned long arg)
 EXPORT_SYMBOL_GPL(hisi_qm_start_qp);
 
 /**
+ * qp_stop_fail_cb() - call request cb.
+ * @qp: stopped failed qp.
+ *
+ * Callback function should be called whether task completed or not.
+ */
+static void qp_stop_fail_cb(struct hisi_qp *qp)
+{
+	int qp_used = atomic_read(&qp->qp_status.used);
+	u16 cur_tail = qp->qp_status.sq_tail;
+	u16 cur_head = (cur_tail + QM_Q_DEPTH - qp_used) % QM_Q_DEPTH;
+	struct hisi_qm *qm = qp->qm;
+	u16 pos;
+	int i;
+
+	for (i = 0; i < qp_used; i++) {
+		pos = (i + cur_head) % QM_Q_DEPTH;
+		qp->req_cb(qp, qp->sqe + (u32)(qm->sqe_size * pos));
+		atomic_dec(&qp->qp_status.used);
+	}
+}
+
+/**
  * qm_drain_qp() - Drain a qp.
  * @qp: The qp we want to drain.
  *
@@ -1962,6 +1987,9 @@ static int qm_stop_qp_nolock(struct hisi_qp *qp)
 	else
 		flush_work(&qp->qm->work);
 
+	if (unlikely(qp->is_resetting && atomic_read(&qp->qp_status.used)))
+		qp_stop_fail_cb(qp);
+
 	dev_dbg(dev, "stop queue %u!", qp->qp_id);
 
 	return 0;
-- 
2.8.1

