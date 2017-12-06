From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 11/20] arm64: assembler: add macros to conditionally yield the NEON under PREEMPT
Date: Wed,  6 Dec 2017 19:43:37 +0000
Message-ID: <20171206194346.24393-12-ard.biesheuvel@linaro.org>
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

Add support macros to conditionally yield the NEON (and thus the CPU)
that may be called from the assembler code.

In some cases, yielding the NEON involves saving and restoring a non
trivial amount of context (especially in the CRC folding algorithms),
and so the macro is split into three, and the code in between is only
executed when the yield path is taken, allowing the context to be preserved.
The third macro takes an optional label argument that marks the resume
path after a yield has been performed.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/assembler.h | 51 ++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 5f61487e9f93..c54e408fd5a7 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -572,4 +572,55 @@ alternative_else_nop_endif
 #endif
 	.endm
 
+/*
+ * Check whether to yield to another runnable task from kernel mode NEON code
+ * (which runs with preemption disabled).
+ *
+ * if_will_cond_yield_neon
+ *        // pre-yield patchup code
+ * do_cond_yield_neon
+ *        // post-yield patchup code
+ * endif_yield_neon
+ *
+ * - Check whether the preempt count is exactly 1, in which case disabling
+ *   preemption once will make the task preemptible. If this is not the case,
+ *   yielding is pointless.
+ * - Check whether TIF_NEED_RESCHED is set, and if so, disable and re-enable
+ *   kernel mode NEON (which will trigger a reschedule), and branch to the
+ *   yield fixup code.
+ *
+ * This macro sequence clobbers x0, x1 and the flags register unconditionally,
+ * and may clobber x2 .. x18 if the yield path is taken.
+ */
+
+	.macro		cond_yield_neon, lbl
+	if_will_cond_yield_neon
+	do_cond_yield_neon
+	endif_yield_neon	\lbl
+	.endm
+
+	.macro		if_will_cond_yield_neon
+#ifdef CONFIG_PREEMPT
+	get_thread_info	x0
+	ldr		w1, [x0, #TSK_TI_PREEMPT]
+	ldr		x0, [x0, #TSK_TI_FLAGS]
+	cmp		w1, #1 // == PREEMPT_OFFSET
+	csel		x0, x0, xzr, eq
+	tbnz		x0, #TIF_NEED_RESCHED, 5555f	// needs rescheduling?
+#endif
+	.subsection	1
+5555:
+	.endm
+
+	.macro		do_cond_yield_neon
+	bl		kernel_neon_end
+	bl		kernel_neon_begin
+	.endm
+
+	.macro		endif_yield_neon, lbl=6666f
+	b		\lbl
+	.previous
+6666:
+	.endm
+
 #endif	/* __ASM_ASSEMBLER_H */
-- 
2.11.0

