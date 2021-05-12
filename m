Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2DC9C43461
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 03:37:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C344C6147D
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 03:37:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbhELDis (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 May 2021 23:38:48 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2490 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbhELDir (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 May 2021 23:38:47 -0400
Received: from dggeml757-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Fg0mG3618zYdq8;
        Wed, 12 May 2021 11:35:10 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggeml757-chm.china.huawei.com (10.1.199.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 12 May 2021 11:37:38 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 12 May 2021 11:37:38 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/8] crypto: hisilicon/hpre - init a structure member each line
Date:   Wed, 12 May 2021 11:34:25 +0800
Message-ID: <1620790471-16621-3-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1620790471-16621-1-git-send-email-tanghui20@huawei.com>
References: <1620790471-16621-1-git-send-email-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggemi760-chm.china.huawei.com (10.1.198.146)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Only init a structure member each line, just to keep the code neat.

Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 56 +++++++++++++++++++++++--------
 1 file changed, 42 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index c914e00..47a169c 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -122,21 +122,49 @@ static const char * const hpre_debug_file_name[] = {
 };
 
 static const struct hpre_hw_error hpre_hw_errors[] = {
-	{ .int_msk = BIT(0), .msg = "core_ecc_1bit_err_int_set" },
-	{ .int_msk = BIT(1), .msg = "core_ecc_2bit_err_int_set" },
-	{ .int_msk = BIT(2), .msg = "dat_wb_poison_int_set" },
-	{ .int_msk = BIT(3), .msg = "dat_rd_poison_int_set" },
-	{ .int_msk = BIT(4), .msg = "bd_rd_poison_int_set" },
-	{ .int_msk = BIT(5), .msg = "ooo_ecc_2bit_err_int_set" },
-	{ .int_msk = BIT(6), .msg = "cluster1_shb_timeout_int_set" },
-	{ .int_msk = BIT(7), .msg = "cluster2_shb_timeout_int_set" },
-	{ .int_msk = BIT(8), .msg = "cluster3_shb_timeout_int_set" },
-	{ .int_msk = BIT(9), .msg = "cluster4_shb_timeout_int_set" },
-	{ .int_msk = GENMASK(15, 10), .msg = "ooo_rdrsp_err_int_set" },
-	{ .int_msk = GENMASK(21, 16), .msg = "ooo_wrrsp_err_int_set" },
-	{ .int_msk = BIT(22), .msg = "pt_rng_timeout_int_set"},
-	{ .int_msk = BIT(23), .msg = "sva_fsm_timeout_int_set"},
 	{
+		.int_msk = BIT(0),
+		.msg = "core_ecc_1bit_err_int_set"
+	}, {
+		.int_msk = BIT(1),
+		.msg = "core_ecc_2bit_err_int_set"
+	}, {
+		.int_msk = BIT(2),
+		.msg = "dat_wb_poison_int_set"
+	}, {
+		.int_msk = BIT(3),
+		.msg = "dat_rd_poison_int_set"
+	}, {
+		.int_msk = BIT(4),
+		.msg = "bd_rd_poison_int_set"
+	}, {
+		.int_msk = BIT(5),
+		.msg = "ooo_ecc_2bit_err_int_set"
+	}, {
+		.int_msk = BIT(6),
+		.msg = "cluster1_shb_timeout_int_set"
+	}, {
+		.int_msk = BIT(7),
+		.msg = "cluster2_shb_timeout_int_set"
+	}, {
+		.int_msk = BIT(8),
+		.msg = "cluster3_shb_timeout_int_set"
+	}, {
+		.int_msk = BIT(9),
+		.msg = "cluster4_shb_timeout_int_set"
+	}, {
+		.int_msk = GENMASK(15, 10),
+		.msg = "ooo_rdrsp_err_int_set"
+	}, {
+		.int_msk = GENMASK(21, 16),
+		.msg = "ooo_wrrsp_err_int_set"
+	}, {
+		.int_msk = BIT(22),
+		.msg = "pt_rng_timeout_int_set"
+	}, {
+		.int_msk = BIT(23),
+		.msg = "sva_fsm_timeout_int_set"
+	}, {
 		/* sentinel */
 	}
 };
-- 
2.8.1

