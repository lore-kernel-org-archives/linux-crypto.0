Return-Path: <SRS0=WlNz=3A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 780D1C3F68F
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Jan 2020 09:02:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 583E320842
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Jan 2020 09:02:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728027AbgAKJCO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 11 Jan 2020 04:02:14 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8697 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728417AbgAKJCO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Jan 2020 04:02:14 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id DEBE2DB374B07D05D707;
        Sat, 11 Jan 2020 17:02:11 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.439.0; Sat, 11 Jan 2020 17:02:04 +0800
From:   Zaibo Xu <xuzaibo@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linuxarm@huawei.com>,
        <jonathan.cameron@huawei.com>, <wangzhou1@hisilicon.com>,
        <tanghui20@huawei.com>, <yekai13@huawei.com>,
        <liulongfang@huawei.com>, <qianweili@huawei.com>,
        <fanghao11@huawei.com>, <forest.zhouchang@huawei.com>
Subject: [PATCH 1/4] crypto: hisilicon - Bugfixed tfm leak
Date:   Sat, 11 Jan 2020 16:58:15 +0800
Message-ID: <1578733098-13863-2-git-send-email-xuzaibo@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1578733098-13863-1-git-send-email-xuzaibo@huawei.com>
References: <1578733098-13863-1-git-send-email-xuzaibo@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

1.Fixed the bug of software tfm leakage.
2.Update HW error log message.

Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c |  7 ++++++-
 drivers/crypto/hisilicon/hpre/hpre_main.c   | 24 ++++++++++++------------
 2 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 98f037e..d8b0152 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -1043,6 +1043,7 @@ static unsigned int hpre_rsa_max_size(struct crypto_akcipher *tfm)
 static int hpre_rsa_init_tfm(struct crypto_akcipher *tfm)
 {
 	struct hpre_ctx *ctx = akcipher_tfm_ctx(tfm);
+	int ret;
 
 	ctx->rsa.soft_tfm = crypto_alloc_akcipher("rsa-generic", 0, 0);
 	if (IS_ERR(ctx->rsa.soft_tfm)) {
@@ -1050,7 +1051,11 @@ static int hpre_rsa_init_tfm(struct crypto_akcipher *tfm)
 		return PTR_ERR(ctx->rsa.soft_tfm);
 	}
 
-	return hpre_ctx_init(ctx);
+	ret = hpre_ctx_init(ctx);
+	if (ret)
+		crypto_free_akcipher(ctx->rsa.soft_tfm);
+
+	return ret;
 }
 
 static void hpre_rsa_exit_tfm(struct crypto_akcipher *tfm)
diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 711f5d1..753e43d 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -106,18 +106,18 @@ static const char * const hpre_debug_file_name[] = {
 };
 
 static const struct hpre_hw_error hpre_hw_errors[] = {
-	{ .int_msk = BIT(0), .msg = "hpre_ecc_1bitt_err" },
-	{ .int_msk = BIT(1), .msg = "hpre_ecc_2bit_err" },
-	{ .int_msk = BIT(2), .msg = "hpre_data_wr_err" },
-	{ .int_msk = BIT(3), .msg = "hpre_data_rd_err" },
-	{ .int_msk = BIT(4), .msg = "hpre_bd_rd_err" },
-	{ .int_msk = BIT(5), .msg = "hpre_ooo_2bit_ecc_err" },
-	{ .int_msk = BIT(6), .msg = "hpre_cltr1_htbt_tm_out_err" },
-	{ .int_msk = BIT(7), .msg = "hpre_cltr2_htbt_tm_out_err" },
-	{ .int_msk = BIT(8), .msg = "hpre_cltr3_htbt_tm_out_err" },
-	{ .int_msk = BIT(9), .msg = "hpre_cltr4_htbt_tm_out_err" },
-	{ .int_msk = GENMASK(15, 10), .msg = "hpre_ooo_rdrsp_err" },
-	{ .int_msk = GENMASK(21, 16), .msg = "hpre_ooo_wrrsp_err" },
+	{ .int_msk = BIT(0), .msg = "core_ecc_1bit_err_int_set" },
+	{ .int_msk = BIT(1), .msg = "core_ecc_2bit_err_int_set" },
+	{ .int_msk = BIT(2), .msg = "dat_wb_poison_int_set" },
+	{ .int_msk = BIT(3), .msg = "dat_rd_poison_int_set" },
+	{ .int_msk = BIT(4), .msg = "bd_rd_poison_int_set" },
+	{ .int_msk = BIT(5), .msg = "ooo_ecc_2bit_err_int_set" },
+	{ .int_msk = BIT(6), .msg = "cluster1_shb_timeout_int_set" },
+	{ .int_msk = BIT(7), .msg = "cluster2_shb_timeout_int_set" },
+	{ .int_msk = BIT(8), .msg = "cluster3_shb_timeout_int_set" },
+	{ .int_msk = BIT(9), .msg = "cluster4_shb_timeout_int_set" },
+	{ .int_msk = GENMASK(15, 10), .msg = "ooo_rdrsp_err_int_set" },
+	{ .int_msk = GENMASK(21, 16), .msg = "ooo_wrrsp_err_int_set" },
 	{ /* sentinel */ }
 };
 
-- 
2.8.1

