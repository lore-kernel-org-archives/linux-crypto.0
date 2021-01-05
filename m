Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E215C433DB
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jan 2021 06:15:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CBF7227C3
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jan 2021 06:15:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725535AbhAEGOs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Jan 2021 01:14:48 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10021 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbhAEGOs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Jan 2021 01:14:48 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4D92HC6mTTzj3NQ;
        Tue,  5 Jan 2021 14:13:11 +0800 (CST)
Received: from huawei.com (10.67.165.24) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.498.0; Tue, 5 Jan 2021
 14:14:01 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: hisilicon/qm - SVA bugfixed on Kunpeng920
Date:   Tue, 5 Jan 2021 14:12:03 +0800
Message-ID: <1609827123-842-1-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Kunpeng920 SEC/HPRE/ZIP cannot support running user space SVA and kernel
Crypto at the same time. Therefore, the algorithms should not be registered
to Crypto as user space SVA is enabled.

Signed-off-by: Kai Ye <yekai13@huawei.com>
Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/qm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index f21ccae..10a04ab 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -4004,6 +4004,9 @@ int hisi_qm_alg_register(struct hisi_qm *qm, struct hisi_qm_list *qm_list)
 {
 	int flag = 0;
 	int ret = 0;
+	/* HW V2 not support both use uacce sva mode and hardware crypto algs */
+	if (qm->ver <= QM_HW_V2 && qm->use_sva)
+		return 0;
 
 	mutex_lock(&qm_list->lock);
 	if (list_empty(&qm_list->list))
@@ -4035,6 +4038,9 @@ EXPORT_SYMBOL_GPL(hisi_qm_alg_register);
  */
 void hisi_qm_alg_unregister(struct hisi_qm *qm, struct hisi_qm_list *qm_list)
 {
+	if (qm->ver <= QM_HW_V2 && qm->use_sva)
+		return;
+
 	mutex_lock(&qm_list->lock);
 	list_del(&qm->list);
 	mutex_unlock(&qm_list->lock);
-- 
2.8.1

