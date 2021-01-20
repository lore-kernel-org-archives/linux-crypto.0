Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 927CAC433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Jan 2021 17:23:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A20E23358
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Jan 2021 17:23:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727190AbhATRWt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Jan 2021 12:22:49 -0500
Received: from foss.arm.com ([217.140.110.172]:40710 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387613AbhATPpk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Jan 2021 10:45:40 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2976631B;
        Wed, 20 Jan 2021 07:44:41 -0800 (PST)
Received: from arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7882E3F68F;
        Wed, 20 Jan 2021 07:44:39 -0800 (PST)
Date:   Wed, 20 Jan 2021 15:44:23 +0000
From:   Dave Martin <Dave.Martin@arm.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Peter Zijlstra <peterz@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 4/5] arm64: fpsimd: run kernel mode NEON with
 softirqs disabled
Message-ID: <20210120154422.GB1684@arm.com>
References: <20201218170106.23280-1-ardb@kernel.org>
 <20201218170106.23280-5-ardb@kernel.org>
 <20210119160045.GA1684@arm.com>
 <CAMj1kXGSB8AJRhftUxabQhaggWHukiVwrSkUR2i=XQcZ3dqynQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXGSB8AJRhftUxabQhaggWHukiVwrSkUR2i=XQcZ3dqynQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 19, 2021 at 05:29:05PM +0100, Ard Biesheuvel wrote:
