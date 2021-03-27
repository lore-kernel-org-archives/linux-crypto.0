Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A560C433E0
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Mar 2021 08:36:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F01CD619FC
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Mar 2021 08:36:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbhC0Ifb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 27 Mar 2021 04:35:31 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14164 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbhC0If1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 27 Mar 2021 04:35:27 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F6sXy1x6lznb4W;
        Sat, 27 Mar 2021 16:32:50 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Sat, 27 Mar 2021 16:35:15 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: hisilicon - delete redundant '\n'
Date:   Sat, 27 Mar 2021 16:32:45 +0800
Message-ID: <1616833965-10171-1-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

It has newline already by sysfs, so delete redundant '\n'

Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 4 ++--
 drivers/crypto/hisilicon/sec2/sec_main.c  | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 73ee997..3c56d33 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -814,9 +814,9 @@ static int hpre_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
 	}
 
 	if (pdev->revision >= QM_HW_V3)
-		qm->algs = "rsa\ndh\necdh\nx25519\nx448\necdsa\nsm2\n";
+		qm->algs = "rsa\ndh\necdh\nx25519\nx448\necdsa\nsm2";
 	else
-		qm->algs = "rsa\ndh\n";
+		qm->algs = "rsa\ndh";
 	qm->mode = uacce_mode;
 	qm->pdev = pdev;
 	qm->ver = pdev->revision;
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 226475d..b7c62a1 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -810,7 +810,7 @@ static int sec_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
 
 	qm->pdev = pdev;
 	qm->ver = pdev->revision;
-	qm->algs = "cipher\ndigest\naead\n";
+	qm->algs = "cipher\ndigest\naead";
 	qm->mode = uacce_mode;
 	qm->sqe_size = SEC_SQE_SIZE;
 	qm->dev_name = sec_name;
-- 
2.8.1

