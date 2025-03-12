Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD2F1DB377
	for <linux-crypto@vger.kernel.org>; Wed, 12 Mar 2025 04:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741753811; cv=none; b=X6YO1ZBN51+fcLHvtZtyFq204eeWrXaQqeKFb6BCk2EL+CoJp4LfXrC4gm8LNv5YCzM0gvAsbQnXq8KQkf+X2rimtlTW8EUwkm3eQc1g+JxyKAdMBMLlw06TaLFCK1qqRLzMaJFgRJxbZCxDmYRUXuZf6mM+LcpDWoXZYE2Oj6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741753811; c=relaxed/simple;
	bh=Rs7keBjnbhKwshc3mzQiqKSQ+xrxExDPHpVOaSiLd60=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=DQpSval4IZOxhuXNMRBv7JLOS772OazoUsKWIsc3V/LmLB1mD0sXn03DgGu01dlv+XbDiFVhGnyInuXc6MOvT2TINe/6SZezf3+Xh30Z8xS2C/h2tpcGxj2Pv6NauxSTZ/UsxYuHFjdje/omDXjiAdLVWFsnO4Rkyu/vXE3OUtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=CbpCHe2B; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="CbpCHe2B"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=i+MXSm3LGhwg0rO3pMtdxVlYRXDl42BeiQqM9NJuxZw=; b=CbpCHe2B6CpGCc0rI4aWsfS9XX
	grbLcRW0XA0JUlyfCTdgWqQNHQidEDvZ276uCpOD/7juiF9UsDNMPVUVSAYIPHUoH1dO01BXA0hPB
	6Dr9yZd6VsuGpzioGYznk8XCdL5Y4LZKheQRKfq9vsG8FsysZl2RkwWUEcT3MmRtky3n83J/HkaHy
	bS6vyVmedB/lj/afG6y78As5rblDQdboXZVQzyzArbhDBh2jL1cpQQomc8nQl6bFZl5R23LRvpWVZ
	TpQWcMt1qglLHh6T+nfcWaEZU9taXdda0ISMrbLI3MpadnUa1F8E62QwEdIWX+bz76by824/BBCiK
	U2LhrbQQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tsDjE-005mXb-0b;
	Wed, 12 Mar 2025 12:30:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 12 Mar 2025 12:30:00 +0800
Date: Wed, 12 Mar 2025 12:30:00 +0800
Message-Id: <a68366725ab6130fea3a5e3257e92c8109b7f86a.1741753576.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1741753576.git.herbert@gondor.apana.org.au>
References: <cover.1741753576.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 2/2] crypto: hash - Use nth_page instead of doing it by
 hand
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use nth_page instead of adding n to the page pointer.

This also fixes a real bug in shash_ahash_digest where the the
check for continguous hash data may be incorrect in the presence
of highmem.  This could result in an incorrect hash or worse.

Fixes: 5f7082ed4f48 ("crypto: hash - Export shash through hash")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/ahash.c | 42 +++++++++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 15 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 9c26175c21a8..aff0d3387f3a 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -16,6 +16,7 @@
 #include <linux/cryptouser.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
+#include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -79,7 +80,7 @@ static int hash_walk_new_entry(struct crypto_hash_walk *walk)
 
 	sg = walk->sg;
 	walk->offset = sg->offset;
-	walk->pg = sg_page(walk->sg) + (walk->offset >> PAGE_SHIFT);
+	walk->pg = nth_page(sg_page(walk->sg), walk->offset >> PAGE_SHIFT);
 	walk->offset = offset_in_page(walk->offset);
 	walk->entrylen = sg->length;
 
@@ -201,25 +202,36 @@ int shash_ahash_digest(struct ahash_request *req, struct shash_desc *desc)
 	unsigned int nbytes = req->nbytes;
 	struct scatterlist *sg;
 	unsigned int offset;
+	struct page *page;
+	const u8 *data;
 	int err;
 
-	if (ahash_request_isvirt(req))
-		return crypto_shash_digest(desc, req->svirt, nbytes,
-					   req->result);
+	data = req->svirt;
+	if (!nbytes || ahash_request_isvirt(req))
+		return crypto_shash_digest(desc, data, nbytes, req->result);
 
-	if (nbytes &&
-	    (sg = req->src, offset = sg->offset,
-	     nbytes <= min(sg->length, ((unsigned int)(PAGE_SIZE)) - offset))) {
-		void *data;
+	sg = req->src;
+	if (nbytes > sg->length)
+		return crypto_shash_init(desc) ?:
+		       shash_ahash_finup(req, desc);
 
-		data = kmap_local_page(sg_page(sg));
-		err = crypto_shash_digest(desc, data + offset, nbytes,
-					  req->result);
-		kunmap_local(data);
-	} else
-		err = crypto_shash_init(desc) ?:
-		      shash_ahash_finup(req, desc);
+	page = sg_page(sg);
+	data = lowmem_page_address(page) + offset;
+	if (!IS_ENABLED(CONFIG_HIGHMEM))
+		return crypto_shash_digest(desc, data, nbytes, req->result);
 
+	offset = sg->offset;
+	page = nth_page(page, offset >> PAGE_SHIFT);
+	offset = offset_in_page(offset);
+
+	if (nbytes > (unsigned int)PAGE_SIZE - offset)
+		return crypto_shash_init(desc) ?:
+		       shash_ahash_finup(req, desc);
+
+	data = kmap_local_page(page);
+	err = crypto_shash_digest(desc, data + offset, nbytes,
+				  req->result);
+	kunmap_local(data);
 	return err;
 }
 EXPORT_SYMBOL_GPL(shash_ahash_digest);
-- 
2.39.5

