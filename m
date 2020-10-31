Return-Path: <SRS0=m/1o=EG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E38E8C388F7
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Oct 2020 09:08:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0D5D206F7
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Oct 2020 09:08:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbgJaJIn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 31 Oct 2020 05:08:43 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7020 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbgJaJIn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 31 Oct 2020 05:08:43 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CNYJ94rD4zhcYt;
        Sat, 31 Oct 2020 17:08:41 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Sat, 31 Oct 2020 17:08:34 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH 2/8] crypto: hisilicon/qm - modify the return type of function
Date:   Sat, 31 Oct 2020 17:07:02 +0800
Message-ID: <1604135228-18410-3-git-send-email-qianweili@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1604135228-18410-1-git-send-email-qianweili@huawei.com>
References: <1604135228-18410-1-git-send-email-qianweili@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The returns of 'qm_get_hw_error_status' and 'qm_get_dev_err_status'
are values from the hardware registers, which should not be defined
as 'int', so update as 'u32'.

Signed-off-by: Weili Qian <qianweili@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/qm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 1de3aac..d5d06ae 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3291,7 +3291,7 @@ pci_ers_result_t hisi_qm_dev_err_detected(struct pci_dev *pdev,
 }
 EXPORT_SYMBOL_GPL(hisi_qm_dev_err_detected);
 
-static int qm_get_hw_error_status(struct hisi_qm *qm)
+static u32 qm_get_hw_error_status(struct hisi_qm *qm)
 {
 	return readl(qm->io_base + QM_ABNORMAL_INT_STATUS);
 }
@@ -3590,7 +3590,7 @@ static int qm_vf_reset_done(struct hisi_qm *qm)
 	return ret;
 }
 
-static int qm_get_dev_err_status(struct hisi_qm *qm)
+static u32 qm_get_dev_err_status(struct hisi_qm *qm)
 {
 	return qm->err_ini->get_dev_hw_err_status(qm);
 }
-- 
2.8.1

