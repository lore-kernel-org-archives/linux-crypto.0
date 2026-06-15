Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E4538E5FF;
	Mon, 15 Jun 2026 18:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781549080; cv=none; b=bFNRYe5c3aNeiqg65FYfzxXXQM0I0N5JNSmOFd6uDfEyBHq+kKDk6Wf6cm/fYM3vExF1YPh9aqgCaRBr+9aHa3q7aKE+QyHhMZlxYfVXoCYIUNn5+SIJcAFWs1PwGXNRI9MQ6yFGRiM1xGuHEKTQ4xf/Y6FIUrm/z8UtzwWwZ84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781549080; c=relaxed/simple;
	bh=ImSy61Gas8Gwm0Nc+dPyDI8ZU+DJ2iT2yJHfJzN+xso=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tPFrRu42edfIcTkbqpXHm4ectGABclx+AqXuVJ+1Fs2c4K39SYoyq6/hNYxRKJ/X7zN3ZqPpQmCFhHtcKg/oI7pyJvnwPOGgynOsm+D7FGCFJIOt8HGXdZXxpICkDSoK63NrfK3Z1abM0gDG179rJvxHvSYhwOFxNYUwxbHoW1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ShtBCogw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ShtBCogw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E74A11F000E9;
	Mon, 15 Jun 2026 18:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781549077;
	bh=05dHFgug+70fdRO5/CQfA+tcEFLrju9nJJWZEpoyYjo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ShtBCogwN/0CuzQubPhBboJKFqRxX7T19dRCkQE5gOSEJAeXTtxFUyTLQkRICS4Uj
	 LVi7VPCpOiIVVTd7LVprhywBfh7iET8iHZRkmU4gUmSdPLyYQ/961Uzaia4VBjsLTA
	 Ge8eJw+8HCw7cZRbB2P+DZdoTP9vEsr7YkxlDL9T+SwuAIWlQhPng9IZeqSu+vNe09
	 mRZpgeSikzgu0/s5k5x/hObXyeoQj023kRvu1OLRD6TNyJcTRED3+5uT5UnzVMWOW2
	 AwM5Jgjy46HLiZbtZ0UGufYUg70eV4ASXV7q6ZGWOI3MLj7bKZO3+2gVFHY21I5E/a
	 WGxpO9PdMoXCg==
Date: Mon, 15 Jun 2026 11:44:35 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, linux-crypto@vger.kernel.org,
	x86@kernel.org, linux-raid@vger.kernel.org
Subject: Re: [PATCH v2] lib/raid/xor: x86: Add AVX-512 optimized xor_gen()
Message-ID: <20260615184435.GA17731@quark>
References: <20260614010357.69416-1-ebiggers@kernel.org>
 <20260614111628.00af46b9@pumpkin>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260614111628.00af46b9@pumpkin>

On Sun, Jun 14, 2026 at 11:16:28AM +0100, David Laight wrote:
> On Sat, 13 Jun 2026 18:03:57 -0700
> Eric Biggers <ebiggers@kernel.org> wrote:
> 
> > Add an implementation of xor_gen() using AVX-512.
> > 
> > It uses 512-bit vectors, i.e. ZMM registers.  It also uses the
> > vpternlogq instruction to do three-input XORs when applicable.
> > 
> > It's enabled on x86_64 CPUs that have AVX512F && !PREFER_YMM.  In
> > practice that means:
> > 
> >     - AMD Zen 4 and later (client and server)
> 
> Doesn't zen4 only have a 256bit bus between the cpu and cache?
> So avx512 reads take two clocks.
> Since this is memory limited it is unlikely to run faster than the
> avx256 version.

On AMD Genoa (Zen 4 server processor), the AVX-512 code added by this
patch is indeed about the same speed as the existing AVX-2 code.

> OTOH if it doesn't cause down-clocking as well then it won't be slower.

Yes, as far as I know that's not an issue on AMD processors, even Zen 4.
The "avoid AVX-512 due to downclocking" rule is historical guidance for
Intel processors that had a bad implementation of AVX-512.  There's no
reason to exclude Zen 4 from executing AVX-512 optimized code.  At worst
it will just be the same, as we're seeing here.

> Since I suggested it :-)
> 
> Reviewed-By: David Laight <david.laight.linux@gmail.com>
> 
> Some 'not very important' comments:
> 
> I did wonder whether moving the loop into the asm() would help.
> gcc has a nasty habit of pessimising loops when you try to be clever.
> It is certainly safer for tight loops like these.

I originally tried leaving the loops to the compiler, but gcc unrolled
the 1x ones by 2x, despite it having no visibility into the asm block.
That broke the intent with the indexed addressing, since to achieve the
unrolling it generated code that incremented the pointers.

So I just ended up moving the loop to the asm, which reliably gives us
the code we want.

> That does have the side effect of making p0 be %1 which doesn't improve
> readability. Either used named parameters or possibly just change p0 to p1 (etc)
> so they match.
> 
> The code should be limited by the memory reads, so the 3-argument xor and
> the interleave of the unroll may make no difference.

The unroll by 2x in the 2 and 3-buffer cases helped a little bit on
Sapphire Rapids.  I don't know exactly why, but it makes sense that
those cases are where the loop overhead is most likely to matter.

> Some cpu do have constraints on the cache alignment in order to do two
> reads per clock, but I've forgotten them and they got better before AVX-512.
> If that were affecting this code (on the tested cpu) then I'd expect the
> interleaved unroll would improve the _4 and -5 functions.
> So it probably doesn't affect this code.

The buffers are always 64-byte aligned here, as documented.

> Using the same loop for the avx-256 and sse (and even smaller) functions could
> well generate code that runs 'pretty much as fast as possible' on older cpu.
> Intel cpu (going back to Sandy bridge) are likely to execute the loop in the
> same number of clocks - but clearly copying half or a quarter of the data.
> But I've no experience of zen1.
> 
> Might be worth doing for avx-256, does any care about anything older :-)

Yes, the existing AVX code is probably excessively unrolled.  It
generates almost 4 KiB of code.

- Eric
