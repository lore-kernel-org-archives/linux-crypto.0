Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19DBEC433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Feb 2021 18:31:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3A4964E0F
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Feb 2021 18:31:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbhBOSbI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Feb 2021 13:31:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:60798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229925AbhBOSbI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Feb 2021 13:31:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AAEDC64DFF;
        Mon, 15 Feb 2021 18:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613413826;
        bh=x8OxQwBZU/RMhOy2ja6Kw/wOYNKkNQjVc5rU0UqZG+M=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Gs5LrN00HgTFTez20C8HCFDIK/PAum6DpmR/YHl05Wa2GOB41YJFnP09BAHsDkPz7
         Uc7sHhE9jMvx5JtvXm6RLg8xKhlQV/KpJeIpId3bfS5ruhoN4qFhDWwzQ3DRhi3sDA
         YK5iiEUZeJQLpmsI7FISl1Y6ij1C/zo1xOO9tHD2i4dKrduwIRnCHCaxnXYcwpTBRD
         0FKrGvDWSbszos1oUwGThI9YeWlGJMFGHTEYTWd8kcg3ES+nqa9oHK22KVeeCyt55g
         B5/AJjhgcQ2q2i41IFdRAGeibYiXN5sHlS3hPwHAZ020kYjrArzXma8LL5pyjBG1yu
         4OiMdci8657AA==
Received: by mail-oi1-f170.google.com with SMTP id u66so8647037oig.9;
        Mon, 15 Feb 2021 10:30:26 -0800 (PST)
X-Gm-Message-State: AOAM531I21qfaZBkxqsLLPd2iN23xCFeKmHGmhN5pv+mr3SKyML79MsW
        jyRE8Xf0lKCNso4IOKguxAq3oLtpS16FC3BqvZQ=
X-Google-Smtp-Source: ABdhPJw76QW9zNZ/GOns4eLwvlpysOkkbtSN4hGo0lfMTUYwSaAKviPX1TneTGOiNC1a7zI/M5jdoD82HEOl6nPln5c=
X-Received: by 2002:aca:b6c1:: with SMTP id g184mr142752oif.47.1613413825941;
 Mon, 15 Feb 2021 10:30:25 -0800 (PST)
MIME-Version: 1.0
References: <20201218170106.23280-1-ardb@kernel.org> <20201218170106.23280-5-ardb@kernel.org>
 <20210119160045.GA1684@arm.com> <CAMj1kXGSB8AJRhftUxabQhaggWHukiVwrSkUR2i=XQcZ3dqynQ@mail.gmail.com>
 <20210120154422.GB1684@arm.com>
