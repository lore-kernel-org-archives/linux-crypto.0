From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 17/30] crypto: user - Remove crypto_lookup_skcipher call
Date: Tue, 12 Jul 2016 13:17:49 +0800
Message-ID: <E1bMq4r-0007SR-FA@gondolin.me.apana.org.au>
References: <20160712051554.GA28324@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51504 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932566AbcGLFRw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jul 2016 01:17:52 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1bMq4r-0004dX-Jc
	for <linux-crypto@vger.kernel.org>; Tue, 12 Jul 2016 15:17:49 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

As there are no more kernel users of built-in IV generators we
can remove the special lookup for skciphers.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/crypto_user.c |   37 +------------------------------------
 1 file changed, 1 insertion(+), 36 deletions(-)

diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index d28513fb..c24a40c 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -378,32 +378,6 @@ drop_alg:
 	return err;
 }
 
-static struct crypto_alg *crypto_user_skcipher_alg(const char *name, u32 type,
-						   u32 mask)
-{
-	int err;
-	struct crypto_alg *alg;
-
-	type = crypto_skcipher_type(type);
-	mask = crypto_skcipher_mask(mask);
-
-	for (;;) {
-		alg = crypto_lookup_skcipher(name,  type, mask);
-		if (!IS_ERR(alg))
-			return alg;
-
-		err = PTR_ERR(alg);
-		if (err != -EAGAIN)
-			break;
-		if (fatal_signal_pending(current)) {
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
@@ -436,16 +410,7 @@ static int crypto_add_alg(struct sk_buff *skb, struct nlmsghdr *nlh,
 	else
 		name = p->cru_name;
 
-	switch (p->cru_type & p->cru_mask & CRYPTO_ALG_TYPE_MASK) {
-	case CRYPTO_ALG_TYPE_GIVCIPHER:
-	case CRYPTO_ALG_TYPE_BLKCIPHER:
-	case CRYPTO_ALG_TYPE_ABLKCIPHER:
-		alg = crypto_user_skcipher_alg(name, p->cru_type, p->cru_mask);
-		break;
-	default:
-		alg = crypto_alg_mod_lookup(name, p->cru_type, p->cru_mask);
-	}
-
+	alg = crypto_alg_mod_lookup(name, p->cru_type, p->cru_mask);
 	if (IS_ERR(alg))
 		return PTR_ERR(alg);
 
