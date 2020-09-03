Return-Path: <SRS0=A9EK=CM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 204B0C433E9
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Sep 2020 12:04:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB27A2072A
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Sep 2020 12:04:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728695AbgICMDM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Sep 2020 08:03:12 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:10760 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728777AbgICL4V (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Sep 2020 07:56:21 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 008EE505A423727940B2;
        Thu,  3 Sep 2020 19:55:15 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Thu, 3 Sep 2020 19:55:04 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH 2/2] crypto: hisilicon/qm - remove the update of flags
Date:   Thu, 3 Sep 2020 19:54:00 +0800
Message-ID: <1599134040-55860-3-git-send-email-qianweili@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1599134040-55860-1-git-send-email-qianweili@huawei.com>
References: <1599134040-55860-1-git-send-email-qianweili@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

'qm_init_qp_status' is just a help function to initiate some 'QP' status.
'QP' status should be updated separately.
This patch removes the updating flags in 'QP' status.

Signed-off-by: Weili Qian <qianweili@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/qm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 07efc52..cfd66ee 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -757,7 +757,6 @@ static void qm_init_qp_status(struct hisi_qp *qp)
 	qp_status->sq_tail = 0;
 	qp_status->cq_head = 0;
 	qp_status->cqc_phase = true;
-	atomic_set(&qp_status->flags, 0);
 	atomic_set(&qp_status->used, 0);
 }
 
-- 
2.8.1

