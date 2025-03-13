Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5780B1F9428
	for <linux-crypto@vger.kernel.org>; Thu, 13 Mar 2025 05:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741842904; cv=none; b=TVLkB5rGgDEGqn8tYFCOpu0vhr3+76L9GEfSatnlW0aE/JxD//Kb5l0ih7S6wX7PamvwhmhrplSYNV9ThFFG6xVBoW5waCklZpuKGDSq1ZWe5QycDXk2Sj+bhQrwMscNIzLsIGs4MO8leFoYQapfczow8WdBLk7TCMrZeLCRn9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741842904; c=relaxed/simple;
	bh=mNLmOGghL62tzDA4JQfsxo+P9xR5NBH2CaNap5VlRjs=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=iyZR98TnOhzWg25etZhlgMXOginSbjHhwfvwmwyDY9/7BYptpW2h4vl0u1BCdrIowbBMn8qQTYaTn4OgDAQdpFZdkY+tZrza9RyT0YXvMy/Tbl3vLV7a0X4wzehqXqwWXlvEEY6MsPFYh2vza0zy6+p3P52LMbuwwxnaXZ051K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=qmcLD3p3; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="qmcLD3p3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=1c9yppkRtU8BSI0xx+i+Gx7RlgrGI2hBSVqONXXhRv4=; b=qmcLD3p3SPAv2ik7TbAszIpliR
	6iOBt+h3GFDwQqw0XDqh5KJe0tRxe+voMBZ2FaKJ3sPpDIEdOJzjmUFfexk/P2GNz/zC6GmdIeq+q
	wqKn5X5IpeEhUh8kjoK98KyYxGx3XtzhBOGIWvT+ciXi2APsC9zTqh8XcyAcpG2mhKSDcN/xLmF3f
	5b5oLbZHPJnMRahiNjhhFVErpmooe0p9LHx2WboGEKJuWklSn5lm4KzFfMVFwjVbAYMQi/wmfOa6l
	67LukNR45rZSdmSC2Z3krG0kASw2cElNuCiNzTD8kc3ys0xSmzOVNL+aLyrcluFe5WP+VpdC2ehL6
	V7rNdAXg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tsauI-0068QX-1u;
	Thu, 13 Mar 2025 13:14:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 13 Mar 2025 13:14:58 +0800
Date: Thu, 13 Mar 2025 13:14:58 +0800
Message-Id: <b4b00e0fed2fe0e48a0d9b2270bed7e29b119f6a.1741842470.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1741842470.git.herbert@gondor.apana.org.au>
References: <cover.1741842470.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v3 PATCH 3/3] crypto: hash - Fix test underflow in
 shash_ahash_digest
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The test on PAGE_SIZE - offset in shash_ahash_digest can underflow,
leading to execution of the fast path even if the data cannot be
mapped into a single page.

Fix this by splitting the test into four cases:

1) nbytes > sg->length: More than one SG entry, slow path.
2) !IS_ENABLED(CONFIG_HIGHMEM): fast path.
3) nbytes > (unsigned int)PAGE_SIZE - offset: Two highmem pages, slow path.
4) Highmem fast path.

Fixes: 5f7082ed4f48 ("crypto: hash - Export shash through hash")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/ahash.c | 40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 9c26175c21a8..1fe594880295 100644
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
+	offset = sg->offset;
+	data = lowmem_page_address(page) + offset;
+	if (!IS_ENABLED(CONFIG_HIGHMEM))
+		return crypto_shash_digest(desc, data, nbytes, req->result);
 
+	page += offset >> PAGE_SHIFT;
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

