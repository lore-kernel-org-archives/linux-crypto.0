Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E701DE2BB;
	Thu, 20 Feb 2025 05:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740028587; cv=none; b=DmKP7RK2llgK24VXWC7cOL3RtQvt3aKSGXvZETZxOyURZMFGJHFZSndpCyLJnqESLRibo8vjGYl9z9J3X9yfavkw4timo0KUGoCLErjDPTEj3Fm5JFoDAbLd630K0YoN3+M/BQUQYjNjVfTPUIGsz6o/H2EDWYYauhxHiyXqYR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740028587; c=relaxed/simple;
	bh=6H7sVIiu6/eqerK5EnliyZ0frWgaDKVoQ4Ltz40Gkso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V0r23+7HMGUGFtowkyYTLskqvJCZwKJbZK/ILZ3b5K5aAvRQGGwxY07HKvOvX9/mXkLA5BWGOaxJqbeixDhaxFGb7L1v8CqJI+Kw8Y8bEbkMiFNvHyWPfZshrqSxJx0+fT9YlnAOe61O2dpMTQnKv1P7UOVVsdZT0QxL2HvK5BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZcAXzHZq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZcAXzHZq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5BCC4CEDD;
	Thu, 20 Feb 2025 05:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740028587;
	bh=6H7sVIiu6/eqerK5EnliyZ0frWgaDKVoQ4Ltz40Gkso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZcAXzHZqzkuo20yO01fdi1NLszprsFniK5bdntMoHfi0Wnmqi9PCFid9Tijad/7Ig
	 MpX2ePxPfHnVEo0jbYynJQi4UvXzXCcce+i/I6D5sREeSRYfILVj6dwm3Wh3yGbnla
	 UXpm51uz7oA2buj/7w4uzOOmkPmonVe+82eWxXbDo8LKcG5eA2+YfrgqON8Kup9hfM
	 bltH5+nhEIDvkvZA5qdSWdkC9MdlWi1RBxnmSkRUpRT0nhbcxuhqmGaSa9xdIoF2uA
	 KgmgKPAPyAh14iAI54AssOyVdSGtmml1iCrLd5tx93UlwcgOO8KkoMZLsgHdd2P7Td
	 U1bybVHBf6+yQ==
From: Eric Biggers <ebiggers@kernel.org>
To: x86@kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Xiao Liang <shaw.leon@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: [RFC PATCH 1/2] x86/fpu: make kernel-mode FPU reliably usable in softirqs
Date: Wed, 19 Feb 2025 21:13:24 -0800
Message-ID: <20250220051325.340691-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250220051325.340691-1-ebiggers@kernel.org>
References: <20250220051325.340691-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Currently kernel-mode FPU is not always usable in softirq context on
x86, since softirqs can nest inside a kernel-mode FPU section in task
context, and nested use of kernel-mode FPU is not supported.

Therefore, x86 SIMD-optimized code that can be called in softirq context
has to sometimes fall back to non-SIMD code.  There are two options for
the fallback, both of which are pretty terrible:

  (a) Use a scalar fallback.  This can be 10-100x slower than vectorized
      code because it cannot use specialized instructions like AES, SHA,
      or carryless multiplication.

  (b) Execute the request asynchronously using a kworker.  In other
      words, use the "crypto SIMD helper" in crypto/simd.c.

Currently most of the x86 en/decryption code (skcipher and aead
algorithms) uses option (b), since this avoids the slow scalar fallback
and it is easier to wire up.  But option (b) is still really bad for its
own reasons:

  - Punting the request to a kworker is bad for performance too.

  - It forces the algorithm to be marked as asynchronous
    (CRYPTO_ALG_ASYNC), preventing it from being used by crypto API
    users who request a synchronous algorithm.  That's another huge
    performance problem, which is especially unfortunate for users who
    don't even do en/decryption in softirq context.

  - It makes all en/decryption operations take a detour through
    crypto/simd.c.  That involves additional checks and an additional
    indirect call, which slow down en/decryption for *everyone*.

Fortunately, the skcipher and aead APIs are only usable in task and
softirq context in the first place, nor is it supported to call them
with hardirqs disabled.  Thus, if kernel-mode FPU were to be reliably
usable in softirq context, no fallback would be needed.  Indeed, other
architectures such as arm, arm64, and riscv have already done this.

Therefore, this patch updates x86 accordingly to reliably support
kernel-mode FPU in softirqs (except when hardirqs are disabled).

This is done by just disabling softirq processing in kernel-mode FPU
sections, as that prevents the nesting that was problematic.

This will delay some softirqs slightly, but only ones that would have
otherwise been nested inside a task context kernel-mode FPU section.
Any such softirqs would have taken the slow fallback path before if they
tried to do any en/decryption.  Now these softirqs will just run at the
end of the task context kernel-mode FPU section (since local_bh_enable()
runs pending softirqs) and will no longer take the slow fallback path.

To comply with the requirements of local_bh_disable and local_bh_enable,
this change also removes support for kernel-mode FPU in hardirq context
or with hardirqs disabled.  This should not be a problem, though.  There
does not appear to be any use case for kernel-mode FPU in such contexts,
and notably arm64 and riscv already have these same conditions.

Alternatives considered:

- Make kernel-mode FPU sections fully preemptible.  This would require
  growing task_struct by another struct fpstate which is more than 2K.

- Make softirqs save/restore the kernel-mode FPU state to a per-CPU
  struct fpstate when nested use is detected.  Somewhat interesting, but
  seems unnecessary when a simpler solution exists.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/include/asm/fpu/api.h | 17 +++++++---------
 arch/x86/kernel/fpu/core.c     | 37 +++++++++++-----------------------
 2 files changed, 19 insertions(+), 35 deletions(-)

diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
index f86ad3335529d..f42de5f05e7eb 100644
--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -14,14 +14,13 @@
 
 #include <asm/fpu/types.h>
 
 /*
  * Use kernel_fpu_begin/end() if you intend to use FPU in kernel context. It
- * disables preemption so be careful if you intend to use it for long periods
- * of time.
- * If you intend to use the FPU in irq/softirq you need to check first with
- * irq_fpu_usable() if it is possible.
+ * disables preemption and softirq processing, so be careful if you intend to
+ * use it for long periods of time.  Kernel-mode FPU cannot be used in all
+ * contexts -- see irq_fpu_usable() for details.
  */
 
 /* Kernel FPU states to initialize in kernel_fpu_begin_mask() */
 #define KFPU_387	_BITUL(0)	/* 387 state will be initialized */
 #define KFPU_MXCSR	_BITUL(1)	/* MXCSR will be initialized */
@@ -48,25 +47,23 @@ static inline void kernel_fpu_begin(void)
 	kernel_fpu_begin_mask(KFPU_387 | KFPU_MXCSR);
 #endif
 }
 
 /*
- * Use fpregs_lock() while editing CPU's FPU registers or fpu->fpstate.
- * A context switch will (and softirq might) save CPU's FPU registers to
- * fpu->fpstate.regs and set TIF_NEED_FPU_LOAD leaving CPU's FPU registers in
- * a random state.
+ * Use fpregs_lock() while editing CPU's FPU registers or fpu->fpstate, or while
+ * using the FPU in kernel mode.  A context switch will (and softirq might) save
+ * CPU's FPU registers to fpu->fpstate.regs and set TIF_NEED_FPU_LOAD leaving
+ * CPU's FPU registers in a random state.
  *
  * local_bh_disable() protects against both preemption and soft interrupts
  * on !RT kernels.
  *
  * On RT kernels local_bh_disable() is not sufficient because it only
  * serializes soft interrupt related sections via a local lock, but stays
  * preemptible. Disabling preemption is the right choice here as bottom
  * half processing is always in thread context on RT kernels so it
  * implicitly prevents bottom half processing as well.
- *
- * Disabling preemption also serializes against kernel_fpu_begin().
  */
 static inline void fpregs_lock(void)
 {
 	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
 		local_bh_disable();
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 1209c7aebb211..0f7268452bf20 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -55,35 +55,22 @@ DEFINE_PER_CPU(struct fpu *, fpu_fpregs_owner_ctx);
  * Can we use the FPU in kernel mode with the
  * whole "kernel_fpu_begin/end()" sequence?
  */
 bool irq_fpu_usable(void)
 {
-	if (WARN_ON_ONCE(in_nmi()))
-		return false;
-
-	/* In kernel FPU usage already active? */
-	if (this_cpu_read(in_kernel_fpu))
-		return false;
-
 	/*
-	 * When not in NMI or hard interrupt context, FPU can be used in:
-	 *
-	 * - Task context except from within fpregs_lock()'ed critical
-	 *   regions.
-	 *
-	 * - Soft interrupt processing context which cannot happen
-	 *   while in a fpregs_lock()'ed critical region.
+	 * kernel_fpu_begin() takes fpregs_lock(), which disables preemption and
+	 * softirq processing.  That prevents any other task or softirq from
+	 * trying to use the FPU.  Therefore, kernel-mode FPU can always be used
+	 * in task and softirq context, except when hardirqs are disabled which
+	 * is not compatible with disabling and enabling softirq processing, or
+	 * when kernel-mode FPU is explicitly nested (which should never
+	 * happen).  Disabling/enabling softirq processing is also not allowed
+	 * in hardirq context.  Thus, we get the following condition.
 	 */
-	if (!in_hardirq())
-		return true;
-
-	/*
-	 * In hard interrupt context it's safe when soft interrupts
-	 * are enabled, which means the interrupt did not hit in
-	 * a fpregs_lock()'ed critical region.
-	 */
-	return !softirq_count();
+	return !this_cpu_read(in_kernel_fpu) &&
+		!in_hardirq() && !irqs_disabled() && !in_nmi();
 }
 EXPORT_SYMBOL(irq_fpu_usable);
 
 /*
  * Track AVX512 state use because it is known to slow the max clock
@@ -418,11 +405,11 @@ int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf,
 EXPORT_SYMBOL_GPL(fpu_copy_uabi_to_guest_fpstate);
 #endif /* CONFIG_KVM */
 
 void kernel_fpu_begin_mask(unsigned int kfpu_mask)
 {
-	preempt_disable();
+	fpregs_lock();
 
 	WARN_ON_FPU(!irq_fpu_usable());
 	WARN_ON_FPU(this_cpu_read(in_kernel_fpu));
 
 	this_cpu_write(in_kernel_fpu, true);
@@ -446,11 +433,11 @@ EXPORT_SYMBOL_GPL(kernel_fpu_begin_mask);
 void kernel_fpu_end(void)
 {
 	WARN_ON_FPU(!this_cpu_read(in_kernel_fpu));
 
 	this_cpu_write(in_kernel_fpu, false);
-	preempt_enable();
+	fpregs_unlock();
 }
 EXPORT_SYMBOL_GPL(kernel_fpu_end);
 
 /*
  * Sync the FPU register state to current's memory register state when the

base-commit: 0ad2507d5d93f39619fc42372c347d6006b64319
prerequisite-patch-id: ec1feea7e6f4d03e4e4c64c492197b89c957611a
-- 
2.48.1

