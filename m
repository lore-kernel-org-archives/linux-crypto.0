Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Frtc1AN9"
Received: from mail-wm1-x349.google.com (mail-wm1-x349.google.com [IPv6:2a00:1450:4864:20::349])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A28110D8
	for <linux-crypto@vger.kernel.org>; Fri,  8 Dec 2023 03:32:49 -0800 (PST)
Received: by mail-wm1-x349.google.com with SMTP id 5b1f17b1804b1-40b357e2a01so14124045e9.1
        for <linux-crypto@vger.kernel.org>; Fri, 08 Dec 2023 03:32:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702035167; x=1702639967; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HXGpaqh/zgZf0KyBTEhnX4/b4EkZDuu9UX5raBl8kcg=;
        b=Frtc1AN9AGgqvqmuBKmyOn4CMa4LAwrWMvRNohSe9EXWwDkGr+fYs7nhUsky1MFuUl
         2A/vQ0N4CFHFqJ+kSeOwAj0MamRQ3z1r3S0w6+y+uvIdshR5+66VdQJnxFQK/9gJ2cii
         ThKgSkurZwYHVdYJqFuCo+GnY2htsTXr9C0sH8mPdP3U224c5CYNSJ6mK6Xqjij0vU5p
         xIZpOsn4TC9hie+dGIgdh+DPoW7uwokX1HM7aeawtwl/YD/m59dW2MTGQowizI70hnhO
         jwUypj0oT2fVu79cstampYnBmuhRUj5AKtKc9W8DOXBsNhZQuldMnf7HpI/phsT1Nfcd
         bB6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702035167; x=1702639967;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HXGpaqh/zgZf0KyBTEhnX4/b4EkZDuu9UX5raBl8kcg=;
        b=YH6z9J93ZQAZhzEDa+ehdMiU43XRtawxCFClLtNNhtxVIL3rz27VVg61KYe2OaTcHc
         z6AwjMXZNo/MT/YpAP7VWgPTqre1tewswGbUCEj/EaiYfVk6rFi+o2lIbcyuvPM82OLx
         AQnl6lQfU5/oFsqaRdIWYsURyWRJYLcp2mfU2cFTFyNmwmPkDZxs9Ao2Z1tsyb6IOEm0
         UCidiECTkysmjUP0WrcGmMkln/6E8OfDQiK3G6zPN+299M1pHegMruu+YOWY34bvJuJ9
         dYSDI05kowIrGi1taYPo/62s/t5L0fdpEp3In+ziiCUWGuSkd65PA6v/v2QV3YsRHzY1
         WkJA==
X-Gm-Message-State: AOJu0Yw3UXb3NJslHEz1NlJ2apHA6ELevzezeMkpcVPN55GEJ/Z/J5iv
	UempI0fXPJHq1Sttl8zwLBejyckN
X-Google-Smtp-Source: AGHT+IEHfkUnH7fiOWr3g719RJ8fqdfAiAbCXQvqS8YXxlxFj7QxMABZd+ezCq05DcEo184QpXA0TZNK
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:118a])
 (user=ardb job=sendgmr) by 2002:a05:600c:4a12:b0:40a:5268:b9c with SMTP id
 c18-20020a05600c4a1200b0040a52680b9cmr38554wmp.2.1702035165430; Fri, 08 Dec
 2023 03:32:45 -0800 (PST)
Date: Fri,  8 Dec 2023 12:32:22 +0100
In-Reply-To: <20231208113218.3001940-6-ardb@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231208113218.3001940-6-ardb@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2812; i=ardb@kernel.org;
 h=from:subject; bh=vQbP47nJikDTpxsJZ362i0c2hKsXJVRVb5p7Cv8VwhU=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIbXo39ESHoe7R96tEfgUHtrJN71vFu89B8HHXlXLT04v9
 dG5f/9NRykLgxgHg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZjIdVNGhtMrJlnkzmCujmZl
 +W+a+MDt867XHi6b4hWcbK9OW8h8cAIjw/d9C/czT7ecu/XZ0kS7askixVNLZR9q5Fza+8x0jiW /BTMA
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231208113218.3001940-9-ardb@google.com>
Subject: [PATCH v4 3/4] arm64: fpsimd: Implement lazy restore for kernel mode FPSIMD
From: Ard Biesheuvel <ardb@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Kees Cook <keescook@chromium.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Mark Brown <broonie@kernel.org>, Eric Biggers <ebiggers@google.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Now that kernel mode FPSIMD state is context switched along with other
task state, we can enable the existing logic that keeps track of which
task's FPSIMD state the CPU is holding in its registers. If it is the
context of the task that we are switching to, we can elide the reload of
the FPSIMD state from memory.

Note that we also need to check whether the FPSIMD state on this CPU is
the most recent: if a task gets migrated away and back again, the state
in memory may be more recent than the state in the CPU. So add another
CPU id field to task_struct to keep track of this. (We could reuse the
existing CPU id field used for user mode context, but that might result
in user state to be discarded unnecessarily, given that two distinct
CPUs could be holding the most recent user mode state and the most
recent kernel mode state)

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
---
 arch/arm64/include/asm/processor.h |  1 +
 arch/arm64/kernel/fpsimd.c         | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index ce6eebd6c08b..5b0a04810b23 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -169,6 +169,7 @@ struct thread_struct {
 	struct debug_info	debug;		/* debugging */
 
 	struct user_fpsimd_state	kernel_fpsimd_state;
+	unsigned int			kernel_fpsimd_cpu;
 #ifdef CONFIG_ARM64_PTR_AUTH
 	struct ptrauth_keys_user	keys_user;
 #ifdef CONFIG_ARM64_PTR_AUTH_KERNEL
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index c2d05de677d1..50ae93d9baec 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1476,12 +1476,30 @@ void do_fpsimd_exc(unsigned long esr, struct pt_regs *regs)
 
 static void fpsimd_load_kernel_state(struct task_struct *task)
 {
+	struct cpu_fp_state *last = this_cpu_ptr(&fpsimd_last_state);
+
+	/*
+	 * Elide the load if this CPU holds the most recent kernel mode
+	 * FPSIMD context of the current task.
+	 */
+	if (last->st == &task->thread.kernel_fpsimd_state &&
+	    task->thread.kernel_fpsimd_cpu == smp_processor_id())
+		return;
+
 	fpsimd_load_state(&task->thread.kernel_fpsimd_state);
 }
 
 static void fpsimd_save_kernel_state(struct task_struct *task)
 {
+	struct cpu_fp_state cpu_fp_state = {
+		.st		= &task->thread.kernel_fpsimd_state,
+		.to_save	= FP_STATE_FPSIMD,
+	};
+
 	fpsimd_save_state(&task->thread.kernel_fpsimd_state);
+	fpsimd_bind_state_to_cpu(&cpu_fp_state);
+
+	task->thread.kernel_fpsimd_cpu = smp_processor_id();
 }
 
 void fpsimd_thread_switch(struct task_struct *next)
-- 
2.43.0.472.g3155946c3a-goog

