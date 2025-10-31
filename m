Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4E92264B8
	for <linux-crypto@vger.kernel.org>; Fri, 31 Oct 2025 14:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761920177; cv=none; b=tYoQ/6M1nQzSss0k1tRr0eKnCkXxz4RkHkGkzrVqaqs2HN1Lkjq5dKSF+1IXPABrljq5jkWpOjRdXr89lywRI1cVkwun+SOtEQKrB1rsk+DGHkhmwJ1HfM1YzLRwSiVg67mNGcjefdTIjdSeynmXKD+bqTS+ak8QmxrXGqQ3DHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761920177; c=relaxed/simple;
	bh=4nV6bg9BxQBHR3ve0/aTh4iBlD+ZLxghEg4FGIDt1Ko=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bqr0EtSHxd42qgbOpHYls7k5YJUP1QZ1nNljGuPHW+HnIR49epeAx1ca0XQH/VPclBGDRnmPMnLQ3wD97V61VEBAIQHgjdpeLvg1uHvufEFuZiFsYyw7d+XxZ41bDJ2V9oJrVlvLticj5urPOztT1DdCwiHn6TaDhlxepBZLL6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QH1nYPWN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QH1nYPWN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AE7DC116D0
	for <linux-crypto@vger.kernel.org>; Fri, 31 Oct 2025 14:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761920177;
	bh=4nV6bg9BxQBHR3ve0/aTh4iBlD+ZLxghEg4FGIDt1Ko=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=QH1nYPWNHA+7SlbW4rkoc6HZk2zGrFi5h9Imb9AUheD7aYMcMHrf1HQnaoHHkd2uL
	 2+2M5g7jTRh57yZAsWEcLTfHdn0H0zlfiFakThloKPvEA4wgiaoPEhWku6iIrZtWUS
	 Av6ZCdustK6VQ6Br54v1zcIFMO7rCwI8kEAAnVgyAq86RnQXMVJW2z/MSZivYvJaGH
	 yDZSWDQtH6T0Uy++F8Iuy1VRZ370ZuTwJZr4JjEcZLAZ80uuLluy8E+JalWaprV4Pt
	 auF4lAd6wnnoOpQ6JxKiTkCzahWiqqHX5pP2UUVXehMbspvMRCU5SDbaouXcljDHEB
	 J9JyliGfhyuFQ==
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-375eff817a3so27978441fa.1
        for <linux-crypto@vger.kernel.org>; Fri, 31 Oct 2025 07:16:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWgCBPrCr1yQ6wrrsOOeFOO1qGcVhM0SOtMfER5Srq00aE4aCW+Y+hUZMWiUCib/VbHnpnOeUCjFTpiShs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyVzNdDC47YTYW9YhOmQhT2yViqriWzfOZ0tIO31ebMIPH0E5cu
	rldNVkzJHF6uf8xBZFCmt426GZMRCPY+mpzSj0AOuwfnmQ+Lxz0vrcKQyT6z2RE7evDw0ewAldN
	aGvHIbqwzw4syu1O6h9IiIccVOC8XZy0=
X-Google-Smtp-Source: AGHT+IFs1mTCcTHch9nwgEpBOET9c/2ewJ7dIptcwyNtn+9vsPTkhZ3FIuxBD0r2sJ+I4tqvqhMIzczxFtmxLqmfsm8=
X-Received: by 2002:a05:651c:2115:b0:336:bd8c:5e53 with SMTP id
 38308e7fff4ca-37a18d86e10mr13223471fa.5.1761920175576; Fri, 31 Oct 2025
 07:16:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251031103858.529530-23-ardb+git@google.com> <20251031103858.529530-44-ardb+git@google.com>
In-Reply-To: <20251031103858.529530-44-ardb+git@google.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 31 Oct 2025 15:16:03 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGV1xeZXF7adHwbUsg6+JpLyueWaiS89pS7XFm3fKuw6A@mail.gmail.com>
X-Gm-Features: AWmQ_bloi2mdeVrG1W7Ne01Tlv9fDhnqBIB5ANhc-xgL21Rb2uTEStHrSK70YvA
Message-ID: <CAMj1kXGV1xeZXF7adHwbUsg6+JpLyueWaiS89pS7XFm3fKuw6A@mail.gmail.com>
Subject: Re: [PATCH v4 21/21] arm64/fpsimd: Allocate kernel mode FP/SIMD
 buffers on the stack
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au, 
	ebiggers@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 31 Oct 2025 at 11:40, Ard Biesheuvel <ardb+git@google.com> wrote:
