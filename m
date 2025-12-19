Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD34F37C113;
	Fri, 19 Dec 2025 18:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766168297; cv=none; b=Xydn/6fhl09+DaBnKaL9f/7yGNJz12pINGeMxFDX9C/P6SIouHxo0aZblyBZwEnvbAjZ4zJEeTzWyFCYJvLpnQz0m8A8u+81gfjNIXmtD+4fjAoqQ/GAAy/oAvrWbcHXy2kzJyAJcCY7EhmuncHmHZayyjGlumnfaqQXdPWk7hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766168297; c=relaxed/simple;
	bh=meScMscCSMX2peLd7xtdCHxTspTZWBU38GYN+Gy8u18=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W71T2BLZev3LyjgbzrirvL41lFkaYUW47YY4bFev2mxDHSSMsiWShT3T6cO6HmDQBQqe18PF3JtW0oza8CdW6A892hysFHlKW09HqxG393I6ow+b18R/DhI94T1bsaouOpkGJJlBEfLjs5hrCgJA6GUXb7l9G1OcegyMMQuB+m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I6y9JQrc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I6y9JQrc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C03C4CEF1;
	Fri, 19 Dec 2025 18:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766168295;
	bh=meScMscCSMX2peLd7xtdCHxTspTZWBU38GYN+Gy8u18=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I6y9JQrcuX+lOwAmBOOGoxIXL68Aeqc1lPmbN/zBszA/QdyC2pjy2UW5rVFRtk5wT
	 HHMqzT6+a5jZFYDXGWUvyj8AERj+VcbJYaNyqm+sp1/F0t6vfUiu6B0WXuVX3haO5B
	 e9oYGK6qOKHjngskDF9bQnz1EUPigdZn/JKNlgunHj78BLcymQS3qbYDLi1aMoJXxD
	 GgFIb+xYga3Unf3SC4ICstB1Nla2uc+g27M81bI5mboHumwY5B890qgYnm+LXg74u/
	 9r47n9z29ElEoUfff0njuCIER0dAdsMxojcUStq/F3utdEZcAcug3GFgadLYLuBkpl
	 CRV96lCWrglEA==
Date: Fri, 19 Dec 2025 10:18:05 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: AlanSong-oc <AlanSong-oc@zhaoxin.com>
Cc: herbert@gondor.apana.org.au, Jason@zx2c4.com, ardb@kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	CobeChen@zhaoxin.com, TonyWWang-oc@zhaoxin.com, YunShen@zhaoxin.com,
	GeorgeXue@zhaoxin.com, LeoLiu-oc@zhaoxin.com, HansHu@zhaoxin.com,
	x86@kernel.org
Subject: Re: [PATCH v2 1/2] lib/crypto: x86/sha1: PHE Extensions optimized
 SHA1 transform function
Message-ID: <20251219181805.GA1797@sol>
References: <cover.1766131281.git.AlanSong-oc@zhaoxin.com>
 <aa8ed72a109480887bdb3f3b36af372eadf0e499.1766131281.git.AlanSong-oc@zhaoxin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa8ed72a109480887bdb3f3b36af372eadf0e499.1766131281.git.AlanSong-oc@zhaoxin.com>

[+Cc x86@kernel.org]

