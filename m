Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FE61CD205;
	Fri, 28 Feb 2025 21:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740777651; cv=none; b=s3YrASTnyyVe3Ra0qdg7mu7gTFTAD4PHemG8xDyJ4r3u33NUuQA2ItQ9MMVqDR8SXPE3X86Wa+pF+fM1xtygD1fNJHEQtCzXhKjVOcytKDzkTZYDhge6NWQsZXL7npTeXhkU/EljnepEQlui947YxgrbCgaTpNaE6SnfkwCvjJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740777651; c=relaxed/simple;
	bh=vsXStoKndBZgGgA0zp9Ln/iSvRo3BZ0cXSDsjvieCU0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jen5BCdCDjCuyInVUWWXroNbi+yhFSrK4HTnANP3Nor05OSt2ZDQMhT9QDPDHoL2l5aj3LYctGMyeONEkWuoAmWDANrtFnJ7kB8RBUDpYjeSCetbxppmOFrhme3g2gUC4Msgy987FCzcnz8c/WTuHbErnDciNnIRcV8xNKAK6mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J/QMUNUq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J/QMUNUq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6485CC4CEE2;
	Fri, 28 Feb 2025 21:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740777650;
	bh=vsXStoKndBZgGgA0zp9Ln/iSvRo3BZ0cXSDsjvieCU0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J/QMUNUqGSPaK18cqkfd3oe6cupTYH1ocioGJl2rLMSy6X4KoUN2cSi+iWXZq800e
	 tX1EsVETHnKVZmWs9kNBr5QOoIYda2+ntRBmnYSsLeaavGz+6l7oEY6YgqKYYXDjT6
	 08ZruDM5vCEcYZc42qUkZ9eYdn2KshsUE96DPL+qHOQzQlewfRSrMsFSPDQ/f2Fozd
	 xRN9nXuvEKrY15bLx17hTjdxJ8k0gLw55LAS9nIVFnkWF3W8sNTCwYVFIRPUvMmBj3
	 asndgY6FNrPnof0jY02CJcOaiYWJO9eeJcQGFDSHb3YYMPmHhZRP4O2QKAytxZcaF5
	 A0X/BaUaiAdXw==
Date: Fri, 28 Feb 2025 21:20:48 +0000
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
Subject: Re: [PATCH v2] x86/crc32: use builtins to improve code generation
Message-ID: <20250228212048.GA2812743@google.com>
References: <CAGG=3QVi27WRYVxmsk9+HLpJw9ZJrpfLjU8G4exuXm-vUA-KqQ@mail.gmail.com>
 <CAGG=3QVkd9Vb9a=pQ=KwhKzGJXaS+6Mk5K+JtBqamj15MzT9mQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGG=3QVkd9Vb9a=pQ=KwhKzGJXaS+6Mk5K+JtBqamj15MzT9mQ@mail.gmail.com>

On Thu, Feb 27, 2025 at 03:47:03PM -0800, Bill Wendling wrote:
> For both gcc and clang, crc32 builtins generate better code than the
> inline asm. GCC improves, removing unneeded "mov" instructions. Clang
> does the same and unrolls the loops. GCC has no changes on i386, but
> Clang's code generation is vastly improved, due to Clang's "rm"
> constraint issue.
> 
> The number of cycles improved by ~0.1% for GCC and ~1% for Clang, which
> is expected because of the "rm" issue. However, Clang's performance is
> better than GCC's by ~1.5%, most likely due to loop unrolling.

Also note that the patch
https://lore.kernel.org/r/20250210210741.471725-1-ebiggers@kernel.org/ (which is
already enqueued in the crc tree for 6.15) changes "rm" to "r" when the compiler
is clang, to improve clang's code generation.  The numbers you quote are against
the original version, right?

- Eric
