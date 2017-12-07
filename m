From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v3 10/20] arm64: assembler: add utility macros to
 push/pop stack frames
Date: Thu, 7 Dec 2017 14:11:06 +0000
Message-ID: <20171207141104.GE22781@e103592.cambridge.arm.com>
References: <20171206194346.24393-1-ard.biesheuvel@linaro.org>
 <20171206194346.24393-11-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        herbert@gondor.apana.org.au, Peter Zijlstra <peterz@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        linux-rt-users@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-rt-users-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171206194346.24393-11-ard.biesheuvel@linaro.org>
Sender: linux-rt-users-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Dec 06, 2017 at 07:43:36PM +0000, Ard Biesheuvel wrote:
> We are going to add code to all the NEON crypto routines that will
> turn them into non-leaf functions, so we need to manage the stack
> frames. To make this less tedious and error prone, add some macros
> that take the number of callee saved registers to preserve and the
> extra size to allocate in the stack frame (for locals) and emit
> the ldp/stp sequences.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm64/include/asm/assembler.h | 60 ++++++++++++++++++++
>  1 file changed, 60 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
> index aef72d886677..5f61487e9f93 100644
> --- a/arch/arm64/include/asm/assembler.h
> +++ b/arch/arm64/include/asm/assembler.h
> @@ -499,6 +499,66 @@ alternative_else_nop_endif
>  #endif
>  	.endm
>  
> +	/*
> +	 * frame_push - Push @regcount callee saved registers to the stack,
> +	 *              starting at x19, as well as x29/x30, and set x29 to
> +	 *              the new value of sp. Add @extra bytes of stack space
> +	 *              for locals.
> +	 */
> +	.macro		frame_push, regcount:req, extra
> +	__frame		st, \regcount, \extra
> +	.endm
> +
> +	/*
> +	 * frame_pop  - Pop @regcount callee saved registers from the stack,
> +	 *              starting at x19, as well as x29/x30. Also pop @extra
> +	 *              bytes of stack space for locals.
> +	 */
> +	.macro		frame_pop, regcount:req, extra
> +	__frame		ld, \regcount, \extra
> +	.endm
> +
> +	.macro		__frame, op, regcount:req, extra=0
> +	.ifc		\op, st
> +	stp		x29, x30, [sp, #-((\regcount + 3) / 2) * 16 - \extra]!
> +	mov		x29, sp
> +	.endif
> +	.if		\regcount < 0 || \regcount > 10
> +	.error		"regcount should be in the range [0 ... 10]"
> +	.endif
> +	.if		(\extra % 16) != 0
> +	.error		"extra should be a multiple of 16 bytes"
> +	.endif
> +	.if		\regcount > 1
> +	\op\()p		x19, x20, [sp, #16]
> +	.if		\regcount > 3
> +	\op\()p		x21, x22, [sp, #32]
> +	.if		\regcount > 5
> +	\op\()p		x23, x24, [sp, #48]
> +	.if		\regcount > 7
> +	\op\()p		x25, x26, [sp, #64]
> +	.if		\regcount > 9
> +	\op\()p		x27, x28, [sp, #80]

Can the _for thing I introduced in fpsimdmacros.h be any use here?
Alternatively, the following could replace that .if-slide,
providing the calling macro does .altmacro .. .noaltmacro somewhere.

.macro _pushpop2 op, n1, n2, offset
	\op     x\n1, x\n2, [sp, #\offset]
.endm

.macro _pushpop op, first, last, offset
	.if \first < \last
	_pushpop2 \op\()p, \first, %\first + 1, \offset
	_pushpop \op, %\first + 2, \last, %\offset + 16
	.elseif \first == \last
	\op\()r x\first, [sp, #\offset]
	.endif
.endm

Also, I wonder whether it would be more readable at the call site
to specify the first and last reg numbers instead of the reg count,
e.g.:

	frame_push first_reg=19, last_reg=23

(or whatever).  Just syntactic sugar though.

[...]

Cheers
---Dave
