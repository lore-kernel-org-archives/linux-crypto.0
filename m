From: Dave P Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v2 11/19] arm64: assembler: add macro to conditionally
 yield the NEON under PREEMPT
Date: Wed, 6 Dec 2017 12:12:51 +0000
Message-ID: <20171206121251.GM12608@e103592.cambridge.arm.com>
References: <20171204122645.31535-1-ard.biesheuvel@linaro.org>
 <20171204122645.31535-12-ard.biesheuvel@linaro.org>
 <20171205122757.GW22781@e103592.cambridge.arm.com>
 <DD92A22D-E5EF-4C97-8C76-4797892518A4@linaro.org>
 <CAKv+Gu88Ym4NxoLxVd07Z07PD454_ONV4D=pqvxezPvAPnd5og@mail.gmail.com>
 <20171206115134.GZ22781@e103592.cambridge.arm.com>
 <CAKv+Gu83CR=KGawz5WRQygULcqX+DjhVjAeR-+QOGYx=2oPTzA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
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
Return-path: <linux-rt-users-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu83CR=KGawz5WRQygULcqX+DjhVjAeR-+QOGYx=2oPTzA@mail.gmail.com>
Sender: linux-rt-users-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Dec 06, 2017 at 11:57:12AM +0000, Ard Biesheuvel wrote:
> On 6 December 2017 at 11:51, Dave Martin <Dave.Martin@arm.com> wrote:
> > On Tue, Dec 05, 2017 at 06:04:34PM +0000, Ard Biesheuvel wrote:
> >> On 5 December 2017 at 12:45, Ard Biesheuvel <ard.biesheuvel@linaro.org=
> wrote:
> >> >
> >> >
> >> >> On 5 Dec 2017, at 12:28, Dave Martin <Dave.Martin@arm.com> wrote:
> >> >>
> >> >>> On Mon, Dec 04, 2017 at 12:26:37PM +0000, Ard Biesheuvel wrote:
> >> >>> Add a support macro to conditionally yield the NEON (and thus the =
CPU)
> >> >>> that may be called from the assembler code. Given that especially =
the
> >> >>> instruction based accelerated crypto code may use very tight loops=
, add
> >> >>> some parametrization so that the TIF_NEED_RESCHED flag test is onl=
y
> >> >>> executed every so many loop iterations.
> >> >>>
> >> >>> In some cases, yielding the NEON involves saving and restoring a n=
on
> >> >>> trivial amount of context (especially in the CRC folding algorithm=
s),
> >> >>> and so the macro is split into two, and the code in between is onl=
y
> >> >>> executed when the yield path is taken, allowing the contex to be p=
reserved.
> >> >>> The second macro takes a label argument that marks the resume-from=
-yield
> >> >>> path, which should restore the preserved context again.
> >> >>>
> >> >>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> >> >>> ---
> >> >>> arch/arm64/include/asm/assembler.h | 50 ++++++++++++++++++++
> >> >>> 1 file changed, 50 insertions(+)
> >> >>>
> >> >>> diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/inclu=
de/asm/assembler.h
> >> >>> index aef72d886677..917b026d3e00 100644
> >> >>> --- a/arch/arm64/include/asm/assembler.h
> >> >>> +++ b/arch/arm64/include/asm/assembler.h
> >> >>> @@ -512,4 +512,54 @@ alternative_else_nop_endif
> >> >>> #endif
> >> >>>    .endm
> >> >>>
> >> >>> +/*
> >> >>> + * yield_neon - check whether to yield to another runnable task f=
rom
> >> >>> + *        kernel mode NEON code (running with preemption disabled=
)
> >> >>> + *
> >> >>> + * - Check whether the preempt count is exactly 1, in which case =
disabling
> >> >>> + *   preemption once will make the task preemptible. If this is n=
ot the case,
> >> >>> + *   yielding is pointless.
> >> >>> + * - Check whether TIF_NEED_RESCHED is set, and if so, disable an=
d re-enable
> >> >>> + *   kernel mode NEON (which will trigger a reschedule), and bran=
ch to the
> >> >>> + *   yield fixup code at @lbl.
> >> >>> + */
> >> >>> +    .macro        yield_neon, lbl:req, ctr, order, stride, loop
> >> >>> +    yield_neon_pre    \ctr, \order, \stride, \loop
> >> >>> +    yield_neon_post    \lbl
> >> >>> +    .endm
> >> >>> +
> >> >>> +    .macro        yield_neon_pre, ctr, order=3D0, stride, loop=3D=
4444f
> >> >>> +#ifdef CONFIG_PREEMPT
> >> >>> +    /*
> >> >>> +     * With some algorithms, it makes little sense to poll the
> >> >>> +     * TIF_NEED_RESCHED flag after every iteration, so only perfo=
rm
> >> >>> +     * the check every 2^order strides.
> >> >>> +     */
> >> >>> +    .if        \order > 1
> >> >>> +    .if        (\stride & (\stride - 1)) !=3D 0
> >> >>> +    .error        "stride should be a power of 2"
> >> >>> +    .endif
> >> >>> +    tst        \ctr, #((1 << \order) * \stride - 1) & ~(\stride -=
 1)
