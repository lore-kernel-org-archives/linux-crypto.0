Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2715B8F58
	for <linux-crypto@vger.kernel.org>; Wed, 30 Oct 2024 04:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730262798; cv=none; b=VjPBBnQ9LrJnrQ7YJUiGWFz+WulC0njHfJXCLrSaUL4PzbbMn0tdJD4REfTAtD391WKm7w7Xj7eWWNWnp8uogDo+5W7kfvVBxAtHN24j6rQrIscbMVqLfxdkFckvDIjQQ6S+LJ0urr0YHO+uEg/xyOVQzBX0DHcMHlW4hMpLR1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730262798; c=relaxed/simple;
	bh=t4mVJkp9rXHoy60NmVGpzaELgy6bwcIcAK3aI7X/TsE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GTpASsaDwWvplaVWSXGYoC0ktfyYx6XnH8Fa6MXMpuDRWdUEDwv1zyL4FcaPsBcklN8bUmZRJaFHobBHnF06/Rr9PrORD/RuhHmmGph/KmRSpYJ97KX7wgtIH/Ft+LBPRnpNhKuP5+HRrvLIxdlrnS0c+OZJR28YaUvpOO82Vkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Okp7QzXI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Okp7QzXI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87730C4CEE4;
	Wed, 30 Oct 2024 04:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730262797;
	bh=t4mVJkp9rXHoy60NmVGpzaELgy6bwcIcAK3aI7X/TsE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Okp7QzXIpIroAShlV5GUsK5+YhgeR88PjhCdDHvCQUljYBg13QhrMqfl31EUk+zKQ
	 /TJkV18mhxdNopKDNBTIql8d0zyJfVIsqs6hIGRxWWgp8L8aBCML7pkqkbGe5CAhji
	 kbHrRPpr1Pa0BHSoG3cDFBUsWVg44R6SW7+r2jpPxvgD9KGmfnObrdUHm3UmGItB0o
	 u5XT74wCZNYpaf8f4cAA3J2+XoY7hNA6leWcdcjcdt0nptQ/5OVrEJ7SdA9s8aV/71
	 nBP4OcqEkncf9IiVspxeNC1zjO7VXD2O0uSsAOu2JUFCK7cCGl16dkm7bn+r2KFRme
	 geqttPntgwCFQ==
Date: Tue, 29 Oct 2024 21:33:16 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	herbert@gondor.apana.org.au, keescook@chromium.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH 6/6] crypto: arm/crct10dif - Implement plain NEON variant
Message-ID: <20241030043316.GF1489@sol.localdomain>
References: <20241028190207.1394367-8-ardb+git@google.com>
 <20241028190207.1394367-14-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241028190207.1394367-14-ardb+git@google.com>

On Mon, Oct 28, 2024 at 08:02:14PM +0100, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> The CRC-T10DIF algorithm produces a 16-bit CRC, and this is reflected in
> the folding coefficients, which are also only 16 bits wide.
> 
> This means that the polynomial multiplications involving these
> coefficients can be performed using 8-bit long polynomial multiplication
> (8x8 -> 16) in only a few steps, and this is an instruction that is part
> of the base NEON ISA, which is all most real ARMv7 cores implement. (The
> 64-bit PMULL instruction is part of the crypto extensions, which are
> only implemented by 64-bit cores)
> 
> The final reduction is a bit more involved, but we can delegate that to
> the generic CRC-T10DIF implementation after folding the entire input
> into a 16 byte vector.
> 
> This results in a speedup of around 6.6x on Cortex-A72 running in 32-bit
> mode.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm/crypto/crct10dif-ce-core.S | 50 ++++++++++++++++++--
>  arch/arm/crypto/crct10dif-ce-glue.c | 44 +++++++++++++++--
>  2 files changed, 85 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm/crypto/crct10dif-ce-core.S b/arch/arm/crypto/crct10dif-ce-core.S
> index 6b72167574b2..5e103a9a42dd 100644
> --- a/arch/arm/crypto/crct10dif-ce-core.S
> +++ b/arch/arm/crypto/crct10dif-ce-core.S
> @@ -112,6 +112,34 @@
>  	FOLD_CONST_L	.req	q10l
>  	FOLD_CONST_H	.req	q10h
>  
> +__pmull16x64_p8:
> +	vmull.p8	q13, d23, d24
> +	vmull.p8	q14, d23, d25
> +	vmull.p8	q15, d22, d24
> +	vmull.p8	q12, d22, d25
> +
> +	veor		q14, q14, q15
> +	veor		d24, d24, d25
> +	veor		d26, d26, d27
> +	veor		d28, d28, d29
> +	vmov.i32	d25, #0
> +	vmov.i32	d29, #0
> +	vext.8		q12, q12, q12, #14
> +	vext.8		q14, q14, q14, #15
> +	veor		d24, d24, d26
> +	bx		lr
> +ENDPROC(__pmull16x64_p8)

As in the arm64 version, a few comments here would help.

> diff --git a/arch/arm/crypto/crct10dif-ce-glue.c b/arch/arm/crypto/crct10dif-ce-glue.c
> index 60aa79c2fcdb..4431e4ce2dbe 100644
> --- a/arch/arm/crypto/crct10dif-ce-glue.c
> +++ b/arch/arm/crypto/crct10dif-ce-glue.c
> @@ -20,6 +20,7 @@
>  #define CRC_T10DIF_PMULL_CHUNK_SIZE	16U
>  
>  asmlinkage u16 crc_t10dif_pmull64(u16 init_crc, const u8 *buf, size_t len);
> +asmlinkage void crc_t10dif_pmull8(u16 init_crc, const u8 *buf, size_t len, u8 *out);

Maybe explicitly type 'out' to 'u8 out[16]'?

- Eric