> On Tue, 19 Jan 2021 at 17:01, Dave Martin <Dave.Martin@arm.com> wrote:
> >
> > On Fri, Dec 18, 2020 at 06:01:05PM +0100, Ard Biesheuvel wrote:
> > > Kernel mode NEON can be used in task or softirq context, but only in
> > > a non-nesting manner, i.e., softirq context is only permitted if the
> > > interrupt was not taken at a point where the kernel was using the NEON
> > > in task context.
> > >
> > > This means all users of kernel mode NEON have to be aware of this
> > > limitation, and either need to provide scalar fallbacks that may be much
> > > slower (up to 20x for AES instructions) and potentially less safe, or
> > > use an asynchronous interface that defers processing to a later time
> > > when the NEON is guaranteed to be available.
> > >
> > > Given that grabbing and releasing the NEON is cheap, we can relax this
> > > restriction, by increasing the granularity of kernel mode NEON code, and
> > > always disabling softirq processing while the NEON is being used in task
> > > context.
> > >
> > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> >
> > Sorry for the slow reply on this...  it looks reasonable, but I have a
> > few comments below.
> >
> 
> No worries - thanks for taking a look.
> 
> > > ---
> > >  arch/arm64/include/asm/assembler.h | 19 +++++++++++++------
> > >  arch/arm64/kernel/asm-offsets.c    |  2 ++
> > >  arch/arm64/kernel/fpsimd.c         |  4 ++--
> > >  3 files changed, 17 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
> > > index ddbe6bf00e33..74ce46ed55ac 100644
> > > --- a/arch/arm64/include/asm/assembler.h
> > > +++ b/arch/arm64/include/asm/assembler.h
> > > @@ -15,6 +15,7 @@
> > >  #include <asm-generic/export.h>
> > >
> > >  #include <asm/asm-offsets.h>
> > > +#include <asm/alternative.h>
> > >  #include <asm/cpufeature.h>
> > >  #include <asm/cputype.h>
> > >  #include <asm/debug-monitors.h>
> > > @@ -717,17 +718,23 @@ USER(\label, ic ivau, \tmp2)                    // invalidate I line PoU
> > >       .endm
> > >
> > >       .macro          if_will_cond_yield_neon
> > > -#ifdef CONFIG_PREEMPTION
> > >       get_current_task        x0
> > >       ldr             x0, [x0, #TSK_TI_PREEMPT]
> > > -     sub             x0, x0, #PREEMPT_DISABLE_OFFSET
> > > -     cbz             x0, .Lyield_\@
> > > +#ifdef CONFIG_PREEMPTION
> > > +     cmp             x0, #PREEMPT_DISABLE_OFFSET
> > > +     beq             .Lyield_\@      // yield on need_resched in task context
> > > +#endif
> > > +     /* never yield while serving a softirq */
> > > +     tbnz            x0, #SOFTIRQ_SHIFT, .Lnoyield_\@
> >
> > Can you explain the rationale here?
> >
> > Using if_will_cond_yield_neon suggests the algo thinks it may run for
> > too long the stall preemption until completion, but we happily stall
> > preemption _and_ softirqs here.
> >
> > Is it actually a bug to use the NEON conditional yield helpers in
> > softirq context?
> >
> 
> No, it is not. But calling kernel_neon_end() from softirq context will
> not cause it to finish any faster, so there is really no point in
> doing so.
> 
> > Ideally, if processing in softirq context takes an unreasonable about of
> > time, the work would be handed off to an asynchronous worker, but that
> > does seem to conflict rather with the purpose of this series...
> >
> 
> Agreed, but this is not something we can police at this level. If the
> caller does an unreasonable amount of work from a softirq, no amount
> of yielding is going to make a difference.

Ack, just wanted to make sure I wasn't missing something.

Anyone writing softirq code can starve preemption, so I agree that we
should trust people to know what they're doing.


> > > +
> > > +     adr_l           x0, irq_stat + IRQ_CPUSTAT_SOFTIRQ_PENDING
> > > +     this_cpu_offset x1
> > > +     ldr             w0, [x0, x1]
> > > +     cbnz            w0, .Lyield_\@  // yield on pending softirq in task context
> > > +.Lnoyield_\@:
> > >       /* fall through to endif_yield_neon */
> > >       .subsection     1
> > >  .Lyield_\@ :
> > > -#else
> > > -     .section        ".discard.cond_yield_neon", "ax"
> > > -#endif
> > >       .endm
> > >
> > >       .macro          do_cond_yield_neon
> > > diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
> > > index 7d32fc959b1a..34ef70877de4 100644
> > > --- a/arch/arm64/kernel/asm-offsets.c
> > > +++ b/arch/arm64/kernel/asm-offsets.c
> > > @@ -93,6 +93,8 @@ int main(void)
> > >    DEFINE(DMA_FROM_DEVICE,    DMA_FROM_DEVICE);
> > >    BLANK();
> > >    DEFINE(PREEMPT_DISABLE_OFFSET, PREEMPT_DISABLE_OFFSET);
> > > +  DEFINE(SOFTIRQ_SHIFT, SOFTIRQ_SHIFT);
> > > +  DEFINE(IRQ_CPUSTAT_SOFTIRQ_PENDING, offsetof(irq_cpustat_t, __softirq_pending));
> > >    BLANK();
> > >    DEFINE(CPU_BOOT_STACK,     offsetof(struct secondary_data, stack));
> > >    DEFINE(CPU_BOOT_TASK,              offsetof(struct secondary_data, task));
> > > diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> > > index 062b21f30f94..823e3a8a8871 100644
> > > --- a/arch/arm64/kernel/fpsimd.c
> > > +++ b/arch/arm64/kernel/fpsimd.c
> > > @@ -180,7 +180,7 @@ static void __get_cpu_fpsimd_context(void)
> > >   */
> > >  static void get_cpu_fpsimd_context(void)
> > >  {
> > > -     preempt_disable();
> > > +     local_bh_disable();
> > >       __get_cpu_fpsimd_context();
> > >  }
> > >
> > > @@ -201,7 +201,7 @@ static void __put_cpu_fpsimd_context(void)
> > >  static void put_cpu_fpsimd_context(void)
> > >  {
> > >       __put_cpu_fpsimd_context();
> > > -     preempt_enable();
> > > +     local_bh_enable();
> > >  }
> > >
> > >  static bool have_cpu_fpsimd_context(void)
> >
> > I was concerned about catching all the relevant preempt_disable()s, but
> > it had slipped my memory that Julien had factored these into one place.
> >
> > I can't see off the top of my head any reason why this shouldn't work.
> >
> 
> Thanks.
> 
> >
> > In threory, switching to local_bh_enable() here will add a check for
> > pending softirqs onto context handling fast paths.  I haven't dug into
> > how that works, so perhaps this is trivial on top of the preemption
> > check in preempt_enable().  Do you see any difference in hackbench or
> > similar benchmarks?
> >
> 
> I haven't tried, tbh. But by context handling fast paths, you mean
> managing the FP/SIMD state at context switch time, right? Checking for
> pending softirqs amounts to a single per-CPU load plus compare, so
> that should be negligible AFAICT. Obviously, actually handling the

Yes.  I've tended to assume, rather than prove, that this kind of thing
is negligible -- so I confess I had not attempted to measure these
effects when writing the original code.

> softirq may take additional time, but that penalty has to be taken
> somewhere - I don't see how that would create extra work that we
> wouldn't have to do otherwise.
> 
> I'll do some experiments with hackbench once I get back to this series.

That sounds fine.

Probably you won't find a significant difference anyway.

Cheers
---Dave
