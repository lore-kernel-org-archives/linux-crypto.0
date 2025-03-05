Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17D120125B;
	Wed,  5 Mar 2025 09:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741165671; cv=none; b=KPYx3lA9qnbVRtbXGqvSVNfCNan3+ua7cJmTY9uZpyxn2ZXHcKMVKKpauP5HE8Kz0+N/nABNgEXJNwS9Y7D9dooyPRxHeTYVDD3+J/nQqubVFtZbFK3PpB7D4abn3MDqxDhg4V0ln1ap6CNuKterHY/7QVulW6mJB6ZAFXQoCFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741165671; c=relaxed/simple;
	bh=evaHuRhxtZRjWX5MGBy0lPYyEGPoTjJrpdnxioPwXZ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZOJD1+jlRZaSk1ho5SSxf7UjREn5W2PDM5Zx96+/RZfrD5UrVJ72rc4Di2NM/E45LlcKUGodjVtioKirGk27wDt0ZJumoWMmqS8wlfI0Lkdll5p6cCqI317h3AZJ6wY2O5iWhxHbCFQBe+MzbEyN4euj8n3HELdjOtUKndTHBJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hloeDu72; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hloeDu72"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8E0C4CEE2;
	Wed,  5 Mar 2025 09:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741165671;
	bh=evaHuRhxtZRjWX5MGBy0lPYyEGPoTjJrpdnxioPwXZ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hloeDu72eul/DbY0xRIn+odBy+uo1/RcQNjA23F5WPuX5Tgg0D0l6q/mdEctCCLkk
	 wS/+Ec9ze870/4ts0BI/THZx5RgHANdq19QVI1v3+C9NEZgG9AqvUnSfzy0ewoKhVo
	 BDjJhbT2jCqSM2l0jGTXWR9hzC06R1RlPpZnws4W/hsaFJtiVpl0Mv1lnY0e1eSvUU
	 /9io5XaRAlikFicGkQgz4XfW8RL7IkbxbPiaJPeIvRZtKV+EaIi2R+eHIk5mbGublq
	 gvpcxXTif5HXkQtK30+QTp36zO8neuCocyy7rB3d7PbhA4V3EpArJk26vC3EPnQvtA
	 v5Uy0JbjSG/Tw==
Date: Wed, 5 Mar 2025 10:07:45 +0100
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
	"Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: Re: [RFC PATCH v2] x86/fpu: make kernel-mode FPU reliably usable in
 softirqs
Message-ID: <Z8gUYamgBr4M5ZaB@gmail.com>
References: <20250304204954.3901-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250304204954.3901-1-ebiggers@kernel.org>


* Eric Biggers <ebiggers@kernel.org> wrote:

> From: Eric Biggers <ebiggers@google.com>
> 
> Currently kernel-mode FPU is not always usable in softirq context on
> x86, since softirqs can nest inside a kernel-mode FPU section in task
> context, and nested use of kernel-mode FPU is not supported.
> 
> Therefore, x86 SIMD-optimized code that can be called in softirq context
> has to sometimes fall back to non-SIMD code.  There are two options for
> the fallback, both of which are pretty terrible:
> 
>   (a) Use a scalar fallback.  This can be 10-100x slower than vectorized
>       code because it cannot use specialized instructions like AES, SHA,
>       or carryless multiplication.
> 
>   (b) Execute the request asynchronously using a kworker.  In other
>       words, use the "crypto SIMD helper" in crypto/simd.c.
> 
> Currently most of the x86 en/decryption code (skcipher and aead
> algorithms) uses option (b), since this avoids the slow scalar fallback
> and it is easier to wire up.  But option (b) is still really bad for its
> own reasons:
> 
>   - Punting the request to a kworker is bad for performance too.
>
>   - It forces the algorithm to be marked as asynchronous
>     (CRYPTO_ALG_ASYNC), preventing it from being used by crypto API
>     users who request a synchronous algorithm.  That's another huge
>     performance problem, which is especially unfortunate for users who
>     don't even do en/decryption in softirq context.
> 
>   - It makes all en/decryption operations take a detour through
>     crypto/simd.c.  That involves additional checks and an additional
>     indirect call, which slow down en/decryption for *everyone*.
> 
> Fortunately, the skcipher and aead APIs are only usable in task and 
> softirq context in the first place.  Thus, if kernel-mode FPU were to 
> be reliably usable in softirq context, no fallback would be needed. 
> Indeed, other architectures such as arm, arm64, and riscv have 
> already done this.
> 
> Therefore, this patch updates x86 accordingly to reliably support
> kernel-mode FPU in softirqs.
> 
> This is done by just disabling softirq processing in kernel-mode FPU
> sections (when hardirqs are not already disabled), as that prevents the
> nesting that was problematic.
> 
> This will delay some softirqs slightly, but only ones that would have
> otherwise been nested inside a task context kernel-mode FPU section.
> Any such softirqs would have taken the slow fallback path before if they
> tried to do any en/decryption.  Now these softirqs will just run at the
> end of the task context kernel-mode FPU section (since local_bh_enable()
> runs pending softirqs) and will no longer take the slow fallback path.
> 
> Alternatives considered:
> 
> - Make kernel-mode FPU sections fully preemptible.  This would require
>   growing task_struct by another struct fpstate which is more than 2K.

So that's something that will probably happen once the kernel is built 
using APX anyway?

> - Make softirqs save/restore the kernel-mode FPU state to a per-CPU
>   struct fpstate when nested use is detected.  Somewhat interesting, but
>   seems unnecessary when a simpler solution exists.

So:

>  void kernel_fpu_begin_mask(unsigned int kfpu_mask)
>  {
> -	preempt_disable();
> +	if (!irqs_disabled())
> +		fpregs_lock();

> +	if (!irqs_disabled())
> +		fpregs_unlock();

So why is the irqs_disabled() check needed here? (On x86 it can be a 
bit expensive at times, because the IRQ flag has to be loaded, 
including all flags, so basically it's a soft synchronization point of 
a sort.)

Ie. why cannot we simply do a local_bh_disable()/enable() pair (on 
!RT), ie. fpregs_lock()/fpregs_unlock()?

local_bh_disable() is very similar in cost to preempt_disable(), both 
are increasing the preempt_count.

Thanks,

	Ingo
