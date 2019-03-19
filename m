Return-Path: <SRS0=OEQJ=RW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 645DBC43381
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Mar 2019 13:37:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 352FF2133D
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Mar 2019 13:37:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbfCSNhQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Mar 2019 09:37:16 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5268 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726661AbfCSNhQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Mar 2019 09:37:16 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A99D5A3974735930077A;
        Tue, 19 Mar 2019 21:37:13 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.408.0; Tue, 19 Mar 2019
 21:37:05 +0800
From:   Yue Haibing <yuehaibing@huawei.com>
To:     <george.cherian@cavium.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] crypto: cavium - remove unused fucntions
Date:   Tue, 19 Mar 2019 21:37:00 +0800
Message-ID: <20190319133700.22864-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

cptvf_mbox_send_ack and cptvf_mbox_send_nack are never
used since introdution in commit c694b233295b ("crypto: cavium
- Add the Virtual Function driver for CPT")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/crypto/cavium/cpt/cptvf_mbox.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/crypto/cavium/cpt/cptvf_mbox.c b/drivers/crypto/cavium/cpt/cptvf_mbox.c
index d5ec3b8..4f438ec 100644
--- a/drivers/crypto/cavium/cpt/cptvf_mbox.c
+++ b/drivers/crypto/cavium/cpt/cptvf_mbox.c
@@ -17,23 +17,6 @@ static void cptvf_send_msg_to_pf(struct cpt_vf *cptvf, struct cpt_mbox *mbx)
 			mbx->data);
 }
 
-/* ACKs PF's mailbox message
- */
-void cptvf_mbox_send_ack(struct cpt_vf *cptvf, struct cpt_mbox *mbx)
-{
-	mbx->msg = CPT_MBOX_MSG_TYPE_ACK;
-	cptvf_send_msg_to_pf(cptvf, mbx);
-}
-
-/* NACKs PF's mailbox message that VF is not able to
- * complete the action
- */
-void cptvf_mbox_send_nack(struct cpt_vf *cptvf, struct cpt_mbox *mbx)
-{
-	mbx->msg = CPT_MBOX_MSG_TYPE_NACK;
-	cptvf_send_msg_to_pf(cptvf, mbx);
-}
-
 /* Interrupt handler to handle mailbox messages from VFs */
 void cptvf_handle_mbox_intr(struct cpt_vf *cptvf)
 {
-- 
2.7.4


