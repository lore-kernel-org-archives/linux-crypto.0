Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF741F8EFA
	for <linux-crypto@vger.kernel.org>; Thu, 13 Mar 2025 05:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741842899; cv=none; b=HPaVZOXO9AYCQAQsBCO/vNMYgTgjpeOVwV/uuwhAm28H4MWLnG3FEzNbQdRKSNEemkErhfolo//gi8iadxWQWgrk5af7EaS/MYTOyNU/RKtuGttKC4mMn/wPmipn3r0iPfbuROd7EB8jW/DBWqdv0MOGvwJumIbXSvuYxwQXOtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741842899; c=relaxed/simple;
	bh=2sNANGKIQIeAXW3LqZFTWdCoXGIVO+gFMkjNbD8MueM=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=ti2k2qbYQX6R85lirZ6P439pTJo0PHYdu3LfonUGHFiWluj1PNlsaUZaJk42LhFeXhDYQMyprCn8eze0wvuzzJWB1qx5787XCbh2wccbdcZJQmV3gSZMVDxNeUabQRsL77OB/yX8fdFZIuK2YQ/5HCnURzSsuQFkEzqfMYkI2Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=s/SAqjhe; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="s/SAqjhe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=LxLyJ5kZwP6rI8UEizqmiW0dxibhaWp/BYfI5Ys2cXg=; b=s/SAqjhexkE69Ewzxb5rP4Lzn3
	1Um3ucC/cILMgo3XcJuuieNK2Aem8T+GzhWWsMGFI4GtUoDweTbBPjSojvfXQfWWDgn2sdxfwbFFj
	eTMSxDGEREYgZNwbbub14Z6+mp2mXV+Hm1hZR9fzz8CwaJUBbhand6U+d+9jCcZtfvmDJ5QAtIsTf
	VuQ5K/hzEflk6ithDvGjXuu70RWKhwvIzQaKYjnsMI+Ej5o2UTxDQFCvKlu9MLb+DupZCVWqrHPME
	I8dC5+bV18a80akk3BczMsiaSywdNjzn5yjVaKqJLGoFc4uUTxq/k7ARCq/woscCT51V1Vj0w2c5M
	m0SBG/YQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tsauD-0068Q6-3A;
	Thu, 13 Mar 2025 13:14:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 13 Mar 2025 13:14:53 +0800
Date: Thu, 13 Mar 2025 13:14:53 +0800
Message-Id: <eee86a8ed9152a79b21c41e900a47279c09c28fe.1741842470.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1741842470.git.herbert@gondor.apana.org.au>
References: <cover.1741842470.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v3 PATCH 1/3] lib/scatterlist: Add SG_MITER_LOCAL and use it
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Add kmap_local support to the scatterlist iterator.  Use it for
all the helper functions in lib/scatterlist.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 include/linux/scatterlist.h |  1 +
 lib/scatterlist.c           | 12 ++++++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index d836e7440ee8..138e2f1bd08f 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -671,6 +671,7 @@ sg_page_iter_dma_address(struct sg_dma_page_iter *dma_iter)
 #define SG_MITER_ATOMIC		(1 << 0)	 /* use kmap_atomic */
 #define SG_MITER_TO_SG		(1 << 1)	/* flush back to phys on unmap */
 #define SG_MITER_FROM_SG	(1 << 2)	/* nop */
+#define SG_MITER_LOCAL		(1 << 3)	 /* use kmap_local */
 
 struct sg_mapping_iter {
 	/* the following three fields can be accessed directly */
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 5bb6b8aff232..b58d5ef1a34b 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -879,7 +879,7 @@ EXPORT_SYMBOL(sg_miter_skip);
  *   @miter->addr and @miter->length point to the current mapping.
  *
  * Context:
- *   May sleep if !SG_MITER_ATOMIC.
+ *   May sleep if !SG_MITER_ATOMIC && !SG_MITER_LOCAL.
  *
  * Returns:
  *   true if @miter contains the next mapping.  false if end of sg
@@ -901,6 +901,8 @@ bool sg_miter_next(struct sg_mapping_iter *miter)
 
 	if (miter->__flags & SG_MITER_ATOMIC)
 		miter->addr = kmap_atomic(miter->page) + miter->__offset;
+	else if (miter->__flags & SG_MITER_LOCAL)
+		miter->addr = kmap_local_page(miter->page) + miter->__offset;
 	else
 		miter->addr = kmap(miter->page) + miter->__offset;
 
@@ -936,7 +938,9 @@ void sg_miter_stop(struct sg_mapping_iter *miter)
 		if (miter->__flags & SG_MITER_ATOMIC) {
 			WARN_ON_ONCE(!pagefault_disabled());
 			kunmap_atomic(miter->addr);
-		} else
+		} else if (miter->__flags & SG_MITER_LOCAL)
+			kunmap_local(miter->addr);
+		else
 			kunmap(miter->page);
 
 		miter->page = NULL;
@@ -965,7 +969,7 @@ size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents, void *buf,
 {
 	unsigned int offset = 0;
 	struct sg_mapping_iter miter;
-	unsigned int sg_flags = SG_MITER_ATOMIC;
+	unsigned int sg_flags = SG_MITER_LOCAL;
 
 	if (to_buffer)
 		sg_flags |= SG_MITER_FROM_SG;
@@ -1080,7 +1084,7 @@ size_t sg_zero_buffer(struct scatterlist *sgl, unsigned int nents,
 {
 	unsigned int offset = 0;
 	struct sg_mapping_iter miter;
-	unsigned int sg_flags = SG_MITER_ATOMIC | SG_MITER_TO_SG;
+	unsigned int sg_flags = SG_MITER_LOCAL | SG_MITER_TO_SG;
 
 	sg_miter_start(&miter, sgl, nents, sg_flags);
 
-- 
2.39.5

