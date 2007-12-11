From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6/8] [CRYPTO] api: Sanitise mask when allocating ablkcipher/hash
Date: Tue, 11 Dec 2007 11:50:24 +0800
Message-ID: <E1J1w8W-0002ee-00@gondolin.me.apana.org.au>
References: <20071211034945.GA10099@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1778 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751846AbXLKDuc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Dec 2007 22:50:32 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J1w8Y-0005pk-Ll
	for <linux-crypto@vger.kernel.org>; Tue, 11 Dec 2007 14:50:27 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] api: Sanitise mask when allocating ablkcipher/hash

When allocating ablkcipher/hash objects, we use a mask that's wider than
the usual type mask.  This patch sanitises the mask supplied by the user
so we don't end up using a narrower mask which may lead to unintended
results.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/linux/crypto.h |    4 ++++
 1 files changed, 4 insertions(+)

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 48aa595..ef7642e 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -532,6 +532,7 @@ static inline struct crypto_ablkcipher *crypto_alloc_ablkcipher(
 	const char *alg_name, u32 type, u32 mask)
 {
 	type &= ~CRYPTO_ALG_TYPE_MASK;
+	mask &= ~CRYPTO_ALG_TYPE_MASK;
 	type |= CRYPTO_ALG_TYPE_BLKCIPHER;
 	mask |= CRYPTO_ALG_TYPE_BLKCIPHER_MASK;
 
@@ -554,6 +555,7 @@ static inline int crypto_has_ablkcipher(const char *alg_name, u32 type,
 					u32 mask)
 {
 	type &= ~CRYPTO_ALG_TYPE_MASK;
+	mask &= ~CRYPTO_ALG_TYPE_MASK;
 	type |= CRYPTO_ALG_TYPE_BLKCIPHER;
 	mask |= CRYPTO_ALG_TYPE_BLKCIPHER_MASK;
 
@@ -1086,6 +1088,7 @@ static inline struct crypto_hash *crypto_alloc_hash(const char *alg_name,
 						    u32 type, u32 mask)
 {
 	type &= ~CRYPTO_ALG_TYPE_MASK;
+	mask &= ~CRYPTO_ALG_TYPE_MASK;
 	type |= CRYPTO_ALG_TYPE_HASH;
 	mask |= CRYPTO_ALG_TYPE_HASH_MASK;
 
@@ -1105,6 +1108,7 @@ static inline void crypto_free_hash(struct crypto_hash *tfm)
 static inline int crypto_has_hash(const char *alg_name, u32 type, u32 mask)
 {
 	type &= ~CRYPTO_ALG_TYPE_MASK;
+	mask &= ~CRYPTO_ALG_TYPE_MASK;
 	type |= CRYPTO_ALG_TYPE_HASH;
 	mask |= CRYPTO_ALG_TYPE_HASH_MASK;
 
