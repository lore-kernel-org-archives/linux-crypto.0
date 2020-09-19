Return-Path: <SRS0=oEI+=C4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64E08C43464
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Sep 2020 11:03:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 375CB2158C
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Sep 2020 11:03:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgISLDC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 19 Sep 2020 07:03:02 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13772 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726159AbgISLC5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 19 Sep 2020 07:02:57 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 80ABF425AAEA7E8AF662;
        Sat, 19 Sep 2020 19:02:54 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Sat, 19 Sep 2020 19:02:47 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH 2/2] crypto: hisilicon/qm - remove the update of flags
Date:   Sat, 19 Sep 2020 19:01:36 +0800
Message-ID: <1600513296-29287-3-git-send-email-qianweili@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1600513296-29287-1-git-send-email-qianweili@huawei.com>
References: <1600513296-29287-1-git-send-email-qianweili@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
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

