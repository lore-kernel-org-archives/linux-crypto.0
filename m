Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1029A43BDA0;
	Wed,  7 Oct 2026 22:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791412654; cv=none; b=hTW5BH4YRW2C6AbhEjC7W0rL9DIvtSmpnLNhMrY8tJLXs7Y1vCQdeKIQWSzFX9d/WuwX+vwJJNGdRdrtIfVbJw1r4YngfTElbpo+20LMncvwr9TI7Ppx7u9wedE+8E7tseQSEh2T8RTZlijwAHQhFY4ExB2rmMgzj9tKD/3Dsn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791412654; c=relaxed/simple;
	bh=G9xv3wDpg5Ngwcp/X0keDDatoMA/PUwJxG3No0lZ0uU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t4XgMnH8mxtjZ0j5BP+pZG9rypkhYrsZ8WwEL9a3p561mOERNQIul6YbGAcp/3mF4oPFtaw7CQxlTpHGscTCsppHmTem7nzqCIkUwSrYDRSZt8jecaak4lzWTfKIn5atALa8eEUp0uMu110QjVS8LijCsBhY0R4yMhCWUnfdxPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l4VK5rRQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l4VK5rRQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E691F000FF;
	Wed,  7 Oct 2026 22:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791412652;
	bh=y5Eb6wDN3K+IXIlDEkTMmRQzs1wHV9zCpiZ2/PHKpJg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=l4VK5rRQYJL0qcq9g0tv7vE/oUgY/q4t4pSyAeKEletXiqDAKhczjPFxKBL+irrg9
	 9/OENVKxvsc2NI91WpHOMCU9U6A1wm27SvtKdF0aBV9xfSUp6iJ541Q1fEVmLp+1dF
	 5wYxyZon1RG2lLKJd8pj/Z7mnvpQJY/k8pfJ3Qw3j0LmzRjcRYpWsYfYmmENOZ5icS
	 lvX//ZWhNhxYPilne4kiF4C32k+e6NGmKv1vTWZW4JirPzWRSG7b2y2VG17fxLl7jO
	 bmkh0QqAIFOu5ht/m2nTpM1d98oqta62PvphTUinQusm67jeJoDvO0sUDukCe9OkzH
	 pESc++MeIaXJg==
Date: Thu, 8 Oct 2026 00:37:26 +0200
From: Eric Biggers <ebiggers@kernel.org>
To: =?iso-8859-1?B?Suly6W15?= Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: arm64: Fix lost Poly1305 carry when resuming
 NEON state
Message-ID: <20261007223726.GA24521@quark>
References: <20261007220235.200818-2-Jeremy.Jean@oss.cyber.gouv.fr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261007220235.200818-2-Jeremy.Jean@oss.cyber.gouv.fr>

On Wed, Oct 07, 2026 at 10:02:36PM +0000, Jérémy Jean wrote:
> When poly1305_blocks_neon() resumes from a radix-2^26 state with an odd
> number of input blocks, it converts the accumulator back to radix-2^64
> before consuming the first block. The final ADC stores the carry into d2,
> but the following accumulation and poly1305_mult() use h2.  If the
> conversion overflows across bit 128, the carry is dropped and the emitted
> tag is wrong.
> 
> Store the carry back into h2. This matches the other conversion paths and
> preserves the represented accumulator.
> 
> Fixes: f569ca164751 ("crypto: arm64/poly1305 - incorporate OpenSSL/CRYPTOGAMS NEON implementation")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
> ---
>  lib/crypto/arm64/poly1305-armv8.pl | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/crypto/arm64/poly1305-armv8.pl b/lib/crypto/arm64/poly1305-armv8.pl
> index f1930c6..234398f 100644
> --- a/lib/crypto/arm64/poly1305-armv8.pl
> +++ b/lib/crypto/arm64/poly1305-armv8.pl
> @@ -375,7 +375,7 @@ poly1305_blocks_neon:
>  	adc	$h1,$h1,xzr
>  	lsr	$h2,x14,#24
>  	adds	$h1,$h1,x14,lsl#40
> -	adc	$d2,$h2,xzr		// can be partially reduced...
> +	adc	$h2,$h2,xzr		// preserve carry into top limb

This needs a regression test in lib/crypto/tests/poly1305_kunit.c.

Please include more details in the commit message about under what
circumstances that carry bit could be nonzero.

It seems this was introduced by commit 03dc4adf91c8bc of
https://github.com/dot-asm/cryptogams just before the kernel imported
the code.  The bug never reached the copy of this file in OpenSSL.  Do
you agree?  If so, please mention this information in the commit message
too, and also open an issue at https://github.com/dot-asm/cryptogams so
that it can be fixed there as well.

- Eric
