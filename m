Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792551192;
	b=S1yjFwyYHpNNPeha0/cth6botuHEElnLFO/An47j634egHO7vaOI/3Bs0ZRB3CrAiZWT
	 NUocPa7t0nGs8JPuBpHtZDUBd827dUIW/uNWLNyz6jXqAsU94NRiH69lNxVjvy+m8t/Ap
	 29f/9z3kHw6s6f1inPg6X5hdYJS32X4t0cAKOEg9YIN9LdRXh7hhc4qOUq9N0papODKze
	 Bx9qW/AT791I3q2S+ymkU4wucnJVujZUkIAnSai67EdibO3uv6kKPc2KDTm032gePsUMv
	 9g7LMMxuo0xVcABcdfy/w196I6EcVxKsXQv2kQgUIwrNu7qgxpd8aIwYTOh8oNzbuyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792551192;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=QuhvTnF1zPgsHG0vM8JZLp9odAfQPVB0z7rVqZRgIE0=;
	b=HScBZE4a38s6ZtJcliSQb6iRzZNWEoEE/8bHq3yrNycFoS8vuupYBb9fXt1ljXqukq9u
	 RPfSiMI9VC5D3QEbePzk6SJJ9NiVeDvyCUxgEzHh92lcaEKCsoWaf8a7X+ToWhBytQ8uM
	 oZOUQ589ExEjNBP7aTDwaUUCdGX50vkift7UXCS5WYy0AqAoFCjqq7mRu1IWTIEwm11HS
	 l21N/k8fOtprPua3b6GBbJ+RWlF788coLyavXVtDkiwpUTxWhShDoCZbSx1YZajmQeFFS
	 9zuZ4Jx+SqGmxO84vmnICwYHJ47FokBK218TMIF3bjpXRq6c16TTaT56AU+KY1epEug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b="Y/6krfiZ";
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D8B606A319
	for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 02:53:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17D8B606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=Y/6krfiZ
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=QuhvTnF1zPgsHG0vM8JZLp9odAfQPVB0z7rVqZRgIE0=; 
	b=Y/6krfiZ2HPCRpKMt+N4p9aU2wR1LUocy2gLIjctweLyS6rKjYEJcfCccGfD6uqexGQWbI/B9sA
	U3wRRdS0YbmsYk6EYL5y72Ye2CfnVshKlRH8h+Wz8AroegUf62v46yx53UbvWYsObfGhU1Qpfd9s3
	ni2CbGw8PS7RdhsOlVBge5UXo1aE95dJDtWq7Qia6QnCXNhHV+ags41pWTq101RS7x/N0IXCIl9My
	rawOuY+qVKcJY7G3EyGmR6TobqBfT5jeDt/UgGzF9PigwMuNW7xOPeloF3MQsqTNtev+OjfPiyQzW
	n6mcU6x8Q877p+LuhTmaNjJOMIylINufrYdA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xJMRo-000000062LP-2qlP;
	Wed, 21 Oct 2026 10:53:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 21 Oct 2026 10:53:00 +0800
Date: Wed, 21 Oct 2026 10:53:00 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: Enabling Sashiko replies to linux-crypto?
Message-ID: <atgpDBOfPgzlBzLm@gondor.apana.org.au>
References: <20261020215744.GF699485@google.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261020215744.GF699485@google.com>

On Tue, Oct 20, 2026 at 09:57:44PM +0000, Eric Biggers wrote:
> Currently, Sashiko is configured (in
> https://github.com/sashiko-dev/sashiko/blob/main/projects/linux/mailing_lists.toml)
> to monitor linux-crypto for patches, but not to send emails to it.
> 
> Would there be any objections to me opening a pull request that changes
> it to the same setting that I set the fscrypt and fsverity lists to?
> 
>     ["linux-crypto@vger.kernel.org"]
>     reply_to = ["author", "list", "recipients"]
> 
> That would enable emails for issues found, with reply-all.
> 
> (There's also a 'positive_review = "all"' setting that would enable
> emails for positive reviews, i.e. "Sashiko has reviewed this patch and
> found no issues. It looks great!"  But those are kind of noisy.)

Sure that sounds like a good idea.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
