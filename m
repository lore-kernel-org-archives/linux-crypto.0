Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3FD3DBB6;
	Thu, 23 Jan 2025 21:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737666965; cv=none; b=sGQwnHUdmW2FnqxHghCN9umQlZJ0/6hbE04R015BazF/C+g/dIvE+kSK67V8Sod+6YYBSEFGJMi5XGpEVVoYjiUOFLIskqGQVORKvKh01pwyPnKDZ3Ftf/P3f9RJfUPHxzDuNd9yD8pZX0s1rjoUnr7wIWtVquoH4F67DU41qNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737666965; c=relaxed/simple;
	bh=wFzSGi8CTD2KJJ9J3NR4e1pAKz/3JtUKeCqKSyCOcIo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mY1uFYXIBv49IsMcR+MlqvLT3ip8TbIWrid2RfBrceYlHQvruy6Cq/YNelAPICjVm4OhT49LgzX3TjIZ7PNwRk1nsA96y3ihdnSxZCq4D/5+3GUWilxDAC1PuVfP7exVf5fRvXpIeIIN2DuzTJLcIjhiAftjNlQHe6Ih06S2u68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fg9QkOb6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fg9QkOb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B26F3C4CED3;
	Thu, 23 Jan 2025 21:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737666965;
	bh=wFzSGi8CTD2KJJ9J3NR4e1pAKz/3JtUKeCqKSyCOcIo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fg9QkOb6mG2vS8TmaYbT2/9CgMGvwHw/47afnvzOuvpGsV1Oc0ekK+EypIA9mFpuJ
	 T5qUFB0S8qSKxvnEx0+KhtO53c+p6dOn8Suca+ZK3OTQ3IMW4t8Bj0CMI3beSUMagI
	 BQzmp9cNLq8iZenXNeVnXXDtQ2m8DtDYVSsCq5uZh7jwLBUm1pHPXJSp3LlX6Mn8ik
	 MgAZKsL0T9zp8tJR2CF8A7lZlyQ0DO5x+uhCJrxCOREvmHA/qPA3bzaqprTaggVUoL
	 2pjQGEfTDvjcRbkCJBU8f/U+y1svyVVh1rTXBXQsKrxIC9xbAE595vxhMz8+EMRBIN
	 RtTlt31xABsZg==
Date: Thu, 23 Jan 2025 13:16:03 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>, Chao Yu <chao@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Vinicius Peixoto <vpeixoto@lkcamp.dev>,
	WangYuli <wangyuli@grjsls0nwwnnilyahiblcmlmlcaoki5s.yundunwaf1.com>
Subject: Re: [GIT PULL] CRC updates for 6.14
Message-ID: <20250123211603.GB88607@sol.localdomain>
References: <20250119225118.GA15398@sol.localdomain>
 <CAHk-=wgqAZf7Sdyrka5RQQ2MVC1V_C1Gp68KrN=mHjPiRw70Jg@mail.gmail.com>
 <20250123051633.GA183612@sol.localdomain>
 <20250123074618.GB183612@sol.localdomain>
 <20250123140744.GB3875121@mit.edu>
 <20250123205810.744c8823@pumpkin>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250123205810.744c8823@pumpkin>

On Thu, Jan 23, 2025 at 08:58:10PM +0000, David Laight wrote:
> On Thu, 23 Jan 2025 09:07:44 -0500
> "Theodore Ts'o" <tytso@mit.edu> wrote:
> 
> > On Wed, Jan 22, 2025 at 11:46:18PM -0800, Eric Biggers wrote:
> > > 
> > > Actually, I'm tempted to just provide slice-by-1 (a.k.a. byte-by-byte) as the
> > > only generic CRC32 implementation.  The generic code has become increasingly
> > > irrelevant due to the arch-optimized code existing.  The arch-optimized code
> > > tends to be 10 to 100 times faster on long messages.  
> > 
> > Yeah, that's my intuition as well; I would think the CPU's that
> > don't have a CRC32 optimization instruction(s) would probably be the
> > most sensitive to dcache thrashing.
> > 
> > But given that Geert ran into this on m68k (I assume), maybe we could
> > have him benchmark the various crc32 generic implementation to see if
> > we is the best for him?  That is, assuming that he cares (which he
> > might not. :-).
> 
> The difference between the clock speed and main memory speed on an m68k will
> be a lot less than on anything more recent.
> So I suspect the effect of cache misses is much less (or more likely it is
> pretty much always getting a cache miss).
> Brain wakes up, does the m68k even have a D-cache?
> Checks the m68k user manual section 6 - it only has a I-cache (64 32-bit words).
> So the important thing is probably keeping the loop small.
> A cpu board might have an external data cache.
> 
> For a small memory footprint it might be worth considering 4 bits at a time.
> So a 16 word (64 byte) lookup table.
> Thinks....
> You can xor a data byte onto the crc 'accumulator' and then do two separate
> table lookups for each of the high nibbles and xor both onto it before the rotate.
> That is probably a reasonable compromise.

Yes, you can do less than a byte at a time (currently one of the choices is even
one *bit* at a time!), but I think byte-at-a-time is small enough already.

- Eric
