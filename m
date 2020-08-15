Return-Path: <SRS0=CHgJ=B2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E564FC433EC
	for <linux-crypto@archiver.kernel.org>; Sun, 16 Aug 2020 01:44:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEC8520675
	for <linux-crypto@archiver.kernel.org>; Sun, 16 Aug 2020 01:44:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729604AbgHPBog (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 15 Aug 2020 21:44:36 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:33856 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729405AbgHPBoS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 15 Aug 2020 21:44:18 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id F220228B65B471A81098;
        Sat, 15 Aug 2020 17:58:33 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Sat, 15 Aug 2020 17:58:24 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH v5 04/10] crypto: hisilicon/qm - fix judgement of queue is full
Date:   Sat, 15 Aug 2020 17:56:11 +0800
Message-ID: <1597485377-2678-5-git-send-email-shenyang39@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1597485377-2678-1-git-send-email-shenyang39@huawei.com>
References: <1597485377-2678-1-git-send-email-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Hui Tang <tanghui20@huawei.com>

The queue depth is 1024, so the condition for judging the queue full
should be 1023, otherwise the hardware cannot judge whether the queue
is empty or full.

Fixes: 263c9959c937("crypto: hisilicon - add queue management driver...")
Signed-off-by: Hui Tang <tanghui20@huawei.com>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/qm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 95a1b6c..b9bff96 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -1647,7 +1647,7 @@ static void *qm_get_avail_sqe(struct hisi_qp *qp)
 	struct hisi_qp_status *qp_status = &qp->qp_status;
 	u16 sq_tail = qp_status->sq_tail;
 
-	if (unlikely(atomic_read(&qp->qp_status.used) == QM_Q_DEPTH))
+	if (unlikely(atomic_read(&qp->qp_status.used) == QM_Q_DEPTH - 1))
 		return NULL;
 
 	return qp->sqe + sq_tail * qp->qm->sqe_size;
-- 
2.7.4