> >> >>> +    b.ne        \loop
> >> >>> +    .endif
> >> >>
> >> >> I'm not sure what baking in this check gives us, and this seems to
> >> >> conflate two rather different things: yielding and defining a
> >> >> "heartbeat" frequency for the calling code.
> >> >>
> >> >> Can we separate out the crypto-loop-helper semantics from the yield=
-
> >> >> neon stuff?
> >> >>
> >> >
> >> > Fair enough. I incorporated the check here so it disappears from the=
 code entirely when !CONFIG_PREEMPT, because otherwise, you end up with a s=
equence that is mispredicted every # iterations without any benefit.
> >> > I guess i could macroise that separately though.
> >> >
> >> >> If we had
> >> >>
> >> >>    if_cond_yield_neon
> >> >>    // patchup code
> >> >>    endif_yield_neon
> >> >>
> >>
> >> I like this, but ...
> >>
> >> >> then the caller is free to conditionally branch over that as approp=
riate
> >> >> like
> >> >>
> >> >> loop:
> >> >>    // crypto stuff
> >> >>    tst x0, #0xf
> >> >>    b.ne    loop
> >> >>
> >> >>    if_cond_yield_neon
> >> >>    // patchup code
> >> >>    endif_cond_yield_neon
> >> >>
> >>
> >> I need to put the post patchup code somewhere too. Please refer to the
> >> CRC patches for the best examples of this.
> >
> > I'm not sure I follow.  If you need to do something different after
> > patchup, can't you either pull that code into the if...endif too, or
> > otherwise put a branch before the endif?
> >
>
> No, not really.
>
> What I currently have is
>
> >    if_cond_yield_neon
> >    // patchup code
> >    endif_cond_yield_neon
>
> which is being turned into
>
>     get_thread_info x0
>     ldr w1, [x0, #TSK_TI_PREEMPT]
>     ldr x0, [x0, #TSK_TI_FLAGS]
>     cmp w1, #1 // =3D=3D PREEMPT_OFFSET
>     csel x0, x0, xzr, eq
>     tbnz x0, #TIF_NEED_RESCHED, 5555f // needs rescheduling?
> 4444:
>
>     .subsection 1
> 5555:
>     // patchup code
>     bl kernel_neon_end
>     bl kernel_neon_begin
>     // post patchup code goes here
>     b 4444b
>     .subsection
>
> so what I basically need is a place to put the post patchup code,
> unless I open code it and branch to a different label right after
> kernel_neon_begin

Ah, I get you.  I had convinced myself that there was only post-
patchup code.

So you conceptually want something like

if_will_cond_yield_neon
        // pre-yield patchup code
do_cond_yield_neon
        // post-yield patchup code
endif_yield_neon

.macro if_will_cond_yield_neon
        // do preempt_count =3D=3D 1 && TIF_NEED_RESCHED check
        b.wont_yield 3432f
.endm

.macro do_cond_yield_neon
        bl      kernel_neon_end
        bl      kernel_neon_begin
.endm

.macro endif_yield_neon
3432:
.endm

The main difference I see is that this doesn't get the slow-case
code out of line.

Or have I still missed something?

Cheers
---Dave
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
