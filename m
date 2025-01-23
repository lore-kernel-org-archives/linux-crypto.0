Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3611570815
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jan 2025 22:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737671819; cv=none; b=vF0nndi3PmaMRQaDDvHP7K56Qgk98kQ9VwLDWSYOlrFgyaAoKrk5WCdkka2fVusUfwy961f8S/Nyv0vveCwHNrK3VUqqIm36mO7cli0eyPZ0Yk09DxpvjAHT3US+CzpBKh/6DHUYevx+tAEaKKK4cppSKGma9/olvEriHqEjlAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737671819; c=relaxed/simple;
	bh=xlg9VetYLEOuYy2H0q8DanbM6YOQ6yKcptCBBzncN7Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kNh2OLP72YFKCSZIHKR28VehusH89c77cPbC5cwcYtPamlQrtdlvkqey35QPNl0gn+TUxIw7s5OMPE/TPv9gq26qtNP72kUtBnCjhhQxLyuOA7xs+UmO8kQ7o0buL1HlWZcVD7sjb7svE2wwTGgWX1bNHoxfLR7I9rKA9SDrNYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dU26b9Pp; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dU26b9Pp"
Date: Thu, 23 Jan 2025 17:36:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1737671814;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E9T4wJkrc6SfVFtKzY8C8OSBpfoanXb2iIehxQD8gFI=;
	b=dU26b9Pp6DPqKw3G1vWpX0s+YDMyMdJxEXEKEWAjDGiD/sUzkjs62G1MxnymTieBBIk3rl
	z94XBPStUD/4ORIqWujjZKflRve/zQ38UlE4MeLRjDL/Pwady+VYHnaYtvA90biJBWEQv4
	buWr7zMctkUbcJAB+oBOq+PVHTmMKl4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	Chao Yu <chao@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Theodore Ts'o <tytso@mit.edu>, 
	Vinicius Peixoto <vpeixoto@lkcamp.dev>, WangYuli <wangyuli@uniontech.com>
Subject: Re: [GIT PULL] CRC updates for 6.14
Message-ID: <osjlhhph7hadq4ovynqeegr3rxliamluo7lvq7gje45hnem4dq@53pwc56v4fah>
References: <20250119225118.GA15398@sol.localdomain>
 <CAHk-=wgqAZf7Sdyrka5RQQ2MVC1V_C1Gp68KrN=mHjPiRw70Jg@mail.gmail.com>
 <20250123051633.GA183612@sol.localdomain>
 <20250123074618.GB183612@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250123074618.GB183612@sol.localdomain>
X-Migadu-Flow: FLOW_OUT

On Wed, Jan 22, 2025 at 11:46:18PM -0800, Eric Biggers wrote:
> On Wed, Jan 22, 2025 at 09:16:33PM -0800, Eric Biggers wrote:
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
> > 
> > But I need to try an interleaved implementation too, since it's possible that
> > could give the best of both worlds.
> 
> Actually, I'm tempted to just provide slice-by-1 (a.k.a. byte-by-byte) as the
> only generic CRC32 implementation.  The generic code has become increasingly
> irrelevant due to the arch-optimized code existing.  The arch-optimized code
> tends to be 10 to 100 times faster on long messages.
> 
> The generic CRC32 code is still needed when the CPU features needed by the arch
> code are unavailable.  But that's rare these days.  It's also still needed when
> the CPU has no scalar instructions to accelerate the CRC (e.g. on x86_64, the
> "regular" CRC32 as opposed to the Castagnoli CRC32) *and* the message is too
> short for the overhead of saving and restoring the vector registers to be worth
> it -- typically < 64 bytes or so.  And it's still needed when the CRC is done in
> a context where vector registers can't be used at all.
> 
> But those don't feel like very strong motivations for the huge tables anymore.
> I think the huge tables were really intended for optimizing CRCs of long
> messages back when CPUs didn't have any better way to do it.

Have you by chance been looking at performance of 64 bit crc algorithms,
or have any recommendations there?

I've been starting to consider switching to a 64 bit crc for the
default for bcachefs - and we do want it to be a regular crc so we can
combine/add them together, not one of the newer fancier add/xor based
hashes.

I thought we'd gotten a faster PCLMULQDQ based implementation of a
crc64, but looking again it appears not, hrm.
