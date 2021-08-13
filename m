Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6155FC4320A
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Aug 2021 09:53:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D61160F00
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Aug 2021 09:53:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239933AbhHMJyW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Aug 2021 05:54:22 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:13313 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239886AbhHMJyV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Aug 2021 05:54:21 -0400
Received: from dggeme768-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GmJmH394tz83p1;
        Fri, 13 Aug 2021 17:53:51 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggeme768-chm.china.huawei.com (10.3.19.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 13 Aug 2021 17:53:53 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <liulongfang@huawei.com>
Subject: [PATCH v2 5/5] crypto: hisilicon - check _PS0 and _PR0 method
Date:   Fri, 13 Aug 2021 17:50:09 +0800
Message-ID: <1628848209-26398-6-git-send-email-qianweili@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1628848209-26398-1-git-send-email-qianweili@huawei.com>
References: <1628848209-26398-1-git-send-email-qianweili@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeme768-chm.china.huawei.com (10.3.19.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

To support runtime PM, use the function 'pci_set_power_state' to change
the power state. Therefore, method _PS0 or _PR0 needs to be filled by
platform. So check whether the method is supported, if not, print a
prompt information.

Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index e29ff97..369562d 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3282,6 +3282,10 @@ static void hisi_qm_pre_init(struct hisi_qm *qm)
 	init_rwsem(&qm->qps_lock);
 	qm->qp_in_used = 0;
 	qm->misc_ctl = false;
+	if (qm->fun_type == QM_HW_PF && qm->ver > QM_HW_V2) {
+		if (!acpi_device_power_manageable(ACPI_COMPANION(&pdev->dev)))
+			dev_info(&pdev->dev, "_PS0 and _PR0 are not defined");
+	}
 }
 
 static void qm_cmd_uninit(struct hisi_qm *qm)
-- 
2.8.1

