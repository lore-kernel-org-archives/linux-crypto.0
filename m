Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C3714F98
	for <linux-crypto@vger.kernel.org>; Thu,  6 Mar 2025 03:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741232010; cv=none; b=UOP9hw/om/VlsY6SJpUJVes1MAMb2nAsZUny03z5KpnqLg7LIpw0wvCPGWmcMD4cw92hnYFWeU9cNNHoJjimtm+yFaDKBqNLB7kXewCUkzns7aHt0g3hsgzImR114pC1IaXR5PFKEZ0r0vay1OnE8ddFVUK1uwZ1K4wHMicY+1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741232010; c=relaxed/simple;
	bh=mNz3bglmzj4Qb+OzW++AidhN/iWOTaiAgE3lXcQEFso=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N7Rm3f+byP8evn2TybSZaryCwYrSaaGspodp2N2mPmt3kKVM5Bcd9BQlGBRwbFVpSGJ7GggJaGr2XZe9bL+142DZGnxZHUE1d0oLC87xxuW0jlgFbq9njbnyEOrmq1hZlXv6qRa7TQCJGTmoG/0ToS78O9llpMPdMkraYzLgz4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=kBTmk4R5; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="kBTmk4R5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/wRKsiWzj/6y6nqYnMinMfjWsoIhWKuhuIEd0vIsxPw=; b=kBTmk4R5wWTiyzC+4hNtmGe0s9
	xfwKKgJ66zxNJ62JpSDgL8a+YNMp5AKsEEN5gqvqju8Gs+FUfbWJoWLmZ4pL1w+H7tZxYRCo2Wes7
	cb/Pkn3JWucJkbToVBiaimAVn6rl+kA+sfUagV2vNB60gcngO/X059+2VmR62/Bb8DZ8AEoxaxqlM
	ZqHZRTblE7DzbXQ0RzuXiBKrcVEgLeKEInKWUHoO5Qi+qxeJO21gEPtF1muHT/NGtew9YPYXEsEUG
	ZDh3jZXtPnVUBn49czDSIR3cbu/7cgUZ+U4JzTV/DQFc03YLFiEIf/IjxoAFoi5B5Jthh7YIOh0y8
	aEHo8qsQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tq1zA-004AQm-0T;
	Thu, 06 Mar 2025 11:33:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 06 Mar 2025 11:33:24 +0800
Date: Thu, 6 Mar 2025 11:33:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [v3 PATCH] crypto: scatterwalk - Add memcpy_sglist
Message-ID: <Z8kXhLb681E_FLzs@gondor.apana.org.au>
References: <Z8kQejXQqMhc3X8x@gondor.apana.org.au>
 <20250306031359.GC1592@sol.localdomain>
 <Z8kUeU_SCFHU07-h@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8kUeU_SCFHU07-h@gondor.apana.org.au>

On Thu, Mar 06, 2025 at 11:20:25AM +0800, Herbert Xu wrote:
>
> Good catch.  Thanks for the review!

Oops, I didn't actually commit before resending:

---8<---
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
