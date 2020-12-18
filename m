Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FF60C3526B
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Dec 2020 17:04:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7229723B74
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Dec 2020 17:04:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732072AbgLRRDw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Dec 2020 12:03:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:54272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725797AbgLRRDw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Dec 2020 12:03:52 -0500
From:   Ard Biesheuvel <ardb@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Dave Martin <dave.martin@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: [RFC PATCH 2/5] crypto: skcipher - disallow en/decrypt for non-task or non-softirq context
Date:   Fri, 18 Dec 2020 18:01:03 +0100
Message-Id: <20201218170106.23280-3-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201218170106.23280-1-ardb@kernel.org>
References: <20201218170106.23280-1-ardb@kernel.org>
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
index b4dae640de9f..d1a656d7d498 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -628,6 +628,11 @@ int crypto_skcipher_encrypt(struct skcipher_request *req)
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
@@ -645,6 +650,11 @@ int crypto_skcipher_decrypt(struct skcipher_request *req)
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
2.17.1

