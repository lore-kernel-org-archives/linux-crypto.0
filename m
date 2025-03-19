Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13090253329
	for <linux-crypto@vger.kernel.org>; Wed, 19 Mar 2025 12:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742387515; cv=none; b=OryDR9lZ+yNr7rxHlpdlTaF71POPwU1IuFOmimWoBN8QTdowArd9kaQ8LVrTln7Fw4QEA6nTZXdUeFV+nyNgEjQxPJbThBCk9tFHqpIZ00+w7cWuIbu1BfhmCfxMe6t5AHwQn/0ooYkoM042yA6N8MYuI74jKYsu1oUI9ilsmPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742387515; c=relaxed/simple;
	bh=LsxevvB5nFM6xsefjkXDy+vlGYYgYLZ0JgqdGTyVfIk=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=ICXWmuaRwloALy1UzTcCu07C08zaefLyGu2cQhiUz/SHvPBsqTMalCs4CMq8g3u7WBJh639D3f3BY32ok/Nr28xKZWQVRoQPor5beTfizzG6tagtSrm8ru2kL/fLSv9wvG9xxfOapS5t7pNhm8nSuxyqJgqQrX+8NHnGG+4Os4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=sTxy71FH; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="sTxy71FH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=nVwUdE9HTC/8yO3XuoXy2CW+YxOqZB3IOsm+WSacGYE=; b=sTxy71FHiWwXeYVlEkyjIcIrIw
	wZLKcWUdgbYqZVcOpUceDKy1iB749NqEyAor5AtUj9HaE9zFt+MMkpF+2ycCEr7osvqWNhI1MdvEt
	iB08yVX+77JF66dNpwQBAKG7VLJ+d28Bk2X39OvGIElfdXaRX7gSf3r9GWqGj/XFU4CK9kFw576g1
	VsgnCqK/r6B6DXyqubhIGRXKX83ZOBYfbA7BTocf/DKY8qgXGVKB5+8OfKzFmErI36GqRD3yca8jU
	EAsSrNTlTBCrIKLA1GGJLy1OcETFxfjrIHsF7umQqYfcKKKoPtUZUUOcyF3NbM4AyNc5VtNJkkszZ
	yzx857Lw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tusaL-008Q12-1D;
	Wed, 19 Mar 2025 20:31:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 19 Mar 2025 20:31:49 +0800
Date: Wed, 19 Mar 2025 20:31:49 +0800
Message-Id: <fdbda8c4d075545e424faf24a5f58f824b7186de.1742387288.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1742387288.git.herbert@gondor.apana.org.au>
References: <cover.1742387288.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/3] crypto: scomp - Drop the dst scratch buffer
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

As deflate has been converted over to acomp, and cavium zip has been
removed, there are no longer any scomp algorithms that can be used
by IPsec.

Since IPsec was the only user of the dst scratch buffer, remove it.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/scompress.c | 98 +++++++++++++++++++++-------------------------
 1 file changed, 44 insertions(+), 54 deletions(-)

diff --git a/crypto/scompress.c b/crypto/scompress.c
index 5a40605570f5..4a2b3933aa95 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -25,15 +25,12 @@
 
 #include "compress.h"
 
-#define SCOMP_SCRATCH_SIZE 65400
-
 struct scomp_scratch {
 	spinlock_t	lock;
 	union {
 		void	*src;
 		unsigned long saddr;
 	};
-	void		*dst;
 };
 
 static DEFINE_PER_CPU(struct scomp_scratch, scomp_scratch) = {
@@ -78,9 +75,7 @@ static void crypto_scomp_free_scratches(void)
 		scratch = per_cpu_ptr(&scomp_scratch, i);
 
 		free_page(scratch->saddr);
-		kvfree(scratch->dst);
 		scratch->src = NULL;
-		scratch->dst = NULL;
 	}
 }
 
@@ -88,19 +83,12 @@ static int scomp_alloc_scratch(struct scomp_scratch *scratch, int cpu)
 {
 	int node = cpu_to_node(cpu);
 	struct page *page;
-	void *mem;
 
-	mem = kvmalloc_node(SCOMP_SCRATCH_SIZE, GFP_KERNEL, node);
-	if (!mem)
-		return -ENOMEM;
 	page = alloc_pages_node(node, GFP_KERNEL, 0);
-	if (!page) {
-		kvfree(mem);
+	if (!page)
 		return -ENOMEM;
-	}
 	spin_lock_bh(&scratch->lock);
 	scratch->src = page_address(page);
-	scratch->dst = mem;
 	spin_unlock_bh(&scratch->lock);
 	return 0;
 }
