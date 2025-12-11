Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7911F13A3F7;
	Thu, 11 Dec 2025 03:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765422174; cv=none; b=C43aqLNqvL00mytAmquNo2x3IvzRA0BMXFgXYL4M8Y3APSGH1pneylhpRGt/tnoXbwjcuxWFDyEb4c5KEErNz6wMpJyHPqmGqFMVrv1fbKpETyXAVwN6WQ6vP3ZaCp9geukgihZj2xHlUuvSAn8ruKPXFeM1PCnBA5aXe/t92Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765422174; c=relaxed/simple;
	bh=6XwPPfQ34j9vwMHBeL7usX3v9sGH3pQOWGJDgnzsgCY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q+80DFQ6oXKoMxdwUP/43wfBZC95ObKDhJcW7eTz2KTDb2cLRS2str6svhnHfi0O3JbbQfEcHtsi+L+fUhMLVwjBTjuorusFrT7+ZwptvUJ6ym/pLCaxrEXwa4Z3xjS5HkG8H+L9MVaeODWI7XY1WybaUmP1jZq1ToP5OiIje9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=li6jKn1o; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="li6jKn1o"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Ab0FOhkIM5QumDMBprCrgDZnmVYT79yg0jygQ9fAPvw=; 
	b=li6jKn1ougyD6RBhgVydfDTP71NTHurxiVBzQ2cVzkK/9ZDI7XQmxzFEMtIjOjvxQ92eEq7GQyt
	4JSj110hWObEsSJ0lQsvHRPyGHJ2uJeQdV40rUCi2o0zvmdGaGyUYKkXmVvaOvbgy3a/LL8veO0Wd
	rYJ+teHHXgkZVBUSxrBv02fUANHvyYMnXQ+O6XT8V+jraU4DukTSyyAbxWWMaTtkI5xhFpgMxE7Zo
	CAZtWDO3JS8vJqF/YkZQH16p26oT238O98YQ8ItUgDHZW62xESbpYYT6RjOeZlNeGYymhopyMpl8n
	ePTLve4Pj6JVEi/12Z1lW2tXPbDPDjCaT/Cw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vTWx5-009PDa-27;
	Thu, 11 Dec 2025 11:02:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 11 Dec 2025 11:02:47 +0800
Date: Thu, 11 Dec 2025 11:02:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	linux-arm-kernel@lists.infradead.org, x86@kernel.org
Subject: Re: [PATCH 10/12] crypto: nhpoly1305 - Remove crypto_shash support
Message-ID: <aTo0V7fD6PqrArFN@gondor.apana.org.au>
References: <20251211011846.8179-1-ebiggers@kernel.org>
 <20251211011846.8179-11-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251211011846.8179-11-ebiggers@kernel.org>

On Wed, Dec 10, 2025 at 05:18:42PM -0800, Eric Biggers wrote:
> Remove nhpoly1305 support from crypto_shash.  It no longer has any user
> now that crypto/adiantum.c no longer uses it.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  crypto/Kconfig              |   6 -
>  crypto/Makefile             |   1 -
>  crypto/nhpoly1305.c         | 255 ------------------------------------
>  include/crypto/nhpoly1305.h |  74 -----------
>  4 files changed, 336 deletions(-)
>  delete mode 100644 crypto/nhpoly1305.c
>  delete mode 100644 include/crypto/nhpoly1305.h

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
