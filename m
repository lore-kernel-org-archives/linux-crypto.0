Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDBF1E3DF4;
	Fri, 21 Feb 2025 19:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740166286; cv=none; b=DWXUWLGl9Gky04kZKGZOkvPLre3ThgHCvixtEar1OaLQgKfGknvhHCRPBJuhrjKKmea2rPT9Xul3FaaempKS/xexxcHJ1vYhXo7PpIx6caL2cER9agrIPVgXf+5tJVdAwMJ949mfzRpG4EdU5Omz7OsQQU2e0MpdSMyu8kdkaCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740166286; c=relaxed/simple;
	bh=OcFmx+DsPBP5CqRzWFl002eCPcOUmr7GbAdpsEhzr4w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C9h/rTEUvLKTTu8OePmmku5wg9y0QW8suu+KkgTE0uOzEvBpv2Ic8tmlW72INo2y4OrwCQC80yVTtV+nSpTwBmC/0HVpZwC0yPdL9lm25ykPGkv57UKnswZKWniPvz4Upp4vjJt1x8J3fKmkgAe1RrtILj2a/xzjFZe+8MdaFo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M0HqZufP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M0HqZufP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C99C4CED6;
	Fri, 21 Feb 2025 19:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740166286;
	bh=OcFmx+DsPBP5CqRzWFl002eCPcOUmr7GbAdpsEhzr4w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M0HqZufPOadn2dlMyrgC+cPT1QIiGxdmxtdItYvN5wLf7ZACCOd4ZVS3GBJ5eypDc
	 PfMKJGJi+agSGEKxRHJBRxBz2SGoSmcc8bcyB3J5/TSqJdGsXlD2/RieFsSA5BtJzw
	 7LmvBSqtmwd/h3qs/mHpZDKF2bu8nV0ej2zzwmYlbcQcaHtgZ8PRuvYyaAmVPXuwxi
	 yQoSeWRBZhPrfUEdK3keQ3XcMHmQxt360P9rNbYOgqUBQ3mg2lEoNfU1Nnx/Mpap+l
	 E5o/SOcUJgG1upsxgN4UKtvZd11NDXecjRVs+2ZRrYrUlEFUx27rzPQAs4efy0PSdC
	 HuZJ2hvboIB8Q==
Date: Fri, 21 Feb 2025 19:31:24 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Xiao Liang <shaw.leon@gmail.com>
Cc: x86@kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: Re: [RFC PATCH 1/2] x86/fpu: make kernel-mode FPU reliably usable in
 softirqs
Message-ID: <20250221193124.GA3790599@google.com>
References: <20250220051325.340691-1-ebiggers@kernel.org>
 <20250220051325.340691-2-ebiggers@kernel.org>
 <CABAhCOQjnSsos3gm4GWrxFUdV8dw-=r_mMn0+xdjnZjJ0PQ9MA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABAhCOQjnSsos3gm4GWrxFUdV8dw-=r_mMn0+xdjnZjJ0PQ9MA@mail.gmail.com>

Hi Xiao,

On Fri, Feb 21, 2025 at 03:38:27PM +0800, Xiao Liang wrote:
> > Therefore, this patch updates x86 accordingly to reliably support
> > kernel-mode FPU in softirqs (except when hardirqs are disabled).
> >
> > This is done by just disabling softirq processing in kernel-mode FPU
> > sections, as that prevents the nesting that was problematic.
> >
> > This will delay some softirqs slightly, but only ones that would have
> > otherwise been nested inside a task context kernel-mode FPU section.
> > Any such softirqs would have taken the slow fallback path before if they
> > tried to do any en/decryption.  Now these softirqs will just run at the
> > end of the task context kernel-mode FPU section (since local_bh_enable()
> > runs pending softirqs) and will no longer take the slow fallback path.
> 
> I think this will delay all softirqs, including those that don't use
> FPU. Will there be a performance impact?
> (I guess you've noticed the patch I submitted last year. And this is
> the main reason why it was implemented in the way you mentioned as
> the second alternative.)

Thanks for taking a look at this patch!  It's true that this patch makes all
softirqs on the same CPU be delayed until the end of the current kernel-mode FPU
section.  But, I'm a bit skeptical that it actually matters enough on x86 to go
with a more complex solution that would allow nested kernel-mode FPU.
Kernel-mode FPU sections are generally short; the usual cases are en/decrypting
disk sectors or network packets that are 4 KiB or less.

Even if a longer buffer is passed in, most of the x86 SIMD-optimized code
already divides the buffer into chunks of at most 4 KiB and uses a separate
kernel-mode FPU section for each chunk.  This happens either explicitly, or
implicitly via the skcipher_walk_* functions which never return more than
PAGE_SIZE (i.e. 4 KiB on x86) in a single step.  There is some code that does
not do this, e.g. the CRC code, but that could easily be fixed.

The commonly-used x86 SIMD-optimized code is also super fast these days, and is
only getting faster.  For example, on an AMD desktop processor from this year I
get roughly 35 GB/s AES-256-XTS, 25 GB/s AES-256-GCM, or 80 GB/s any CRC,
courtesy of VAES and VPCLMULQDQ (measuring single-threaded throughput at max
frequency).  That works out to 50-165 nanoseconds per 4 KiB.  Increasingly these
algorithms can be thought of as similar to memcpy() in speed.

Of course, the worst case is probably about 100x slower -- consider a CPU that
is much older, and from a low-voltage product line (e.g. Intel Atom), and not
running at its max frequency, and computing a much slower crypto algorithm that
lacks hardware acceleration like Serpent-XTS, or even AES-something if the CPU
is so old (over 15 years) as to lack AES-NI.

But, the super slow crypto algorithms are becoming increasingly rare.  The
crypto algorithms in use these days tend to have hardware acceleration on x86
(via AES-NI, PCLMULQDQ, or SHA extensions) or at least be fast with SSE / AVX.

So while the worst case is likely about 20 microseconds on certain systems where
everything lines up the wrong way, realistically the worst case on most systems
based on what's actually being used is probably less than 1 microsecond.

That seems probably short enough to be acceptable?  Remember that preemption was
already being disabled during this time.  And this is only on one CPU.

I think it's also important to note that when local_bh_enable() re-enables
softirq processing (when called from kernel_fpu_end()), it also immediatelly
runs any pending softirqs.  Thus there would be no additional delay; the CPU
will *immediately* run any pending softirqs.

As for supporting nested kernel-mode FPU if we wanted to go that way: yes, your
patch from last year
https://lore.kernel.org/lkml/20240403140138.393825-1-shaw.leon@gmail.com/
ostensibly did that.  However, I found some bugs in it; e.g., it didn't take
into account that struct fpu is variable-length.  So it didn't turn out as
simple as that patch made it seem.  Just extending fpregs_{lock,unlock}() to
kernel-mode FPU is a simpler solution with fewer edge cases, and it avoids
increasing the memory usage of the kernel.  So I thought I'd propose that first.

- Eric
