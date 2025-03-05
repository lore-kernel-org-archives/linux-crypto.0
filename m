Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4A524C07D;
	Wed,  5 Mar 2025 17:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741196367; cv=none; b=ZbY/+oX3hREoNUKDiolaLXTrWZO2/qGNA2YDrN2xPyQuh6UEH1xdYXs00IYXBBh22GLIdDr6PYJGExIDMdewdvbzT07BxUX65mI/QLG88pEHwwty9kIe1rbU8bTATPBfpDNql8GT8WnqLKiR8FKFxhpG5tBEpaiW6SQ99zM6Z0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741196367; c=relaxed/simple;
	bh=iaeOPT3vWx4E9oqHe4PhquvgcNeLALdwpOkdZJgJZIA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YfyVHZFHJ8abhHw07fj/UT3fJwJEOVSngcsEclBLOHHsaXcomKKmjbr0At4ee4IkLxSqneh3V1K8IzfHSIxsjWJlnC663LVnX5F5hYR4R2L8UkIfCGkl5GvltwpgPUMZdi8DGDY2Ayb/XMw9hwcixB4EVEduWmq4nSAwcjZ5QcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cru5nLgz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cru5nLgz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2778C4CEE0;
	Wed,  5 Mar 2025 17:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741196367;
	bh=iaeOPT3vWx4E9oqHe4PhquvgcNeLALdwpOkdZJgJZIA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cru5nLgzCC41CtNsmq/VbBtRtMqeCAwKBACMCgiJCwoClPE+Hc9+6s0kbh7R3682V
	 0fAOSB0eBQkuI394JE293mpcC103S2AxueaMdcUSRvQDpl/snTsdBGfq0amlh/b2fe
	 IjpL3BBJqjcDe7Lp6kmkD94YLGeXKtxvBP+zBsmwl3xzejcKGFyAiLuypNKcXtY6ib
	 EozP3+79T4BYxdN2Zzy+DO2OSEm2kBbUABJdjriGcKLRgCdf26Y4kRxee4tu6t4zyo
	 QSOfrfOJAkK7zzX2Vh6ssHgOBgWavTciyM3FxYvUcibTNbPWjl1QyuvKT+5UDdmuYr
	 JUiCCzW+wPtYQ==
Date: Wed, 5 Mar 2025 17:39:25 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: x86@kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Xiao Liang <shaw.leon@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: Re: [RFC PATCH v2] x86/fpu: make kernel-mode FPU reliably usable in
 softirqs
Message-ID: <20250305173925.GA4014401@google.com>
References: <20250304204954.3901-1-ebiggers@kernel.org>
 <Z8gUYamgBr4M5ZaB@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8gUYamgBr4M5ZaB@gmail.com>

