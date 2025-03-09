Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FEAB7482
	for <linux-crypto@vger.kernel.org>; Sun,  9 Mar 2025 02:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741488214; cv=none; b=umyVD3jutKBOzEKj2atd97Ihcs+xmpQRpE6ny60gHjYF0amlqDIKL7ATc2q4zpRiRVk3eIXy8MQtqPQloWx/jnQ+yiwmXBIXEWhe+NS/hi8tO9spi/LJChFwfE/T9Ff7wYCfd07evbMx9KRMWs4ejv5GhkK/odSsDBWKgeVIrRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741488214; c=relaxed/simple;
	bh=LKu+GdSuuk4UtRqA6tVt/r5kcvNv840xSZX10C4qHHM=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=Zcey0aSn4HVp4WjGz2ol1eK2v05wEKvq5Eds9FS8Rg2noW+uM+tOYPBp43Lvd/kkZxkTXEupSNooPhr9UvFVL0ZGVW21kq1IeFJ4NrCEd/4Ve+5i3kkd8YwZb0W1MOamm77HCaa9ejKFTWmJVhdHYBE/NAAN6xSJe9QS70hTNuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Sk/X6sMI; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Sk/X6sMI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=eEvjJihUlyzj8h1KDaV7C5804TZHyfJBqdqnlaKUCYM=; b=Sk/X6sMIHrMJmSV40aoXIs1jAu
	lIn7UKtzEVMhwSm9aDZBXZtNyKSdtajQfpz1/LgmtlvOYkkv5uPCd+jRq+Q+GwU+69iqykzqxkRjV
	v/hvNMCxgyZrOgh+kkUeW5ugwP9wwVxP3IisbpFgu5RZOI+4S3kZ6yPsRif89K//dfYOvbkfSnBji
	4q6zCka8gCKJH8/N25CNbplhUmNGDHbkbafMRUE8p5Hv29B0QuTbrRAG6EBFnQ5/PsiXzGQ0tS8sU
	KrZNb1qAYetGzxeaDtOPPqGmMmIJTIJVkxGx5JgRz2OsxdPuxTlWw6QfZqCMQXM6D8c4rwQlO7rlg
	0t+cl0ag==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tr6dU-004zIU-20;
	Sun, 09 Mar 2025 10:43:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 09 Mar 2025 10:43:28 +0800
Date: Sun, 09 Mar 2025 10:43:28 +0800
Message-Id: <60191b6f89569e8813731f5f99fc7247172ce056.1741488107.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1741488107.git.herbert@gondor.apana.org.au>
References: <cover.1741488107.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v3 PATCH 8/8] crypto: scomp - Add chaining and virtual address
 support
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Kanchana P Sridhar <kanchana.p.sridhar@intel.com>, Sergey Senozhatsky <senozhatsky@chromium.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Add chaining and virtual address support to all scomp algorithms.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/scompress.c | 68 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 50 insertions(+), 18 deletions(-)

diff --git a/crypto/scompress.c b/crypto/scompress.c
index 1f7426c6d85a..c4336151dc84 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -165,7 +165,8 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 	struct scomp_scratch *scratch;
 	unsigned int slen = req->slen;
 	unsigned int dlen = req->dlen;
-	void *src, *dst;
+	const u8 *src;
+	u8 *dst;
 	int ret;
 
 	if (!req->src || !slen)
@@ -174,28 +175,33 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 	if (req->dst && !dlen)
 		return -EINVAL;
 
-	if (sg_nents(req->dst) > 1)
+	if (acomp_request_dst_isvirt(req))
+		dst = req->dvirt;
+	else if (sg_nents(req->dst) > 1)
 		return -ENOSYS;
-
-	if (req->dst->offset >= PAGE_SIZE)
+	else if (req->dst->offset >= PAGE_SIZE)
 		return -ENOSYS;
+	else {
+		if (req->dst->offset + dlen > PAGE_SIZE)
+			dlen = PAGE_SIZE - req->dst->offset;
+		dst = kmap_local_page(sg_page(req->dst)) + req->dst->offset;
+	}
 
-	if (req->dst->offset + dlen > PAGE_SIZE)
-		dlen = PAGE_SIZE - req->dst->offset;
+	scratch = raw_cpu_ptr(&scomp_scratch);
 
-	if (sg_nents(req->src) == 1 && (!PageHighMem(sg_page(req->src)) ||
-					req->src->offset + slen <= PAGE_SIZE))
+	if (acomp_request_src_isvirt(req))
+		src = req->svirt;
+	else if (sg_nents(req->src) == 1 &&
+		 (!PageHighMem(sg_page(req->src)) ||
+		  req->src->offset + slen <= PAGE_SIZE))
 		src = kmap_local_page(sg_page(req->src)) + req->src->offset;
 	else
 		src = scratch->src;
 
-	dst = kmap_local_page(sg_page(req->dst)) + req->dst->offset;
-
-	scratch = raw_cpu_ptr(&scomp_scratch);
 	spin_lock_bh(&scratch->lock);
 
 	if (src == scratch->src)
-		memcpy_from_sglist(src, req->src, 0, req->slen);
+		memcpy_from_sglist(scratch->src, req->src, 0, req->slen);
 
 	stream = raw_cpu_ptr(crypto_scomp_alg(scomp)->stream);
 	spin_lock(&stream->lock);
@@ -208,22 +214,39 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 	spin_unlock(&stream->lock);
 	spin_unlock_bh(&scratch->lock);
 
-	if (src != scratch->src)
+	if (!acomp_request_src_isvirt(req) && src != scratch->src)
 		kunmap_local(src);
-	kunmap_local(dst);
-	flush_dcache_page(sg_page(req->dst));
+
+	if (!acomp_request_dst_isvirt(req)) {
+		kunmap_local(dst);
+		flush_dcache_page(sg_page(req->dst));
+	}
 
 	return ret;
 }
 
+static int scomp_acomp_chain(struct acomp_req *req, int dir)
+{
+	struct acomp_req *r2;
+	int err;
+
+	err = scomp_acomp_comp_decomp(req, dir);
+	req->base.err = err;
+
+	list_for_each_entry(r2, &req->base.list, base.list)
+		r2->base.err = scomp_acomp_comp_decomp(r2, dir);
+
+	return err;
+}
+
 static int scomp_acomp_compress(struct acomp_req *req)
 {
-	return scomp_acomp_comp_decomp(req, 1);
+	return scomp_acomp_chain(req, 1);
 }
 
 static int scomp_acomp_decompress(struct acomp_req *req)
 {
-	return scomp_acomp_comp_decomp(req, 0);
+	return scomp_acomp_chain(req, 0);
 }
 
 static void crypto_exit_scomp_ops_async(struct crypto_tfm *tfm)
@@ -284,12 +307,21 @@ static const struct crypto_type crypto_scomp_type = {
 	.tfmsize = offsetof(struct crypto_scomp, base),
 };
 
-int crypto_register_scomp(struct scomp_alg *alg)
+static void scomp_prepare_alg(struct scomp_alg *alg)
 {
 	struct crypto_alg *base = &alg->calg.base;
 
 	comp_prepare_alg(&alg->calg);
 
+	base->cra_flags |= CRYPTO_ALG_REQ_CHAIN;
+}
+
+int crypto_register_scomp(struct scomp_alg *alg)
+{
+	struct crypto_alg *base = &alg->calg.base;
+
+	scomp_prepare_alg(alg);
+
 	base->cra_type = &crypto_scomp_type;
 	base->cra_flags |= CRYPTO_ALG_TYPE_SCOMPRESS;
 
-- 
2.39.5

