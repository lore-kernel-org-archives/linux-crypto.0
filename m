From: Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH RFC 5/7] crypto: testmgr: add scompress/acompress test
Date: Mon,  4 Jan 2016 13:46:56 +0900
Message-ID: <1451882819-2810-6-git-send-email-iamjoonsoo.kim@lge.com>
References: <1451882819-2810-1-git-send-email-iamjoonsoo.kim@lge.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Weigang Li <weigang.li@intel.com>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	Minchan Kim <minchan@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:33818 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbcADErd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 3 Jan 2016 23:47:33 -0500
In-Reply-To: <1451882819-2810-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 crypto/Kconfig   |   1 +
 crypto/testmgr.c | 173 ++++++++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 165 insertions(+), 9 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index b4b485c..f487502 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -118,6 +118,7 @@ config CRYPTO_MANAGER2
 	select CRYPTO_HASH2
 	select CRYPTO_BLKCIPHER2
 	select CRYPTO_AKCIPHER2
+	select CRYPTO_COMPRESS2
 
 config CRYPTO_USER
 	tristate "Userspace cryptographic algorithm configuration"
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 086aa4d..bd0c639 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -32,6 +32,7 @@
 #include <crypto/rng.h>
 #include <crypto/drbg.h>
 #include <crypto/akcipher.h>
+#include <crypto/compress.h>
 
 #include "internal.h"
 
@@ -1205,12 +1206,14 @@ static int test_skcipher(struct crypto_skcipher *tfm, int enc,
 	return 0;
 }
 