>
> From: Ard Biesheuvel <ardb@kernel.org>
>
> Commit aefbab8e77eb16b5
>
>   ("arm64: fpsimd: Preserve/restore kernel mode NEON at context switch")
>
> added a 'kernel_fpsimd_state' field to struct thread_struct, which is
> the arch-specific portion of struct task_struct, and is allocated for
> each task in the system. The size of this field is 528 bytes, resulting
> in non-negligible bloat of task_struct, and the resulting memory
> overhead may impact performance on systems with many processes.
>
> This allocation is only used if the task is scheduled out or interrupted
> by a softirq while using the FP/SIMD unit in kernel mode, and so it is
> possible to transparently allocate this buffer on the caller's stack
> instead.
>
> So tweak the 'ksimd' scoped guard implementation so that a stack buffer
> is allocated and passed to both kernel_neon_begin() and
> kernel_neon_end(), and either record it in the task struct, or use it
> directly to preserve the task mode kernel FP/SIMD when running in
> softirq context. Passing the address to both functions, and checking the
> addresses for consistency ensures that callers of the updated bare
> begin/end API use it in a manner that is consistent with the new context
> switch semantics.
>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/include/asm/fpu.h       |  4 +-
>  arch/arm64/include/asm/neon.h      |  4 +-
>  arch/arm64/include/asm/processor.h |  7 ++-
>  arch/arm64/include/asm/simd.h      |  7 ++-
>  arch/arm64/kernel/fpsimd.c         | 53 ++++++++++++++------
>  5 files changed, 54 insertions(+), 21 deletions(-)
>
> diff --git a/arch/arm64/include/asm/fpu.h b/arch/arm64/include/asm/fpu.h
> index bdc4c6304c6a..751e88a96734 100644
> --- a/arch/arm64/include/asm/fpu.h
> +++ b/arch/arm64/include/asm/fpu.h
> @@ -15,12 +15,12 @@ static inline void kernel_fpu_begin(void)
>  {
>         BUG_ON(!in_task());
>         preempt_disable();
> -       kernel_neon_begin();
> +       kernel_neon_begin(NULL);
>  }
>
>  static inline void kernel_fpu_end(void)
>  {
> -       kernel_neon_end();
> +       kernel_neon_end(NULL);
>         preempt_enable();
>  }
>
> diff --git a/arch/arm64/include/asm/neon.h b/arch/arm64/include/asm/neon.h
> index d4b1d172a79b..acebee4605b5 100644
> --- a/arch/arm64/include/asm/neon.h
> +++ b/arch/arm64/include/asm/neon.h
> @@ -13,7 +13,7 @@
>
>  #define cpu_has_neon()         system_supports_fpsimd()
>
> -void kernel_neon_begin(void);
> -void kernel_neon_end(void);
> +void kernel_neon_begin(struct user_fpsimd_state *);
> +void kernel_neon_end(struct user_fpsimd_state *);
>
>  #endif /* ! __ASM_NEON_H */
> diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
> index 61d62bfd5a7b..de3c3b65461d 100644
> --- a/arch/arm64/include/asm/processor.h
> +++ b/arch/arm64/include/asm/processor.h
> @@ -172,7 +172,12 @@ struct thread_struct {
>         unsigned long           fault_code;     /* ESR_EL1 value */
>         struct debug_info       debug;          /* debugging */
>
> -       struct user_fpsimd_state        kernel_fpsimd_state;
> +       /*
> +        * Set [cleared] by kernel_neon_begin() [kernel_neon_end()] to the
> +        * address of a caller provided buffer that will be used to preserve a
> +        * task's kernel mode FPSIMD state while it is scheduled out.
> +        */
> +       struct user_fpsimd_state        *kernel_fpsimd_state;
>         unsigned int                    kernel_fpsimd_cpu;
>  #ifdef CONFIG_ARM64_PTR_AUTH
>         struct ptrauth_keys_user        keys_user;
> diff --git a/arch/arm64/include/asm/simd.h b/arch/arm64/include/asm/simd.h
> index d9f83c478736..7ddb25df5c98 100644
> --- a/arch/arm64/include/asm/simd.h
> +++ b/arch/arm64/include/asm/simd.h
> @@ -43,8 +43,11 @@ static __must_check inline bool may_use_simd(void) {
>
>  #endif /* ! CONFIG_KERNEL_MODE_NEON */
>
> -DEFINE_LOCK_GUARD_0(ksimd, kernel_neon_begin(), kernel_neon_end())
> +DEFINE_LOCK_GUARD_1(ksimd,
> +                   struct user_fpsimd_state,
> +                   kernel_neon_begin(_T->lock),
> +                   kernel_neon_end(_T->lock))
>
> -#define scoped_ksimd() scoped_guard(ksimd)
> +#define scoped_ksimd() scoped_guard(ksimd, &(struct user_fpsimd_state){})
>
>  #endif
> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> index e3f8f51748bc..1c652ce4d40d 100644
> --- a/arch/arm64/kernel/fpsimd.c
> +++ b/arch/arm64/kernel/fpsimd.c
> @@ -1489,21 +1489,23 @@ static void fpsimd_load_kernel_state(struct task_struct *task)
>          * Elide the load if this CPU holds the most recent kernel mode
>          * FPSIMD context of the current task.
>          */
> -       if (last->st == &task->thread.kernel_fpsimd_state &&
> +       if (last->st == task->thread.kernel_fpsimd_state &&
>             task->thread.kernel_fpsimd_cpu == smp_processor_id())
>                 return;
>
> -       fpsimd_load_state(&task->thread.kernel_fpsimd_state);
> +       fpsimd_load_state(task->thread.kernel_fpsimd_state);
>  }
>
>  static void fpsimd_save_kernel_state(struct task_struct *task)
>  {
>         struct cpu_fp_state cpu_fp_state = {
> -               .st             = &task->thread.kernel_fpsimd_state,
> +               .st             = task->thread.kernel_fpsimd_state,
>                 .to_save        = FP_STATE_FPSIMD,
>         };
>
> -       fpsimd_save_state(&task->thread.kernel_fpsimd_state);
> +       BUG_ON(!cpu_fp_state.st);
> +
> +       fpsimd_save_state(task->thread.kernel_fpsimd_state);
>         fpsimd_bind_state_to_cpu(&cpu_fp_state);
>
>         task->thread.kernel_fpsimd_cpu = smp_processor_id();
> @@ -1774,6 +1776,7 @@ void fpsimd_update_current_state(struct user_fpsimd_state const *state)
>  void fpsimd_flush_task_state(struct task_struct *t)
>  {
>         t->thread.fpsimd_cpu = NR_CPUS;
> +       t->thread.kernel_fpsimd_state = NULL;
>         /*
>          * If we don't support fpsimd, bail out after we have
>          * reset the fpsimd_cpu for this task and clear the
> @@ -1833,8 +1836,13 @@ void fpsimd_save_and_flush_cpu_state(void)
>   *
>   * The caller may freely use the FPSIMD registers until kernel_neon_end() is
>   * called.
> + *
> + * Unless called from non-preemptible task context, @state must point to a
> + * caller provided buffer that will be used to preserve the task's kernel mode
> + * FPSIMD context when it is scheduled out, or if it is interrupted by kernel
> + * mode FPSIMD occurring in softirq context. May be %NULL otherwise.
>   */
> -void kernel_neon_begin(void)
> +void kernel_neon_begin(struct user_fpsimd_state *state)
>  {
>         if (WARN_ON(!system_supports_fpsimd()))
>                 return;
> @@ -1846,7 +1854,7 @@ void kernel_neon_begin(void)
>         /* Save unsaved fpsimd state, if any: */
>         if (test_thread_flag(TIF_KERNEL_FPSTATE)) {
>                 BUG_ON(IS_ENABLED(CONFIG_PREEMPT_RT) || !in_serving_softirq());
> -               fpsimd_save_kernel_state(current);
> +               fpsimd_save_state(state);
>         } else {
>                 fpsimd_save_user_state();
>
> @@ -1867,8 +1875,17 @@ void kernel_neon_begin(void)
>                  * mode in task context. So in this case, setting the flag here
>                  * is always appropriate.
>                  */
> -               if (IS_ENABLED(CONFIG_PREEMPT_RT) || !in_serving_softirq())
> +               if (IS_ENABLED(CONFIG_PREEMPT_RT) || !in_serving_softirq()) {
> +                       /*
> +                        * Record the caller provided buffer as the kernel mode
> +                        * FP/SIMD buffer for this task, so that the state can
> +                        * be preserved and restored on a context switch.
> +                        */
> +                       WARN_ON(current->thread.kernel_fpsimd_state != NULL);
> +                       WARN_ON(preemptible() && !state);

This is in the wrong place: we are never preemptible here, even when
called from preemptible context.

Will fix for the next rev.
