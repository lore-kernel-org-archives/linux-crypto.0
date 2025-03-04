Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B6C25FA14;
	Tue,  4 Mar 2025 20:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741121491; cv=none; b=lq7AO9FZNiUMMdY0SvZjI0cNpy7AfcgBCvtZwAA1Jz+crbA0eZAWfqck9cq9uv5RDGvDTOJbgbGjHycpxumdQ+XjghGlHgsa3T3mmORhnex+LySBB9bPKMfF96pnVaI+Fro9l/D49Mlhk2+7KKGMN8wo1kFc+7nyeyy7gRuwBBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741121491; c=relaxed/simple;
	bh=zEuJDSdpagweCAj4noxSIPPno5NwiCCQ7YIhPEIpUBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ht3Pl/kVQyb/ApGJ5hJubBmz3Wv7sFeo1NCl866Ut8ex6iMJXkqAYrPwKzXbMDaZVOJD3Wpq0bimucXctYG3hAOv3DsXpcEFUFcrm3/Qy8KZlGZhlkYOgLkxbm1ICy4GfFOgoueUiWSgI00hIHz0DejPvYn/cInVLWExYEUB7P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U2gC63my; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U2gC63my"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1FAC4CEE9;
	Tue,  4 Mar 2025 20:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741121490;
	bh=zEuJDSdpagweCAj4noxSIPPno5NwiCCQ7YIhPEIpUBQ=;
	h=From:To:Cc:Subject:Date:From;
	b=U2gC63myUGZYLS5xD7W1svkHmz81fCSW4LR5miX5cTLQp0UZIGQxSuDHxBRuXvkvT
	 WoTJS+3CM3V3FmemOWYNyjbsZkqmqd8+a1LPUpuSWfkWIJUpQBLlpX3i643MzPdVka
	 dHME1B3ULfngXsg0Cued2tq964veSWIMy6iJ4aXzLIrdkkJmrvJuXlD7fmaYUQa7of
	 yOozumFrP2rNSYc9HO8YrNcF/vplYcyhaE8Ds+J6Rg6YfC/BNTLdxsFsa1LKrUC21U
	 CFDc1o9Yh4SUrDVpdPb7x0UFBsais9a2IU0HgMGoYLE3zVDZx1nCkR3Jyy4rhLbOMG
	 2gY/rCp3lZjLQ==
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
Subject: [RFC PATCH v2] x86/fpu: make kernel-mode FPU reliably usable in softirqs
Date: Tue,  4 Mar 2025 12:49:54 -0800
Message-ID: <20250304204954.3901-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
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
softirq context in the first place.  Thus, if kernel-mode FPU were to be
reliably usable in softirq context, no fallback would be needed.
Indeed, other architectures such as arm, arm64, and riscv have already
done this.

Therefore, this patch updates x86 accordingly to reliably support
kernel-mode FPU in softirqs.

This is done by just disabling softirq processing in kernel-mode FPU
sections (when hardirqs are not already disabled), as that prevents the
nesting that was problematic.

This will delay some softirqs slightly, but only ones that would have
otherwise been nested inside a task context kernel-mode FPU section.
Any such softirqs would have taken the slow fallback path before if they
tried to do any en/decryption.  Now these softirqs will just run at the
end of the task context kernel-mode FPU section (since local_bh_enable()
runs pending softirqs) and will no longer take the slow fallback path.

Alternatives considered:

- Make kernel-mode FPU sections fully preemptible.  This would require
  growing task_struct by another struct fpstate which is more than 2K.

- Make softirqs save/restore the kernel-mode FPU state to a per-CPU
  struct fpstate when nested use is detected.  Somewhat interesting, but
  seems unnecessary when a simpler solution exists.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---

Changed in v2:
    - Retain support for kernel-mode FPU when hardirqs are disabled
      (needed for system suspend and resume)
    - Send the x86 patch as a standalone patch.

 arch/x86/include/asm/fpu/api.h | 17 +++++++----------
 arch/x86/kernel/fpu/core.c     | 17 +++++++++++++----
 2 files changed, 20 insertions(+), 14 deletions(-)

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
index 1209c7aebb211..f937329d1aa9c 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -58,13 +58,20 @@ DEFINE_PER_CPU(struct fpu *, fpu_fpregs_owner_ctx);
 bool irq_fpu_usable(void)
 {
 	if (WARN_ON_ONCE(in_nmi()))
 		return false;
 
-	/* In kernel FPU usage already active? */
-	if (this_cpu_read(in_kernel_fpu))
+	/*
+	 * In kernel FPU usage already active?  This detects any explicitly
+	 * nested usage in task or softirq context, which is unsupported.  It
+	 * also detects attempted usage in a hardirq that has interrupted a
+	 * kernel-mode FPU section.
+	 */
+	if (this_cpu_read(in_kernel_fpu)) {
+		WARN_ON_FPU(!in_hardirq());
 		return false;
+	}
 
 	/*
 	 * When not in NMI or hard interrupt context, FPU can be used in:
 	 *
 	 * - Task context except from within fpregs_lock()'ed critical
@@ -418,11 +425,12 @@ int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf,
 EXPORT_SYMBOL_GPL(fpu_copy_uabi_to_guest_fpstate);
 #endif /* CONFIG_KVM */
 
 void kernel_fpu_begin_mask(unsigned int kfpu_mask)
 {
-	preempt_disable();
+	if (!irqs_disabled())
+		fpregs_lock();
 
 	WARN_ON_FPU(!irq_fpu_usable());
 	WARN_ON_FPU(this_cpu_read(in_kernel_fpu));
 
 	this_cpu_write(in_kernel_fpu, true);
@@ -446,11 +454,12 @@ EXPORT_SYMBOL_GPL(kernel_fpu_begin_mask);
 void kernel_fpu_end(void)
 {
 	WARN_ON_FPU(!this_cpu_read(in_kernel_fpu));
 
 	this_cpu_write(in_kernel_fpu, false);
-	preempt_enable();
+	if (!irqs_disabled())
+		fpregs_unlock();
 }
 EXPORT_SYMBOL_GPL(kernel_fpu_end);
 
 /*
  * Sync the FPU register state to current's memory register state when the

base-commit: 0ad2507d5d93f39619fc42372c347d6006b64319
-- 
2.48.1

