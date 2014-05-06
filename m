From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH resend 03/15] arm64: defer reloading a task's FPSIMD
 state to userland resume
Date: Tue, 6 May 2014 17:31:33 +0100
Message-ID: <20140506163133.GJ23957@arm.com>
References: <1398959381-8126-1-git-send-email-ard.biesheuvel@linaro.org>
 <1398959381-8126-4-git-send-email-ard.biesheuvel@linaro.org>
 <20140506160826.GI23957@arm.com>
 <CAKv+Gu9ogEHb6rOT6KgPMDXjTwR5Krz0s7pkiaW_7vtZipu2Hw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Will Deacon <Will.Deacon@arm.com>,
	"steve.capper@linaro.org" <steve.capper@linaro.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:17809 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751963AbaEFQcK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 6 May 2014 12:32:10 -0400
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9ogEHb6rOT6KgPMDXjTwR5Krz0s7pkiaW_7vtZipu2Hw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 06, 2014 at 05:25:14PM +0100, Ard Biesheuvel wrote:
> On 6 May 2014 18:08, Catalin Marinas <catalin.marinas@arm.com> wrote:
> > On Thu, May 01, 2014 at 04:49:35PM +0100, Ard Biesheuvel wrote:
> >> @@ -153,12 +252,11 @@ static int fpsimd_cpu_pm_notifier(struct notifier_block *self,
> >>  {
> >>         switch (cmd) {
> >>         case CPU_PM_ENTER:
> >> -               if (current->mm)
> >> +               if (current->mm && !test_thread_flag(TIF_FOREIGN_FPSTATE))
> >>                         fpsimd_save_state(&current->thread.fpsimd_state);
> >>                 break;
> >>         case CPU_PM_EXIT:
> >> -               if (current->mm)
> >> -                       fpsimd_load_state(&current->thread.fpsimd_state);
> >> +               set_thread_flag(TIF_FOREIGN_FPSTATE);
> >
> > I think we could enter a PM state on a kernel thread (idle), so we
> > should preserve the current->mm check as well.
> 
> OK
> 
> >>                 break;
> >>         case CPU_PM_ENTER_FAILED:
> >>         default:
> >> diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
> >> index 06448a77ff53..882f01774365 100644
> >> --- a/arch/arm64/kernel/signal.c
> >> +++ b/arch/arm64/kernel/signal.c
> >> @@ -413,4 +413,8 @@ asmlinkage void do_notify_resume(struct pt_regs *regs,
> >>                 clear_thread_flag(TIF_NOTIFY_RESUME);
> >>                 tracehook_notify_resume(regs);
> >>         }
> >> +
> >> +       if (thread_flags & _TIF_FOREIGN_FPSTATE)
> >> +               fpsimd_restore_current_state();
> >
> > I think this should be safe. Even if we get preempted here, ret_to_user
> > would loop over TI_FLAGS with interrupts disabled until no work pending.
> 
> I don't follow. Do you think I should change something here?

No, I think it's safe (just thinking out loud). That's assuming
TIF_FOREIGN_FPSTATE is never set in interrupt context but a brief look
at subsequent patch shows that it doesn't.

> Anyway, inside fpsimd_restore_current_state() the TIF_FOREIGN_FPSTATE
> is checked again, but this time with preemption disabled.

Yes. I was thinking about the scenario where we get to
do_notify_resume() because of other work but with TIF_FOREIGN_FPSTATE
cleared. In the meantime, we get preempted and TIF_FOREIGN_FPSTATE gets
set when switching back to this thread. In this case, ret_to_user loops
again over TI_FLAGS.

-- 
Catalin
