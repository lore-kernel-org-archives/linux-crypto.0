From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 11/19] arm64: assembler: add macro to conditionally yield the NEON under PREEMPT
Date: Mon,  4 Dec 2017 12:26:37 +0000
Message-ID: <20171204122645.31535-12-ard.biesheuvel@linaro.org>
References: <20171204122645.31535-1-ard.biesheuvel@linaro.org>
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
In-Reply-To: <20171204122645.31535-1-ard.biesheuvel@linaro.org>
Sender: linux-rt-users-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add a support macro to conditionally yield the NEON (and thus the CPU)
that may be called from the assembler code. Given that especially the
instruction based accelerated crypto code may use very tight loops, add
some parametrization so that the TIF_NEED_RESCHED flag test is only
executed every so many loop iterations.

In some cases, yielding the NEON involves saving and restoring a non
trivial amount of context (especially in the CRC folding algorithms),
and so the macro is split into two, and the code in between is only
executed when the yield path is taken, allowing the contex to be preserved.
The second macro takes a label argument that marks the resume-from-yield
path, which should restore the preserved context again.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/assembler.h | 50 ++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index aef72d886677..917b026d3e00 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -512,4 +512,54 @@ alternative_else_nop_endif
 #endif
 	.endm
 
+/*
+ * yield_neon - check whether to yield to another runnable task from
+ *		kernel mode NEON code (running with preemption disabled)
+ *
+ * - Check whether the preempt count is exactly 1, in which case disabling
+ *   preemption once will make the task preemptible. If this is not the case,
+ *   yielding is pointless.
+ * - Check whether TIF_NEED_RESCHED is set, and if so, disable and re-enable
+ *   kernel mode NEON (which will trigger a reschedule), and branch to the
+ *   yield fixup code at @lbl.
+ */
+	.macro		yield_neon, lbl:req, ctr, order, stride, loop
+	yield_neon_pre	\ctr, \order, \stride, \loop
+	yield_neon_post	\lbl
+	.endm
+
+	.macro		yield_neon_pre, ctr, order=0, stride, loop=4444f
+#ifdef CONFIG_PREEMPT
+	/*
+	 * With some algorithms, it makes little sense to poll the
+	 * TIF_NEED_RESCHED flag after every iteration, so only perform
+	 * the check every 2^order strides.
+	 */
+	.if		\order > 1
+	.if		(\stride & (\stride - 1)) != 0
+	.error		"stride should be a power of 2"
+	.endif
+	tst		\ctr, #((1 << \order) * \stride - 1) & ~(\stride - 1)
+	b.ne		\loop
+	.endif
+
+	get_thread_info	x0
+	ldr		w1, [x0, #TSK_TI_PREEMPT]
+	ldr		x0, [x0, #TSK_TI_FLAGS]
+	cmp		w1, #1 // == PREEMPT_OFFSET
+	csel		x0, x0, xzr, eq
+	tbnz		x0, #TIF_NEED_RESCHED, 5555f	// needs rescheduling?
+4444:
+#endif
+	.subsection	1
+5555:
+	.endm
+
+	.macro		yield_neon_post, lbl:req
+	bl		kernel_neon_end
+	bl		kernel_neon_begin
+	b		\lbl
+	.previous
+	.endm
+
 #endif	/* __ASM_ASSEMBLER_H */
-- 
2.11.0

