Return-Path: <SRS0=MAzA=AM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53169C433E1
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jul 2020 07:24:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38E462074D
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jul 2020 07:24:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbgGAHY2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Jul 2020 03:24:28 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7326 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727981AbgGAHY2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Jul 2020 03:24:28 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 0F23C60AFAC84685FC63;
        Wed,  1 Jul 2020 15:21:42 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Wed, 1 Jul 2020 15:21:31 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: [Patch v2 4/9] crypto: hisilicon/qm - fix judgement of queue is full
Date:   Wed, 1 Jul 2020 15:19:50 +0800
Message-ID: <1593587995-7391-5-git-send-email-shenyang39@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1593587995-7391-1-git-send-email-shenyang39@huawei.com>
References: <1593587995-7391-1-git-send-email-shenyang39@huawei.com>
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
index 095ebf0..93f443c 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -1655,7 +1655,7 @@ static void *qm_get_avail_sqe(struct hisi_qp *qp)
 	struct hisi_qp_status *qp_status = &qp->qp_status;
 	u16 sq_tail = qp_status->sq_tail;
 
-	if (unlikely(atomic_read(&qp->qp_status.used) == QM_Q_DEPTH))
+	if (unlikely(atomic_read(&qp->qp_status.used) == QM_Q_DEPTH - 1))
 		return NULL;
 
 	return qp->sqe + sq_tail * qp->qm->sqe_size;
-- 
2.7.4

