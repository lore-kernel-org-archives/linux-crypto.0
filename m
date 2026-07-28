Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1E545D1A6;
	Tue, 28 Jul 2026 18:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785263690; cv=none; b=CzJOBT57S1/b0Jq+vWZUxVHBMQ6jnzquIo/oDZJcqld7aAbAertHzOWuOsF3LUPIfSqqg+qxx+e0e5vEi+k1XUVsm605Cd74+qm8+vY7tTEnaFUiju5zfHFJsQZ3oELeV+y1TlTdYT6+91RIcDarD0P6FUbttV0qOMk4Kvb89Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785263690; c=relaxed/simple;
	bh=BvReud9ZBbcNNSirtVjilkfUeCKWfRQEGsfmWkkSa1w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pJBNDynxv8lPxfHxbAWDm0FvEQYvCiBHloAmZP3XQ79xcaNrtKp7EmjKflCrERUmBBR9s2p64nqJDY5ObkQYnKXcc271NsfCL18LUz0TNlu8vjm4IWj0Bvq0vOeeQUBdaca39pLWXv7c9jHy76RJvEl2iLMhT4oz/5rgapn6wQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JqUV6iX3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JqUV6iX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF921F000E9;
	Tue, 28 Jul 2026 18:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785263688;
	bh=pjvdVv0MUwDDtYkRKjmZ7xW663TKBYNVKsK7EjCTPrY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JqUV6iX3rJgwzZpJPRr7KqlBzoRauXMIDnx+Wiw7O4VUxU+otB7NUgQbuNL2xnhx7
	 J1veAbdlId/+BmMxATC4PXjXK9xD8gNc0RiCEvUwauI9kGe35Wps4htfxsCSZ9Go1n
	 A17heF2QLdRw4BNUZLHaXF1IWsCPuFEy6baCzGTvd/q9f8ZLvgsCT5H99rtbLvHcZ1
	 J9w0K5BXRmixoM1Lite+e4KgPlCbkm/yT3P694W0CYAHasYD1TF59dLnheSzHGsn66
	 c2Mi2JEJUgseqQ3m0JRaixgbwTqyabYK8ZRoKEkxs/Wjm9r/R5z/+QBPaa/F3Z5Kt5
	 wWug/R6guS06w==
Date: Tue, 28 Jul 2026 18:34:47 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org, linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 1/8] x86/fpu: Check for missing AVX and AVX-512 xstate
 bits
Message-ID: <20260728183447.GB3355536@google.com>
References: <20260728021603.79870-1-ebiggers@kernel.org>
 <20260728021603.79870-2-ebiggers@kernel.org>
 <20260728052727.GCamg9v5WxNieTMUwE@fat_crate.local>
 <20260728054532.GA99797@sol>
 <20260728182007.GBamjy17zynlWm2gQT@fat_crate.local>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728182007.GBamjy17zynlWm2gQT@fat_crate.local>

On Tue, Jul 28, 2026 at 11:20:07AM -0700, Borislav Petkov wrote:
> On Mon, Jul 27, 2026 at 10:45:32PM -0700, Eric Biggers wrote:
> > *xfeatures* 0, not *xfeature* 0.  It's a bitmask.
> 
> That doesn't make it more clear. It does "clear cpu caps with missing
> xfeatures 0". I can't parse that code, maybe I don't see it yet.

The argument is the bitmask of xfeatures that are present.  0 is an
empty bitmask, i.e. no xfeatures are present.

I can rename it to xfeatures_present and/or document the argument
explicitly in the function comment, if that would help.

> > Hypervisors that set AVX CPUID bits without their prerequisite
> > xfeatures. 
> 
> Yeah, those are the ones I don't care about.
> 
> > Or the host OS, in the case of the UML patch.
> 
> That was because UML didn't have cpu_has_xfeatures(), right?

I'm not sure what this question is asking, but UML indeed doesn't
implement cpu_has_xfeatures().  Currently most of the AVX optimized code
isn't enabled on UML, which avoids this limitation.  The RAID code is
different though, as it's enabled on UML.

> > There are about 25 sites where kernel code is checking for this.  This
> > is just checking it at the architectural level instead.
> 
> So tglx mentioned another case - firmware. Apparently we can have firmware
> which fumbles the configuration of those bits and I can very much see that
> happening - it is firmware, doh, ofc.
> 
> > We could try taking the position that this is not supported at all and
> > just delete all the cpu_has_xfeatures() checks without replacing them
> > with anything, and see what bug reports we receive (other than all the
> > AI ones which we'd need to just ignore).  This would mean just taking
> > patches 3-8.  Is that what you'd prefer?
> 
> I had another idea this morning: towards the end of fpu__init_system_xstate(),
> we have figured out everything we support, components, buffer sizes, etc.
> There we also do a paranoia check on the xfeatures mask.
> 
> How about we go through the final xfeatures mask and then clear bits which are
> wrong?
>
> This way we'll have all the checking done in one place, if checks pass we can
> say the machine is ok to do xstate handling and then we can drop all other
> checks around the tree.
> 
> How does that sound?

First, the code being added *is* to fpu__init_system_xstate().  Do you
think it needs to be moved later in the function, and if so why?

Second, clearing xfeatures is the opposite of what's needed.

(It's also already there.  See loop with the comment
"Clear XSAVE features that are disabled in the normal CPUID".)

What's needed is clearing X86_FEATURE_* flags based on missing
xfeatures.

- Eric
