From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v3 10/20] arm64: assembler: add utility macros to push/pop
 stack frames
Date: Thu, 7 Dec 2017 14:58:43 +0000
Message-ID: <CAKv+Gu_CjvvBuCpkCDNadAo0vZv4qJmNM7=EQXMM06DWecFcvg@mail.gmail.com>
References: <20171206194346.24393-1-ard.biesheuvel@linaro.org>
 <20171206194346.24393-11-ard.biesheuvel@linaro.org> <20171207141104.GE22781@e103592.cambridge.arm.com>
 <CAKv+Gu_82v_L9dZczQZbkmksc1wvOBsa28URP4Q7MEcvAwxhmw@mail.gmail.com> <20171207145309.GG22781@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Mark Rutland <mark.rutland@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Peter Zijlstra <peterz@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Steven Rostedt <rostedt@goodmis.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        linux-rt-users@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:33297 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754468AbdLGO6o (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Dec 2017 09:58:44 -0500
Received: by mail-it0-f66.google.com with SMTP id o130so979114itg.0
        for <linux-crypto@vger.kernel.org>; Thu, 07 Dec 2017 06:58:44 -0800 (PST)
In-Reply-To: <20171207145309.GG22781@e103592.cambridge.arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 7 December 2017 at 14:53, Dave Martin <Dave.Martin@arm.com> wrote:
> On Thu, Dec 07, 2017 at 02:21:17PM +0000, Ard Biesheuvel wrote:
>> On 7 December 2017 at 14:11, Dave Martin <Dave.Martin@arm.com> wrote:
>> > On Wed, Dec 06, 2017 at 07:43:36PM +0000, Ard Biesheuvel wrote:
>> >> We are going to add code to all the NEON crypto routines that will
>> >> turn them into non-leaf functions, so we need to manage the stack
>> >> frames. To make this less tedious and error prone, add some macros
>> >> that take the number of callee saved registers to preserve and the
>> >> extra size to allocate in the stack frame (for locals) and emit
>> >> the ldp/stp sequences.
>> >>
>> >> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> >> ---
>> >>  arch/arm64/include/asm/assembler.h | 60 ++++++++++++++++++++
>> >>  1 file changed, 60 insertions(+)
>> >>
>> >> diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
>> >> index aef72d886677..5f61487e9f93 100644
>> >> --- a/arch/arm64/include/asm/assembler.h
>> >> +++ b/arch/arm64/include/asm/assembler.h
>> >> @@ -499,6 +499,66 @@ alternative_else_nop_endif
>> >>  #endif
>> >>       .endm
>> >>
>> >> +     /*
>> >> +      * frame_push - Push @regcount callee saved registers to the stack,
>> >> +      *              starting at x19, as well as x29/x30, and set x29 to
>> >> +      *              the new value of sp. Add @extra bytes of stack space
>> >> +      *              for locals.
>> >> +      */
>> >> +     .macro          frame_push, regcount:req, extra
>> >> +     __frame         st, \regcount, \extra
>> >> +     .endm
>> >> +
>> >> +     /*
>> >> +      * frame_pop  - Pop @regcount callee saved registers from the stack,
>> >> +      *              starting at x19, as well as x29/x30. Also pop @extra
>> >> +      *              bytes of stack space for locals.
>> >> +      */
>> >> +     .macro          frame_pop, regcount:req, extra
>> >> +     __frame         ld, \regcount, \extra
>> >> +     .endm
>> >> +
>> >> +     .macro          __frame, op, regcount:req, extra=0
>> >> +     .ifc            \op, st
>> >> +     stp             x29, x30, [sp, #-((\regcount + 3) / 2) * 16 - \extra]!
>> >> +     mov             x29, sp
>> >> +     .endif
>> >> +     .if             \regcount < 0 || \regcount > 10
>> >> +     .error          "regcount should be in the range [0 ... 10]"
>> >> +     .endif
>> >> +     .if             (\extra % 16) != 0
>> >> +     .error          "extra should be a multiple of 16 bytes"
>> >> +     .endif
>> >> +     .if             \regcount > 1
>> >> +     \op\()p         x19, x20, [sp, #16]
>> >> +     .if             \regcount > 3
>> >> +     \op\()p         x21, x22, [sp, #32]
>> >> +     .if             \regcount > 5
>> >> +     \op\()p         x23, x24, [sp, #48]
>> >> +     .if             \regcount > 7
>> >> +     \op\()p         x25, x26, [sp, #64]
>> >> +     .if             \regcount > 9
>> >> +     \op\()p         x27, x28, [sp, #80]
>> >
>> > Can the _for thing I introduced in fpsimdmacros.h be any use here?
>> > Alternatively, the following could replace that .if-slide,
>> > providing the calling macro does .altmacro .. .noaltmacro somewhere.
>> >
>> > .macro _pushpop2 op, n1, n2, offset
>> >         \op     x\n1, x\n2, [sp, #\offset]
>> > .endm
>> >
>> > .macro _pushpop op, first, last, offset
>> >         .if \first < \last
>> >         _pushpop2 \op\()p, \first, %\first + 1, \offset
>> >         _pushpop \op, %\first + 2, \last, %\offset + 16
>> >         .elseif \first == \last
>> >         \op\()r x\first, [sp, #\offset]
>> >         .endif
>> > .endm
>> >
>>
>> I'd prefer not to rely on altmacro, for reasons you pointed out
>> yourself a while ago IIRC.
>>
>> I agree your version is more compact, but for a write once thing, I'm
>> not sure if it matters.
>>
>> > Also, I wonder whether it would be more readable at the call site
>> > to specify the first and last reg numbers instead of the reg count,
>> > e.g.:
>> >
>> >         frame_push first_reg=19, last_reg=23
>> >
>> > (or whatever).  Just syntactic sugar though.
>> >
>>
>> Again, this will involve arithmetic on macro arguments, which implies
>> altmacro. Relying on altmacro being set is dodgy, and unfortunately,
>> we can't enable it in the macro without keeping it enabled (or we may
>> disable it on behalf of the caller. I guess we could try to come up
>> with a smart way to infer whether altmacro was enabled, and only
>> disable it afterwards if it wasn't, using some directives that get
>> interpreted differently, but to be honest, I factored out this
>> sequence so I could think about more important things :-)
>
> Sure, no worries.
>
> I've changed my mind a bit about .altmacro, in that it is not really
> usable at all unless turned on explicitly, and then off again, only
> where it's needed.  So if you just assume it's always off, things are
> sane (and that's what happens in practice).
>
> But it's not really needed here -- my main confusion was with the
> deeply nested .ifs, but perhaps that could be avoided more
> straightforwardly:
>
>         .if     \regcount > 1
>         \op\()p x19, x20, [sp, #16]
>         .endif
>         .if     \regcount > 3
>         \op\()p x21, x22, [sp, #32]
>         .endif
>         // ...
>         .if     \regcount > 9
>         \op\()p x27, x28, [sp, #80]
>         .endif
>
>         .if     \regcount == 1
>         \op\()r x19, [sp, #20]
>         .endif
>         .if     \regcount == 3
>         \op\()r x21, [sp, #22]
>         .endif
>         // ...
>         .if     \regcount == 9
>         \op\()r x27, [sp, #28]
>         .endif
>

Yes, that does look better.

>
> One other thing, should you be protecting the macro args with ()?
>
> It seems unlikely that an expression would be passed for regcount,
> but for extra it's a bit more plausible.
>

Good point, given that I subtract \extra from the frame size in the ldp case.

> Cheers
> ---Dave