On Fri, Dec 19, 2025 at 04:03:05PM +0800, AlanSong-oc wrote:
> diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
> index d2845b214..069069377 100644
> --- a/lib/crypto/Makefile
> +++ b/lib/crypto/Makefile
> @@ -205,7 +205,8 @@ endif
>  libsha1-$(CONFIG_SPARC) += sparc/sha1_asm.o
>  libsha1-$(CONFIG_X86) += x86/sha1-ssse3-and-avx.o \
>  			 x86/sha1-avx2-asm.o \
> -			 x86/sha1-ni-asm.o
> +			 x86/sha1-ni-asm.o \
> +			 x86/sha1-phe-asm.o
>  endif # CONFIG_CRYPTO_LIB_SHA1_ARCH
>  
>  ################################################################################
> diff --git a/lib/crypto/x86/sha1-phe-asm.S b/lib/crypto/x86/sha1-phe-asm.S
> new file mode 100644
> index 000000000..eff086104
> --- /dev/null
> +++ b/lib/crypto/x86/sha1-phe-asm.S
> @@ -0,0 +1,71 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * PHE Extensions optimized implementation of a SHA-1 update function
> + *
> + * This file is provided under a dual BSD/GPLv2 license.  When using or
> + * redistributing this file, you may do so under either license.
> + *
> + * GPL LICENSE SUMMARY
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of version 2 of the GNU General Public License as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * BSD LICENSE
> + *
> + * Redistribution and use in source and binary forms, with or without
> + * modification, are permitted provided that the following conditions
> + * are met:
> + *
> + * 	* Redistributions of source code must retain the above copyright
> + * 	  notice, this list of conditions and the following disclaimer.
> + * 	* Redistributions in binary form must reproduce the above copyright
> + * 	  notice, this list of conditions and the following disclaimer in
> + * 	  the documentation and/or other materials provided with the
> + * 	  distribution.
> + * 	* Neither the name of Intel Corporation nor the names of its
> + * 	  contributors may be used to endorse or promote products derived
> + * 	  from this software without specific prior written permission.
> + *
> + * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
> + * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
> + * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
> + * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
> + * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
> + * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
> + * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
> + * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
> + * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
> + * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
> + * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
> + *
> + */
> +
> +#include <linux/linkage.h>
> +
> +/*
> + * PHE Extensions optimized implementation of a SHA-1 block function
> + *
> + * This function takes a pointer to the current SHA-1 state, a pointer to the
> + * input data, and the number of 64-byte blocks to process.  The number of
> + * blocks to process is assumed to be nonzero.  Once all blocks have been
> + * processed, the state is updated with the new state.  This function only
> + * processes complete blocks.  State initialization, buffering of partial
> + * blocks, and digest finalization are expected to be handled elsewhere.
> + *
> + * void sha1_transform_phe(u8 *state, const u8 *data, size_t nblocks)
> + */
> +.text
> +SYM_FUNC_START(sha1_transform_phe)
> +	mov		$-1, %rax
> +	mov		%rdx, %rcx
> +
> +	.byte	0xf3,0x0f,0xa6,0xc8
> +
> +	RET
> +SYM_FUNC_END(sha1_transform_phe)

Please make this an inline asm statement instead of using a .S file.
It's just one instruction.

> +#define PHE_ALIGNMENT 16
> +asmlinkage void sha1_transform_phe(u8 *state, const u8 *data, size_t nblocks);
> +static void sha1_blocks_phe(struct sha1_block_state *state,
> +			     const u8 *data, size_t nblocks)
> +{
> +	/*
> +	 * XSHA1 requires %edi to point to a 32-byte, 16-byte-aligned
> +	 * buffer on Zhaoxin processors.
> +	 */

What is the largest 'nblocks' that the instruction supports?

What happens if the instruction is interrupted partway through?  Does
the CPU correctly resume it in all cases?

Is it supported in both 32-bit and 64-bit modes?  Your patch doesn't
check for CONFIG_64BIT.  Should it?  New optimized assembly code
generally should be 64-bit only.

Where is this instruction specified?  Please add a comment that links to
the specification.

> +	u8 buf[32 + PHE_ALIGNMENT - 1];
> +	u8 *dst = PTR_ALIGN(&buf[0], PHE_ALIGNMENT);
> +
> +	memcpy(dst, (u8 *)(state), SHA1_DIGEST_SIZE);
> +	sha1_transform_phe(dst, data, nblocks);
> +	memcpy((u8 *)(state), dst, SHA1_DIGEST_SIZE);
> +}

The casts to 'u8 *' are unnecessary.

> +
>  static void sha1_blocks(struct sha1_block_state *state,
>  			const u8 *data, size_t nblocks)
>  {
> @@ -59,6 +76,9 @@ static void sha1_mod_init_arch(void)
>  {
>  	if (boot_cpu_has(X86_FEATURE_SHA_NI)) {
>  		static_call_update(sha1_blocks_x86, sha1_blocks_ni);
> +	} else if (boot_cpu_has(X86_FEATURE_PHE) && boot_cpu_has(X86_FEATURE_PHE_EN)) {
> +		if (cpu_data(0).x86 >= 0x07)
> +			static_call_update(sha1_blocks_x86, sha1_blocks_phe);

Check IS_ENABLED(CONFIG_CPU_SUP_ZHAOXIN) first, so that the code gets
compiled out when support for Zhaoxin CPUs isn't included in the kernel.

There are hardly any mentions of 'cpu_data(0).x86' in the kernel.  I
think you mean 'boot_cpu_data.x86', which is used much more frequently.

What is the difference between X86_FEATURE_PHE and X86_FEATURE_PHE_EN,
and why are both needed?

All these comments apply to the SHA-256 patch too.

- Eric
