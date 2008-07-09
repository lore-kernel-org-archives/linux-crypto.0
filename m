From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: FW: [Fwd: [PATCH]Using Intel CRC32 instruction to implement hardware accelerated CRC32c algorithm.]
Date: Wed, 9 Jul 2008 15:41:53 +0800
Message-ID: <20080709074153.GA11927@gondor.apana.org.au>
References: <000901c8e0d4$6f5cf230$7fb410ac@ccr.corp.intel.com> <1215512754.2906.23.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, chaapala@cisco.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	arjan@linux.intel.com
To: austin zhang <austin_zhang@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:33586 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756084AbYGIHmB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Jul 2008 03:42:01 -0400
Content-Disposition: inline
In-Reply-To: <1215512754.2906.23.camel@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 08, 2008 at 06:25:54AM -0400, austin zhang wrote:
>
> Agreed. And which module in crypto is the template for following the crypto API?

I've just converted the crc32c module over to the new interface.
You can use this as an example.

> > In fact, we could even skip 2) and reimplement lib/crc32c as a
> > wrapper on the crypto crc32c interface with a shared tfm so you
> > don't need to modify its existing users.
> Good idea.

Unfortunately this leads to nasty hacks because the existing
interface does chaining in a way that isn't easily mapped over
to the crypto API.  However this is no great loss since there
is a grand total of two users in the tree :)

So my plan is to convert them and then remove the libcrc32c
interface completely.

commit d55f7a6c8efa17bcbc3b5d240cc72ed8a71196c2
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Tue Jul 8 20:54:28 2008 +0800

    crypto: crc32c - Add ahash implementation
    
    This patch reimplements crc32c using the ahash interface.  This
    allows one tfm to be used by an unlimited number of users provided
    that they all use the same key (which all current crc32c users do).
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 43b7473..ea50357 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -213,7 +213,7 @@ comment "Digest"
 
 config CRYPTO_CRC32C
 	tristate "CRC32c CRC algorithm"
-	select CRYPTO_ALGAPI
+	select CRYPTO_HASH
 	select LIBCRC32C
 	help
 	  Castagnoli, et al Cyclic Redundancy-Check Algorithm.  Used
diff --git a/crypto/crc32c.c b/crypto/crc32c.c
index 0dcf64a..7049a98 100644
--- a/crypto/crc32c.c
+++ b/crypto/crc32c.c
@@ -5,20 +5,23 @@
  *
  * This module file is a wrapper to invoke the lib/crc32c routines.
  *
+ * Copyright (c) 2008 Herbert Xu <herbert@gondor.apana.org.au>
+ *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
  * Software Foundation; either version 2 of the License, or (at your option) 
  * any later version.
  *
  */
+
+#include <crypto/hash.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/string.h>
-#include <linux/crypto.h>
 #include <linux/crc32c.h>
 #include <linux/kernel.h>
 
-#define CHKSUM_BLOCK_SIZE	32
+#define CHKSUM_BLOCK_SIZE	1
 #define CHKSUM_DIGEST_SIZE	4
 
 struct chksum_ctx {
@@ -71,7 +74,7 @@ static void chksum_final(struct crypto_tfm *tfm, u8 *out)
 	*(__le32 *)out = ~cpu_to_le32(mctx->crc);
 }
 
-static int crc32c_cra_init(struct crypto_tfm *tfm)
+static int crc32c_cra_init_old(struct crypto_tfm *tfm)
 {
 	struct chksum_ctx *mctx = crypto_tfm_ctx(tfm);
 
@@ -79,14 +82,14 @@ static int crc32c_cra_init(struct crypto_tfm *tfm)
 	return 0;
 }
 