On Wed, Mar 05, 2025 at 10:07:45AM +0100, Ingo Molnar wrote:
> 
> * Eric Biggers <ebiggers@kernel.org> wrote:
> 
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Currently kernel-mode FPU is not always usable in softirq context on
> > x86, since softirqs can nest inside a kernel-mode FPU section in task
> > context, and nested use of kernel-mode FPU is not supported.
> > 
> > Therefore, x86 SIMD-optimized code that can be called in softirq context
> > has to sometimes fall back to non-SIMD code.  There are two options for
> > the fallback, both of which are pretty terrible:
> > 
> >   (a) Use a scalar fallback.  This can be 10-100x slower than vectorized
> >       code because it cannot use specialized instructions like AES, SHA,
> >       or carryless multiplication.
> > 
> >   (b) Execute the request asynchronously using a kworker.  In other
> >       words, use the "crypto SIMD helper" in crypto/simd.c.
> > 
> > Currently most of the x86 en/decryption code (skcipher and aead
> > algorithms) uses option (b), since this avoids the slow scalar fallback
> > and it is easier to wire up.  But option (b) is still really bad for its
> > own reasons:
> > 
> >   - Punting the request to a kworker is bad for performance too.
> >
> >   - It forces the algorithm to be marked as asynchronous
> >     (CRYPTO_ALG_ASYNC), preventing it from being used by crypto API
> >     users who request a synchronous algorithm.  That's another huge
> >     performance problem, which is especially unfortunate for users who
> >     don't even do en/decryption in softirq context.
> > 
> >   - It makes all en/decryption operations take a detour through
> >     crypto/simd.c.  That involves additional checks and an additional
> >     indirect call, which slow down en/decryption for *everyone*.
> > 
> > Fortunately, the skcipher and aead APIs are only usable in task and 
> > softirq context in the first place.  Thus, if kernel-mode FPU were to 
> > be reliably usable in softirq context, no fallback would be needed. 
> > Indeed, other architectures such as arm, arm64, and riscv have 
> > already done this.
> > 
> > Therefore, this patch updates x86 accordingly to reliably support
> > kernel-mode FPU in softirqs.
> > 
> > This is done by just disabling softirq processing in kernel-mode FPU
> > sections (when hardirqs are not already disabled), as that prevents the
> > nesting that was problematic.
> > 
> > This will delay some softirqs slightly, but only ones that would have
> > otherwise been nested inside a task context kernel-mode FPU section.
> > Any such softirqs would have taken the slow fallback path before if they
> > tried to do any en/decryption.  Now these softirqs will just run at the
> > end of the task context kernel-mode FPU section (since local_bh_enable()
> > runs pending softirqs) and will no longer take the slow fallback path.
> > 
> > Alternatives considered:
> > 
> > - Make kernel-mode FPU sections fully preemptible.  This would require
> >   growing task_struct by another struct fpstate which is more than 2K.
> 
> So that's something that will probably happen once the kernel is built 
> using APX anyway?

The APX state is just 16 GPRs, for 128 bytes total.  That's about 5% of the size
of the fpstate (assuming AVX512 is supported).  As Dave mentioned, for in-kernel
use of APX it probably will make more sense to treat the new GPRs like the
existing ones, instead of using XSTATE and integrating it with kernel-mode FPU.
I.e., they will be saved/restored using plain moves to/from a dedicated buffer.

> 
> > - Make softirqs save/restore the kernel-mode FPU state to a per-CPU
> >   struct fpstate when nested use is detected.  Somewhat interesting, but
> >   seems unnecessary when a simpler solution exists.
> 
> So:
> 
> >  void kernel_fpu_begin_mask(unsigned int kfpu_mask)
> >  {
> > -	preempt_disable();
> > +	if (!irqs_disabled())
> > +		fpregs_lock();
> 
> > +	if (!irqs_disabled())
> > +		fpregs_unlock();
> 
> So why is the irqs_disabled() check needed here? (On x86 it can be a 
> bit expensive at times, because the IRQ flag has to be loaded, 
> including all flags, so basically it's a soft synchronization point of 
> a sort.)
> 
> Ie. why cannot we simply do a local_bh_disable()/enable() pair (on 
> !RT), ie. fpregs_lock()/fpregs_unlock()?
> 
> local_bh_disable() is very similar in cost to preempt_disable(), both 
> are increasing the preempt_count.

It's to keep kernel_fpu_begin()/end() working when hardirqs are disabled, since
local_bh_disable()/enable() require that hardirqs be enabled.  See the changelog
and https://lore.kernel.org/r/20250228035924.GC5588@sol.localdomain/.  There are
other directions we could go, but this seems to be the simplest solution.  If we
forbid kernel_fpu_begin() with hardirqs disabled (as PS1 did), then a call to
irqs_disabled() is still needed in irq_fpu_usable().  To avoid irqs_disabled()
entirely, we'd need to avoid disabling softirqs, which would mean supporting
nested kernel-mode FPU in softirqs.  I can sent out a patch that does that using
a per-CPU buffer, if you'd like to see that.  I wasn't super happy with the
extra edge cases and memory usage, but we could go in that direction.

- Eric
