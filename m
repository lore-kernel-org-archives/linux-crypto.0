Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F5A225779
	for <linux-crypto@vger.kernel.org>; Thu,  1 May 2025 12:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746103063; cv=none; b=Vyk8YEz4Zc5pfcByrCWnKdfgG4lnG0yYXkntVT9v6pLnmsxD8wFOurQUdW1ivUIcI1/0Ay+TjWJwSwFJmWaOqv+LVDCTEQ2PocROdceM5hUiA33t/8SXAj9i/gY4o533QOyhYJTw9bS4YJeZi6sxvCkd62keuPt7VDaV2FjBfI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746103063; c=relaxed/simple;
	bh=HM6EgddskCXkChxjeffRHjfo09SxOqTMaeSYRUxITqg=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=VItQIJ1Wq+CmqBPHYcmz22++cNeViMNCtzHrqUtPahBdTbfM0p14gUrtToVP8P7zaYUOpArYOZXxVaPiAD3r9FsHyeO9op69jIFwQi6m1NDsbBIboLGd6d657IwbAQUFshiPTt23uaIDhpAU2jZPSPpMPIjn9JW4c7J3MZGcQQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=D3pJjDYU; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="D3pJjDYU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=2Nq7gFsQkFTi60kydWjc5/MHbyTJyziFWtOylmEcKLM=; b=D3pJjDYU3P/OuWj6JRC5hkkYoc
	bjTMPz+2Yp6jaql9BAs5RKyv0u3U8j7yY7h9GzZAK+LxL6OUtYWhSH12phJ6FuVVYVmlzGpEQpMrS
	oyQBJJ7IvQY/85XbUSI8GF7xotudtRaDWyHe0pzlC/9Jvx4XTDSvgTvHdp/FgdJRsiwEciSQYWQhk
	2Ek54Pe5LmYGNVew2a461INn8Tj/KR44HQl6uPVpOXhNkm+eHK/80Y40EX3H5iz/zwDybx1Wkzg+O
	kcP704yXBgKx2yUHiCOsLkP9Wmg8iaAQk7ZcLW4reQ0QKfwNZvDQUDO1J9dIRZQrQjkmuOTcFoZlN
	PHnIpbsQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uATAX-002bFW-1T;
	Thu, 01 May 2025 20:37:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 01 May 2025 20:37:37 +0800
Date: Thu, 01 May 2025 20:37:37 +0800
Message-Id: <79dc6c03779a179e3cf9eae95142e3858d5979ee.1746102673.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1746102673.git.herbert@gondor.apana.org.au>
References: <cover.1746102673.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/4] crypto: testmgr - Add multibuffer acomp testing
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Add rudimentary multibuffer acomp testing.  Testing coverage is
extended to compression vectors only.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/testmgr.c | 145 +++++++++++++++++++++++------------------------
 1 file changed, 72 insertions(+), 73 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 82977ea25db3..68f295923ea7 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -58,6 +58,9 @@ module_param(fuzz_iterations, uint, 0644);
 MODULE_PARM_DESC(fuzz_iterations, "number of fuzz test iterations");
 #endif
 
+/* Multibuffer is unlimited.  Set arbitrary limit for testing. */
+#define MAX_MB_MSGS	16
+
 #ifdef CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
 
 /* a perfect nop */
@@ -3326,14 +3329,19 @@ static int test_acomp(struct crypto_acomp *tfm,
 		      int ctcount, int dtcount)
 {
 	const char *algo = crypto_tfm_alg_driver_name(crypto_acomp_tfm(tfm));
-	unsigned int i;
+	struct scatterlist src[MAX_MB_MSGS], dst[2];
+	ACOMP_REQUEST_ON_STACK(req, tfm);
 	char *output, *decomp_out;
-	int ret;
-	struct scatterlist src, dst;
-	struct acomp_req *req;
 	struct crypto_wait wait;
+	int ret = -ENOMEM;
+	unsigned int i;
 
-	output = kmalloc(COMP_BUF_SIZE, GFP_KERNEL);
+	acomp_request_set_callback(req,
+				   CRYPTO_TFM_REQ_MAY_SLEEP |
+				   CRYPTO_TFM_REQ_MAY_BACKLOG,
+				   NULL, NULL);
+
+	output = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!output)
 		return -ENOMEM;
 
