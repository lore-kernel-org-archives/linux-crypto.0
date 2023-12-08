Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0JMNUNOx"
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E08210D8
	for <linux-crypto@vger.kernel.org>; Fri,  8 Dec 2023 03:32:42 -0800 (PST)
Received: by mail-wr1-x44a.google.com with SMTP id ffacd0b85a97d-33340d20b90so1571453f8f.2
        for <linux-crypto@vger.kernel.org>; Fri, 08 Dec 2023 03:32:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702035160; x=1702639960; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jg1jNGMQOGhVtXZCjl80hXnmubgi/Ca9g2iUAVxbP60=;
        b=0JMNUNOxo6cVoPJkB4WKiQXT5eJlqk8i1GHSCOOZ7Jc9eV/G96e58jNknNPvgLMOBq
         rU0Kp0wqeXx9LEfzRKyTEjssmlBhGyx2xvUMjMGjMgvNO1C1guxKPDTycorCkvfsaI0Y
         BD41INYP3fvyNbUtEDrV3MktkXi6ayz+575NUliBn7HDYcz5BlslbB3Fg0kG+n4++NFX
         9AdtweBGdMaBra94cHwAN4O4l2IZSp7vYwdwR3eRkIumAV/DMvmIQgCu1wdfFB6Ml/1f
         oGszMZc/wnq5E4t/uOdHLGw2XfGKheRpyNOHZwYW2G5uld/AoGOxrp2nqMaj0LFcfFOK
         Qo8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702035160; x=1702639960;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jg1jNGMQOGhVtXZCjl80hXnmubgi/Ca9g2iUAVxbP60=;
        b=G9YqrTlD1JT4L3XfDBFV5x6kOGzOoFm2nZW7GqcAvzR041Elx4kLJfNfEe6GJdSN1l
         aoap6YxilMH6E4r/rNXFe4S5NhLzz/siW8hmFqoo21X3i52esqO4MMin91bwdjRQ/2aS
         8GRX3Y3j8/PJGcuA3aW1lxuvEGnPGWhFznUcqbYTUcWmlzc915OSuQat1UZcz3t0s7sp
         C/fhSXWYEUZy+eys0xjYIy0PJ77yw01RSTKFL5vsFjbE3Pd8DkLDUgqvM49jRRIrelE7
         KzeQdS6D0vouv3taeBxhUD+fOMvHqZ+CwO39JvBaMZ1l6Bf4X44v8QEefgkBwJjTsjaM
         Rvow==
X-Gm-Message-State: AOJu0YwExp7skFzS0DiLByBfqIzzir1J70Zddd3z7Zs8rBfGsByeDF3f
	3qeeGmYeO/0Z8NIdU+Ill0Rpkada
X-Google-Smtp-Source: AGHT+IGkH+QxL7r73sTzLHjD0Egz3yIU0KByp6DGplkQ3jrogz8531guXVzVYPh2nijV8KggnCWJpNgB
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:118a])
 (user=ardb job=sendgmr) by 2002:a5d:5d83:0:b0:333:3029:781 with SMTP id
 ci3-20020a5d5d83000000b0033330290781mr25310wrb.3.1702035160680; Fri, 08 Dec
 2023 03:32:40 -0800 (PST)
Date: Fri,  8 Dec 2023 12:32:20 +0100
In-Reply-To: <20231208113218.3001940-6-ardb@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231208113218.3001940-6-ardb@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=7216; i=ardb@kernel.org;
 h=from:subject; bh=vct3jQZrFKs6CxzAxEpfL53Y/+dXQO86TjA7/Z0onS0=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIbXo3xFN09WVi3gj9S8rKIsx7rmyfM4nne2PEo42nDZi6
 FT42iHYUcrCIMbBICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACbidI6RYcKdHzeqjgtvr5QN
 midZ7lWrcWf518ff6ve0RTVd6/768wHDP9XIf0uEv25bOOtUa5L9zdBfpz8HWEn3cFqLmS66oOk fzw4A
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231208113218.3001940-7-ardb@google.com>
Subject: [PATCH v4 1/4] arm64: fpsimd: Drop unneeded 'busy' flag
From: Ard Biesheuvel <ardb@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Kees Cook <keescook@chromium.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Mark Brown <broonie@kernel.org>, Eric Biggers <ebiggers@google.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Kernel mode NEON will preserve the user mode FPSIMD state by saving it
into the task struct before clobbering the registers. In order to avoid
the need for preserving kernel mode state too, we disallow nested use of
kernel mode NEON, i..e, use in softirq context while the interrupted
task context was using kernel mode NEON too.

