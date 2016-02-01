From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5/6] staging: lustre: Use ahash
Date: Mon, 01 Feb 2016 21:36:53 +0800
Message-ID: <E1aQEez-0002pe-RL@gondolin.me.apana.org.au>
References: <20160201133405.GA10754@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	devel@driverdev.osuosl.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47688 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932443AbcBANg5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Feb 2016 08:36:57 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch replaces uses of the long obsolete hash interface with
ahash.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/staging/lustre/lustre/libcfs/linux/linux-crypto.c |   92 +++++++-------
 1 file changed, 52 insertions(+), 40 deletions(-)

diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-crypto.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-crypto.c
index 079d50e..94c01aa 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-crypto.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-crypto.c
@@ -27,7 +27,7 @@
  * Copyright (c) 2012, Intel Corporation.
  */
 
-#include <linux/crypto.h>
+#include <crypto/hash.h>
 #include <linux/scatterlist.h>
 #include "../../../include/linux/libcfs/libcfs.h"
 #include "linux-crypto.h"
@@ -38,9 +38,11 @@ static int cfs_crypto_hash_speeds[CFS_HASH_ALG_MAX];
 
 static int cfs_crypto_hash_alloc(unsigned char alg_id,
 				 const struct cfs_crypto_hash_type **type,
-				 struct hash_desc *desc, unsigned char *key,
+				 struct ahash_request **req,
+				 unsigned char *key,
 				 unsigned int key_len)
 {
+	struct crypto_ahash *tfm;
 	int     err = 0;
 
 	*type = cfs_crypto_hash_type(alg_id);
@@ -50,18 +52,23 @@ static int cfs_crypto_hash_alloc(unsigned char alg_id,
 		      alg_id, CFS_HASH_ALG_MAX);
 		return -EINVAL;
 	}
-	desc->tfm = crypto_alloc_hash((*type)->cht_name, 0, 0);
+	tfm = crypto_alloc_ahash((*type)->cht_name, 0, CRYPTO_ALG_ASYNC);
 
