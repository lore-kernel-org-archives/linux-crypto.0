From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/11] [CRYPTO] ablkcipher: Add givcrypt operation and givcipher type
Date: Thu, 22 Nov 2007 16:48:39 +0800
Message-ID: <E1Iv7jj-0001zw-00@gondolin.me.apana.org.au>
References: <20071122084758.GA7536@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4659 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751260AbXKVIso (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Nov 2007 03:48:44 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1Iv7jj-0008Bj-ME
	for <linux-crypto@vger.kernel.org>; Thu, 22 Nov 2007 19:48:39 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[CRYPTO] ablkcipher: Add givcrypt operation and givcipher type

Different block cipher modes have different requirements for intialisation
vectors.  For example, CBC can use a simple randomly generated IV while
modes such as CTR must use an IV generation mechanisms that give a stronger
guarantee on the lack of collisions.  Furthermore, disk encryption modes
have their own IV generation algorithms.

Up until now IV generation has been left to the users of the block cipher
API.  This is inconvenient as the number of block cipher modes increase
because the user needs to be aware of which mode is supposed tobe paired
with which IV generation algorithm.

Therefore it makes sense to integrate the IV generation into the crypto API.
This patch takes the first step in that direction by creating a new ablkcipher
operation, givcrypt that generates an IV before performing the actual
encryption.

It also creates the underlying givcipher type.  Algorithms that directly
generate IVs would use it instead of ablkcipher.  All other algorithms
(including all existing ones) would gain a givcipher algorithm upon
registration.  This givcipher algorithm will be constructed from the geniv
string that's stored in every algorithm.  That string will locate a template
which is instantiated by the blkcipher/ablkcipher algorithm in question to
give a givcipher algorithm.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ablkcipher.c     |   41 +++++++++++++++++++++++++++++++++++++++++
 crypto/blkcipher.c      |    1 +
 include/crypto/algapi.h |    1 +
 include/linux/crypto.h  |   24 ++++++++++++++++++++++++
 4 files changed, 67 insertions(+)

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index 2731acb..85e7875 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -94,6 +94,7 @@ static void crypto_ablkcipher_show(struct seq_file *m, struct crypto_alg *alg)
 	seq_printf(m, "min keysize  : %u\n", ablkcipher->min_keysize);
 	seq_printf(m, "max keysize  : %u\n", ablkcipher->max_keysize);
 	seq_printf(m, "ivsize       : %u\n", ablkcipher->ivsize);
+	seq_printf(m, "geniv        : %s\n", ablkcipher->geniv);
 }
 
 const struct crypto_type crypto_ablkcipher_type = {
@@ -105,5 +106,45 @@ const struct crypto_type crypto_ablkcipher_type = {
 };
 EXPORT_SYMBOL_GPL(crypto_ablkcipher_type);
 
+static int crypto_init_givcipher_ops(struct crypto_tfm *tfm, u32 type,
+				      u32 mask)
+{
+	struct ablkcipher_alg *alg = &tfm->__crt_alg->cra_ablkcipher;
+	struct ablkcipher_tfm *crt = &tfm->crt_ablkcipher;
+
+	if (alg->ivsize > PAGE_SIZE / 8)
+		return -EINVAL;
+
+	crt->setkey = setkey;
+	crt->encrypt = alg->encrypt;
+	crt->givcrypt = alg->givcrypt;
+	crt->decrypt = alg->decrypt;
+	crt->ivsize = alg->ivsize;
+
+	return 0;
+}
+
+static void crypto_givcipher_show(struct seq_file *m, struct crypto_alg *alg)
+	__attribute__ ((unused));
+static void crypto_givcipher_show(struct seq_file *m, struct crypto_alg *alg)
+{
+	struct ablkcipher_alg *ablkcipher = &alg->cra_ablkcipher;
+
+	seq_printf(m, "type         : givcipher\n");
+	seq_printf(m, "blocksize    : %u\n", alg->cra_blocksize);
+	seq_printf(m, "min keysize  : %u\n", ablkcipher->min_keysize);
+	seq_printf(m, "max keysize  : %u\n", ablkcipher->max_keysize);
+	seq_printf(m, "ivsize       : %u\n", ablkcipher->ivsize);
+}
+
+const struct crypto_type crypto_givcipher_type = {
+	.ctxsize = crypto_ablkcipher_ctxsize,
+	.init = crypto_init_givcipher_ops,
+#ifdef CONFIG_PROC_FS
+	.show = crypto_givcipher_show,
+#endif
+};
+EXPORT_SYMBOL_GPL(crypto_givcipher_type);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Asynchronous block chaining cipher type");
diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index 180d914..75c3ab9 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -496,6 +496,7 @@ static void crypto_blkcipher_show(struct seq_file *m, struct crypto_alg *alg)
 	seq_printf(m, "min keysize  : %u\n", alg->cra_blkcipher.min_keysize);
 	seq_printf(m, "max keysize  : %u\n", alg->cra_blkcipher.max_keysize);
 	seq_printf(m, "ivsize       : %u\n", alg->cra_blkcipher.ivsize);
+	seq_printf(m, "geniv        : %s\n", alg->cra_blkcipher.geniv);
 }
 
 const struct crypto_type crypto_blkcipher_type = {
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 2cdb227..7f71c41 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -95,6 +95,7 @@ struct blkcipher_walk {
 };
 
 extern const struct crypto_type crypto_ablkcipher_type;
+extern const struct crypto_type crypto_givcipher_type;
 extern const struct crypto_type crypto_aead_type;
 extern const struct crypto_type crypto_blkcipher_type;
 extern const struct crypto_type crypto_hash_type;
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index f56ae87..95e99f4 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -34,6 +34,7 @@
 #define CRYPTO_ALG_TYPE_HASH		0x00000003
 #define CRYPTO_ALG_TYPE_BLKCIPHER	0x00000004
 #define CRYPTO_ALG_TYPE_ABLKCIPHER	0x00000005
+#define CRYPTO_ALG_TYPE_GIVCIPHER	0x00000006
 #define CRYPTO_ALG_TYPE_COMPRESS	0x00000008
 #define CRYPTO_ALG_TYPE_AEAD		0x00000009
 
@@ -116,6 +117,9 @@ struct ablkcipher_request {
 
 	unsigned int nbytes;
 
+	u64 seq;
+	u8 *giv;
+
 	void *info;
 
 	struct scatterlist *src;
@@ -177,11 +181,14 @@ struct ablkcipher_alg {
 	int (*setkey)(struct crypto_ablkcipher *tfm, const u8 *key,
 	              unsigned int keylen);
 	int (*encrypt)(struct ablkcipher_request *req);
+	int (*givcrypt)(struct ablkcipher_request *req);
 	int (*decrypt)(struct ablkcipher_request *req);
 
 	unsigned int min_keysize;
 	unsigned int max_keysize;
 	unsigned int ivsize;
+
+	char geniv[CRYPTO_MAX_ALG_NAME];
 };
 
 struct aead_alg {
@@ -207,6 +214,8 @@ struct blkcipher_alg {
 	unsigned int min_keysize;
 	unsigned int max_keysize;
 	unsigned int ivsize;
+
+	char geniv[CRYPTO_MAX_ALG_NAME];
 };
 
 struct cipher_alg {
@@ -318,6 +327,7 @@ struct ablkcipher_tfm {
 	int (*setkey)(struct crypto_ablkcipher *tfm, const u8 *key,
 	              unsigned int keylen);
 	int (*encrypt)(struct ablkcipher_request *req);
+	int (*givcrypt)(struct ablkcipher_request *req);
 	int (*decrypt)(struct ablkcipher_request *req);
 	unsigned int ivsize;
 	unsigned int reqsize;
@@ -619,6 +629,13 @@ static inline int crypto_ablkcipher_encrypt(struct ablkcipher_request *req)
 	return crt->encrypt(req);
 }
 
+static inline int crypto_ablkcipher_givcrypt(struct ablkcipher_request *req)
+{
+	struct ablkcipher_tfm *crt =
+		crypto_ablkcipher_crt(crypto_ablkcipher_reqtfm(req));
+	return crt->givcrypt(req);
+}
+
 static inline int crypto_ablkcipher_decrypt(struct ablkcipher_request *req)
 {
 	struct ablkcipher_tfm *crt =
@@ -683,6 +700,13 @@ static inline void ablkcipher_request_set_crypt(
 	req->info = iv;
 }
 
+static inline void ablkcipher_request_set_giv(struct ablkcipher_request *req,
+					      u8 *giv, u64 seq)
+{
+	req->giv = giv;
+	req->seq = seq;
+}
+
 static inline struct crypto_aead *__crypto_aead_cast(struct crypto_tfm *tfm)
 {
 	return (struct crypto_aead *)tfm;
