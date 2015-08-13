From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/13] crypto: user - Remove crypto_lookup_aead call
Date: Thu, 13 Aug 2015 17:28:50 +0800
Message-ID: <E1ZPooc-0005oo-PQ@gondolin.me.apana.org.au>
References: <20150813092520.GA22268@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33236 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbbHMJ2y (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Aug 2015 05:28:54 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1ZPood-00035V-9b
	for <linux-crypto@vger.kernel.org>; Thu, 13 Aug 2015 19:28:51 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

As IV generators are now standalone AEAD transforms, we no longer
need to use the crypto_lookup_aead call.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/crypto_user.c |   32 --------------------------------
 1 file changed, 32 deletions(-)

diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index 08ea286..d94d99f 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -25,7 +25,6 @@
 #include <net/netlink.h>
 #include <linux/security.h>
 #include <net/net_namespace.h>
-#include <crypto/internal/aead.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/internal/rng.h>
 #include <crypto/akcipher.h>
@@ -385,34 +384,6 @@ static struct crypto_alg *crypto_user_skcipher_alg(const char *name, u32 type,
 	return ERR_PTR(err);
 }
 
-static struct crypto_alg *crypto_user_aead_alg(const char *name, u32 type,
-					       u32 mask)
-{
-	int err;
-	struct crypto_alg *alg;
-
-	type &= ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV);
-	type |= CRYPTO_ALG_TYPE_AEAD;
-	mask &= ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV);
-	mask |= CRYPTO_ALG_TYPE_MASK;
-
-	for (;;) {
-		alg = crypto_lookup_aead(name,  type, mask);
-		if (!IS_ERR(alg))
-			return alg;
-
-		err = PTR_ERR(alg);
-		if (err != -EAGAIN)
-			break;
-		if (signal_pending(current)) {
-			err = -EINTR;
-			break;
-		}
-	}
-
-	return ERR_PTR(err);
-}
-
 static int crypto_add_alg(struct sk_buff *skb, struct nlmsghdr *nlh,
 			  struct nlattr **attrs)
 {
@@ -446,9 +417,6 @@ static int crypto_add_alg(struct sk_buff *skb, struct nlmsghdr *nlh,
 		name = p->cru_name;
 
 	switch (p->cru_type & p->cru_mask & CRYPTO_ALG_TYPE_MASK) {
-	case CRYPTO_ALG_TYPE_AEAD:
-		alg = crypto_user_aead_alg(name, p->cru_type, p->cru_mask);
-		break;
 	case CRYPTO_ALG_TYPE_GIVCIPHER:
 	case CRYPTO_ALG_TYPE_BLKCIPHER:
 	case CRYPTO_ALG_TYPE_ABLKCIPHER:
