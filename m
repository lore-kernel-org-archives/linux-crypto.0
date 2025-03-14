Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F85A3594C
	for <linux-crypto@vger.kernel.org>; Fri, 14 Mar 2025 03:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741922847; cv=none; b=sB6BBHoumKzdpLW7aw6hkhh1Tgjlka0BAJN9juLfCvVtdFU8PeU5xk6smT67tvZWGzaGQDICLL0Vk/JbZ0HkpuOdOkAsP1IXV3RLR4PO8B2ESREwYCqfQSJhVO3MEKFuSzTR+RKcAIHaN3yX1ykq+5h9MueryrNy/gUzJ99CwzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741922847; c=relaxed/simple;
	bh=eAsybyYFAGEZtNaqSvW7P4xfcCrvznb/iYuw4kt7btc=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=iMsd3XbVIeBan+eDdrButZA15TVFNieLSkATZse4LUtypdFgHDh9m5ZdJlENvbI6LJz3ZCKqw72fxMyPGPMXnssnl5x93s+9UslGrtDApkvH3GZMX8aoiS53CGO+ZBhqpnMfCOngVlRdaECTGH2GWOi5U8QRkVIKSs7pCkb0Rkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=PL/AofUx; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="PL/AofUx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=C5hEJRBn2ZqVakdU3LL7S96ho5HtbWPhR+4gnVLsrmc=; b=PL/AofUxPaNApIjhuYIitVb2yh
	qEIYo4HXjtwC2TQMhiQ91Mzr59R20DmuRzPo8Dl+KWMsRf3k3Fvbw0x5riD4FFi7uEfPDoILypd4s
	JdtDC7GTgLoQacHOtAK8Ahc5QEZd22GALNG52Hw2Rdp9PQ+3gfphcujysYI+PpfAz9ht9Wv/TBDCG
	2J6PF+fDbsCfZevUlELAq6zT2yMSUHcS/w13W/Z85M+/MmcpZLaAYe7gBzmZulBdl1pRj2gbDNS5P
	v5DP2bgAhZISWkcXSUQFkU/QAAFgXvFzNv10zTSWUCdLG3gUfuWlU0aWdRG1Wn+b0qwY0RMNpvpOb
	g8oe0Cdw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tsvhg-006S8d-2v;
	Fri, 14 Mar 2025 11:27:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 14 Mar 2025 11:27:20 +0800
Date: Fri, 14 Mar 2025 11:27:20 +0800
Message-Id: <96553040a4b37d8b54b9959e859fc057889dfdac.1741922689.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1741922689.git.herbert@gondor.apana.org.au>
References: <cover.1741922689.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v4 PATCH 1/2] crypto: scatterwalk - Use nth_page instead of doing it
 by hand
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Curiously, the Crypto API scatterwalk incremented pages by hand
rather than using nth_page.  Possibly because scatterwalk predates
nth_page (the following commit is from the history tree):

	commit 3957f2b34960d85b63e814262a8be7d5ad91444d
	Author: James Morris <jmorris@intercode.com.au>
	Date:   Sun Feb 2 07:35:32 2003 -0800

	    [CRYPTO]: in/out scatterlist support for ciphers.

Fix this by using nth_page.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 include/crypto/scatterwalk.h | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index b7e617ae4442..94a8585f26b2 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -100,11 +100,15 @@ static inline void scatterwalk_get_sglist(struct scatter_walk *walk,
 static inline void scatterwalk_map(struct scatter_walk *walk)
 {
 	struct page *base_page = sg_page(walk->sg);
+	unsigned int offset = walk->offset;
+	void *addr;
 
 	if (IS_ENABLED(CONFIG_HIGHMEM)) {
-		walk->__addr = kmap_local_page(base_page +
-					       (walk->offset >> PAGE_SHIFT)) +
-			       offset_in_page(walk->offset);
+		struct page *page;
+
+		page = nth_page(base_page, offset >> PAGE_SHIFT);
+		offset = offset_in_page(offset);
+		addr = kmap_local_page(page) + offset;
 	} else {
 		/*
 		 * When !HIGHMEM we allow the walker to return segments that
@@ -117,8 +121,10 @@ static inline void scatterwalk_map(struct scatter_walk *walk)
 		 * in the direct map, but this makes it clearer what is really
 		 * going on.
 		 */
-		walk->__addr = page_address(base_page) + walk->offset;
+		addr = page_address(base_page) + offset;
 	}
+
+	walk->__addr = addr;
 }
 
 /**
@@ -189,14 +195,18 @@ static inline void scatterwalk_done_dst(struct scatter_walk *walk,
 	 * reliably optimized out or not.
 	 */
 	if (ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE) {
-		struct page *base_page, *start_page, *end_page, *page;
+		struct page *base_page;
+		unsigned int offset;
+		int start, end, i;
 
 		base_page = sg_page(walk->sg);
-		start_page = base_page + (walk->offset >> PAGE_SHIFT);
-		end_page = base_page + ((walk->offset + nbytes +
-					 PAGE_SIZE - 1) >> PAGE_SHIFT);
-		for (page = start_page; page < end_page; page++)
-			flush_dcache_page(page);
+		offset = walk->offset;
+		start = offset >> PAGE_SHIFT;
+		end = start + (nbytes >> PAGE_SHIFT);
+		end += (offset_in_page(offset) + offset_in_page(nbytes) +
+			PAGE_SIZE - 1) >> PAGE_SHIFT;
+		for (i = start; i < end; i++)
+			flush_dcache_page(nth_page(base_page, i));
 	}
 	scatterwalk_advance(walk, nbytes);
 }
-- 
2.39.5

