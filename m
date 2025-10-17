Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179B827F72C;
	Fri, 17 Oct 2025 08:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760689098; cv=none; b=svRa2LWN6LqpkgGXlCjgYjUW9ixWqKj77pKdg9xrSDsu0JxnwL1heyO2JtbwrKm3Q2a+BsL3qntuasvDe8Xm7jzxHbcvB1XIAX7Ushsc6I5h+gTEwOKc0s85pkeQnhKykFIotNwWyZQFihB96PJ8Zz5XT4ntSRVVkw4+AYs+/98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760689098; c=relaxed/simple;
	bh=wdVpLu79pmbA89LCGmxTUVEV1tX3C4XJaDey5g4sBqA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LzLMaKMCy9JQH7bToucAK9RS5u1JBqNEvE/wR3ySYclPc2yehPzTyaLCRLy2PjeNSRdG/xypP7mH/hKManbFaIK0fanfxJPfnhkaSWlHMgntmzcjnBfHCzg7vYokFpZQnK1yuFs84Qh9Czhs8FIDhMTm0TUeo86BlPbKFmCICeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=X6C/N3Hb; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="X6C/N3Hb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=XaYU9Wbn4fwn3k9kyBk0uiaNLW5c1SeE0TL9SWNic6A=; 
	b=X6C/N3HbTciFbCwii+IIdfYvkp7VMI0qIueorWKxAYA6v56XYdOpOKFtD9+YKUMMjjgMNyDig/A
	75p+y9E3plm5QFUM7o56BBkOqk3Z4X3ubEINQOQtc3Uk2jhZWl8roT5Kw3zj4jiiuGnpcxULwdC53
	/HuQ+csozYO21TD5d6ou3jc3ZgQsS2LLKThssPlerzJbXNbwjXkpL3TIrDSJGMmvtQ0mwk5nrxqlo
	cbVkVTmLBKptr3qpC/IorlwphJflmL3b4iBou47bKKkmBqw4zZgJOTMrXM/k8tWFHzbtWVEPw0O/n
	AG3UEpXrOD8BdRLX9sODTHYIZBiFgGloR+ig==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1v9ff4-00DN17-1n;
	Fri, 17 Oct 2025 16:18:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Oct 2025 16:18:06 +0800
Date: Fri, 17 Oct 2025 16:18:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Shivani Agarwal <shivani.agarwal@broadcom.com>
Cc: davem@davemloft.net, smueller@chronox.de, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
	ajay.kaher@broadcom.com, alexey.makhalov@broadcom.com,
	tapas.kundu@broadcom.com, vamsi-krishna.brahmajosyula@broadcom.com,
	srinidhi.rao@broadcom.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] crypto: zero initialize memory allocated via
 sock_kmalloc
Message-ID: <aPH7vuz7Z3dunQbk@gondor.apana.org.au>
References: <20250924060148.299749-1-shivani.agarwal@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250924060148.299749-1-shivani.agarwal@broadcom.com>

On Tue, Sep 23, 2025 at 11:01:48PM -0700, Shivani Agarwal wrote:
> Several crypto user API contexts and requests allocated with
> sock_kmalloc() were left uninitialized, relying on callers to
> set fields explicitly. This resulted in the use of uninitialized
> data in certain error paths or when new fields are added in the
> future.
> 
> The ACVP patches also contain two user-space interface files:
> algif_kpp.c and algif_akcipher.c. These too rely on proper
> initialization of their context structures.
> 
> A particular issue has been observed with the newly added
> 'inflight' variable introduced in af_alg_ctx by commit:
> 
>   67b164a871af ("crypto: af_alg - Disallow multiple in-flight AIO requests")
> 
> Because the context is not memset to zero after allocation,
> the inflight variable has contained garbage values. As a result,
> af_alg_alloc_areq() has incorrectly returned -EBUSY randomly when
> the garbage value was interpreted as true:
> 
>   https://github.com/gregkh/linux/blame/master/crypto/af_alg.c#L1209
> 
> The check directly tests ctx->inflight without explicitly
> comparing against true/false. Since inflight is only ever set to
> true or false later, an uninitialized value has triggered
> -EBUSY failures. Zero-initializing memory allocated with
> sock_kmalloc() ensures inflight and other fields start in a known
> state, removing random issues caused by uninitialized data.
> 
> Fixes: fe869cdb89c9 ("crypto: algif_hash - User-space interface for hash operations")
> Fixes: 5afdfd22e6ba ("crypto: algif_rng - add random number generator support")
> Fixes: 2d97591ef43d ("crypto: af_alg - consolidation of duplicate code")
> Fixes: 67b164a871af ("crypto: af_alg - Disallow multiple in-flight AIO requests")
> Cc: stable@vger.kernel.org
> Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
> ---
> Changes in v2:
> - Dropped algif_skcipher_export changes, The ctx->state will immediately
> be overwritten by crypto_skcipher_export.
> - No other changes.
> ---
>  crypto/af_alg.c     | 5 ++---
>  crypto/algif_hash.c | 3 +--
>  crypto/algif_rng.c  | 3 +--
>  3 files changed, 4 insertions(+), 7 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