-static int test_comp(struct crypto_comp *tfm, struct comp_testvec *ctemplate,
-		     struct comp_testvec *dtemplate, int ctcount, int dtcount)
+static int test_comp(struct crypto_tfm *tfm, void *ctx, int type,
+		struct comp_testvec *ctemplate, struct comp_testvec *dtemplate,
+		int ctcount, int dtcount)
 {
-	const char *algo = crypto_tfm_alg_driver_name(crypto_comp_tfm(tfm));
+	const char *algo = crypto_tfm_alg_driver_name(tfm);
 	unsigned int i;
 	char result[COMP_BUF_SIZE];
+	struct scatterlist src, dst;
 	int ret;
 
 	for (i = 0; i < ctcount; i++) {
@@ -1220,8 +1223,33 @@ static int test_comp(struct crypto_comp *tfm, struct comp_testvec *ctemplate,
 		memset(result, 0, sizeof (result));
 
 		ilen = ctemplate[i].inlen;
-		ret = crypto_comp_compress(tfm, ctemplate[i].input,
-		                           ilen, result, &dlen);
+
+		switch (type) {
+		case 0:
+			ret = crypto_comp_compress(crypto_comp_cast(tfm),
+					ctemplate[i].input, ilen,
+					result, &dlen);
+			break;
+
+		case 1:
+			ret = crypto_scomp_compress(crypto_scomp_cast(tfm),
+					ctemplate[i].input, ilen,
+					result, &dlen, ctx);
+			break;
+
+		case 2:
+			sg_init_one(&src, ctemplate[i].input, ilen);
+			sg_init_one(&dst, result, dlen);
+			acomp_request_set_comp(ctx, &src, &dst, ilen, dlen);
+			ret = crypto_acomp_compress(ctx);
+			dlen = ((struct acomp_req *)ctx)->out_len;
+			break;
+
+		default:
+			ret = 1;
+			break;
+		}
+
 		if (ret) {
 			printk(KERN_ERR "alg: comp: compression failed "
 			       "on test %d for %s: ret=%d\n", i + 1, algo,
@@ -1253,8 +1281,32 @@ static int test_comp(struct crypto_comp *tfm, struct comp_testvec *ctemplate,
 		memset(result, 0, sizeof (result));
 
 		ilen = dtemplate[i].inlen;
-		ret = crypto_comp_decompress(tfm, dtemplate[i].input,
-		                             ilen, result, &dlen);
+		switch (type) {
+		case 0:
+			ret = crypto_comp_decompress(crypto_comp_cast(tfm),
+						dtemplate[i].input, ilen,
+						result, &dlen);
+			break;
+
+		case 1:
+			ret = crypto_scomp_decompress(crypto_scomp_cast(tfm),
+						dtemplate[i].input, ilen,
+						result, &dlen, ctx);
+			break;
+
+		case 2:
+			sg_init_one(&src, dtemplate[i].input, ilen);
+			sg_init_one(&dst, result, dlen);
+			acomp_request_set_comp(ctx, &src, &dst, ilen, dlen);
+			ret = crypto_acomp_decompress(ctx);
+			dlen = ((struct acomp_req *)ctx)->out_len;
+			break;
+
+		default:
+			ret = 1;
+			break;
+		}
+
 		if (ret) {
 			printk(KERN_ERR "alg: comp: decompression failed "
 			       "on test %d for %s: ret=%d\n", i + 1, algo,
@@ -1446,7 +1498,8 @@ static int alg_test_comp(const struct alg_test_desc *desc, const char *driver,
 		return PTR_ERR(tfm);
 	}
 
-	err = test_comp(tfm, desc->suite.comp.comp.vecs,
+	err = test_comp(crypto_comp_tfm(tfm), NULL, 0,
+			desc->suite.comp.comp.vecs,
 			desc->suite.comp.decomp.vecs,
 			desc->suite.comp.comp.count,
 			desc->suite.comp.decomp.count);
@@ -1455,6 +1508,92 @@ static int alg_test_comp(const struct alg_test_desc *desc, const char *driver,
 	return err;
 }
 
+static int __alg_test_scomp(const struct alg_test_desc *desc,
+			const char *driver, u32 type, u32 mask)
+{
+	struct crypto_scomp *tfm;
+	void *ctx;
+	int err;
+
+	tfm = crypto_alloc_scomp(driver, type, mask);
+	if (IS_ERR(tfm)) {
+		printk(KERN_ERR "alg: scomp: Failed to load transform for %s: "
+		       "%ld\n", driver, PTR_ERR(tfm));
+		return PTR_ERR(tfm);
+	}
+
+	ctx = crypto_scomp_alloc_ctx(tfm);
+	if (IS_ERR(ctx)) {
+		printk(KERN_ERR "alg: scomp: Failed to alloc context for %s: "
+		       "%ld\n", driver, PTR_ERR(ctx));
+		err = PTR_ERR(ctx);
+		goto out;
+	}
+
+	err = test_comp(crypto_scomp_tfm(tfm), ctx, 1,
+			desc->suite.comp.comp.vecs,
+			desc->suite.comp.decomp.vecs,
+			desc->suite.comp.comp.count,
+			desc->suite.comp.decomp.count);
+
+	crypto_scomp_free_ctx(tfm, ctx);
+
+out:
+	crypto_free_scomp(tfm);
+	return err;
+}
+
+static int __alg_test_acomp(const struct alg_test_desc *desc,
+			const char *driver, u32 type, u32 mask)
+{
+	struct crypto_acomp *tfm;
+	struct acomp_req *req;
+	int err;
+
+	tfm = crypto_alloc_acomp(driver, type, mask);
+	if (IS_ERR(tfm)) {
+		printk(KERN_ERR "alg: acomp: Failed to load transform for %s: "
+		       "%ld\n", driver, PTR_ERR(tfm));
+		return PTR_ERR(tfm);
+	}
+
+	req = acomp_request_alloc(tfm, GFP_KERNEL);
+	if (!req) {
+		printk(KERN_ERR "alg: acomp: Failed to alloc request for %s: ",
+			driver);
+		err = -ENOMEM;
+		goto out;
+	}
+
+	err = test_comp(crypto_acomp_tfm(tfm), req, 2,
+			desc->suite.comp.comp.vecs,
+			desc->suite.comp.decomp.vecs,
+			desc->suite.comp.comp.count,
+			desc->suite.comp.decomp.count);
+
+	acomp_request_free(req);
+
+out:
+	crypto_free_acomp(tfm);
+	return err;
+}
+
+static int alg_test_scomp(const struct alg_test_desc *desc, const char *driver,
+			 u32 type, u32 mask)
+{
+	int err;
+
+	err = __alg_test_scomp(desc, driver, type, mask);
+	if (err)
+		return err;
+
+	err = __alg_test_acomp(desc, driver, type, mask);
+	if (err)
+		return err;
+
+	return err;
+}
+
 static int alg_test_hash(const struct alg_test_desc *desc, const char *driver,
 			 u32 type, u32 mask)
 {
@@ -3203,7 +3342,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
-		.alg = "lzo",
+		.alg = "lzo-generic",
 		.test = alg_test_comp,
 		.fips_allowed = 1,
 		.suite = {
@@ -3219,6 +3358,22 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "lzo-scomp",
+		.test = alg_test_scomp,
+		.fips_allowed = 1,
+		.suite = {
+			.comp = {
+				.comp = {
+					.vecs = lzo_comp_tv_template,
+					.count = LZO_COMP_TEST_VECTORS
+				},
+				.decomp = {
+					.vecs = lzo_decomp_tv_template,
+					.count = LZO_DECOMP_TEST_VECTORS
+				}
+			}
+		}
+	}, {
 		.alg = "md4",
 		.test = alg_test_hash,
 		.suite = {
-- 
1.9.1
