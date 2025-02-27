Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161C8229B0E
	for <linux-crypto@vger.kernel.org>; Thu, 27 Feb 2025 10:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740651304; cv=none; b=kAySyouAgrRAUKEaDMs+F9E+pNW5tLC4CkndOcswULmgDgUqpnXajDHIbBTEiLTWDQTc2WHcv7TXPDeSYnEmrqTdEeIyyWwuJekXjMKABLvBY4eAoc2Km/jTdbJAWqKrHayYeopRzf7GUU6Znn0MfNosV3wnSAhC4sUaYqQE0EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740651304; c=relaxed/simple;
	bh=7JB+YIZuGSKGx7TM38NrrFpt1sHpGpk0GPtp++f3H0Q=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=gM1RHROkwvwmtcMe4xxrmlCLoAqycZDvZz2HwmI7+F6pvQG/h0zY9Aaic57fTy5QjnRZTGINC1NqNQdf4GJZdWFMKWwFGdCLScV9C+4Enc9ECllkuYhk8vVhmZChlyjjwPB31GhYAYsl2V4H8HOTOmu5UVVDnXa2oUzsmA7DInQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=f6ptTZnG; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="f6ptTZnG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=s0kKNBPaAqYeBEw8gVtFkyAt+P3FpXQ+B0aCH0krQCE=; b=f6ptTZnGEsG8pAmJ12gduGoGtw
	LJvvcNd0JbrcZLgOpdFFrtQDySCARECl1MpUPPvhtjvbeTsNznbA3VpGXt/vHVyHLe1WwNcw3uOLz
	lZMM06Lb1fALO/3Ki1Xakt9jXY6ioVSAp9IVrFA7R0CUBwg+rm+90oEt4mP+K25cfWvhAxz4Gr5Vw
	jg3/f1uAdN8leG6+CV+Tcky7b6DR/cpA4gT0OHEWtnFZOAuDWHqgBafiR1L+1ThzhPow3AVi6CSoo
	+2JuQ9OgwWMxDkd98NUCUxZ3SXGrS7lvEHzO7Z49vDS7yj2ns96lfr7RN7L5Ay1c6XARioCDJPQjq
	t8NPMhlw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tnauw-002Dqn-00;
	Thu, 27 Feb 2025 18:14:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 27 Feb 2025 18:14:57 +0800
Date: Thu, 27 Feb 2025 18:14:57 +0800
Message-Id: <bb32fbfe34c7f5f70dc5802d97e66ec88c470c66.1740651138.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1740651138.git.herbert@gondor.apana.org.au>
References: <cover.1740651138.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/7] crypto: acomp - Remove acomp request flags
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: linux-mm@kvack.org, Yosry Ahmed <yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The acomp request flags field duplicates the base request flags
and is confusing.  Remove it.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/acompress.c         | 2 +-
 include/crypto/acompress.h | 6 ++----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 6fdf0ff9f3c0..30176316140a 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -144,7 +144,7 @@ void acomp_request_free(struct acomp_req *req)
 	if (tfm->__crt_alg->cra_type != &crypto_acomp_type)
 		crypto_acomp_scomp_free_ctx(req);
 
-	if (req->flags & CRYPTO_ACOMP_ALLOC_OUTPUT) {
+	if (req->base.flags & CRYPTO_ACOMP_ALLOC_OUTPUT) {
 		acomp->dst_free(req->dst);
 		req->dst = NULL;
 	}
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 54937b615239..b6d5136e689d 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -24,7 +24,6 @@
  * @dst:	Destination data
  * @slen:	Size of the input buffer
  * @dlen:	Size of the output buffer and number of bytes produced
- * @flags:	Internal flags
  * @__ctx:	Start of private context data
  */
 struct acomp_req {
@@ -33,7 +32,6 @@ struct acomp_req {
 	struct scatterlist *dst;
 	unsigned int slen;
 	unsigned int dlen;
-	u32 flags;
 	void *__ctx[] CRYPTO_MINALIGN_ATTR;
 };
 
@@ -232,9 +230,9 @@ static inline void acomp_request_set_params(struct acomp_req *req,
 	req->slen = slen;
 	req->dlen = dlen;
 
-	req->flags &= ~CRYPTO_ACOMP_ALLOC_OUTPUT;
+	req->base.flags &= ~CRYPTO_ACOMP_ALLOC_OUTPUT;
 	if (!req->dst)
-		req->flags |= CRYPTO_ACOMP_ALLOC_OUTPUT;
+		req->base.flags |= CRYPTO_ACOMP_ALLOC_OUTPUT;
 }
 
 /**
-- 
2.39.5

