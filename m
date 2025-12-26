Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15AC5464D
	for <linux-crypto@vger.kernel.org>; Fri, 26 Dec 2025 00:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766709519; cv=none; b=DdLD1144ofe2vEdKmoN+Z6f/ReKccFWi2Gk1eEb1twFvKMSirfsN96M2g9ggqGw6L6unRYq/493jOX+SdwCwzDiBoXeFbyq3aOC1u91PAFbFRNqbKJfHmMKDfaiod7eACgpt7kctGRqFmjWc59LOjLwqEDyRggdkOoOdHe2ML/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766709519; c=relaxed/simple;
	bh=P2E41+jB7chfJxVv0QbxiYnG1IOSZ9kULiROpAN8asI=;
	h=Date:Message-ID:In-Reply-To:References:From:Subject:To:Cc; b=DVvun7W1JCXv2f55KuRz8delAVGpjufoeX9nbiGte4SGQNk2hw94CkgFkc9/61OmaMQI4FN6/NS/w4OEtFsBBLN61V3xi3OHyKK7TvCdMVHlzlTY4z/PgtejOXcsRGHVEfOQ7mqmPuHyzxJ6JrpNTcSbd+ZN0NHCQRQciKmTd7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=YuO7IYGf; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="YuO7IYGf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=Cc:To:Subject:From:References:In-Reply-To:
	Message-ID:Date:cc:to:subject:message-id:date:from:content-type:mime-version:
	reply-to; bh=y8VLx11pNosaPBbmk98BXJQc1kgij7aVUDvbrn8CCG4=; b=YuO7IYGfWTgmZ+xw
	z/lmYVYrwk5/pfcuAg9y+UZbAK72OzXmLiCgE9qx2Yu+wHwUpEdlN4qlBkq+Fq40M+xyY9ooJU48R
	NG1l+91SE01zqC+pf3onw5jDgAR7/w4IuR0UbToFmlJ/nsyzyBVEgk8d0IxlHhbwgy72SvjOCIrFW
	a8hLJkFUzW2lgjhuHgXkgiNrz7AI9oIi9UCvJMKOojbUpWfU5x7W7CCJ8LrBmcR0FUL8MEVYnZKt3
	Idzs3YSAntlDnqASyzgNhye4jFLqoTurhvyEumnv+4vrAkK7XFTYJp87fI15ERpV5SZ51OB7GdhPz
	FpmIU1KkO5Yb4KenZQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vYvqb-00CY7e-15;
	Fri, 26 Dec 2025 08:38:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 26 Dec 2025 08:38:25 +0800
Date: Fri, 26 Dec 2025 08:38:25 +0800
Message-ID: <9565daceae6efbac8ba35c291e7f9370ecfc83d6.1766709379.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1766709379.git.herbert@gondor.apana.org.au>
References: <cover.1766709379.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/3] crypto: acomp - Define a unit_size in struct acomp_req to
 enable batching.
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev, Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>

We add a new @unit_size data member to struct acomp_req along with a
helper function acomp_request_set_unit_size() for kernel modules to set
the unit size to use while breaking down the request's src/dst
scatterlists.

An acomp_alg can implement batching by using the @req->unit_size to
break down the SG lists passed in via @req->dst and/or @req->src, to
submit individual @req->slen/@req->unit_size compress jobs or
@req->dlen/@req->unit_size decompress jobs, for batch compression and
batch decompression respectively.

In case of batch compression, the folio's pages for the batch can be
retrieved from the @req->src scatterlist by using an struct sg_page_iter
after determining the number of pages as @req->slen/@req->unit_size.

Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 include/crypto/acompress.h | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 9eacb9fa375d..0f1334168f1b 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -79,6 +79,7 @@ struct acomp_req_chain {
  * @dvirt:	Destination virtual address
  * @slen:	Size of the input buffer
  * @dlen:	Size of the output buffer and number of bytes produced
+ * @unit_size:  Unit size for the request for use in batching
  * @chain:	Private API code data, do not use
  * @__ctx:	Start of private context data
  */
@@ -94,6 +95,7 @@ struct acomp_req {
 	};
 	unsigned int slen;
 	unsigned int dlen;
+	unsigned int unit_size;
 
 	struct acomp_req_chain chain;
 
@@ -328,9 +330,43 @@ static inline void acomp_request_set_callback(struct acomp_req *req,
 {
 	flgs &= ~CRYPTO_ACOMP_REQ_PRIVATE;
 	flgs |= req->base.flags & CRYPTO_ACOMP_REQ_PRIVATE;
+	req->unit_size = 0;
 	crypto_request_set_callback(&req->base, flgs, cmpl, data);
 }
 
+/**
+ * acomp_request_set_unit_size() -- Sets the unit size for the request.
+ *
+ * As suggested by Herbert Xu, this is a new helper function that enables
+ * batching for zswap, IPComp, etc.
+ *
+ * Example usage model:
+ *
+ * A module like zswap that wants to use batch compression of @nr_pages with
+ * crypto_acomp must create an output SG table for the batch, initialized to
+ * contain @nr_pages SG lists. Each scatterlist is mapped to the nth
+ * destination buffer for the batch.
+ *
+ * An acomp_alg can implement batching by using the @req->unit_size to
+ * break down the SG lists passed in via @req->dst and/or @req->src, to
+ * submit individual @req->slen/@req->unit_size compress jobs or
+ * @req->dlen/@req->unit_size decompress jobs, for batch compression and
+ * batch decompression respectively.
+ *
+ * This API must be called after acomp_request_set_callback(),
+ * which sets @req->unit_size to 0.
+ *
+ * @du would be PAGE_SIZE for zswap, it could be the MTU for IPsec.
+ *
+ * @req:	asynchronous compress request
+ * @du:		data unit size of the input buffer scatterlist.
+ */
+static inline void acomp_request_set_unit_size(struct acomp_req *req,
+					       unsigned int du)
+{
+	req->unit_size = du;
+}
+
 /**
  * acomp_request_set_params() -- Sets request parameters
  *
-- 
2.47.3

