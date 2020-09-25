Return-Path: <SRS0=J/bj=DC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C91AC4363D
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Sep 2020 14:09:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D682208A9
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Sep 2020 14:09:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728942AbgIYOI7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Sep 2020 10:08:59 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:47148 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728959AbgIYOI6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Sep 2020 10:08:58 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 58CF5DE3620179093242;
        Fri, 25 Sep 2020 22:08:56 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Fri, 25 Sep 2020 22:08:50 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH RESEND 4/4] crypto: hisilicon/zip - fix the uninitalized 'curr_qm_qp_num'
Date:   Fri, 25 Sep 2020 22:06:17 +0800
Message-ID: <1601042777-26150-5-git-send-email-shenyang39@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1601042777-26150-1-git-send-email-shenyang39@huawei.com>
References: <1601042777-26150-1-git-send-email-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Sihang Chen <chensihang1@hisilicon.com>

The 'qm->curr_qm_qp_num' is not initialized, which will result in failure
to write the current_q file.

Signed-off-by: Sihang Chen <chensihang1@hisilicon.com>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/zip/zip_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index f10bf99..4bd2c81 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -760,6 +760,7 @@ static int hisi_zip_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
 	if (qm->fun_type == QM_HW_PF) {
 		qm->qp_base = HZIP_PF_DEF_Q_BASE;
 		qm->qp_num = pf_q_num;
+		qm->debug.curr_qm_qp_num = pf_q_num;
 		qm->qm_list = &zip_devices;
 	} else if (qm->fun_type == QM_HW_VF && qm->ver == QM_HW_V1) {
 		/*
-- 
2.7.4

