Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD1E33F6
	for <linux-crypto@vger.kernel.org>; Wed, 12 Mar 2025 04:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741753809; cv=none; b=kK3UgWDfEwfdlLHsVU4/sePUVFh8QG+mLMvW6948GrrDQ8AheRxTRxFSdlNkkzbbL7oYwp33pu0SzTh7ILinu5Vy/xjylD2ZNJj188KK9bONiRyADfyUS3+0R6s7qaI7wgJ4PdazYBO24jAi4DjAjvEBTX99lpwzksaxW19mgEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741753809; c=relaxed/simple;
	bh=HTnXIOyu15Zlx7eQzAeQm8j+Mf5oK3TEq7XOJ++MXYo=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=qMwX0r00uLItiZ6zJrD35CI0bxT0qIokAwGiieLoV9JeCuckCkNRbm8PncyarAuOyPAykIUAJLXutYH+zwqu8hbyM9LSTq7J7Q6FuBHJpNamIgAPQG/9wqSTvuxzFNlZ02Sbi/ZWsNQ7m6bwYQUAPeimFURVP+7u0Q+12P8gjk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=F2EG358I; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="F2EG358I"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=qh9OjMVOyQUs1HuYmcAdi7OtBjnhT/8zyguovqQhU0Y=; b=F2EG358IQZ6/vkfIZd08uxu0yT
	o7A4zXWdpLcRpenwukllUV05Z+OVLzBTLrKfoBUL2QFoEHkyv/QHcw9YzitIH4eZlsJ9OrhVi1OVk
	Kjp/ZoHEsCOB6hEXzYhJrp8uUGu1L8NAP33BiBAU7REa+Kg88e8nQsUaquVImhw3TRkjOHwDatagr
	Xqw1qBxX0dtBqXbn9nB4jqEKEFGvDmDWbe8xdL0/5xqWNqeXMpErhtQQbSTdBkdtVfbxAMCAnN8UM
	mlUlvkY+wLAVIzke4TR1BJ/V3vb71CYjFK20BnXya7T/bgbnvEr42DQ5aEuWNSYJQebvn4XO0786b
	fDe3GZ1g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tsDjB-005mXQ-2q;
	Wed, 12 Mar 2025 12:29:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 12 Mar 2025 12:29:57 +0800
Date: Wed, 12 Mar 2025 12:29:57 +0800
Message-Id: <03f40ecd970de816686b233bd79406768dc66bbc.1741753576.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1741753576.git.herbert@gondor.apana.org.au>
References: <cover.1741753576.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 1/2] crypto: scatterwalk - Use nth_page instead of doing it
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
 include/crypto/scatterwalk.h | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index b7e617ae4442..0ba5be363abf 100644
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
@@ -112,13 +116,14 @@ static inline void scatterwalk_map(struct scatter_walk *walk)
 		 * clear that in this case we're working in the linear buffer of
 		 * the whole sg entry in the kernel's direct map rather than
 		 * within the mapped buffer of a single page, compute the
-		 * address as an offset from the page_address() of the first
-		 * page of the sg entry.  Either way the result is the address
-		 * in the direct map, but this makes it clearer what is really
-		 * going on.
+		 * address as an offset from the lowmem_page_address() of
+		 * the first page of the sg entry.  Either way the result
+		 * is the address in the direct map, but this makes it clearer
+		 * what is really going on.
 		 */
-		walk->__addr = page_address(base_page) + walk->offset;
+		addr = lowmem_page_address(base_page) + offset;
 	}
+	walk->__addr = addr;
 }
 
 /**
-- 
2.39.5