@@ -3346,7 +3354,9 @@ static int test_acomp(struct crypto_acomp *tfm,
 	for (i = 0; i < ctcount; i++) {
 		unsigned int dlen = COMP_BUF_SIZE;
 		int ilen = ctemplate[i].inlen;
+		struct scatterlist *sg;
 		void *input_vec;
+		int j;
 
 		input_vec = kmemdup(ctemplate[i].input, ilen, GFP_KERNEL);
 		if (!input_vec) {
@@ -3354,70 +3364,74 @@ static int test_acomp(struct crypto_acomp *tfm,
 			goto out;
 		}
 
-		memset(output, 0, dlen);
 		crypto_init_wait(&wait);
-		sg_init_one(&src, input_vec, ilen);
-		sg_init_one(&dst, output, dlen);
 
-		req = acomp_request_alloc(tfm);
-		if (!req) {
-			pr_err("alg: acomp: request alloc failed for %s\n",
-			       algo);
-			kfree(input_vec);
-			ret = -ENOMEM;
-			goto out;
+		sg_init_table(src, MAX_MB_MSGS);
+		for (j = 0; j < MAX_MB_MSGS; j++)
+			sg_set_buf(src + j, input_vec, ilen);
+
+		sg_init_one(dst, output, PAGE_SIZE);
+		acomp_request_set_src_unit(req, src, MAX_MB_MSGS * ilen,
+					   dst, ilen);
+
+		ret = crypto_acomp_compress(req);
+		if (ret == -EAGAIN) {
+			req = ACOMP_REQUEST_CLONE(req, GFP_KERNEL);
+			acomp_request_set_callback(req,
+						   CRYPTO_TFM_REQ_MAY_SLEEP |
+						   CRYPTO_TFM_REQ_MAY_BACKLOG,
+						   crypto_req_done, &wait);
+			ret = crypto_acomp_compress(req);
+			ret = crypto_wait_req(ret, &wait);
 		}
-
-		acomp_request_set_params(req, &src, &dst, ilen, dlen);
-		acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-					   crypto_req_done, &wait);
-
-		ret = crypto_wait_req(crypto_acomp_compress(req), &wait);
 		if (ret) {
 			pr_err("alg: acomp: compression failed on test %d for %s: ret=%d\n",
 			       i + 1, algo, -ret);
 			kfree(input_vec);
-			acomp_request_free(req);
 			goto out;
 		}
 
-		ilen = req->dlen;
+		sg = dst;
+		ilen = sg->length;
 		dlen = COMP_BUF_SIZE;
-		sg_init_one(&src, output, ilen);
-		sg_init_one(&dst, decomp_out, dlen);
-		crypto_init_wait(&wait);
-		acomp_request_set_params(req, &src, &dst, ilen, dlen);
+		for (j = 0; j < MAX_MB_MSGS; j++) {
+			sg_init_one(src, decomp_out, dlen);
+			acomp_request_set_params(req, sg, src, ilen, dlen);
+			crypto_init_wait(&wait);
+			ret = crypto_wait_req(crypto_acomp_decompress(req), &wait);
+			if (ret) {
+				pr_err("alg: acomp: re-decompression failed on test %d (%d) for %s: ret=%d\n",
+				       i + 1, j, algo, -ret);
+				acomp_free_sgl(dst);
+				kfree(input_vec);
+				goto out;
+			}
 
-		ret = crypto_wait_req(crypto_acomp_decompress(req), &wait);
-		if (ret) {
-			pr_err("alg: acomp: compression failed on test %d for %s: ret=%d\n",
-			       i + 1, algo, -ret);
-			kfree(input_vec);
-			acomp_request_free(req);
-			goto out;
-		}
-
-		if (req->dlen != ctemplate[i].inlen) {
-			pr_err("alg: acomp: Compression test %d failed for %s: output len = %d\n",
-			       i + 1, algo, req->dlen);
-			ret = -EINVAL;
-			kfree(input_vec);
-			acomp_request_free(req);
-			goto out;
-		}
-
-		if (memcmp(input_vec, decomp_out, req->dlen)) {
-			pr_err("alg: acomp: Compression test %d failed for %s\n",
-			       i + 1, algo);
-			hexdump(output, req->dlen);
-			ret = -EINVAL;
-			kfree(input_vec);
-			acomp_request_free(req);
-			goto out;
+			if (req->dlen != ctemplate[i].inlen) {
+				pr_err("alg: acomp: Compression test %d (%d) failed for %s: output len = %d\n",
+				       i + 1, j, algo, req->dlen);
+				ret = -EINVAL;
+				acomp_free_sgl(dst);
+				kfree(input_vec);
+				goto out;
+			}
+
+			if (memcmp(input_vec, decomp_out, req->dlen)) {
+				pr_err("alg: acomp: Compression test %d (%d) failed for %s\n",
+				       i + 1, j, algo);
+				hexdump(output, req->dlen);
+				ret = -EINVAL;
+				acomp_free_sgl(dst);
+				kfree(input_vec);
+				goto out;
+			}
+			if (acomp_sgl_split(sg))
+				sg = sg_next(sg);
+			sg = sg_next(sg);
 		}
 
+		acomp_free_sgl(dst);
 		kfree(input_vec);
-		acomp_request_free(req);
 	}
 
 	for (i = 0; i < dtcount; i++) {
@@ -3431,30 +3445,17 @@ static int test_acomp(struct crypto_acomp *tfm,
 			goto out;
 		}
 
-		memset(output, 0, dlen);
 		crypto_init_wait(&wait);
-		sg_init_one(&src, input_vec, ilen);
-		sg_init_one(&dst, output, dlen);
+		sg_init_one(src, input_vec, ilen);
+		sg_init_one(dst, output, dlen);
 
-		req = acomp_request_alloc(tfm);
-		if (!req) {
-			pr_err("alg: acomp: request alloc failed for %s\n",
-			       algo);
-			kfree(input_vec);
-			ret = -ENOMEM;
-			goto out;
-		}
-
-		acomp_request_set_params(req, &src, &dst, ilen, dlen);
-		acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-					   crypto_req_done, &wait);
+		acomp_request_set_params(req, src, dst, ilen, dlen);
 
 		ret = crypto_wait_req(crypto_acomp_decompress(req), &wait);
 		if (ret) {
 			pr_err("alg: acomp: decompression failed on test %d for %s: ret=%d\n",
 			       i + 1, algo, -ret);
 			kfree(input_vec);
-			acomp_request_free(req);
 			goto out;
 		}
 
@@ -3463,7 +3464,6 @@ static int test_acomp(struct crypto_acomp *tfm,
 			       i + 1, algo, req->dlen);
 			ret = -EINVAL;
 			kfree(input_vec);
-			acomp_request_free(req);
 			goto out;
 		}
 
@@ -3473,17 +3473,16 @@ static int test_acomp(struct crypto_acomp *tfm,
 			hexdump(output, req->dlen);
 			ret = -EINVAL;
 			kfree(input_vec);
-			acomp_request_free(req);
 			goto out;
 		}
 
 		kfree(input_vec);
-		acomp_request_free(req);
 	}
 
 	ret = 0;
 
 out:
+	acomp_request_free(req);
 	kfree(decomp_out);
 	kfree(output);
 	return ret;
-- 
2.39.5

