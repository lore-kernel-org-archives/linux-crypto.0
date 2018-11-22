Return-Path: <SRS0=unN5=OB=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438433AbeKWGeN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Nov 2018 01:34:13 -0500
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 14/36] crypto: simd - correctly take reqsize of wrapped skcipher into account
Date: Thu, 22 Nov 2018 14:52:18 -0500
Message-Id: <20181122195240.13123-14-sashal@kernel.org>
In-Reply-To: <20181122195240.13123-1-sashal@kernel.org>
References: <20181122195240.13123-1-sashal@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

[ Upstream commit 508a1c4df085a547187eed346f1bfe5e381797f1 ]

The simd wrapper's skcipher request context structure consists
of a single subrequest whose size is taken from the subordinate
skcipher. However, in simd_skcipher_init(), the reqsize that is
retrieved is not from the subordinate skcipher but from the
cryptd request structure, whose size is completely unrelated to
the actual wrapped skcipher.

Reported-by: Qian Cai <cai@gmx.us>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Tested-by: Qian Cai <cai@gmx.us>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/simd.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/crypto/simd.c b/crypto/simd.c
index ea7240be3001..78e8d037ae2b 100644
--- a/crypto/simd.c
+++ b/crypto/simd.c
@@ -124,8 +124,9 @@ static int simd_skcipher_init(struct crypto_skcipher *tfm)
 
 	ctx->cryptd_tfm = cryptd_tfm;
 
-	reqsize = sizeof(struct skcipher_request);
-	reqsize += crypto_skcipher_reqsize(&cryptd_tfm->base);
+	reqsize = crypto_skcipher_reqsize(cryptd_skcipher_child(cryptd_tfm));
+	reqsize = max(reqsize, crypto_skcipher_reqsize(&cryptd_tfm->base));
+	reqsize += sizeof(struct skcipher_request);
 
 	crypto_skcipher_set_reqsize(tfm, reqsize);
 
-- 
2.17.1
