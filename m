Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 317A8C433ED
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Apr 2021 07:19:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 083826115B
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Apr 2021 07:19:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbhDHHTX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Apr 2021 03:19:23 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:16038 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhDHHTX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Apr 2021 03:19:23 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FGCHC6DwfzPnwx;
        Thu,  8 Apr 2021 15:16:23 +0800 (CST)
Received: from huawei.com (10.175.113.32) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.498.0; Thu, 8 Apr 2021
 15:19:04 +0800
From:   Shixin Liu <liushixin2@huawei.com>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        "Jernej Skrabec" <jernej.skrabec@siol.net>
CC:     <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-sunxi@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        Shixin Liu <liushixin2@huawei.com>
Subject: [PATCH -next 1/7] crypto: sun4i-ss - Fix PM reference leak when pm_runtime_get_sync() fails
Date:   Thu, 8 Apr 2021 15:18:31 +0800
Message-ID: <20210408071831.836638-1-liushixin2@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.32]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

pm_runtime_get_sync will increment pm usage counter even it failed.
Forgetting to putting operation will result in reference leak here.
Fix it by replacing it with pm_runtime_resume_and_get to keep usage
counter balanced.

Signed-off-by: Shixin Liu <liushixin2@huawei.com>
---
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c | 2 +-
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c   | 2 +-
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c   | 2 +-
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-prng.c   | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
index c2e6f5ed1d79..dec79fa3ebaf 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
@@ -561,7 +561,7 @@ int sun4i_ss_cipher_init(struct crypto_tfm *tfm)
 				    sizeof(struct sun4i_cipher_req_ctx) +
 				    crypto_skcipher_reqsize(op->fallback_tfm));
 
-	err = pm_runtime_get_sync(op->ss->dev);
+	err = pm_runtime_resume_and_get(op->ss->dev);
 	if (err < 0)
 		goto error_pm;
 
diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
index ef224d5e4903..44b8fc4b786d 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
@@ -454,7 +454,7 @@ static int sun4i_ss_probe(struct platform_device *pdev)
 	 * this info could be useful
 	 */
 
-	err = pm_runtime_get_sync(ss->dev);
+	err = pm_runtime_resume_and_get(ss->dev);
 	if (err < 0)
 		goto error_pm;
 
diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c
index c1b4585e9bbc..d28292762b32 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c
@@ -27,7 +27,7 @@ int sun4i_hash_crainit(struct crypto_tfm *tfm)
 	algt = container_of(alg, struct sun4i_ss_alg_template, alg.hash);
 	op->ss = algt->ss;
 
-	err = pm_runtime_get_sync(op->ss->dev);
+	err = pm_runtime_resume_and_get(op->ss->dev);
 	if (err < 0)
 		return err;
 
diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-prng.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-prng.c
index 443160a114bb..491fcb7b81b4 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-prng.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-prng.c
@@ -29,7 +29,7 @@ int sun4i_ss_prng_generate(struct crypto_rng *tfm, const u8 *src,
 	algt = container_of(alg, struct sun4i_ss_alg_template, alg.rng);
 	ss = algt->ss;
 
-	err = pm_runtime_get_sync(ss->dev);
+	err = pm_runtime_resume_and_get(ss->dev);
 	if (err < 0)
 		return err;
 
-- 
2.25.1

