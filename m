From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH resend 03/15] arm64: defer reloading a task's FPSIMD
 state to userland resume
Date: Tue, 6 May 2014 17:08:26 +0100
Message-ID: <20140506160826.GI23957@arm.com>
References: <1398959381-8126-1-git-send-email-ard.biesheuvel@linaro.org>
 <1398959381-8126-4-git-send-email-ard.biesheuvel@linaro.org>
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
In-Reply-To: <1398959381-8126-4-git-send-email-ard.biesheuvel@linaro.org>
Content-Language: en-US
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

On Thu, May 01, 2014 at 04:49:35PM +0100, Ard Biesheuvel wrote:
> @@ -153,12 +252,11 @@ static int fpsimd_cpu_pm_notifier(struct notifier_block *self,
>  {
>         switch (cmd) {
>         case CPU_PM_ENTER:
> -               if (current->mm)
> +               if (current->mm && !test_thread_flag(TIF_FOREIGN_FPSTATE))
>                         fpsimd_save_state(&current->thread.fpsimd_state);
>                 break;
>         case CPU_PM_EXIT:
> -               if (current->mm)
> -                       fpsimd_load_state(&current->thread.fpsimd_state);
> +               set_thread_flag(TIF_FOREIGN_FPSTATE);

I think we could enter a PM state on a kernel thread (idle), so we
should preserve the current->mm check as well.

>                 break;
>         case CPU_PM_ENTER_FAILED:
>         default:
> diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
> index 06448a77ff53..882f01774365 100644
> --- a/arch/arm64/kernel/signal.c
> +++ b/arch/arm64/kernel/signal.c
> @@ -413,4 +413,8 @@ asmlinkage void do_notify_resume(struct pt_regs *regs,
>                 clear_thread_flag(TIF_NOTIFY_RESUME);
>                 tracehook_notify_resume(regs);
>         }
> +
> +       if (thread_flags & _TIF_FOREIGN_FPSTATE)
> +               fpsimd_restore_current_state();

I think this should be safe. Even if we get preempted here, ret_to_user
would loop over TI_FLAGS with interrupts disabled until no work pending.

-- 
Catalin
