Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56CBD211A3C;
	Mon, 19 May 2025 06:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747634663; cv=none; b=a6rxZSQSqZzWTuExjGiuYsca9j7NprkOgvgymCOpyEd/E6GXSSPbTcFT/fhFik4HsLd8cpxRYMaIRjq41n4QE07J6oGh5KfB3+is51/vSu73jXzghrD3LbysvMysxg7EdEfNe3ieMr7zFjyxm3+b3Sr3UhhxPcv/pjtMX5KylOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747634663; c=relaxed/simple;
	bh=0HtQRntL0Bt/WmIfukICCNL1PHzImHN45NrHmLn0O2c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZtF0g8NjHndg/JbcljyAvYvGOHA3UljeVpP192XrjO9URZoLlL5jGETIMxM9UJF/0YIvNrf8dzqxYyLroBLOdJj6qJT5tPfMWFj+q+A981GmuNAAzLsRViZYUWWFYowtmnYfKmjuxEm8UjYIYkkyFTcsH6RhjvjD05krLakZsvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=fw4Y/3pw; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="fw4Y/3pw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ecqYsfNOrcyjwIG/bdG9qR1VqNqvGjWgpDIJB/3BtXg=; b=fw4Y/3pw40asseQ+jAmB919xiV
	bJs3PEmrgCaMRGleSYQDkDgv7VyeZRFVUpa3w8+QxUTcYkvWc6+R0FfIOJ+91HOTgShkhisCQgMdW
	61HU5Q1N+GohRwmO5pskriqTW1enKbDMf7GcYQnflnQvmaKNIv9Rj1ONC4OzmJ63VVl71b+R+iR+l
	FTKUiHx80coH1jIRCzoiDMwUDvln8oWmvZh9cYiAK6MA7YQbvCqmljmQSvK4jkHad8CFeqTrfWOwo
	DgRMuEMtVOe6gL3pXchkEOjUVd0sUvR0gKCN/2Iw3ar4PuveScFFUeZngwJHciS4qHW4grzji1Tnp
	R4D4CxIw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uGtbl-0078Cz-1s;
	Mon, 19 May 2025 14:04:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 19 May 2025 14:04:17 +0800
Date: Mon, 19 May 2025 14:04:17 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ivan Pravdin <ipravdin.official@gmail.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: algif_hash - fix double free in hash_accept
Message-ID: <aCrJ4ftEQ34opaa7@gondor.apana.org.au>
References: <20250518224102.478904-1-ipravdin.official@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250518224102.478904-1-ipravdin.official@gmail.com>

On Sun, May 18, 2025 at 06:41:02PM -0400, Ivan Pravdin wrote:
> If accept(2) is called on socket type algif_hash with
> MSG_MORE flag set and crypto_ahash_import fails,
> sk2 is freed. However, it is also freed in af_alg_release,
> leading to slab-use-after-free error.
> 
> Fixes: fe869cdb89c9 ("crypto: algif_hash - User-space interface for hash operations")
> Signed-off-by: Ivan Pravdin <ipravdin.official@gmail.com>
> ---
>  crypto/algif_hash.c | 4 ----
>  1 file changed, 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
