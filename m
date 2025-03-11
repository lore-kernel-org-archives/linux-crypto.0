Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB1422FAC3
	for <linux-crypto@vger.kernel.org>; Tue, 11 Mar 2025 10:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741688437; cv=none; b=V4ub95pkS8wZqS9+D7pDlZsiXrdwaiD8Ovg2+4S+9InBWkcjfNHHSKjI653H2VbGvCDaoeYDS1CUPHR2pJEL0qnAo6Zic0TXbpF/eXdWgoKczIdzVcGOO72tcukDPQ4GoANquJVfjDW0vpLhmMjSdFyUY44hwrD1HD+KtKbcfAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741688437; c=relaxed/simple;
	bh=oqAl44/16ogrton1crAj6AdPxyrfydmopBW4he0VS8s=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=OkbWLro9WWvcczf3Fe4W9/U/RJz8VzT/t5xerSW5HlfD5zlJ8jycuOM8UI2+2/ghWcrxKw8jGlwOK1NRu0W812FCo/xcucUOkz4O+0YVV6xef80Hekx1AjFF1CuvAN0HmNZ8tsN3ogNQrB/xlYnTwiRavgQsKNQ9LWEvrAPEj6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=TaKlz7cf; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="TaKlz7cf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mwgnhhyUokXHbzqZLKg4QW/Np8o0K+acOG2Mbe5W3FU=; b=TaKlz7cfDjDxoGihUQjPvQA+B3
	srlyHrzbOwUAJMS4iaa8vvKuiRxLj/msSOCRn7hlWTi+DHReU8i9ktckllbcpw5+eGAj1JvWg9vnV
	Iete/NHH488mXU4TA2v5cYq4g+8MGC+OVgFYTAwWAeL5sSYYz1eqrf2WsV2XVWNtKz/hC7D8QRF2F
	mUDtLxNKlTN9s9A2d46rzwAH5q2hddvBwStecDxT0TrBOeBjAo4chHypvJLK0sDlP+WzxRwvK6fRl
	dSQivwpoEayggiLy0wvxUEJSAl/W6JGLruGWA+YncZyxn/iRroQyck4smWEEymIKzb5Q0c8BafrkE
	Ua613JyQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1trwit-005YUn-1p;
	Tue, 11 Mar 2025 18:20:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 11 Mar 2025 18:20:31 +0800
Date: Tue, 11 Mar 2025 18:20:31 +0800
Message-Id: <e858dadf36f7fc2c12545c648dda4645f48cab22.1741688305.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1741688305.git.herbert@gondor.apana.org.au>
References: <cover.1741688305.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/3] crypto: hash - Use nth_page instead of doing it by hand
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
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
 crypto/ahash.c | 38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 9c26175c21a8..75d642897e36 100644
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
+	void *data;
 	int err;
 
-	if (ahash_request_isvirt(req))
+	if (!nbytes || ahash_request_isvirt(req))
 		return crypto_shash_digest(desc, req->svirt, nbytes,
 					   req->result);
 
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
+	offset = sg->offset;
+	page = nth_page(page, offset >> PAGE_SHIFT);
+	offset = offset_in_page(offset);
 
+	if (!IS_ENABLED(CONFIG_HIGHMEM))
+		return crypto_shash_digest(desc, page_address(page) + offset,
+					   nbytes, req->result);
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

