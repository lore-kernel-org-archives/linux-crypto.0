Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D37E0C4338F
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Aug 2021 09:59:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B140C60ED6
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Aug 2021 09:59:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244771AbhHFJ7t (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Aug 2021 05:59:49 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:7801 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244700AbhHFJ7t (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Aug 2021 05:59:49 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Gh1Cv4FM6zYlmS;
        Fri,  6 Aug 2021 17:59:23 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 6 Aug 2021 17:59:31 +0800
Received: from huawei.com (10.69.192.56) by dggpeml500012.china.huawei.com
 (7.185.36.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 6 Aug 2021
 17:59:30 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <yekai13@huawei.com>
Subject: [PATCH 2/2] crypto: hisilicon/sec - modify the hardware endian configuration
Date:   Fri, 6 Aug 2021 17:58:34 +0800
Message-ID: <1628243914-33224-3-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1628243914-33224-1-git-send-email-yekai13@huawei.com>
References: <1628243914-33224-1-git-send-email-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500012.china.huawei.com (7.185.36.15)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When the endian configuration of the hardware is abnormal, it will
cause the SEC engine is faulty that reports empty message. And it
will affect the normal function of the hardware. Currently the soft
configuration method can't restore the faulty device. The endian
needs to be configured according to the system properties. So fix it.

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec.h      |  5 -----
 drivers/crypto/hisilicon/sec2/sec_main.c | 35 ++++++++++----------------------
 2 files changed, 11 insertions(+), 29 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
index 018415b..d97cf02 100644
--- a/drivers/crypto/hisilicon/sec2/sec.h
+++ b/drivers/crypto/hisilicon/sec2/sec.h
@@ -157,11 +157,6 @@ struct sec_ctx {
 	struct device *dev;
 };
 
-enum sec_endian {
-	SEC_LE = 0,
-	SEC_32BE,
-	SEC_64BE
-};
 
 enum sec_debug_file_index {
 	SEC_CLEAR_ENABLE,
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 8addbd7..f637fc8 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -312,31 +312,20 @@ static const struct pci_device_id sec_dev_ids[] = {
 };
 MODULE_DEVICE_TABLE(pci, sec_dev_ids);
 
-static u8 sec_get_endian(struct hisi_qm *qm)
+static void sec_set_endian(struct hisi_qm *qm)
 {
 	u32 reg;
 
-	/*
-	 * As for VF, it is a wrong way to get endian setting by
-	 * reading a register of the engine
-	 */
-	if (qm->pdev->is_virtfn) {
-		dev_err_ratelimited(&qm->pdev->dev,
-				    "cannot access a register in VF!\n");
-		return SEC_LE;
-	}
 	reg = readl_relaxed(qm->io_base + SEC_CONTROL_REG);
-	/* BD little endian mode */
-	if (!(reg & BIT(0)))
-		return SEC_LE;
-
-	/* BD 32-bits big endian mode */
-	else if (!(reg & BIT(1)))
-		return SEC_32BE;
-
-	/* BD 64-bits big endian mode */
-	else
-		return SEC_64BE;
+	reg &= ~(BIT(1) | BIT(0));
+#ifndef CONFIG_64BIT
+	reg |= BIT(1);
+#endif
+
+#ifndef CONFIG_CPU_LITTLE_ENDIAN
+	reg |= BIT(0);
+#endif
+	writel_relaxed(reg, qm->io_base + SEC_CONTROL_REG);
 }
 
 static void sec_open_sva_prefetch(struct hisi_qm *qm)
@@ -429,9 +418,7 @@ static int sec_engine_init(struct hisi_qm *qm)
 		       qm->io_base + SEC_BD_ERR_CHK_EN_REG3);
 
 	/* config endian */
-	reg = readl_relaxed(qm->io_base + SEC_CONTROL_REG);
-	reg |= sec_get_endian(qm);
-	writel_relaxed(reg, qm->io_base + SEC_CONTROL_REG);
+	sec_set_endian(qm);
 
 	return 0;
 }
-- 
2.7.4

