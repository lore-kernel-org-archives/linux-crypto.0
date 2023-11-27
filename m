Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4Awf7/dH"
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD842183
	for <linux-crypto@vger.kernel.org>; Mon, 27 Nov 2023 04:23:15 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5cfe0b63eeeso16146837b3.0
        for <linux-crypto@vger.kernel.org>; Mon, 27 Nov 2023 04:23:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701087795; x=1701692595; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=p/Ch/7P7gbGGJgSxsuR+ilVTc8c1SGXumgwmkI4FD94=;
        b=4Awf7/dH26FDONZbYGB+1hdCXXRfoe8ERJzCTZBckMzCfOQbsfmumufZSooq2QgIo8
         9d4UccWZ2Z81b7HkORIMivJgEgev/X7ZJkS30VAUUsFeDmsJQC88GnBizCUTmZ7cyVRm
         4wLS2hiIHgT6gdKurdKoqIZlrk0lRVCApWSAPdlt8/vgiRQEvBOW9j5OrQrC0SsfLMcc
         Vn2JIkbT3vhaZGwRRdwlEr1nywNioL6vUrsH6MgQkIEytx7DqSKPCXXhHSXgs7/jtR2o
         /zzqiUnvSCQ6z33jS51HeaaxS2VyLB23wsXT/S60gbeLaa6uZSVu3xzzRqaOGBi9R/1r
         9AxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701087795; x=1701692595;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p/Ch/7P7gbGGJgSxsuR+ilVTc8c1SGXumgwmkI4FD94=;
        b=mCPW7y8jGJOochsp1PM0ZwBHUjrwCfp/csuPoi7IPqgHyj+y9bAlfL/3VV5YwoR1qj
         VYdpAQ3rCU281kX2ikvJbCvguNcvzDc/zbC77QSd2jGSLhpJa5LZX81lJW+VmW9I5CY6
         UJcAZ0wB9xrh0HgnPIdVS3T89gKkGlIsJGUXC3BiR2N32G8AcW9s1n7hx73vxEsa8G87
         G9z62IuBEkPwPsGSjyYZNHtE2RVMunRVQkoX+CGJ/nl6yLzAlIi1W/38xFhQtM10LZ3i
         BvrlQwG0smFrVzCJkeG/tlkVgez1PJBOEle4oXTzE0GdyDpFwoYhbEBkkAOVLnrkl+j+
         9scQ==
X-Gm-Message-State: AOJu0YxgRG8Wa/Yc9GL7ib3ZZMxjwyA4T56ZwE3YpUldxgs6aEEWtkWX
	7VDSpWdzsrgUPXudc22865Lc9TAh
X-Google-Smtp-Source: AGHT+IF139AT3aSFpqii6704dz6/8G3AqH52BUM1m6DcXw4sMHUwiDAh6VdtyvMa9xONH3X0O6krylhX
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:118a])
 (user=ardb job=sendgmr) by 2002:a05:690c:3301:b0:5c9:6d54:de9e with SMTP id
 fj1-20020a05690c330100b005c96d54de9emr345006ywb.10.1701087794943; Mon, 27 Nov
 2023 04:23:14 -0800 (PST)
Date: Mon, 27 Nov 2023 13:23:01 +0100
In-Reply-To: <20231127122259.2265164-7-ardb@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231127122259.2265164-7-ardb@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=7220; i=ardb@kernel.org;
 h=from:subject; bh=XBBn0M5ow9wFIvsftiDNXJYygKjCB9+fC9f2YPlvdKk=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JITWlS/V6/6d1n0MvC6470mSewDi94qBCYYjr3AeShbYHU
 o2WHtvaUcrCIMbBICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACZygp2RYQvXzl9rNTsezxd1
 PeFaeu/a76YHmqZW9YlbNP+GPZxespzhn47Co+bgrs+9j/a/61FfKzH93EEnrv1LO4V6I/eJfrt 0mQsA
X-Mailer: git-send-email 2.43.0.rc1.413.gea7ed67945-goog
Message-ID: <20231127122259.2265164-8-ardb@google.com>
Subject: [PATCH v3 1/5] arm64: fpsimd: Drop unneeded 'busy' flag
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
2.43.0.rc1.413.gea7ed67945-goog

