Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39B2FC433E9
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Jan 2021 20:25:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0259E64DF5
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Jan 2021 20:25:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbhA1UYv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Jan 2021 15:24:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:51364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229595AbhA1UYr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Jan 2021 15:24:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 333686146D;
        Thu, 28 Jan 2021 20:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611865446;
        bh=knHhXvGOR2ZuKbHZDopGK46P68bkpl5iIyUlr+F/47A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l4CK/BNsG/cx+KMPTxQoUQJuPEz305yABjrh3nTCjlsdzqYs1oUHA9R8IYbSISbaG
         UY5CBOoPXKqLQAqr7junf+S8HVRlWYcsRZwnZXVoBfXJIRXYVtvyokZvNAAJQKyEoT
         2CHrlTrMuUKqaNLsT4ysukA/+Rcpk3c3O1YEC0nrUK9VpwUeQbyOnwXrWz0etpb/YX
         sAP7SCbNbzhPUNwlKQCVBdIXQZvEScpzreZo0QVP6+0laQw19f2QkS4H7uQ+FY1cxL
         SJjb8UQKgjBTYEqBpT7+4TQVrBFgVOyOdmY17XLMBG4K7XKVqRKGJFkkW4M/RQbufx
         9GNZvERkLoS0Q==
Date:   Thu, 28 Jan 2021 20:24:02 +0000
From:   Will Deacon <will@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
        mark.rutland@arm.com, Dave Martin <dave.martin@arm.com>,
        Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH 1/9] arm64: assembler: add cond_yield macro
Message-ID: <20210128202401.GD3016@willie-the-truck>
References: <20210128130625.54076-1-ardb@kernel.org>
 <20210128130625.54076-2-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128130625.54076-2-ardb@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 28, 2021 at 02:06:17PM +0100, Ard Biesheuvel wrote:
> Add a macro cond_yield that branches to a specified label when called if
> the TIF_NEED_RESCHED flag is set and decreasing the preempt count would
> make the task preemptible again, resulting in a schedule to occur. This
> can be used by kernel mode SIMD code that keeps a lot of state in SIMD
> registers, which would make chunking the input in order to perform the
> cond_resched() check from C code disproportionately costly.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/include/asm/assembler.h | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
> index bf125c591116..5f977a7c6b43 100644
> --- a/arch/arm64/include/asm/assembler.h
> +++ b/arch/arm64/include/asm/assembler.h
> @@ -745,6 +745,22 @@ USER(\label, ic	ivau, \tmp2)			// invalidate I line PoU
>  .Lyield_out_\@ :
>  	.endm
>  
> +	/*
> +	 * Check whether preempt-disabled code should yield as soon as it
> +	 * is able. This is the case if re-enabling preemption a single
> +	 * time results in a preempt count of zero, and the TIF_NEED_RESCHED
> +	 * flag is set. (Note that the latter is stored negated in the
> +	 * top word of the thread_info::preempt_count field)
> +	 */
> +	.macro		cond_yield, lbl:req, tmp:req
> +#ifdef CONFIG_PREEMPTION
> +	get_current_task \tmp
> +	ldr		\tmp, [\tmp, #TSK_TI_PREEMPT]
> +	cmp		\tmp, #PREEMPT_DISABLE_OFFSET
> +	beq		\lbl

Fancy that, I didn't know the '.' was optional in "b.eq"!

Anyway, a very similar code sequence exists inside if_will_cond_yield_neon,
only it doesn't touch the flags. Can we use that sequence instead, and then
use the new macro from there?

Will
