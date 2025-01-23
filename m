Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DEF13596B;
	Thu, 23 Jan 2025 05:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737609395; cv=none; b=Zr5KWCKGWv3aBje2MsfF0XHOBqbFrzZc/PEiSAVW2P8C4cgyTSv1qPR1SXCbY8PYPWDc6HoTemQWIorNMbBRXf3DQcvxZOitAyxolEtqjcfnHPe4h4pHK3Rd30/kYlszYRCERrM/TH4pSXyGtAIGwBnTaSvs6jSPnpj8x6D9C3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737609395; c=relaxed/simple;
	bh=kYRuAshAO17KL1+BUt85TwSrkCsAuGsZ2Ro+sp3To9I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gNHgy9YZFAcOAHEvqV1cmF+iyoQ/J+PPdH8McN8/eCGgrn3hxmL1f8HnMWJ6NVNus9NGJst6ZlpNqinLPGVO8OqAvI/z5XeWlsQHa3Ht5+puXo0DCYrRXO+GfxWwfiEJWdATunPZSPzNB3DOsNCkWa+9LQieHmh3GbpgaN435ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QpRw1dy3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QpRw1dy3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1A3BC4CED3;
	Thu, 23 Jan 2025 05:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737609395;
	bh=kYRuAshAO17KL1+BUt85TwSrkCsAuGsZ2Ro+sp3To9I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QpRw1dy33gSxXxgm5Twbu69Vd1FYCWqEXUaXJvbVSbQP1JG1UhmndYh6Y9VtzQnrk
	 Idf4FcxOOysHg0deNgl9db4Wa8OP9l90X+ir4qca5IOBOmlqNJIWKITKoCxJoYXpB8
	 3drignmxu70XGjsHEmjjps13Yz7Bsm+aSFshJ7dJGobd44BeuOAx8wW+pEfKLlPXQj
	 S4m+by8HCaSVsQiRjE/G0zxVyaRwp/qA+Utv5M4rJjqGuUAs9g5I9FZa7muXn3+Hoc
	 caD/qHJYe8Uq61qwEsqZoo865EAh11GhHTuXur1HSelfMPK+5g9vDl1dcKebcqYX1G
	 Kr3jzTcjpIamA==
Date: Wed, 22 Jan 2025 21:16:33 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>, Chao Yu <chao@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Theodore Ts'o <tytso@mit.edu>,
	Vinicius Peixoto <vpeixoto@lkcamp.dev>,
	WangYuli <wangyuli@uniontech.com>
Subject: Re: [GIT PULL] CRC updates for 6.14
Message-ID: <20250123051633.GA183612@sol.localdomain>
References: <20250119225118.GA15398@sol.localdomain>
 <CAHk-=wgqAZf7Sdyrka5RQQ2MVC1V_C1Gp68KrN=mHjPiRw70Jg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgqAZf7Sdyrka5RQQ2MVC1V_C1Gp68KrN=mHjPiRw70Jg@mail.gmail.com>

Hi Linus,

On Wed, Jan 22, 2025 at 08:13:07PM -0800, Linus Torvalds wrote:
> On Sun, 19 Jan 2025 at 14:51, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > - Reorganize the architecture-optimized CRC32 and CRC-T10DIF code to be
> >   directly accessible via the library API, instead of requiring the
> >   crypto API.  This is much simpler and more efficient.
> 
> I'm not a fan of the crazy crypto interfaces for simple hashes that
> only complicate and slow things down, so I'm all in favor of this and
> have pulled it.
> 
> HOWEVER.
> 
> I'm also very much not a fan of asking users pointless questions.
> 
> What does this patch-set ask users idiotic questions like
> 
>   CRC-T10DIF implementation
>   > 1. Architecture-optimized (CRC_T10DIF_IMPL_ARCH) (NEW)
>     2. Generic implementation (CRC_T10DIF_IMPL_GENERIC) (NEW)
> 
> and
> 
>   CRC32 implementation
>   > 1. Arch-optimized, with fallback to slice-by-8
> (CRC32_IMPL_ARCH_PLUS_SLICEBY8) (NEW)
>     2. Arch-optimized, with fallback to slice-by-1
> (CRC32_IMPL_ARCH_PLUS_SLICEBY1) (NEW)
>     3. Slice by 8 bytes (CRC32_IMPL_SLICEBY8) (NEW)
>     4. Slice by 4 bytes (CRC32_IMPL_SLICEBY4) (NEW)
>     5. Slice by 1 byte (Sarwate's algorithm) (CRC32_IMPL_SLICEBY1) (NEW)
>     6. Classic Algorithm (one bit at a time) (CRC32_IMPL_BIT) (NEW)
> 
> because *nobody* wants to see that completely pointless noise.
> 
> Pick the best one. Don't ask the user to pick the best one.
> 
> If you have some really strong argument for why users need to be able
> to override the sane choice, make the question it at *least* depend on
> EXPERT.
> 
> And honestly, I don't see how there could possibly ever be any point.
> If there is an arch-optimized version, just use it.
> 
> And if the "optimized" version is crap and worse than some generic
> one, it just needs to be removed.
> 
> None of this "make the user make the choice because kernel developers
> can't deal with the responsibility of just saying what is best".

Yes, I agree, and the kconfig options are already on my list of things to clean
up.  Thanks for giving your thoughts on how to do it.  To be clarify, this
initial set of changes removed the existing arch-specific CRC32 and CRC-T10DIF
options (on x86 that was CRYPTO_CRC32C_INTEL, CRYPTO_CRC32_PCLMUL, and
CRYPTO_CRCT10DIF_PCLMUL) and added the equivalent functionality to two choices
in lib, one of which already existed.  So for now the changes to the options
were just meant to consolidate them, not add to or remove from them per se.

I do think that to support kernel size minimization efforts we should continue
to allow omitting the arch-specific CRC code.  One of the CRC options, usually
CONFIG_CRC32, gets built into almost every kernel.  Some options already group
together multiple CRC variants (e.g. there are three different CRC32's), and
each can need multiple implementations targeting different instruction set
extensions (e.g. both PCLMULQDQ and VPCLMULQDQ on x86).  So it does add up.

But it makes sense to make the code be included by default, and make the choice
to omit it be conditional on CONFIG_EXPERT.

I'm also thinking of just doing a single option that affects all enabled CRC
variants, e.g. CRC_OPTIMIZATIONS instead of both CRC32_OPTIMIZATIONS and
CRC_T10DIF_OPTIMIZATIONS.  Let me know if you think that would be reasonable.

As you probably noticed, the other problem is that CRC32 has 4 generic
implementations: bit-by-bit, and slice by 1, 4, or 8 bytes.

Bit-by-bit is useless.  Slice by 4 and slice by 8 are too similar to have both.

It's not straightforward to choose between slice by 1 and slice by 4/8, though.
When benchmarking slice-by-n, a higher n will always be faster in
microbenchmarks (up to about n=16), but the required table size also increases
accordingly.  E.g., a slice-by-1 CRC32 uses a 1024-byte table, while slice-by-8
uses a 8192-byte table.  This table is accessed randomly, which is really bad on
the dcache, and can be really bad for performance in real world scenarios where
the system is bottlenecked on memory.

I'm tentatively planning to just say that slice-by-4 is a good enough compromise
and have that be the only generic CRC32 implementation.

But I need to try an interleaved implementation too, since it's possible that
could give the best of both worlds.

- Eric
