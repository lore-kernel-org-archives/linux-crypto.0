Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13FC01C860C;
	Tue, 25 Feb 2025 22:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740524375; cv=none; b=Jz1To4dvbgPqL2CFII4IEkBYCH0uxtCSZR0ARiBbHLQlgRNLqSyITiCZVfcIoRx5gp/n+ISuMiytiojaP7oo+N7T5QZ5Hs03mif2dm9X0D/GYyz30uzZpKy0pKNGSb+thbkBzVdDXiR6rs52rmIBOGx9L6tC0ZCRkP/Dm4hngy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740524375; c=relaxed/simple;
	bh=UutXvj5xcObwy2bXzQ6fauT5FEVlvk2zdLl/xwmVg00=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AGdjQ3SZ2V2fdXLwZzzw7t9p63nyNKxZhApg07i3kenCjw5AIpvUa3uVxzQUqF1ZNlC7JtZuOeh3ec+IdLydaV1ki9kN3EopOOoS8XpEYSdSg7XeLIf4PoOrHHY9RQHhbZzNuy+2h/Rmuxsr4+QHPXScdXuGbSjR8en+VY1T0Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rEh04ANg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rEh04ANg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 555A3C4CEDD;
	Tue, 25 Feb 2025 22:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740524374;
	bh=UutXvj5xcObwy2bXzQ6fauT5FEVlvk2zdLl/xwmVg00=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rEh04ANgrCejG70O9NFdPZdOC5Gt8H+W3ZDZBQKufLa/XY0HD4RUhBJxqoaE3clLC
	 GFEf1wzF5vKHI669T5uC6Ir1XjLQvcLFwC9jA+narvdPkYlFy03JzVKA5rGPfXk9bP
	 ls8WU47uZKYtklajeWa+kfWUaw0V17LHhzU9Psr1qDCAeE7a93WrLl39u7f0BqjTi5
	 vJzlTA9VehJ9ZpOYpCQGvVe1jtyijnELp4Kl/O9pJAmMO+I24e1DR/jCybEhHorpsU
	 tOsOv5g+eq0gXI8cmQ7Y+tFbi5/NWZKLas2XswoovAxLnsjBtTPO8pfkOlra+JBLS1
	 YegVcvR1QM0pA==
Date: Tue, 25 Feb 2025 22:59:32 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: Xiao Liang <shaw.leon@gmail.com>, x86@kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>
Subject: Re: [RFC PATCH 1/2] x86/fpu: make kernel-mode FPU reliably usable in
 softirqs
Message-ID: <20250225225932.GA2975818@google.com>
References: <20250220051325.340691-1-ebiggers@kernel.org>
 <20250220051325.340691-2-ebiggers@kernel.org>
 <CABAhCOQjnSsos3gm4GWrxFUdV8dw-=r_mMn0+xdjnZjJ0PQ9MA@mail.gmail.com>
 <20250221193124.GA3790599@google.com>
 <20250225222133.395f7194@pumpkin>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250225222133.395f7194@pumpkin>

On Tue, Feb 25, 2025 at 10:21:33PM +0000, David Laight wrote:
> > As for supporting nested kernel-mode FPU if we wanted to go that way: yes, your
> > patch from last year
> > https://lore.kernel.org/lkml/20240403140138.393825-1-shaw.leon@gmail.com/
> > ostensibly did that.  However, I found some bugs in it; e.g., it didn't take
> > into account that struct fpu is variable-length.  So it didn't turn out as
> > simple as that patch made it seem.  Just extending fpregs_{lock,unlock}() to
> > kernel-mode FPU is a simpler solution with fewer edge cases, and it avoids
> > increasing the memory usage of the kernel.  So I thought I'd propose that first.
> 
> Since many kernel users don't want the traditional fpu, they just need to use
> an instruction that requires an AVX register or two, is it possible for code
> to specify a small save area for just two or four registers and then use just
> those registers? (so treating then all as caller-saved).
> I know that won't work with anything that affects the fpu status register,
> but if you want a single wide register for a PCIe read (to generate a big TLP)
> it is more than enough.
> 
> I'm sure there are horrid pitfalls, especially if IPI are still used to for
> deferred save of fpu state.

I'm afraid that's not an accurate summary of what uses the vector registers in
kernel mode.  The main use case is crypto, and most of the crypto code uses a
lot of vector registers.  Some of the older crypto code uses at most 8 vector
registers (xmm0-xmm7) for 32-bit compatibility, but newer code uses 16 or even
up to 32 YMM or ZMM registers.  The new AES-GCM code for example uses all 32
vector registers, and the new AES-XTS code uses 30.

In general, taking full advantage of the vector register set improves
performance, and the trend has very much been towards using more registers --
not fewer.  (And the registers have been getting larger too!)  AES by itself
tends to need about 8 registers to take advantage of the CPU's full AES
throughput, but there are other computations like GHASH or tweak computation
that need to be interleaved with AES, using more registers.  And various
constants and round keys can be cached in registers to improve performance.

If we had to save/restore a large number of vector registers in every crypto
function call (not amortized to one save/restore per return to userspace), that
would be a big performance problem.

Most of the crypto code certainly could be written to use fewer registers.  But
it would reduce performance, especially if we tried to squeeze it down to use a
really small number of registers like 2-4.  Plus any such efforts would
complicate efforts to port crypto code between the kernel and userspace, as
userspace does not have such constraints on the number of registers.

- Eric
