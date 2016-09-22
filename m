From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v8 8/8] crypto: acomp - update testmgr with support for acomp
Date: Thu, 22 Sep 2016 23:44:21 +0100
Message-ID: <1474584261-25776-9-git-send-email-giovanni.cabiddu@intel.com>
References: <1474584261-25776-1-git-send-email-giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:8646 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933539AbcIVWoo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Sep 2016 18:44:44 -0400
In-Reply-To: <1474584261-25776-1-git-send-email-giovanni.cabiddu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add tests to the test manager for algorithms exposed through acomp

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 crypto/testmgr.c | 158 ++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 145 insertions(+), 13 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 0b01c3d..65a2d3d 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -33,6 +33,7 @@
 #include <crypto/drbg.h>
 #include <crypto/akcipher.h>
 #include <crypto/kpp.h>
+#include <crypto/acompress.h>
 
 #include "internal.h"
 
@@ -1439,6 +1440,121 @@ out:
 	return ret;
 }
 
+static int test_acomp(struct crypto_acomp *tfm, struct comp_testvec *ctemplate,
+		      struct comp_testvec *dtemplate, int ctcount, int dtcount)
+{
+	const char *algo = crypto_tfm_alg_driver_name(crypto_acomp_tfm(tfm));
+	unsigned int i;
+	char output[COMP_BUF_SIZE];
+	int ret;
+	struct scatterlist src, dst;
+	struct acomp_req *req;
+	struct tcrypt_result result;
+
+	for (i = 0; i < ctcount; i++) {
+		unsigned int dlen = COMP_BUF_SIZE;
+		int ilen = ctemplate[i].inlen;
+
+		memset(output, 0, sizeof(output));
+		init_completion(&result.completion);
+		sg_init_one(&src, ctemplate[i].input, ilen);
+		sg_init_one(&dst, output, dlen);
+
+		req = acomp_request_alloc(tfm);
+		if (!req) {
+			pr_err("alg: acomp: request alloc failed for %s\n",
+			       algo);
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		acomp_request_set_params(req, &src, &dst, ilen, dlen);
+		acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+					   tcrypt_complete, &result);
+
+		ret = wait_async_op(&result, crypto_acomp_compress(req));
+		if (ret) {
+			pr_err("alg: acomp: compression failed on test %d for %s: ret=%d\n",
+			       i + 1, algo, -ret);
+			acomp_request_free(req);
+			goto out;
+		}
+
+		if (req->dlen != ctemplate[i].outlen) {
+			pr_err("alg: acomp: Compression test %d failed for %s: output len = %d\n",
+			       i + 1, algo, req->dlen);
+			ret = -EINVAL;
+			acomp_request_free(req);
+			goto out;
+		}
+
+		if (memcmp(output, ctemplate[i].output, req->dlen)) {
+			pr_err("alg: acomp: Compression test %d failed for %s\n",
+			       i + 1, algo);
+			hexdump(output, req->dlen);
+			ret = -EINVAL;
+			acomp_request_free(req);
+			goto out;
+		}
+
+		acomp_request_free(req);
+	}
+
+	for (i = 0; i < dtcount; i++) {
+		unsigned int dlen = COMP_BUF_SIZE;
+		int ilen = dtemplate[i].inlen;
+
+		memset(output, 0, sizeof(output));
+		init_completion(&result.completion);
+		sg_init_one(&src, dtemplate[i].input, ilen);
+		sg_init_one(&dst, output, dlen);
+
+		req = acomp_request_alloc(tfm);
+		if (!req) {
+			pr_err("alg: acomp: request alloc failed for %s\n",
+			       algo);
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		acomp_request_set_params(req, &src, &dst, ilen, dlen);
+		acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+					   tcrypt_complete, &result);
+
+		ret = wait_async_op(&result, crypto_acomp_decompress(req));
+		if (ret) {
+			pr_err("alg: acomp: decompression failed on test %d for %s: ret=%d\n",
+			       i + 1, algo, -ret);
+			acomp_request_free(req);
+			goto out;
+		}
+
+		if (req->dlen != dtemplate[i].outlen) {
+			pr_err("alg: acomp: Decompression test %d failed for %s: output len = %d\n",
+			       i + 1, algo, req->dlen);
+			ret = -EINVAL;
+			acomp_request_free(req);
+			goto out;
+		}
+
+		if (memcmp(output, dtemplate[i].output, req->dlen)) {
+			pr_err("alg: acomp: Decompression test %d failed for %s\n",
+			       i + 1, algo);
+			hexdump(output, req->dlen);
+			ret = -EINVAL;
+			acomp_request_free(req);
+			goto out;
+		}
+
+		acomp_request_free(req);
+	}
+
+	ret = 0;
+
+out:
+	return ret;
+}
+
 static int test_cprng(struct crypto_rng *tfm, struct cprng_testvec *template,
 		      unsigned int tcount)
 {
@@ -1590,22 +1706,38 @@ out:
 static int alg_test_comp(const struct alg_test_desc *desc, const char *driver,
 			 u32 type, u32 mask)
 {
-	struct crypto_comp *tfm;
+	struct crypto_comp *comp;
+	struct crypto_acomp *acomp;
 	int err;
+	u32 algo_type = type & CRYPTO_ALG_TYPE_ACOMPRESS_MASK;
+
+	if (algo_type == CRYPTO_ALG_TYPE_ACOMPRESS) {
+		acomp = crypto_alloc_acomp(driver, type, mask);
+		if (IS_ERR(acomp)) {
+			pr_err("alg: acomp: Failed to load transform for %s: %ld\n",
+			       driver, PTR_ERR(acomp));
+			return PTR_ERR(acomp);
+		}
+		err = test_acomp(acomp, desc->suite.comp.comp.vecs,
+				 desc->suite.comp.decomp.vecs,
+				 desc->suite.comp.comp.count,
+				 desc->suite.comp.decomp.count);
+		crypto_free_acomp(acomp);
+	} else {
+		comp = crypto_alloc_comp(driver, type, mask);
+		if (IS_ERR(comp)) {
+			pr_err("alg: comp: Failed to load transform for %s: %ld\n",
+			       driver, PTR_ERR(comp));
+			return PTR_ERR(comp);
+		}
 
-	tfm = crypto_alloc_comp(driver, type, mask);
-	if (IS_ERR(tfm)) {
-		printk(KERN_ERR "alg: comp: Failed to load transform for %s: "
-		       "%ld\n", driver, PTR_ERR(tfm));
-		return PTR_ERR(tfm);
-	}
-
-	err = test_comp(tfm, desc->suite.comp.comp.vecs,
-			desc->suite.comp.decomp.vecs,
-			desc->suite.comp.comp.count,
-			desc->suite.comp.decomp.count);
+		err = test_comp(comp, desc->suite.comp.comp.vecs,
+				desc->suite.comp.decomp.vecs,
+				desc->suite.comp.comp.count,
+				desc->suite.comp.decomp.count);
 
-	crypto_free_comp(tfm);
+		crypto_free_comp(comp);
+	}
 	return err;
 }
 
-- 
2.4.11
