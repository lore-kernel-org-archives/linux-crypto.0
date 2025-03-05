Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98791D88B4;
	Wed,  5 Mar 2025 20:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741206620; cv=none; b=Di32TUwBMJzAkSiXGW4taA7r0XJB4EMFlk6Iq1J9oulxGlWX9TmJqsTtI/QMPGw7lm008V8yRFW6JyYE6ykQs2NcwIh6tHdmQmtUEeYTYb50tZgVClC9NACpeFKbUKBHTiCtxltFonqUOUq+QCb4dPGMZB38GFatS5IG2vRb68Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741206620; c=relaxed/simple;
	bh=GbhzyluVu633CKrXby+h6BUEFw6bxcHR/enWjNtEtnc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rz4yrYoy7NY/W0Ize5tamwCQn8MPeYMqjEfGue1EG0kwU8KDq7MFDdkNcvuPqmcFieoxO0y6wQM6eRcVsn3s4MQniYzyjD4E/E4yKvs7qqblYEd2atCQvX4XkTnZsiBg6x7vdq7fELtjMv3xfYT0kNtkXuqBKiYaPOuKq93cZdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XqGxMnv2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XqGxMnv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA36C4CED1;
	Wed,  5 Mar 2025 20:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741206620;
	bh=GbhzyluVu633CKrXby+h6BUEFw6bxcHR/enWjNtEtnc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XqGxMnv2A8nPgiu+BofQN/uHdf3S2S6dxg9lXmhlJn6z9FGje3Uqc8t+JJCfAMyIh
	 uUdqz1aqKCS8DwP+p+ObIlvSx2N3MbKepiLv8ezu3CCj1vFrvVzWqgySGwM6spH5iP
	 yJGMVN0RGKCG7zm7XAjD9c6ckMcbqF65bkSuZaGF0sES3fsfv4kSVCtZOKr1DdFIlW
	 hTwz/new8iXjtcOyTXpVvaqbb3VVRXH25A6TumI3aPajz60zBOHLr//uweXrJEGH5f
	 rcU1i8Zwu3CqXE260Ry7iMSw2U1FCUKbitCrY8/lqMgEmOJPVbDNwrF5Fh0JvmoJi0
	 00s5av0FyP9qw==
Date: Wed, 5 Mar 2025 12:30:18 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: x86@kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Xiao Liang <shaw.leon@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH v2] x86/fpu: make kernel-mode FPU reliably usable in
 softirqs
Message-ID: <20250305203018.GB19889@sol.localdomain>
References: <20250304204954.3901-1-ebiggers@kernel.org>
 <Z8gUYamgBr4M5ZaB@gmail.com>
 <20250305173925.GA4014401@google.com>
 <Z8iTSzfzrFLv-JBL@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8iTSzfzrFLv-JBL@gmail.com>

