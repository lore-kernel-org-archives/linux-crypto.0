Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5575320B;
	Thu, 23 Jan 2025 08:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737620538; cv=none; b=sXZ4TxcsxnKilhj762D35PUSE4pOIcxkumO5igds1C3c6QfSqOl6HAHGHwp4Fh4A7C/5fanLBLU1opa0hps8mcgc/CL2sB61dHCX/miZHkW7CQq37nsvjfUqM/yh8799nZVHuNFwKzXYxrFSUp3ZYZpdoy/EKBnxN4XDYJQfGxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737620538; c=relaxed/simple;
	bh=KI02qYrWCahz2mUoQZpXhE1XwjLNkz7flzRxbd/QZgc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bHqcDedr2HSv8cIjgO8D8IWoC0PQBHdj5o3Jf1gNOzm+5J0YEIWoUM+Qj5wb6hnaWVrhQEIeB/9IMRXFkEv0bNf3qv+s943fk6CIBjE6DFDNaBzY5yAlax4QmiL1ziUFcLcFK7u0Db4ttATBlLAONhP3fRJOr85s6Sl+Sdcdmng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bdY8YoMM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bdY8YoMM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66F2C4CED3;
	Thu, 23 Jan 2025 08:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737620537;
	bh=KI02qYrWCahz2mUoQZpXhE1XwjLNkz7flzRxbd/QZgc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bdY8YoMM8ME5sEZp6/wgKzqi4mlECh1Jz2o16xVQ1H1HA25yocAVNnCWR5FSFqpTA
	 WRHij/vsq7s8HVqNzKhwZO7ZMk7Pt87i9UFbWKMuOt2maqCV4Y3d+iDBpawnx/gWMM
	 m6+YBmT+TOZN+QTWKNl3DNmg8NtzB48jdQXkiuYVL0rKXduVl9AIyD6CDnLSy1RTRp
	 1Vrt5JWIBKcaMTEpEegy6Bou9MUx3l0tZelfdjOEoMUOH66UNNIpnW9Q8QE9PP748D
	 S0wxEVV4XP9YWMBKbGwfe+bdPvKCqK1QjBWBJzth+q0j2exbLbTSpDsWolSMx0Kk9r
	 qBSV01fdeEvgQ==
Date: Thu, 23 Jan 2025 00:22:15 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>, Chao Yu <chao@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Theodore Ts'o <tytso@mit.edu>,
	Vinicius Peixoto <vpeixoto@lkcamp.dev>,
	WangYuli <wangyuli@uniontech.com>
Subject: Re: [GIT PULL] CRC updates for 6.14
Message-ID: <20250123082215.GC183612@sol.localdomain>
References: <20250119225118.GA15398@sol.localdomain>
 <CAHk-=wgqAZf7Sdyrka5RQQ2MVC1V_C1Gp68KrN=mHjPiRw70Jg@mail.gmail.com>
 <20250123051633.GA183612@sol.localdomain>
 <CAMuHMdXM=iEOiJBZcaRAt1f_BtHBvpU=bg79DoAgUZ161WRz4Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdXM=iEOiJBZcaRAt1f_BtHBvpU=bg79DoAgUZ161WRz4Q@mail.gmail.com>