Originally, this policy was implemented using a per-CPU flag which was
exposed via may_use_simd(), requiring the users of the kernel mode NEON
to deal with the possibility that it might return false, and having NEON
and non-NEON code paths. This policy was changed by commit
13150149aa6ded1 ("arm64: fpsimd: run kernel mode NEON with softirqs
disabled"), and now, softirq processing is disabled entirely instead,
and so may_use_simd() can never fail when called from task or softirq
context.

This means we can drop the fpsimd_context_busy flag entirely, and
instead, ensure that we disable softirq processing in places where we
formerly relied on the flag for preventing races in the FPSIMD preserve
routines.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/simd.h | 11 +---
 arch/arm64/kernel/fpsimd.c    | 53 +++++---------------
 2 files changed, 13 insertions(+), 51 deletions(-)

diff --git a/arch/arm64/include/asm/simd.h b/arch/arm64/include/asm/simd.h
index 6a75d7ecdcaa..8e86c9e70e48 100644
--- a/arch/arm64/include/asm/simd.h
+++ b/arch/arm64/include/asm/simd.h
@@ -12,8 +12,6 @@
 #include <linux/preempt.h>
 #include <linux/types.h>
 
-DECLARE_PER_CPU(bool, fpsimd_context_busy);
-
 #ifdef CONFIG_KERNEL_MODE_NEON
 
 /*
@@ -28,17 +26,10 @@ static __must_check inline bool may_use_simd(void)
 	/*
 	 * We must make sure that the SVE has been initialized properly
 	 * before using the SIMD in kernel.
-	 * fpsimd_context_busy is only set while preemption is disabled,
-	 * and is clear whenever preemption is enabled. Since
-	 * this_cpu_read() is atomic w.r.t. preemption, fpsimd_context_busy
-	 * cannot change under our feet -- if it's set we cannot be
-	 * migrated, and if it's clear we cannot be migrated to a CPU
-	 * where it is set.
 	 */
 	return !WARN_ON(!system_capabilities_finalized()) &&
 	       system_supports_fpsimd() &&
-	       !in_hardirq() && !irqs_disabled() && !in_nmi() &&
-	       !this_cpu_read(fpsimd_context_busy);
+	       !in_hardirq() && !irqs_disabled() && !in_nmi();
 }
 
 #else /* ! CONFIG_KERNEL_MODE_NEON */
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 1559c706d32d..ccc4a78a70e4 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -85,13 +85,13 @@
  * softirq kicks in. Upon vcpu_put(), KVM will save the vcpu FP state and
  * flag the register state as invalid.
  *
- * In order to allow softirq handlers to use FPSIMD, kernel_neon_begin() may
- * save the task's FPSIMD context back to task_struct from softirq context.
- * To prevent this from racing with the manipulation of the task's FPSIMD state
- * from task context and thereby corrupting the state, it is necessary to
- * protect any manipulation of a task's fpsimd_state or TIF_FOREIGN_FPSTATE
- * flag with {, __}get_cpu_fpsimd_context(). This will still allow softirqs to
- * run but prevent them to use FPSIMD.
+ * In order to allow softirq handlers to use FPSIMD, kernel_neon_begin() may be
+ * called from softirq context, which will save the task's FPSIMD context back
+ * to task_struct. To prevent this from racing with the manipulation of the
+ * task's FPSIMD state from task context and thereby corrupting the state, it
+ * is necessary to protect any manipulation of a task's fpsimd_state or
+ * TIF_FOREIGN_FPSTATE flag with get_cpu_fpsimd_context(), which will suspend
+ * softirq servicing entirely until put_cpu_fpsimd_context() is called.
  *
  * For a certain task, the sequence may look something like this:
  * - the task gets scheduled in; if both the task's fpsimd_cpu field
