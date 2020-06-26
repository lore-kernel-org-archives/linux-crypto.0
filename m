Return-Path: <SRS0=PFiu=AH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA28AC433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jun 2020 10:32:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A446920768
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jun 2020 10:32:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbgFZKcs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jun 2020 06:32:48 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:6829 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727925AbgFZKcs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jun 2020 06:32:48 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 7DF68A5A2842CC6A5899
        for <linux-crypto@vger.kernel.org>; Fri, 26 Jun 2020 18:32:43 +0800 (CST)
Received: from huawei.com (10.67.165.24) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Fri, 26 Jun 2020
 18:32:40 +0800
From:   Longfang Liu <liulongfang@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>
Subject: [PATCH 5/5] crypto: hisilicon/sec2 - fix some coding styles
Date:   Fri, 26 Jun 2020 18:32:09 +0800
Message-ID: <1593167529-22463-6-git-send-email-liulongfang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1593167529-22463-1-git-send-email-liulongfang@huawei.com>
References: <1593167529-22463-1-git-send-email-liulongfang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Modify some log output interfaces and
update author information

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec_main.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 5bef3d8..90cd6b5 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -282,7 +282,7 @@ static int sec_engine_init(struct hisi_qm *qm)
 					 reg, reg & 0x1, SEC_DELAY_10_US,
 					 SEC_POLL_TIMEOUT_US);
 	if (ret) {
-		dev_err(&qm->pdev->dev, "fail to init sec mem\n");
+		pci_err(qm->pdev, "fail to init sec mem\n");
 		return ret;
 	}
 
@@ -371,7 +371,7 @@ static void sec_hw_error_enable(struct hisi_qm *qm)
 
 	if (qm->ver == QM_HW_V1) {
 		writel(SEC_CORE_INT_DISABLE, qm->io_base + SEC_CORE_INT_MASK);
-		dev_info(&qm->pdev->dev, "V1 not support hw error handle\n");
+		pci_info(qm->pdev, "V1 not support hw error handle\n");
 		return;
 	}
 
@@ -599,7 +599,7 @@ static int sec_core_debug_init(struct hisi_qm *qm)
 
 	regset = devm_kzalloc(dev, sizeof(*regset), GFP_KERNEL);
 	if (!regset)
-		return -ENOENT;
+		return -ENOMEM;
 
 	regset->regs = sec_dfx_regs;
 	regset->nregs = ARRAY_SIZE(sec_dfx_regs);
@@ -686,8 +686,6 @@ static void sec_log_hw_error(struct hisi_qm *qm, u32 err_sts)
 						SEC_CORE_SRAM_ECC_ERR_INFO);
 				dev_err(dev, "multi ecc sram num=0x%x\n",
 					SEC_ECC_NUM(err_val));
-				dev_err(dev, "multi ecc sram addr=0x%x\n",
-					SEC_ECC_ADDR(err_val));
 			}
 		}
 		errs++;
@@ -996,5 +994,6 @@ module_exit(sec_exit);
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Zaibo Xu <xuzaibo@huawei.com>");
 MODULE_AUTHOR("Longfang Liu <liulongfang@huawei.com>");
+MODULE_AUTHOR("Kai Ye <yekai13@huawei.com>");
 MODULE_AUTHOR("Wei Zhang <zhangwei375@huawei.com>");
 MODULE_DESCRIPTION("Driver for HiSilicon SEC accelerator");
-- 
2.8.1

