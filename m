Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A5B5C433B4
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Apr 2021 12:34:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05CC06128A
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Apr 2021 12:34:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241061AbhDLMeq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Apr 2021 08:34:46 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:16575 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239097AbhDLMep (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Apr 2021 08:34:45 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FJp5l16cRz18H3G;
        Mon, 12 Apr 2021 20:32:11 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Mon, 12 Apr 2021 20:34:18 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>,
        <liulongfang@huawei.com>, Weili Qian <qianweili@huawei.com>
Subject: [PATCH 3/4] crypto: hisilicon - add new error type for SEC
Date:   Mon, 12 Apr 2021 20:31:34 +0800
Message-ID: <1618230695-22775-4-git-send-email-qianweili@huawei.com>
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

Kunpeng930 SEC adds several new hardware error types. This patch enables
the new error types and configures the error types as NFE.

Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec_main.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 26b9904..6f0062d 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -42,8 +42,8 @@
 #define SEC_ECC_NUM			16
 #define SEC_ECC_MASH			0xFF
 #define SEC_CORE_INT_DISABLE		0x0
-#define SEC_CORE_INT_ENABLE		0x1ff
-#define SEC_CORE_INT_CLEAR		0x1ff
+#define SEC_CORE_INT_ENABLE		0x7c1ff
+#define SEC_CORE_INT_CLEAR		0x7c1ff
 #define SEC_SAA_ENABLE			0x17f
 
 #define SEC_RAS_CE_REG			0x301050
@@ -51,7 +51,7 @@
 #define SEC_RAS_NFE_REG			0x301058
 #define SEC_RAS_CE_ENB_MSK		0x88
 #define SEC_RAS_FE_ENB_MSK		0x0
-#define SEC_RAS_NFE_ENB_MSK		0x177
+#define SEC_RAS_NFE_ENB_MSK		0x7c177
 #define SEC_RAS_DISABLE		0x0
 #define SEC_MEM_START_INIT_REG	0x301100
 #define SEC_MEM_INIT_DONE_REG		0x301104
@@ -147,6 +147,26 @@ static const struct sec_hw_error sec_hw_errors[] = {
 		.int_msk = BIT(8),
 		.msg = "sec_chain_buff_err_rint"
 	},
+	{
+		.int_msk = BIT(14),
+		.msg = "sec_no_secure_access"
+	},
+	{
+		.int_msk = BIT(15),
+		.msg = "sec_wrapping_key_auth_err"
+	},
+	{
+		.int_msk = BIT(16),
+		.msg = "sec_km_key_crc_fail"
+	},
+	{
+		.int_msk = BIT(17),
+		.msg = "sec_axi_poison_err"
+	},
+	{
+		.int_msk = BIT(18),
+		.msg = "sec_sva_err"
+	},
 	{}
 };
 
-- 
2.8.1

