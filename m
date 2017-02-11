From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/2] crypto: ccm - drop unnecessary minimum 32-bit alignment
Date: Sat, 11 Feb 2017 19:25:22 +0000
Message-ID: <1486841122-1686-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1486841122-1686-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:34626 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750989AbdBKTZg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Feb 2017 14:25:36 -0500
Received: by mail-wr0-f173.google.com with SMTP id o16so128697624wra.1
        for <linux-crypto@vger.kernel.org>; Sat, 11 Feb 2017 11:25:36 -0800 (PST)
In-Reply-To: <1486841122-1686-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The CCM driver forces 32-bit alignment even if the underlying ciphers
don't care about alignment. This is because crypto_xor() used to require
this, but since this is no longer the case, drop the hardcoded minimum
of 32 bits.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/ccm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/crypto/ccm.c b/crypto/ccm.c
index 24c26ab052ca..442848807a52 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -525,8 +525,7 @@ static int crypto_ccm_create_common(struct crypto_template *tmpl,
 				       ctr->base.cra_priority) / 2;
 	inst->alg.base.cra_blocksize = 1;
 	inst->alg.base.cra_alignmask = mac->base.cra_alignmask |
-				       ctr->base.cra_alignmask |
-				       (__alignof__(u32) - 1);
+				       ctr->base.cra_alignmask;
 	inst->alg.ivsize = 16;
 	inst->alg.chunksize = crypto_skcipher_alg_chunksize(ctr);
 	inst->alg.maxauthsize = 16;
-- 
2.7.4
