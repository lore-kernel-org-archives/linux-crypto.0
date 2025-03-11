Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8E623370B
	for <linux-crypto@vger.kernel.org>; Tue, 11 Mar 2025 10:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741688436; cv=none; b=JCBKwT5ZZpFSzsIM1pIpMHpo8jmAj/EZR41xJ0w+VW7FtUvK90BiE/qRGKTHjT7KYuNp6SSyqwVS5fd0E9ypvYvm7qvrSCpmOvRNP+hwWMDhFJDBxsU8ZX9Teu+ZB8mxptV4qBrvCn026lQsyMNqNREiQKOF0xUGyILPAKQFltM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741688436; c=relaxed/simple;
	bh=V6surscDjh1JebscS+37XaCJ1GmoRVxUNwC/MTa3XPk=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=hcoo5JnDzZIqH8fTh7F0Ws6BzPcKm3GGsoOTt49BY0IPg134Go3qGE/tWoRGiSotk6icg1EHOVUNq/OI59AI9/kcejKqledlo95+guNsB+nRsRnc0Mqqutm7W8WjcxL+ahAdhXRnDc7FxWVt736MFUiT0j6Yrf2tfGifeu/8kYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=T6Ymwb29; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="T6Ymwb29"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=eqhI9CgBVvId/vtQHE5C/PIopPyTgezQrfR150Tcqpw=; b=T6Ymwb29zRj7tIB1dC0wvvhZ7T
	NZ/F2p9OIgd5t71/RC9vJeZjtR7tfGBM5mVNvatFE2V01LDdv88143jU5fOf9CzrLPRGlZi6QsoXL
	ji/F9KW+RKtLzTFeF5dBln6OE0Fpu9RqxMvDC6rvkPrke/B3x0B/lMT0Pe35cPSuxJe8h24UF3S+F
	E/SMIBPVhah4TcSnoeXlED+B1680EcXisdKG7xAIVz4PGangfQJjCrhp/vhPAO1Se8YuFbMStLtiV
	8+ECiRMyhXnrwWUUqtJPeEw/ZWITTu8+okj0uQDGF2KK29F5DKUbRxYm9Ul+16c83iz6aCv7LhuHM
	rrGHTdOQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1trwir-005YUd-0r;
	Tue, 11 Mar 2025 18:20:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 11 Mar 2025 18:20:29 +0800
Date: Tue, 11 Mar 2025 18:20:29 +0800
Message-Id: <9c5624f2b3a0131e89f3e692553a55d132f50a96.1741688305.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1741688305.git.herbert@gondor.apana.org.au>
References: <cover.1741688305.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/3] crypto: scatterwalk - Use nth_page instead of doing it by
 hand
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
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
 include/crypto/scatterwalk.h | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index b7e617ae4442..4fc70b8422c5 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -99,26 +99,27 @@ static inline void scatterwalk_get_sglist(struct scatter_walk *walk,
 
 static inline void scatterwalk_map(struct scatter_walk *walk)
 {
-	struct page *base_page = sg_page(walk->sg);
+	struct page *page = sg_page(walk->sg);
+	unsigned int offset = walk->offset;
+	void *addr;
+
+	page = nth_page(page, offset >> PAGE_SHIFT);
+	offset = offset_in_page(offset);
 
 	if (IS_ENABLED(CONFIG_HIGHMEM)) {
-		walk->__addr = kmap_local_page(base_page +
-					       (walk->offset >> PAGE_SHIFT)) +
-			       offset_in_page(walk->offset);
+		addr = kmap_local_page(page) + offset;
 	} else {
 		/*
 		 * When !HIGHMEM we allow the walker to return segments that
 		 * span a page boundary; see scatterwalk_clamp().  To make it
 		 * clear that in this case we're working in the linear buffer of
 		 * the whole sg entry in the kernel's direct map rather than
-		 * within the mapped buffer of a single page, compute the
-		 * address as an offset from the page_address() of the first
-		 * page of the sg entry.  Either way the result is the address
-		 * in the direct map, but this makes it clearer what is really
-		 * going on.
+		 * within the mapped buffer of a single page, use
+		 * page_address() instead of going through kmap.
 		 */
-		walk->__addr = page_address(base_page) + walk->offset;
+		addr = page_address(page) + offset;
 	}
+	walk->__addr = addr;
 }
 
 /**
-- 
2.39.5

