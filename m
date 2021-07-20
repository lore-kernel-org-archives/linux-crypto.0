Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C30EC07E9B
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 13:12:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0409D610CC
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 13:12:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236394AbhGTMbx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Jul 2021 08:31:53 -0400
Received: from smtpbg126.qq.com ([106.55.201.22]:26786 "EHLO smtpbg587.qq.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232473AbhGTMba (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jul 2021 08:31:30 -0400
X-Greylist: delayed 506 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Jul 2021 08:31:29 EDT
X-QQ-mid: bizesmtp48t1626786092tzpucwkl
Received: from localhost.localdomain (unknown [125.70.163.19])
        by esmtp6.qq.com (ESMTP) with 
        id ; Tue, 20 Jul 2021 21:01:30 +0800 (CST)
X-QQ-SSF: 0100000000400080B000B00A0000000
X-QQ-FEAT: QiB9IW2pbdELcbxTZh3ALvEfJuv/cKfiB1Sgs9+zAap2LDX7uELg/zrJw7mXo
        LCArt9ZnyYCpMPfPv84aIAqD1PFZcLqJ1pAn7juYQxgZgvNAecBHTMMvZuUMvAjZIxTiwtF
        3v3HeJgZP1hQuec3h1mof2XoCuV849eJ8C08AS+gQ3cCEEcXwcljoQf1kCZvXBWWjHukv6s
        25JZ9nq32sO7m2hswDQUeQE6RMo2MipAFDuKzwyGmkrPSEOTjWwQ1cPPQ9JRgP1bdhspvK4
        mTst0UxBugvg0ubqNmo8v6xk7sLBExUEUU+aP2B8re5w3hfUKLPnC1OOmwyks3cIcI/Q==
X-QQ-GoodBg: 0
From:   Jason Wang <wangborong@cdjrlc.com>
To:     herbert@gondor.apana.org.au
Cc:     clabbe.montjoie@gmail.com, davem@davemloft.net, mripard@kernel.org,
        wens@csie.org, jernej.skrabec@gmail.com, colin.king@canonical.com,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev, linux-kernel@vger.kernel.org,
        Jason Wang <wangborong@cdjrlc.com>
Subject: [PATCH] crypto: sun8i-ss - Use kfree_sensitive
Date:   Tue, 20 Jul 2021 21:01:04 +0800
Message-Id: <20210720130104.42867-1-wangborong@cdjrlc.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam2
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The kfree_sensitive is a kernel API to clear sensitive information
that should not be leaked to other future users of the same memory
objects and free the memory. Its function is the same as the
combination of memzero_explicit and kfree. Thus, we can replace the
combination APIs with the single kfree_sensitive API.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c
index 3191527928e4..246a6782674c 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c
@@ -20,8 +20,7 @@ int sun8i_ss_prng_seed(struct crypto_rng *tfm, const u8 *seed,
 	struct sun8i_ss_rng_tfm_ctx *ctx = crypto_rng_ctx(tfm);
 
 	if (ctx->seed && ctx->slen != slen) {
-		memzero_explicit(ctx->seed, ctx->slen);
-		kfree(ctx->seed);
+		kfree_sensitive(ctx->seed);
 		ctx->slen = 0;
 		ctx->seed = NULL;
 	}
@@ -48,8 +47,7 @@ void sun8i_ss_prng_exit(struct crypto_tfm *tfm)
 {
 	struct sun8i_ss_rng_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	memzero_explicit(ctx->seed, ctx->slen);
-	kfree(ctx->seed);
+	kfree_sensitive(ctx->seed);
 	ctx->seed = NULL;
 	ctx->slen = 0;
 }
@@ -167,9 +165,8 @@ int sun8i_ss_prng_generate(struct crypto_rng *tfm, const u8 *src,
 		/* Update seed */
 		memcpy(ctx->seed, d + dlen, ctx->slen);
 	}
-	memzero_explicit(d, todo);
 err_free:
-	kfree(d);
+	kfree_sensitive(d);
 
 	return err;
 }
-- 
2.32.0

