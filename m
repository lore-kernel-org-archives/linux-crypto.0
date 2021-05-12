Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19CF1C43462
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 21:08:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D75BC61439
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 21:08:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233130AbhELVHv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 May 2021 17:07:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:56230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245259AbhELSqO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 May 2021 14:46:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6572F6142D;
        Wed, 12 May 2021 18:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620845092;
        bh=SmBuw5/my1vcoFAJsK9Niemsp+zYVD3mIjyRu1+S350=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GXHvPcUMlEhYbcijXWwlUHQgce2c9Ib9yTDzmBL4YG7dnOovASp0AjESwfNexi3QE
         USE/L1kR0UTx8lM3Jtp1NXrWqfv6DAsUPxwUpe198I8lhPrPo0nzOk/B1r7J330X3l
         n2WCj86XfHHqndgPDjzSanXjYetPIDpRg3TXSpgvN6OXXRGejRyYvO4//TwOfO0eBO
         NCuO+BD1cVikdBMVEXgaiFI62j0AxqbWu13dOzhtabaj/jPGHQ87oW5Qu89lVkla6a
         FCIWhp2EFhbXAL6LcJTvpT4L80eqrLB6kxzmRQvZLbQM0HhzRrt8aLSHAY6rxARqUl
         /NwdIq++nIMRQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, ebiggers@kernel.org,
        herbert@gondor.apana.org.au, will@kernel.org,
        kernel-team@android.com, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH v3 3/7] crypto: skcipher - disallow en/decrypt for non-task or non-softirq context
Date:   Wed, 12 May 2021 20:44:35 +0200
Message-Id: <20210512184439.8778-4-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210512184439.8778-1-ardb@kernel.org>
References: <20210512184439.8778-1-ardb@kernel.org>
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
 crypto/skcipher.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 93fdacf49697..9bce5350008b 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -625,6 +625,11 @@ int crypto_skcipher_encrypt(struct skcipher_request *req)
 	unsigned int cryptlen = req->cryptlen;
 	int ret;
 
+	if (!(alg->cra_flags & CRYPTO_ALG_ASYNC) &&
+	    WARN_ONCE(!in_task() && !in_serving_softirq(),
+		      "synchronous call from invalid context\n"))
+		return -EBUSY;
+
 	crypto_stats_get(alg);
 	if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		ret = -ENOKEY;
@@ -642,6 +647,11 @@ int crypto_skcipher_decrypt(struct skcipher_request *req)
 	unsigned int cryptlen = req->cryptlen;
 	int ret;
 
+	if (!(alg->cra_flags & CRYPTO_ALG_ASYNC) &&
+	    WARN_ONCE(!in_task() && !in_serving_softirq(),
+		      "synchronous call from invalid context\n"))
+		return -EBUSY;
+
 	crypto_stats_get(alg);
 	if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		ret = -ENOKEY;
-- 
2.20.1

