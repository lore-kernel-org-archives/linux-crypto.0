From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 2/3] crypto: poly1305 - remove cra_alignmask
Date: Fri, 29 Dec 2017 10:10:25 -0600
Message-ID: <20171229161026.28102-3-ebiggers3@gmail.com>
References: <20171229161026.28102-1-ebiggers3@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Martin Willi <martin@strongswan.org>,
        Eric Biggers <ebiggers@google.com>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:40427 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751246AbdL2QNA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Dec 2017 11:13:00 -0500
Received: by mail-it0-f68.google.com with SMTP id f190so32001234ita.5
        for <linux-crypto@vger.kernel.org>; Fri, 29 Dec 2017 08:13:00 -0800 (PST)
In-Reply-To: <20171229161026.28102-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Now that nothing in poly1305-generic assumes any special alignment,
remove the cra_alignmask so that the crypto API does not have to
unnecessarily align the buffers.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/poly1305_generic.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/crypto/poly1305_generic.c b/crypto/poly1305_generic.c
index d752901ba0bc..d92617aeb783 100644
--- a/crypto/poly1305_generic.c
+++ b/crypto/poly1305_generic.c
@@ -287,7 +287,6 @@ static struct shash_alg poly1305_alg = {
 		.cra_driver_name	= "poly1305-generic",
 		.cra_priority		= 100,
 		.cra_flags		= CRYPTO_ALG_TYPE_SHASH,
-		.cra_alignmask		= sizeof(u32) - 1,
 		.cra_blocksize		= POLY1305_BLOCK_SIZE,
 		.cra_module		= THIS_MODULE,
 	},
-- 
2.15.1
