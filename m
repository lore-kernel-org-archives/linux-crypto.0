From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH resend 00/15] arm64 crypto roundup
Date: Wed, 7 May 2014 15:45:54 +0100
Message-ID: <20140507144554.GC17253@arm.com>
References: <1398959381-8126-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Will Deacon <Will.Deacon@arm.com>,
	"steve.capper@linaro.org" <steve.capper@linaro.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:46661 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753784AbaEGOqb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2014 10:46:31 -0400
Content-Disposition: inline
In-Reply-To: <1398959381-8126-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 01, 2014 at 04:49:32PM +0100, Ard Biesheuvel wrote:
> This is a repost of the arm64 crypto patches that I have posted to the LAKML
> over the past months. They have now been verified on actual hardware
> (Cortex-A57) so if there are no remaining issues I would like to propose them
> for 3.16.
> 
> Ard Biesheuvel (15):
>   asm-generic: allow generic unaligned access if the arch supports it
>   arm64: add abstractions for FPSIMD state manipulation
>   arm64: defer reloading a task's FPSIMD state to userland resume
>   arm64: add support for kernel mode NEON in interrupt context
>   arm64/crypto: SHA-1 using ARMv8 Crypto Extensions
>   arm64/crypto: SHA-224/SHA-256 using ARMv8 Crypto Extensions
>   arm64/crypto: GHASH secure hash using ARMv8 Crypto Extensions
>   arm64/crypto: AES using ARMv8 Crypto Extensions
>   arm64/crypto: AES in CCM mode using ARMv8 Crypto Extensions
>   arm64: pull in <asm/simd.h> from asm-generic
>   arm64/crypto: AES-ECB/CBC/CTR/XTS using ARMv8 NEON and Crypto
>     Extensions
>   arm64/crypto: add shared macro to test for NEED_RESCHED
>   arm64/crypto: add voluntary preemption to Crypto Extensions SHA1
>   arm64/crypto: add voluntary preemption to Crypto Extensions SHA2
>   arm64/crypto: add voluntary preemption to Crypto Extensions GHASH

There are about 5 patches that make sense to me ;) and apart from a few
minor comments they look fine.

There are the other 10 crypto patches that are beyond my knowledge. Do
you know anyone who could do a sanity check on them? Are there any tests
that would show the correctness of the implementation?

Thanks.

-- 
Catalin
