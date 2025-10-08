Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63752FDC27
	for <linux-crypto@vger.kernel.org>; Wed,  8 Oct 2025 15:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759938432; cv=none; b=sgaQE6vO5wE2aFr0nSDX6YOBN0uWZR1gILCWd2E4eavAImMokPr141E1NlGajl/Z/XAGvQ4SyZ1tgDOX0HsR7AcWKqFhp5w7VlTNFPHGJUFoiLE651nC4MyQ1ycwUoSWPRZ4mn+uzEB/v2YiB0J1B7dEzvFl8bwsswz9d8HjKbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759938432; c=relaxed/simple;
	bh=dcsoTMvU6BQfqDU8Ebpep4KV5tTYSoNmzT6aKXdDKSo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bZnunxqWEU/jgZS1psGASlglgJURcWwBscZY8rJrMLvGmgjhO3+Yld5KN/7KV5gnf7C01JkVpJd2JOJRhoDDM7pQBXyb0gj8R/jGejncoPZ4MZTiLHJd/wMGNZsE7OtAD8ZvNb/KAXkEHNoJisfI27DIFwvW0MM2LgTH4eZ9iVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3rrIPHws; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3rrIPHws"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3f3c118cbb3so58479f8f.3
        for <linux-crypto@vger.kernel.org>; Wed, 08 Oct 2025 08:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759938429; x=1760543229; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P5EC4bnWWk+Vzr+mFCriKnKa8JCHW95jn5qMkKvnHLI=;
        b=3rrIPHwsNJ4BUIKdC7qAiAwC+0vZ2xAb9dI8iG3MOV5mek8CmAzSYHB1J76PTeC3hS
         ih2zDJM+cX29YJTMWTQqC8cvEapCgFvQsBmE/u/L5lbdop4fIKX+nPmMRkjR2cOBUUi0
         bbHJQstoPTd+Qr/lGN3JwjR/jaj7F+yYgAXXga56Z21oq+BBkEmAHAxwYnPvpxtzJnnK
         c2U+2NEoaUZj6wCogyLODuCjv7p9SBP7qmeTlfk6zucjOzlG2gOsVQybmEKa087SgM64
         sSRvd/wAVizP/5PETwMZMUgUWe+LXKYjYlA7m6Fs6FNKoefjaInkVCJkql2NfgkY0GZv
         WvEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759938429; x=1760543229;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P5EC4bnWWk+Vzr+mFCriKnKa8JCHW95jn5qMkKvnHLI=;
        b=hbf3fPmTDO0K5UugkeBgrGzqD343f1H5vvTHNhSeRLc+bKYl2uDUak4Nw3UUfB9fgP
         bP1AlZuHFM8oZooVR+eOEYJZ4lAWgKQ7u6b2K0gbQrTmvX4spo/FwPrTL5C76GXqsPVr
         Mft8F0yZyqb2LIQgLDVYMptLeR9wp1Vi+fo2Z595vWgxjzor2P85yKRyG2GgxkAm42Yr
         hsITxaKNZChGjU40S/ZjlYwdAQfyWdxlyh3wAJeCSudyUWF7tWllwAl68yO7t27YYlGr
         YCeBU34r7yXppLsYBWFO8EpE2bnn0t+bm/qbVWkkMSx2FG7Up/gQLZNivF9e9g5VuPBD
         wujw==
X-Forwarded-Encrypted: i=1; AJvYcCWDLqLazKtoobuxAyjVYzDS8p+tDwC9TeLNak7iduUTJmq4wslHD0k1HW+uww965+sp3S1HATG8ccIVLb0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwucduAZwYY7q50J1E05GNX5JS+QnkSei+Oym18MmyA864HeWxX
	6msRvf4m6xCk7+Z29fkuwbfBCfuYqP6mfJHhf8q6G7u3Q6l0FdTny1uT/a9K9pvkFPBN1+PvhA=
	=
X-Google-Smtp-Source: AGHT+IFKBOFngZ4tgCIe5stSYpbVjOkdovhSMBx+KSFMPmr5szglET/KMW92mtXFPvgDpIR9UTC1qiLy
X-Received: from wrpb3.prod.google.com ([2002:adf:f243:0:b0:408:941a:35ac])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:186c:b0:3ec:c50c:715b
 with SMTP id ffacd0b85a97d-4266726d746mr2480961f8f.19.1759938428971; Wed, 08
 Oct 2025 08:47:08 -0700 (PDT)
Date: Wed,  8 Oct 2025 17:45:55 +0200
In-Reply-To: <20251008154533.3089255-23-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251008154533.3089255-23-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=8211; i=ardb@kernel.org;
 h=from:subject; bh=qFYb9c8NrpZLi3t0kBZMhSZQnTeMa7rAW/va1fm5iKE=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIeNZe6RrMdOP7WWaXEZtnOWrti149D/yfIGH75Sc8K5pV
 7iPvpHuKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABMJiWP4X7jkwKn7H/dZuW4x
 ODbr7eZbykva9wkk/ljVKvx577T7C/gY/mmdXv3TQeCF1AfldQYdfqv08sQkbmlNt3dnzp139Kh lNhsA
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251008154533.3089255-44-ardb+git@google.com>
Subject: [PATCH v3 21/21] arm64/fpsimd: Allocate kernel mode FP/SIMD buffers
 on the stack
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	herbert@gondor.apana.org.au, ebiggers@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Commit aefbab8e77eb16b5

  ("arm64: fpsimd: Preserve/restore kernel mode NEON at context switch")

added a 'kernel_fpsimd_state' field to struct thread_struct, which is
the arch-specific portion of struct task_struct, and is allocated for
each task in the system. The size of this field is 528 bytes, resulting
in non-negligible bloat of task_struct, and the resulting memory
overhead may impact performance on systems with many processes.

