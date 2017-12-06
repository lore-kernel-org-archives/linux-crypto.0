From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v2 11/19] arm64: assembler: add macro to conditionally
 yield the NEON under PREEMPT
Date: Wed, 6 Dec 2017 14:37:57 +0000
Message-ID: <20171206143756.GC22781@e103592.cambridge.arm.com>
References: <20171204122645.31535-1-ard.biesheuvel@linaro.org>
 <20171204122645.31535-12-ard.biesheuvel@linaro.org>
 <20171205122757.GW22781@e103592.cambridge.arm.com>
 <DD92A22D-E5EF-4C97-8C76-4797892518A4@linaro.org>
 <CAKv+Gu88Ym4NxoLxVd07Z07PD454_ONV4D=pqvxezPvAPnd5og@mail.gmail.com>
 <20171206115134.GZ22781@e103592.cambridge.arm.com>
 <CAKv+Gu83CR=KGawz5WRQygULcqX+DjhVjAeR-+QOGYx=2oPTzA@mail.gmail.com>
 <20171206121251.GM12608@e103592.cambridge.arm.com>
 <CAKv+Gu-MBUt4C4ZrjUD1veQSZ8xX8Q3hNS+E3kAWBVtZ7Um-FQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mark Rutland <Mark.Rutland@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Peter Zijlstra <peterz@infradead.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Steven Rostedt <rostedt@goodmis.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:36616 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751453AbdLFOiD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Dec 2017 09:38:03 -0500
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-MBUt4C4ZrjUD1veQSZ8xX8Q3hNS+E3kAWBVtZ7Um-FQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 06, 2017 at 12:25:44PM +0000, Ard Biesheuvel wrote:
> On 6 December 2017 at 12:12, Dave P Martin <Dave.Martin@arm.com> wrote:
> > On Wed, Dec 06, 2017 at 11:57:12AM +0000, Ard Biesheuvel wrote:
> >> On 6 December 2017 at 11:51, Dave Martin <Dave.Martin@arm.com> wrote:
> >> > On Tue, Dec 05, 2017 at 06:04:34PM +0000, Ard Biesheuvel wrote:
> >> >> On 5 December 2017 at 12:45, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> >> >> >
> >> >> >
> >> >> >> On 5 Dec 2017, at 12:28, Dave Martin <Dave.Martin@arm.com> wrote:

[...]

> >> >> >> If we had
> >> >> >>
> >> >> >>    if_cond_yield_neon
> >> >> >>    // patchup code
> >> >> >>    endif_yield_neon
> >> >> >>
> >> >>
> >> >> I like this, but ...
> >> >>
> >> >> >> then the caller is free to conditionally branch over that as appropriate
> >> >> >> like
> >> >> >>
> >> >> >> loop:
> >> >> >>    // crypto stuff
> >> >> >>    tst x0, #0xf
> >> >> >>    b.ne    loop
> >> >> >>
> >> >> >>    if_cond_yield_neon
> >> >> >>    // patchup code
> >> >> >>    endif_cond_yield_neon
> >> >> >>
> >> >>
> >> >> I need to put the post patchup code somewhere too. Please refer to the
> >> >> CRC patches for the best examples of this.
> >> >
> >> > I'm not sure I follow.  If you need to do something different after
> >> > patchup, can't you either pull that code into the if...endif too, or
> >> > otherwise put a branch before the endif?
> >> >
> >>
> >> No, not really.
> >>
> >> What I currently have is
> >>
> >> >    if_cond_yield_neon
> >> >    // patchup code
> >> >    endif_cond_yield_neon
> >>
> >> which is being turned into
> >>
> >>     get_thread_info x0
> >>     ldr w1, [x0, #TSK_TI_PREEMPT]
> >>     ldr x0, [x0, #TSK_TI_FLAGS]
> >>     cmp w1, #1 // == PREEMPT_OFFSET
> >>     csel x0, x0, xzr, eq
> >>     tbnz x0, #TIF_NEED_RESCHED, 5555f // needs rescheduling?
> >> 4444:
> >>
> >>     .subsection 1
> >> 5555:
> >>     // patchup code
> >>     bl kernel_neon_end
> >>     bl kernel_neon_begin
> >>     // post patchup code goes here
> >>     b 4444b
> >>     .subsection
> >>
> >> so what I basically need is a place to put the post patchup code,
> >> unless I open code it and branch to a different label right after
> >> kernel_neon_begin
> >
> > Ah, I get you.  I had convinced myself that there was only post-
> > patchup code.
> >
> > So you conceptually want something like
> >
> > if_will_cond_yield_neon
> >         // pre-yield patchup code
> > do_cond_yield_neon
> >         // post-yield patchup code
> > endif_yield_neon
> >
> > .macro if_will_cond_yield_neon
> >         // do preempt_count == 1 && TIF_NEED_RESCHED check
> >         b.wont_yield 3432f
> > .endm
> >
> > .macro do_cond_yield_neon
> >         bl      kernel_neon_end
> >         bl      kernel_neon_begin
> > .endm
> >
> > .macro endif_yield_neon
> > 3432:
> > .endm
> >
> > The main difference I see is that this doesn't get the slow-case
> > code out of line.
> >
> > Or have I still missed something?
> >
> 
> No, that seems accurate. I think the idiom looks much better, but I'd
> still like to get the code out of line, so that everything disappears
> completely for !CONFIG_PREEMPT.

Sure, out-of-lining should still be possible by spilling into another
section or subsection similarly to what you were already doing -- and
it may still make sense to have (optional?) label arguments to allow
some branch elision.  I didn't want to complicate things initially.

> I'll try to rework my stuff using this as a starting point.

Cool, let me know.

Cheers
---Dave
