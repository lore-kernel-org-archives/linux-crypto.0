Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D948D21C18F
	for <linux-crypto@vger.kernel.org>; Thu, 27 Feb 2025 10:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740651312; cv=none; b=q0a3syfk3REMAU6GHN0NuWyasml9gsT1AVF5oPpt0rOULckmexTR1UVNw235TncYrrGJwD4E4n0en3z1P7VeTKIBXraFoOY4AfwkrxXdlgID/Z2+Sj8RuW33T0SpqRI26t5rz2/3ALmjs+EijifLMEzJ3YspCpzZkKqwZTHZBL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740651312; c=relaxed/simple;
	bh=1jARPtAmFsaLvJekNHw+PWq7V3+RxW/pqlYL27SWt78=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=d076uO+4eDAsrWryvqsmueDH+yefKx+G4wU+LJAi5i2Qh4qXacEACLcHoHB2fKsT1QTAdRcAxy23yBonXbjmEizIIiPIBGTzJ2DOMAXJ1dBygeLqV+r/uCZ7495P5M3SrqWJ4SgRJDpjssjn/cPU1SWSL4Kse7SIEh9Ex+OTCSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=iAONUVb0; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="iAONUVb0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ilEUmOuJANO5dYUHK6+31dmZkztFgxSS5iQ9gGn3/Q8=; b=iAONUVb0h3CbuPNKOX0ujTia2G
	YLBdZRAGx1POwTLzZCEAW3gweMXf3M6/GT8nzhYlrV1aFlDelzPMYcoRHpupZByvwSN7O3BkA/gDa
	8EtkM5M5IRIWjQcW/KO1fx2dg6gBCsrwbJRUyOarfnCdJraHq7jghYoceHbFwLhOLtLFGlL86w3Q3
	ysRx4etPOnaO1CAzOrwVW+q7WWYD6rmxiOtDnr4uJiPHywXT8Vhlph1wBziPsNakoha0zw75mcmo2
	XsNUwHHcyCVnQ9MwxrZThD1lg76JUz0UgZzu1Gv3LrCZMHqysCrXadKJadAzm2/hbeQ3+tnXOkFhO
	6RD1NXkw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tnav5-002Drd-0Y;
	Thu, 27 Feb 2025 18:15:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 27 Feb 2025 18:15:07 +0800
Date: Thu, 27 Feb 2025 18:15:07 +0800
Message-Id: <b135b8db00cdd8e5a97f9758617cfe1648bda5fb.1740651138.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1740651138.git.herbert@gondor.apana.org.au>
References: <cover.1740651138.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6/7] crypto: scomp - Add chaining and virtual address support
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: linux-mm@kvack.org, Yosry Ahmed <yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Add chaining and virtual address support to all scomp algorithms.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/scompress.c | 62 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 46 insertions(+), 16 deletions(-)

diff --git a/crypto/scompress.c b/crypto/scompress.c
index ffc8e7f4862c..e94ea9c1685b 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -58,7 +58,8 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 	void **ctx = acomp_request_ctx(req);
 	unsigned int slen = req->slen;
 	unsigned int dlen = req->dlen;
-	void *src, *dst;
+	const u8 *src;
+	u8 *dst;
 	int ret;
 
 	if (!req->src || !slen)
@@ -70,20 +71,24 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 	if (!req->dst || !dlen)
 		return -ENOSYS;
 
-	if (sg_nents(req->src) > 1 || req->src->offset + slen > PAGE_SIZE)
+	if (acomp_request_isvirt(req)) {
+		src = req->svirt;
+		dst = req->dvirt;
+	} else if (sg_nents(req->src) > 1 ||
+		   req->src->offset + slen > PAGE_SIZE)
 		return -ENOSYS;
-
-	if (sg_nents(req->dst) > 1)
+	else if (sg_nents(req->dst) > 1)
 		return -ENOSYS;
-
-	if (req->dst->offset >= PAGE_SIZE)
+	else if (req->dst->offset >= PAGE_SIZE)
 		return -ENOSYS;
+	else {
 
-	if (req->dst->offset + dlen > PAGE_SIZE)
-		dlen = PAGE_SIZE - req->dst->offset;
+		if (req->dst->offset + dlen > PAGE_SIZE)
+			dlen = PAGE_SIZE - req->dst->offset;
 
-	src = kmap_local_page(sg_page(req->src)) + req->src->offset;
-	dst = kmap_local_page(sg_page(req->dst)) + req->dst->offset;
+		src = kmap_local_page(sg_page(req->src)) + req->src->offset;
+		dst = kmap_local_page(sg_page(req->dst)) + req->dst->offset;
+	}
 
 	if (dir)
 		ret = crypto_scomp_compress(scomp, src, slen,
@@ -92,21 +97,37 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 		ret = crypto_scomp_decompress(scomp, src, slen,
 					      dst, &req->dlen, *ctx);
 
-	kunmap_local(src);
-	kunmap_local(dst);
-	flush_dcache_page(sg_page(req->dst));
+	if (!acomp_request_isvirt(req)) {
+		kunmap_local(src);
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
@@ -188,12 +209,21 @@ static const struct crypto_type crypto_scomp_type = {
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

