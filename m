Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DDF7175D39
	for <linux-crypto@vger.kernel.org>; Sat, 12 Apr 2025 05:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744436223; cv=none; b=hmYrLepJBuJXtJyN7swe/RJu/GsCa61asIVm9+PzMdMAPEOhw7JSvUh4a84QskWqA/VVtxukTb1cjmZf3W10R26pbGRTgJdUCDAxnOA3ZfQSoN6bwSfTYQuX8fPoOwHhbmcBdFliq0HOotUcvNyjGxIVMIUcNs8DqWVmAlIFzO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744436223; c=relaxed/simple;
	bh=DKdMVPsqsq08VGzJ9kwLCavo3Acfjiax6KLtF5waozg=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=h0/8KSHa7snvJwWey4tqIjB05wL+QBerCJhuFsNKhyHtV9QETTmQd+L3ZkXwUepjOrJluKF63CIBpK8hczOmYyUYV1FBT9QT1jTzUtV1EbKsKBGPm3oTJv6v2p+uwvQlwLrFsTlv360euU1dwoP9O0vLledSoWF9zw7vQ4ehDmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=srLC3d7f; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="srLC3d7f"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=O+ziDs32lMHl9CITBC9D6jQcooAc+hVOMtWbW4QWCL8=; b=srLC3d7fgJhcgtHGXQr93RsjRH
	BMnR1MQ1G/uy2iSf76yIxrxU9kdUt+xT1957lZWH3ThL04VU+BuAktPzlCMHouW5VYfEIt/xg1gse
	WS1OkF9tmwd0LO0XY8AUNK3uFrVT3QDxO46iIV5rw/Op1Q8bqw+HNHY8289AYeJ3QNGxmandsv+HW
	6gGPA4UwiWqKN8wjBBlagpcAtMXumrtaXosNvnGOi21sBDkMEq1vuH8o5K+cKpQgN+wLvhRMRNFOV
	1h8p2btsDyjF5eu1IfCeO4EROYVg2c18ytpLgPYqGQt69cEXEZn8ZCp0purm4RBVVPmseNSeAJ4d1
	OT+/l1Uw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u3TXv-00F2sL-0Q;
	Sat, 12 Apr 2025 13:36:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 12 Apr 2025 13:36:51 +0800
Date: Sat, 12 Apr 2025 13:36:51 +0800
Message-Id: <cbcaa7d1daee8a9dd518d56da4d424e7631868b0.1744436095.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744436095.git.herbert@gondor.apana.org.au>
References: <cover.1744436095.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 1/5] Revert "crypto: testmgr - Add multibuffer acomp
 testing"
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

This reverts commit 99585c2192cb1ce212876e82ef01d1c98c7f4699.

Remove the acomp multibuffer tests so that the interface can be
redesigned.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/testmgr.c | 145 ++++++++++++++++++++---------------------------
 1 file changed, 63 insertions(+), 82 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index abd609d4c8ef..82977ea25db3 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -58,9 +58,6 @@ module_param(fuzz_iterations, uint, 0644);
 MODULE_PARM_DESC(fuzz_iterations, "number of fuzz test iterations");
 #endif
 
-/* Multibuffer is unlimited.  Set arbitrary limit for testing. */
-#define MAX_MB_MSGS	16
-
 #ifdef CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
 
 /* a perfect nop */
