Return-Path: <SRS0=qXKu=AK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C025C433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jun 2020 18:57:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08C2E204EC
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jun 2020 18:57:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729412AbgF2S5I (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jun 2020 14:57:08 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:59614 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726920AbgF2S5H (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jun 2020 14:57:07 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 3F3DC1C0664F4EBA5BF3;
        Mon, 29 Jun 2020 19:10:58 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Mon, 29 Jun 2020 19:10:45 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: [PATCH 3/9] crypto: hisilicon/qm - fix print frequence in hisi_qp_send
Date:   Mon, 29 Jun 2020 19:09:02 +0800
Message-ID: <1593428948-64634-4-git-send-email-shenyang39@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1593428948-64634-1-git-send-email-shenyang39@huawei.com>
References: <1593428948-64634-1-git-send-email-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Requests will be sent continuously as resetting, which will cause 'printk'
flooding. Using 'dev_info_ratelimited' can solve this problem well.

Fixes: b67202e8ed30("crypto: hisilicon/qm - add state machine for QM")
Signed-off-by: Yang Shen <shenyang39@huawei.com>
Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 79d17a0..095ebf0 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -1992,7 +1992,7 @@ int hisi_qp_send(struct hisi_qp *qp, const void *msg)
 	if (unlikely(atomic_read(&qp->qp_status.flags) == QP_STOP ||
 		     atomic_read(&qp->qm->status.flags) == QM_STOP ||
 		     qp->is_resetting)) {
-		dev_info(&qp->qm->pdev->dev, "QP is stopped or resetting\n");
+		dev_info_ratelimited(&qp->qm->pdev->dev, "QP is stopped or resetting\n");
 		return -EAGAIN;
 	}
 
-- 
2.7.4