In-Reply-To: <20210120154422.GB1684@arm.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 15 Feb 2021 19:30:14 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEO1+JNQH5R-SAx73TWcuOA4ZtejobhO=9B5o---h5oVg@mail.gmail.com>
Message-ID: <CAMj1kXEO1+JNQH5R-SAx73TWcuOA4ZtejobhO=9B5o---h5oVg@mail.gmail.com>
Subject: Re: [RFC PATCH 4/5] arm64: fpsimd: run kernel mode NEON with softirqs disabled
To:     Dave Martin <Dave.Martin@arm.com>
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 20 Jan 2021 at 16:44, Dave Martin <Dave.Martin@arm.com> wrote:
>
> On Tue, Jan 19, 2021 at 05:29:05PM +0100, Ard Biesheuvel wrote:
> > On Tue, 19 Jan 2021 at 17:01, Dave Martin <Dave.Martin@arm.com> wrote:
> > >
> > > On Fri, Dec 18, 2020 at 06:01:05PM +0100, Ard Biesheuvel wrote:
> > > > Kernel mode NEON can be used in task or softirq context, but only in
> > > > a non-nesting manner, i.e., softirq context is only permitted if the
> > > > interrupt was not taken at a point where the kernel was using the NEON
> > > > in task context.
> > > >
> > > > This means all users of kernel mode NEON have to be aware of this
> > > > limitation, and either need to provide scalar fallbacks that may be much
> > > > slower (up to 20x for AES instructions) and potentially less safe, or
> > > > use an asynchronous interface that defers processing to a later time
> > > > when the NEON is guaranteed to be available.
> > > >
> > > > Given that grabbing and releasing the NEON is cheap, we can relax this
> > > > restriction, by increasing the granularity of kernel mode NEON code, and
> > > > always disabling softirq processing while the NEON is being used in task
> > > > context.
> > > >
> > > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > >
> > > Sorry for the slow reply on this...  it looks reasonable, but I have a
> > > few comments below.
> > >
> >
> > No worries - thanks for taking a look.
> >
> > > > ---
> > > >  arch/arm64/include/asm/assembler.h | 19 +++++++++++++------
> > > >  arch/arm64/kernel/asm-offsets.c    |  2 ++
> > > >  arch/arm64/kernel/fpsimd.c         |  4 ++--
> > > >  3 files changed, 17 insertions(+), 8 deletions(-)
> > > >
> > > > diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
> > > > index ddbe6bf00e33..74ce46ed55ac 100644
> > > > --- a/arch/arm64/include/asm/assembler.h
> > > > +++ b/arch/arm64/include/asm/assembler.h
> > > > @@ -15,6 +15,7 @@
> > > >  #include <asm-generic/export.h>
> > > >
> > > >  #include <asm/asm-offsets.h>
> > > > +#include <asm/alternative.h>
> > > >  #include <asm/cpufeature.h>
> > > >  #include <asm/cputype.h>
> > > >  #include <asm/debug-monitors.h>
> > > > @@ -717,17 +718,23 @@ USER(\label, ic ivau, \tmp2)                    // invalidate I line PoU
> > > >       .endm
> > > >
> > > >       .macro          if_will_cond_yield_neon
> > > > -#ifdef CONFIG_PREEMPTION
> > > >       get_current_task        x0
> > > >       ldr             x0, [x0, #TSK_TI_PREEMPT]
> > > > -     sub             x0, x0, #PREEMPT_DISABLE_OFFSET
> > > > -     cbz             x0, .Lyield_\@
> > > > +#ifdef CONFIG_PREEMPTION
> > > > +     cmp             x0, #PREEMPT_DISABLE_OFFSET
> > > > +     beq             .Lyield_\@      // yield on need_resched in task context
> > > > +#endif
> > > > +     /* never yield while serving a softirq */
> > > > +     tbnz            x0, #SOFTIRQ_SHIFT, .Lnoyield_\@
> > >
> > > Can you explain the rationale here?
> > >
> > > Using if_will_cond_yield_neon suggests the algo thinks it may run for
> > > too long the stall preemption until completion, but we happily stall
> > > preemption _and_ softirqs here.
> > >
> > > Is it actually a bug to use the NEON conditional yield helpers in
> > > softirq context?
> > >
> >
> > No, it is not. But calling kernel_neon_end() from softirq context will
> > not cause it to finish any faster, so there is really no point in
> > doing so.
> >
> > > Ideally, if processing in softirq context takes an unreasonable about of
> > > time, the work would be handed off to an asynchronous worker, but that
> > > does seem to conflict rather with the purpose of this series...
> > >
> >
> > Agreed, but this is not something we can police at this level. If the
> > caller does an unreasonable amount of work from a softirq, no amount
> > of yielding is going to make a difference.
>
> Ack, just wanted to make sure I wasn't missing something.
>
> Anyone writing softirq code can starve preemption, so I agree that we
> should trust people to know what they're doing.
>
>
> > > > +
> > > > +     adr_l           x0, irq_stat + IRQ_CPUSTAT_SOFTIRQ_PENDING
> > > > +     this_cpu_offset x1
> > > > +     ldr             w0, [x0, x1]
> > > > +     cbnz            w0, .Lyield_\@  // yield on pending softirq in task context
> > > > +.Lnoyield_\@:
> > > >       /* fall through to endif_yield_neon */
> > > >       .subsection     1
> > > >  .Lyield_\@ :
> > > > -#else
> > > > -     .section        ".discard.cond_yield_neon", "ax"
> > > > -#endif
> > > >       .endm
> > > >
> > > >       .macro          do_cond_yield_neon
> > > > diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
> > > > index 7d32fc959b1a..34ef70877de4 100644
> > > > --- a/arch/arm64/kernel/asm-offsets.c
> > > > +++ b/arch/arm64/kernel/asm-offsets.c
> > > > @@ -93,6 +93,8 @@ int main(void)
> > > >    DEFINE(DMA_FROM_DEVICE,    DMA_FROM_DEVICE);
> > > >    BLANK();
> > > >    DEFINE(PREEMPT_DISABLE_OFFSET, PREEMPT_DISABLE_OFFSET);
> > > > +  DEFINE(SOFTIRQ_SHIFT, SOFTIRQ_SHIFT);
> > > > +  DEFINE(IRQ_CPUSTAT_SOFTIRQ_PENDING, offsetof(irq_cpustat_t, __softirq_pending));
> > > >    BLANK();
> > > >    DEFINE(CPU_BOOT_STACK,     offsetof(struct secondary_data, stack));
> > > >    DEFINE(CPU_BOOT_TASK,              offsetof(struct secondary_data, task));
> > > > diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> > > > index 062b21f30f94..823e3a8a8871 100644
> > > > --- a/arch/arm64/kernel/fpsimd.c
> > > > +++ b/arch/arm64/kernel/fpsimd.c
> > > > @@ -180,7 +180,7 @@ static void __get_cpu_fpsimd_context(void)
> > > >   */
> > > >  static void get_cpu_fpsimd_context(void)
> > > >  {
> > > > -     preempt_disable();
> > > > +     local_bh_disable();
> > > >       __get_cpu_fpsimd_context();
> > > >  }
> > > >
> > > > @@ -201,7 +201,7 @@ static void __put_cpu_fpsimd_context(void)
> > > >  static void put_cpu_fpsimd_context(void)
> > > >  {
> > > >       __put_cpu_fpsimd_context();
> > > > -     preempt_enable();
> > > > +     local_bh_enable();
> > > >  }
> > > >
> > > >  static bool have_cpu_fpsimd_context(void)
> > >
> > > I was concerned about catching all the relevant preempt_disable()s, but
> > > it had slipped my memory that Julien had factored these into one place.
> > >
> > > I can't see off the top of my head any reason why this shouldn't work.
> > >
> >
> > Thanks.
> >
> > >
> > > In threory, switching to local_bh_enable() here will add a check for
> > > pending softirqs onto context handling fast paths.  I haven't dug into
> > > how that works, so perhaps this is trivial on top of the preemption
> > > check in preempt_enable().  Do you see any difference in hackbench or
> > > similar benchmarks?
> > >
> >
> > I haven't tried, tbh. But by context handling fast paths, you mean
> > managing the FP/SIMD state at context switch time, right? Checking for
> > pending softirqs amounts to a single per-CPU load plus compare, so
> > that should be negligible AFAICT. Obviously, actually handling the
>
> Yes.  I've tended to assume, rather than prove, that this kind of thing
> is negligible -- so I confess I had not attempted to measure these
> effects when writing the original code.
>
> > softirq may take additional time, but that penalty has to be taken
> > somewhere - I don't see how that would create extra work that we
> > wouldn't have to do otherwise.
> >
> > I'll do some experiments with hackbench once I get back to this series.
>
> That sounds fine.
>
> Probably you won't find a significant difference anyway.
>

Finally got around to trying this: as expected, I don't see any
difference at all between the two versions (tested on TX2)
