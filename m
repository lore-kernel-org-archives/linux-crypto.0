Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D67B35DA42
	for <linux-crypto@vger.kernel.org>; Wed, 15 Apr 2026 18:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776276061; cv=none; b=Z1PCOzZGrZez3h3wLIXS7LR4q6C1ppQCeWHvZ0JrxPcGyw+yLWKSat9HVqgI9W17JYnnkXFJrwp0QZZCmoFMgMfdogMDbPdjKVzXhLRx53QNe+cUhG6I0U9b5yWVL7WUYAeasPnzkFY2bkgHUBRzLJed7nuOGL1c2GMLuZF8ZJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776276061; c=relaxed/simple;
	bh=VPBvair3W2M3Ljf9VyfmlSdBd+CurMSIXOB9iZZhMMU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gWm4ISaMJ1oq1i1/ypnSm+VkJTR/iqLVhpquCOIAwZkUhA8mX4Ez2SCC+BroS9+CEg0FO1/hhFlxEMTe8rnF9R1YyiplELOZ7a+zi8+YXAtmaj0ARy/A6LgfJuUYx3p4P7K41VEm36sq7j04rwg8F998XoWLwSsq27JPhltFLoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XiiLGAPp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XiiLGAPp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80011C2BCB5;
	Wed, 15 Apr 2026 18:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776276060;
	bh=VPBvair3W2M3Ljf9VyfmlSdBd+CurMSIXOB9iZZhMMU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XiiLGAPpyOpvJF+8relTHb6zejRdPeSEta4US367grzO0yeYnKiGyu69gf1j/rKm2
	 gbovijvquIZwYf5nHkywHllqnuzvpCxq7UZcscury72CX+5G3kJoYJSAFL5fQgkKFd
	 R+yfIJVGD7/GK0BHBZtvb0F7tyiCeiaPVmy3k+1iFNOe+qoUtIc1PzrrtOqib5ZeyF
	 UiShLfgZqYsAqBPadoY2iH7bT3RkAAQ8BuXx1g5a5DnM4lXO7VVV0FgLZV2hgCsi79
	 5HfBx6TlwnWUhY7aCbkzY4xAh3QLPkUACH8aVdO/0aRZD7L74dZXYOdNATjYJgMeDW
	 z/8cDpyI3cnLA==
Date: Wed, 15 Apr 2026 11:00:58 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Lukas Wunner <lukas@wunner.de>
Cc: Jason Donenfeld <jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>,
	Yiming Qian <yimingqian591@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ignat Korchagin <ignat@linux.win>,
	David Howells <dhowells@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Tadeusz Struk <tstruk@gigaio.com>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: lib/mpi - Fix integer underflow in
 mpi_read_raw_from_sgl()
Message-ID: <20260415180058.GC3142@quark>
References: <59eca92ff4f87e2081777f1423a0efaaadcfdb39.1776003111.git.lukas@wunner.de>
 <20260414175903.GC24456@quark>
 <ad68X6BveJXqynUk@wunner.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad68X6BveJXqynUk@wunner.de>

On Wed, Apr 15, 2026 at 12:14:55AM +0200, Lukas Wunner wrote:
> diff --git a/lib/crypto/mpi/mpicoder.c b/lib/crypto/mpi/mpicoder.c
> index 9359a58..011434d 100644
> --- a/lib/crypto/mpi/mpicoder.c
> +++ b/lib/crypto/mpi/mpicoder.c
> @@ -347,11 +347,9 @@ MPI mpi_read_raw_from_sgl(struct scatterlist *sgl, unsigned int nbytes)
>  	lzeros = 0;
>  	len = 0;
>  	while (nbytes > 0) {
> -		while (len && !*buff && lzeros < nbytes) {
> -			lzeros++;
> -			len--;
> -			buff++;
> -		}
> +		lzeros = count_leading_zerobytes(buff, min(len, nbytes));
> +		len -= lzeros;
> +		buff += lzeros;

Well, now you're passing an uninitialized pointer as a function
parameter.  (The loop body still operates on data from the previous
iteration.)  So no, that isn't a step forwards.  This should be
rewritten as a conventional loop and be switched to the scatterwalk API.

But this is really just a symptom of the larger issue with the pointless
virtaddr => scatterlist => virtaddr conversion that is happening.  And
lib/crypto/mpi/ is broken in other ways too, e.g. it's not constant-time
but is being used for RSA signing.  And it has no tests.

This is on my TODO list to fix up at some point, but it's a big task.
Secure bignum implementations aren't easy; userspace projects have spent
a long time to get them right.  So far I've instead been focusing on
symmetric crypto, which is what actually matters in the kernel.  If
someone is using the broken kernel RSA signing UAPIs (which should never
have been added), they hopefully know what they're getting...

- Eric
