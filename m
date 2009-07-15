From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 22/35] crypto: api - Remove frontend argument from extsize/init_tfm
Date: Wed, 15 Jul 2009 15:16:16 +0800
Message-ID: <E1MQyiu-00050p-70@gondolin.me.apana.org.au>
References: <20090715071424.GA19023@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53644 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752644AbZGOHQV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 03:16:21 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MQyiu-0004tB-VJ
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2009 17:16:17 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: api - Remove frontend argument from extsize/init_tfm

As the extsize and init_tfm functions belong to the frontend the
frontend argument is superfluous.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/api.c            |    4 ++--
 crypto/pcompress.c      |    6 ++----
 crypto/shash.c          |    6 ++----
 include/crypto/algapi.h |    6 ++----
 4 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index c8ac18f..798526d 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -457,7 +457,7 @@ void *crypto_create_tfm(struct crypto_alg *alg,
 	int err = -ENOMEM;
 
 	tfmsize = frontend->tfmsize;
-	total = tfmsize + sizeof(*tfm) + frontend->extsize(alg, frontend);
+	total = tfmsize + sizeof(*tfm) + frontend->extsize(alg);
 
 	mem = kzalloc(total, GFP_KERNEL);
 	if (mem == NULL)
@@ -466,7 +466,7 @@ void *crypto_create_tfm(struct crypto_alg *alg,
 	tfm = (struct crypto_tfm *)(mem + tfmsize);
 	tfm->__crt_alg = alg;
 
-	err = frontend->init_tfm(tfm, frontend);
+	err = frontend->init_tfm(tfm);
 	if (err)
 		goto out_free_tfm;
 
diff --git a/crypto/pcompress.c b/crypto/pcompress.c
index bcadc03..f7c4a7d 100644
--- a/crypto/pcompress.c
+++ b/crypto/pcompress.c
@@ -36,14 +36,12 @@ static int crypto_pcomp_init(struct crypto_tfm *tfm, u32 type, u32 mask)
 	return 0;
 }
 
-static unsigned int crypto_pcomp_extsize(struct crypto_alg *alg,
-					 const struct crypto_type *frontend)
+static unsigned int crypto_pcomp_extsize(struct crypto_alg *alg)
 {
 	return alg->cra_ctxsize;
 }
 
-static int crypto_pcomp_init_tfm(struct crypto_tfm *tfm,
-				 const struct crypto_type *frontend)
+static int crypto_pcomp_init_tfm(struct crypto_tfm *tfm)
 {
 	return 0;
 }
diff --git a/crypto/shash.c b/crypto/shash.c
index 3b1b06b..7063e14 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -448,8 +448,7 @@ static unsigned int crypto_shash_ctxsize(struct crypto_alg *alg, u32 type,
 	return 0;
 }
 
-static int crypto_shash_init_tfm(struct crypto_tfm *tfm,
-				 const struct crypto_type *frontend)
+static int crypto_shash_init_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_shash *hash = __crypto_shash_cast(tfm);
 
@@ -457,8 +456,7 @@ static int crypto_shash_init_tfm(struct crypto_tfm *tfm,
 	return 0;
 }
 
-static unsigned int crypto_shash_extsize(struct crypto_alg *alg,
-					 const struct crypto_type *frontend)
+static unsigned int crypto_shash_extsize(struct crypto_alg *alg)
 {
 	return alg->cra_ctxsize;
 }
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 1d15a92..7635fde 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -22,11 +22,9 @@ struct seq_file;
 
 struct crypto_type {
 	unsigned int (*ctxsize)(struct crypto_alg *alg, u32 type, u32 mask);
-	unsigned int (*extsize)(struct crypto_alg *alg,
-				const struct crypto_type *frontend);
+	unsigned int (*extsize)(struct crypto_alg *alg);
 	int (*init)(struct crypto_tfm *tfm, u32 type, u32 mask);
-	int (*init_tfm)(struct crypto_tfm *tfm,
-		        const struct crypto_type *frontend);
+	int (*init_tfm)(struct crypto_tfm *tfm);
 	void (*show)(struct seq_file *m, struct crypto_alg *alg);
 	struct crypto_alg *(*lookup)(const char *name, u32 type, u32 mask);
 
