Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30876313543
	for <linux-crypto@vger.kernel.org>; Wed,  1 Oct 2025 21:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759352658; cv=none; b=Ust1qvCZJvNj5RY1yd3XDSXtKZ4T0VD9MgrZYszDI4XG6e3VLyG6/Rmj6bOvBDgmjA3G2V+bhlcW+d0nYmNTWxsyAwrA+TZ/avUpCe44sLuMCjpId6hOxKZ9bN4OGh3ph2LbqeUAAEEtEbkhAJRNYxKjrS1nGkRE4+XJ7H5b+VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759352658; c=relaxed/simple;
	bh=NrkKCf7Vf8E5XPoueeWIQqRDMvrxqVXoVSGlKLkPssM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eIfAEKDJUJo/NP7afjX3HcLetnML8gNvB2e+L1hr8HDn6L6wQXcGOtCuBtAM3s6uX9lWrB+6wHbaCqmgFsoUSZz+Nb+G/WE6I8hSkvVatLQiBNjxIp7iEiFRDF6WRK2A+AAVyWPPwyXibud+tAiXL+9gMFupnIn2e4jHsIQJliY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K9vtyEeP; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K9vtyEeP"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-46e2c11b94cso1060025e9.3
        for <linux-crypto@vger.kernel.org>; Wed, 01 Oct 2025 14:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759352654; x=1759957454; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=x1XNfcXLPxTuycG48FvJ57h34RR7WVga1h96zHJSpsk=;
        b=K9vtyEeP6b+LhqaPIRy3gPlAzw+DEK8+hFVGzJFjV+uXsPeikni2cxgnbo8m9DcO9X
         vejlkAAfFSYm1Xj5dZZj7+/ccZ9jQSseH0ouun2gVX3U/Jidiw7cuZqc32JBdI2dySnB
         ACDFwfGFuxSevLXbvUFgJ6bIXX3w3r3EhKltrB0xtIh3BQPiBOrCYZnIObW2aKSFG+8f
         +AGRb6GA7te/u0oeQhpDK7zdbzPzT4d4CszJdkV7OZEev9LwvK88HaaJCeWMVg+zL7UY
         EtQU/xOTpWzUunkEzgn1Gqz/UiQGHOdQ6EmjZufFzVovXu/6JH4vj5kizjTlq1Js4BPo
         z9pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759352654; x=1759957454;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x1XNfcXLPxTuycG48FvJ57h34RR7WVga1h96zHJSpsk=;
        b=M9MSmbhX2J8JN+Y9pTlX9KNRKYwreUo3GjifvoIrroKM0hbcpWGYyLWt37DVk+GIHe
         dwjSLpaSZjeKLpdUWkvXib6fPgxGomehZcUy9Z75QiHDoOGCTl/kdbCEecKDNQXZlScr
         JX94TjZ0Hk9WxNPOLhRnQiFQVpS4zn5fpbqxVjw3YqHPKfcys2igpPJjBqKF+Dm5Ahyw
         rz1QHnMg/7Ct13G95ro8ufYxqlUgH/YyDoHG6xmoTtUwk9jW7GAVeps4msGAKcl/5Hhd
         to+np9wVm3Iyl0GjNnimEHHpV1Eq7iIlJ1EgaCIDTOxVjQ8/q1joDB2XYOmrKa0sLGt+
         Pv3g==
X-Gm-Message-State: AOJu0YyxYmLXVAr4mp0baPgOXuEYNUlgQWYeBmL7IDLFTn8133ZQl9xr
	jJMS0DXdoDEj4+ddnCwpRCYlq62l0O6VND4+VbwicNKckBkN+j6aWePyldO11TyIHfSbQe3W/w=
	=
X-Google-Smtp-Source: AGHT+IF4pAXl5Kz4VKrEzIr4Pw9yb2GP5tMgq1HmwMabQ5THhboAs0iCENwI8BZUxUuDCIiW3R3H9LbE
X-Received: from wmbh26.prod.google.com ([2002:a05:600c:a11a:b0:45d:cfa4:ce0d])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:45d0:b0:46e:1d8d:cfa2
 with SMTP id 5b1f17b1804b1-46e612bab92mr36541765e9.20.1759352654487; Wed, 01
 Oct 2025 14:04:14 -0700 (PDT)
