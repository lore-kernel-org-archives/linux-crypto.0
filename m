Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96A01373
	for <linux-crypto@vger.kernel.org>; Wed,  2 Apr 2025 17:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743615027; cv=none; b=YaFwpnEsMM+UDwaY2OmhqThB6oR7EMtmVBXRVZUQ517TirLwBS73mSkWA05vckd6Wyy7EOCCPY5NRRENmt+mFiNJwiEAvNcPXrRuw3nKYmVW6yL4uTXpPTsU1n5DgDPPwSVEtlIkJVRWQe0xHAaJ8CIlFO7z0drdTm+ERbydZrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743615027; c=relaxed/simple;
	bh=E+fPsADjzWGHXU7LsqGEmS5ToStoyx9zhJyWoJ9AdO4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KMXBUVi7L7oeVjSFfdGTlXqeg9xG+TWGUTPghjdOteEo1yql3zWjlR5s2Ox/n8WgX3zNen49J/kW4AIkZfIX5kPltH2DylGreMsMxLMjYlkwfx3VkOu7EMSYgmf69mtKMD43ZtUwEQxwOfv0aTgXGuBZEhrhftEglHxungtWWqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=or6p85ZF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="or6p85ZF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3923C4CEDD;
	Wed,  2 Apr 2025 17:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743615027;
	bh=E+fPsADjzWGHXU7LsqGEmS5ToStoyx9zhJyWoJ9AdO4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=or6p85ZFbq9MCmpsAI4BNWvFZkM1bkvThZhRcNOXLEvOMlkKa5oSzGGhiyiiv3ZYL
	 tNihs3ZVlh4K1mEfiZ27uoBkH7Fab9qcyWFHZ5K/L42WJnE/W42KbEJW2ykKUhW/xW
	 vDlOioFWkWrLMUC4u/EEMEumujuBmm/f9Yxcca7dZCm97eyK4IeNWswNKLmxE7Lwm8
	 N43JFQpdFei0FqpJFtKIw9LA71pTWNIlMjIAJ9jkmAY7Jonwn/hQxTbYkNe3hGcEDx
	 jhkVvEzH6fhU52Z+EvcYjtm+zyWsAzQrozqDRvJOHR+WH842CraO8S11sjnNe4AGhq
	 y6+FxxzZ5qh7g==
Date: Wed, 2 Apr 2025 10:30:25 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH 2/2] crypto: arm/aes-neonbs - stop using the SIMD helper
Message-ID: <20250402173025.GE1235@sol.localdomain>
References: <20250402070251.1762692-3-ardb+git@google.com>
 <20250402070251.1762692-4-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250402070251.1762692-4-ardb+git@google.com>

On Wed, Apr 02, 2025 at 09:02:53AM +0200, Ard Biesheuvel wrote:
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
>  arch/arm/crypto/Kconfig           |   1 -
>  arch/arm/crypto/aes-neonbs-glue.c | 114 +++---------------------------
>  2 files changed, 9 insertions(+), 106 deletions(-)
> 
> diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
> index 2fa8aba8dc12..ba1d1b67c727 100644
> --- a/arch/arm/crypto/Kconfig
> +++ b/arch/arm/crypto/Kconfig
> @@ -169,7 +169,6 @@ config CRYPTO_AES_ARM_BS
>  	select CRYPTO_AES_ARM
>  	select CRYPTO_SKCIPHER
>  	select CRYPTO_LIB_AES
> -	select CRYPTO_SIMD
>  	help
>  	  Length-preserving ciphers: AES cipher algorithms (FIPS-197)
>  	  with block cipher modes:
> diff --git a/arch/arm/crypto/aes-neonbs-glue.c b/arch/arm/crypto/aes-neonbs-glue.c
> index f6be80b5938b..63800257a7ea 100644
> --- a/arch/arm/crypto/aes-neonbs-glue.c
> +++ b/arch/arm/crypto/aes-neonbs-glue.c

The following includes can now be removed from this file:

    #include <crypto/ctr.h>
    #include <crypto/internal/simd.h>

Otherwise this patch looks good.  Thanks!

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

- Eric
