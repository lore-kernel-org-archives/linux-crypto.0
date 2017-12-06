From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 10/20] arm64: assembler: add utility macros to push/pop stack frames
Date: Wed,  6 Dec 2017 19:43:36 +0000
Message-ID: <20171206194346.24393-11-ard.biesheuvel@linaro.org>
References: <20171206194346.24393-1-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Dave Martin <Dave.Martin@arm.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-rt-users@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
To: linux-crypto@vger.kernel.org
Return-path: <linux-rt-users-owner@vger.kernel.org>
In-Reply-To: <20171206194346.24393-1-ard.biesheuvel@linaro.org>
Sender: linux-rt-users-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

We are going to add code to all the NEON crypto routines that will
turn them into non-leaf functions, so we need to manage the stack
frames. To make this less tedious and error prone, add some macros
that take the number of callee saved registers to preserve and the
extra size to allocate in the stack frame (for locals) and emit
the ldp/stp sequences.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/assembler.h | 60 ++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index aef72d886677..5f61487e9f93 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -499,6 +499,66 @@ alternative_else_nop_endif
 #endif
 	.endm
 
+	/*
+	 * frame_push - Push @regcount callee saved registers to the stack,
+	 *              starting at x19, as well as x29/x30, and set x29 to
+	 *              the new value of sp. Add @extra bytes of stack space
+	 *              for locals.
+	 */
+	.macro		frame_push, regcount:req, extra
+	__frame		st, \regcount, \extra
+	.endm
+
+	/*
+	 * frame_pop  - Pop @regcount callee saved registers from the stack,
+	 *              starting at x19, as well as x29/x30. Also pop @extra
+	 *              bytes of stack space for locals.
+	 */
+	.macro		frame_pop, regcount:req, extra
+	__frame		ld, \regcount, \extra
+	.endm
+
+	.macro		__frame, op, regcount:req, extra=0
+	.ifc		\op, st
+	stp		x29, x30, [sp, #-((\regcount + 3) / 2) * 16 - \extra]!
+	mov		x29, sp
+	.endif
+	.if		\regcount < 0 || \regcount > 10
+	.error		"regcount should be in the range [0 ... 10]"
+	.endif
+	.if		(\extra % 16) != 0
+	.error		"extra should be a multiple of 16 bytes"
+	.endif
+	.if		\regcount > 1
+	\op\()p		x19, x20, [sp, #16]
+	.if		\regcount > 3
+	\op\()p		x21, x22, [sp, #32]
+	.if		\regcount > 5
+	\op\()p		x23, x24, [sp, #48]
+	.if		\regcount > 7
+	\op\()p		x25, x26, [sp, #64]
+	.if		\regcount > 9
+	\op\()p		x27, x28, [sp, #80]
+	.elseif		\regcount == 9
+	\op\()r		x27, [sp, #80]
+	.endif
+	.elseif		\regcount == 7
+	\op\()r		x25, [sp, #64]
+	.endif
+	.elseif		\regcount == 5
+	\op\()r		x23, [sp, #48]
+	.endif
+	.elseif		\regcount == 3
+	\op\()r		x21, [sp, #32]
+	.endif
+	.elseif		\regcount == 1
+	\op\()r		x19, [sp, #16]
+	.endif
+	.ifc		\op, ld
+	ldp		x29, x30, [sp], #((\regcount + 3) / 2) * 16 + \extra
+	.endif
+	.endm
+
 /*
  * Errata workaround post TTBR0_EL1 update.
  */
-- 
2.11.0