Date: Wed,  1 Oct 2025 23:02:22 +0200
In-Reply-To: <20251001210201.838686-22-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251001210201.838686-22-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=6908; i=ardb@kernel.org;
 h=from:subject; bh=AKLCnRRN0mrxopEXea8EITSSalYE601b/mp0OMxmCUA=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIePudPllFx24g4Qqp876JueqIbU3bdpm9jenXldn3VCqc
 7xwoXx6RykLgxgXg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZjI/3JGhpfBSQwSSv8eLPfY
 NFdq3fNCmQ7XN/e1mDiza847V+1/8Izhn2WKrPTZCa8PqC/9+8/01/oEz/e2W6NvM6rtUG1RPc+ VwAIA
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251001210201.838686-42-ardb+git@google.com>
Subject: [PATCH v2 20/20] arm64/fpsimd: Allocate kernel mode FP/SIMD buffers
 on the stack
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, linux@armlinux.org.uk, 
	Ard Biesheuvel <ardb@kernel.org>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Brown <broonie@kernel.org>, 
	Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Commit aefbab8e77eb16b5

  ("arm64: fpsimd: Preserve/restore kernel mode NEON at context switch")

added a 'kernel_fpsimd_state' field to struct thread_struct, which is
the arch-specific portion of struct task_struct, and is allocated for
each task in the system. The size of this field is 528 bytes, resulting
in non-trivial bloat of task_struct, and the resulting memory overhead
may impact performance on systems with many processes.

This allocation is only used if the task is scheduled out or interrupted
by a softirq while using the FP/SIMD unit in kernel mode, and so it is
possible to transparently allocate this buffer on the caller's stack
instead.

So tweak the 'ksimd' scoped guard implementation so that a stack buffer
is allocated and passed to both kernel_neon_begin() and
kernel_neon_end(), and record it in the task struct. Passing the address
to both functions, and checking the addresses for consistency ensures
that callers of the updated bare begin/end API use it in a manner that
is consistent with the new context switch semantics.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/include/asm/neon.h      |  4 +--
 arch/arm64/include/asm/processor.h |  2 +-
 arch/arm64/include/asm/simd.h      |  7 ++--
 arch/arm64/kernel/fpsimd.c         | 34 +++++++++++++-------
 4 files changed, 31 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/neon.h b/arch/arm64/include/asm/neon.h
index d4b1d172a79b..acebee4605b5 100644
--- a/arch/arm64/include/asm/neon.h
+++ b/arch/arm64/include/asm/neon.h
@@ -13,7 +13,7 @@
 
 #define cpu_has_neon()		system_supports_fpsimd()
 
