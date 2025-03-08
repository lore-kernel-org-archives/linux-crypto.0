Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6409B2744E
	for <linux-crypto@vger.kernel.org>; Sat,  8 Mar 2025 12:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741437929; cv=none; b=jpe4qWX04KIRiXgHOgwulY3JbmgE/hK0Ul9Uisrw1n2EBw3wUf1z5dTXDSJ60AkRO3mMWa3Kt6hdbCmRyNE2dt49kshzlYJHK/96iu2p8jbRnCwQf6VqaA89PsC4MxnwEU2lSfosqJqaPl9ARn4Zlhn154E7NNEDj2FPs8siM1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741437929; c=relaxed/simple;
	bh=paTGudFEGIoTnfijlsMla3IXBdp0gmfWbEodnoBw/7k=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=TFyoFm2KGVG0xyBGEcSFg35FJvGvFUx5169rStp2xJWaQnZFGVvketJEZ4YqKjBdCvYNXk/7a4WWfSFquYURi8osOVc3sfj+u2Bza6uBOCYJiHO8Lm0k6cyKL2cTfVi0V8btbLi8B689muIDWmaxZYLRG17MPQtdYGifIqIm8E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=cOZo84Uk; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="cOZo84Uk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=XLQlhAY/2txbdivpVV2RwPAG5NKf5880rbxqDk5bHNA=; b=cOZo84Ukd2szV36Ve9lJOHPN9p
	MTdU8A5x0gqhAf/J+weEAkrfN+VB1MSivJqVPClKETNQcGxxJ6Jt7QRnQ+Kb/ANFarhOafTtPxFrc
	SzE/jT5PvziTjh5+Wk1L9znuW7lvEOIqx4rsSu3e6KaVNOjQio48X7ESDKiSAzAZD+S9WWoPSzoOy
	ao0LzmxrDIE5OqiiOfvgtk0/j0cXZhU5msoFqmTpwCPzRjbLtG4wxbZKgOcm+I8N+pfzXta5hMi4a
	i+/Jm5FGKoaTJ1PfHEJgbxV+r0vb7TLNdtTG9xDX1wG8OWatSC32Bgpx9/3AOVFNlS6vF+JwG5npV
	fPP5mcHw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tqtYR-004r9G-1s;
	Sat, 08 Mar 2025 20:45:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 08 Mar 2025 20:45:23 +0800
Date: Sat, 08 Mar 2025 20:45:23 +0800
Message-Id: <cfa8ea2f1ec1bedb63bf1d1ace5c307fc5378aad.1741437826.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1741437826.git.herbert@gondor.apana.org.au>
References: <cover.1741437826.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v3 PATCH 2/3] crypto: scatterwalk - Add memcpy_sglist
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Add memcpy_sglist which copies one SG list to another.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/scatterwalk.c         | 27 +++++++++++++++++++++++++++
 include/crypto/scatterwalk.h |  3 +++
 2 files changed, 30 insertions(+)

diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index 20a28c6d94da..8225801488d5 100644
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
+		scatterwalk_done_dst(&dwalk, len);
+		scatterwalk_done_src(&swalk, len);
+		nbytes -= len;
+	} while (nbytes);
+}
+EXPORT_SYMBOL_GPL(memcpy_sglist);
+
 struct scatterlist *scatterwalk_ffwd(struct scatterlist dst[2],
 				     struct scatterlist *src,
 				     unsigned int len)
diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index 8523c7591d95..c62f47d04eb1 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -210,6 +210,9 @@ void memcpy_from_sglist(void *buf, struct scatterlist *sg,
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

