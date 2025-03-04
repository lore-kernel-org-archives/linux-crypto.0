Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475101FBC86
	for <linux-crypto@vger.kernel.org>; Tue,  4 Mar 2025 09:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741080321; cv=none; b=FBr/w4+KQEXaE2ttZ2Q5N4dy/nPVUggJtS+3Y1+cmvOHCZC7GQq87oip9CPljjwsN/yAH4M4qRcNNAqzVME48gKT+EKG5mC4CDMiZtVbrwT4Q6jXv07h1Nb063bVcIqFleb0lvYw68WcaAz1RZWl4JH9gXuJGgQETOEtaXTLBEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741080321; c=relaxed/simple;
	bh=RTJ9+fuyOem3nUeFavNPKUwJrdxUt7N0Hj1qpRJSm6U=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=ZIKoLBqUQRScp4ADeTb1wepK6XTzuoxjQWpf8sNq9JI/HTRf6DZpGWIowgaaagFPLOV45Sb0A5sG6GQxdll+uE61rBiG5lzs/14IgoEiSjdVaVJ4FdRFgG7Dvk88J09kRR5t5Xmv17QkWtQ+JmqnFEtGbYrZHaw1NMp9MQzwpxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=SHf5JXLH; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="SHf5JXLH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=gIqcHUXrW/VV9CB31vd0AlriCi6IJXCee7ucb3EsjSo=; b=SHf5JXLHQMZKrDgv1yUviFGqGV
	+tUxoSsnOQNrj+h3TcgQ6jwXn3ZDN4qo0MAMCDRPQUintBhiqHM0QkqMB5VW7gszVOJqh/KBOqEPT
	VwqRZUA88TE9QKQON7+UosLPS8nnuHgbTfVi67vd/CKbI0jfo2CbzLS7NUeLk8FEwVVxExkd8rAM0
	1Hr+4YK6pUfHqawcilKRyS1mLgRRvm//py+avvWaZipzGv474xPgy+Fx5j+/K0VsX9NUWfnrjgoUE
	skQ7GGAff6TlYpoz/+uvkJ1F0H1gePDQcP8OOeEt9cYBRYer2MALM4VfJCsU//okVBEv8p/S6iQAJ
	OlpQchcg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tpOWZ-003a3P-14;
	Tue, 04 Mar 2025 17:25:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 04 Mar 2025 17:25:15 +0800
Date: Tue, 04 Mar 2025 17:25:15 +0800
Message-Id: <7fb4bea494ba06ec8c8f7bb3af5af2b478615edd.1741080140.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1741080140.git.herbert@gondor.apana.org.au>
References: <cover.1741080140.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 6/7] crypto: scomp - Add chaining and virtual address
 support
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: linux-mm@kvack.org, Yosry Ahmed <yosry.ahmed@linux.dev>, Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Add chaining and virtual address support to all scomp algorithms.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/scompress.c | 82 +++++++++++++++++++++++++++++++---------------
 1 file changed, 56 insertions(+), 26 deletions(-)

diff --git a/crypto/scompress.c b/crypto/scompress.c
index d78f307343ac..8ef2d71ad908 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -116,7 +116,8 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 	struct scomp_scratch *scratch;
 	unsigned int slen = req->slen;
 	unsigned int dlen = req->dlen;
-	void *src, *dst;
+	const u8 *src;
+	u8 *dst;
 	int ret;
 
 	if (!req->src || !slen)
@@ -125,28 +126,32 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 	if (req->dst && !dlen)
 		return -EINVAL;
 
-	if (sg_nents(req->dst) > 1)
-		return -ENOSYS;
-
-	if (req->dst->offset >= PAGE_SIZE)
-		return -ENOSYS;
-
-	if (req->dst->offset + dlen > PAGE_SIZE)
-		dlen = PAGE_SIZE - req->dst->offset;
-
-	if (sg_nents(req->src) == 1 && (!PageHighMem(sg_page(req->src)) ||
-					req->src->offset + slen <= PAGE_SIZE))
-		src = kmap_local_page(sg_page(req->src)) + req->src->offset;
-	else
-		src = scratch->src;
-
-	dst = kmap_local_page(sg_page(req->dst)) + req->dst->offset;
-
 	scratch = raw_cpu_ptr(&scomp_scratch);
+
+	if (acomp_request_isvirt(req)) {
+		src = req->svirt;
+		dst = req->dvirt;
+	} else if (sg_nents(req->dst) > 1)
+		return -ENOSYS;
+	else if (req->dst->offset >= PAGE_SIZE)
+		return -ENOSYS;
+	else {
+		if (req->dst->offset + dlen > PAGE_SIZE)
+			dlen = PAGE_SIZE - req->dst->offset;
+
+		src = scratch->src;
+		if (sg_nents(req->src) == 1 &&
+		    (!PageHighMem(sg_page(req->src)) ||
+		     req->src->offset + slen <= PAGE_SIZE))
+			src = kmap_local_page(sg_page(req->src)) + req->src->offset;
+
+		dst = kmap_local_page(sg_page(req->dst)) + req->dst->offset;
+	}
+
 	spin_lock(&scratch->lock);
 
 	if (src == scratch->src)
-		memcpy_from_sglist(src, req->src, 0, req->slen);
+		memcpy_from_sglist(scratch->src, req->src, 0, req->slen);
 
 	if (dir)
 		ret = crypto_scomp_compress(scomp, src, slen,
@@ -157,22 +162,38 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 
 	spin_unlock(&scratch->lock);
 
-	if (src != scratch->src)
-		kunmap_local(src);
-	kunmap_local(dst);
-	flush_dcache_page(sg_page(req->dst));
+	if (!acomp_request_isvirt(req)) {
+		if (src != scratch->src)
+			kunmap_local(src);
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
@@ -259,12 +280,21 @@ static const struct crypto_type crypto_scomp_type = {
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

