From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH resend 02/15] arm64: add abstractions for FPSIMD state manipulation
Date: Thu,  1 May 2014 17:49:34 +0200
Message-ID: <1398959381-8126-3-git-send-email-ard.biesheuvel@linaro.org>
References: <1398959381-8126-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: catalin.marinas@arm.com, will.deacon@arm.com,
	steve.capper@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:65373 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbaEAPtw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 1 May 2014 11:49:52 -0400
Received: by mail-we0-f174.google.com with SMTP id k48so3374361wev.33
        for <linux-crypto@vger.kernel.org>; Thu, 01 May 2014 08:49:51 -0700 (PDT)
In-Reply-To: <1398959381-8126-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

There are two tacit assumptions in the FPSIMD handling code that will no longer
hold after the next patch that optimizes away some FPSIMD state restores:
. the FPSIMD registers of this CPU contain the userland FPSIMD state of
  task 'current';
. when switching to a task, its FPSIMD state will always be restored from
  memory.

This patch adds the following functions to abstract away from straight FPSIMD
register file saves and restores:
- fpsimd_preserve_current_state -> ensure current's FPSIMD state is saved
- fpsimd_restore_current_state -> ensure current's FPSIMD state is loaded
- fpsimd_update_current_state -> replace current's FPSIMD state
- fpsimd_flush_task_state -> invalidate live copies of a task's FPSIMD state

Where necessary, the ptrace, signal handling and fork code are updated to use
the above wrappers instead of poking into the FPSIMD registers directly.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/fpsimd.h |  6 ++++++
 arch/arm64/kernel/fpsimd.c      | 33 +++++++++++++++++++++++++++++++++
 arch/arm64/kernel/process.c     |  2 +-
 arch/arm64/kernel/ptrace.c      |  2 ++
 arch/arm64/kernel/signal.c      |  9 +++------
 arch/arm64/kernel/signal32.c    |  9 +++------
 6 files changed, 48 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index c43b4ac13008..9f9b8e438546 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -58,6 +58,12 @@ extern void fpsimd_load_state(struct fpsimd_state *state);
 extern void fpsimd_thread_switch(struct task_struct *next);
 extern void fpsimd_flush_thread(void);
 
+extern void fpsimd_preserve_current_state(void);
+extern void fpsimd_restore_current_state(void);
+extern void fpsimd_update_current_state(struct fpsimd_state *state);
+
+extern void fpsimd_flush_task_state(struct task_struct *target);
+
 #endif
 
 #endif
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 4aef42a04bdc..86ac6a9bc86a 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -87,6 +87,39 @@ void fpsimd_flush_thread(void)
 	preempt_enable();
 }
 
+/*
+ * Save the userland FPSIMD state of 'current' to memory
+ */
+void fpsimd_preserve_current_state(void)
+{
+	fpsimd_save_state(&current->thread.fpsimd_state);
+}
+
+/*
+ * Load the userland FPSIMD state of 'current' from memory
+ */
+void fpsimd_restore_current_state(void)
+{
+	fpsimd_load_state(&current->thread.fpsimd_state);
+}
+
+/*
+ * Load an updated userland FPSIMD state for 'current' from memory
+ */
+void fpsimd_update_current_state(struct fpsimd_state *state)
+{
+	preempt_disable();
+	fpsimd_load_state(state);
+	preempt_enable();
+}
+
+/*
+ * Invalidate live CPU copies of task t's FPSIMD state
+ */
+void fpsimd_flush_task_state(struct task_struct *t)
+{
+}
+
 #ifdef CONFIG_KERNEL_MODE_NEON
 
 /*
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 6391485f342d..c5693163408c 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -205,7 +205,7 @@ void release_thread(struct task_struct *dead_task)
 
 int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 {
-	fpsimd_save_state(&current->thread.fpsimd_state);
+	fpsimd_preserve_current_state();
 	*dst = *src;
 	return 0;
 }
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 6a8928bba03c..f8700eca24e7 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -517,6 +517,7 @@ static int fpr_set(struct task_struct *target, const struct user_regset *regset,
 		return ret;
 
 	target->thread.fpsimd_state.user_fpsimd = newstate;
+	fpsimd_flush_task_state(target);
 	return ret;
 }
 
@@ -764,6 +765,7 @@ static int compat_vfp_set(struct task_struct *target,
 		uregs->fpcr = fpscr & VFP_FPSCR_CTRL_MASK;
 	}
 
+	fpsimd_flush_task_state(target);
 	return ret;
 }
 
diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index 890a591f75dd..06448a77ff53 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -51,7 +51,7 @@ static int preserve_fpsimd_context(struct fpsimd_context __user *ctx)
 	int err;
 
 	/* dump the hardware registers to the fpsimd_state structure */
-	fpsimd_save_state(fpsimd);
+	fpsimd_preserve_current_state();
 
 	/* copy the FP and status/control registers */
 	err = __copy_to_user(ctx->vregs, fpsimd->vregs, sizeof(fpsimd->vregs));
@@ -86,11 +86,8 @@ static int restore_fpsimd_context(struct fpsimd_context __user *ctx)
 	__get_user_error(fpsimd.fpcr, &ctx->fpcr, err);
 
 	/* load the hardware registers from the fpsimd_state structure */
-	if (!err) {
-		preempt_disable();
-		fpsimd_load_state(&fpsimd);
-		preempt_enable();
-	}
+	if (!err)
+		fpsimd_update_current_state(&fpsimd);
 
 	return err ? -EFAULT : 0;
 }
diff --git a/arch/arm64/kernel/signal32.c b/arch/arm64/kernel/signal32.c
index b3fc9f5ec6d3..ac7e237d0bda 100644
--- a/arch/arm64/kernel/signal32.c
+++ b/arch/arm64/kernel/signal32.c
@@ -219,7 +219,7 @@ static int compat_preserve_vfp_context(struct compat_vfp_sigframe __user *frame)
 	 * Note that this also saves V16-31, which aren't visible
 	 * in AArch32.
 	 */
-	fpsimd_save_state(fpsimd);
+	fpsimd_preserve_current_state();
 
 	/* Place structure header on the stack */
 	__put_user_error(magic, &frame->magic, err);
@@ -282,11 +282,8 @@ static int compat_restore_vfp_context(struct compat_vfp_sigframe __user *frame)
 	 * We don't need to touch the exception register, so
 	 * reload the hardware state.
 	 */
-	if (!err) {
-		preempt_disable();
-		fpsimd_load_state(&fpsimd);
-		preempt_enable();
-	}
+	if (!err)
+		fpsimd_update_current_state(&fpsimd);
 
 	return err ? -EFAULT : 0;
 }
-- 
1.8.3.2
