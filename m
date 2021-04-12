Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 549BBC43461
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Apr 2021 12:34:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B11B6134F
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Apr 2021 12:34:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241066AbhDLMeq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Apr 2021 08:34:46 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:16573 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241051AbhDLMep (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Apr 2021 08:34:45 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FJp5l1KJXz18H3w;
        Mon, 12 Apr 2021 20:32:11 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Mon, 12 Apr 2021 20:34:17 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>,
        <liulongfang@huawei.com>, Weili Qian <qianweili@huawei.com>
Subject: [PATCH 2/4] crypto: hisilicon - support new error types for ZIP
Date:   Mon, 12 Apr 2021 20:31:33 +0800
Message-ID: <1618230695-22775-3-git-send-email-qianweili@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1618230695-22775-1-git-send-email-qianweili@huawei.com>
References: <1618230695-22775-1-git-send-email-qianweili@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Kunpeng930 ZIP adds 'zip_axi_poison_err' 'zip_sva_err' and
'QM_ACC_DO_TASK_TIMEOUT' hardware error types. This patch enables the error
types and configures the error types as NFE.

Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/zip/zip_main.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 50407bb..2178b40 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -68,10 +68,10 @@
 #define HZIP_CORE_INT_RAS_CE_ENABLE	0x1
 #define HZIP_CORE_INT_RAS_NFE_ENB	0x301164
 #define HZIP_CORE_INT_RAS_FE_ENB        0x301168
-#define HZIP_CORE_INT_RAS_NFE_ENABLE	0x7FE
+#define HZIP_CORE_INT_RAS_NFE_ENABLE	0x1FFE
 #define HZIP_SRAM_ECC_ERR_NUM_SHIFT	16
 #define HZIP_SRAM_ECC_ERR_ADDR_SHIFT	24
-#define HZIP_CORE_INT_MASK_ALL		GENMASK(10, 0)
+#define HZIP_CORE_INT_MASK_ALL		GENMASK(12, 0)
 #define HZIP_COMP_CORE_NUM		2
 #define HZIP_DECOMP_CORE_NUM		6
 #define HZIP_CORE_NUM			(HZIP_COMP_CORE_NUM + \
@@ -133,6 +133,8 @@ static const struct hisi_zip_hw_error zip_hw_error[] = {
 	{ .int_msk = BIT(8), .msg = "zip_com_inf_err" },
 	{ .int_msk = BIT(9), .msg = "zip_enc_inf_err" },
 	{ .int_msk = BIT(10), .msg = "zip_pre_out_err" },
+	{ .int_msk = BIT(11), .msg = "zip_axi_poison_err" },
+	{ .int_msk = BIT(12), .msg = "zip_sva_err" },
 	{ /* sentinel */ }
 };
 
@@ -668,6 +670,9 @@ static void hisi_zip_err_info_init(struct hisi_qm *qm)
 	err_info->msi_wr_port = HZIP_WR_PORT;
 	err_info->acpi_rst = "ZRST";
 	err_info->nfe = QM_BASE_NFE | QM_ACC_WB_NOT_READY_TIMEOUT;
+
+	if (qm->ver >= QM_HW_V3)
+		err_info->nfe |= QM_ACC_DO_TASK_TIMEOUT;
 }
 
 static const struct hisi_qm_err_ini hisi_zip_err_ini = {
-- 
2.8.1

