Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CB8DC433DB
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Mar 2021 01:42:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0645564E62
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Mar 2021 01:42:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236363AbhCCB2Q (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Mar 2021 20:28:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:40154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378876AbhCBJFT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Mar 2021 04:05:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6129864DE4;
        Tue,  2 Mar 2021 09:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614675738;
        bh=/9iGZlMSTBpH3pvYK2XMp6jTFluRmMTYaBwnJWdiW6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JvdwB42Dh4PttZChpfMeQrxV9Kh6YQrGHN1qnIGTdznaDavl+WUI1TGzTQNvOiSoK
         PkR8b4PKCs8Q6nXjeD2gP+FGsSdjSGWhhRMBB5XZQMRY+APDE/LMumpf7WvrXyFQI6
         xRReGhHxgoify9QeDpjd4X/aKQTe3bFj14Q22Ik9Z+MUzFHTOu1BicysbTdPVVco34
         5mQ5HFUhyAPNpQK+y0rXPaiYI6aq1UlQzhVLrBDurg2VecZIlHOIPrdqYaKwqI2oR8
         OFfmLT9H5hc4O3arH/iRkzfjMovkVqbs7+RKQjvcAqJ7rXH8Vilc8WphlJZjRv1it7
         RqDGiLBep8amg==
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
Subject: [PATCH v2 5/9] crypto: skcipher - disallow en/decrypt for non-task or non-softirq context
Date:   Tue,  2 Mar 2021 10:01:14 +0100
Message-Id: <20210302090118.30666-6-ardb@kernel.org>
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
skcipher encrypt and decrypt routines from outside of task or softirq
context.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/skcipher.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index a15376245416..d1a2ba6eacbe 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -623,6 +623,11 @@ int crypto_skcipher_encrypt(struct skcipher_request *req)
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
@@ -640,6 +645,11 @@ int crypto_skcipher_decrypt(struct skcipher_request *req)
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
2.30.1

