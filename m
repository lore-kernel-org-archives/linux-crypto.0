Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FF41DDD1;
	Thu, 27 Feb 2025 06:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740637741; cv=none; b=ARJrqcIeltP6y5GBy5Kmx1DG8yIe7Xq+afCt0JK6fK0qm4M81RocfO7nGdvpEjJCYJP2jaS+KwIN3Cstukt5WvwElpOd1M3PSd63Rahw87z4Zwa4qnAxijzHvBGOs6l4ZD0q0NK0e1yv+fEzYK4aUcPykFmIvJ6sGrTBun6R/s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740637741; c=relaxed/simple;
	bh=QBDFXX+2NJk1bzymlEzaxP+sRTrLVruQgJ8E8hJbcW0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VzNyVLepKxDYLLy6nd21MEC/fZU2thrLDYljd9pXHi9R8C6V096RY2QXS7oiNz/3v1aGWYkEKevIlcKQj6Op+hRM3o7FGQmjwsfkJoACOwhJfdquikL3KDsaWoZqICX42DtUK3n3QwlpJFBb2PWc329aBix6GzLwwzW8gPf5Np4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TTgJLigd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TTgJLigd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6886C4CEDD;
	Thu, 27 Feb 2025 06:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740637741;
	bh=QBDFXX+2NJk1bzymlEzaxP+sRTrLVruQgJ8E8hJbcW0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TTgJLigdjKKMH+/1gJ9LbifYx8vzJYelp5fs4bj+EwNfboVlPiY3tefGRXxkhS3Ft
	 bMtWTkKI4aR7unN/SaBkrk2P9JfOJmJd7ySEgqJ6PVuORXtCPgO0q4BpVmAZZ/io0E
	 U7XTboTQUgulb7GH2AUnM/PT+/lNkKXUm+x7z7LXsP3ZUwO34GiFNqU6i8Wlp4dUct
	 eRuoxdf1LuUs6Lk9JbFOvnqGtJls2BdWMnIJmcYl2woUdkoHk/EvGPzWh0+P7qzZPC
	 +EfK8j6lTN0XUHhWYRWzBToNpP8RihSrYpKx16HntlDLMzY2I4/c7n2+g0kT10QqnS
	 s7tlXPcTa2CQg==
Date: Wed, 26 Feb 2025 22:28:59 -0800
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
Message-ID: <20250227062859.GA2506@sol.localdomain>
References: <CAGG=3QVi27WRYVxmsk9+HLpJw9ZJrpfLjU8G4exuXm-vUA-KqQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGG=3QVi27WRYVxmsk9+HLpJw9ZJrpfLjU8G4exuXm-vUA-KqQ@mail.gmail.com>

On Wed, Feb 26, 2025 at 10:12:47PM -0800, Bill Wendling wrote:
> For both gcc and clang, crc32 builtins generate better code than the
> inline asm. GCC improves, removing unneeded "mov" instructions. Clang
> does the same and unrolls the loops. GCC has no changes on i386, but
> Clang's code generation is vastly improved, due to Clang's "rm"
> constraint issue.
> 
> The number of cycles improved by ~0.1% for GCC and ~1% for Clang, which
> is expected because of the "rm" issue. However, Clang's performance is
> better than GCC's by ~1.5%, most likely due to loop unrolling.
> 
> Link: https://github.com/llvm/llvm-project/issues/20571#issuecomment-2649330009
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: x86@kernel.org
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: Nathan Chancellor <nathan@kernel.org>
> Cc: Nick Desaulniers <nick.desaulniers+lkml@gmail.com>
> Cc: Justin Stitt <justinstitt@google.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-crypto@vger.kernel.org
> Cc: llvm@lists.linux.dev
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
>  arch/x86/Makefile         | 3 +++
>  arch/x86/lib/crc32-glue.c | 8 ++++----
>  2 files changed, 7 insertions(+), 4 deletions(-)

Thanks!  A couple concerns, though:

> diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> index 5b773b34768d..241436da1473 100644
> --- a/arch/x86/Makefile
> +++ b/arch/x86/Makefile
> @@ -114,6 +114,9 @@ else
>  KBUILD_CFLAGS += $(call cc-option,-fcf-protection=none)
>  endif
> 
> +# Enables the use of CRC32 builtins.
> +KBUILD_CFLAGS += -mcrc32

Doesn't this technically allow the compiler to insert CRC32 instructions
anywhere in arch/x86/ without the needed runtime CPU feature check?  Normally
when using intrinsics it's necessary to limit the scope of the feature
enablement to match the runtime CPU feature check that is done, e.g. by using
the target function attribute.

> diff --git a/arch/x86/lib/crc32-glue.c b/arch/x86/lib/crc32-glue.c
> index 2dd18a886ded..fdb94bff25f4 100644
> --- a/arch/x86/lib/crc32-glue.c
> +++ b/arch/x86/lib/crc32-glue.c
> @@ -48,9 +48,9 @@ u32 crc32_le_arch(u32 crc, const u8 *p, size_t len)
>  EXPORT_SYMBOL(crc32_le_arch);
> 
>  #ifdef CONFIG_X86_64
> -#define CRC32_INST "crc32q %1, %q0"
> +#define CRC32_INST __builtin_ia32_crc32di
>  #else
> -#define CRC32_INST "crc32l %1, %0"
> +#define CRC32_INST __builtin_ia32_crc32si
>  #endif

Do both gcc and clang consider these builtins to be a stable API, or do they
only guarantee the stability of _mm_crc32_*() from immintrin.h?  At least for
the rest of the SSE and AVX stuff, I thought that only the immintrin.h functions
are actually considered stable.

- Eric
