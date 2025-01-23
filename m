Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E1D1D432D;
	Thu, 23 Jan 2025 23:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737675733; cv=none; b=HVYCIT2eZTJ4cRFBMwk96qWw+bn1Lp7YnmraQCJMQBWJeOaeITllbIS9mJXxGZGZoJJan27BwdI9HSrJH1BTp51wnt6ecQCYER42SVpjIa5R6XpL7CCxvMU4T/D0vR9IitYZkTC/FF1in5QfD8444p+qSN2tsB2B8TGFz8tUGG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737675733; c=relaxed/simple;
	bh=vA+yuOaBU/M8P5YIK16JnNHTgrW7Ko6rIw4qu5gP3dI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lcf/0FvkJfTzw2wGbhcgWw2kNoU7Ol70ViPtAIOxPfoWfja4Kgg+kqp7g0pe83EMEbxomflfk4jaRXJkOsdBxXfqExp2JYKPUSH0XZmh/VcGAicSu5TwSyz+6xJoJkwMHJ51W/QBA0Knj8gpfOfYfWJsx8yFHlj3oePtzkfv7iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OAMEsRiv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OAMEsRiv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36488C4CED3;
	Thu, 23 Jan 2025 23:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737675732;
	bh=vA+yuOaBU/M8P5YIK16JnNHTgrW7Ko6rIw4qu5gP3dI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OAMEsRivNJE8WLK6qQdE5yAhsQv6AEQijJxhxo4DrST9/sF5rSqMecqW2ZDEnczQt
	 UdRxVg9zltskiGFC/IcMjbDw70atm/2QR6QaFOpLEVPMxcluWfDc7cPHiW8lOsCB2r
	 L0cg6LHWu64nEOVTn88ClcK2oWNWggQmn1X34a7wohW6vr8oOYq5YCugDyBg2OqjQp
	 m152BeJ/rUOJFYO8M++hxOvEd0xL/yl83T5w3f6Ly4aEec5tqePAiELgBi42xuRpCS
	 Pq9JYmAE9kv/5x9rYgMn+YcHKGQjGLargiZd5Fr5XBriB4pRJVPIfx3CL7P/PTbJMd
	 dBv7i6Ai25pIw==
Date: Thu, 23 Jan 2025 15:42:09 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>, Chao Yu <chao@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Theodore Ts'o <tytso@mit.edu>,
	Vinicius Peixoto <vpeixoto@lkcamp.dev>,
	WangYuli <wangyuli@uniontech.com>
Subject: Re: [GIT PULL] CRC updates for 6.14
Message-ID: <20250123234209.GD88607@sol.localdomain>
References: <20250119225118.GA15398@sol.localdomain>
 <CAHk-=wgqAZf7Sdyrka5RQQ2MVC1V_C1Gp68KrN=mHjPiRw70Jg@mail.gmail.com>
 <20250123051633.GA183612@sol.localdomain>
 <20250123074618.GB183612@sol.localdomain>
 <osjlhhph7hadq4ovynqeegr3rxliamluo7lvq7gje45hnem4dq@53pwc56v4fah>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <osjlhhph7hadq4ovynqeegr3rxliamluo7lvq7gje45hnem4dq@53pwc56v4fah>

