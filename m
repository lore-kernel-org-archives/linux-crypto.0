Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1544CC433ED
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Apr 2021 09:47:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B13DE613A0
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Apr 2021 09:47:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350276AbhDGJrZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Apr 2021 05:47:25 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15942 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350270AbhDGJrZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Apr 2021 05:47:25 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FFfdC22jJzyN2J;
        Wed,  7 Apr 2021 17:45:03 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Wed, 7 Apr 2021 17:47:06 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>,
        <liulongfang@huawei.com>
Subject: [PATCH] crypto: hisilicon/trng - add version to adapt new algorithm
Date:   Wed, 7 Apr 2021 17:44:33 +0800
Message-ID: <1617788673-47222-1-git-send-email-qianweili@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Kunpeng930 supports trng and prng, but Kunpeng920 only supports trng.

Therefore, version information is added to ensure that prng is not
registered to Crypto subsystem on Kunpeng920.

Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/trng/trng.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/hisilicon/trng/trng.c b/drivers/crypto/hisilicon/trng/trng.c
index 2971268..829f2ca 100644
--- a/drivers/crypto/hisilicon/trng/trng.c
+++ b/drivers/crypto/hisilicon/trng/trng.c
@@ -18,6 +18,8 @@
 #define HISI_TRNG_REG		0x00F0
 #define HISI_TRNG_BYTES		4
 #define HISI_TRNG_QUALITY	512
+#define HISI_TRNG_VERSION	0x01B8
+#define HISI_TRNG_VER_V1	GENMASK(31, 0)
 #define SLEEP_US		10
 #define TIMEOUT_US		10000
 #define SW_DRBG_NUM_SHIFT	2
@@ -50,6 +52,7 @@ struct hisi_trng {
 	struct hisi_trng_list *trng_list;
 	struct list_head list;
 	struct hwrng rng;
+	u32 ver;
 	bool is_used;
 	struct mutex mutex;
 };
@@ -260,6 +263,7 @@ static int hisi_trng_probe(struct platform_device *pdev)
 		return PTR_ERR(trng->base);
 
 	trng->is_used = false;
+	trng->ver = readl(trng->base + HISI_TRNG_VERSION);
 	if (!trng_devices.is_init) {
 		INIT_LIST_HEAD(&trng_devices.list);
 		mutex_init(&trng_devices.lock);
@@ -267,7 +271,8 @@ static int hisi_trng_probe(struct platform_device *pdev)
 	}
 
 	hisi_trng_add_to_list(trng);
-	if (atomic_inc_return(&trng_active_devs) == 1) {
+	if (trng->ver != HISI_TRNG_VER_V1 &&
+	    atomic_inc_return(&trng_active_devs) == 1) {
 		ret = crypto_register_rng(&hisi_trng_alg);
 		if (ret) {
 			dev_err(&pdev->dev,
@@ -289,7 +294,8 @@ static int hisi_trng_probe(struct platform_device *pdev)
 	return ret;
 
 err_crypto_unregister:
-	if (atomic_dec_return(&trng_active_devs) == 0)
+	if (trng->ver != HISI_TRNG_VER_V1 &&
+	    atomic_dec_return(&trng_active_devs) == 0)
 		crypto_unregister_rng(&hisi_trng_alg);
 
 err_remove_from_list:
@@ -305,7 +311,8 @@ static int hisi_trng_remove(struct platform_device *pdev)
 	while (hisi_trng_del_from_list(trng))
 		;
 
-	if (atomic_dec_return(&trng_active_devs) == 0)
+	if (trng->ver != HISI_TRNG_VER_V1 &&
+	    atomic_dec_return(&trng_active_devs) == 0)
 		crypto_unregister_rng(&hisi_trng_alg);
 
 	return 0;
-- 
2.8.1