@@ -209,27 +209,14 @@ static inline void sme_free(struct task_struct *t) { }
 
 #endif
 
-DEFINE_PER_CPU(bool, fpsimd_context_busy);
-EXPORT_PER_CPU_SYMBOL(fpsimd_context_busy);
-
 static void fpsimd_bind_task_to_cpu(void);
 
-static void __get_cpu_fpsimd_context(void)
-{
-	bool busy = __this_cpu_xchg(fpsimd_context_busy, true);
-
-	WARN_ON(busy);
-}
-
 /*
  * Claim ownership of the CPU FPSIMD context for use by the calling context.
  *
  * The caller may freely manipulate the FPSIMD context metadata until
  * put_cpu_fpsimd_context() is called.
  *
- * The double-underscore version must only be called if you know the task
- * can't be preempted.
- *
  * On RT kernels local_bh_disable() is not sufficient because it only
  * serializes soft interrupt related sections via a local lock, but stays
  * preemptible. Disabling preemption is the right choice here as bottom
@@ -242,14 +229,6 @@ static void get_cpu_fpsimd_context(void)
 		local_bh_disable();
 	else
 		preempt_disable();
-	__get_cpu_fpsimd_context();
-}
-
-static void __put_cpu_fpsimd_context(void)
-{
-	bool busy = __this_cpu_xchg(fpsimd_context_busy, false);
-
-	WARN_ON(!busy); /* No matching get_cpu_fpsimd_context()? */
 }
 
 /*
@@ -261,18 +240,12 @@ static void __put_cpu_fpsimd_context(void)
  */
 static void put_cpu_fpsimd_context(void)
 {
-	__put_cpu_fpsimd_context();
 	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
 		local_bh_enable();
 	else
 		preempt_enable();
 }
 
-static bool have_cpu_fpsimd_context(void)
-{
-	return !preemptible() && __this_cpu_read(fpsimd_context_busy);
-}
-
 unsigned int task_get_vl(const struct task_struct *task, enum vec_type type)
 {
 	return task->thread.vl[type];
@@ -383,7 +356,7 @@ static void task_fpsimd_load(void)
 	bool restore_ffr;
 
 	WARN_ON(!system_supports_fpsimd());
-	WARN_ON(!have_cpu_fpsimd_context());
+	WARN_ON(preemptible());
 
 	if (system_supports_sve() || system_supports_sme()) {
 		switch (current->thread.fp_type) {
@@ -467,7 +440,7 @@ static void fpsimd_save(void)
 	unsigned int vl;
 
 	WARN_ON(!system_supports_fpsimd());
-	WARN_ON(!have_cpu_fpsimd_context());
+	WARN_ON(preemptible());
 
 	if (test_thread_flag(TIF_FOREIGN_FPSTATE))
 		return;
@@ -1507,7 +1480,7 @@ void fpsimd_thread_switch(struct task_struct *next)
 	if (!system_supports_fpsimd())
 		return;
 
-	__get_cpu_fpsimd_context();
+	WARN_ON_ONCE(!irqs_disabled());
 
 	/* Save unsaved fpsimd state, if any: */
 	fpsimd_save();
@@ -1523,8 +1496,6 @@ void fpsimd_thread_switch(struct task_struct *next)
 
 	update_tsk_thread_flag(next, TIF_FOREIGN_FPSTATE,
 			       wrong_task || wrong_cpu);
-
-	__put_cpu_fpsimd_context();
 }
 
 static void fpsimd_flush_thread_vl(enum vec_type type)
@@ -1829,10 +1800,10 @@ void fpsimd_save_and_flush_cpu_state(void)
 	if (!system_supports_fpsimd())
 		return;
 	WARN_ON(preemptible());
-	__get_cpu_fpsimd_context();
+	get_cpu_fpsimd_context();
 	fpsimd_save();
 	fpsimd_flush_cpu_state();
-	__put_cpu_fpsimd_context();
+	put_cpu_fpsimd_context();
 }
 
 #ifdef CONFIG_KERNEL_MODE_NEON
-- 
2.43.0.472.g3155946c3a-goog

