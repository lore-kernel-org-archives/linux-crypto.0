Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AB41E2889;
	Fri,  2 Aug 2024 12:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722602836; cv=none; b=SOHOwHm9S5S089qkIt9R0hjoa5pke+GMRHiz+XZt9IxcC4ddoDKy7NRGCqSmTnARtq7578Tt671uAiDclqbykL8P3M0AlGhhal61KOSTPIACnDoZuloAZ58fK7PhX1errVAp9vZCd1pllR3X19NfuDbTUbWZPKde/UG4BnoiU+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722602836; c=relaxed/simple;
	bh=QwtvSHP8orsfWRhmoOyhHXEUD00kRv35Tia6kl9g/64=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mcn3EuvgNUg20LhlK9UN5YTwrkBjyUqPuo+hDm7yqrIU5vxRaZQiiPnJLA/c85xSz4bkqzW6gmQw1S1vZxqcphMJ6YKA9n1lGCMCB1TJj6IrJjdtS4xMm+QWMuw9NuellaUw+OvId0n+d/6j+A4QSAS3k0ti96Q4VL9dKa+zgfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sZrXr-001zj2-0Q;
	Fri, 02 Aug 2024 20:46:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Aug 2024 20:46:52 +0800
Date: Fri, 2 Aug 2024 20:46:52 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Roman Smirnov <r.smirnov@omp.ru>
Cc: "David S. Miller" <davem@davemloft.net>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sergey Shtylyov <s.shtylyov@omp.ru>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH] crypto: mpi: add NULL checks to mpi_normalize().
Message-ID: <ZqzVPGCbwAS8ChEa@gondor.apana.org.au>
References: <20240716082825.65219-1-r.smirnov@omp.ru>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240716082825.65219-1-r.smirnov@omp.ru>

On Tue, Jul 16, 2024 at 11:28:25AM +0300, Roman Smirnov wrote:
> If a->d is NULL, the NULL pointer will be dereferenced. It
> is necessary to prevent this case. There is at least one call
> stack that can lead to it:
> 
>     mpi_ec_curve_point()
>       ec_pow2()
>         ec_mulm()
>           ec_mod()
>             mpi_mod()
>               mpi_fdiv_r()
>                 mpi_tdiv_r()
>                   mpi_tdiv_qr()
>                     mpi_resize()
>                       kcalloc()
> 
> mpi_resize can return -ENOMEM, but this case is not handled in any way.
> 
> Next, dereferencing takes place:
> 
>     mpi_ec_curve_point()
>       mpi_cmp()
>         do_mpi_cmp()
>           mpi_normalize()
> 
> Found by Linux Verification Center (linuxtesting.org) with Svace.
> 
> Signed-off-by: Roman Smirnov <r.smirnov@omp.ru>
> ---
>  lib/crypto/mpi/mpi-bit.c | 3 +++
>  1 file changed, 3 insertions(+)

I've just posted a patch to remove mpi_ec_curve_point and mpi_tdiv_qr.
Are there any other code paths with the same problem?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
