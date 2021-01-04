Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_NONE,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54288C433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 15:56:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20E50207AE
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 15:56:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727442AbhADP4t (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Jan 2021 10:56:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:35926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727317AbhADP4t (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Jan 2021 10:56:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3DBF22473;
        Mon,  4 Jan 2021 15:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609775769;
        bh=ryPdll3V/K/eQdBbjthjbb01fYsd1QLUEUG1k47B+ME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JRby57NITm52dm1soMPK5WeI3TIFQ2wMEixnE7yCjwunCtJJqJWV6Z+xOBCdxD1G0
         +66oddIvZ1h2XOji4L6BQBUD5mlMN/+ZOBQLdCm/W5O21Y3Fyjn/BmQfg0u96oa7pX
         qlspWZNOK4GVAm/8PBRr89mLNK73sXVuJu6XrDFWjJUk7n52DCD7l4gvvx5v8PCwgY
         ODi29G0snOa675d6tkK7vAMACF7RJohlxnOOC8hWvqIhkW4Ss9CE7saLkWv+DhR4pk
         p7xLt22hERpSTuxWgg76gGAhWvrYI0kBGPxe9lLLRVfflpT+ACLClRhzbsKjUZJoNF
         DpWxKP9kFm82A==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, Megha Dey <megha.dey@intel.com>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH v2 3/5] crypto: x86/gcm-aes-ni - clean up mapping of associated data
Date:   Mon,  4 Jan 2021 16:55:48 +0100
Message-Id: <20210104155550.6359-4-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210104155550.6359-1-ardb@kernel.org>
References: <20210104155550.6359-1-ardb@kernel.org>
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
index 0f124d72e6b4..26b012065701 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -667,14 +667,15 @@ static int gcmaes_crypt_by_sg(bool enc, struct aead_request *req,
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

