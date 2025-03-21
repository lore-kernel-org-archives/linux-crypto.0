Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284E21EFFA0
	for <linux-crypto@vger.kernel.org>; Fri, 21 Mar 2025 08:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742546621; cv=none; b=tqOHokaua478zQQWqeqwwb6wcUgfDEILKkSKIQ5cZbfX1kpsS3tcvFEBWw20yhbxpY9phmWyJQmDC7qzaR6XYDvVqKZzDiVZjTg6tseaD5+4y9FDOdmYBnvGX3jVxHk0f+3JtxGkKAlWxnMNoVO53mFTUd5VuPVMVW8mbmfi/L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742546621; c=relaxed/simple;
	bh=jCyJDgo+g8dZGbTbAe1jAwrRdVAI3bRWc1ZAVdGX5Co=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=XQb/5LYOWo4TosLCfWAZSiWO0HkOPfSwH7TTwJiKV1wt6moWpdU6e1A/tSYV4tZlpdCQdO2bCwU4FoipSJ3zjTu+RCWEwih/awW17afbQExLOFszPwA2y9Hq9oMyS44fzyt+ZuuXnbUHk/NfSk4m7SE1ziq7lOmDO+7VQ8DxuHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=d+WAHNxV; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="d+WAHNxV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=o9NG1hls8IZWMonn8boTkJIhJqkFDavqPhGqIk8cN7Y=; b=d+WAHNxV4j9Os5bRwQebAE6BDq
	G+XexQOgVmqrSr48qOlGLdttySnnw6B3VLmZTmSBdTNavH+aKQU11NhytoviZO5qtCRFZBjqxuCwY
	GqHrMXMwfgq9yOKg5u950vtMcPeLWWPcE18dzBHkd207YcrAv1Ai/I+M8XPomZkaPXJsqurgBmHSe
	hGaM0XDEV7Nm58pc+/moyp/0x11wDzTuRkeiF0aWzoSKwTmOhEnFZIVKVKaEdSyjP/TjX6b3COCi+
	lcOIRewi0uQAfA6vxxPK/uGWIc6ua1SJXNt5npgRgrNjpm+RqZL8bEkETfQMz64tcy0AbPWQ7zvqt
	FNJHpGhQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tvXyZ-008xw9-0h;
	Fri, 21 Mar 2025 16:43:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Mar 2025 16:43:35 +0800
