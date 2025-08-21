Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8541FF7C5;
	Thu, 21 Aug 2025 03:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755748308; cv=none; b=SFNm8Clgvww6mQbPnPBDG0865OYwe4JiCg40j8makb3flTAFck8qDP0nS7+3klPFtzsjVWTifrRrqgxwp9FE+8829tLSAi9XjFP4FJQSH+htoPvRuWBBUwuKmlgx85+V8N2xuIZfeqymEOyoo7T1J3PuuC/TxRfZkQr2svGE5H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755748308; c=relaxed/simple;
	bh=K0X3/jhwWrEaPtinS/n7sXwu1FaDWpd7B2nFS/DST3s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kiegpn/HrEYBW7GK39Wrva9l2PirKtH6XLwsVyWXU1olc4gBn/K5ltIsr0MqeTeI+hpSpFzXEztQbTG1pJCORXREYyH1EBDmLYSi43XuVQDH0jax0zTku2BzkjmocfktR6TAML9f79Z77M+2a0CEhWO6bF/oq6pDn9D4CRAc2CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o/ttZ/zZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o/ttZ/zZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA38C4CEF4;
	Thu, 21 Aug 2025 03:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755748308;
	bh=K0X3/jhwWrEaPtinS/n7sXwu1FaDWpd7B2nFS/DST3s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o/ttZ/zZHEfBAzoBnURpkOD/czJxLF9XR+cduTGP0bntSBdPnJq0dN2ftU0ysnGA4
	 2fTszwKjQ/BpGTXg8Y1TpSN9HSc8bBIZ+2nx5OHp3PU10asiSl6CIx0O0Yhmg9lUYa
	 /8e+44+1vMW1eNUoSTb/UQQge0pXtf0zStO9S8dx+geEoIyrtAcE+KrIllWBKAwYQj
	 PutnohssLSU8HnSglxxEzBQlDWEgJu9HKEFLbDeajzro3tvkXH0SbwvllUurN0amIk
	 y82ausXRHmq5EmI3g35CQlHAC2cBcKLX4hGeaEp2nkJzq8Eo2bdx6NNL1qfw2nveCU
	 d6guqk5GiI8HA==
Date: Wed, 20 Aug 2025 23:51:45 -0400
From: Eric Biggers <ebiggers@kernel.org>
To: Uros Bizjak <ubizjak@gmail.com>
Cc: linux-crypto@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/4] crypto:x86 - Remove CONFIG_AS_GFNI
Message-ID: <20250821035145.GF185832@quark>
References: <20250819085855.333380-1-ubizjak@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819085855.333380-1-ubizjak@gmail.com>

On Tue, Aug 19, 2025 at 10:57:49AM +0200, Uros Bizjak wrote:
> Current minimum required version of binutils is 2.30,
> which supports GFNI instruction mnemonics.
> 
> Remove check for assembler support of GFNI instructions
> and all relevant macros for conditional compilation.
> 
> No functional change intended.
> 
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> ---
>  arch/x86/Kconfig.assembler               |  5 -----
>  arch/x86/crypto/Kconfig                  |  2 +-
>  arch/x86/crypto/aria-aesni-avx-asm_64.S  | 10 ----------
>  arch/x86/crypto/aria-aesni-avx2-asm_64.S | 10 +---------
>  arch/x86/crypto/aria_aesni_avx2_glue.c   |  4 +---
>  arch/x86/crypto/aria_aesni_avx_glue.c    |  4 +---
>  6 files changed, 4 insertions(+), 31 deletions(-)

For the whole series:

    Reviewed-by: Eric Biggers <ebiggers@kernel.org>

Please include a cover letter next time.

- Eric
