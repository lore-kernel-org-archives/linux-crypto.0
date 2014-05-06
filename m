From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH resend 02/15] arm64: add abstractions for FPSIMD state
 manipulation
Date: Tue, 6 May 2014 15:43:40 +0100
Message-ID: <20140506144340.GE23957@arm.com>
References: <1398959381-8126-1-git-send-email-ard.biesheuvel@linaro.org>
 <1398959381-8126-3-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "steve.capper@linaro.org" <steve.capper@linaro.org>,
 Will Deacon <Will.Deacon@arm.com>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1398959381-8126-3-git-send-email-ard.biesheuvel@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

On Thu, May 01, 2014 at 04:49:34PM +0100, Ard Biesheuvel wrote:
> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> index 4aef42a04bdc..86ac6a9bc86a 100644
> --- a/arch/arm64/kernel/fpsimd.c
> +++ b/arch/arm64/kernel/fpsimd.c
> @@ -87,6 +87,39 @@ void fpsimd_flush_thread(void)
>  	preempt_enable();
>  }
>  
> +/*
> + * Save the userland FPSIMD state of 'current' to memory
> + */
> +void fpsimd_preserve_current_state(void)
> +{
> +	fpsimd_save_state(&current->thread.fpsimd_state);
> +}
> +
> +/*
> + * Load the userland FPSIMD state of 'current' from memory
> + */
> +void fpsimd_restore_current_state(void)
> +{
> +	fpsimd_load_state(&current->thread.fpsimd_state);
> +}
> +
> +/*
> + * Load an updated userland FPSIMD state for 'current' from memory
> + */
> +void fpsimd_update_current_state(struct fpsimd_state *state)
> +{
> +	preempt_disable();
> +	fpsimd_load_state(state);
> +	preempt_enable();
> +}

Minor - please update the comment above the functions to state that
preemption needs to be disabled by the caller.

> +/*
> + * Invalidate live CPU copies of task t's FPSIMD state
> + */
> +void fpsimd_flush_task_state(struct task_struct *t)
> +{
> +}

I guess this will be added in a subsequent patch. You could either move
it there or add a comment in the commit log that it is a dummy function
for now (I prefer the former).

-- 
Catalin