This allocation is only used if the task is scheduled out or interrupted
by a softirq while using the FP/SIMD unit in kernel mode, and so it is
possible to transparently allocate this buffer on the caller's stack
instead.

So tweak the 'ksimd' scoped guard implementation so that a stack buffer
is allocated and passed to both kernel_neon_begin() and
kernel_neon_end(), and either record it in the task struct, or use it
directly to preserve the task mode kernel FP/SIMD when running in
softirq context. Passing the address to both functions, and checking the
addresses for consistency ensures that callers of the updated bare
begin/end API use it in a manner that is consistent with the new context
switch semantics.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/include/asm/fpu.h       |  4 +-
 arch/arm64/include/asm/neon.h      |  4 +-
 arch/arm64/include/asm/processor.h |  2 +-
 arch/arm64/include/asm/simd.h      |  7 +++-
 arch/arm64/kernel/fpsimd.c         | 44 +++++++++++++-------
 5 files changed, 40 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/include/asm/fpu.h b/arch/arm64/include/asm/fpu.h
index 52a1c513bdf3..e252c518de05 100644
--- a/arch/arm64/include/asm/fpu.h
+++ b/arch/arm64/include/asm/fpu.h
@@ -15,12 +15,12 @@ static inline void kernel_fpu_begin(void)
 {
 	BUG_ON(!in_task());
 	preempt_disable();
-	kernel_neon_begin();
+	kernel_neon_begin(NULL);
 }
 
 static inline void kernel_fpu_end(void)
 {
-	kernel_neon_end();
+	kernel_neon_end(NULL);
 	preempt_disable();
 }
 
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
index 61d62bfd5a7b..226e635c53d9 100644
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
index e3f8f51748bc..cab866d52bb7 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1489,21 +1489,23 @@ static void fpsimd_load_kernel_state(struct task_struct *task)
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
@@ -1774,6 +1776,7 @@ void fpsimd_update_current_state(struct user_fpsimd_state const *state)
 void fpsimd_flush_task_state(struct task_struct *t)
 {
 	t->thread.fpsimd_cpu = NR_CPUS;
+	t->thread.kernel_fpsimd_state = NULL;
 	/*
 	 * If we don't support fpsimd, bail out after we have
 	 * reset the fpsimd_cpu for this task and clear the
@@ -1834,7 +1837,7 @@ void fpsimd_save_and_flush_cpu_state(void)
  * The caller may freely use the FPSIMD registers until kernel_neon_end() is
  * called.
  */
-void kernel_neon_begin(void)
+void kernel_neon_begin(struct user_fpsimd_state *state)
 {
 	if (WARN_ON(!system_supports_fpsimd()))
 		return;
@@ -1846,7 +1849,7 @@ void kernel_neon_begin(void)
 	/* Save unsaved fpsimd state, if any: */
 	if (test_thread_flag(TIF_KERNEL_FPSTATE)) {
 		BUG_ON(IS_ENABLED(CONFIG_PREEMPT_RT) || !in_serving_softirq());
-		fpsimd_save_kernel_state(current);
+		fpsimd_save_state(state);
 	} else {
 		fpsimd_save_user_state();
 
@@ -1867,8 +1870,16 @@ void kernel_neon_begin(void)
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
+			WARN_ON(current->thread.kernel_fpsimd_state != NULL);
+			current->thread.kernel_fpsimd_state = state;
 			set_thread_flag(TIF_KERNEL_FPSTATE);
+		}
 	}
 
 	/* Invalidate any task state remaining in the fpsimd regs: */
@@ -1887,21 +1898,26 @@ EXPORT_SYMBOL_GPL(kernel_neon_begin);
  * The caller must not use the FPSIMD registers after this function is called,
  * unless kernel_neon_begin() is called again in the meantime.
  */
-void kernel_neon_end(void)
+void kernel_neon_end(struct user_fpsimd_state *state)
 {
 	if (!system_supports_fpsimd())
 		return;
 
+	if (!test_thread_flag(TIF_KERNEL_FPSTATE))
+		return;
+
 	/*
 	 * If we are returning from a nested use of kernel mode FPSIMD, restore
 	 * the task context kernel mode FPSIMD state. This can only happen when
 	 * running in softirq context on non-PREEMPT_RT.
 	 */
-	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && in_serving_softirq() &&
-	    test_thread_flag(TIF_KERNEL_FPSTATE))
-		fpsimd_load_kernel_state(current);
-	else
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && in_serving_softirq()) {
+		fpsimd_load_state(state);
+	} else {
 		clear_thread_flag(TIF_KERNEL_FPSTATE);
+		WARN_ON(current->thread.kernel_fpsimd_state != state);
+		current->thread.kernel_fpsimd_state = NULL;
+	}
 }
 EXPORT_SYMBOL_GPL(kernel_neon_end);
 
@@ -1937,7 +1953,7 @@ void __efi_fpsimd_begin(void)
 	WARN_ON(preemptible());
 
 	if (may_use_simd()) {
-		kernel_neon_begin();
+		kernel_neon_begin(&efi_fpsimd_state);
 	} else {
 		/*
 		 * If !efi_sve_state, SVE can't be in use yet and doesn't need
@@ -1986,7 +2002,7 @@ void __efi_fpsimd_end(void)
 		return;
 
 	if (!efi_fpsimd_state_used) {
-		kernel_neon_end();
+		kernel_neon_end(&efi_fpsimd_state);
 	} else {
 		if (system_supports_sve() && efi_sve_state_used) {
 			bool ffr = true;
-- 
2.51.0.710.ga91ca5db03-goog

