Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A88E125B2;
	Fri, 28 Feb 2025 02:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740708538; cv=none; b=Q6l+ZhUS/YIT6B1DVLtD51pUwUvfy6ym0TcvlydRL8NZUC0Gu03Cq4KL1vDEOeZoIVtMiB0Jbj+j3Eeg3+WaEiOuoD5BLRlMinnSfNbn2VUne/dNmEXRW43EI1Tmt3qjT0gWJXRpoofjvut3vnnxdvtxth3AzqU/MQ8UGhHoLiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740708538; c=relaxed/simple;
	bh=5pr8uhB5SExy3iDSiDu9M//1Qd4Bg7ELhoDwqC9I9t4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pn2hpnZL2rOqh9EhPq/1t1f72wRPA7PLwMGvMkZq+k4/EZn1Z53r/MkNYHMi1/aqOIvi1bCi7EujY6hkea2xxVRzgItxaXDFPJRMrTG2jT4CCV7dRQnGqDx4cboBwTN2yM4YcIaYaq/eLWxSZVUjmduJqWLgexA11WL+8FgWZs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dBZ7fC++; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dBZ7fC++"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F52CC4CEE9;
	Fri, 28 Feb 2025 02:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740708537;
	bh=5pr8uhB5SExy3iDSiDu9M//1Qd4Bg7ELhoDwqC9I9t4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dBZ7fC++U6uUckHrv/9YRCdMjwAi3rZPzwMkhwFTh4J42qa/ywvHDdKubIDBWArjk
	 cycrsE/IGkX2tjEuSi0ew04SIVU7+lE1V8ztOZU9osSXFnoQnx6HsO7B9QlrKV/Vfp
	 ioYuk6l9HCCstmqFJNaE1b+GjL1AhI4pKJ6UWNseFaEPawhgjnmCf6Rwhb4YS+wiQB
	 Udp0OeYe5/V2DFKMtdIWEr6tFPdrFu7c4WDq9OBc9Xw9l/LF3F5gzKG858UvO1UD3b
	 QR7y1A+t2SZkaF6L3FfsGFixAGm62Jr9ieRgi6jARcqYPNAijugKvYZzrl2vao88VX
	 RK4VR5A+FF8kw==
Date: Thu, 27 Feb 2025 18:08:55 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Bill Wendling <morbo@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Justin Stitt <justinstitt@google.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
	clang-built-linux <llvm@lists.linux.dev>
Subject: Re: [PATCH] x86/crc32: use builtins to improve code generation
Message-ID: <20250228020855.GA5588@sol.localdomain>
References: <CAGG=3QVi27WRYVxmsk9+HLpJw9ZJrpfLjU8G4exuXm-vUA-KqQ@mail.gmail.com>
 <20250227062859.GA2506@sol.localdomain>
 <CAGG=3QVitM-AwqtYF0QjxpBV7Q8bqv59Os+jELFRUKMnRS9OGA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGG=3QVitM-AwqtYF0QjxpBV7Q8bqv59Os+jELFRUKMnRS9OGA@mail.gmail.com>

On Wed, Feb 26, 2025 at 11:08:22PM -0800, Bill Wendling wrote:
> > Doesn't this technically allow the compiler to insert CRC32 instructions
> > anywhere in arch/x86/ without the needed runtime CPU feature check?  Normally
> > when using intrinsics it's necessary to limit the scope of the feature
> > enablement to match the runtime CPU feature check that is done, e.g. by using
> > the target function attribute.
> >
> I'm not sure if CRC32 instructions will automatically be inserted when
> not explicitly called, especially since the other vector features are
> disabled. I wanted to limit enabling this flag for only crc32-glue.c,
> but my Makefile-fu failed me. The file appears to be compiled twice.
> But adding __attribute__((target("crc32"))) to the function would be
> much better.

Technically, limiting it to crc32-glue.c still isn't enough, as much of the code
in that file is executed before the crc32 instruction support is checked for.

I also noticed that -mcrc32 support wasn't added to clang until clang 14, by
https://github.com/llvm/llvm-project/commit/12fa608af44a80de8b655a8a984cd095908e7e80
But according to https://docs.kernel.org/process/changes.html the minimum clang
version to build Linux is 13.0.1.  So there's a missing check for support.

> > Do both gcc and clang consider these builtins to be a stable API, or do they
> > only guarantee the stability of _mm_crc32_*() from immintrin.h?  At least for
> > the rest of the SSE and AVX stuff, I thought that only the immintrin.h functions
> > are actually considered stable.
> >
> I don't know the answer for this. In general, once we (Clang) create a
> __builtin_* function it's not going away, because it will break anyone
> who uses them. (I assume the same is true for GCC.)

Here are examples of LLVM commits that removed x86 builtins:

* https://github.com/llvm/llvm-project/commit/09857a4bd166ca62a9610629731dfbf8f62cd955
* https://github.com/llvm/llvm-project/commit/9a14c369c422b244db78f1a9f947a891a75d912f
* https://github.com/llvm/llvm-project/commit/ec6024d0811b3116e0a29481b01179d5081a3b92
* https://github.com/llvm/llvm-project/commit/e4074432d5bf5c295f96eeed27c5b693f5b3bf16
* https://github.com/llvm/llvm-project/commit/9fddc3fd00b3ad5df5a3988e5cc4708254976173

So no, they do not appear to be considered stable.

(The equivalents in immintrin.h are stable, but good luck including immintrin.h
in the Linux kernel, since it depends on stdlib.h.)

Of course, if we really wanted this we could go with "it works in practice"
anyway.  But, given the small benefit of this patch vs. the potential risk I
don't think we should bother with it, unless it's acked by the gcc and clang
folks on the following points:

* The crc32 builtins are stable.

* gcc and clang will never generate crc32 instructions without explicitly using
  the builtins.  (BTW, keep in mind this ongoing work:
  https://gcc.gnu.org/wiki/cauldron2023talks?action=AttachFile&do=get&target=GCC+CRC+optimization.pdf)

Also note that crc32c_arch() already calls into the assembly code in
arch/x86/lib/crc32c-3way.S to handle lengths >= 512 bytes, and for handling the
tail data that assembly function already has a nice qword-at-a-time loop which
is exactly what we are trying to generate here.  A more promising approach might
be to reorganize things a bit so that we can reuse that assembly code.

- Eric
