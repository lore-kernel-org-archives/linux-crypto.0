From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/8] [CRYPTO] aead: Fix mask in crypto_alloc_aead
Date: Mon, 17 Dec 2007 18:31:14 +0800
Message-ID: <E1J4DFi-00038p-00@gondolin.me.apana.org.au>
References: <20071217103037.GA11988@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4832 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760238AbXLQKbU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Dec 2007 05:31:20 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J4DFj-0008VB-9d
	for <linux-crypto@vger.kernel.org>; Mon, 17 Dec 2007 21:31:15 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] aead: Fix mask in crypto_alloc_aead

There is a silly typo in crypto_alloc_aead and crypto_grab_aead where
we set the GENIV bit in the mask when we were supposed to clear it
instead.  This broke the construction of AEAD geniv wrappers.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/aead.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index 4a62ea7..77694ad 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -429,7 +429,8 @@ int crypto_grab_aead(struct crypto_aead_spawn *spawn, const char *name,
 
 	type &= ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV);
 	type |= CRYPTO_ALG_TYPE_AEAD;
-	mask |= CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV;
+	mask &= ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV);
+	mask |= CRYPTO_ALG_TYPE_MASK;
 
 	alg = crypto_lookup_aead(name, type, mask);
 	if (IS_ERR(alg))
@@ -448,7 +449,8 @@ struct crypto_aead *crypto_alloc_aead(const char *alg_name, u32 type, u32 mask)
 
 	type &= ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV);
 	type |= CRYPTO_ALG_TYPE_AEAD;
-	mask |= CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV;
+	mask &= ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV);
+	mask |= CRYPTO_ALG_TYPE_MASK;
 
 	for (;;) {
 		struct crypto_alg *alg;