@@ -181,6 +169,8 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 {
 	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
 	struct crypto_scomp **tfm_ctx = acomp_tfm_ctx(tfm);
+	bool src_isvirt = acomp_request_src_isvirt(req);
+	bool dst_isvirt = acomp_request_dst_isvirt(req);
 	struct crypto_scomp *scomp = *tfm_ctx;
 	struct crypto_acomp_stream *stream;
 	struct scomp_scratch *scratch;
@@ -200,13 +190,33 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 	if (!req->dst || !dlen)
 		return -EINVAL;
 
-	stream = crypto_acomp_lock_stream_bh(&crypto_scomp_alg(scomp)->streams);
-	scratch = scomp_lock_scratch();
+	if (dst_isvirt)
+		dst = req->dvirt;
+	else {
+		if (acomp_request_dst_isfolio(req)) {
+			dpage = folio_page(req->dfolio, 0);
+			doff = req->doff;
+		} else if (dlen <= req->dst->length) {
+			dpage = sg_page(req->dst);
+			doff = req->dst->offset;
+		} else
+			return -ENOSYS;
 
-	if (acomp_request_src_isvirt(req))
+		dpage = nth_page(dpage, doff / PAGE_SIZE);
+		doff = offset_in_page(doff);
+
+		n = dlen / PAGE_SIZE;
+		n += (offset_in_page(dlen) + doff - 1) / PAGE_SIZE;
+		if (PageHighMem(dpage + n) &&
+		    size_add(doff, dlen) > PAGE_SIZE)
+			return -ENOSYS;
+		dst = kmap_local_page(dpage) + doff;
+	}
+
+	if (src_isvirt)
 		src = req->svirt;
 	else {
-		src = scratch->src;
+		src = NULL;
 		do {
 			if (acomp_request_src_isfolio(req)) {
 				spage = folio_page(req->sfolio, 0);
@@ -227,57 +237,39 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 				break;
 			src = kmap_local_page(spage) + soff;
 		} while (0);
-
-		if (src == scratch->src)
-			memcpy_from_sglist(scratch->src, req->src, 0, slen);
 	}
 
-	if (acomp_request_dst_isvirt(req))
-		dst = req->dvirt;
-	else {
-		unsigned int max = SCOMP_SCRATCH_SIZE;
+	stream = crypto_acomp_lock_stream_bh(&crypto_scomp_alg(scomp)->streams);
 
-		dst = scratch->dst;
-		do {
-			if (acomp_request_dst_isfolio(req)) {
-				dpage = folio_page(req->dfolio, 0);
-				doff = req->doff;
-			} else if (dlen <= req->dst->length) {
-				dpage = sg_page(req->dst);
-				doff = req->dst->offset;
-			} else
-				break;
+	if (!src_isvirt && !src) {
+		const u8 *src;
 
-			dpage = nth_page(dpage, doff / PAGE_SIZE);
-			doff = offset_in_page(doff);
+		scratch = scomp_lock_scratch();
+		src = scratch->src;
+		memcpy_from_sglist(scratch->src, req->src, 0, slen);
 
-			n = dlen / PAGE_SIZE;
-			n += (offset_in_page(dlen) + doff - 1) / PAGE_SIZE;
-			if (PageHighMem(dpage + n) &&
-			    size_add(doff, dlen) > PAGE_SIZE)
-				break;
-			dst = kmap_local_page(dpage) + doff;
-			max = dlen;
-		} while (0);
-		dlen = min(dlen, max);
-	}
+		if (dir)
+			ret = crypto_scomp_compress(scomp, src, slen,
+						    dst, &dlen, stream->ctx);
+		else
+			ret = crypto_scomp_decompress(scomp, src, slen,
+						      dst, &dlen, stream->ctx);
 
-	if (dir)
+		scomp_unlock_scratch(scratch);
+	} else if (dir)
 		ret = crypto_scomp_compress(scomp, src, slen,
 					    dst, &dlen, stream->ctx);
 	else
 		ret = crypto_scomp_decompress(scomp, src, slen,
 					      dst, &dlen, stream->ctx);
 
-	if (dst == scratch->dst)
-		memcpy_to_sglist(req->dst, 0, dst, dlen);
-
-	scomp_unlock_scratch(scratch);
 	crypto_acomp_unlock_stream_bh(stream);
 
 	req->dlen = dlen;
 
-	if (!acomp_request_dst_isvirt(req) && dst != scratch->dst) {
+	if (!src_isvirt && src)
+		kunmap_local(src);
+	if (!dst_isvirt) {
 		kunmap_local(dst);
 		dlen += doff;
 		for (;;) {
@@ -288,8 +280,6 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 			dpage = nth_page(dpage, 1);
 		}
 	}
-	if (!acomp_request_src_isvirt(req) && src != scratch->src)
-		kunmap_local(src);
 
 	return ret;
 }
-- 
2.39.5

