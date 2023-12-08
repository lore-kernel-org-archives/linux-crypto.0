Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ce1MJz6L"
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2DF410F9
	for <linux-crypto@vger.kernel.org>; Fri,  8 Dec 2023 03:32:44 -0800 (PST)
Received: by mail-wr1-x44a.google.com with SMTP id ffacd0b85a97d-33331e69698so1534956f8f.1
        for <linux-crypto@vger.kernel.org>; Fri, 08 Dec 2023 03:32:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702035163; x=1702639963; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3O2yuXK53QoMtia112whRnCg8zUb1fGWC+saOC+mET8=;
        b=ce1MJz6LMDQI5/vIannxJjbbyRNy8p41nASuCTPM5wvZvnqaTWKs1DflVt9lOeiMBY
         2t5irPCcd2IodwpVGoXEiFz5aWl9/71KVc5D9BBGG91qh/QvTGp0DkVoNCCmRAhcEa6i
         RLEV5TTr960f0t1XFuGsOoq4TmSufdLRc6riIaanruumC2kqIt0eE1WvxSfeId7l5nWP
         0Xc6tf8zBBMJf5682fXYL4uY9zx4Ni2Y2I6mC+GHtGyO+mPgY4JlkhGZ2BOWB3KsJEvi
         I6ilWJAq8FAUrPmRqlH+xLjhqSoh4ZGGmWZA1t/Lhci/+vNGKFJBdO1RBOV0rCCxmfdN
         DvYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702035163; x=1702639963;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3O2yuXK53QoMtia112whRnCg8zUb1fGWC+saOC+mET8=;
        b=VAxkk9MQ1qgycp8KlW2kwYDgYHiI9umW2qeCh84gntbimDu9lFn/sVIbqGOjizQwjC
         CSUdm7VkqfRKo476sRTSjGcoffjKJcwzWCs74fndCCzYQSiKx/21JfFjYqmEVXXhgqUS
         c8VyRO5+Gdsez0i68JJywGxfR4gf/K7eRH+AXMvWCurxRUvCaXOJKrH2ZvIRju2uBkLI
         6YHTZgiq7EtpSC//cA60kHBlDPsRNFTxt/lkbGP9sQ9s/7+F6V35xu3kFwuhNKEY18zx
         WVK21y8V6/kYW5I9yg3ImTQhiEoMh0ZqBdvCIyHm1cywT7owVmTUuh8qB3qNeKvuH8/t
         h+Cw==
X-Gm-Message-State: AOJu0Yy+pCKrbzK0Lax8l/SH3PhtaHAbrs/3hk0p8vapwc8AgaEphEAG
	kZtdj3P6z3qQMM9EAnjKCDiKndIB
X-Google-Smtp-Source: AGHT+IGchnNKZLtJZLnM4Mg8Fopmt4Ms2IZHC0vpZD2xvrk2BI0CsZMPYPlXAw30wgGxC9MD2s8ptDAv
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:118a])
 (user=ardb job=sendgmr) by 2002:a05:6000:4008:b0:336:d27:f052 with SMTP id
 cp8-20020a056000400800b003360d27f052mr2785wrb.6.1702035163182; Fri, 08 Dec
 2023 03:32:43 -0800 (PST)
Date: Fri,  8 Dec 2023 12:32:21 +0100
In-Reply-To: <20231208113218.3001940-6-ardb@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231208113218.3001940-6-ardb@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=9014; i=ardb@kernel.org;
 h=from:subject; bh=l8r/ER1V9gqsGl3Qyn/lK6qCXUafvW2TT1gMg+3pacI=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIbXo35HNk97ev2Dp9nLthq9PFms/Keew9J8dxrjy3xYNd
 qPv3N0BHaUsDGIcDLJiiiwCs/++23l6olSt8yxZmDmsTCBDGLg4BWAiCkKMDBuFXuQzn2NYtGTR
 rWu3+VoM8v5Klp44+aB+r8EFuzU+jsyMDGcVYj5090/x0Vj7yF3fxXntucqfIeJ509tMNNg7Zmd lMwEA
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231208113218.3001940-8-ardb@google.com>
Subject: [PATCH v4 2/4] arm64: fpsimd: Preserve/restore kernel mode NEON at
 context switch
From: Ard Biesheuvel <ardb@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Kees Cook <keescook@chromium.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Mark Brown <broonie@kernel.org>, Eric Biggers <ebiggers@google.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Currently, the FPSIMD register file is not preserved and restored along
with the general registers on exception entry/exit or context switch.
For this reason, we disable preemption when enabling FPSIMD for kernel
mode use in task context, and suspend the processing of softirqs so that
there are no concurrent uses in the kernel. (Kernel mode FPSIMD may not
be used at all in other contexts).

