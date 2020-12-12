Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3171C4361B
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Dec 2020 10:03:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D14120684
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Dec 2020 10:03:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438557AbgLLKD0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 12 Dec 2020 05:03:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:58844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730250AbgLLJy1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 12 Dec 2020 04:54:27 -0500
From:   Ard Biesheuvel <ardb@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/4] crypto: x86/gcm-aes-ni - clean up mapping of associated data
Date:   Sat, 12 Dec 2020 10:16:59 +0100
Message-Id: <20201212091700.11776-4-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201212091700.11776-1-ardb@kernel.org>
References: <20201212091700.11776-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The gcm(aes-ni) driver is only built for x86_64, which does not make
use of highmem. So testing for PageHighMem is pointless and can be
omitted.

While at it, replace GFP_ATOMIC with the appropriate runtime decided
value based on the context.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/aesni-intel_glue.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 063cf579a8fc..e5c4d0cce828 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -760,14 +760,15 @@ static int gcmaes_crypt_by_sg(bool enc, struct aead_request *req,
 		gcm_tfm = &aesni_gcm_tfm_sse;
 
 	/* Linearize assoc, if not already linear */
-	if (req->src->length >= assoclen && req->src->length &&
-		(!PageHighMem(sg_page(req->src)) ||
-			req->src->offset + req->src->length <= PAGE_SIZE)) {
+	if (req->src->length >= assoclen && req->src->length) {
 		scatterwalk_start(&assoc_sg_walk, req->src);
 		assoc = scatterwalk_map(&assoc_sg_walk);
 	} else {
+		gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP)
+			      ? GFP_KERNEL : GFP_ATOMIC;
+
 		/* assoc can be any length, so must be on heap */
-		assocmem = kmalloc(assoclen, GFP_ATOMIC);
+		assocmem = kmalloc(assoclen, flags);
 		if (unlikely(!assocmem))
 			return -ENOMEM;
 		assoc = assocmem;
-- 
2.17.1

