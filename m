Return-Path: <SRS0=HYoH=NT=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55118 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726915AbeKIIdI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Nov 2018 03:33:08 -0500
Received: by mail-wm1-f68.google.com with SMTP id r63-v6so298399wma.4
        for <linux-crypto@vger.kernel.org>; Thu, 08 Nov 2018 14:55:22 -0800 (PST)
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, cai@gmx.us,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] crypto/simd: correctly take reqsize of wrapped skcipher into account
Date: Thu,  8 Nov 2018 23:55:16 +0100
Message-Id: <20181108225516.9967-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The simd wrapper's skcipher request context structure consists
of a single subrequest whose size is taken from the subordinate
skcipher. However, in simd_skcipher_init(), the reqsize that is
retrieved is not from the subordinate skcipher but from the
cryptd request structure, whose size is completely unrelated to
the actual wrapped skcipher.

Reported-by: Qian Cai <cai@gmx.us>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/simd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/simd.c b/crypto/simd.c
index ea7240be3001..2f3d6e897afc 100644
--- a/crypto/simd.c
+++ b/crypto/simd.c
@@ -125,7 +125,7 @@ static int simd_skcipher_init(struct crypto_skcipher *tfm)
 	ctx->cryptd_tfm = cryptd_tfm;
 
 	reqsize = sizeof(struct skcipher_request);
-	reqsize += crypto_skcipher_reqsize(&cryptd_tfm->base);
+	reqsize += crypto_skcipher_reqsize(cryptd_skcipher_child(cryptd_tfm));
 
 	crypto_skcipher_set_reqsize(tfm, reqsize);
 
-- 
2.19.1