@@ -3329,48 +3326,27 @@ static int test_acomp(struct crypto_acomp *tfm,
 		      int ctcount, int dtcount)
 {
 	const char *algo = crypto_tfm_alg_driver_name(crypto_acomp_tfm(tfm));
-	struct scatterlist *src = NULL, *dst = NULL;
-	struct acomp_req *reqs[MAX_MB_MSGS] = {};
-	char *decomp_out[MAX_MB_MSGS] = {};
-	char *output[MAX_MB_MSGS] = {};
-	struct crypto_wait wait;
-	struct acomp_req *req;
-	int ret = -ENOMEM;
 	unsigned int i;
+	char *output, *decomp_out;
+	int ret;
+	struct scatterlist src, dst;
+	struct acomp_req *req;
+	struct crypto_wait wait;
 
-	src = kmalloc_array(MAX_MB_MSGS, sizeof(*src), GFP_KERNEL);
-	if (!src)
-		goto out;
-	dst = kmalloc_array(MAX_MB_MSGS, sizeof(*dst), GFP_KERNEL);
-	if (!dst)
-		goto out;
+	output = kmalloc(COMP_BUF_SIZE, GFP_KERNEL);
+	if (!output)
+		return -ENOMEM;
 
-	for (i = 0; i < MAX_MB_MSGS; i++) {
-		reqs[i] = acomp_request_alloc(tfm);
-		if (!reqs[i])
-			goto out;
-
-		acomp_request_set_callback(reqs[i],
-					   CRYPTO_TFM_REQ_MAY_SLEEP |
-					   CRYPTO_TFM_REQ_MAY_BACKLOG,
-					   crypto_req_done, &wait);
-		if (i)
-			acomp_request_chain(reqs[i], reqs[0]);
-
-		output[i] = kmalloc(COMP_BUF_SIZE, GFP_KERNEL);
-		if (!output[i])
-			goto out;
-
-		decomp_out[i] = kmalloc(COMP_BUF_SIZE, GFP_KERNEL);
-		if (!decomp_out[i])
-			goto out;
+	decomp_out = kmalloc(COMP_BUF_SIZE, GFP_KERNEL);
+	if (!decomp_out) {
+		kfree(output);
+		return -ENOMEM;
 	}
 
 	for (i = 0; i < ctcount; i++) {
 		unsigned int dlen = COMP_BUF_SIZE;
 		int ilen = ctemplate[i].inlen;
 		void *input_vec;
-		int j;
 
 		input_vec = kmemdup(ctemplate[i].input, ilen, GFP_KERNEL);
 		if (!input_vec) {
@@ -3378,61 +3354,70 @@ static int test_acomp(struct crypto_acomp *tfm,
 			goto out;
 		}
 
+		memset(output, 0, dlen);
 		crypto_init_wait(&wait);
-		sg_init_one(src, input_vec, ilen);
+		sg_init_one(&src, input_vec, ilen);
+		sg_init_one(&dst, output, dlen);
 
-		for (j = 0; j < MAX_MB_MSGS; j++) {
-			sg_init_one(dst + j, output[j], dlen);
-			acomp_request_set_params(reqs[j], src, dst + j, ilen, dlen);
+		req = acomp_request_alloc(tfm);
+		if (!req) {
+			pr_err("alg: acomp: request alloc failed for %s\n",
+			       algo);
+			kfree(input_vec);
+			ret = -ENOMEM;
+			goto out;
 		}
 
-		req = reqs[0];
+		acomp_request_set_params(req, &src, &dst, ilen, dlen);
+		acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+					   crypto_req_done, &wait);
+
 		ret = crypto_wait_req(crypto_acomp_compress(req), &wait);
 		if (ret) {
 			pr_err("alg: acomp: compression failed on test %d for %s: ret=%d\n",
 			       i + 1, algo, -ret);
 			kfree(input_vec);
+			acomp_request_free(req);
 			goto out;
 		}
 
 		ilen = req->dlen;
 		dlen = COMP_BUF_SIZE;
+		sg_init_one(&src, output, ilen);
+		sg_init_one(&dst, decomp_out, dlen);
 		crypto_init_wait(&wait);
-		for (j = 0; j < MAX_MB_MSGS; j++) {
-			sg_init_one(src + j, output[j], ilen);
-			sg_init_one(dst + j, decomp_out[j], dlen);
-			acomp_request_set_params(reqs[j], src + j, dst + j, ilen, dlen);
+		acomp_request_set_params(req, &src, &dst, ilen, dlen);
+
+		ret = crypto_wait_req(crypto_acomp_decompress(req), &wait);
+		if (ret) {
+			pr_err("alg: acomp: compression failed on test %d for %s: ret=%d\n",
+			       i + 1, algo, -ret);
+			kfree(input_vec);
+			acomp_request_free(req);
+			goto out;
 		}
 
-		crypto_wait_req(crypto_acomp_decompress(req), &wait);
-		for (j = 0; j < MAX_MB_MSGS; j++) {
-			ret = reqs[j]->base.err;
-			if (ret) {
-				pr_err("alg: acomp: compression failed on test %d (%d) for %s: ret=%d\n",
-				       i + 1, j, algo, -ret);
-				kfree(input_vec);
-				goto out;
-			}
+		if (req->dlen != ctemplate[i].inlen) {
+			pr_err("alg: acomp: Compression test %d failed for %s: output len = %d\n",
+			       i + 1, algo, req->dlen);
+			ret = -EINVAL;
+			kfree(input_vec);
+			acomp_request_free(req);
+			goto out;
+		}
 
-			if (reqs[j]->dlen != ctemplate[i].inlen) {
-				pr_err("alg: acomp: Compression test %d (%d) failed for %s: output len = %d\n",
-				       i + 1, j, algo, reqs[j]->dlen);
-				ret = -EINVAL;
-				kfree(input_vec);
-				goto out;
-			}
-
-			if (memcmp(input_vec, decomp_out[j], reqs[j]->dlen)) {
-				pr_err("alg: acomp: Compression test %d (%d) failed for %s\n",
-				       i + 1, j, algo);
-				hexdump(output[j], reqs[j]->dlen);
-				ret = -EINVAL;
-				kfree(input_vec);
-				goto out;
-			}
+		if (memcmp(input_vec, decomp_out, req->dlen)) {
+			pr_err("alg: acomp: Compression test %d failed for %s\n",
+			       i + 1, algo);
+			hexdump(output, req->dlen);
+			ret = -EINVAL;
+			kfree(input_vec);
+			acomp_request_free(req);
+			goto out;
 		}
 
 		kfree(input_vec);
+		acomp_request_free(req);
 	}
 
 	for (i = 0; i < dtcount; i++) {
@@ -3446,9 +3431,10 @@ static int test_acomp(struct crypto_acomp *tfm,
 			goto out;
 		}
 
+		memset(output, 0, dlen);
 		crypto_init_wait(&wait);
-		sg_init_one(src, input_vec, ilen);
-		sg_init_one(dst, output[0], dlen);
+		sg_init_one(&src, input_vec, ilen);
+		sg_init_one(&dst, output, dlen);
 
 		req = acomp_request_alloc(tfm);
 		if (!req) {
@@ -3459,7 +3445,7 @@ static int test_acomp(struct crypto_acomp *tfm,
 			goto out;
 		}
 
-		acomp_request_set_params(req, src, dst, ilen, dlen);
+		acomp_request_set_params(req, &src, &dst, ilen, dlen);
 		acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
 					   crypto_req_done, &wait);
 
@@ -3481,10 +3467,10 @@ static int test_acomp(struct crypto_acomp *tfm,
 			goto out;
 		}
 
-		if (memcmp(output[0], dtemplate[i].output, req->dlen)) {
+		if (memcmp(output, dtemplate[i].output, req->dlen)) {
 			pr_err("alg: acomp: Decompression test %d failed for %s\n",
 			       i + 1, algo);
-			hexdump(output[0], req->dlen);
+			hexdump(output, req->dlen);
 			ret = -EINVAL;
 			kfree(input_vec);
 			acomp_request_free(req);
@@ -3498,13 +3484,8 @@ static int test_acomp(struct crypto_acomp *tfm,
 	ret = 0;
 
 out:
-	acomp_request_free(reqs[0]);
-	for (i = 0; i < MAX_MB_MSGS; i++) {
-		kfree(output[i]);
-		kfree(decomp_out[i]);
-	}
-	kfree(dst);
-	kfree(src);
+	kfree(decomp_out);
+	kfree(output);
 	return ret;
 }
 
-- 
2.39.5

