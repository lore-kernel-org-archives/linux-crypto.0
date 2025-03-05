Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C590250BFB;
	Wed,  5 Mar 2025 18:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198161; cv=none; b=bc0jB4MYWkueolZ1uHroOAs0fFfhMlVMxBKkMOKJlE9rz7Mr6xrzRqm+YOjLIqw01+t6srdgq5zGhSiFaST6wjBNt6QPhhBe3RoQtW8o+1oknZQdvHT6NuypXwHPsYxL5VlL/XPIij756cjzWd5F3eQ3fBFSvXYK13OBjUiszPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198161; c=relaxed/simple;
	bh=oeVPPtAkF5XsxcuqQq+IuEcBjTXTE3uXU50UnbyM9ZE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Auhqx0YHJNpd5kTeeF7/x8uZTN3Z7cESuPgfhRjWNHKhnBOy4Z/g7zrl8geCVP5wAQOXTUdvOvyOvuwQqL3UuH4Xh7h3HqlryuT0936MMfGYTo5geDeHRCY0sJZ1T+yzwt7bFPKSyNp1LsFym42JjDzJgkzduWm287N39Gjkyak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pPyBRyDA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pPyBRyDA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0DDDC4CED1;
	Wed,  5 Mar 2025 18:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741198160;
	bh=oeVPPtAkF5XsxcuqQq+IuEcBjTXTE3uXU50UnbyM9ZE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pPyBRyDAkIXQXhpUBf+hyVx/3dIAPIu53PddmdMpJfpA8TpYA1mYCXKwVOzouZqS0
	 Rhj3BvnXmbNPU/Ha7bDhOgsRUdBX5OH7NRyzz45fVjFD35EPprEYeif46cFKU3TKtv
	 QsnNzQbMrLHAznnvczT1p465mc/2RdteLniTtfrn5VjlVX4go9sCopNg2PfzVL2Hft
	 u2LxmEnUxe9J56lHGEauJIFoa6VQH1klXwG3MfpzZ/BaD7jTo2w/qFWA1EevTz49e0
	 kAOjqWL3BR96Yw5T9fTBxcDGYuqfxB/lop6DEIa13BCnr+kioNykXeVm0hCQ29+ndy
	 uaiDqRQ3TPifg==
Date: Wed, 5 Mar 2025 19:09:15 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: x86@kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Xiao Liang <shaw.leon@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH v2] x86/fpu: make kernel-mode FPU reliably usable in
 softirqs
Message-ID: <Z8iTSzfzrFLv-JBL@gmail.com>
References: <20250304204954.3901-1-ebiggers@kernel.org>
 <Z8gUYamgBr4M5ZaB@gmail.com>
 <20250305173925.GA4014401@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250305173925.GA4014401@google.com>


* Eric Biggers <ebiggers@kernel.org> wrote:

> [...] To avoid irqs_disabled() entirely, we'd need to avoid disabling 
> softirqs, which would mean supporting nested kernel-mode FPU in 
> softirqs.  I can sent out a patch that does that using a per-CPU 
> buffer, if you'd like to see that.  I wasn't super happy with the 
> extra edge cases and memory usage, but we could go in that direction.

Meh: so I just checked, and local_bh_disable()/enable() are pretty 
heavy these days - it's not just a simple preempt-count twiddle and a 
check anymore. :-/ I don't think my initial argument of irqs_disabled() 
overhead is really valid - and if we really cared we could halve it by 
saving the irqs_disabled() status at kernel_fpu_begin() time and 
reading it at kernel_fpu_end() time.

And the alternative of having nested FPU usage and extra per-CPU FPU 
save areas for the kernel feels a bit fragile, even without having seen 
the patch.

So I think I'll commit your patch to tip:x86/fpu as-is, unless someone 
objects.


BTW., a side note, I was also reviewing the kernel_fpu_begin()/end() 
codepaths, and we have gems like:

        /* Put sane initial values into the control registers. */
        if (likely(kfpu_mask & KFPU_MXCSR) && boot_cpu_has(X86_FEATURE_XMM))
                ldmxcsr(MXCSR_DEFAULT);

        if (unlikely(kfpu_mask & KFPU_387) && boot_cpu_has(X86_FEATURE_FPU))
                asm volatile ("fninit");

has the LDMXCSR instruction, or its effects, ever shown up in profiles?

Because AFAICS these will execute all the time on x86-64, because:

static inline void kernel_fpu_begin(void)
{
#ifdef CONFIG_X86_64
        /*
         * Any 64-bit code that uses 387 instructions must explicitly request
         * KFPU_387.
         */
        kernel_fpu_begin_mask(KFPU_MXCSR);

And X86_FEATURE_XMM is set in pretty much every x86 CPU.

Thanks,

	Ingo
