Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E652D2487;
	Wed, 12 Aug 2026 19:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786563614; cv=none; b=ZvjZDT3IZL2EJ0FP2Hx84/wCU129RthCy82xqIi6p1EIBWLAqz3rTQBPtYdUGY5PQQbvg4issDVN098LisoGMTzlRVswHsk+Z8jkXXiIeJtgtHPXOL0UjQZzKG6gUHXNb0XGLN1By4KW8icyfgX6FQQq2/18yZPkpxksdMGY5Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786563614; c=relaxed/simple;
	bh=NGSRUtMgw5F4ZJ5K+2h4dVIdUxK/Jykx2mHFBCrhHfA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MD1Q0cyFmJO4ERXnjUcGYafMQ8RAjplzocCjcnUBPvZ/Xqi1BssefJqxR9meseirH5dsHwXDikjiWzaljcmRavJLGrUncOrjEwEmgHWCMRz2oazjhOSw6Rwy2DzPkwnhCXKqXmq9RzHEcmjnjS50pcnaNeNkMIsKR3B4MIpIdkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=odicFeqE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="odicFeqE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC92F1F000E9;
	Wed, 12 Aug 2026 19:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786563613;
	bh=U+gt0iEPzsWX4i8iCLvPkbDr9lrluiFQAHkh4aUzvKU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=odicFeqEpKsz8g/dwV0mnxBfc2Ps4uIwbMfPegtg2t/bnoN4lZHMQWYjs5AjENrpl
	 26DljbHUx5OWFMOhADqP8s/FpnKz8oeNHbctv0Q+H2BZNs0kFhjBat+BEfNM7O3eR7
	 8SQD6x4bCBk4/eZUI2iC2SUArqfq+9KZ72P4Ua9q2WysFqRYFJHsyYNq7I7DEzC/D5
	 Uqz9oT2g8TLfnlVd3bBR8r/17CaVk8LfniMMITIvKrMbZcBXgbM0OGocx4NjlOjiTO
	 NlR7SOapNWkc/whazI+6JbZZoSBlACcMrKODJXZkMJVVgDV7ADa/X2fgzkag8amb7f
	 9rLG+rx/j9IzA==
Date: Wed, 12 Aug 2026 19:40:11 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org, linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 1/8] x86/fpu: Check for missing AVX and AVX-512 xstate
 bits
Message-ID: <20260812194011.GA3734410@google.com>
References: <20260728021603.79870-1-ebiggers@kernel.org>
 <20260728021603.79870-2-ebiggers@kernel.org>
 <20260728052727.GCamg9v5WxNieTMUwE@fat_crate.local>
 <20260728054532.GA99797@sol>
 <20260728182007.GBamjy17zynlWm2gQT@fat_crate.local>
 <20260728183447.GB3355536@google.com>
 <20260728225936.GBamk0WK38PByPFkxz@fat_crate.local>
 <20260728233430.GA3277@quark>
 <20260728234726.GCamk_jnl3LtfGbxoC@fat_crate.local>
 <20260812174826.GAanyx6vUWv5GLX2AZ@fat_crate.local>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260812174826.GAanyx6vUWv5GLX2AZ@fat_crate.local>

On Wed, Aug 12, 2026 at 10:48:26AM -0700, Borislav Petkov wrote:
> On Tue, Jul 28, 2026 at 04:47:26PM -0700, Borislav Petkov wrote:
> > On Tue, Jul 28, 2026 at 04:34:30PM -0700, Eric Biggers wrote:
> > > I don't know what your suggestion is.  Are you still asking for the
> > > function to be renamed to clear_cpu_caps_xft()?  Note that the
> > > abbreviation "xft" doesn't appear anywhere else in arch/x86/.  Maybe you
> > > want the argument inverted?  I don't know what you want, sorry.
> > 
> > That's fine - I'll take a look at the final version after having gone through
> > the whole pile and then holler if I still see a need.
> 
> Ok, here's something ontop of yours. It is tested only in a guest but it
> should show the intention.
> 
> The first call in:
> 
> 	if (!boot_cpu_has(X86_FEATURE_FPU)) {
> 
> is not needed because that is caught earlier:
> 
> [    0.553199] x86/fpu: Giving up, no FPU found and no math emulation present
> 
> and we stop there.

Interesting, so the !boot_cpu_has(X86_FEATURE_FPU) check is dead code
since ab05214025ee ("x86/fpu: Remove MATH_EMULATION and related glue
code").  Sure, there's no need to add anything to there then, though we
should do a separate patch that removes it.

> The second one can then simply do:
> 
>                 /* Disable all dependent flags too */
>                 setup_clear_cpu_cap(X86_FEATURE_XSAVE);
> 
> because that'll clear all dependent flags and we should be good there:

Sure, that works.  I'm not sure it's actually easier to understand than
what I proposed; it's kind of contradictory to call
"setup_clear_cpu_cap(X86_FEATURE_XSAVE)" when we just verified it is
clear.  But the comment mentioning that it's actually for clearing
dependent flags helps.  If you prefer this way, let's do this.

> and then the rest is streamlined into fpu__init_system_xstate() where all
> sanity checking should be performed, as I mentioned intially.

It's functionally equivalent, but yes we can write it this way if you
prefer.  Is it okay if I fold your diff (minus the pr_info()) into this
patch?  (I'll also add FW_BUG to the error messages as Thomas
requested.)

- Eric
