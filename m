Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB7C1A285;
	Sun, 18 Jan 2026 00:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768696288; cv=none; b=Ob0Z6gnjIBbrUzU3OSuz+2UbVkDKPo8C+Wmmok8uJzReE2qwXCAXPpMV1byyKXJlMtiONWEKFbxWcoQuUWe7Tfx8RqnbPCuZzKJZkv/aRmxgHFhe9YOBh299p6AptjF5rl6b0tlFrEHVgDeQ3812y/8b2kHMGb3tYUc2RS5zMXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768696288; c=relaxed/simple;
	bh=YxEgrjSexDELN5XG/WgM7/N56hoDnF9xLAH3mnMSNxE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K3XpQ6q2wO8V+bpVhoxyzOG7Diy82Wm81aNMh5doVpSnQKwtFZ2XqulUi1vL+PgsZiRFqGw+C79ZRiOrVeNLrh6BCbt2NfPp6rUWKJn3weEYti4tfz90v0cTLAysPFV9eGMG7/f1wbiBWa0+8voECBQ9XkvmJxJnIjYTNwoETOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=menkZDN8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="menkZDN8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F66CC4CEF7;
	Sun, 18 Jan 2026 00:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768696288;
	bh=YxEgrjSexDELN5XG/WgM7/N56hoDnF9xLAH3mnMSNxE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=menkZDN85DerEKGx36xPUHXaNXKvFWj+ccOtI2YmPCDBEo/m8J7pHAWFEj88/EquC
	 zavXcuDOMUOgVnBoxk2SWVFVsXpTWwRP3xxyJM5BMKn+Z87ZVElMSY5hKyazSkae7L
	 U7bHeK7ZcY+Ryazsp+kWaixD0dMurQu0KQWrQdP+1Qbhg5ohrMeNIiSxAIwVkodGvp
	 Nr7O6FwmNNKOBHCD4bfD6D3NA1CZw++PHd+whDpWWbs577E3hZF2qO173nI3/iQp8E
	 uXACTakYNmEnvK3PVfgTfuXC6eXCoFw7jOaVB0o0T7WZevLLQtY+6s9EN/p2nCOvYw
	 dtOiFWI708uqw==
Date: Sat, 17 Jan 2026 16:31:20 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: AlanSong-oc <AlanSong-oc@zhaoxin.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, Jason@zx2c4.com,
	ardb@kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org, CobeChen@zhaoxin.com,
	TonyWWang-oc@zhaoxin.com, YunShen@zhaoxin.com,
	GeorgeXue@zhaoxin.com, LeoLiu-oc@zhaoxin.com, HansHu@zhaoxin.com
Subject: Re: [PATCH v3 2/3] lib/crypto: x86/sha1: PHE Extensions optimized
 SHA1 transform function
Message-ID: <20260118003120.GF74518@quark>
References: <20260116071513.12134-1-AlanSong-oc@zhaoxin.com>
 <20260116071513.12134-3-AlanSong-oc@zhaoxin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116071513.12134-3-AlanSong-oc@zhaoxin.com>

On Fri, Jan 16, 2026 at 03:15:12PM +0800, AlanSong-oc wrote:
> Zhaoxin CPUs have implemented the SHA(Secure Hash Algorithm) as its CPU
> instructions by PHE(Padlock Hash Engine) Extensions, including XSHA1,
> XSHA256, XSHA384 and XSHA512 instructions.
> 
> With the help of implementation of SHA in hardware instead of software,
> can develop applications with higher performance, more security and more
> flexibility.
> 
> This patch includes the XSHA1 instruction optimized implementation of
> SHA-1 transform function.
> 
> Signed-off-by: AlanSong-oc <AlanSong-oc@zhaoxin.com>

Please include the information I've asked for (benchmark results, test
results, and link to the specification) directly in the commit message.

> +#if IS_ENABLED(CONFIG_CPU_SUP_ZHAOXIN)
> +#define PHE_ALIGNMENT 16
> +static void sha1_blocks_phe(struct sha1_block_state *state,
> +			     const u8 *data, size_t nblocks)

The IS_ENABLED(CONFIG_CPU_SUP_ZHAOXIN) should go in the CPU feature
check, so that the code will be parsed regardless of the setting.  That
reduces the chance that future changes will cause compilation errors.

> +	/*
> +	 * XSHA1 requires %edi to point to a 32-byte, 16-byte-aligned
> +	 * buffer on Zhaoxin processors.
> +	 */

This seems implausible.  In 64-bit mode a pointer can't fit in %edi.  I
thought you mentioned that this instruction is 64-bit compatible?  You
may have meant %rdi.

Interestingly, the spec you provided specifically says the registers
operated on are %eax, %ecx, %esi, and %edi.

So assuming the code works, perhaps both the spec and your code comment
are incorrect?

These errors don't really confidence in this instruction.

> +	memcpy(dst, state, SHA1_DIGEST_SIZE);
> +	asm volatile(".byte 0xf3,0x0f,0xa6,0xc8"
> +		     : "+S"(data), "+D"(dst)
> +		     : "a"((long)-1), "c"(nblocks));
> +	memcpy(state, dst, SHA1_DIGEST_SIZE);

Is the reason for using '.byte' that the GNU and clang assemblers don't
implement the mnemonic this Zhaoxin-specific instruction?  The spec
implies that the intended mnemonic is "rep sha1".

If that's correct, could you add a comment like /* rep sha1 */ so that
it's clear what the intended instruction is?

Also, the spec describes all four registers as both input and output
registers.  Yet your inline asm marks %rax and %rcx as inputs only.

> @@ -59,6 +79,11 @@ static void sha1_mod_init_arch(void)
>  {
>  	if (boot_cpu_has(X86_FEATURE_SHA_NI)) {
>  		static_call_update(sha1_blocks_x86, sha1_blocks_ni);
> +#if IS_ENABLED(CONFIG_CPU_SUP_ZHAOXIN)
> +	} else if (boot_cpu_has(X86_FEATURE_PHE_EN)) {
> +		if (boot_cpu_data.x86 >= 0x07)
> +			static_call_update(sha1_blocks_x86, sha1_blocks_phe);
> +#endif

I think it should be:

	} else if (IS_ENABLED(CONFIG_CPU_SUP_ZHAOXIN) &&
		   boot_cpu_has(X86_FEATURE_PHE_EN) &&
		   boot_cpu_data.x86 >= 0x07) {
			static_call_update(sha1_blocks_x86, sha1_blocks_phe);

... so (a) the code will be parsed even when !CONFIG_CPU_SUP_ZHAOXIN,
and (b) functions won't be unnecessarily disabled when
boot_cpu_has(X86_FEATURE_PHE_EN) && boot_cpu_data.x86 < 0x07).

As before, all these comments apply to the SHA-256 patch too.

- Eric