-static struct crypto_alg alg = {
+static struct crypto_alg old_alg = {
 	.cra_name	=	"crc32c",
 	.cra_flags	=	CRYPTO_ALG_TYPE_DIGEST,
 	.cra_blocksize	=	CHKSUM_BLOCK_SIZE,
 	.cra_ctxsize	=	sizeof(struct chksum_ctx),
 	.cra_module	=	THIS_MODULE,
-	.cra_list	=	LIST_HEAD_INIT(alg.cra_list),
-	.cra_init	=	crc32c_cra_init,
+	.cra_list	=	LIST_HEAD_INIT(old_alg.cra_list),
+	.cra_init	=	crc32c_cra_init_old,
 	.cra_u		=	{
 		.digest = {
 			 .dia_digestsize=	CHKSUM_DIGEST_SIZE,
@@ -98,14 +101,125 @@ static struct crypto_alg alg = {
 	}
 };
 
+/*
+ * Setting the seed allows arbitrary accumulators and flexible XOR policy
+ * If your algorithm starts with ~0, then XOR with ~0 before you set
+ * the seed.
+ */
+static int crc32c_setkey(struct crypto_ahash *hash, const u8 *key,
+			 unsigned int keylen)
+{
+	u32 *mctx = crypto_ahash_ctx(hash);
+
+	if (keylen != sizeof(u32)) {
+		crypto_ahash_set_flags(hash, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+	*mctx = le32_to_cpup((__le32 *)key);
+	return 0;
+}
+
+static int crc32c_init(struct ahash_request *req)
+{
+	u32 *mctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
+	u32 *crcp = ahash_request_ctx(req);
+
+	*crcp = *mctx;
+	return 0;
+}
+
+static int crc32c_update(struct ahash_request *req)
+{
+	struct crypto_hash_walk walk;
+	u32 *crcp = ahash_request_ctx(req);
+	u32 crc = *crcp;
+	int nbytes;
+
+	for (nbytes = crypto_hash_walk_first(req, &walk); nbytes;
+	     nbytes = crypto_hash_walk_done(&walk, 0))
+		crc = crc32c(crc, walk.data, nbytes);
+
+	*crcp = crc;
+	return 0;
+}
+
+static int crc32c_final(struct ahash_request *req)
+{
+	u32 *crcp = ahash_request_ctx(req);
+	
+	*(__le32 *)req->result = ~cpu_to_le32p(crcp);
+	return 0;
+}
+
+static int crc32c_digest(struct ahash_request *req)
+{
+	struct crypto_hash_walk walk;
+	u32 *mctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
+	u32 crc = *mctx;
+	int nbytes;
+
+	for (nbytes = crypto_hash_walk_first(req, &walk); nbytes;
+	     nbytes = crypto_hash_walk_done(&walk, 0))
+		crc = crc32c(crc, walk.data, nbytes);
+
+	*(__le32 *)req->result = ~cpu_to_le32(crc);
+	return 0;
+}
+
+static int crc32c_cra_init(struct crypto_tfm *tfm)
+{
+	u32 *key = crypto_tfm_ctx(tfm);
+
+	*key = ~0;
+
+	tfm->crt_ahash.reqsize = sizeof(u32);
+
+	return 0;
+}
+
+static struct crypto_alg alg = {
+	.cra_name		=	"crc32c",
+	.cra_driver_name	=	"crc32c-generic",
+	.cra_priority		=	100,
+	.cra_flags		=	CRYPTO_ALG_TYPE_AHASH,
+	.cra_blocksize		=	CHKSUM_BLOCK_SIZE,
+	.cra_alignmask		=	3,
+	.cra_ctxsize		=	sizeof(u32),
+	.cra_module		=	THIS_MODULE,
+	.cra_list		=	LIST_HEAD_INIT(alg.cra_list),
+	.cra_init		=	crc32c_cra_init,
+	.cra_type		=	&crypto_ahash_type,
+	.cra_u			=	{
+		.ahash = {
+			 .digestsize	=	CHKSUM_DIGEST_SIZE,
+			 .setkey	=	crc32c_setkey,
+			 .init   	= 	crc32c_init,
+			 .update 	=	crc32c_update,
+			 .final  	=	crc32c_final,
+			 .digest  	=	crc32c_digest,
+		 }
+	}
+};
+
 static int __init crc32c_mod_init(void)
 {
-	return crypto_register_alg(&alg);
+	int err;
+
+	err = crypto_register_alg(&old_alg);
+	if (err)
+		return err;
+
+	err = crypto_register_alg(&alg);
+	if (err)
+		crypto_unregister_alg(&old_alg);
+
+	return err;
 }
 
 static void __exit crc32c_mod_fini(void)
 {
 	crypto_unregister_alg(&alg);
+	crypto_unregister_alg(&old_alg);
 }
 
 module_init(crc32c_mod_init);

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
