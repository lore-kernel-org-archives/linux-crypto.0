Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA70226D04;
	Fri, 19 Sep 2025 19:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758310346; cv=none; b=KBvxSe9Cq52mI3z4U8Nsq9AtZoPt71YI9LgHM6oJL5WQKcDsCezwDwA9ncIYG26iB/6hX9QB/AAWGvYkMcifN6PaiAeksT9CWyZc4uRWiQc5K+QM8PzsD0N2cPBoFUtNcNpcpXvZJDjXhqnSa90vxcTOSRbtEwq7MRCR7NTbu6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758310346; c=relaxed/simple;
	bh=Q4PEuEuP9alXqKgQvbxJXKjAtS2HMA+4AJTY/GWd7HI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F6MOSTd4Z6uTgkUAKSKJDG3THMOAtsV4APrdig2Ged8+CpvvHc5pVhCPZrTEROKq3WVIVhhVq3+9qSdkPc9sV6d5cXroAkMFYiTVzNvMZBbozIoce5h0GzhU3Fohe8Kvi5VcVQU3JkJDOtu91w35VJes85H3A3Qe/LqFyHpXl8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pgi9APbb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pgi9APbb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07598C4CEF0;
	Fri, 19 Sep 2025 19:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758310345;
	bh=Q4PEuEuP9alXqKgQvbxJXKjAtS2HMA+4AJTY/GWd7HI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pgi9APbbq/5rG7Ho2J+TZJGVkq0W10UPMkV2zbAclCur7Yzs+JdYB0hM6X2u2i3HP
	 IqxlioxzxNjshOFUgcQ6MMPJCvAm1L/aS8fva/rK3xgGEyv1evQY+lKGOv9iLfTJW+
	 PmodCLjEoKLgErL9k0J4bO/3yv1SSWkFe38PBY8G6v/Ti+XS6AvZMOGkuOveTF/61c
	 +ruGnQQS7vbuByVzAbe15qbNWNWgdpCd52SJWvCOW3mzTSbY8QTRmHjefxzkbfgJgQ
	 Lv2QGTOJ7yKk3E2GWAVY4O9sPkWiY8EzWq8ZEl0ONR5VpUjaXk5bhB2EMCTF9O+Vkp
	 8+PAuWAXcY94g==
Date: Fri, 19 Sep 2025 14:32:21 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
	Ard Biesheuvel <ardb@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Kees Cook <keescook@chromium.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 0/5] arm64: Move kernel mode FPSIMD buffer to the stack
Message-ID: <20250919193221.GB2249@quark>
References: <20250918063539.2640512-7-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250918063539.2640512-7-ardb+git@google.com>

On Thu, Sep 18, 2025 at 08:35:40AM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> Move the buffer for preserving/restoring the kernel mode FPSIMD state on a
> context switch out of struct thread_struct, and onto the stack, so that
> the memory cost is not imposed needlessly on all tasks in the system.
> 
> Patches #1 - #3 contains some prepwork so that patch #4 can tighten the
> rules around permitted usage patterns of kernel_neon_begin() and
> kernel_neon_end(). This permits #5 to provide a stack buffer to
> kernel_neon_begin() transparently, in a manner that ensures that it will
> remain available until after the associated call to kernel_neon_end()
> returns.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Will Deacon <will@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Mark Brown <broonie@kernel.org>
> 
> Ard Biesheuvel (5):
>   crypto/arm64: aes-ce-ccm - Avoid pointless yield of the NEON unit
>   crypto/arm64: sm4-ce-ccm - Avoid pointless yield of the NEON unit
>   crypto/arm64: sm4-ce-gcm - Avoid pointless yield of the NEON unit
>   arm64/fpsimd: Require kernel NEON begin/end calls from the same scope
>   arm64/fpsimd: Allocate kernel mode FP/SIMD buffers on the stack
> 
>  arch/arm64/crypto/aes-ce-ccm-glue.c |  5 +--
>  arch/arm64/crypto/sm4-ce-ccm-glue.c | 10 ++----
>  arch/arm64/crypto/sm4-ce-gcm-glue.c | 10 ++----
>  arch/arm64/include/asm/neon.h       |  7 ++--
>  arch/arm64/include/asm/processor.h  |  2 +-
>  arch/arm64/kernel/fpsimd.c          | 34 +++++++++++++-------
>  6 files changed, 34 insertions(+), 34 deletions(-)

This looks like the right decision: saving 528 bytes per task is
significant.  528 bytes is a lot to allocate on the stack too, but
functions that use the NEON registers are either leaf functions or very
close to being leaf functions, so it should be okay.

The implementation is a bit unusual, though:

   #define kernel_neon_begin()	do { __kernel_neon_begin(&(struct user_fpsimd_state){})
   #define kernel_neon_end()	__kernel_neon_end(); } while (0)

It works, but normally macros don't start or end code blocks behind the
scenes like this.  Perhaps it should be more like s390's
kernel_fpu_begin(), where the caller provides the buffer that the
registers are stored in?  

- Eric
