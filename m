Return-Path: <SRS0=tM/H=BE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 261B2C433EA
	for <linux-crypto@archiver.kernel.org>; Sat, 25 Jul 2020 06:09:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 097B7206C1
	for <linux-crypto@archiver.kernel.org>; Sat, 25 Jul 2020 06:09:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgGYGJr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 25 Jul 2020 02:09:47 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:33162 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726273AbgGYGJr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 25 Jul 2020 02:09:47 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 94D5412D207D22F38E03;
        Sat, 25 Jul 2020 14:09:28 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Sat, 25 Jul 2020 14:09:21 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH 4/4] crypto: hisilicon/zip - fix the uninitalized 'curr_qm_qp_num'
Date:   Sat, 25 Jul 2020 14:06:50 +0800
Message-ID: <1595657210-3964-5-git-send-email-shenyang39@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595657210-3964-1-git-send-email-shenyang39@huawei.com>
References: <1595657210-3964-1-git-send-email-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
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
index cc4a829..47efc2f 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -762,6 +762,7 @@ static int hisi_zip_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
 	if (qm->fun_type == QM_HW_PF) {
 		qm->qp_base = HZIP_PF_DEF_Q_BASE;
 		qm->qp_num = pf_q_num;
+		qm->debug.curr_qm_qp_num = pf_q_num;
 		qm->qm_list = &zip_devices;
 	} else if (qm->fun_type == QM_HW_VF && qm->ver == QM_HW_V1) {
 		/*
--
2.7.4

