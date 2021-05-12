Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3847FC43460
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 21:08:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E781461434
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 21:08:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234466AbhELVHz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 May 2021 17:07:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245234AbhELSqO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 May 2021 14:46:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 504286141C;
        Wed, 12 May 2021 18:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620845090;
        bh=isWmI38USeF4NjdMkoUIY8ZmRIz+cWLvwEpazjfnYh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XZEm9yTT3ICvLwUoBNGxZGZS9t+cp+ZGmnNwEPUPmavpwQqIZirSnL90Q4RKx2Nqs
         fnl5Hd30euD37o9wmeOQVTy4E4Cbi83pdff4SGSydHpPUV75yTpNTDqMUpaOlU4uwL
         QwCrLRDikY5sDJ5OSs2hK6u/iINNmEHepHlNb0NP04BJhg/f5u392RPq87HTmT1etB
         bn2nKRwL3mpxbP830Z8cfJi3xwqu/VJRfj7gSaBz58zMF0GIlt7cEfKP5z+iDTkJ7k
         5IfDQr3AGqX6rD6R8lAK808ET6MLqlt1JGI1onFRBkoJZbTo8lRXx5aAjUs7JTv4Np
         JSXDaaP4noP9w==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, ebiggers@kernel.org,
        herbert@gondor.apana.org.au, will@kernel.org,
        kernel-team@android.com, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH v3 2/7] crypto: aead - disallow en/decrypt for non-task or non-softirq context
Date:   Wed, 12 May 2021 20:44:34 +0200
Message-Id: <20210512184439.8778-3-ardb@kernel.org>
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
2.20.1

