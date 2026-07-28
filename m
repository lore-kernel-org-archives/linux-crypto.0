Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230472D5A01;
	Tue, 28 Jul 2026 23:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785281674; cv=none; b=nvTcaIIKClInkXQDw/dfUlx8L+/MJ/gmCby0NC6TZY9iDVPeP4zD6GnCHB8eNtCXa/ZspKX8emPcwkU2/yE60kRWUESvOD3K6QDLRrjj8mBsA7OhEKlxKrdWT3My1uivov4FgaQxfaGtDtoikclW9qV54WfXmR+kH3XMEBxt4fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785281674; c=relaxed/simple;
	bh=vBfvrtnQ7KZMB6KD/nTRn8kFdgN/zwjDpiIFu6rxIUE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ES/ynPV5DU0fwPbNUoQeEa2mPMsovj58k22RcaIEMJ0tFqMg24rxaeeBsuydrcnBu1Vt+hJU1raCrR/6NOZCYKy8PSqlckd7gaxiPuku2t3ERf+Z7TSef88M2jzoasry5XSlgrowSKqDbqv6pmo+VCOrSRt8Q8SVt6S90hIco0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d3iFzTDp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d3iFzTDp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607051F000E9;
	Tue, 28 Jul 2026 23:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785281672;
	bh=x/W+IVSURy9beakcVAzhkFhybnnYmzcojVCP73b3+G0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=d3iFzTDpDMzb7jxs1ZQDBL+9/U8KyuBJIwhHokpy5yoEyO1OcBHHpD+2EYW2pakv0
	 k9vrypd+aMGdgnWNnNK8V4sZ3HI5XgUiywzbkDbLTiXdGQN10T0jm4twddhRLwrrtI
	 HKZGUfUCProAse/O94l9hz8c+iXiirHEwtPw5+BM/8UjN1iACVPp9daOA5Kb0wKhgU
	 xbc2JH63ga5EjyeXQtlfBzI7Th2uSFGmaB86wiU/8t3wp12BGoewtt3i+8MrgznBXj
	 pu1rFFnUR6BKDo/ffz1vhIKaGz5WXoQOCg6gz4rY2d/1B75+xd7JQCaOXvyu3PW6Ae
	 9HLMK3voKIxhw==
Date: Tue, 28 Jul 2026 16:34:30 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org, linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 1/8] x86/fpu: Check for missing AVX and AVX-512 xstate
 bits
Message-ID: <20260728233430.GA3277@quark>
References: <20260728021603.79870-1-ebiggers@kernel.org>
 <20260728021603.79870-2-ebiggers@kernel.org>
 <20260728052727.GCamg9v5WxNieTMUwE@fat_crate.local>
 <20260728054532.GA99797@sol>
 <20260728182007.GBamjy17zynlWm2gQT@fat_crate.local>
 <20260728183447.GB3355536@google.com>
 <20260728225936.GBamk0WK38PByPFkxz@fat_crate.local>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728225936.GBamk0WK38PByPFkxz@fat_crate.local>

On Tue, Jul 28, 2026 at 03:59:36PM -0700, Borislav Petkov wrote:
> On Tue, Jul 28, 2026 at 06:34:47PM +0000, Eric Biggers wrote:
> > The argument is the bitmask of xfeatures that are present.  0 is an
> > empty bitmask, i.e. no xfeatures are present.
> 
> Ok, so what does that mean when you see it in the code:
> 
> 	clear_cpu_caps_with_missing_xfeatures(0)
> 
> clear the CPU caps with missing xfeatures bitmask 0?

It clears the CPU caps whose xfeature dependencies are missing from the
given mask, which denotes the present xfeatures.  An empty mask means
nothing present, i.e. everything is missing.

It could be a separate function that clears unconditionally, but then
the clearing and the log messages would need to be duplicated.

I don't know what your suggestion is.  Are you still asking for the
function to be renamed to clear_cpu_caps_xft()?  Note that the
abbreviation "xft" doesn't appear anywhere else in arch/x86/.  Maybe you
want the argument inverted?  I don't know what you want, sorry.

> You brought up the UML example upthread. I'm trying to figure out why we care
> about the UML case. I'm also assuming that case will be fixed with whatever we
> end up doing here.

The UML update is in this series.  See patch 2.  Maybe you don't care
about UML but many people do.  kunit.py uses it by default, for example.

> > First, the code being added *is* to fpu__init_system_xstate().  Do you
> > think it needs to be moved later in the function, and if so why?
> 
> Lemme try again:
> 
> there where we sanity check the xfeatures mask, at that same place we can
> sanity check the X86_FEATURE flags we have set in our internal representation
> of CPUID flags. At exactly the same place. And we warn and clear the ones are
> wrong.

This is basically what this patch does already:

	clear_cpu_caps_with_missing_xfeatures(fpu_kernel_cfg.max_features);

	fpu_kernel_cfg.independent_features = fpu_kernel_cfg.max_features &
					      XFEATURE_MASK_INDEPENDENT;

	/*
	 * Clear XSAVE features that are disabled in the normal CPUID.
	 */
	for (i = 0; i < ARRAY_SIZE(xsave_cpuid_features); i++) {
		unsigned short cid = xsave_cpuid_features[i];

		/* Careful: X86_FEATURE_FPU is 0! */
		if ((i != XFEATURE_FP && !cid) || !boot_cpu_has(cid))
			fpu_kernel_cfg.max_features &= ~BIT_ULL(i);
	}

Maybe you want it moved down one statement so that it's immediately
adjacent to the loop?

Or maybe you want it to be integrated into the loop itself?  It's
doable, but a bit awkward because the two CPU features we'd like to
clear each depend on multiple xfeatures rather than just one.  And also
there are those two cases earlier in the function (XSAVE or FPU being
disabled) that do an early return and never reach here.  It's nice to
use the same helper function in those cases.

> > Second, clearing xfeatures is the opposite of what's needed.
> 
> I meant clearing X86_FEATURE flags. Basically what you started doing.
> 
> All I'm proposing is having the *whole* X86_FEATURE clearing concentrated in
> a single function so that it is called once per CPU and then we're done.

fpu__init_system_xstate() is already a function called once on the boot
CPU.  Is your suggestion that the feature clearing should be once per
CPU instead of just on the boot CPU?

- Eric
