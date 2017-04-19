From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: acomp - replace compression known answer test
Date: Wed, 19 Apr 2017 14:27:18 +0100
Message-ID: <20170419132718.3438-1-giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, weigang.li@intel.com,
        giovanni.cabiddu@gmail.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:17459 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1763606AbdDSN1d (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Apr 2017 09:27:33 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Compression implementations might return valid outputs that
do not match what specified in the test vectors.
For this reason, the testmgr might report that a compression
implementation failed the test even if the data produced
by the compressor is correct.
This implements a decompress-and-verify test for acomp
compression tests rather than a known answer test.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 crypto/testmgr.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index cd075c7..8373c72 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1458,7 +1458,7 @@ static int test_acomp(struct crypto_acomp *tfm,
 {
 	const char *algo = crypto_tfm_alg_driver_name(crypto_acomp_tfm(tfm));
 	unsigned int i;
-	char *output;
+	char *output, *decomp_out;
 	int ret;
 	struct scatterlist src, dst;
 	struct acomp_req *req;
@@ -1468,6 +1468,12 @@ static int test_acomp(struct crypto_acomp *tfm,
 	if (!output)
 		return -ENOMEM;
 
+	decomp_out = kmalloc(COMP_BUF_SIZE, GFP_KERNEL);
+	if (!decomp_out) {
+		kfree(output);
+		return -ENOMEM;
+	}
+
 	for (i = 0; i < ctcount; i++) {
 		unsigned int dlen = COMP_BUF_SIZE;
 		int ilen = ctemplate[i].inlen;
@@ -1506,7 +1512,23 @@ static int test_acomp(struct crypto_acomp *tfm,
 			goto out;
 		}
 
-		if (req->dlen != ctemplate[i].outlen) {
+		ilen = req->dlen;
+		dlen = COMP_BUF_SIZE;
+		sg_init_one(&src, output, ilen);
+		sg_init_one(&dst, decomp_out, dlen);
+		init_completion(&result.completion);
+		acomp_request_set_params(req, &src, &dst, ilen, dlen);
+
+		ret = wait_async_op(&result, crypto_acomp_decompress(req));
+		if (ret) {
+			pr_err("alg: acomp: compression failed on test %d for %s: ret=%d\n",
+			       i + 1, algo, -ret);
+			kfree(input_vec);
+			acomp_request_free(req);
+			goto out;
+		}
+
+		if (req->dlen != ctemplate[i].inlen) {
 			pr_err("alg: acomp: Compression test %d failed for %s: output len = %d\n",
 			       i + 1, algo, req->dlen);
 			ret = -EINVAL;
@@ -1515,7 +1537,7 @@ static int test_acomp(struct crypto_acomp *tfm,
 			goto out;
 		}
 
-		if (memcmp(output, ctemplate[i].output, req->dlen)) {
+		if (memcmp(input_vec, decomp_out, req->dlen)) {
 			pr_err("alg: acomp: Compression test %d failed for %s\n",
 			       i + 1, algo);
 			hexdump(output, req->dlen);
@@ -1593,6 +1615,7 @@ static int test_acomp(struct crypto_acomp *tfm,
 	ret = 0;
 
 out:
+	kfree(decomp_out);
 	kfree(output);
 	return ret;
 }
-- 
2.9.3
