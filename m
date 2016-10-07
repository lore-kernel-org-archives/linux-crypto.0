From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH] crypto: skcipher - Remove unused crypto_lookup_skcipher() declaration
Date: Fri,  7 Oct 2016 14:13:34 -0700
Message-ID: <1475874815-136813-1-git-send-email-ebiggers@google.com>
Cc: linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:34622 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933081AbcJGVOf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Oct 2016 17:14:35 -0400
Received: by mail-pf0-f172.google.com with SMTP id e6so28599158pfk.1
        for <linux-crypto@vger.kernel.org>; Fri, 07 Oct 2016 14:14:34 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The definition of crypto_lookup_skcipher() was already removed in
commit 3a01d0ee2b99 ("crypto: skcipher - Remove top-level givcipher
interface").  So the declaration should be removed too.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/crypto/internal/skcipher.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index a21a95e..95d2a18 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -74,8 +74,6 @@ static inline int crypto_grab_skcipher2(struct crypto_skcipher_spawn *spawn,
 	return crypto_grab_skcipher(spawn, name, type, mask);
 }
 
-struct crypto_alg *crypto_lookup_skcipher(const char *name, u32 type, u32 mask);
-
 static inline void crypto_drop_skcipher(struct crypto_skcipher_spawn *spawn)
 {
 	crypto_drop_spawn(&spawn->base);
-- 
2.8.0.rc3.226.g39d4020
