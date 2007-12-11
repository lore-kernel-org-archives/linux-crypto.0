From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/19] [CRYPTO] skcipher: Add givcrypt operations and givcipher type
Date: Tue, 11 Dec 2007 12:02:53 +0800
Message-ID: <E1J1wKb-0002jP-00@gondolin.me.apana.org.au>
References: <20071211040215.GA10360@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1905 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751827AbXLKEC4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Dec 2007 23:02:56 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J1wKb-000625-Ld
	for <linux-crypto@vger.kernel.org>; Tue, 11 Dec 2007 15:02:53 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] skcipher: Add givcrypt operations and givcipher type

Note: From now on the collective of ablkcipher/blkcipher/givcipher will
be known as skcipher, i.e., symmetric key cipher.  The name blkcipher has
always been much of a misnomer since it supports stream ciphers too.

Different block cipher modes have different requirements for intialisation
vectors.  For example, CBC can use a simple randomly generated IV while
modes such as CTR must use an IV generation mechanisms that give a stronger
guarantee on the lack of collisions.  Furthermore, disk encryption modes
have their own IV generation algorithms.

Up until now IV generation has been left to the users of the symmetric
key cipher API.  This is inconvenient as the number of block cipher modes
increase because the user needs to be aware of which mode is supposed to
be paired with which IV generation algorithm.

Therefore it makes sense to integrate the IV generation into the crypto
API.  This patch takes the first step in that direction by creating two
new ablkcipher operations, givencrypt and givdecrypt that generates an
IV before performing the actual encryption or decryption.

The operations are currently not exposed to the user.  That will be done
once the underlying functionality has actually been implemented.

It also creates the underlying givcipher type.  Algorithms that directly
generate IVs would use it instead of ablkcipher.  All other algorithms
(including all existing ones) would generate a givcipher algorithm upon
registration.  This givcipher algorithm will be constructed from the geniv
string that's stored in every algorithm.  That string will locate a template
which is instantiated by the blkcipher/ablkcipher algorithm in question to
give a givcipher algorithm.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ablkcipher.c                |   46 +++++++++++++++++++++++++++++++++++++
 include/crypto/internal/skcipher.h |   28 ++++++++++++++++++++++
 include/crypto/skcipher.h          |   38 ++++++++++++++++++++++++++++++
 include/linux/crypto.h             |    7 +++++
 4 files changed, 119 insertions(+)

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index 2731acb..d957ba2 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -105,5 +105,51 @@ const struct crypto_type crypto_ablkcipher_type = {
 };
 EXPORT_SYMBOL_GPL(crypto_ablkcipher_type);
 
+static int no_givdecrypt(struct skcipher_givcrypt_request *req)
+{
+	return -ENOSYS;
+}
+
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
+	crt->decrypt = alg->decrypt;
+	crt->givencrypt = alg->givencrypt;
+	crt->givdecrypt = alg->givdecrypt ?: no_givdecrypt;
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
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
new file mode 100644
index 0000000..04951cb
--- /dev/null
+++ b/include/crypto/internal/skcipher.h
@@ -0,0 +1,28 @@
+/*
+ * Symmetric key ciphers.
+ * 
+ * Copyright (c) 2007 Herbert Xu <herbert@gondor.apana.org.au>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option) 
+ * any later version.
+ *
+ */
+
+#ifndef _CRYPTO_INTERNAL_SKCIPHER_H
+#define _CRYPTO_INTERNAL_SKCIPHER_H
+
+#include <crypto/algapi.h>
+#include <crypto/skcipher.h>
+
+extern const struct crypto_type crypto_givcipher_type;
+
+static inline void *skcipher_givcrypt_reqctx(
+	struct skcipher_givcrypt_request *req)
+{
+	return ablkcipher_request_ctx(&req->creq);
+}
+
+#endif	/* _CRYPTO_INTERNAL_SKCIPHER_H */
+
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
new file mode 100644
index 0000000..c283fab
--- /dev/null
+++ b/include/crypto/skcipher.h
@@ -0,0 +1,38 @@
+/*
+ * Symmetric key ciphers.
+ * 
+ * Copyright (c) 2007 Herbert Xu <herbert@gondor.apana.org.au>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option) 
+ * any later version.
+ *
+ */
+
+#ifndef _CRYPTO_SKCIPHER_H
+#define _CRYPTO_SKCIPHER_H
+
+#include <linux/crypto.h>
+
+/**
+ *	struct skcipher_givcrypt_request - Crypto request with IV generation
+ *	@seq: Sequence number for IV generation
+ *	@giv: Space for generated IV
+ *	@creq: The crypto request itself
+ */
+struct skcipher_givcrypt_request {
+	u64 seq;
+	u8 *giv;
+
+	struct ablkcipher_request creq;
+};
+
+static inline struct crypto_ablkcipher *skcipher_givcrypt_reqtfm(
+	struct skcipher_givcrypt_request *req)
+{
+	return crypto_ablkcipher_reqtfm(&req->creq);
+}
+
+#endif	/* _CRYPTO_SKCIPHER_H */
+
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index ef7642e..d3012cd 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -34,6 +34,7 @@
 #define CRYPTO_ALG_TYPE_HASH		0x00000003
 #define CRYPTO_ALG_TYPE_BLKCIPHER	0x00000004
 #define CRYPTO_ALG_TYPE_ABLKCIPHER	0x00000005
+#define CRYPTO_ALG_TYPE_GIVCIPHER	0x00000006
 #define CRYPTO_ALG_TYPE_COMPRESS	0x00000008
 #define CRYPTO_ALG_TYPE_AEAD		0x00000009
 
@@ -99,6 +100,7 @@ struct crypto_blkcipher;
 struct crypto_hash;
 struct crypto_tfm;
 struct crypto_type;
+struct skcipher_givcrypt_request;
 
 typedef void (*crypto_completion_t)(struct crypto_async_request *req, int err);
 
@@ -178,6 +180,8 @@ struct ablkcipher_alg {
 	              unsigned int keylen);
 	int (*encrypt)(struct ablkcipher_request *req);
 	int (*decrypt)(struct ablkcipher_request *req);
+	int (*givencrypt)(struct skcipher_givcrypt_request *req);
+	int (*givdecrypt)(struct skcipher_givcrypt_request *req);
 
 	unsigned int min_keysize;
 	unsigned int max_keysize;
@@ -320,6 +324,9 @@ struct ablkcipher_tfm {
 	              unsigned int keylen);
 	int (*encrypt)(struct ablkcipher_request *req);
 	int (*decrypt)(struct ablkcipher_request *req);
+	int (*givencrypt)(struct skcipher_givcrypt_request *req);
+	int (*givdecrypt)(struct skcipher_givcrypt_request *req);
+
 	unsigned int ivsize;
 	unsigned int reqsize;
 };