On Thu, Jan 23, 2025 at 09:16:21AM +0100, Geert Uytterhoeven wrote:
> Hi Eric,
> 
> On Thu, Jan 23, 2025 at 6:16 AM Eric Biggers <ebiggers@kernel.org> wrote:
> > On Wed, Jan 22, 2025 at 08:13:07PM -0800, Linus Torvalds wrote:
> > > On Sun, 19 Jan 2025 at 14:51, Eric Biggers <ebiggers@kernel.org> wrote:
> > > >
> > > > - Reorganize the architecture-optimized CRC32 and CRC-T10DIF code to be
> > > >   directly accessible via the library API, instead of requiring the
> > > >   crypto API.  This is much simpler and more efficient.
> > >
> > > I'm not a fan of the crazy crypto interfaces for simple hashes that
> > > only complicate and slow things down, so I'm all in favor of this and
> > > have pulled it.
> > >
> > > HOWEVER.
> > >
> > > I'm also very much not a fan of asking users pointless questions.
> > >
> > > What does this patch-set ask users idiotic questions like
> > >
> > >   CRC-T10DIF implementation
> > >   > 1. Architecture-optimized (CRC_T10DIF_IMPL_ARCH) (NEW)
> > >     2. Generic implementation (CRC_T10DIF_IMPL_GENERIC) (NEW)
> > >
> > > and
> > >
> > >   CRC32 implementation
> > >   > 1. Arch-optimized, with fallback to slice-by-8
> > > (CRC32_IMPL_ARCH_PLUS_SLICEBY8) (NEW)
> > >     2. Arch-optimized, with fallback to slice-by-1
> > > (CRC32_IMPL_ARCH_PLUS_SLICEBY1) (NEW)
> > >     3. Slice by 8 bytes (CRC32_IMPL_SLICEBY8) (NEW)
> > >     4. Slice by 4 bytes (CRC32_IMPL_SLICEBY4) (NEW)
> > >     5. Slice by 1 byte (Sarwate's algorithm) (CRC32_IMPL_SLICEBY1) (NEW)
> > >     6. Classic Algorithm (one bit at a time) (CRC32_IMPL_BIT) (NEW)
> > >
> > > because *nobody* wants to see that completely pointless noise.
> > >
> > > Pick the best one. Don't ask the user to pick the best one.
> > >
> > > If you have some really strong argument for why users need to be able
> > > to override the sane choice, make the question it at *least* depend on
> > > EXPERT.
> > >
> > > And honestly, I don't see how there could possibly ever be any point.
> > > If there is an arch-optimized version, just use it.
> > >
> > > And if the "optimized" version is crap and worse than some generic
> > > one, it just needs to be removed.
> > >
> > > None of this "make the user make the choice because kernel developers
> > > can't deal with the responsibility of just saying what is best".
> >
> > Yes, I agree, and the kconfig options are already on my list of things to clean
> > up.  Thanks for giving your thoughts on how to do it.  To be clarify, this
> > initial set of changes removed the existing arch-specific CRC32 and CRC-T10DIF
> > options (on x86 that was CRYPTO_CRC32C_INTEL, CRYPTO_CRC32_PCLMUL, and
> > CRYPTO_CRCT10DIF_PCLMUL) and added the equivalent functionality to two choices
> > in lib, one of which already existed.  So for now the changes to the options
> > were just meant to consolidate them, not add to or remove from them per se.
> >
> > I do think that to support kernel size minimization efforts we should continue
> > to allow omitting the arch-specific CRC code.  One of the CRC options, usually
> > CONFIG_CRC32, gets built into almost every kernel.  Some options already group
> > together multiple CRC variants (e.g. there are three different CRC32's), and
> > each can need multiple implementations targeting different instruction set
> > extensions (e.g. both PCLMULQDQ and VPCLMULQDQ on x86).  So it does add up.
> >
> > But it makes sense to make the code be included by default, and make the choice
> > to omit it be conditional on CONFIG_EXPERT.
> >
> > I'm also thinking of just doing a single option that affects all enabled CRC
> > variants, e.g. CRC_OPTIMIZATIONS instead of both CRC32_OPTIMIZATIONS and
> > CRC_T10DIF_OPTIMIZATIONS.  Let me know if you think that would be reasonable.
> >
> > As you probably noticed, the other problem is that CRC32 has 4 generic
> > implementations: bit-by-bit, and slice by 1, 4, or 8 bytes.
> >
> > Bit-by-bit is useless.  Slice by 4 and slice by 8 are too similar to have both.
> >
> > It's not straightforward to choose between slice by 1 and slice by 4/8, though.
> > When benchmarking slice-by-n, a higher n will always be faster in
> > microbenchmarks (up to about n=16), but the required table size also increases
> > accordingly.  E.g., a slice-by-1 CRC32 uses a 1024-byte table, while slice-by-8
> > uses a 8192-byte table.  This table is accessed randomly, which is really bad on
> > the dcache, and can be really bad for performance in real world scenarios where
> > the system is bottlenecked on memory.
> >
> > I'm tentatively planning to just say that slice-by-4 is a good enough compromise
> > and have that be the only generic CRC32 implementation.
> 
> So I guess I want slice-by-1 on m68k. Or
> 
>     default CRC32_IMPL_SLICEBY1 if CONFIG_CC_OPTIMIZE_FOR_SIZE
> 
> so I don't have to touch all defconfigs? ;-)

As I mentioned in my next reply I'm actually leaning towards slice-by-1 only
now.

> BTW, shouldn't all existing defconfigs that enable
> CONFIG_CRC32_SLICEBY[48], CONFIG_CRC32_SARWATE, or CRC32_BIT be updated,
> as the logic has changed (these symbols are now enabled based on
> CRC32_IMPL*)?

Yes, though I doubt that anyone who was selecting a specific generic CRC32
implementation really put much thought into it.  And if we standardize on one
implementation then the choice will go away and it won't matter anyway.

- Eric
