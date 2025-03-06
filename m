Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B8A1519A8
	for <linux-crypto@vger.kernel.org>; Thu,  6 Mar 2025 03:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741230209; cv=none; b=VsAKS0dI2yIu+2zItHVOLRnNndENtFkzA1hxhYy9utyOeLs4mhM5usuX8eDposrulOhVgyInUufphNjohQ3ZCyIVt9sxueT7VtGXX4CowXy6htIP5Vy6dPMXXiEeLKVUkOK1DDLX+e6hD8Vys2gdeW0K879jIBe8htfWjvorvAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741230209; c=relaxed/simple;
	bh=9Cpkj3eXLMyc/xrDjQcsFbLAi/ppJEj5kEar3a7EMs8=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=sttVuKxVKNCA0nE7NIfnmkSvWLBN2fDNUGZGrcHHfAU6CanEQDZedfEr+3pI4iW9c2N24QC87oK8UMBHmuNoYRUyeB7wkB+sZHWMiY+QWEf2IVIsrNg6/+70WtKBKGxzMBMP/KvQ0hXTQbjxQjyiW+IVtz/WSqrWujDkQMOKS8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ETuk8ZOY; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ETuk8ZOY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=rRVH8LYv4TwbtLOSq7Dzij3icVQZEcT1/Zu36x+TJvM=; b=ETuk8ZOYjhniOYhXacVhB8wNri
	vAm6O5FU4rP4kyqs4fyq6sN1vXXAeTPmBIwhnLZ/eMuUJC/Pt5vY4lNXTgbFrKryS5tQlPMPy+CAK
	GAX5F62S3hhx8R55M8ibXqeF2/qpFuo1YPBVhfPIZ0Y7XV72qmIOVkY775JdNdycLz8kb3FvD46SS
	d9m/yj7KK4BZSA85XfM3fVDBvm9HV87Np+J5MfEnLnU8NVmFR+Rf1vCdngQNHRn7B94LmFX8vCWcu
	rtx7LFhPzvt73csmDZZTxQmtiSf6dfgkLgvlHhJDerPi75o7D4JN6QhnBWSZnLnRhPS4jaxRlz6uc
	75dyOvog==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tq1W6-004A7X-2f;
	Thu, 06 Mar 2025 11:03:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 06 Mar 2025 11:03:22 +0800
Date: Thu, 6 Mar 2025 11:03:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: scatterwalk - Add memcpy_sglist
Message-ID: <Z8kQejXQqMhc3X8x@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

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
