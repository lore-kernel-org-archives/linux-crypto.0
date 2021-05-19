Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92E11C433ED
	for <linux-crypto@archiver.kernel.org>; Wed, 19 May 2021 11:23:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F5E36135F
	for <linux-crypto@archiver.kernel.org>; Wed, 19 May 2021 11:23:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350133AbhESLYQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 May 2021 07:24:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:52858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350260AbhESLYJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 May 2021 07:24:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7118611BF;
        Wed, 19 May 2021 11:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621423370;
        bh=813vbDqlVp4TbHnw89ag9TrBuAfoPXQrAusOPwlb2rU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Brw1T6XE0yCFB5iVo+miBtWO8wz4UmajA8EcKnQkX+4YMT4KaR5x1w+u/43HZmBTY
         R5Lr+tI0o0GiEDOIV5/LeSboXD//qyI8cJMBUzwu+qisa5jWp6j04X66NfJfEXP9kQ
         jQUZ7EcX9TZzF2cBGylXEux4s8q2cFeIAjz2eLjbkZAouhtv9h4Q/v6k0gwOtq36xy
         61NSvBJqQwaL0SUj2MdS/dDY3hGApJtK8OBBOmoRxIEvzTY5lkzchfsj85cN+XtKQw
         W/95vEJof393JQGZ0wNnOB7OhIAB2oH/36Iou+gUO6y6fjOwx6QC08XACLAeDV3ksS
         +K1NdC5y82KCg==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, ebiggers@kernel.org,
        herbert@gondor.apana.org.au, will@kernel.org,
        kernel-team@android.com, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH v4 3/7] crypto: skcipher - disallow en/decrypt for non-task or non-softirq context
Date:   Wed, 19 May 2021 13:22:35 +0200
Message-Id: <20210519112239.33664-4-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210519112239.33664-1-ardb@kernel.org>
References: <20210519112239.33664-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In order to ensure that kernel mode SIMD routines will not need a scalar
fallback if they run with softirqs disabled, disallow any use of the
skcipher encrypt and decrypt routines from outside of task or softirq
context.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/skcipher.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index ed2deb031742..f69492aab75d 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -628,7 +628,11 @@ int crypto_skcipher_encrypt(struct skcipher_request *req)
 	int ret;
 
 	crypto_stats_get(alg);
-	if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
+	if (!(alg->cra_flags & CRYPTO_ALG_ASYNC) &&
+	    WARN_ONCE(!in_task() && !in_serving_softirq(),
+		      "synchronous call from invalid context\n"))
+		ret = -EBUSY;
+	else if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		ret = -ENOKEY;
 	else
 		ret = crypto_skcipher_alg(tfm)->encrypt(req);
@@ -645,7 +649,11 @@ int crypto_skcipher_decrypt(struct skcipher_request *req)
 	int ret;
 
 	crypto_stats_get(alg);
-	if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
+	if (!(alg->cra_flags & CRYPTO_ALG_ASYNC) &&
+	    WARN_ONCE(!in_task() && !in_serving_softirq(),
+		      "synchronous call from invalid context\n"))
+		ret = -EBUSY;
+	else if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		ret = -ENOKEY;
 	else
 		ret = crypto_skcipher_alg(tfm)->decrypt(req);
-- 
2.20.1

