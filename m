From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 11/23] arm64: assembler: add macros to conditionally yield
 the NEON under PREEMPT
Date: Sat, 10 Mar 2018 15:21:56 +0000
Message-ID: <20180310152208.10369-12-ard.biesheuvel@linaro.org>
References: <20180310152208.10369-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Mark Rutland <mark.rutland@arm.com>, herbert@gondor.apana.org.au,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Will Deacon <will.deacon@arm.com>,
 Russell King - ARM Linux <linux@armlinux.org.uk>,
 Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org,
 linux-rt-users@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180310152208.10369-1-ard.biesheuvel@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
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
 arch/arm64/include/asm/assembler.h | 64 ++++++++++++++++++++
 arch/arm64/kernel/asm-offsets.c    |  2 +
 2 files changed, 66 insertions(+)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index eef1fd2c1c0b..61168cbe9781 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -635,4 +635,68 @@ alternative_else_nop_endif
 	.endif
 	.endm
 
+/*
+ * Check whether to yield to another runnable task from kernel mode NEON code
+ * (which runs with preemption disabled).
+ *
+ * if_will_cond_yield_neon
+ *        // pre-yield patchup code
+ * do_cond_yield_neon
+ *        // post-yield patchup code
+ * endif_yield_neon    <label>
+ *
+ * where <label> is optional, and marks the point where execution will resume
+ * after a yield has been performed. If omitted, execution resumes right after
+ * the endif_yield_neon invocation.
+ *
+ * Note that the patchup code does not support assembler directives that change
+ * the output section, any use of such directives is undefined.
+ *
+ * The yield itself consists of the following:
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
+	cmp		w1, #PREEMPT_DISABLE_OFFSET
+	csel		x0, x0, xzr, eq
+	tbnz		x0, #TIF_NEED_RESCHED, .Lyield_\@	// needs rescheduling?
+#endif
+	/* fall through to endif_yield_neon */
+	.subsection	1
+.Lyield_\@ :
+	.endm
+
+	.macro		do_cond_yield_neon
+	bl		kernel_neon_end
+	bl		kernel_neon_begin
+	.endm
+
+	.macro		endif_yield_neon, lbl
+	.ifnb		\lbl
+	b		\lbl
+	.else
+	b		.Lyield_out_\@
+	.endif
+	.previous
+.Lyield_out_\@ :
+	.endm
+
 #endif	/* __ASM_ASSEMBLER_H */
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 1303e04110cd..1e2ea2e51acb 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -93,6 +93,8 @@ int main(void)
   DEFINE(DMA_TO_DEVICE,		DMA_TO_DEVICE);
   DEFINE(DMA_FROM_DEVICE,	DMA_FROM_DEVICE);
   BLANK();
+  DEFINE(PREEMPT_DISABLE_OFFSET, PREEMPT_DISABLE_OFFSET);
+  BLANK();
   DEFINE(CLOCK_REALTIME,	CLOCK_REALTIME);
   DEFINE(CLOCK_MONOTONIC,	CLOCK_MONOTONIC);
   DEFINE(CLOCK_MONOTONIC_RAW,	CLOCK_MONOTONIC_RAW);
-- 
2.15.1
