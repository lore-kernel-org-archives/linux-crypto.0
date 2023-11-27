Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8CA2985
	for <linux-crypto@vger.kernel.org>; Mon, 27 Nov 2023 05:32:37 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D069B2F4;
	Mon, 27 Nov 2023 05:33:24 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.43.171])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7F3813F73F;
	Mon, 27 Nov 2023 05:32:35 -0800 (PST)
Date: Mon, 27 Nov 2023 13:32:32 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Ard Biesheuvel <ardb@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>, Kees Cook <keescook@chromium.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Brown <broonie@kernel.org>, Eric Biggers <ebiggers@google.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH v3 3/5] arm64: fpsimd: Implement lazy restore for kernel
 mode FPSIMD
Message-ID: <ZWSacNwpzMnUvw5y@FVFF77S0Q05N>
References: <20231127122259.2265164-7-ardb@google.com>
 <20231127122259.2265164-10-ardb@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231127122259.2265164-10-ardb@google.com>

On Mon, Nov 27, 2023 at 01:23:03PM +0100, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> Now that kernel mode FPSIMD state is context switched along with other
> task state, we can enable the existing logic that keeps track of which
> task's FPSIMD state the CPU is holding in its registers. If it is the
> context of the task that we are switching to, we can elide the reload of
> the FPSIMD state from memory.
> 
> Note that we also need to check whether the FPSIMD state on this CPU is
> the most recent: if a task gets migrated away and back again, the state
> in memory may be more recent than the state in the CPU. So add another
> CPU id field to task_struct to keep track of this. (We could reuse the
> existing CPU id field used for user mode context, but that might result
> in user state to be discarded unnecessarily, given that two distinct
> CPUs could be holding the most recent user mode state and the most
> recent kernel mode state)
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> Reviewed-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/include/asm/processor.h |  1 +
>  arch/arm64/kernel/fpsimd.c         | 18 ++++++++++++++++++
>  2 files changed, 19 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
> index dcb51c0571af..332f15d0abcf 100644
> --- a/arch/arm64/include/asm/processor.h
> +++ b/arch/arm64/include/asm/processor.h
> @@ -169,6 +169,7 @@ struct thread_struct {
>  	struct debug_info	debug;		/* debugging */
>  
>  	struct user_fpsimd_state	kmode_fpsimd_state;
> +	unsigned int			kmode_fpsimd_cpu;
>  #ifdef CONFIG_ARM64_PTR_AUTH
>  	struct ptrauth_keys_user	keys_user;
>  #ifdef CONFIG_ARM64_PTR_AUTH_KERNEL
> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> index 198918805bf6..112111a078b6 100644
> --- a/arch/arm64/kernel/fpsimd.c
> +++ b/arch/arm64/kernel/fpsimd.c
> @@ -1476,12 +1476,30 @@ void do_fpsimd_exc(unsigned long esr, struct pt_regs *regs)
>  
>  static void fpsimd_load_kernel_state(struct task_struct *task)
>  {
> +	struct cpu_fp_state *last = this_cpu_ptr(&fpsimd_last_state);
> +
> +	/*
> +	 * Elide the load if this CPU holds the most recent kernel mode
> +	 * FPSIMD context of the current task.
> +	 */
> +	if (last->st == &task->thread.kmode_fpsimd_state &&
> +	    task->thread.kmode_fpsimd_cpu == smp_processor_id())
> +		return;
> +
>  	fpsimd_load_state(&task->thread.kmode_fpsimd_state);
>  }
>  
>  static void fpsimd_save_kernel_state(struct task_struct *task)
>  {
> +	struct cpu_fp_state cpu_fp_state = {
> +		.st		= &task->thread.kmode_fpsimd_state,
> +		.to_save	= FP_STATE_FPSIMD,
> +	};
> +
>  	fpsimd_save_state(&task->thread.kmode_fpsimd_state);
> +	fpsimd_bind_state_to_cpu(&cpu_fp_state);
> +
> +	task->thread.kmode_fpsimd_cpu = smp_processor_id();
>  }

I was a little worried tha we might be missing a change to
fpsimd_cpu_pm_notifier() to handle contesxt-destructive idle states correctly,
but since that clears the fpsimd_last_state variable already, that should do
the right thing as-is.

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

>  
>  void fpsimd_thread_switch(struct task_struct *next)
> -- 
> 2.43.0.rc1.413.gea7ed67945-goog
> 
