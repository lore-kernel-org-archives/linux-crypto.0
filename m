From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 3/3] crypto: x86/poly1305 - remove cra_alignmask
Date: Fri, 29 Dec 2017 10:10:26 -0600
Message-ID: <20171229161026.28102-4-ebiggers3@gmail.com>
References: <20171229161026.28102-1-ebiggers3@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Martin Willi <martin@strongswan.org>,
        Eric Biggers <ebiggers@google.com>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:41364 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751381AbdL2QNC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Dec 2017 11:13:02 -0500
Received: by mail-io0-f196.google.com with SMTP id f6so5250151ioh.8
        for <linux-crypto@vger.kernel.org>; Fri, 29 Dec 2017 08:13:01 -0800 (PST)
In-Reply-To: <20171229161026.28102-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

crypto_poly1305_final() no longer requires a cra_alignmask, and nothing
else in the x86 poly1305-simd implementation does either.  So remove the
cra_alignmask so that the crypto API does not have to unnecessarily
align the buffers.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/poly1305_glue.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/crypto/poly1305_glue.c b/arch/x86/crypto/poly1305_glue.c
index e32142bc071d..f58f89b05a7f 100644
--- a/arch/x86/crypto/poly1305_glue.c
+++ b/arch/x86/crypto/poly1305_glue.c
@@ -171,7 +171,6 @@ static struct shash_alg alg = {
 		.cra_driver_name	= "poly1305-simd",
 		.cra_priority		= 300,
 		.cra_flags		= CRYPTO_ALG_TYPE_SHASH,
-		.cra_alignmask		= sizeof(u32) - 1,
 		.cra_blocksize		= POLY1305_BLOCK_SIZE,
 		.cra_module		= THIS_MODULE,
 	},
-- 
2.15.1
