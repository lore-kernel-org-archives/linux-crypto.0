Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DC7DC43461
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 06:30:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC8BD61942
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 06:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbhELGbc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 May 2021 02:31:32 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2789 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbhELGb2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 May 2021 02:31:28 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Fg4ZS3HztzmgKn;
        Wed, 12 May 2021 14:26:56 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Wed, 12 May 2021 14:30:09 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/8] crypto: hisilicon/hpre - init a structure member each line
Date:   Wed, 12 May 2021 14:27:05 +0800
Message-ID: <1620800831-53346-3-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1620800831-53346-1-git-send-email-tanghui20@huawei.com>
References: <1620800831-53346-1-git-send-email-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
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

