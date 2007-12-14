From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/3] [CRYPTO] api: Show async type
Date: Fri, 14 Dec 2007 22:46:32 +0800
Message-ID: <E1J3Bo8-0004wF-00@gondolin.me.apana.org.au>
References: <20071214144317.GA18890@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4864 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751186AbXLNOqh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Dec 2007 09:46:37 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J3Bo9-000586-JY
	for <linux-crypto@vger.kernel.org>; Sat, 15 Dec 2007 01:46:34 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] api: Show async type

This patch adds an async field to /proc/crypto for ablkcipher and aead
algorithms.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ablkcipher.c |    4 ++++
 crypto/aead.c       |    4 ++++
 2 files changed, 8 insertions(+)

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index ca08290..83cfed7 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -109,6 +109,8 @@ static void crypto_ablkcipher_show(struct seq_file *m, struct crypto_alg *alg)
 	struct ablkcipher_alg *ablkcipher = &alg->cra_ablkcipher;
 
 	seq_printf(m, "type         : ablkcipher\n");
+	seq_printf(m, "async        : %s\n", alg->cra_flags & CRYPTO_ALG_ASYNC ?
+					     "yes" : "no");
 	seq_printf(m, "blocksize    : %u\n", alg->cra_blocksize);
 	seq_printf(m, "min keysize  : %u\n", ablkcipher->min_keysize);
 	seq_printf(m, "max keysize  : %u\n", ablkcipher->max_keysize);
@@ -158,6 +160,8 @@ static void crypto_givcipher_show(struct seq_file *m, struct crypto_alg *alg)
 	struct ablkcipher_alg *ablkcipher = &alg->cra_ablkcipher;
 
 	seq_printf(m, "type         : givcipher\n");
+	seq_printf(m, "async        : %s\n", alg->cra_flags & CRYPTO_ALG_ASYNC ?
+					     "yes" : "no");
 	seq_printf(m, "blocksize    : %u\n", alg->cra_blocksize);
 	seq_printf(m, "min keysize  : %u\n", ablkcipher->min_keysize);
 	seq_printf(m, "max keysize  : %u\n", ablkcipher->max_keysize);
diff --git a/crypto/aead.c b/crypto/aead.c
index 2bf039b..c43fa81 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -115,6 +115,8 @@ static void crypto_aead_show(struct seq_file *m, struct crypto_alg *alg)
 	struct aead_alg *aead = &alg->cra_aead;
 
 	seq_printf(m, "type         : aead\n");
+	seq_printf(m, "async        : %s\n", alg->cra_flags & CRYPTO_ALG_ASYNC ?
+					     "yes" : "no");
 	seq_printf(m, "blocksize    : %u\n", alg->cra_blocksize);
 	seq_printf(m, "ivsize       : %u\n", aead->ivsize);
 	seq_printf(m, "maxauthsize  : %u\n", aead->maxauthsize);
@@ -169,6 +171,8 @@ static void crypto_nivaead_show(struct seq_file *m, struct crypto_alg *alg)
 	struct aead_alg *aead = &alg->cra_aead;
 
 	seq_printf(m, "type         : nivaead\n");
+	seq_printf(m, "async        : %s\n", alg->cra_flags & CRYPTO_ALG_ASYNC ?
+					     "yes" : "no");
 	seq_printf(m, "blocksize    : %u\n", alg->cra_blocksize);
 	seq_printf(m, "ivsize       : %u\n", aead->ivsize);
 	seq_printf(m, "maxauthsize  : %u\n", aead->maxauthsize);
