From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 23/23] DO NOT MERGE
Date: Sat, 10 Mar 2018 15:22:08 +0000
Message-ID: <20180310152208.10369-24-ard.biesheuvel@linaro.org>
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

Test code to force a kernel_neon_end+begin sequence at every yield point,
and wipe the entire NEON state before resuming the algorithm.
---
 arch/arm64/include/asm/assembler.h | 33 ++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 61168cbe9781..b471b0bbdfe6 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -678,6 +678,7 @@ alternative_else_nop_endif
 	cmp		w1, #PREEMPT_DISABLE_OFFSET
 	csel		x0, x0, xzr, eq
 	tbnz		x0, #TIF_NEED_RESCHED, .Lyield_\@	// needs rescheduling?
+	b		.Lyield_\@
 #endif
 	/* fall through to endif_yield_neon */
 	.subsection	1
@@ -687,6 +688,38 @@ alternative_else_nop_endif
 	.macro		do_cond_yield_neon
 	bl		kernel_neon_end
 	bl		kernel_neon_begin
+	movi		v0.16b, #0x55
+	movi		v1.16b, #0x55
+	movi		v2.16b, #0x55
+	movi		v3.16b, #0x55
+	movi		v4.16b, #0x55
+	movi		v5.16b, #0x55
+	movi		v6.16b, #0x55
+	movi		v7.16b, #0x55
+	movi		v8.16b, #0x55
+	movi		v9.16b, #0x55
+	movi		v10.16b, #0x55
+	movi		v11.16b, #0x55
+	movi		v12.16b, #0x55
+	movi		v13.16b, #0x55
+	movi		v14.16b, #0x55
+	movi		v15.16b, #0x55
+	movi		v16.16b, #0x55
+	movi		v17.16b, #0x55
+	movi		v18.16b, #0x55
+	movi		v19.16b, #0x55
+	movi		v20.16b, #0x55
+	movi		v21.16b, #0x55
+	movi		v22.16b, #0x55
+	movi		v23.16b, #0x55
+	movi		v24.16b, #0x55
+	movi		v25.16b, #0x55
+	movi		v26.16b, #0x55
+	movi		v27.16b, #0x55
+	movi		v28.16b, #0x55
+	movi		v29.16b, #0x55
+	movi		v30.16b, #0x55
+	movi		v31.16b, #0x55
 	.endm
 
 	.macro		endif_yield_neon, lbl
-- 
2.15.1
