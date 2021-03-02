Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5ABFC433E6
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Mar 2021 01:42:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 977F464E6C
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Mar 2021 01:42:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233782AbhCCB3P (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Mar 2021 20:29:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:40152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378877AbhCBJFT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Mar 2021 04:05:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6313164F0A;
        Tue,  2 Mar 2021 09:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614675734;
        bh=hPANTmY35Q8IL90zLscr8PTsutAG+9jAP5fhAb6fKD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uk0aQH+XVslNq9sIKyuOuDq4BacGU/fMunrjVXQbV6SZPl/gKh/+PVO4K+DtExBpE
         3mrfhT+RDcsn093HejAsN25Fm2VVW4zBxI+Qg2N+dH90Gknkg0FCPqqIWCebT0kNLr
         v/hU/XBF8AA1F9e9RHeUx5oBZhUF2pE+WG2IheShgqm/NqaSjpMWbezTjjMWusdLYh
         an8gud7XtXHNpt9DXQPO+gE8OqgQn4Ddfv3rw/FfxD9ay+s2znSDt8K8NrYR8HJIcJ
         Ymskzh9FAgfTaDE3dqiTeyyLY+9TEs9tv63AdqVUsj8acOJGFq/JClTpVddLL3wb0U
         ID/P71MDxksLw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
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
        Ingo Molnar <mingo@kernel.org>,
        Andy Lutomirski <luto@kernel.org>
Subject: [PATCH v2 4/9] crypto: aead - disallow en/decrypt for non-task or non-softirq context
Date:   Tue,  2 Mar 2021 10:01:13 +0100
Message-Id: <20210302090118.30666-5-ardb@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302090118.30666-1-ardb@kernel.org>
References: <20210302090118.30666-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In order to ensure that kernel mode SIMD routines will not need a scalar
fallback if they run with softirqs disabled, disallow any use of the
AEAD encrypt and decrypt routines from outside of task or softirq context.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/aead.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/crypto/aead.c b/crypto/aead.c
index 16991095270d..b5304b3d3314 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -87,6 +87,11 @@ int crypto_aead_encrypt(struct aead_request *req)
 	unsigned int cryptlen = req->cryptlen;
 	int ret;
 
+	if (!(alg->cra_flags & CRYPTO_ALG_ASYNC) &&
+	    WARN_ONCE(!in_task() && !in_serving_softirq(),
+		      "synchronous call from invalid context\n"))
+		return -EBUSY;
+
 	crypto_stats_get(alg);
 	if (crypto_aead_get_flags(aead) & CRYPTO_TFM_NEED_KEY)
 		ret = -ENOKEY;
@@ -104,6 +109,11 @@ int crypto_aead_decrypt(struct aead_request *req)
 	unsigned int cryptlen = req->cryptlen;
 	int ret;
 
+	if (!(alg->cra_flags & CRYPTO_ALG_ASYNC) &&
+	    WARN_ONCE(!in_task() && !in_serving_softirq(),
+		      "synchronous call from invalid context\n"))
+		return -EBUSY;
+
 	crypto_stats_get(alg);
 	if (crypto_aead_get_flags(aead) & CRYPTO_TFM_NEED_KEY)
 		ret = -ENOKEY;
-- 
2.30.1

