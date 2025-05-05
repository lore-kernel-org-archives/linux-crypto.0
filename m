Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6FE541C63
	for <linux-crypto@vger.kernel.org>; Mon,  5 May 2025 12:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746449688; cv=none; b=LglJeLSiRfay0id/keUx1zTHKoMng1EkwuhtllSoKcV0pzjWLGqu062wwiUONKMGRvBO0luyalpVGhUqzioeg2aQE8cs8n8kFf1RdfOF41uWFZXEGsrLxw8oZZ/8Q9oOtjNjQXg6lVK2JfVyXuqLuGIxWxfe2f+KP85JWBhAD9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746449688; c=relaxed/simple;
	bh=xsiNfgIXVoni+kkOYNvcEhe1FJGy046tFO91rZ8roRA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MaeaYIETwFqBEi4svw9kcTg+kym7IYJj5L/79n4OZmCoZHtZD5e+rxMnJ0xtp8Gugot7UaOfut0r0FoHHrlxDj9ZuIsvFVejgKJLNxbnZMPUIo7KesdBK47rEmVqQnVePk4XxGV0ZvR5r874pX4M7qCqQdp/8SucfrRgt6QBcew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=SSSYmHcB; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="SSSYmHcB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=w7WBS3HXwBYvql4leWhRbNzxZfOY9nOt4+c/l2i27bk=; b=SSSYmHcBICqjjnp+0FIDApV+QS
	exisRD9WLjuQFsOTSx/lZHXssu5op5vPtMDXfc0yZPD2Xf+zNs7EXkkZ1NrW6Pd/lEktGAWvK9GdS
	niXCr7FC8i7J4lmNoAT+VcGcCkd8/Aw+a7K9YphIss51uxXw+UKG1y1Cb1Y0Z/ylBjw+5IwBXXkcn
	96CkoIo0xubG/jWuEHZLQG1G93+a1N+7H1qbuC/b0FXpuf09IG0D9JLSpQJ/kzkCCx2OlD/J2lgbr
	gEg4g3gROHCPnxjsi2C1XUxxnYnfFGUCERnf6KAbx9H+jX5C5b1Zi2iZ/WH6DHHXOARlIWczBSyjn
	gBk+IBtg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uBvLF-003YfV-03;
	Mon, 05 May 2025 20:54:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 05 May 2025 20:54:41 +0800
Date: Mon, 5 May 2025 20:54:41 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ingo Franzki <ifranzki@linux.ibm.com>
Cc: Holger Dengler <dengler@linux.ibm.com>, linux-crypto@vger.kernel.org,
	Harald Freudenberger <freude@linux.ibm.com>
Subject: [PATCH] crypto: s390/sha512 - Initialise upper counter to zero for
 sha384
Message-ID: <aBi1EbRU5cqdgVHZ@gondor.apana.org.au>
References: <632df0c6adc88f82d27bbabcc3fc6d7f@linux.ibm.com>
 <aBCX_l0kSHVx4xQn@gondor.apana.org.au>
 <9c50b5ad-39ae-4c0e-ac9b-ee95e8b7e8b0@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c50b5ad-39ae-4c0e-ac9b-ee95e8b7e8b0@linux.ibm.com>

On Mon, May 05, 2025 at 02:45:09PM +0200, Ingo Franzki wrote:
>
> Shouldn't the sha384_init() function also use array indexes 0-7 like your fix in sha512_init() ?

It certainly should.  Although that is not the reason why it fails
as the 32-to-64 change is just cosmetic.  The real reason is that
as I overlooked this function the high bits of the counter just isn't
set and contains garbage:

---8<---
Initialise the high bit counter to zero in sha384_init.

Also change the state initialisation to use ctx->sha512.state
instead of ctx->state for consistency.

Fixes: 572b5c4682c7 ("crypto: s390/sha512 - Use API partial block handling")
Reported-by: Ingo Franzki <ifranzki@linux.ibm.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/s390/crypto/sha512_s390.c b/arch/s390/crypto/sha512_s390.c
index 3c5175e6dda6..33711a29618c 100644
--- a/arch/s390/crypto/sha512_s390.c
+++ b/arch/s390/crypto/sha512_s390.c
@@ -86,15 +86,16 @@ static int sha384_init(struct shash_desc *desc)
 {
 	struct s390_sha_ctx *ctx = shash_desc_ctx(desc);
 
-	*(__u64 *)&ctx->state[0] = SHA384_H0;
-	*(__u64 *)&ctx->state[2] = SHA384_H1;
-	*(__u64 *)&ctx->state[4] = SHA384_H2;
-	*(__u64 *)&ctx->state[6] = SHA384_H3;
-	*(__u64 *)&ctx->state[8] = SHA384_H4;
-	*(__u64 *)&ctx->state[10] = SHA384_H5;
-	*(__u64 *)&ctx->state[12] = SHA384_H6;
-	*(__u64 *)&ctx->state[14] = SHA384_H7;
+	ctx->sha512.state[0] = SHA384_H0;
+	ctx->sha512.state[1] = SHA384_H1;
+	ctx->sha512.state[2] = SHA384_H2;
+	ctx->sha512.state[3] = SHA384_H3;
+	ctx->sha512.state[4] = SHA384_H4;
+	ctx->sha512.state[5] = SHA384_H5;
+	ctx->sha512.state[6] = SHA384_H6;
+	ctx->sha512.state[7] = SHA384_H7;
 	ctx->count = 0;
+	ctx->sha512.count_hi = 0;
 	ctx->func = CPACF_KIMD_SHA_512;
 
 	return 0;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
