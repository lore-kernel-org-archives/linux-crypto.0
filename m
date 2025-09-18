Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6632D9EED
	for <linux-crypto@vger.kernel.org>; Thu, 18 Sep 2025 06:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758177376; cv=none; b=LXCrF13qsfnZv/k5761UZZEbGvXBMkFJcEIdxx3vOffEiB1UKDJNyParvW0hiFqDEnQe3urUv4VlUdCDv1JSl5xnGw4gBZkQVLV6k3vTEqTREbvXjHn06DBexdV1RdzrpK46p+zZgF4leyX3dK+y1lQkMCWSJpom+lIV70Tqdh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758177376; c=relaxed/simple;
	bh=yZilTx72GF8qqKvNUbLyRsBvojfMOoic5NxQVYR1doQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=h78E27mXPpJrT53JEgIamyz7EMKD0BLhIRht5XmkikD7R+kBa4mB/kdZwImyCFGcVnfTVMfbxkV2NgyrTTkdYFbn/GWLwLAm8QsGOV3OROGX1cltVOvNwSIwvnLiQw/MLhy93QIPJDYLoN6tt01BOzK8Prpuw7/4DrXAHCMQt98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gCdRHsIt; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gCdRHsIt"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45f2b9b99f0so3076045e9.1
        for <linux-crypto@vger.kernel.org>; Wed, 17 Sep 2025 23:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758177373; x=1758782173; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=A1ta9KttEF8sJmGrgUmmN67wbPwjz6EsYqXVUKnq6iI=;
        b=gCdRHsItTVNUcyqQGCJDAlulH7ER5iVlFUaZTwNwI4eMZ2XDpV1v4GCbIoTT5G0qGt
         R6bNas8vIzA2zVfnuHKk0s8JwBM1G5wIMRhkHpZpA3JIGSR3PCw+qMbMjAVnXC9CYQSO
         zpPvkP72QHOImC5H2/wcIqjsRLz9Z/CSHM8Wvuyj/CCWHF6tPnSGM9sbkis76GFW4D0n
         c6F7Yf1U3+aMygwyBY67Hk/ZyrXNMzW0/OMq16xHUOgv/MMuo3QkelOxPuupKgttarGv
         js5/vmTnJgmC1jg9014BSiC9YTyNaYfx0sEw1Gs3NlgUCJcOGxMKq+m4D38rYZn6aSCj
         KawQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758177373; x=1758782173;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A1ta9KttEF8sJmGrgUmmN67wbPwjz6EsYqXVUKnq6iI=;
        b=Rai/69ta5BPz9oBQPOVX5w3DqHMYfi/bFliE+kCSUaisBhcg9HxYxRu/ozpUo2asaf
         YftZfHayV9GQa+ZPbz4DrGsteFl2mlzT5+lBnE0eAhVYOZ3cmUYSBAmksqyxjMUhZCYw
         UOidEDJUWnqX+uw7TQ5EIK+uc/7VmtktQIpVow/2WCywLb4QN5/c7zjGKxXpZ/hCVcCE
         k//Gt6FtFSqxfbX+nw4OWqxRvQfgpzkFrg9sRHccVDaWJKiBPVKinOyk0DdDIFubtk/Y
         8IKHwsB9Z/tCgVuNYEMISGAN15hF93KWLY0XOivKk1vcFDS/8bPJFy06CXEtfqjdoP60
         eprA==
X-Gm-Message-State: AOJu0YwALjQq8+i/w/0OYuXJgJA6IxpDerhH74ILzu2LjVfYZqPNIi1I
	uGWyvFLv1O5DAwC3ODPcPrTrT3Dg3FNV5kRLN20kg4ps5u/vRm0pznuuewoPO3tp+Iow5LO0Yw=
	=
X-Google-Smtp-Source: AGHT+IHwDdNQKSpulh2BKmpGNYTuQzvpQWSRjIlrRJfiSKNGg3YFQhrNwINDqw6AqWcxEWBgOnrglZXe
X-Received: from wmbhc26.prod.google.com ([2002:a05:600c:871a:b0:45f:2859:5428])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:c0d7:b0:45b:9b9f:88cb
 with SMTP id 5b1f17b1804b1-464fdf4425emr15559625e9.16.1758177372848; Wed, 17
 Sep 2025 23:36:12 -0700 (PDT)
