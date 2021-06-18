Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C974CC48BDF
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Jun 2021 09:36:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2A43613EB
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Jun 2021 09:36:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232256AbhFRJiy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Jun 2021 05:38:54 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:8271 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232666AbhFRJiv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Jun 2021 05:38:51 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4G5twS56bLz1BNSw;
        Fri, 18 Jun 2021 17:31:36 +0800 (CST)
Received: from dggema713-chm.china.huawei.com (10.3.20.77) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 18 Jun 2021 17:36:40 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggema713-chm.china.huawei.com (10.3.20.77) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 18 Jun 2021 17:36:39 +0800
From:   Wenkai Lin <linwenkai6@hisilicon.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <prime.zeng@hisilicon.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH] crypto: hisilicon/qm - implement for querying hardware tasks status.
Date:   Fri, 18 Jun 2021 17:36:06 +0800
Message-ID: <1624008966-1395-1-git-send-email-linwenkai6@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggema713-chm.china.huawei.com (10.3.20.77)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds a function hisi_qm_is_q_updated to
check if the task is ready in hardware queue when
user polls an UACCE queue.This prevents users from
repeatedly querying whether the accelerator has
completed tasks, which wastes CPU resources.

Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
---
 drivers/crypto/hisilicon/qm.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 5807094..1d67f94 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -2926,6 +2926,23 @@ static void hisi_qm_uacce_stop_queue(struct uacce_queue *q)
 	hisi_qm_stop_qp(q->priv);
 }
 
+static int hisi_qm_is_q_updated(struct uacce_queue *q)
+{
+	struct hisi_qp *qp = q->priv;
+	struct qm_cqe *cqe = qp->cqe + qp->qp_status.cq_head;
+	int updated = 0;
+
+	while (QM_CQE_PHASE(cqe) == qp->qp_status.cqc_phase) {
+		/* make sure to read data from memory */
+		dma_rmb();
+		qm_cq_head_update(qp);
+		cqe = qp->cqe + qp->qp_status.cq_head;
+		updated = 1;
+	}
+
+	return updated;
+}
+
 static void qm_set_sqctype(struct uacce_queue *q, u16 type)
 {
 	struct hisi_qm *qm = q->uacce->priv;
@@ -2971,6 +2988,7 @@ static const struct uacce_ops uacce_qm_ops = {
 	.stop_queue = hisi_qm_uacce_stop_queue,
 	.mmap = hisi_qm_uacce_mmap,
 	.ioctl = hisi_qm_uacce_ioctl,
+	.is_q_updated = hisi_qm_is_q_updated,
 };
 
 static int qm_alloc_uacce(struct hisi_qm *qm)
-- 
2.7.4

