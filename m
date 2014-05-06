From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH resend 02/15] arm64: add abstractions for FPSIMD state
 manipulation
Date: Tue, 6 May 2014 16:42:44 +0100
Message-ID: <20140506154244.GH23957@arm.com>
References: <1398959381-8126-1-git-send-email-ard.biesheuvel@linaro.org>
 <1398959381-8126-3-git-send-email-ard.biesheuvel@linaro.org>
 <20140506144340.GE23957@arm.com>
 <CAKv+Gu_3876kGtFOauLK4Uz=-74aSGq4a-m=9MmsVVzgsdYG3g@mail.gmail.com>
 <20140506151255.GF23957@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Will Deacon <Will.Deacon@arm.com>,
	"steve.capper@linaro.org" <steve.capper@linaro.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:30211 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752018AbaEFPna (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 6 May 2014 11:43:30 -0400
Content-Disposition: inline
In-Reply-To: <20140506151255.GF23957@arm.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 06, 2014 at 04:12:55PM +0100, Catalin Marinas wrote:
> On Tue, May 06, 2014 at 03:48:08PM +0100, Ard Biesheuvel wrote:
> > On 6 May 2014 16:43, Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > On Thu, May 01, 2014 at 04:49:34PM +0100, Ard Biesheuvel wrote:
> > >> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> > >> index 4aef42a04bdc..86ac6a9bc86a 100644
> > >> --- a/arch/arm64/kernel/fpsimd.c
> > >> +++ b/arch/arm64/kernel/fpsimd.c
> > >> @@ -87,6 +87,39 @@ void fpsimd_flush_thread(void)
> > >>       preempt_enable();
> > >>  }
> > >>
> > >> +/*
> > >> + * Save the userland FPSIMD state of 'current' to memory
> > >> + */
> > >> +void fpsimd_preserve_current_state(void)
> > >> +{
> > >> +     fpsimd_save_state(&current->thread.fpsimd_state);
> > >> +}
> > >> +
> > >> +/*
> > >> + * Load the userland FPSIMD state of 'current' from memory
> > >> + */
> > >> +void fpsimd_restore_current_state(void)
> > >> +{
> > >> +     fpsimd_load_state(&current->thread.fpsimd_state);
> > >> +}
> > >> +
> > >> +/*
> > >> + * Load an updated userland FPSIMD state for 'current' from memory
> > >> + */
> > >> +void fpsimd_update_current_state(struct fpsimd_state *state)
> > >> +{
> > >> +     preempt_disable();
> > >> +     fpsimd_load_state(state);
> > >> +     preempt_enable();
> > >> +}
> > >
> > > Minor - please update the comment above the functions to state that
> > > preemption needs to be disabled by the caller.
> > >
> > 
> > Do you mean in all three cases? And, by implication, that the
> > preempt_disable()/enable() pair should be moved to the call site for
> > fpsimd_update_current_state() ?
> 
> No, just the comment for the first two functions updated.

I noticed in a subsequent patch that you add preempt_disable/enable
already in the first two functions. You could do it here as well to
avoid confusion (and no need to update the comment).

-- 
Catalin
