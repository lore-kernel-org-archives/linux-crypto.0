From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/8] [CRYPTO] aead/skcipher: Fix larval leak
Date: Mon, 17 Dec 2007 18:31:15 +0800
Message-ID: <E1J4DFj-00038w-00@gondolin.me.apana.org.au>
References: <20071217103037.GA11988@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4834 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760077AbXLQKbS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Dec 2007 05:31:18 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J4DFk-0008VF-CE
	for <linux-crypto@vger.kernel.org>; Mon, 17 Dec 2007 21:31:16 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] aead/skcipher: Fix larval leak

When we get a non-larval from crypto_larval_lookup we need to drop its
reference count before leaving the default geniv construction.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ablkcipher.c |    5 +++--
 crypto/aead.c       |    5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index 83cfed7..3bcb099 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -209,7 +209,7 @@ static int crypto_givcipher_default(struct crypto_alg *alg, u32 type, u32 mask)
 
 	err = -EAGAIN;
 	if (!crypto_is_larval(larval))
-		goto out;
+		goto drop_larval;
 
 	ptype.attr.rta_len = sizeof(ptype);
 	ptype.attr.rta_type = CRYPTOA_TYPE;
@@ -256,8 +256,9 @@ static int crypto_givcipher_default(struct crypto_alg *alg, u32 type, u32 mask)
 put_tmpl:
 	crypto_tmpl_put(tmpl);
 kill_larval:
-	crypto_mod_put(larval);
 	crypto_larval_kill(larval);
+drop_larval:
+	crypto_mod_put(larval);
 out:
 	crypto_mod_put(alg);
 	return err;
diff --git a/crypto/aead.c b/crypto/aead.c
index 77694ad..058ca74 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -359,7 +359,7 @@ static int crypto_nivaead_default(struct crypto_alg *alg, u32 type, u32 mask)
 
 	err = -EAGAIN;
 	if (!crypto_is_larval(larval))
-		goto out;
+		goto drop_larval;
 
 	ptype.attr.rta_len = sizeof(ptype);
 	ptype.attr.rta_type = CRYPTOA_TYPE;
@@ -399,8 +399,9 @@ static int crypto_nivaead_default(struct crypto_alg *alg, u32 type, u32 mask)
 put_tmpl:
 	crypto_tmpl_put(tmpl);
 kill_larval:
-	crypto_mod_put(larval);
 	crypto_larval_kill(larval);
+drop_larval:
+	crypto_mod_put(larval);
 out:
 	crypto_mod_put(alg);
 	return err;