On Wed, Mar 05, 2025 at 07:09:15PM +0100, Ingo Molnar wrote:
> 
> * Eric Biggers <ebiggers@kernel.org> wrote:
> 
> > [...] To avoid irqs_disabled() entirely, we'd need to avoid disabling 
> > softirqs, which would mean supporting nested kernel-mode FPU in 
> > softirqs.  I can sent out a patch that does that using a per-CPU 
> > buffer, if you'd like to see that.  I wasn't super happy with the 
> > extra edge cases and memory usage, but we could go in that direction.
> 
> Meh: so I just checked, and local_bh_disable()/enable() are pretty 
> heavy these days - it's not just a simple preempt-count twiddle and a 
> check anymore. :-/ I don't think my initial argument of irqs_disabled() 
> overhead is really valid - and if we really cared we could halve it by 
> saving the irqs_disabled() status at kernel_fpu_begin() time and 
> reading it at kernel_fpu_end() time.
> 
> And the alternative of having nested FPU usage and extra per-CPU FPU 
> save areas for the kernel feels a bit fragile, even without having seen 
> the patch.
> 
> So I think I'll commit your patch to tip:x86/fpu as-is, unless someone 
> objects.
> 
> 
> BTW., a side note, I was also reviewing the kernel_fpu_begin()/end() 
> codepaths, and we have gems like:
> 
>         /* Put sane initial values into the control registers. */
>         if (likely(kfpu_mask & KFPU_MXCSR) && boot_cpu_has(X86_FEATURE_XMM))
>                 ldmxcsr(MXCSR_DEFAULT);
> 
>         if (unlikely(kfpu_mask & KFPU_387) && boot_cpu_has(X86_FEATURE_FPU))
>                 asm volatile ("fninit");
> 
> has the LDMXCSR instruction, or its effects, ever shown up in profiles?
> 
> Because AFAICS these will execute all the time on x86-64, because:
> 
> static inline void kernel_fpu_begin(void)
> {
> #ifdef CONFIG_X86_64
>         /*
>          * Any 64-bit code that uses 387 instructions must explicitly request
>          * KFPU_387.
>          */
>         kernel_fpu_begin_mask(KFPU_MXCSR);
> 
> And X86_FEATURE_XMM is set in pretty much every x86 CPU.

I did some benchmarks with AES-XTS encryption of 16-byte messages (which is
unrealistically small, but this makes it easier to see the overhead of
kernel-mode FPU...).  The baseline was 384 MB/s.  Removing the use of
crypto/simd.c, which this work makes possible, increases it to 487 MB/s.  v1 of
this patch decreases it to 479 MB/s, and v2 (which added irqs_disabled() checks
to kernel_fpu_begin() and kernel_fpu_end()) decreases it to 461 MB/s.  An
experimental patch that I have that supports nested kernel-mode FPU in softirqs
by using per-CPU areas maintains 480 MB/s.

CPU was AMD Ryzen 9 9950X (Zen 5).  No debugging options were enabled.

Deleting the ldmxcsr(MXCSR_DEFAULT) adds about 14 MB/s.

But given the large improvement from no longer using crypto/simd.c, the other
overheads seem much smaller and maybe are not worth worrying too much about.

In case you're interested, the following is my experimental patch for supporting
nested use in softirqs:

diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
index f86ad3335529..70729d2bd64f 100644
--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -16,11 +16,11 @@
 
 /*
  * Use kernel_fpu_begin/end() if you intend to use FPU in kernel context. It
  * disables preemption so be careful if you intend to use it for long periods
  * of time.
- * If you intend to use the FPU in irq/softirq you need to check first with
+ * If you intend to use the FPU in hardirq you need to check first with
  * irq_fpu_usable() if it is possible.
  */
 
 /* Kernel FPU states to initialize in kernel_fpu_begin_mask() */
 #define KFPU_387	_BITUL(0)	/* 387 state will be initialized */
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 1209c7aebb21..a524260a0fa6 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -42,11 +42,13 @@ struct fpu_state_config fpu_user_cfg __ro_after_init;
  * depending on the FPU hardware format:
  */
 struct fpstate init_fpstate __ro_after_init;
 
 /* Track in-kernel FPU usage */
-static DEFINE_PER_CPU(bool, in_kernel_fpu);
+static DEFINE_PER_CPU(unsigned int, kernel_fpu_depth);
+
+DEFINE_PER_CPU(struct fpstate *, saved_kernel_fpstate);
 
 /*
  * Track which context is using the FPU on the CPU:
  */
 DEFINE_PER_CPU(struct fpu *, fpu_fpregs_owner_ctx);
@@ -58,14 +60,10 @@ DEFINE_PER_CPU(struct fpu *, fpu_fpregs_owner_ctx);
 bool irq_fpu_usable(void)
 {
 	if (WARN_ON_ONCE(in_nmi()))
 		return false;
 
-	/* In kernel FPU usage already active? */
-	if (this_cpu_read(in_kernel_fpu))
-		return false;
-
 	/*
 	 * When not in NMI or hard interrupt context, FPU can be used in:
 	 *
 	 * - Task context except from within fpregs_lock()'ed critical
 	 *   regions.
@@ -75,13 +73,14 @@ bool irq_fpu_usable(void)
 	 */
 	if (!in_hardirq())
 		return true;
 
 	/*
-	 * In hard interrupt context it's safe when soft interrupts
-	 * are enabled, which means the interrupt did not hit in
-	 * a fpregs_lock()'ed critical region.
+	 * In hard interrupt context it's safe when soft interrupts are enabled,
+	 * which means the interrupt did not hit in a fpregs_lock()'ed critical
+	 * region, nor did it hit while serving a softirq (which could have
+	 * already been using nested kernel-mode FPU).
 	 */
 	return !softirq_count();
 }
 EXPORT_SYMBOL(irq_fpu_usable);
 
@@ -96,10 +95,34 @@ static void update_avx_timestamp(struct fpu *fpu)
 
 	if (fpu->fpstate->regs.xsave.header.xfeatures & AVX512_TRACKING_MASK)
 		fpu->avx512_timestamp = jiffies;
 }
 
