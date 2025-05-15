Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25DC296731
	for <linux-crypto@vger.kernel.org>; Thu, 15 May 2025 18:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747335177; cv=none; b=jnXoJXZAMUf6dl7mXXR9Vkh1jSErjV7Oniu7AAdvbwA1b7fUQS2Ltf/PJTdUNPgK+8gARa2tHXHGJfOfAOJaYFIumqo3PwK1M6zkxs8T92hRZwuhzzeLPLcJdVjQXp4mGgsTNrIVaMQaIkMh8MfnUXt3LX0ZYxBEzJYutSlivXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747335177; c=relaxed/simple;
	bh=so+lA3jbVBr0hSrnna7hrpN+V6k/EkJwfbhhlyeCQ+0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=onKE9Fxl8ukEUZhbcAahUFWT5EFv6TPufuFRYbf6kuorUUXVakZjo9X2VdRioCISgB7AhLxmr88+x4faoTwPnuzbRWEeYJ01LsNYe69rySUo8y31ywzxpfqmer0oZ/cP2QNZaT3cRgvCw9MwLlp43P5lQ8tl4xXapms83GV8sX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=doZ9NKme; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="doZ9NKme"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06CB4C4CEE7;
	Thu, 15 May 2025 18:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747335176;
	bh=so+lA3jbVBr0hSrnna7hrpN+V6k/EkJwfbhhlyeCQ+0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=doZ9NKmePjbsn5RObCBZHFVFasGfyL+bPSS61MbeLfjNCAjZVlhj/bQ9mSuSiFetG
	 GDHpAGe1vxaKcW7+FCKY84uHo6VsiwpHVXldI3Tm3sMnnVAf1gzQy5E/fVAvp1dgOP
	 pdgUmnccTllEQt8xBh9bD/Md7r+nJvnwmJB1tJFLbDjJhdcOJxoMMKdZhEgCafzKPh
	 ibiu9UokKL5mNx+mVnfnMgBl8Lg5dtbum9Al2cEhmlje+NjRrzCJIs2/ioYUhH4/ZA
	 4gYwKRmBM2+0KYgZw9iyb1FKdig4cbaXz61l8n+Pc24o65o3bKPL2dRIGQNHGeY6t3
	 MIWmU1Z91j5NA==
Date: Thu, 15 May 2025 11:52:54 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH] crypto: arm64 - Drop asm fallback macros for older
 binutils
Message-ID: <20250515185254.GE1411@quark>
References: <20250515142702.2592942-2-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250515142702.2592942-2-ardb+git@google.com>

On Thu, May 15, 2025 at 04:27:03PM +0200, Ard Biesheuvel wrote:
> diff --git a/arch/arm64/crypto/sha512-ce-core.S b/arch/arm64/crypto/sha512-ce-core.S
> index 91ef68b15fcc..deb2469ab631 100644
> --- a/arch/arm64/crypto/sha512-ce-core.S
> +++ b/arch/arm64/crypto/sha512-ce-core.S
> @@ -12,26 +12,7 @@
>  #include <linux/linkage.h>
>  #include <asm/assembler.h>
>  
> -	.irp		b,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19
> -	.set		.Lq\b, \b
> -	.set		.Lv\b\().2d, \b
> -	.endr
> -
> -	.macro		sha512h, rd, rn, rm
> -	.inst		0xce608000 | .L\rd | (.L\rn << 5) | (.L\rm << 16)
> -	.endm
> -
> -	.macro		sha512h2, rd, rn, rm
> -	.inst		0xce608400 | .L\rd | (.L\rn << 5) | (.L\rm << 16)
> -	.endm
> -
> -	.macro		sha512su0, rd, rn
> -	.inst		0xcec08000 | .L\rd | (.L\rn << 5)
> -	.endm
> -
> -	.macro		sha512su1, rd, rn, rm
> -	.inst		0xce608800 | .L\rd | (.L\rn << 5) | (.L\rm << 16)
> -	.endm
> +	.arch	armv8-a+sha3

This looked like a mistake: SHA-512 is part of SHA-2, not SHA-3.  However, the
current versions of binutils and clang do indeed put it under sha3.  There
should be a comment that mentions this unfortunate quirk.

However, there's also the following commit which went into binutils 2.43:

    commit 0aac62aa3256719c37be9e0ce6af8b190f45c928
    Author: Andrew Carlotti <andrew.carlotti@arm.com>
    Date:   Fri Jan 19 13:01:40 2024 +0000

        aarch64: move SHA512 instructions to +sha3

        SHA512 instructions were added to the architecture at the same time as SHA3
        instructions, but later than the SHA1 and SHA256 instructions.  Furthermore,
        implementations must support either both or neither of the SHA512 and SHA3
        instruction sets.  However, SHA512 instructions were originally (and
        incorrectly) added to Binutils under the +sha2 flag.

        This patch moves SHA512 instructions under the +sha3 flag, which matches the
        architecture constraints and existing GCC and LLVM behaviour.

So probably we need ".arch armv8-a+sha2+sha3" to support binutils 2.30 through
2.42, as well as clang and the latest version of binutils?  (I didn't test it
yet, but it seems likely...)

- Eric
