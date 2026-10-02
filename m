Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C935E374A12;
	Fri,  2 Oct 2026 10:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790935930; cv=none; b=EgJbPIYUJuXV9Rfpq0mgI+WLcnToCGl89a7yhyu7trbL9sEN4Ye8hpL+LoqKEVWaSKe/w0lyQCT5JQxHIG3rtC7VTBEI3G1SrC8MuGY7kWpg2u3XkUB0WTf0mBMLUudf0RX5D0Hf9TC3tiG9guQggPr6+CCYduRGgaNQCHv0v30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790935930; c=relaxed/simple;
	bh=yvrjWUMyCAnARlPBCBiRvYB21dUAPlfGyJkRS/7mps8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PkV88CWWFKNIu5Ji41eFU8xj8kuEsQCUWA+Pe+bQDrHEaQSKWro0wp8FE3koLlGBUJnsAlh6X8aplN7U6ZT6zlueSfP0+u0246/KhFpUdbOmfiZiZ/ItGF3DNC3ygRw3CaCM6JezqB9yxpaiyLfwceM6hQK7xZfJpgffx6Sd/4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Yc4MDBxM; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Yc4MDBxM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=CFT1MPqw1zKRb3EQNSatMDnaAsiHgSgy+AoUrzQGQwQ=; 
	b=Yc4MDBxMK26JaaOE/7sz4QQ72cmEYkZclGNMzEnVoMp3h6cEzOLlUbDPSlRUACaI2MYXfq88hPf
	AE9xNfj8nrSefRJXO2NOpFX47W2DYtgeOl8RaplLzVASVXPEZmP+XgurBBaNrun1O7HE5LlZGd1qJ
	H1KGmC51FndGpgJAtSARf/hr2pHYYGfcCiY3+1BN7ebz68cohRYwupzssT5By+9e/+vGN+A+Xgm8x
	3mZh1G3M0HiMl5kA3qGFGLjCLqtBU8CPmyN6zQplEzro6JGqlWyq658rSIQtf/JyVGnk7E9wsh3bb
	N7TEgHWpt8ZIgXrxygSabhyecZOG3JgazeFg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xCaFI-000000001hJ-0MZP;
	Fri, 02 Oct 2026 18:12:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Oct 2026 20:12:04 +1000
Date: Fri, 2 Oct 2026 20:12:04 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <blum@kernel.org>
Cc: Olivia Mackall <olivia@selenic.com>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig_=28The_Capable_Hub=29?= <u.kleine-koenig@baylibre.com>,
	Kees Cook <kees@kernel.org>,
	Corentin LABBE <clabbe.montjoie@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: amd - report partial reads in non-blocking mode
Message-ID: <ar-DdJo4QONspJwn@gondor.apana.org.au>
References: <20260923201259.90336-2-blum@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923201259.90336-2-blum@kernel.org>

On Wed, Sep 23, 2026 at 10:12:58PM +0200, Thorsten Blum wrote:
> amd_rng_read() returns 0 if no more data is available, even if some data
> was already copied to the output buffer. Return the number of copied
> bytes instead.
> 
> Fixes: 85962d2248fa ("hwrng: amd - Convert to new hwrng read() API")
> Cc: stable@vger.kernel.org
> Signed-off-by: Thorsten Blum <blum@kernel.org>
> ---
>  drivers/char/hw_random/amd-rng.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