+static __always_inline void
+__save_fpregs_to_fpstate(struct fpstate *fpstate,
+			 struct fpu *fpu, bool have_fpu)
+{
+	if (likely(use_xsave())) {
+		os_xsave(fpstate);
+		if (have_fpu)
+			update_avx_timestamp(fpu);
+		return;
+	}
+
+	if (likely(use_fxsr())) {
+		fxsave(&fpstate->regs.fxsave);
+		return;
+	}
+
+	/*
+	 * Legacy FPU register saving, FNSAVE always clears FPU registers,
+	 * so we have to reload them from the memory state.
+	 */
+	asm volatile("fnsave %[fp]; fwait" : [fp] "=m" (fpstate->regs.fsave));
+	frstor(&fpstate->regs.fsave);
+}
+
 /*
  * Save the FPU register state in fpu->fpstate->regs. The register state is
  * preserved.
  *
  * Must be called with fpregs_lock() held.
@@ -112,27 +135,11 @@ static void update_avx_timestamp(struct fpu *fpu)
  *
  * FXSAVE and all XSAVE variants preserve the FPU register state.
  */
 void save_fpregs_to_fpstate(struct fpu *fpu)
 {
-	if (likely(use_xsave())) {
-		os_xsave(fpu->fpstate);
-		update_avx_timestamp(fpu);
-		return;
-	}
-
-	if (likely(use_fxsr())) {
-		fxsave(&fpu->fpstate->regs.fxsave);
-		return;
-	}
-
-	/*
-	 * Legacy FPU register saving, FNSAVE always clears FPU registers,
-	 * so we have to reload them from the memory state.
-	 */
-	asm volatile("fnsave %[fp]; fwait" : [fp] "=m" (fpu->fpstate->regs.fsave));
-	frstor(&fpu->fpstate->regs.fsave);
+	__save_fpregs_to_fpstate(fpu->fpstate, fpu, true);
 }
 
 void restore_fpregs_from_fpstate(struct fpstate *fpstate, u64 mask)
 {
 	/*
@@ -418,23 +425,31 @@ int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf,
 EXPORT_SYMBOL_GPL(fpu_copy_uabi_to_guest_fpstate);
 #endif /* CONFIG_KVM */
 
 void kernel_fpu_begin_mask(unsigned int kfpu_mask)
 {
+	unsigned int prev_depth;
+
 	preempt_disable();
 
 	WARN_ON_FPU(!irq_fpu_usable());
-	WARN_ON_FPU(this_cpu_read(in_kernel_fpu));
-
-	this_cpu_write(in_kernel_fpu, true);
-
-	if (!(current->flags & (PF_KTHREAD | PF_USER_WORKER)) &&
-	    !test_thread_flag(TIF_NEED_FPU_LOAD)) {
-		set_thread_flag(TIF_NEED_FPU_LOAD);
-		save_fpregs_to_fpstate(&current->thread.fpu);
+	prev_depth = __this_cpu_read(kernel_fpu_depth);
+	__this_cpu_write(kernel_fpu_depth, prev_depth + 1);
+
+	if (prev_depth != 0) {
+		WARN_ON_FPU(in_task());
+		WARN_ON_FPU(prev_depth != 1);
+		__save_fpregs_to_fpstate(__this_cpu_read(saved_kernel_fpstate),
+					 NULL, false);
+	} else {
+		if (!(current->flags & (PF_KTHREAD | PF_USER_WORKER)) &&
+		    !test_thread_flag(TIF_NEED_FPU_LOAD)) {
+			set_thread_flag(TIF_NEED_FPU_LOAD);
+			save_fpregs_to_fpstate(&current->thread.fpu);
+		}
+		__cpu_invalidate_fpregs_state();
 	}
-	__cpu_invalidate_fpregs_state();
 
 	/* Put sane initial values into the control registers. */
 	if (likely(kfpu_mask & KFPU_MXCSR) && boot_cpu_has(X86_FEATURE_XMM))
 		ldmxcsr(MXCSR_DEFAULT);
 
@@ -443,13 +458,18 @@ void kernel_fpu_begin_mask(unsigned int kfpu_mask)
 }
 EXPORT_SYMBOL_GPL(kernel_fpu_begin_mask);
 
 void kernel_fpu_end(void)
 {
-	WARN_ON_FPU(!this_cpu_read(in_kernel_fpu));
+	unsigned int depth = __this_cpu_read(kernel_fpu_depth);
 
-	this_cpu_write(in_kernel_fpu, false);
+	if (depth > 1)
+		restore_fpregs_from_fpstate(__this_cpu_read(saved_kernel_fpstate),
+					    XFEATURE_MASK_FPSTATE);
+	else if (WARN_ON_ONCE(depth == 0))
+		depth = 1;
+	__this_cpu_write(kernel_fpu_depth, depth - 1);
 	preempt_enable();
 }
 EXPORT_SYMBOL_GPL(kernel_fpu_end);
 
 /*
@@ -468,19 +488,10 @@ void fpu_sync_fpstate(struct fpu *fpu)
 
 	trace_x86_fpu_after_save(fpu);
 	fpregs_unlock();
 }
 
-static inline unsigned int init_fpstate_copy_size(void)
-{
-	if (!use_xsave())
-		return fpu_kernel_cfg.default_size;
-
-	/* XSAVE(S) just needs the legacy and the xstate header part */
-	return sizeof(init_fpstate.regs.xsave);
-}
-
 static inline void fpstate_init_fxstate(struct fpstate *fpstate)
 {
 	fpstate->regs.fxsave.cwd = 0x37f;
 	fpstate->regs.fxsave.mxcsr = MXCSR_DEFAULT;
 }
diff --git a/arch/x86/kernel/fpu/init.c b/arch/x86/kernel/fpu/init.c
index 998a08f17e33..549852552f51 100644
--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -7,10 +7,11 @@
 #include <asm/setup.h>
 
 #include <linux/sched.h>
 #include <linux/sched/task.h>
 #include <linux/init.h>
+#include <linux/slab.h>
 
 #include "internal.h"
 #include "legacy.h"
 #include "xstate.h"
 
@@ -205,10 +206,35 @@ static void __init fpu__init_system_xstate_size_legacy(void)
 	fpu_user_cfg.max_size = size;
 	fpu_user_cfg.default_size = size;
 	fpstate_reset(&current->thread.fpu);
 }
 
