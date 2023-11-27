Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nrgIVtOD"
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB6B111
	for <linux-crypto@vger.kernel.org>; Mon, 27 Nov 2023 04:23:21 -0800 (PST)
Received: by mail-wr1-x44a.google.com with SMTP id ffacd0b85a97d-332ee6c2a1aso1862737f8f.1
        for <linux-crypto@vger.kernel.org>; Mon, 27 Nov 2023 04:23:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701087799; x=1701692599; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7RC7fcm+iIbvYs4DSiycpu+OLkiF/mkbOdoMlvtSw6k=;
        b=nrgIVtODJgjjn0rHpg1oVRHevzvHulR08y2B/kUXnVUVhSV7JD/N8kgFOPYOLPmlW7
         pLxtv9e44vhsb6aV4JjVTKcy6v6j5rUt2I1mpwxPiDTy0Lk/tEThUS5C/gty9hQNiplZ
         /Sh+xUEg29N3N7ZGjUP1b0Q5q7LNaGClleQA7d40QuagfpgygDdN/AXnhmlphASubIog
         wY+Vv+ao09CM0SZsWmKhQD7dwPEXBv3i8Z3ri7vpWA+NSWVoFrvYqk/VV8BbiruTyodQ
         yCWiSEmyUnXsi7nbSK+1JjqaNj1mJshx/GChXJBdFXIpw/dzHZsNu5r9mnnKeRQ0IypI
         LDvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701087800; x=1701692600;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7RC7fcm+iIbvYs4DSiycpu+OLkiF/mkbOdoMlvtSw6k=;
        b=WTRFaia0eW5ukOijvl8E9mOYXsPaJwpDhbqt8f+ePYvC0cDv9VUf7dr8MkNOjz5Rhf
         CtOCgoXP3jBiQuxVOZg5VFRKudDzCNX9Lb1jeoq6C9tSYPCms/eQz5fRzk3kCAZ65dsw
         aosBNXgoJZRCwR54amS29rlnuZAQGtdAlXv0J6iXO/xJbXaJV9GOA4ZGeN5DfE6rkzrR
         nfzFnQ+gOxQW+jhbBpQxgSjGfg4aHfJ08E4KtNmwCPR2Vh2dASZMfghYSdzPD/Bt3CH9
         D3/YLq7KDSm+TYybUkO+rodscfekugfa+73Pu+GeqfanKzVrbqAgfh7g2D51erGRivlX
         ZudQ==
X-Gm-Message-State: AOJu0YzhO3w5AfAqHQwPhgJFdMHWPL/MgFUBCQ1Z6aGfXL6NZ+z8OVGi
	9/q8keSFRCFzgY4brXz3/0FOY+9R
X-Google-Smtp-Source: AGHT+IHf0gTC1PXtSo2Om+FUZLbT7f8NZUczw3CzhB5wimmyrlTb6QDofzUzL3kLMA0a2OUJC9vKEbW3
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:118a])
 (user=ardb job=sendgmr) by 2002:adf:fc52:0:b0:332:cc18:b798 with SMTP id
 e18-20020adffc52000000b00332cc18b798mr178167wrs.14.1701087799840; Mon, 27 Nov
 2023 04:23:19 -0800 (PST)
Date: Mon, 27 Nov 2023 13:23:03 +0100
In-Reply-To: <20231127122259.2265164-7-ardb@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231127122259.2265164-7-ardb@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2761; i=ardb@kernel.org;
 h=from:subject; bh=lq25ekjnEUttIKcfoZQhq0creUwzzdf4IQiZXvjxNR0=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JITWlS73BdDabothCI+GzBy6dev+y8ujX1SE8exbv+b323
 nG7x8afOkpZGMQ4GGTFFFkEZv99t/P0RKla51myMHNYmUCGMHBxCsBEGCQZ/hklH69KkPmpnFkt
 t/yB3oLV3xasDbzwI4e9eXP2m+SLl74z/OGL9j/6qqbysPDhBTNOMV9XOdBd63t7IRNP9PRpoo8 XOfICAA==
X-Mailer: git-send-email 2.43.0.rc1.413.gea7ed67945-goog
Message-ID: <20231127122259.2265164-10-ardb@google.com>
Subject: [PATCH v3 3/5] arm64: fpsimd: Implement lazy restore for kernel mode FPSIMD
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
---
 arch/arm64/include/asm/processor.h |  1 +
 arch/arm64/kernel/fpsimd.c         | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index dcb51c0571af..332f15d0abcf 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -169,6 +169,7 @@ struct thread_struct {
 	struct debug_info	debug;		/* debugging */
 
 	struct user_fpsimd_state	kmode_fpsimd_state;
+	unsigned int			kmode_fpsimd_cpu;
 #ifdef CONFIG_ARM64_PTR_AUTH
 	struct ptrauth_keys_user	keys_user;
 #ifdef CONFIG_ARM64_PTR_AUTH_KERNEL
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 198918805bf6..112111a078b6 100644
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
+	if (last->st == &task->thread.kmode_fpsimd_state &&
+	    task->thread.kmode_fpsimd_cpu == smp_processor_id())
+		return;
+
 	fpsimd_load_state(&task->thread.kmode_fpsimd_state);
 }
 
 static void fpsimd_save_kernel_state(struct task_struct *task)
 {
+	struct cpu_fp_state cpu_fp_state = {
+		.st		= &task->thread.kmode_fpsimd_state,
+		.to_save	= FP_STATE_FPSIMD,
+	};
+
 	fpsimd_save_state(&task->thread.kmode_fpsimd_state);
+	fpsimd_bind_state_to_cpu(&cpu_fp_state);
+
+	task->thread.kmode_fpsimd_cpu = smp_processor_id();
 }
 
 void fpsimd_thread_switch(struct task_struct *next)
-- 
2.43.0.rc1.413.gea7ed67945-goog