Disabling preemption while doing CPU intensive work on inputs of
potentially unbounded size is bad for real-time performance, which is
why we try and ensure that SIMD crypto code does not operate on more
than ~4k at a time, which is an arbitrary limit and requires assembler
code to implement efficiently.

We can avoid the need for disabling preemption if we can ensure that any
in-kernel users of the NEON will not lose the FPSIMD register state
across a context switch. And given that disabling softirqs implicitly
disables preemption as well, we will also have to ensure that a softirq
that runs code using FPSIMD can safely interrupt an in-kernel user.

So introduce a thread_info flag TIF_USING_KMODE_FPSIMD, and modify the
context switch hook for FPSIMD to preserve and restore the kernel mode
FPSIMD to/from struct thread_struct when it is set. This avoids any
scheduling blackouts due to prolonged use of FPSIMD in kernel mode,
without the need for manual yielding.

In order to support softirq processing while FPSIMD is being used in
kernel task context, use the same flag to decide whether the kernel mode
FPSIMD state needs to be preserved and restored before allowing FPSIMD
to be used in softirq context.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
---
 arch/arm64/include/asm/processor.h   |  2 +
 arch/arm64/include/asm/thread_info.h |  1 +
 arch/arm64/kernel/fpsimd.c           | 92 ++++++++++++++++----
 3 files changed, 77 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index e5bc54522e71..ce6eebd6c08b 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -167,6 +167,8 @@ struct thread_struct {
 	unsigned long		fault_address;	/* fault info */
 	unsigned long		fault_code;	/* ESR_EL1 value */
 	struct debug_info	debug;		/* debugging */
+
+	struct user_fpsimd_state	kernel_fpsimd_state;
 #ifdef CONFIG_ARM64_PTR_AUTH
 	struct ptrauth_keys_user	keys_user;
 #ifdef CONFIG_ARM64_PTR_AUTH_KERNEL
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index 553d1bc559c6..e72a3bf9e563 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -80,6 +80,7 @@ void arch_setup_new_exec(void);
 #define TIF_TAGGED_ADDR		26	/* Allow tagged user addresses */
 #define TIF_SME			27	/* SME in use */
 #define TIF_SME_VL_INHERIT	28	/* Inherit SME vl_onexec across exec */
+#define TIF_KERNEL_FPSTATE	29	/* Task is in a kernel mode FPSIMD section */
 
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index ccc4a78a70e4..c2d05de677d1 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -357,6 +357,7 @@ static void task_fpsimd_load(void)
 
 	WARN_ON(!system_supports_fpsimd());
 	WARN_ON(preemptible());
+	WARN_ON(test_thread_flag(TIF_KERNEL_FPSTATE));
 
 	if (system_supports_sve() || system_supports_sme()) {
 		switch (current->thread.fp_type) {
@@ -379,7 +380,7 @@ static void task_fpsimd_load(void)
 		default:
 			/*
 			 * This indicates either a bug in
-			 * fpsimd_save() or memory corruption, we
+			 * fpsimd_save_user_state() or memory corruption, we
 			 * should always record an explicit format
 			 * when we save. We always at least have the
 			 * memory allocated for FPSMID registers so
@@ -430,7 +431,7 @@ static void task_fpsimd_load(void)
  * than via current, if we are saving KVM state then it will have
  * ensured that the type of registers to save is set in last->to_save.
  */
-static void fpsimd_save(void)
+static void fpsimd_save_user_state(void)
 {
 	struct cpu_fp_state const *last =
 		this_cpu_ptr(&fpsimd_last_state);
@@ -861,7 +862,7 @@ int vec_set_vector_length(struct task_struct *task, enum vec_type type,
 	if (task == current) {
 		get_cpu_fpsimd_context();
 
-		fpsimd_save();
+		fpsimd_save_user_state();
 	}
 
 	fpsimd_flush_task_state(task);
@@ -1473,6 +1474,16 @@ void do_fpsimd_exc(unsigned long esr, struct pt_regs *regs)
 		       current);
 }
 
+static void fpsimd_load_kernel_state(struct task_struct *task)
+{
+	fpsimd_load_state(&task->thread.kernel_fpsimd_state);
+}
+
+static void fpsimd_save_kernel_state(struct task_struct *task)
+{
+	fpsimd_save_state(&task->thread.kernel_fpsimd_state);
+}
+
 void fpsimd_thread_switch(struct task_struct *next)
 {
 	bool wrong_task, wrong_cpu;
@@ -1483,19 +1494,28 @@ void fpsimd_thread_switch(struct task_struct *next)
 	WARN_ON_ONCE(!irqs_disabled());
 
 	/* Save unsaved fpsimd state, if any: */
-	fpsimd_save();
+	if (test_thread_flag(TIF_KERNEL_FPSTATE))
+		fpsimd_save_kernel_state(current);
+	else
+		fpsimd_save_user_state();
 
-	/*
-	 * Fix up TIF_FOREIGN_FPSTATE to correctly describe next's
-	 * state.  For kernel threads, FPSIMD registers are never loaded
-	 * and wrong_task and wrong_cpu will always be true.
-	 */
-	wrong_task = __this_cpu_read(fpsimd_last_state.st) !=
-					&next->thread.uw.fpsimd_state;
-	wrong_cpu = next->thread.fpsimd_cpu != smp_processor_id();
+	if (test_tsk_thread_flag(next, TIF_KERNEL_FPSTATE)) {
+		fpsimd_load_kernel_state(next);
+		set_tsk_thread_flag(next, TIF_FOREIGN_FPSTATE);
+	} else {
+		/*
+		 * Fix up TIF_FOREIGN_FPSTATE to correctly describe next's
+		 * state.  For kernel threads, FPSIMD registers are never
+		 * loaded with user mode FPSIMD state and so wrong_task and
+		 * wrong_cpu will always be true.
+		 */
+		wrong_task = __this_cpu_read(fpsimd_last_state.st) !=
+			&next->thread.uw.fpsimd_state;
+		wrong_cpu = next->thread.fpsimd_cpu != smp_processor_id();
 
-	update_tsk_thread_flag(next, TIF_FOREIGN_FPSTATE,
-			       wrong_task || wrong_cpu);
+		update_tsk_thread_flag(next, TIF_FOREIGN_FPSTATE,
+				       wrong_task || wrong_cpu);
+	}
 }
 
 static void fpsimd_flush_thread_vl(enum vec_type type)
@@ -1585,7 +1605,7 @@ void fpsimd_preserve_current_state(void)
 		return;
 
 	get_cpu_fpsimd_context();
-	fpsimd_save();
+	fpsimd_save_user_state();
 	put_cpu_fpsimd_context();
 }
 
@@ -1801,7 +1821,7 @@ void fpsimd_save_and_flush_cpu_state(void)
 		return;
 	WARN_ON(preemptible());
 	get_cpu_fpsimd_context();
-	fpsimd_save();
+	fpsimd_save_user_state();
 	fpsimd_flush_cpu_state();
 	put_cpu_fpsimd_context();
 }
@@ -1835,10 +1855,37 @@ void kernel_neon_begin(void)
 	get_cpu_fpsimd_context();
 
 	/* Save unsaved fpsimd state, if any: */
-	fpsimd_save();
+	if (test_thread_flag(TIF_KERNEL_FPSTATE)) {
+		BUG_ON(IS_ENABLED(CONFIG_PREEMPT_RT) || !in_serving_softirq());
+		fpsimd_save_kernel_state(current);
+	} else {
+		fpsimd_save_user_state();
+
+		/*
+		 * Set the thread flag so that the kernel mode FPSIMD state
+		 * will be context switched along with the rest of the task
+		 * state.
+		 *
+		 * On non-PREEMPT_RT, softirqs may interrupt task level kernel
+		 * mode FPSIMD, but the task will not be preemptible so setting
+		 * TIF_KERNEL_FPSTATE for those would be both wrong (as it
+		 * would mark the task context FPSIMD state as requiring a
+		 * context switch) and unnecessary.
+		 *
+		 * On PREEMPT_RT, softirqs are serviced from a separate thread,
+		 * which is scheduled as usual, and this guarantees that these
+		 * softirqs are not interrupting use of the FPSIMD in kernel
+		 * mode in task context. So in this case, setting the flag here
+		 * is always appropriate.
+		 */
+		if (IS_ENABLED(CONFIG_PREEMPT_RT) || !in_serving_softirq())
+			set_thread_flag(TIF_KERNEL_FPSTATE);
+	}
 
 	/* Invalidate any task state remaining in the fpsimd regs: */
 	fpsimd_flush_cpu_state();
+
+	put_cpu_fpsimd_context();
 }
 EXPORT_SYMBOL_GPL(kernel_neon_begin);
 
@@ -1856,7 +1903,16 @@ void kernel_neon_end(void)
 	if (!system_supports_fpsimd())
 		return;
 
-	put_cpu_fpsimd_context();
+	/*
+	 * If we are returning from a nested use of kernel mode FPSIMD, restore
+	 * the task context kernel mode FPSIMD state. This can only happen when
+	 * running in softirq context on non-PREEMPT_RT.
+	 */
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && in_serving_softirq() &&
+	    test_thread_flag(TIF_KERNEL_FPSTATE))
+		fpsimd_load_kernel_state(current);
+	else
+		clear_thread_flag(TIF_KERNEL_FPSTATE);
 }
 EXPORT_SYMBOL_GPL(kernel_neon_end);
 
-- 
2.43.0.472.g3155946c3a-goog

