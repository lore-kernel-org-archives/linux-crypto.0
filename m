Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445BD2580DE;
	Thu,  2 Oct 2025 16:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759422011; cv=none; b=gVRL+wcJwBWEzjV2a5NKII/cV8XPKBtDfXniW0WatT9lXcdnee8k7KK+mM384fTAxMw5t/P7oh7BU8kenZkfFn+xo/GmjvEfdln73rvlh0T3hJw9usyNWHJf69Idx1ldeg0h+iednCMDkT4JDFHn4oXgIuLT0EjiEalPf40MFzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759422011; c=relaxed/simple;
	bh=OxqQDGMDmx2w7gfRNWA+e+czIuGiEoxutb/vwzJrrRY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LVl+sJMm4Q5tr9Sfjggch/AmlvKzhRmsP+CNhgfmbKOCjpxDkuABruQ2eXdXVgU7FSn32oo4wZqwmkZ8upuh5ZJYh7J36YTNe3bpMoupvZ5JN/FwCoagnWdCn8hlwPmCI0d2Oes65bwW84IYUD0wDuzxicntfS1j/y2GIEC3eCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tj/YiZ/T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tj/YiZ/T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18852C4CEF4;
	Thu,  2 Oct 2025 16:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759422011;
	bh=OxqQDGMDmx2w7gfRNWA+e+czIuGiEoxutb/vwzJrrRY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Tj/YiZ/TobyIeKv7q1W9iU8j8CxlU714gulY6x5ee8E99AufPrsZp8nuXuZ47+SAX
	 pUlG9R5AoknegrncPU9bU8JUAqovMuANAxMkLj8VUvQPubYAxyPdLiWPYrfktgn6rU
	 FBB7W1AIg++rkuDKZpLnQwMC+hM4JAAEEuTczdXCoBbi2dQ7T3/FtWakBvinDavAaE
	 IEXJSGDQL839fOuhb3Q0xrrmSQlPDpu3C815JeiU/kAKnMI9RKcXBpuIyLZVFDubWf
	 QpsnQNgcHb2YYP4UWm1cMo2JDpD7f/AxpVvfMGVmsaXRUqR7cLsN+5JkqqJ5AdjNeZ
	 mCZWGxx5tGfJQ==
Date: Thu, 2 Oct 2025 09:20:10 -0700
From: Kees Cook <kees@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
	linux@armlinux.org.uk, Ard Biesheuvel <ardb@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Brown <broonie@kernel.org>, Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v2 04/20] crypto: aegis128-neon - Move to more abstract
 'ksimd' guard API
Message-ID: <202510020918.7E358227@keescook>
References: <20251001210201.838686-22-ardb+git@google.com>
 <20251001210201.838686-26-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251001210201.838686-26-ardb+git@google.com>

On Wed, Oct 01, 2025 at 11:02:06PM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> Move away from calling kernel_neon_begin() and kernel_neon_end()
> directly, and instead, use the newly introduced scoped_ksimd() API. This
> permits arm64 to modify the kernel mode NEON API without affecting code
> that is shared between ARM and arm64.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  crypto/aegis128-neon.c | 33 +++++++-------------
>  1 file changed, 12 insertions(+), 21 deletions(-)
> 
> diff --git a/crypto/aegis128-neon.c b/crypto/aegis128-neon.c
> index 9ee50549e823..b41807e63bd3 100644
> --- a/crypto/aegis128-neon.c
> +++ b/crypto/aegis128-neon.c
> @@ -4,7 +4,7 @@
>   */
>  
>  #include <asm/cpufeature.h>
> -#include <asm/neon.h>
> +#include <asm/simd.h>
>  
>  #include "aegis.h"
>  #include "aegis-neon.h"
> @@ -24,32 +24,28 @@ void crypto_aegis128_init_simd(struct aegis_state *state,
>  			       const union aegis_block *key,
>  			       const u8 *iv)
>  {
> -	kernel_neon_begin();
> -	crypto_aegis128_init_neon(state, key, iv);
> -	kernel_neon_end();
> +	scoped_ksimd()
> +		crypto_aegis128_init_neon(state, key, iv);
>  }

For these cases (to avoid the indentation change), do you want to use
just "guard" instead of "scope_guard", or do you want to explicitly
require explicit scope context even when the scope ends at the function
return?

-- 
Kees Cook
