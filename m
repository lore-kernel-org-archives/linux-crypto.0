Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6151A4E9D;
	Mon, 14 Oct 2024 23:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728950359; cv=none; b=mc6YIxRwqqJFNxt9D0JNBY5gmBLYNpInZi5IyyMjgpG3mCAWvJG3lyqn7tmC41YzzaeO0nnosNnSDOMXvpEhhtBySdecWn7VlU2kJQ6UeuA4esE7W59aMrzPSQgzEeEiidQE1EbB09CPhB8CQ+jZIxFyjhC9IosVIAtp2W5ahgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728950359; c=relaxed/simple;
	bh=khorf+GVMktPWXIu4XhxDc+f+AhvRXq0/5lrsE+R/d0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fFv41JAVL7x/gWpayQTxltlq2jjZZeIcrU/D4WZmPbWP0fO7Mf6pOK2tnsI3d1jARbts1+rEoV7cR3Ev9MccVgR3z3imf9PsyycAyAbpmQekwCLtNPjkyMzlLzwDWK0Rb9x/vQTXQdqyH6xUfTE3NN1WQ0FRxkt2W8K4A7m01b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=umdDG/Bo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="umdDG/Bo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7DA6C4CEC3;
	Mon, 14 Oct 2024 23:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728950359;
	bh=khorf+GVMktPWXIu4XhxDc+f+AhvRXq0/5lrsE+R/d0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=umdDG/BojFhUARRgde/AeEBMCLwwvPwcrTo/WYXYlD6w+1eUQw99gRanxI1smwrrC
	 JD7BmKzc8N3HVe/fZTwGlKHfX5HI0Fp/kKGr7mIwVB5CRkNRVA+smpRpxBguXeAEM4
	 T9yrC9JrQbzvtxy+AQWh7FyCSawjKqjD6HG7bjhF38D0V0swpYcogsz9vqkFsStDPj
	 FZZqiVghyvXCmi9M3yoB2mPSWVQVsQDkOVXYmxdK7mZ8IDIFBrf8PQcG3HUoiLffBl
	 3ZGG3VZZ97MX98UXK4OjTqYyLTmu2Pb/f9XsZ5/IPgW7MtMeB9p9/RRH9F8Nk1qDvK
	 KdLjTMZ4sNdww==
Date: Mon, 14 Oct 2024 16:59:17 -0700
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
Message-ID: <20241014235917.GA1114@sol.localdomain>
References: <20241014042447.50197-1-ebiggers@kernel.org>
 <20241014042447.50197-4-ebiggers@kernel.org>
 <a6c0c04a0486404ca4db3fd57a809d5b@AcuMS.aculab.com>
 <20241014190142.GA1137@sol.localdomain>
 <00c9c7c84e9043689942fc1f36e28591@AcuMS.aculab.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00c9c7c84e9043689942fc1f36e28591@AcuMS.aculab.com>

On Mon, Oct 14, 2024 at 10:32:48PM +0000, David Laight wrote:
> ...
> > > Do you need to unroll it at all?
> 
> > It looks like on most CPUs, no.  On Haswell, Emerald Rapids, Zen 2 it does not
> > make a significant difference.  However, it helps on Zen 5.
> 
> I wonder if one of the loop instructions is using the ALU
> unit you really want to be processing a crc32?
> If the cpu has fused arithmetic+jump u-ops then trying to get the
> decoder to use one of those may help.
> 
> Is Zen 5 actually slower than the other systems?
> I've managed to get clock cycle counts using the performance counters
> that more of less match the predicted values.
> You can't use 'rdtsc' because the cpu frequence isn't stable.

No, Zen 5 is faster than the other CPUs.  I looked more into what was happening,
and it turns out it's actually executing more than 3 crc32q in parallel on
average, by overlapping the execution of different calls to crc_pcl().  If I
chain the CRC values, that goes away and the 4x unrolling no longer helps.

Of course, whether users are chaining the CRC values or not is up to the user.
A user might be checksumming lots of small messages, or they might be
checksumming a large message in smaller pieces.

I do think the 4x unrolling is probably worth keeping around to reduce
dependency on microarchitectural details for future-proofing.  It's quite modest
compared to the 128x unrolling that was used before...

> ...
> > > If you are really lucky you'll get two memory reads/clock.
> > > So you won't ever to do than two crc32/clock.
> > > Looking at Agner's instruction latency tables I don't think
> > > any cpu can do more that one per clock, or pipeline them.
> > > I think that means you don't even need two (never mind 3)
> > > buffers.
> > 
> > On most Intel and AMD CPUs (I tested Haswell for old Intel, Emerald Rapids for
> > new Intel, and Zen 2 for slightly-old AMD), crc32q has 3 cycle latency and 1 per
> > cycle throughput.  So you do need at least 3 streams.
> 
> Bah, I missed the latency column :-)
> 
> > AMD Zen 5 has much higher crc32q throughput and seems to want up to 7 streams.
> > This is not implemented yet.
> 
> The copy of the tables I have is old - doesn't contain Zen-5.
> Does that mean that 2 (or more) of its alu 'units' can do crc32
> so you can do more than 1/clock (along with the memory reads).

That's correct.  It seems that 3 ALUs on Zen 5 can do crc32.

> One thought is how much of it is actually worth while!
> If the data isn't already in the L1 data cache then the cache
> loads almost certainly dominate - especially if you have to
> do out to 'real memory'.
> You can benchmark the loops by repeatedly accessing the same
> data - but that isn't what will actually happen.
> 

Well, data is rarely checksummed on its own but rather immediately before using
it or right after generating it.  In those cases it needs to be pulled into L1
cache, or has already been pulled into L1 cache, anyway.

> > > Most modern x86 can do 4 or 5 (or even more) ALU operations
> > > per clock - depending on the combination of instructions.
> > >
> > > Replace the loop termination with a comparison of 'bufp'
> > > against a pre-calculated limit and you get two instructions
> > > (that might get merged into one u-op) for the loop overhead.
> > > They'll run in parallel with the crc32q instructions.
> > 
> > That's actually still three instructions: add, cmp, and jne.
> 
> I was really thinking of the loop I quoted later.
> The one that uses negative offsets from the end of the buffer.
> That has an 'add' and a 'jnz' - which might even fuse into a
> single u-op.
> Maybe even constrained to p6 - so won't go near p1.
> (I don't have a recent AMD cpu)
>
> It may not actually matter.
> The add/subtract/cmp are only dependant on themselves.
> Similarly the jne is only dependant on the result of the sub/cmp.
> In principle they can all run in the same clock (for different
> loop cycles) since the rest of the loop only needs one of the
> ALU blocks (on Intel only P1 can do crc).
> But I failed to get a 1 clock loop (using ADC - which doesn't
> have a latency issue).
> It might be impossible because a predicted-taken conditional jmp
> has a latency of 2.

Yes, it's an interesting idea.  There would need to be a separate bufend pointer
for each chunk set up.

- Eric
