From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH resend 02/15] arm64: add abstractions for FPSIMD state manipulation
Date: Tue, 6 May 2014 16:48:08 +0200
Message-ID: <CAKv+Gu_3876kGtFOauLK4Uz=-74aSGq4a-m=9MmsVVzgsdYG3g@mail.gmail.com>
References: <1398959381-8126-1-git-send-email-ard.biesheuvel@linaro.org>
	<1398959381-8126-3-git-send-email-ard.biesheuvel@linaro.org>
	<20140506144340.GE23957@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Will Deacon <Will.Deacon@arm.com>,
	"steve.capper@linaro.org" <steve.capper@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:37638 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757191AbaEFOsJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 6 May 2014 10:48:09 -0400
Received: by mail-lb0-f182.google.com with SMTP id q8so4400443lbi.13
        for <linux-crypto@vger.kernel.org>; Tue, 06 May 2014 07:48:08 -0700 (PDT)
In-Reply-To: <20140506144340.GE23957@arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 6 May 2014 16:43, Catalin Marinas <catalin.marinas@arm.com> wrote:
> On Thu, May 01, 2014 at 04:49:34PM +0100, Ard Biesheuvel wrote:
>> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
>> index 4aef42a04bdc..86ac6a9bc86a 100644
>> --- a/arch/arm64/kernel/fpsimd.c
>> +++ b/arch/arm64/kernel/fpsimd.c
>> @@ -87,6 +87,39 @@ void fpsimd_flush_thread(void)
>>       preempt_enable();
>>  }
>>
>> +/*
>> + * Save the userland FPSIMD state of 'current' to memory
>> + */
>> +void fpsimd_preserve_current_state(void)
>> +{
>> +     fpsimd_save_state(&current->thread.fpsimd_state);
>> +}
>> +
>> +/*
>> + * Load the userland FPSIMD state of 'current' from memory
>> + */
>> +void fpsimd_restore_current_state(void)
>> +{
>> +     fpsimd_load_state(&current->thread.fpsimd_state);
>> +}
>> +
>> +/*
>> + * Load an updated userland FPSIMD state for 'current' from memory
>> + */
>> +void fpsimd_update_current_state(struct fpsimd_state *state)
>> +{
>> +     preempt_disable();
>> +     fpsimd_load_state(state);
>> +     preempt_enable();
>> +}
>
> Minor - please update the comment above the functions to state that
> preemption needs to be disabled by the caller.
>

Do you mean in all three cases? And, by implication, that the
preempt_disable()/enable() pair should be moved to the call site for
fpsimd_update_current_state() ?


>> +/*
>> + * Invalidate live CPU copies of task t's FPSIMD state
>> + */
>> +void fpsimd_flush_task_state(struct task_struct *t)
>> +{
>> +}
>
> I guess this will be added in a subsequent patch. You could either move
> it there or add a comment in the commit log that it is a dummy function
> for now (I prefer the former).
>

OK

-- 
Ard.
