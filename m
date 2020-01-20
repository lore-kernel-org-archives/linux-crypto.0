Return-Path: <SRS0=QLPS=3J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B63C4C3F68F
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jan 2020 07:30:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E8DB207E0
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jan 2020 07:30:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgATHaU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Jan 2020 02:30:20 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:42988 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726148AbgATHaU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Jan 2020 02:30:20 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C643B1FAA91938B1C091;
        Mon, 20 Jan 2020 15:30:17 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Mon, 20 Jan 2020 15:30:12 +0800
From:   Shukun Tan <tanshukun1@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [PATCH 2/4] crypto: hisilicon: Configure zip RAS error type
Date:   Mon, 20 Jan 2020 15:30:07 +0800
Message-ID: <1579505409-3776-3-git-send-email-tanshukun1@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1579505409-3776-1-git-send-email-tanshukun1@huawei.com>
References: <1579505409-3776-1-git-send-email-tanshukun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Configure zip RAS error type in error handle initialization,
Where ECC 1bit is configured as CE error, others are NFE.

Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/zip/zip_main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 4f60b93..ec2408e 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -64,6 +64,10 @@
 #define HZIP_CORE_INT_STATUS		0x3010AC
 #define HZIP_CORE_INT_STATUS_M_ECC	BIT(1)
 #define HZIP_CORE_SRAM_ECC_ERR_INFO	0x301148
+#define HZIP_CORE_INT_RAS_CE_ENB	0x301160
+#define HZIP_CORE_INT_RAS_NFE_ENB	0x301164
+#define HZIP_CORE_INT_RAS_FE_ENB        0x301168
+#define HZIP_CORE_INT_RAS_NFE_ENABLE	0x7FE
 #define SRAM_ECC_ERR_NUM_SHIFT		16
 #define SRAM_ECC_ERR_ADDR_SHIFT		24
 #define HZIP_CORE_INT_MASK_ALL		GENMASK(10, 0)
@@ -378,6 +382,12 @@ static void hisi_zip_hw_error_enable(struct hisi_qm *qm)
 	/* clear ZIP hw error source if having */
 	writel(HZIP_CORE_INT_MASK_ALL, qm->io_base + HZIP_CORE_INT_SOURCE);
 
+	/* configure error type */
+	writel(0x1, qm->io_base + HZIP_CORE_INT_RAS_CE_ENB);
+	writel(0x0, qm->io_base + HZIP_CORE_INT_RAS_FE_ENB);
+	writel(HZIP_CORE_INT_RAS_NFE_ENABLE,
+		qm->io_base + HZIP_CORE_INT_RAS_NFE_ENB);
+
 	/* enable ZIP hw error interrupts */
 	writel(0, qm->io_base + HZIP_CORE_INT_MASK_REG);
 }
-- 
2.7.4

