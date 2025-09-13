Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6AAB1D88D7;
	Sat, 13 Sep 2025 04:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757737597; cv=none; b=lYYoHlZ5a6K/L7Vbfnwc52m07xiplBCkKUal0YRAOZGiDLWdNYpsYn4CbEJQTDgfeLgqGGGTFlBpSdX6dSif6aQs2/AiUDPLtwRWbwF11Eu6XvfXAgUN/pcLVNDpEdJ+MpeoXQ9rKHUlvgalOSAnmzAxDCneQK5/hoRcMPuJNw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757737597; c=relaxed/simple;
	bh=SI6qYbGtTZ+uBCkzeOyv60NcU4kjXBnoLD9zdEo3zPI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FrnXviAGhnMjcWDhAJaFMRZSLyJdRqEM8e+HlachSM+JalKCZNx3HdGmTjg11jWWglNVSzLk8ymH3qFI5lygGDBbB8gbi05MLhqsLXq5D0J2sNHO2NHstIpKfa7Yrt/pXbDU2reXs9Uch0E52s+wxrHUX+aOcS5/g/UBUfofEJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=YoBNIwpw; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="YoBNIwpw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=yHbu/VpA1M6tYXJjA1n95RXGK7JDygip5jRKebV1vEs=; b=YoBNIwpwcb/iN3H15zASzEM8pK
	CEuLIKj3lHP4uwq3usELwRnIFPlBxKM/aOTzZfIh7x/so+Ur1TyMXsgzvDx2kCALvEOkzcEs6mJaB
	na1KHjdOTa8hd3iY6PrXvhyWSF5uFlcDgA463oJj5+B25JwMsQqCvONiHdwiAGHF3Xj+lG42qaq0a
	j+biXWJbes+wy4kTYIPMxcb8QjHS+94J51CQ3elmxWhsQp/izA+C9HHAPFk+iGh3AObYF85KDqWHt
	epGw7t9fccySNHenfNH2DhcrjFZZcBR/ghkwdWKdqxE3213NSKApJaPjHX2qLDVszbEWzIPjUhqkH
	fY7LsphA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uxHad-0053nK-08;
	Sat, 13 Sep 2025 12:26:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 13 Sep 2025 12:26:15 +0800
Date: Sat, 13 Sep 2025 12:26:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Cc: clabbe.montjoie@gmail.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, wens@csie.org,
	jernej.skrabec@gmail.com, samuel@sholland.org,
	linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/9] sun8i-ce: small cleanups/refactoring
Message-ID: <aMTyZz_keDm_WOoR@gondor.apana.org.au>
References: <20250902132134.3287515-1-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902132134.3287515-1-ovidiu.panait.oss@gmail.com>

On Tue, Sep 02, 2025 at 04:21:25PM +0300, Ovidiu Panait wrote:
> This series includes only the refactoring commits from [1]. The batching
> related changes were dropped since they are no longer relevant (batching
> support in crypto_engine was retired in [2]).
> 
> This series includes various small cleanups and refactoring:
> - move request-specific skcipher and hash data to request context,
>   eliminating the need to allocate extra memory in the digest path
> - make the hashing code more clear and modular
> - reduce a bit of boilerplate/duplicated code
> 
> Changes in v3:
>    - dropped ____cacheline_aligned attributes from buffers used for
>      to-device DMA only
>    - set up proper alignment for ahash reqctx, in order to allow from-device DMA
>      into reqctx buffer:
>       * increased ahash reqsize by CRYPTO_DMA_PADDING
>       * added __aligned(CRYPTO_DMA_ALIGN) attribute for the 'result' buffer
>       * converted all ahash_request_ctx_dma() calls to ahash_request_ctx_dma()
> 
> Changes in v2:
>    - fixed [-Wunused-but-set-variable] warning reported by kernel test robot
> 
> [1] https://lore.kernel.org/linux-crypto/20250626095813.83963-1-ovidiu.panait.oss@gmail.com/
> [2] c470ffa6f486 ("crypto: engine - remove request batching support")
> 
> Ovidiu Panait (9):
>   crypto: sun8i-ce - remove channel timeout field
>   crypto: sun8i-ce - remove boilerplate in sun8i_ce_hash_digest()
>   crypto: sun8i-ce - remove unnecessary __maybe_unused annotations
>   crypto: sun8i-ce - add a new function for dumping task descriptors
>   crypto: sun8i-ce - move bounce_iv and backup_iv to request context
>   crypto: sun8i-ce - fold sun8i_ce_cipher_run() into
>     sun8i_ce_cipher_do_one()
>   crypto: sun8i-ce - pass task descriptor to cipher prepare/unprepare
>   crypto: sun8i-ce - save hash buffers and dma info to request context
>   crytpo: sun8i-ce - factor out prepare/unprepare from
>     sun8i_ce_hash_run()
> 
>  .../allwinner/sun8i-ce/sun8i-ce-cipher.c      |  85 +++++-----
>  .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c |  35 ++---
>  .../crypto/allwinner/sun8i-ce/sun8i-ce-hash.c | 145 ++++++++++--------
>  .../crypto/allwinner/sun8i-ce/sun8i-ce-prng.c |   1 -
>  .../crypto/allwinner/sun8i-ce/sun8i-ce-trng.c |   1 -
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h  |  27 +++-
>  6 files changed, 147 insertions(+), 147 deletions(-)
> 
> -- 
> 2.50.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
