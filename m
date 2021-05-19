Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03884C43461
	for <linux-crypto@archiver.kernel.org>; Wed, 19 May 2021 11:22:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D18086135F
	for <linux-crypto@archiver.kernel.org>; Wed, 19 May 2021 11:22:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241088AbhESLYO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 May 2021 07:24:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:52828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350132AbhESLYI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 May 2021 07:24:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E1616135F;
        Wed, 19 May 2021 11:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621423368;
        bh=eLg/GSNSaqnJy8ioL9ZrQp36Kv1wIh+t1ziwjtWeq0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YTBW9tRuQbImgmgw59v2K5Fm3MCDjSuQOZvtdYxYSFtz7f/8icRBHiqYkn9ddoYc/
         Qd35YfxLLgremuJZzMdltvKTfxivFo4FsSHou7MNya1roI1jrD6XgrDyppxtrQKOkV
         Cai76pWvXMKb6xNu1ZkI8n72zqyOZbCt6uZ7fgAtba4vSMPEFFOIuKxjcm6BL/Jaai
         xZYsyyszH+AkaCpl6EjtA3IjpEeoxYdyeTjJP4j6O4ISZr7rtRP1sOZLKVdZOfd9dW
         3Z3+KcjoNXsfVgnG3woKlH3sUcwKGaIxDPbUARjjM049tp7wfnQEv18ViY79WZfwxQ
         y7i5fWp0gsaLg==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, ebiggers@kernel.org,
        herbert@gondor.apana.org.au, will@kernel.org,
        kernel-team@android.com, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH v4 2/7] crypto: aead - disallow en/decrypt for non-task or non-softirq context
Date:   Wed, 19 May 2021 13:22:34 +0200
Message-Id: <20210519112239.33664-3-ardb@kernel.org>
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
AEAD encrypt and decrypt routines from outside of task or softirq context.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/aead.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index 16991095270d..141c9369b02a 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -88,7 +88,11 @@ int crypto_aead_encrypt(struct aead_request *req)
 	int ret;
 
 	crypto_stats_get(alg);
-	if (crypto_aead_get_flags(aead) & CRYPTO_TFM_NEED_KEY)
+	if (!(alg->cra_flags & CRYPTO_ALG_ASYNC) &&
+	    WARN_ONCE(!in_task() && !in_serving_softirq(),
+		      "synchronous call from invalid context\n"))
+		ret = -EBUSY;
+	else if (crypto_aead_get_flags(aead) & CRYPTO_TFM_NEED_KEY)
 		ret = -ENOKEY;
 	else
 		ret = crypto_aead_alg(aead)->encrypt(req);
@@ -105,7 +109,11 @@ int crypto_aead_decrypt(struct aead_request *req)
 	int ret;
 
 	crypto_stats_get(alg);
-	if (crypto_aead_get_flags(aead) & CRYPTO_TFM_NEED_KEY)
+	if (!(alg->cra_flags & CRYPTO_ALG_ASYNC) &&
+	    WARN_ONCE(!in_task() && !in_serving_softirq(),
+		      "synchronous call from invalid context\n"))
+		ret = -EBUSY;
+	else if (crypto_aead_get_flags(aead) & CRYPTO_TFM_NEED_KEY)
 		ret = -ENOKEY;
 	else if (req->cryptlen < crypto_aead_authsize(aead))
 		ret = -EINVAL;
-- 
2.20.1

