Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89671373
	for <linux-crypto@vger.kernel.org>; Wed,  2 Apr 2025 17:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743615178; cv=none; b=oqBQY+TiVh607Axn3S9SZDTrs9PVtQZCcCaqZNwYo70BDwmUmGU99aFPs8MWq0I6q35XFzZ7K5jGZaVC0HsJ/GBPZAgc/cX9ko9nOpwLFHQUpg7CpuNg5RS4e5S+JDFminRwUp0ZmC08fTzilCZaza7BhD6TMkdek0j7ulRWSks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743615178; c=relaxed/simple;
	bh=PDBx9Mwlt0VuTbkCTuvBag9RIYTLpzY//Vox7KarUw4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uGMWRKR1mD5NnMdD4Ai1G3mAUwWiZG4uNW+VO4W7rBrPd6NbyiMq/pmo1FmnQXpuAei+ZvHx1MhF5sL46JhKrZj0O2I2kAFRVYc8P6aQbeRjGkAJXv7WElJlk5Whnr78DtVUQrH9YS9YUlb8rpKZWFQ3c89tqxnM2dSr9t56S9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DB0fJMwp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DB0fJMwp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257B8C4CEDD;
	Wed,  2 Apr 2025 17:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743615177;
	bh=PDBx9Mwlt0VuTbkCTuvBag9RIYTLpzY//Vox7KarUw4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DB0fJMwpTUWTW1iCebVH6P0kAvwOA2No1jlc/2TFO+dCOoIp05YHe/raiBCYb0RgZ
	 kvmQ3YQHXfLlDj1TQ8KPtIuDEKTurkjTOoB3JMm9TB9U+hDIfTF2CWvwcmOFfFOwOI
	 rhUmUP5SFYqNwmXX/aKWZ8/laVB5U9sPAQH0A0/T7hCwpgFXUd961rGjWhAPDbzTQb
	 2T/eqNrEh1fJxi5Y5BELHOwdlroSpdupxfBd99VEfC/ons0lzKJQNdrBHcF/vocsFf
	 CcKALAhS+vIbvPb2gfJGxRjVOCYzjJUla9PA7o5oc0SE1j8NDLm+Uq7G32eTxxXyvX
	 +I1eK7jHyO6mw==
Date: Wed, 2 Apr 2025 10:32:55 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH 1/2] crypto: arm/aes-ce - stop using the SIMD helper
Message-ID: <20250402173255.GF1235@sol.localdomain>
References: <20250402070251.1762692-3-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250402070251.1762692-3-ardb+git@google.com>

On Wed, Apr 02, 2025 at 09:02:52AM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> Now that ARM permits use of the NEON unit in softirq context as well as
> task context, there is no longer a need to rely on the SIMD helper
> module to construct async skciphers wrapping the sync ones, as the
> latter can always be called directly.
> 
> So remove these wrappers and the dependency on the SIMD helper. This
> permits the use of these algorithms by callers that only support
> synchronous use.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm/crypto/Kconfig       |   1 -
>  arch/arm/crypto/aes-ce-glue.c | 102 ++++------------------------------
>  2 files changed, 11 insertions(+), 92 deletions(-)
> 
> diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
> index 32650c8431d9..2fa8aba8dc12 100644
> --- a/arch/arm/crypto/Kconfig
> +++ b/arch/arm/crypto/Kconfig
> @@ -197,7 +197,6 @@ config CRYPTO_AES_ARM_CE
>  	depends on KERNEL_MODE_NEON
>  	select CRYPTO_SKCIPHER
>  	select CRYPTO_LIB_AES
> -	select CRYPTO_SIMD
>  	help
>  	  Length-preserving ciphers: AES cipher algorithms (FIPS-197)
>  	   with block cipher modes:
> diff --git a/arch/arm/crypto/aes-ce-glue.c b/arch/arm/crypto/aes-ce-glue.c
> index 21df5e7f51f9..c17d9e4ad8e6 100644
> --- a/arch/arm/crypto/aes-ce-glue.c
> +++ b/arch/arm/crypto/aes-ce-glue.c

The following includes can now be removed from this file:

    #include <crypto/ctr.h>
    #include <crypto/internal/simd.h>

Otherwise this patch looks good.  Thanks!

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

- Eric
