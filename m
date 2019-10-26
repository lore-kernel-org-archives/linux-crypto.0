Return-Path: <SRS0=2cET=YT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6F2BCA9EA0
	for <linux-crypto@archiver.kernel.org>; Sat, 26 Oct 2019 03:01:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 767EC21655
	for <linux-crypto@archiver.kernel.org>; Sat, 26 Oct 2019 03:01:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbfJZDB2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Oct 2019 23:01:28 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:33558 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725957AbfJZDB2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Oct 2019 23:01:28 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 505A5BCBC53AA533256D;
        Sat, 26 Oct 2019 11:01:25 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Sat, 26 Oct 2019 11:01:18 +0800
From:   Zhou Wang <wangzhou1@hisilicon.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, Zhou Wang <wangzhou1@hisilicon.com>
Subject: [PATCH] crypto: hisilicon - use sgl API to get sgl dma addr and len
Date:   Sat, 26 Oct 2019 10:57:21 +0800
Message-ID: <1572058641-173376-1-git-send-email-wangzhou1@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use sgl API to get sgl dma addr and len, this will help to avoid compile
error in some platforms. So NEED_SG_DMA_LENGTH can be removed here, which
can only be selected by arch code.

Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/hisilicon/Kconfig | 1 -
 drivers/crypto/hisilicon/sgl.c   | 4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/hisilicon/Kconfig b/drivers/crypto/hisilicon/Kconfig
index a71f2bf..82fb810d 100644
--- a/drivers/crypto/hisilicon/Kconfig
+++ b/drivers/crypto/hisilicon/Kconfig
@@ -18,7 +18,6 @@ config CRYPTO_DEV_HISI_QM
 	tristate
 	depends on ARM64 || COMPILE_TEST
 	depends on PCI && PCI_MSI
-	select NEED_SG_DMA_LENGTH
 	help
 	  HiSilicon accelerator engines use a common queue management
 	  interface. Specific engine driver may use this module.
diff --git a/drivers/crypto/hisilicon/sgl.c b/drivers/crypto/hisilicon/sgl.c
index bf72603..012023c 100644
--- a/drivers/crypto/hisilicon/sgl.c
+++ b/drivers/crypto/hisilicon/sgl.c
@@ -164,8 +164,8 @@ static struct hisi_acc_hw_sgl *acc_get_sgl(struct hisi_acc_sgl_pool *pool,
 static void sg_map_to_hw_sg(struct scatterlist *sgl,
 			    struct acc_hw_sge *hw_sge)
 {
-	hw_sge->buf = sgl->dma_address;
-	hw_sge->len = cpu_to_le32(sgl->dma_length);
+	hw_sge->buf = sg_dma_address(sgl);
+	hw_sge->len = cpu_to_le32(sg_dma_len(sgl));
 }
 
 static void inc_hw_sgl_sge(struct hisi_acc_hw_sgl *hw_sgl)
-- 
2.8.1

