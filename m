From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/8] [CRYPTO] api: Add missing headers for setkey_unaligned
Date: Thu, 30 Aug 2007 16:41:22 +0800
Message-ID: <E1IQfac-0004BO-00@gondolin.me.apana.org.au>
References: <20070830083900.GA15936@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Thomas Graf <tgraf@suug.ch>,
	Herbgert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1406 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756253AbXH3IlZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Aug 2007 04:41:25 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[CRYPTO] api: Add missing headers for setkey_unaligned

This patch ensures that kernel.h and slab.h are included for
the setkey_unaligned function.  It also breaks a couple of
long lines.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ablkcipher.c |    5 ++++-
 crypto/blkcipher.c  |    6 +++---
 crypto/cipher.c     |    5 +++--
 crypto/hash.c       |    3 ++-
 4 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index 3dbb1cc..47438b6 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -16,10 +16,13 @@
 #include <crypto/algapi.h>
 #include <linux/errno.h>
 #include <linux/init.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/seq_file.h>
 
-static int setkey_unaligned(struct crypto_ablkcipher *tfm, const u8 *key, unsigned int keylen)
+static int setkey_unaligned(struct crypto_ablkcipher *tfm, const u8 *key,
+			    unsigned int keylen)
 {
 	struct ablkcipher_alg *cipher = crypto_ablkcipher_alg(tfm);
 	unsigned long alignmask = crypto_ablkcipher_alignmask(tfm);
diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index 7755834..3dfce35 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -336,7 +336,8 @@ static int blkcipher_walk_first(struct blkcipher_desc *desc,
 	return blkcipher_walk_next(desc, walk);
 }
 
-static int setkey_unaligned(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen)
+static int setkey_unaligned(struct crypto_tfm *tfm, const u8 *key,
+			    unsigned int keylen)
 {
 	struct blkcipher_alg *cipher = &tfm->__crt_alg->cra_blkcipher;
 	unsigned long alignmask = crypto_tfm_alg_alignmask(tfm);
@@ -357,8 +358,7 @@ static int setkey_unaligned(struct crypto_tfm *tfm, const u8 *key, unsigned int
 	return ret;
 }
 
-static int setkey(struct crypto_tfm *tfm, const u8 *key,
-		  unsigned int keylen)
+static int setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen)
 {
 	struct blkcipher_alg *cipher = &tfm->__crt_alg->cra_blkcipher;
 	unsigned long alignmask = crypto_tfm_alg_alignmask(tfm);
diff --git a/crypto/cipher.c b/crypto/cipher.c
index fc6b46f..9a1a731 100644
--- a/crypto/cipher.c
+++ b/crypto/cipher.c
@@ -16,11 +16,12 @@
 #include <linux/kernel.h>
 #include <linux/crypto.h>
 #include <linux/errno.h>
-#include <linux/scatterlist.h>
+#include <linux/slab.h>
 #include <linux/string.h>
 #include "internal.h"
 
-static int setkey_unaligned(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen)
+static int setkey_unaligned(struct crypto_tfm *tfm, const u8 *key,
+			    unsigned int keylen)
 {
 	struct cipher_alg *cia = &tfm->__crt_alg->cra_cipher;
 	unsigned long alignmask = crypto_tfm_alg_alignmask(tfm);
diff --git a/crypto/hash.c b/crypto/hash.c
index 4fd470b..7dcff67 100644
--- a/crypto/hash.c
+++ b/crypto/hash.c
@@ -12,6 +12,7 @@
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/seq_file.h>
 
 #include "internal.h"
@@ -46,7 +47,7 @@ static int hash_setkey_unaligned(struct crypto_hash *crt, const u8 *key,
 }
 
 static int hash_setkey(struct crypto_hash *crt, const u8 *key,
-		unsigned int keylen)
+		       unsigned int keylen)
 {
 	struct crypto_tfm *tfm = crypto_hash_tfm(crt);
 	struct hash_alg *alg = &tfm->__crt_alg->cra_hash;
