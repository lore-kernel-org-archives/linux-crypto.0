Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E395C433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Jan 2021 16:02:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57FC8216FD
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Jan 2021 16:02:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728357AbhASQCK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Jan 2021 11:02:10 -0500
Received: from foss.arm.com ([217.140.110.172]:37606 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389504AbhASQCD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Jan 2021 11:02:03 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A33AAD6E;
        Tue, 19 Jan 2021 08:01:17 -0800 (PST)
Received: from arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F33483F66E;
        Tue, 19 Jan 2021 08:01:15 -0800 (PST)
Date:   Tue, 19 Jan 2021 16:00:56 +0000
From:   Dave Martin <Dave.Martin@arm.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Peter Zijlstra <peterz@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 4/5] arm64: fpsimd: run kernel mode NEON with
 softirqs disabled
Message-ID: <20210119160045.GA1684@arm.com>
References: <20201218170106.23280-1-ardb@kernel.org>
 <20201218170106.23280-5-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201218170106.23280-5-ardb@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Dec 18, 2020 at 06:01:05PM +0100, Ard Biesheuvel wrote:
> Kernel mode NEON can be used in task or softirq context, but only in
> a non-nesting manner, i.e., softirq context is only permitted if the
> interrupt was not taken at a point where the kernel was using the NEON
> in task context.
> 
> This means all users of kernel mode NEON have to be aware of this
> limitation, and either need to provide scalar fallbacks that may be much
> slower (up to 20x for AES instructions) and potentially less safe, or
> use an asynchronous interface that defers processing to a later time
> when the NEON is guaranteed to be available.
> 
> Given that grabbing and releasing the NEON is cheap, we can relax this
> restriction, by increasing the granularity of kernel mode NEON code, and
> always disabling softirq processing while the NEON is being used in task
> context.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Sorry for the slow reply on this...  it looks reasonable, but I have a
few comments below.

> ---
>  arch/arm64/include/asm/assembler.h | 19 +++++++++++++------
>  arch/arm64/kernel/asm-offsets.c    |  2 ++
>  arch/arm64/kernel/fpsimd.c         |  4 ++--
>  3 files changed, 17 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
> index ddbe6bf00e33..74ce46ed55ac 100644
> --- a/arch/arm64/include/asm/assembler.h
> +++ b/arch/arm64/include/asm/assembler.h
> @@ -15,6 +15,7 @@
>  #include <asm-generic/export.h>
>  
>  #include <asm/asm-offsets.h>
> +#include <asm/alternative.h>
>  #include <asm/cpufeature.h>
>  #include <asm/cputype.h>
>  #include <asm/debug-monitors.h>
> @@ -717,17 +718,23 @@ USER(\label, ic	ivau, \tmp2)			// invalidate I line PoU
>  	.endm
>  
>  	.macro		if_will_cond_yield_neon
> -#ifdef CONFIG_PREEMPTION
>  	get_current_task	x0
>  	ldr		x0, [x0, #TSK_TI_PREEMPT]
> -	sub		x0, x0, #PREEMPT_DISABLE_OFFSET
> -	cbz		x0, .Lyield_\@
> +#ifdef CONFIG_PREEMPTION
> +	cmp		x0, #PREEMPT_DISABLE_OFFSET
> +	beq		.Lyield_\@	// yield on need_resched in task context
> +#endif
> +	/* never yield while serving a softirq */
> +	tbnz		x0, #SOFTIRQ_SHIFT, .Lnoyield_\@

Can you explain the rationale here?

Using if_will_cond_yield_neon suggests the algo thinks it may run for
too long the stall preemption until completion, but we happily stall
preemption _and_ softirqs here.

Is it actually a bug to use the NEON conditional yield helpers in
softirq context?

Ideally, if processing in softirq context takes an unreasonable about of
time, the work would be handed off to an asynchronous worker, but that
does seem to conflict rather with the purpose of this series...

> +
> +	adr_l		x0, irq_stat + IRQ_CPUSTAT_SOFTIRQ_PENDING
> +	this_cpu_offset	x1
> +	ldr		w0, [x0, x1]
> +	cbnz		w0, .Lyield_\@	// yield on pending softirq in task context
> +.Lnoyield_\@:
>  	/* fall through to endif_yield_neon */
>  	.subsection	1
>  .Lyield_\@ :
> -#else
> -	.section	".discard.cond_yield_neon", "ax"
> -#endif
>  	.endm
>  
>  	.macro		do_cond_yield_neon
> diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
> index 7d32fc959b1a..34ef70877de4 100644
> --- a/arch/arm64/kernel/asm-offsets.c
> +++ b/arch/arm64/kernel/asm-offsets.c
> @@ -93,6 +93,8 @@ int main(void)
>    DEFINE(DMA_FROM_DEVICE,	DMA_FROM_DEVICE);
>    BLANK();
>    DEFINE(PREEMPT_DISABLE_OFFSET, PREEMPT_DISABLE_OFFSET);
> +  DEFINE(SOFTIRQ_SHIFT, SOFTIRQ_SHIFT);
> +  DEFINE(IRQ_CPUSTAT_SOFTIRQ_PENDING, offsetof(irq_cpustat_t, __softirq_pending));
>    BLANK();
>    DEFINE(CPU_BOOT_STACK,	offsetof(struct secondary_data, stack));
>    DEFINE(CPU_BOOT_TASK,		offsetof(struct secondary_data, task));
> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> index 062b21f30f94..823e3a8a8871 100644
> --- a/arch/arm64/kernel/fpsimd.c
> +++ b/arch/arm64/kernel/fpsimd.c
> @@ -180,7 +180,7 @@ static void __get_cpu_fpsimd_context(void)
>   */
>  static void get_cpu_fpsimd_context(void)
>  {
> -	preempt_disable();
> +	local_bh_disable();
>  	__get_cpu_fpsimd_context();
>  }
>  
> @@ -201,7 +201,7 @@ static void __put_cpu_fpsimd_context(void)
>  static void put_cpu_fpsimd_context(void)
>  {
>  	__put_cpu_fpsimd_context();
> -	preempt_enable();
> +	local_bh_enable();
>  }
>  
>  static bool have_cpu_fpsimd_context(void)

I was concerned about catching all the relevant preempt_disable()s, but
it had slipped my memory that Julien had factored these into one place.

I can't see off the top of my head any reason why this shouldn't work.


In threory, switching to local_bh_enable() here will add a check for
pending softirqs onto context handling fast paths.  I haven't dug into
how that works, so perhaps this is trivial on top of the preemption
check in preempt_enable().  Do you see any difference in hackbench or
similar benchmarks?

Cheers
---Dave