Date: Thu, 18 Sep 2025 08:35:45 +0200
In-Reply-To: <20250918063539.2640512-7-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250918063539.2640512-7-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=5265; i=ardb@kernel.org;
 h=from:subject; bh=Dk5FXoMF39rDUZtpDj8iIP76qecw7z+7kErWyEtMPzo=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIeP0CufThftPBJ5ss7Q590bVUEs2Ter/i0lV+lcLvH5sO
 OEvxvmxo5SFQYyLQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAExE8A0jQ1dfScM10ctyTn+n
 ty7RPK65fneCi7xyrPjMkFVnk3OWVDH8r2H2uPotW6BoL8e7uzOTizP+SbnZ3nFqrFr5/s6HEP6 VLAA=
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250918063539.2640512-12-ardb+git@google.com>
Subject: [PATCH 5/5] arm64/fpsimd: Allocate kernel mode FP/SIMD buffers on the stack
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, ebiggers@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Brown <broonie@kernel.org>
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
by a softirq while using the FP/SIMD unit in kernel mode, and given that
calls to kernel_neon_begin() and kernel_neon_end() are now guaranteed to
originate from the same lexical scope, it is possible to transparently
allocate this buffer on the caller's stack instead.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/include/asm/neon.h      |  4 +--
 arch/arm64/include/asm/processor.h |  2 +-
 arch/arm64/kernel/fpsimd.c         | 26 ++++++++++++++------
 3 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/neon.h b/arch/arm64/include/asm/neon.h
index 4e24f1058b55..acaac98ff449 100644
--- a/arch/arm64/include/asm/neon.h
+++ b/arch/arm64/include/asm/neon.h
@@ -13,10 +13,10 @@
 
 #define cpu_has_neon()		system_supports_fpsimd()
 
-void __kernel_neon_begin(void);
+void __kernel_neon_begin(struct user_fpsimd_state *);
 void __kernel_neon_end(void);
 
-#define kernel_neon_begin()	do { __kernel_neon_begin()
+#define kernel_neon_begin()	do { __kernel_neon_begin(&(struct user_fpsimd_state){})
 #define kernel_neon_end()	__kernel_neon_end(); } while (0)
 
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
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index d7eb073d1366..919c53a26484 100644
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
-void __kernel_neon_begin(void)
+void __kernel_neon_begin(struct user_fpsimd_state *s)
 {
 	if (WARN_ON(!system_supports_fpsimd()))
 		return;
@@ -1849,6 +1852,13 @@ void __kernel_neon_begin(void)
 	} else {
 		fpsimd_save_user_state();
 
+		/*
+		 * Record the caller provided buffer as the kernel mode FP/SIMD
+		 * buffer for this task, so that the state can be preserved and
+		 * restored on a context switch.
+		 */
+		current->thread.kernel_fpsimd_state = s;
+
 		/*
 		 * Set the thread flag so that the kernel mode FPSIMD state
 		 * will be context switched along with the rest of the task
@@ -1899,8 +1909,8 @@ void __kernel_neon_end(void)
 	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && in_serving_softirq() &&
 	    test_thread_flag(TIF_KERNEL_FPSTATE))
 		fpsimd_load_kernel_state(current);
-	else
-		clear_thread_flag(TIF_KERNEL_FPSTATE);
+	else if (test_and_clear_thread_flag(TIF_KERNEL_FPSTATE))
+		current->thread.kernel_fpsimd_state = NULL;
 }
 EXPORT_SYMBOL_GPL(__kernel_neon_end);
 
@@ -1936,7 +1946,7 @@ void __efi_fpsimd_begin(void)
 	WARN_ON(preemptible());
 
 	if (may_use_simd()) {
-		__kernel_neon_begin();
+		__kernel_neon_begin(&efi_fpsimd_state);
 	} else {
 		/*
 		 * If !efi_sve_state, SVE can't be in use yet and doesn't need
-- 
2.51.0.384.g4c02a37b29-goog

