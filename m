Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3E81649CC;
	Fri,  9 Aug 2024 04:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723177762; cv=none; b=ALLsRSZ6VW8PGfhFCjjI1kswmRtHPpYxH7cWrDfzgynEgPdbBsFeFpqCLtLq8vAuzp5L7CelNBM4Qw8kre6DeOgFxbFaLbXumfqJqzQ8dc1hbMzohozIE9dmDJ4F6K/P7p3PCOIO3zkov0W8dvBHGXwyLRSxIg7DtYHh/WP0rL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723177762; c=relaxed/simple;
	bh=VjZqan/cHU62V9lEkU9kx5uqw9w4yOTjy7SUjTrnCqg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AEEASxjNdYlJf8vp+MP+Nv9WAcogJnqH/J4neDz889GewbAHR2r6mBr1pGwsXDBZHOqQqoX01bkWVSbg6NeFGDkHCueJk5f3BTlgmD7Uzli09D4hYRSFUtdBGdMrhDPu2FSVVYK5/WwiyCtgRWBiTuvqxNTLPKeLCyweCeY6OQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1scH6r-003TJF-2i;
	Fri, 09 Aug 2024 12:28:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 09 Aug 2024 12:28:58 +0800
Date: Fri, 9 Aug 2024 12:28:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Roman Smirnov <r.smirnov@omp.ru>
Cc: "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	"zohar@linux.ibm.com" <zohar@linux.ibm.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: mpi: add NULL checks to mpi_normalize().
Message-ID: <ZrWbCnhg1XYIk5IB@gondor.apana.org.au>
References: <20240716082825.65219-1-r.smirnov@omp.ru>
 <ZqzVPGCbwAS8ChEa@gondor.apana.org.au>
 <4ea0ced79912e810e2655bf21896937bd8f8d24e.camel@omp.ru>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ea0ced79912e810e2655bf21896937bd8f8d24e.camel@omp.ru>

On Wed, Aug 07, 2024 at 02:20:36PM +0000, Roman Smirnov wrote:
>
> Svace found a similar case but it is no longer relevant:
> 
> NULL constant:
>     mpi_ec_mul_point()
>       ec_mulm(z3, point->z, z2, ctx)
>         ec_mod()
>           mpi_mod()
>             mpi_fdiv_r()
>               mpi_tdiv_r()
>                 mpi_tdiv_qr()
>                   mpi_resize()
>                     kcalloc()

In general, I think it's better to deal with the error at the
point of allocation.  So whoever calls mpi_resize should check
for errors and return an error if appropriate.

We can deal with this if this function is ever reintroduced.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
