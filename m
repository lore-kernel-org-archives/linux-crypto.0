From: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 1/2] add infrastructure for ansi_cprng self-tests
Date: Tue, 28 Apr 2009 21:28:13 -0400
Message-ID: <200904282128.14153.jarod@redhat.com>
References: <200904282127.33190.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Neil Horman <nhorman@tuxdriver.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:60092 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755990AbZD2B2T (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Apr 2009 21:28:19 -0400
In-Reply-To: <200904282127.33190.jarod@redhat.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add some necessary infrastructure to make it possible to run
self-tests for ansi_cprng. The bits are likely very specific
to the ANSI X9.31 CPRNG in AES mode, and thus perhaps should
be named more specifically if/when we grow additional CPRNG
support...

Successfully tested against the cryptodev-2.6 tree and a
Red Hat Enterprise Linux 5.x kernel with the follow-on
patch that adds the actual test vectors.

Signed-off-by: Jarod Wilson <jarod@redhat.com>

---
 crypto/testmgr.c |   89 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 crypto/testmgr.h |   12 +++++++
 2 files changed, 101 insertions(+), 0 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index d0cc85c..6330081 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -19,6 +19,7 @@
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <crypto/rng.h>
 
 #include "internal.h"
 #include "testmgr.h"
@@ -84,6 +85,11 @@ struct hash_test_suite {
 	unsigned int count;
 };
 
+struct cprng_test_suite {
+	struct cprng_testvec *vecs;
+	unsigned int count;
+};
+
 struct alg_test_desc {
 	const char *alg;
 	int (*test)(const struct alg_test_desc *desc, const char *driver,
@@ -95,6 +101,7 @@ struct alg_test_desc {
 		struct comp_test_suite comp;
 		struct pcomp_test_suite pcomp;
 		struct hash_test_suite hash;
+		struct cprng_test_suite cprng;
 	} suite;
 };
 
@@ -1089,6 +1096,68 @@ static int test_pcomp(struct crypto_pcomp *tfm,
 	return 0;
 }
 
+
+static int test_cprng(struct crypto_rng *tfm, struct cprng_testvec *template,
+		      unsigned int tcount)
+{
+	const char *algo = crypto_tfm_alg_driver_name(crypto_rng_tfm(tfm));
+	int err, i, j, seedsize;
+	u8 *seed;
+	char result[32];
+
+	seedsize = crypto_rng_seedsize(tfm);
+
+	seed = kmalloc(seedsize, GFP_KERNEL);
+	if (!seed) {
+		printk(KERN_ERR "alg: cprng: Failed to allocate seed space "
+		       "for %s\n", algo);
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < tcount; i++) {
+		memset(result, 0, 32);
+
+		memcpy(seed, template[i].v, template[i].vlen);
+		memcpy(seed + template[i].vlen, template[i].key,
+		       template[i].klen);
+		memcpy(seed + template[i].vlen + template[i].klen,
+		       template[i].dt, template[i].dtlen);
+
+		err = crypto_rng_reset(tfm, seed, seedsize);
+		if (err) {
+			printk(KERN_ERR "alg: cprng: Failed to reset rng "
+			       "for %s\n", algo);
+			goto out;
+		}
+
+		for (j = 0; j < template[i].loops; j++) {
+			err = crypto_rng_get_bytes(tfm, result,
+						   template[i].rlen);
+			if (err != template[i].rlen) {
+				printk(KERN_ERR "alg: cprng: Failed to obtain "
+				       "the correct amount of random data for "
+				       "%s (requested %d, got %d)\n", algo,
+				       template[i].rlen, err);
+				goto out;
+			}
+		}
+
+		err = memcmp(result, template[i].result,
+			     template[i].rlen);
+		if (err) {
+			printk(KERN_ERR "alg: cprng: Test %d failed for %s\n",
+			       i, algo);
+			hexdump(result, template[i].rlen);
+			err = -EINVAL;
+			goto out;
+		}
+	}
+
+out:
+	kfree(seed);
+	return err;
+}
+
 static int alg_test_aead(const struct alg_test_desc *desc, const char *driver,
 			 u32 type, u32 mask)
 {
@@ -1288,6 +1357,26 @@ out:
 	return err;
 }
 
+static int alg_test_cprng(const struct alg_test_desc *desc, const char *driver,
+			  u32 type, u32 mask)
+{
+	struct crypto_rng *rng;
+	int err;
+
+	rng = crypto_alloc_rng(driver, type, mask);
+	if (IS_ERR(rng)) {
+		printk(KERN_ERR "alg: cprng: Failed to load transform for %s: "
+		       "%ld\n", driver, PTR_ERR(rng));
+		return PTR_ERR(rng);
+	}
+
+	err = test_cprng(rng, desc->suite.cprng.vecs, desc->suite.cprng.count);
+
+	crypto_free_rng(rng);
+
+	return err;
+}
+
 /* Please keep this list sorted by algorithm name. */
 static const struct alg_test_desc alg_test_descs[] = {
 	{
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 5add651..13d5a61 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -70,6 +70,18 @@ struct aead_testvec {
 	unsigned short rlen;
 };
 
+struct cprng_testvec {
+	char *key;
+	char *dt;
+	char *v;
+	char *result;
+	unsigned char klen;
+	unsigned short dtlen;
+	unsigned short vlen;
+	unsigned short rlen;
+	unsigned short loops;
+};
+
 static char zeroed_string[48];
 
 /*


-- 
Jarod Wilson
jarod@redhat.com
