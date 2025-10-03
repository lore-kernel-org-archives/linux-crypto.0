Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59EC417A2E1;
	Fri,  3 Oct 2025 20:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759523332; cv=none; b=Kicf/sxfEouiJUEdxlKcpwhrrr9jR1G61p+sJD982JOMmuCMesBRDD93TbLJRnb6JLrxNvYo2ZNhOlr5TafSCThjpEzDw9ePuzX1+IvzlPY203N0CRhNJFYzu8nnyX7K1AQ41OZuHtYdXO032+/XZemqtkdurTIVgf5yUfRvGO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759523332; c=relaxed/simple;
	bh=7TtwZs3DmPv30Yl96eKnE5YiLSOUEgOMMAjocXogTbY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g8kmOPwTOvO5n7Ynq6b9GQiIhnjwMOrymlqQ5Kaa9i5O2vZj9oI0a2Xp4AC8/21kl7VLFxSKBkT5GascyZ5uKTNtLRNZn3pU7tP/YcFSzeJVH67l07498W86Q8+NthtvdTLNzed1SH87wp44z4wVv/Psy/wGdTAwUhVTZZyMs18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qYX27rqc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qYX27rqc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B7BDC4CEF5;
	Fri,  3 Oct 2025 20:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759523331;
	bh=7TtwZs3DmPv30Yl96eKnE5YiLSOUEgOMMAjocXogTbY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qYX27rqcewLkT6w2pLiIvL0EQzeFeY/384GYHpgexiBTUOZFYHb09BJpvY3jncXuv
	 96vD/f8crQ5hRQJRG7GDd9m5SVBEqMmecn0GWI8gU6Bu06Jr9Qj9Et7Q4DVBHupWLR
	 GFQzSKbc50bm7YwGqZdK7pTrzzOBy1ue78pCDcGpKHlOn9uK39AS40cMIlDnZv/V/O
	 miHZbq2WyJJACCOjQLaTD82hpqmDxcRrD4qzasI1o71o6Lli4ST6W8rH2IQ5sUEgWv
	 3+/2C10wgEJlU77l3M8s6iNuhfAcrqaoaORmTJSkqECviX5xe4LqjitXtbc94ZMoja
	 +eFvQwPW4sjMA==
Date: Fri, 3 Oct 2025 13:28:49 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
	linux@armlinux.org.uk, Ard Biesheuvel <ardb@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Kees Cook <keescook@chromium.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v2 00/20] arm64: Move kernel mode FPSIMD buffer to the
 stack
Message-ID: <20251003202849.GB24598@quark>
References: <20251001210201.838686-22-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251001210201.838686-22-ardb+git@google.com>

On Wed, Oct 01, 2025 at 11:02:02PM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> Move the buffer for preserving/restoring the kernel mode FPSIMD state on a
> context switch out of struct thread_struct, and onto the stack, so that
> the memory cost is not imposed needlessly on all tasks in the system.
> 
> Changes since v1:
> - Add a patch reverting the arm64 support for the generic
>   kernel_fpu_begin()/end() API, which is problematic on arm64.
> 
> - Introduce a new 'ksimd' scoped guard that encapsulates the calls the
>   kernel_neon_begin() and kernel_neon_end() at a higher level of
>   abstraction. This makes it straight-forward to plumb in the stack
>   buffer without complicating the callers.
> 
> - Move all kernel mode NEON users on arm64 (and some on ARM) over to the
>   new API.
> 
> - Add Mark's ack to patches #6 - #8
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Will Deacon <will@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Eric Biggers <ebiggers@kernel.org>
> 
> Ard Biesheuvel (20):
>   arm64: Revert support for generic kernel mode FPU
>   arm64/simd: Add scoped guard API for kernel mode SIMD
>   ARM/simd: Add scoped guard API for kernel mode SIMD
>   crypto: aegis128-neon - Move to more abstract 'ksimd' guard API
>   raid6: Move to more abstract 'ksimd' guard API
>   crypto/arm64: aes-ce-ccm - Avoid pointless yield of the NEON unit
>   crypto/arm64: sm4-ce-ccm - Avoid pointless yield of the NEON unit
>   crypto/arm64: sm4-ce-gcm - Avoid pointless yield of the NEON unit
>   lib/crc: Switch ARM and arm64 to 'ksimd' scoped guard API
>   lib/crypto: Switch ARM and arm64 to 'ksimd' scoped guard API
>   crypto/arm64: aes-ccm - Switch to 'ksimd' scoped guard API
>   crypto/arm64: aes-blk - Switch to 'ksimd' scoped guard API
>   crypto/arm64: aes-gcm - Switch to 'ksimd' scoped guard API
>   crypto/arm64: nhpoly1305 - Switch to 'ksimd' scoped guard API
>   crypto/arm64: polyval - Switch to 'ksimd' scoped guard API
>   crypto/arm64: sha3 - Switch to 'ksimd' scoped guard API
>   crypto/arm64: sm3 - Switch to 'ksimd' scoped guard API
>   crypto/arm64: sm4 - Switch to 'ksimd' scoped guard API
>   arm64/xorblocks:  Switch to 'ksimd' scoped guard API
>   arm64/fpsimd: Allocate kernel mode FP/SIMD buffers on the stack

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

- Eric
