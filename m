From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 16/19] [CRYPTO] aead: Add givcrypt operations
Date: Tue, 11 Dec 2007 12:05:44 +0800
Message-ID: <E1J1wNM-0002lM-00@gondolin.me.apana.org.au>
References: <20071211040215.GA10360@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1972 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751948AbXLKEFx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Dec 2007 23:05:53 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J1wNO-00068A-US
	for <linux-crypto@vger.kernel.org>; Tue, 11 Dec 2007 15:05:47 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] aead: Add givcrypt operations

This patch adds the underlying givcrypt operations for aead and associated
support elements.  The rationale is identical to that of the skcipher
givcrypt operations, i.e., sometimes only the algorithm knows how the
IV should be generated.

A new request type aead_givcrypt_request is added which contains an
embedded aead_request structure with two new elements to support this
operation.  The new elements are seq and giv.  The seq field should
contain a strictly increasing 64-bit integer which may be used by
certain IV generators as an input value.  The giv field will be used
to store the generated IV.  It does not need to obey the alignment
requirements of the algorithm because it's not used during the operation.

The existing iv field must still be available as it will be used to store
intermediate IVs and the output IV if chaining is desired.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/aead.c          |    7 +++++++
 include/crypto/aead.h  |   38 ++++++++++++++++++++++++++++++++++++++
 include/linux/crypto.h |    5 +++++
 3 files changed, 50 insertions(+)

diff --git a/crypto/aead.c b/crypto/aead.c
index f23c2b0..0402b60 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -77,6 +77,11 @@ static unsigned int crypto_aead_ctxsize(struct crypto_alg *alg, u32 type,
 	return alg->cra_ctxsize;
 }
 
+static int no_givdecrypt(struct aead_givcrypt_request *req)
+{
+	return -ENOSYS;
+}
+
 static int crypto_init_aead_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 {
 	struct aead_alg *alg = &tfm->__crt_alg->cra_aead;
@@ -88,6 +93,8 @@ static int crypto_init_aead_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 	crt->setkey = setkey;
 	crt->encrypt = alg->encrypt;
 	crt->decrypt = alg->decrypt;
+	crt->givencrypt = alg->givencrypt;
+	crt->givdecrypt = alg->givdecrypt ?: no_givdecrypt;
 	crt->ivsize = alg->ivsize;
 	crt->authsize = alg->maxauthsize;
 
diff --git a/include/crypto/aead.h b/include/crypto/aead.h
new file mode 100644
index 0000000..0839203
--- /dev/null
+++ b/include/crypto/aead.h
@@ -0,0 +1,38 @@
+/*
+ * AEAD: Authenticated Encryption with Associated Data
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
+#ifndef _CRYPTO_AEAD_H
+#define _CRYPTO_AEAD_H
+
+#include <linux/crypto.h>
+#include <linux/kernel.h>
+
+/**
+ *	struct aead_givcrypt_request - AEAD request with IV generation
+ *	@seq: Sequence number for IV generation
+ *	@giv: Space for generated IV
+ *	@areq: The AEAD request itself
+ */
+struct aead_givcrypt_request {
+	u64 seq;
+	u8 *giv;
+
+	struct aead_request areq;
+};
+
+static inline struct crypto_aead *aead_givcrypt_reqtfm(
+	struct aead_givcrypt_request *req)
+{
+	return crypto_aead_reqtfm(&req->areq);
+}
+
+#endif	/* _CRYPTO_AEAD_H */
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 835dcaf..7524928 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -106,6 +106,7 @@ struct crypto_blkcipher;
 struct crypto_hash;
 struct crypto_tfm;
 struct crypto_type;
+struct aead_givcrypt_request;
 struct skcipher_givcrypt_request;
 
 typedef void (*crypto_completion_t)(struct crypto_async_request *req, int err);
@@ -202,6 +203,8 @@ struct aead_alg {
 	int (*setauthsize)(struct crypto_aead *tfm, unsigned int authsize);
 	int (*encrypt)(struct aead_request *req);
 	int (*decrypt)(struct aead_request *req);
+	int (*givencrypt)(struct aead_givcrypt_request *req);
+	int (*givdecrypt)(struct aead_givcrypt_request *req);
 
 	unsigned int ivsize;
 	unsigned int maxauthsize;
@@ -348,6 +351,8 @@ struct aead_tfm {
 	              unsigned int keylen);
 	int (*encrypt)(struct aead_request *req);
 	int (*decrypt)(struct aead_request *req);
+	int (*givencrypt)(struct aead_givcrypt_request *req);
+	int (*givdecrypt)(struct aead_givcrypt_request *req);
 	unsigned int ivsize;
 	unsigned int authsize;
 	unsigned int reqsize;
