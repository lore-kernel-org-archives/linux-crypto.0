Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D9013C810;
	Mon, 14 Oct 2024 19:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728932505; cv=none; b=hnpfOFhNpzFsqGjVUhpyTLnMWZtDj9trKMzOM/Nw4Jv8EJYFUYrrM4bv9BpxtTq/uXd797rDuFeTu3rhZh6EQ1q1XZOvpStXrc79NzKMY9YRjb0e5s1RIRL96DKigpu4Tycf6hY4UVqzfVr+1pc2SqlGJmll92EUM1lsCl1+VBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728932505; c=relaxed/simple;
	bh=4B/4MKRiZMEAx3KlSKct+QBFZ1DTuDQEOf7PADj4UYE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=njYqvPwxwQLmBEBIRhLRX21BeUF13bWYbNpuMU4Pp8seKt5BjTsL/jQXV5Ty1AipwNhgQgMHPUOH6hf6TMVpWf92faoMvDvgqHJW0PEp9a8C3ZckMhMHEo9+AK3HesuL8d2ZKE0vEZBdjpJX0nxIXFNMCqJ5D4hGNb5RRToko5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=llYDHDQI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="llYDHDQI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A59AC4CEC3;
	Mon, 14 Oct 2024 19:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728932504;
	bh=4B/4MKRiZMEAx3KlSKct+QBFZ1DTuDQEOf7PADj4UYE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=llYDHDQIkfBeL0ZFDnSSgtqfLxoWdgvdPQQopLaTh+W9roGjh6pHAihxCtKvjbeiz
	 wrXDNxYaPBV1FqD3nwk/3XYS6tVExcudDEkF40u11/es90SNLxLgEqHKl90Bz1sm8/
	 UE+OSwTwgfZeTZ5J5FhTealJUO8mYpq5b9wbmYQA9b1Lwm5kbcD2A7Hz0MRFUXysVb
	 ql+tPM3W3hmDIUQGaM4lwFS/ufGdl+dQJJAMuhF3Jax0Bp7+aq6uc1oeUo74yE6RY1
	 KUoQCo+a8R1KttTQuGt8RzU9Ij4Kv1zZJNls5IYCd4SPowfxKwEAOsnoFw2o4vmQBx
	 EZr/wgp+Hbv9A==
Date: Mon, 14 Oct 2024 12:01:42 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: David Laight <David.Laight@aculab.com>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 3/3] crypto: x86/crc32c - eliminate jump table and
 excessive unrolling
Message-ID: <20241014190142.GA1137@sol.localdomain>
References: <20241014042447.50197-1-ebiggers@kernel.org>
 <20241014042447.50197-4-ebiggers@kernel.org>
 <a6c0c04a0486404ca4db3fd57a809d5b@AcuMS.aculab.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6c0c04a0486404ca4db3fd57a809d5b@AcuMS.aculab.com>

On Mon, Oct 14, 2024 at 04:30:05PM +0000, David Laight wrote:
> From: Eric Biggers
> > Sent: 14 October 2024 05:25
> > 
> > crc32c-pcl-intel-asm_64.S has a loop with 1 to 127 iterations fully
> > unrolled and uses a jump table to jump into the correct location.  This
> > optimization is misguided, as it bloats the binary code size and
> > introduces an indirect call.  x86_64 CPUs can predict loops well, so it
> > is fine to just use a loop instead.  Loop bookkeeping instructions can
> > compete with the crc instructions for the ALUs, but this is easily
> > mitigated by unrolling the loop by a smaller amount, such as 4 times.
> 
> Do you need to unroll it at all?

It looks like on most CPUs, no.  On Haswell, Emerald Rapids, Zen 2 it does not
make a significant difference.  However, it helps on Zen 5.

> > +	# Unroll the loop by a factor of 4 to reduce the overhead of the loop
> > +	# bookkeeping instructions, which can compete with crc32q for the ALUs.
> > +.Lcrc_3lanes_4x_loop:
> > +	crc32q	(bufp), crc_init_q
> > +	crc32q	(bufp,chunk_bytes_q), crc1
> > +	crc32q	(bufp,chunk_bytes_q,2), crc2
> > +	crc32q	8(bufp), crc_init_q
> > +	crc32q	8(bufp,chunk_bytes_q), crc1
> > +	crc32q	8(bufp,chunk_bytes_q,2), crc2
> > +	crc32q	16(bufp), crc_init_q
> > +	crc32q	16(bufp,chunk_bytes_q), crc1
> > +	crc32q	16(bufp,chunk_bytes_q,2), crc2
> > +	crc32q	24(bufp), crc_init_q
> > +	crc32q	24(bufp,chunk_bytes_q), crc1
> > +	crc32q	24(bufp,chunk_bytes_q,2), crc2
> > +	add	$32, bufp
> > +	sub	$4, %eax
> > +	jge	.Lcrc_3lanes_4x_loop
> 
> If you are really lucky you'll get two memory reads/clock.
> So you won't ever to do than two crc32/clock.
> Looking at Agner's instruction latency tables I don't think
> any cpu can do more that one per clock, or pipeline them.
> I think that means you don't even need two (never mind 3)
> buffers.

On most Intel and AMD CPUs (I tested Haswell for old Intel, Emerald Rapids for
new Intel, and Zen 2 for slightly-old AMD), crc32q has 3 cycle latency and 1 per
cycle throughput.  So you do need at least 3 streams.

AMD Zen 5 has much higher crc32q throughput and seems to want up to 7 streams.
This is not implemented yet.

> Most modern x86 can do 4 or 5 (or even more) ALU operations
> per clock - depending on the combination of instructions.
> 
> Replace the loop termination with a comparison of 'bufp'
> against a pre-calculated limit and you get two instructions
> (that might get merged into one u-op) for the loop overhead.
> They'll run in parallel with the crc32q instructions.

That's actually still three instructions: add, cmp, and jne.

I tried it on both Intel and AMD, and it did not help.

> I've never managed to get a 1-clock loop, but two is easy.
> You might find that just:
> 10:
> 	crc32q	(bufp), crc
> 	crc32q	8(bufp), crc
> 	add		$16, bufp
> 	cmp		bufp, buf_lim
> 	jne		10b
> will run at 8 bytes/clock on modern intel cpu.

No, the latency of crc32q is still three cycles.  You need three streams.

> You can write that in C with a simple asm function for the crc32
> instruction itself.

Well, the single-stream CRC32C implementation already does that; see
arch/x86/crypto/crc32c-intel_glue.c.  Things are not as simple for this
multi-stream implementation, which uses pclmulqdq to combine the CRCs.

- Eric
