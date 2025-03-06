Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E861D194A6B
	for <linux-crypto@vger.kernel.org>; Thu,  6 Mar 2025 03:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741231231; cv=none; b=HBS0oYBsFy+DUnhLGinXtVseCY95lKCHq8dmZGwaNn29UoqZrnW9A2zEziHa6z04T37gyTnodVdD3hZQEdI+yIy/Gy92TDLQnneNyyeYAdSBTeU2LZuqgxL/u7fZe9MuqseBm03YyMeSvVLJAKh/33CNwqBf64rzn79pxbWUCgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741231231; c=relaxed/simple;
	bh=u6HpZI9pqTuBUPaXI0f+P1To8eLHQ2ez7eUEAWRfcxY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IxdPAdnxPQeB5WtALN3cdEczuIBLk4tKKYCa4is2bjQ23QSFRcuSlhS2mDWwOIJjOS+6hhT9dpurxwiVm5cTk/lL6fhXZUgvHogGsxyTmh6v0E6ju+JOK+j8O3gP8vBlD6Bsa6ivgyUYDQGOEZsn2csz/YVfuWKdwGQMmii7wUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=bZfneIc1; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="bZfneIc1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=dJjyaGPdhElCuYEn90hny1ewnVB56oia1veRCI1bXyg=; b=bZfneIc1tG7leFF0+SS+JCl6LQ
	r7nfFGUW87RLojcpqnM+mxMKg+ilri/Ct9wxRYDFJEJ9Wz9VCkYCpcph0ubB0WOaa5wWR6jRGzwy5
	OO60iN8aLAx7j48kipWoJLv2TQop7cE7EH62j7F9RQWf+onmNo6qwisXoFrob9Y3ObI96vywRjCU/
	HYMo8JRg4W0lM84INLN03Kg8llq4hiqMk3eJTrC1cCAlgfh5hOkgBmlNGkYThHTbnzRIqxkNzw4TY
	p1qrL0EHY6Hk0vqUhyO2TuAj3U2D+IPWWkPn/0VGAkyt3sEVcSGpC1SsBlu3/SRit91rxgxFy9BGA
	lpb3Wa+Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tq1mb-004ALN-0X;
	Thu, 06 Mar 2025 11:20:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 06 Mar 2025 11:20:25 +0800
Date: Thu, 6 Mar 2025 11:20:25 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [v2 PATCH] crypto: scatterwalk - Add memcpy_sglist
Message-ID: <Z8kUeU_SCFHU07-h@gondor.apana.org.au>
References: <Z8kQejXQqMhc3X8x@gondor.apana.org.au>
 <20250306031359.GC1592@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250306031359.GC1592@sol.localdomain>

On Wed, Mar 05, 2025 at 07:13:59PM -0800, Eric Biggers wrote:
> 
> Local kmaps must be released in reverse order of the mapping, so
> scatterwalk_done_dst() must be done before scatterwalk_done_src() above.

Good catch.  Thanks for the review!

---8<---
Add memcpy_sglist which copies one SG list to another.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/scatterwalk.c         | 27 +++++++++++++++++++++++++++
 include/crypto/scatterwalk.h |  3 +++
 2 files changed, 30 insertions(+)

diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index 20a28c6d94da..e57ce08e0d8d 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -86,6 +86,33 @@ void memcpy_to_sglist(struct scatterlist *sg, unsigned int start,
 }
 EXPORT_SYMBOL_GPL(memcpy_to_sglist);
 
+void memcpy_sglist(struct scatterlist *dst, struct scatterlist *src,
+		   unsigned int nbytes)
+{
+	struct scatter_walk swalk;
+	struct scatter_walk dwalk;
+
+	if (unlikely(nbytes == 0)) /* in case sg == NULL */
+		return;
+
+	scatterwalk_start(&swalk, src);
+	scatterwalk_start(&dwalk, dst);
+
+	do {
+		unsigned int slen, dlen;
+		unsigned int len;
+
+		slen = scatterwalk_next(&swalk, nbytes);
+		dlen = scatterwalk_next(&dwalk, nbytes);
+		len = min(slen, dlen);
+		memcpy(dwalk.addr, swalk.addr, len);
+		scatterwalk_done_src(&swalk, len);
+		scatterwalk_done_dst(&dwalk, len);
+		nbytes -= len;
+	} while (nbytes);
+}
+EXPORT_SYMBOL_GPL(memcpy_sglist);
+
 struct scatterlist *scatterwalk_ffwd(struct scatterlist dst[2],
 				     struct scatterlist *src,
 				     unsigned int len)
diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index 40c3c629e27f..1201543295f9 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -208,6 +208,9 @@ void memcpy_from_sglist(void *buf, struct scatterlist *sg,
 void memcpy_to_sglist(struct scatterlist *sg, unsigned int start,
 		      const void *buf, unsigned int nbytes);
 
+void memcpy_sglist(struct scatterlist *dst, struct scatterlist *src,
+		   unsigned int nbytes);
+
 /* In new code, please use memcpy_{from,to}_sglist() directly instead. */
 static inline void scatterwalk_map_and_copy(void *buf, struct scatterlist *sg,
 					    unsigned int start,
-- 
2.39.5

-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