On Thu, Jan 23, 2025 at 05:36:40PM -0500, Kent Overstreet wrote:
> On Wed, Jan 22, 2025 at 11:46:18PM -0800, Eric Biggers wrote:
> > On Wed, Jan 22, 2025 at 09:16:33PM -0800, Eric Biggers wrote:
> > > As you probably noticed, the other problem is that CRC32 has 4 generic
> > > implementations: bit-by-bit, and slice by 1, 4, or 8 bytes.
> > > 
> > > Bit-by-bit is useless.  Slice by 4 and slice by 8 are too similar to have both.
> > > 
> > > It's not straightforward to choose between slice by 1 and slice by 4/8, though.
> > > When benchmarking slice-by-n, a higher n will always be faster in
> > > microbenchmarks (up to about n=16), but the required table size also increases
> > > accordingly.  E.g., a slice-by-1 CRC32 uses a 1024-byte table, while slice-by-8
> > > uses a 8192-byte table.  This table is accessed randomly, which is really bad on
> > > the dcache, and can be really bad for performance in real world scenarios where
> > > the system is bottlenecked on memory.
> > > 
> > > I'm tentatively planning to just say that slice-by-4 is a good enough compromise
> > > and have that be the only generic CRC32 implementation.
> > > 
> > > But I need to try an interleaved implementation too, since it's possible that
> > > could give the best of both worlds.
> > 
> > Actually, I'm tempted to just provide slice-by-1 (a.k.a. byte-by-byte) as the
> > only generic CRC32 implementation.  The generic code has become increasingly
> > irrelevant due to the arch-optimized code existing.  The arch-optimized code
> > tends to be 10 to 100 times faster on long messages.
> > 
> > The generic CRC32 code is still needed when the CPU features needed by the arch
> > code are unavailable.  But that's rare these days.  It's also still needed when
> > the CPU has no scalar instructions to accelerate the CRC (e.g. on x86_64, the
> > "regular" CRC32 as opposed to the Castagnoli CRC32) *and* the message is too
> > short for the overhead of saving and restoring the vector registers to be worth
> > it -- typically < 64 bytes or so.  And it's still needed when the CRC is done in
> > a context where vector registers can't be used at all.
> > 
> > But those don't feel like very strong motivations for the huge tables anymore.
> > I think the huge tables were really intended for optimizing CRCs of long
> > messages back when CPUs didn't have any better way to do it.
> 
> Have you by chance been looking at performance of 64 bit crc algorithms,
> or have any recommendations there?
> 
> I've been starting to consider switching to a 64 bit crc for the
> default for bcachefs - and we do want it to be a regular crc so we can
> combine/add them together, not one of the newer fancier add/xor based
> hashes.
> 
> I thought we'd gotten a faster PCLMULQDQ based implementation of a
> crc64, but looking again it appears not, hrm.

Yep!  I've written an assembly template that expands into a PCLMULQDQ or
VPCLMULQDQ implementation of any variant of CRC-8, CRC-16, CRC-32, or CRC-64.
The latest work-in-progress version can be found at
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-x86.
We just need to decide which CRC variants to wire it up for.  My tentative plan,
which is implemented in that git branch, is crc32_le, crc_t10dif, crc64_be, and
crc64_nvme.  (crc64_nvme is currently called crc64_rocksoft, but that name makes
no sense.)  For crc32_le and crc_t10dif these would replace the existing
PCLMULQDQ implementations.  crc64* on the other hand would gain acceleration for
the first time, improving performance for those by as much as 100x.  I'm also
fixing the CRC64 lib to be organized the way I did CRC32 and CRC-T10DIF.

That work is targeting 6.15, since there was already enough for 6.14.

Though this approach makes it easy to wire up arbitrary CRC variants for x86, we
do need to make sure that anyone we wire up is actually useful.  The users of
the optimized crc64_be would be drivers/md/bcache/ and fs/bcachefs/.  So if you
could confirm that that would indeed be useful for you (and in particular you
haven't deprecated the CRC64 support in favor of xxHash), that would be helpful.

Note, I haven't worked on arm64 yet, but a similar approach could be used there.

As far as performance goes, the [V]PCLMULQDQ based code performs about the same
across all CRC variants.  The "le" or least-significant-bit first CRCs are
*slightly* faster than the "be" or most-significant-bit first CRCs since they
avoid a byteswap of the data, but it's a small difference.  If you happen to be
changing CRC variant anyway, but still want a 64-bit CRC, crc64_nvme may be a
slightly better choice than crc64_be it is a "le" CRC and is already needed for
NVME data integrity
(https://lore.kernel.org/linux-block/20220303201312.3255347-1-kbusch@kernel.org/).
But otherwise staying with crc64_be is fine.

- Eric