Date: Fri, 21 Mar 2025 16:43:35 +0800
Message-Id: <342e2c0e357e71a03fa0641929069ae908b9ff28.1742546178.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1742546178.git.herbert@gondor.apana.org.au>
References: <cover.1742546178.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/4] crypto: testmgr - Add multibuffer acomp testing
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Add rudimentary multibuffer acomp testing.  Testing coverage is
extended to compression vectors only.  However, as the compression
vectors are compressed and then decompressed, this covers both
compression and decompression.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/testmgr.c | 142 ++++++++++++++++++++++++++---------------------
 1 file changed, 79 insertions(+), 63 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 5694901e5242..02016ae7c7dd 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -3544,27 +3544,48 @@ static int test_acomp(struct crypto_acomp *tfm,
 		      int ctcount, int dtcount)
 {
 	const char *algo = crypto_tfm_alg_driver_name(crypto_acomp_tfm(tfm));
-	unsigned int i;
-	char *output, *decomp_out;
-	int ret;
-	struct scatterlist src, dst;
-	struct acomp_req *req;
+	struct scatterlist *src = NULL, *dst = NULL;
+	struct acomp_req *reqs[MAX_MB_MSGS] = {};
+	char *decomp_out[MAX_MB_MSGS] = {};
+	char *output[MAX_MB_MSGS] = {};
 	struct crypto_wait wait;
+	struct acomp_req *req;
+	int ret = -ENOMEM;
+	unsigned int i;
 
-	output = kmalloc(COMP_BUF_SIZE, GFP_KERNEL);
-	if (!output)
-		return -ENOMEM;
+	src = kmalloc_array(MAX_MB_MSGS, sizeof(*src), GFP_KERNEL);
+	if (!src)
+		goto out;
+	dst = kmalloc_array(MAX_MB_MSGS, sizeof(*dst), GFP_KERNEL);
+	if (!dst)
+		goto out;
 
-	decomp_out = kmalloc(COMP_BUF_SIZE, GFP_KERNEL);
-	if (!decomp_out) {
-		kfree(output);
-		return -ENOMEM;
+	for (i = 0; i < MAX_MB_MSGS; i++) {
+		reqs[i] = acomp_request_alloc(tfm);
+		if (!reqs[i])
+			goto out;
+
+		acomp_request_set_callback(reqs[i],
+					   CRYPTO_TFM_REQ_MAY_SLEEP |
+					   CRYPTO_TFM_REQ_MAY_BACKLOG,
+					   crypto_req_done, &wait);
+		if (i)
+			acomp_request_chain(reqs[i], reqs[0]);
+
+		output[i] = kmalloc(COMP_BUF_SIZE, GFP_KERNEL);
+		if (!output[i])
+			goto out;
+
+		decomp_out[i] = kmalloc(COMP_BUF_SIZE, GFP_KERNEL);
+		if (!decomp_out[i])
+			goto out;
 	}
 
 	for (i = 0; i < ctcount; i++) {
 		unsigned int dlen = COMP_BUF_SIZE;
 		int ilen = ctemplate[i].inlen;
 		void *input_vec;
+		int j;
 
 		input_vec = kmemdup(ctemplate[i].input, ilen, GFP_KERNEL);
 		if (!input_vec) {
@@ -3572,70 +3593,61 @@ static int test_acomp(struct crypto_acomp *tfm,
 			goto out;
 		}
 
-		memset(output, 0, dlen);
 		crypto_init_wait(&wait);
-		sg_init_one(&src, input_vec, ilen);
-		sg_init_one(&dst, output, dlen);
+		sg_init_one(src, input_vec, ilen);
 
-		req = acomp_request_alloc(tfm);
-		if (!req) {
-			pr_err("alg: acomp: request alloc failed for %s\n",
-			       algo);
-			kfree(input_vec);
-			ret = -ENOMEM;
-			goto out;
+		for (j = 0; j < MAX_MB_MSGS; j++) {
+			sg_init_one(dst + j, output[j], dlen);
+			acomp_request_set_params(reqs[j], src, dst + j, ilen, dlen);
 		}
 
-		acomp_request_set_params(req, &src, &dst, ilen, dlen);
-		acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-					   crypto_req_done, &wait);
-
+		req = reqs[0];
 		ret = crypto_wait_req(crypto_acomp_compress(req), &wait);
 		if (ret) {
 			pr_err("alg: acomp: compression failed on test %d for %s: ret=%d\n",
 			       i + 1, algo, -ret);
 			kfree(input_vec);
-			acomp_request_free(req);
 			goto out;
 		}
 
 		ilen = req->dlen;
 		dlen = COMP_BUF_SIZE;
-		sg_init_one(&src, output, ilen);
-		sg_init_one(&dst, decomp_out, dlen);
 		crypto_init_wait(&wait);
-		acomp_request_set_params(req, &src, &dst, ilen, dlen);
-
-		ret = crypto_wait_req(crypto_acomp_decompress(req), &wait);
-		if (ret) {
-			pr_err("alg: acomp: compression failed on test %d for %s: ret=%d\n",
-			       i + 1, algo, -ret);
-			kfree(input_vec);
-			acomp_request_free(req);
-			goto out;
+		for (j = 0; j < MAX_MB_MSGS; j++) {
+			sg_init_one(src + j, output[j], ilen);
+			sg_init_one(dst + j, decomp_out[j], dlen);
+			acomp_request_set_params(reqs[j], src + j, dst + j, ilen, dlen);
 		}
 
-		if (req->dlen != ctemplate[i].inlen) {
-			pr_err("alg: acomp: Compression test %d failed for %s: output len = %d\n",
-			       i + 1, algo, req->dlen);
-			ret = -EINVAL;
-			kfree(input_vec);
-			acomp_request_free(req);
-			goto out;
-		}
+		crypto_wait_req(crypto_acomp_decompress(req), &wait);
+		for (j = 0; j < MAX_MB_MSGS; j++) {
+			ret = reqs[j]->base.err;
+			if (ret) {
+				pr_err("alg: acomp: compression failed on test %d (%d) for %s: ret=%d\n",
+				       i + 1, j, algo, -ret);
+				kfree(input_vec);
+				goto out;
+			}
 
-		if (memcmp(input_vec, decomp_out, req->dlen)) {
-			pr_err("alg: acomp: Compression test %d failed for %s\n",
-			       i + 1, algo);
-			hexdump(output, req->dlen);
-			ret = -EINVAL;
-			kfree(input_vec);
-			acomp_request_free(req);
-			goto out;
+			if (reqs[j]->dlen != ctemplate[i].inlen) {
+				pr_err("alg: acomp: Compression test %d (%d) failed for %s: output len = %d\n",
+				       i + 1, j, algo, reqs[j]->dlen);
+				ret = -EINVAL;
+				kfree(input_vec);
+				goto out;
+			}
+
+			if (memcmp(input_vec, decomp_out[j], reqs[j]->dlen)) {
+				pr_err("alg: acomp: Compression test %d (%d) failed for %s\n",
+				       i + 1, j, algo);
+				hexdump(output[j], reqs[j]->dlen);
+				ret = -EINVAL;
+				kfree(input_vec);
+				goto out;
+			}
 		}
 
 		kfree(input_vec);
-		acomp_request_free(req);
 	}
 
 	for (i = 0; i < dtcount; i++) {
@@ -3649,10 +3661,9 @@ static int test_acomp(struct crypto_acomp *tfm,
 			goto out;
 		}
 
-		memset(output, 0, dlen);
 		crypto_init_wait(&wait);
-		sg_init_one(&src, input_vec, ilen);
-		sg_init_one(&dst, output, dlen);
+		sg_init_one(src, input_vec, ilen);
+		sg_init_one(dst, output[0], dlen);
 
 		req = acomp_request_alloc(tfm);
 		if (!req) {
@@ -3663,7 +3674,7 @@ static int test_acomp(struct crypto_acomp *tfm,
 			goto out;
 		}
 
-		acomp_request_set_params(req, &src, &dst, ilen, dlen);
+		acomp_request_set_params(req, src, dst, ilen, dlen);
 		acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
 					   crypto_req_done, &wait);
 
@@ -3685,10 +3696,10 @@ static int test_acomp(struct crypto_acomp *tfm,
 			goto out;
 		}
 
-		if (memcmp(output, dtemplate[i].output, req->dlen)) {
+		if (memcmp(output[0], dtemplate[i].output, req->dlen)) {
 			pr_err("alg: acomp: Decompression test %d failed for %s\n",
 			       i + 1, algo);
-			hexdump(output, req->dlen);
+			hexdump(output[0], req->dlen);
 			ret = -EINVAL;
 			kfree(input_vec);
 			acomp_request_free(req);
@@ -3702,8 +3713,13 @@ static int test_acomp(struct crypto_acomp *tfm,
 	ret = 0;
 
 out:
-	kfree(decomp_out);
-	kfree(output);
+	acomp_request_free(reqs[0]);
+	for (i = 0; i < MAX_MB_MSGS; i++) {
+		kfree(output[i]);
+		kfree(decomp_out[i]);
+	}
+	kfree(dst);
+	kfree(src);
 	return ret;
 }
 
-- 
2.39.5

