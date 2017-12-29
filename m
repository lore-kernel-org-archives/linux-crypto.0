From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 1/3] crypto: poly1305 - use unaligned access macros to output digest
Date: Fri, 29 Dec 2017 10:10:24 -0600
Message-ID: <20171229161026.28102-2-ebiggers3@gmail.com>
References: <20171229161026.28102-1-ebiggers3@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Martin Willi <martin@strongswan.org>,
        Eric Biggers <ebiggers@google.com>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:45995 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751246AbdL2QM7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Dec 2017 11:12:59 -0500
Received: by mail-it0-f66.google.com with SMTP id z6so31440614iti.4
        for <linux-crypto@vger.kernel.org>; Fri, 29 Dec 2017 08:12:58 -0800 (PST)
In-Reply-To: <20171229161026.28102-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Currently the only part of poly1305-generic which is assuming special
alignment is the part where the final digest is written.  Switch this
over to the unaligned access macros so that we'll be able to remove the
cra_alignmask.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/poly1305_generic.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/crypto/poly1305_generic.c b/crypto/poly1305_generic.c
index b1c2d57dc734..d752901ba0bc 100644
--- a/crypto/poly1305_generic.c
+++ b/crypto/poly1305_generic.c
@@ -210,7 +210,6 @@ EXPORT_SYMBOL_GPL(crypto_poly1305_update);
 int crypto_poly1305_final(struct shash_desc *desc, u8 *dst)
 {
 	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
-	__le32 *mac = (__le32 *)dst;
 	u32 h0, h1, h2, h3, h4;
 	u32 g0, g1, g2, g3, g4;
 	u32 mask;
@@ -267,10 +266,10 @@ int crypto_poly1305_final(struct shash_desc *desc, u8 *dst)
 	h3 = (h3 >> 18) | (h4 <<  8);
 
 	/* mac = (h + s) % (2^128) */
-	f = (f >> 32) + h0 + dctx->s[0]; mac[0] = cpu_to_le32(f);
-	f = (f >> 32) + h1 + dctx->s[1]; mac[1] = cpu_to_le32(f);
-	f = (f >> 32) + h2 + dctx->s[2]; mac[2] = cpu_to_le32(f);
-	f = (f >> 32) + h3 + dctx->s[3]; mac[3] = cpu_to_le32(f);
+	f = (f >> 32) + h0 + dctx->s[0]; put_unaligned_le32(f, dst +  0);
+	f = (f >> 32) + h1 + dctx->s[1]; put_unaligned_le32(f, dst +  4);
+	f = (f >> 32) + h2 + dctx->s[2]; put_unaligned_le32(f, dst +  8);
+	f = (f >> 32) + h3 + dctx->s[3]; put_unaligned_le32(f, dst + 12);
 
 	return 0;
 }
-- 
2.15.1
