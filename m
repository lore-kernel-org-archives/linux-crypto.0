Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C29C5C433E6
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Feb 2021 07:14:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7496464E32
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Feb 2021 07:14:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbhBWHNi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Feb 2021 02:13:38 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12989 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231800AbhBWHNb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Feb 2021 02:13:31 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Dl9FV1MC6zjQt2;
        Tue, 23 Feb 2021 15:11:10 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Tue, 23 Feb 2021 15:12:34 +0800
From:   Meng Yu <yumeng18@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <tudor.ambarus@microchip.com>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <yumeng18@huawei.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v9 6/7] crypto: add curve25519 params and expose them
Date:   Tue, 23 Feb 2021 15:10:18 +0800
Message-ID: <1614064219-40701-7-git-send-email-yumeng18@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1614064219-40701-1-git-send-email-yumeng18@huawei.com>
References: <1614064219-40701-1-git-send-email-yumeng18@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

1. Add curve 25519 parameters in 'crypto/ecc_curve_defs.h';
2. Add curve25519 interface 'ecc_get_curve25519_param' in
   'include/crypto/ecc_curve.h', to make its parameters be
   exposed to everyone in kernel tree.

Signed-off-by: Meng Yu <yumeng18@huawei.com>
Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
---
 crypto/ecc.c               |  6 ++++++
 crypto/ecc_curve_defs.h    | 17 +++++++++++++++++
 include/crypto/ecc_curve.h |  7 +++++++
 3 files changed, 30 insertions(+)

diff --git a/crypto/ecc.c b/crypto/ecc.c
index 4b55ad0..0798a18 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -43,6 +43,12 @@ typedef struct {
 	u64 m_high;
 } uint128_t;
 
+/* Returns curv25519 curve param */
+const struct ecc_curve *ecc_get_curve25519(void)
+{
+	return &ecc_25519;
+}
+EXPORT_SYMBOL(ecc_get_curve25519);
 
 const struct ecc_curve *ecc_get_curve(unsigned int curve_id)
 {
diff --git a/crypto/ecc_curve_defs.h b/crypto/ecc_curve_defs.h
index 69be6c7..d7769cc 100644
--- a/crypto/ecc_curve_defs.h
+++ b/crypto/ecc_curve_defs.h
@@ -54,4 +54,21 @@ static struct ecc_curve nist_p256 = {
 	.b = nist_p256_b
 };
 
+/* curve25519 */
+static u64 curve25519_g_x[] = { 0x0000000000000009, 0x0000000000000000,
+				0x0000000000000000, 0x0000000000000000 };
+static u64 curve25519_p[] = { 0xffffffffffffffed, 0xffffffffffffffff,
+				0xffffffffffffffff, 0x7fffffffffffffff };
+static u64 curve25519_a[] = { 0x000000000001DB41, 0x0000000000000000,
+				0x0000000000000000, 0x0000000000000000 };
+static const struct ecc_curve ecc_25519 = {
+	.name = "curve25519",
+	.g = {
+		.x = curve25519_g_x,
+		.ndigits = 4,
+	},
+	.p = curve25519_p,
+	.a = curve25519_a,
+};
+
 #endif
diff --git a/include/crypto/ecc_curve.h b/include/crypto/ecc_curve.h
index 19a35da..7096478 100644
--- a/include/crypto/ecc_curve.h
+++ b/include/crypto/ecc_curve.h
@@ -50,4 +50,11 @@ struct ecc_curve {
  */
 const struct ecc_curve *ecc_get_curve(unsigned int curve_id);
 
+/**
+ * ecc_get_curve25519() - get curve25519 curve;
+ *
+ * Returns curve25519
+ */
+const struct ecc_curve *ecc_get_curve25519(void);
+
 #endif
-- 
2.8.1