-	if (desc->tfm == NULL)
-		return -EINVAL;
-
-	if (IS_ERR(desc->tfm)) {
+	if (IS_ERR(tfm)) {
 		CDEBUG(D_INFO, "Failed to alloc crypto hash %s\n",
 		       (*type)->cht_name);
-		return PTR_ERR(desc->tfm);
+		return PTR_ERR(tfm);
 	}
 
-	desc->flags = 0;
+	*req = ahash_request_alloc(tfm, GFP_KERNEL);
+	if (!*req) {
+		CDEBUG(D_INFO, "Failed to alloc ahash_request for %s\n",
+		       (*type)->cht_name);
+		crypto_free_ahash(tfm);
+		return -ENOMEM;
+	}
+
+	ahash_request_set_callback(*req, 0, NULL, NULL);
 
 	/** Shash have different logic for initialization then digest
 	 * shash: crypto_hash_setkey, crypto_hash_init
@@ -70,23 +77,27 @@ static int cfs_crypto_hash_alloc(unsigned char alg_id,
 	 * cfs_crypto_hash_alloc.
 	 */
 	if (key != NULL)
-		err = crypto_hash_setkey(desc->tfm, key, key_len);
+		err = crypto_ahash_setkey(tfm, key, key_len);
 	else if ((*type)->cht_key != 0)
-		err = crypto_hash_setkey(desc->tfm,
+		err = crypto_ahash_setkey(tfm,
 					 (unsigned char *)&((*type)->cht_key),
 					 (*type)->cht_size);
 
 	if (err != 0) {
-		crypto_free_hash(desc->tfm);
+		crypto_free_ahash(tfm);
 		return err;
 	}
 
 	CDEBUG(D_INFO, "Using crypto hash: %s (%s) speed %d MB/s\n",
-	       (crypto_hash_tfm(desc->tfm))->__crt_alg->cra_name,
-	       (crypto_hash_tfm(desc->tfm))->__crt_alg->cra_driver_name,
+	       crypto_ahash_alg_name(tfm), crypto_ahash_driver_name(tfm),
 	       cfs_crypto_hash_speeds[alg_id]);
 
-	return crypto_hash_init(desc);
+	err = crypto_ahash_init(*req);
+	if (err) {
+		ahash_request_free(*req);
+		crypto_free_ahash(tfm);
+	}
+	return err;
 }
 
 int cfs_crypto_hash_digest(unsigned char alg_id,
@@ -95,27 +106,29 @@ int cfs_crypto_hash_digest(unsigned char alg_id,
 			   unsigned char *hash, unsigned int *hash_len)
 {
 	struct scatterlist	sl;
-	struct hash_desc	hdesc;
+	struct ahash_request *req;
 	int			err;
 	const struct cfs_crypto_hash_type	*type;
 
 	if (buf == NULL || buf_len == 0 || hash_len == NULL)
 		return -EINVAL;
 
-	err = cfs_crypto_hash_alloc(alg_id, &type, &hdesc, key, key_len);
+	err = cfs_crypto_hash_alloc(alg_id, &type, &req, key, key_len);
 	if (err != 0)
 		return err;
 
 	if (hash == NULL || *hash_len < type->cht_size) {
 		*hash_len = type->cht_size;
-		crypto_free_hash(hdesc.tfm);
+		crypto_free_ahash(crypto_ahash_reqtfm(req));
+		ahash_request_free(req);
 		return -ENOSPC;
 	}
 	sg_init_one(&sl, buf, buf_len);
 
-	hdesc.flags = 0;
-	err = crypto_hash_digest(&hdesc, &sl, sl.length, hash);
-	crypto_free_hash(hdesc.tfm);
+	ahash_request_set_crypt(req, &sl, hash, sl.length);
+	err = crypto_ahash_digest(req);
+	crypto_free_ahash(crypto_ahash_reqtfm(req));
+	ahash_request_free(req);
 
 	return err;
 }
@@ -125,22 +138,15 @@ struct cfs_crypto_hash_desc *
 	cfs_crypto_hash_init(unsigned char alg_id,
 			     unsigned char *key, unsigned int key_len)
 {
-
-	struct  hash_desc       *hdesc;
+	struct ahash_request *req;
 	int		     err;
 	const struct cfs_crypto_hash_type       *type;
 
-	hdesc = kmalloc(sizeof(*hdesc), 0);
-	if (hdesc == NULL)
-		return ERR_PTR(-ENOMEM);
+	err = cfs_crypto_hash_alloc(alg_id, &type, &req, key, key_len);
 
-	err = cfs_crypto_hash_alloc(alg_id, &type, hdesc, key, key_len);
-
-	if (err) {
-		kfree(hdesc);
+	if (err)
 		return ERR_PTR(err);
-	}
-	return (struct cfs_crypto_hash_desc *)hdesc;
+	return (struct cfs_crypto_hash_desc *)req;
 }
 EXPORT_SYMBOL(cfs_crypto_hash_init);
 
@@ -148,23 +154,27 @@ int cfs_crypto_hash_update_page(struct cfs_crypto_hash_desc *hdesc,
 				struct page *page, unsigned int offset,
 				unsigned int len)
 {
+	struct ahash_request *req = (void *)hdesc;
 	struct scatterlist sl;
 
 	sg_init_table(&sl, 1);
 	sg_set_page(&sl, page, len, offset & ~CFS_PAGE_MASK);
 
-	return crypto_hash_update((struct hash_desc *)hdesc, &sl, sl.length);
+	ahash_request_set_crypt(req, &sl, NULL, sl.length);
+	return crypto_ahash_update(req);
 }
 EXPORT_SYMBOL(cfs_crypto_hash_update_page);
 
 int cfs_crypto_hash_update(struct cfs_crypto_hash_desc *hdesc,
 			   const void *buf, unsigned int buf_len)
 {
+	struct ahash_request *req = (void *)hdesc;
 	struct scatterlist sl;
 
 	sg_init_one(&sl, buf, buf_len);
 
-	return crypto_hash_update((struct hash_desc *)hdesc, &sl, sl.length);
+	ahash_request_set_crypt(req, &sl, NULL, sl.length);
+	return crypto_ahash_update(req);
 }
 EXPORT_SYMBOL(cfs_crypto_hash_update);
 
@@ -173,25 +183,27 @@ int cfs_crypto_hash_final(struct cfs_crypto_hash_desc *hdesc,
 			  unsigned char *hash, unsigned int *hash_len)
 {
 	int     err;
-	int     size = crypto_hash_digestsize(((struct hash_desc *)hdesc)->tfm);
+	struct ahash_request *req = (void *)hdesc;
+	int size = crypto_ahash_digestsize(crypto_ahash_reqtfm(req));
 
 	if (hash_len == NULL) {
-		crypto_free_hash(((struct hash_desc *)hdesc)->tfm);
-		kfree(hdesc);
+		crypto_free_ahash(crypto_ahash_reqtfm(req));
+		ahash_request_free(req);
 		return 0;
 	}
 	if (hash == NULL || *hash_len < size) {
 		*hash_len = size;
 		return -ENOSPC;
 	}
-	err = crypto_hash_final((struct hash_desc *) hdesc, hash);
+	ahash_request_set_crypt(req, NULL, hash, 0);
+	err = crypto_ahash_final(req);
 
 	if (err < 0) {
 		/* May be caller can fix error */
 		return err;
 	}
-	crypto_free_hash(((struct hash_desc *)hdesc)->tfm);
-	kfree(hdesc);
+	crypto_free_ahash(crypto_ahash_reqtfm(req));
+	ahash_request_free(req);
 	return err;
 }
 EXPORT_SYMBOL(cfs_crypto_hash_final);
