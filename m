Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412A028A72C;
	Thu,  8 May 2025 19:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746733301; cv=none; b=AHCdmpNo3W1M5Nc5qLhKIRA7D9ZvKwbCOalhgcUekOSzldrRgwppVKSCe8KaMjNMIg6ekQTLOJ1qKnhw0EnufSvk7uwGK3dB+z/2IMylNqJ9Fcq5vS30dpXtguCJSzxe9++HAK19CcaJhazDmTUOowYw+N9CQKlI0Sb4nYWegWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746733301; c=relaxed/simple;
	bh=YCqkHG3xgUw0fvPeOxdezVgACk/mFbGDzGAv8tGRuL4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kKHATpC+BRe1ner/4h7NxhBQxEZI+GHOz6dInCAwfU7lKvIqZVckxW7qw0hl8MrGisz+ekktCkeUnsVEWBgt6q0g4m0OC4FqScl3wGxq4AXSuzVce3sbm34r97DtgmhbFWsTKVZoChanbSZpJsKVZGyg6scN9seLhFSfhAwpiRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FWQyrU0S; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FWQyrU0S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746733300; x=1778269300;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YCqkHG3xgUw0fvPeOxdezVgACk/mFbGDzGAv8tGRuL4=;
  b=FWQyrU0Sg6Xs3kutgkpQBQ+1ThKSEtpoIIXwf/G2LMjzEjRPet3QWwp5
   idAIfDmifnTC1mpQN8+hK+6P2QPD+4fQagBNJ1FrECx2p74HhP+viozsO
   Ip2CWR1AEUCUvJeFryJWQM783LC0X/1SdNTjVfKp+SVsCseAJbVO2AMen
   AwP2PjLpevdtwGRH+31I0giv3T0Bt6JkPsPhqKIzkPphG3+JwOiBqXw1p
   5Nl1QIqCt6D5Aks2V9IQZjEtRF+EH1i12CFH5zAPawKMCofZU5+bPcWMi
   EdxlgJqQmdgDFb7cbY0j5I/ytHURZfNrSw6jAineaN1TKtQnDmjIFFBz5
   Q==;
X-CSE-ConnectionGUID: XFqzR4UVT46pSrmLqIE1ZQ==
X-CSE-MsgGUID: /Yr30N6hTn6JLq06eNkcMA==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="48454584"
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="48454584"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 12:41:37 -0700
X-CSE-ConnectionGUID: yM5zIuQQRZCqLLboMQkZww==
X-CSE-MsgGUID: 26z8tzPSTGyf9K7o1iXnaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="136880818"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa010.fm.intel.com with ESMTP; 08 May 2025 12:41:36 -0700
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	usamaarif642@gmail.com,
	ryan.roberts@arm.com,
	21cnbao@gmail.com,
	ying.huang@linux.alibaba.com,
	akpm@linux-foundation.org,
	senozhatsky@chromium.org,
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	clabbe@baylibre.com,
	ardb@kernel.org,
	ebiggers@google.com,
	surenb@google.com,
	kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com
Cc: wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v9 03/19] Revert "crypto: testmgr - Add multibuffer acomp testing"
Date: Thu,  8 May 2025 12:41:18 -0700
Message-Id: <20250508194134.28392-4-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250508194134.28392-1-kanchana.p.sridhar@intel.com>
References: <20250508194134.28392-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit 99585c2192cb1ce212876e82ef01d1c98c7f4699.

Remove the acomp multibuffer tests so that the interface can be
redesigned.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/testmgr.c | 147 +++++++++++++++++++++--------------------------
 1 file changed, 64 insertions(+), 83 deletions(-)

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
-
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
+	output = kmalloc(COMP_BUF_SIZE, GFP_KERNEL);
+	if (!output)
+		return -ENOMEM;
 
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
-		}
-
-		crypto_wait_req(crypto_acomp_decompress(req), &wait);
-		for (j = 0; j < MAX_MB_MSGS; j++) {
-			ret = reqs[j]->base.err;
-			if (ret) {
-				pr_err("alg: acomp: compression failed on test %d (%d) for %s: ret=%d\n",
-				       i + 1, j, algo, -ret);
-				kfree(input_vec);
-				goto out;
-			}
+		acomp_request_set_params(req, &src, &dst, ilen, dlen);
 
-			if (reqs[j]->dlen != ctemplate[i].inlen) {
-				pr_err("alg: acomp: Compression test %d (%d) failed for %s: output len = %d\n",
-				       i + 1, j, algo, reqs[j]->dlen);
-				ret = -EINVAL;
-				kfree(input_vec);
-				goto out;
-			}
+		ret = crypto_wait_req(crypto_acomp_decompress(req), &wait);
+		if (ret) {
+			pr_err("alg: acomp: compression failed on test %d for %s: ret=%d\n",
+			       i + 1, algo, -ret);
+			kfree(input_vec);
+			acomp_request_free(req);
+			goto out;
+		}
 
-			if (memcmp(input_vec, decomp_out[j], reqs[j]->dlen)) {
-				pr_err("alg: acomp: Compression test %d (%d) failed for %s\n",
-				       i + 1, j, algo);
-				hexdump(output[j], reqs[j]->dlen);
-				ret = -EINVAL;
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
+
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
2.27.0