+/*
+ * Allocate per-CPU areas for saving the kernel-mode FPU registers.  This is
+ * needed to reliably support use of kernel-mode FPU in softirqs:
+ */
+static void __init fpu__init_saved_kernel_fpstates(void)
+{
+	size_t size;
+	void *p;
+	struct fpstate *fpstate;
+	int cpu;
+
+	size = arch_task_struct_size;
+	size -= offsetof(struct task_struct, thread.fpu.__fpstate);
+	size += (__alignof__(struct fpstate) - 1) & ~(ARCH_KMALLOC_MINALIGN - 1);
+	for_each_possible_cpu(cpu) {
+		p = kmalloc(size, GFP_KERNEL);
+		if (!p)
+			panic("Out of memory");
+		fpstate = PTR_ALIGN(p, __alignof__(struct fpstate));
+		memcpy(&fpstate->regs, &init_fpstate.regs,
+		       init_fpstate_copy_size());
+		per_cpu(saved_kernel_fpstate, cpu) = fpstate;
+	}
+}
+
 /*
  * Called on the boot CPU once per system bootup, to set up the initial
  * FPU state that is later cloned into all processes:
  */
 void __init fpu__init_system(void)
@@ -224,6 +250,7 @@ void __init fpu__init_system(void)
 
 	fpu__init_system_generic();
 	fpu__init_system_xstate_size_legacy();
 	fpu__init_system_xstate(fpu_kernel_cfg.max_size);
 	fpu__init_task_struct_size();
+	fpu__init_saved_kernel_fpstates();
 }
diff --git a/arch/x86/kernel/fpu/internal.h b/arch/x86/kernel/fpu/internal.h
index dbdb31f55fc7..24f5f6d238b9 100644
--- a/arch/x86/kernel/fpu/internal.h
+++ b/arch/x86/kernel/fpu/internal.h
@@ -23,6 +23,17 @@ static __always_inline __pure bool use_fxsr(void)
 
 /* Used in init.c */
 extern void fpstate_init_user(struct fpstate *fpstate);
 extern void fpstate_reset(struct fpu *fpu);
 
+DECLARE_PER_CPU(struct fpstate *, saved_kernel_fpstate);
+
+static inline unsigned int init_fpstate_copy_size(void)
+{
+	if (!use_xsave())
+		return fpu_kernel_cfg.default_size;
+
+	/* XSAVE(S) just needs the legacy and the xstate header part */
+	return sizeof(init_fpstate.regs.xsave);
+}
+
 #endif