-void kernel_neon_begin(void);
-void kernel_neon_end(void);
+void kernel_neon_begin(struct user_fpsimd_state *);
+void kernel_neon_end(struct user_fpsimd_state *);
 
 #endif /* ! __ASM_NEON_H */
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 4f8d677b73ee..93bca4d454d7 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -172,7 +172,7 @@ struct thread_struct {
 	unsigned long		fault_code;	/* ESR_EL1 value */
 	struct debug_info	debug;		/* debugging */
 
-	struct user_fpsimd_state	kernel_fpsimd_state;
+	struct user_fpsimd_state	*kernel_fpsimd_state;
 	unsigned int			kernel_fpsimd_cpu;
 #ifdef CONFIG_ARM64_PTR_AUTH
 	struct ptrauth_keys_user	keys_user;
diff --git a/arch/arm64/include/asm/simd.h b/arch/arm64/include/asm/simd.h
index d9f83c478736..7ddb25df5c98 100644
--- a/arch/arm64/include/asm/simd.h
+++ b/arch/arm64/include/asm/simd.h
@@ -43,8 +43,11 @@ static __must_check inline bool may_use_simd(void) {
 
 #endif /* ! CONFIG_KERNEL_MODE_NEON */
 
-DEFINE_LOCK_GUARD_0(ksimd, kernel_neon_begin(), kernel_neon_end())
+DEFINE_LOCK_GUARD_1(ksimd,
+		    struct user_fpsimd_state,
+		    kernel_neon_begin(_T->lock),
+		    kernel_neon_end(_T->lock))
 
-#define scoped_ksimd()	scoped_guard(ksimd)
+#define scoped_ksimd()	scoped_guard(ksimd, &(struct user_fpsimd_state){})
 
 #endif
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index c37f02d7194e..ea9192a180aa 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1488,21 +1488,23 @@ static void fpsimd_load_kernel_state(struct task_struct *task)
 	 * Elide the load if this CPU holds the most recent kernel mode
 	 * FPSIMD context of the current task.
 	 */
-	if (last->st == &task->thread.kernel_fpsimd_state &&
+	if (last->st == task->thread.kernel_fpsimd_state &&
 	    task->thread.kernel_fpsimd_cpu == smp_processor_id())
 		return;
 
-	fpsimd_load_state(&task->thread.kernel_fpsimd_state);
+	fpsimd_load_state(task->thread.kernel_fpsimd_state);
 }
 
 static void fpsimd_save_kernel_state(struct task_struct *task)
 {
 	struct cpu_fp_state cpu_fp_state = {
-		.st		= &task->thread.kernel_fpsimd_state,
+		.st		= task->thread.kernel_fpsimd_state,
 		.to_save	= FP_STATE_FPSIMD,
 	};
 
-	fpsimd_save_state(&task->thread.kernel_fpsimd_state);
+	BUG_ON(!cpu_fp_state.st);
+
+	fpsimd_save_state(task->thread.kernel_fpsimd_state);
 	fpsimd_bind_state_to_cpu(&cpu_fp_state);
 
 	task->thread.kernel_fpsimd_cpu = smp_processor_id();
@@ -1773,6 +1775,7 @@ void fpsimd_update_current_state(struct user_fpsimd_state const *state)
 void fpsimd_flush_task_state(struct task_struct *t)
 {
 	t->thread.fpsimd_cpu = NR_CPUS;
+	t->thread.kernel_fpsimd_state = NULL;
 	/*
 	 * If we don't support fpsimd, bail out after we have
 	 * reset the fpsimd_cpu for this task and clear the
@@ -1833,7 +1836,7 @@ void fpsimd_save_and_flush_cpu_state(void)
  * The caller may freely use the FPSIMD registers until kernel_neon_end() is
  * called.
  */
-void kernel_neon_begin(void)
+void kernel_neon_begin(struct user_fpsimd_state *s)
 {
 	if (WARN_ON(!system_supports_fpsimd()))
 		return;
@@ -1866,8 +1869,16 @@ void kernel_neon_begin(void)
 		 * mode in task context. So in this case, setting the flag here
 		 * is always appropriate.
 		 */
-		if (IS_ENABLED(CONFIG_PREEMPT_RT) || !in_serving_softirq())
+		if (IS_ENABLED(CONFIG_PREEMPT_RT) || !in_serving_softirq()) {
+			/*
+			 * Record the caller provided buffer as the kernel mode
+			 * FP/SIMD buffer for this task, so that the state can
+			 * be preserved and restored on a context switch.
+			 */
+			if (cmpxchg(&current->thread.kernel_fpsimd_state, NULL, s))
+				BUG();
 			set_thread_flag(TIF_KERNEL_FPSTATE);
+		}
 	}
 
 	/* Invalidate any task state remaining in the fpsimd regs: */
@@ -1886,7 +1897,7 @@ EXPORT_SYMBOL_GPL(kernel_neon_begin);
  * The caller must not use the FPSIMD registers after this function is called,
  * unless kernel_neon_begin() is called again in the meantime.
  */
-void kernel_neon_end(void)
+void kernel_neon_end(struct user_fpsimd_state *s)
 {
 	if (!system_supports_fpsimd())
 		return;
@@ -1899,8 +1910,9 @@ void kernel_neon_end(void)
 	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && in_serving_softirq() &&
 	    test_thread_flag(TIF_KERNEL_FPSTATE))
 		fpsimd_load_kernel_state(current);
-	else
-		clear_thread_flag(TIF_KERNEL_FPSTATE);
+	else if (test_and_clear_thread_flag(TIF_KERNEL_FPSTATE))
+		if (cmpxchg(&current->thread.kernel_fpsimd_state, s, NULL) != s)
+			BUG();
 }
 EXPORT_SYMBOL_GPL(kernel_neon_end);
 
@@ -1936,7 +1948,7 @@ void __efi_fpsimd_begin(void)
 	WARN_ON(preemptible());
 
 	if (may_use_simd()) {
-		kernel_neon_begin();
+		kernel_neon_begin(&efi_fpsimd_state);
 	} else {
 		/*
 		 * If !efi_sve_state, SVE can't be in use yet and doesn't need
@@ -1985,7 +1997,7 @@ void __efi_fpsimd_end(void)
 		return;
 
 	if (!efi_fpsimd_state_used) {
-		kernel_neon_end();
+		kernel_neon_end(&efi_fpsimd_state);
 	} else {
 		if (system_supports_sve() && efi_sve_state_used) {
 			bool ffr = true;
-- 
2.51.0.618.g983fd99d29-goog

