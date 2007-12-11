From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/19] [CRYPTO] skcipher: Added geniv field
Date: Tue, 11 Dec 2007 12:02:54 +0800
Message-ID: <E1J1wKc-0002jW-00@gondolin.me.apana.org.au>
References: <20071211040215.GA10360@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1907 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751874AbXLKEC5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Dec 2007 23:02:57 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J1wKc-000629-Of
	for <linux-crypto@vger.kernel.org>; Tue, 11 Dec 2007 15:02:54 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] skcipher: Added geniv field

This patch introduces the geniv field which indicates the default IV
generator for each algorithm.  It should point to a string that is not
freed as long as the algorithm is registered.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ablkcipher.c    |    2 ++
 crypto/blkcipher.c     |    2 ++
 include/linux/crypto.h |    4 ++++
 3 files changed, 8 insertions(+)

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index d957ba2..66e3922 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -94,6 +94,7 @@ static void crypto_ablkcipher_show(struct seq_file *m, struct crypto_alg *alg)
 	seq_printf(m, "min keysize  : %u\n", ablkcipher->min_keysize);
 	seq_printf(m, "max keysize  : %u\n", ablkcipher->max_keysize);
 	seq_printf(m, "ivsize       : %u\n", ablkcipher->ivsize);
+	seq_printf(m, "geniv        : %s\n", ablkcipher->geniv ?: "<default>");
 }
 
 const struct crypto_type crypto_ablkcipher_type = {
@@ -140,6 +141,7 @@ static void crypto_givcipher_show(struct seq_file *m, struct crypto_alg *alg)
 	seq_printf(m, "min keysize  : %u\n", ablkcipher->min_keysize);
 	seq_printf(m, "max keysize  : %u\n", ablkcipher->max_keysize);
 	seq_printf(m, "ivsize       : %u\n", ablkcipher->ivsize);
+	seq_printf(m, "geniv        : %s\n", ablkcipher->geniv ?: "<built-in>");
 }
 
 const struct crypto_type crypto_givcipher_type = {
diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index 7939504..7a3e1a3 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -496,6 +496,8 @@ static void crypto_blkcipher_show(struct seq_file *m, struct crypto_alg *alg)
 	seq_printf(m, "min keysize  : %u\n", alg->cra_blkcipher.min_keysize);
 	seq_printf(m, "max keysize  : %u\n", alg->cra_blkcipher.max_keysize);
 	seq_printf(m, "ivsize       : %u\n", alg->cra_blkcipher.ivsize);
+	seq_printf(m, "geniv        : %s\n", alg->cra_blkcipher.geniv ?:
+					     "<default>");
 }
 
 const struct crypto_type crypto_blkcipher_type = {
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index d3012cd..5462711 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -183,6 +183,8 @@ struct ablkcipher_alg {
 	int (*givencrypt)(struct skcipher_givcrypt_request *req);
 	int (*givdecrypt)(struct skcipher_givcrypt_request *req);
 
+	const char *geniv;
+
 	unsigned int min_keysize;
 	unsigned int max_keysize;
 	unsigned int ivsize;
@@ -209,6 +211,8 @@ struct blkcipher_alg {
 		       struct scatterlist *dst, struct scatterlist *src,
 		       unsigned int nbytes);
 
+	const char *geniv;
+
 	unsigned int min_keysize;
 	unsigned int max_keysize;
 	unsigned int ivsize;
