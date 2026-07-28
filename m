Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421CC35972;
	Tue, 28 Jul 2026 18:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785262835; cv=none; b=bMlt7d8ivR/3avgH8j+O3zRFbQ997aL2x+5Szb37VhLaHP6yL2jSt213/sh+6eNYWMgDOcbk+9dBdhF0dCJzZ3S88eWF+i249tM6u+vgQuRJEmRTR2xIe7BlNd4rD66ycirFWJo+RW+yuGpv6gTKuydEgv7iG6PeZm1edineTxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785262835; c=relaxed/simple;
	bh=wRNLXyCY7jA+XWWFNABhnfKTW+02gby5TJtGgn0AArM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JMEIxI5XZQREoDruJK7s5vSKqQ1TzAAX7pG0YwCBuP4NJ8ny8YEvn5Dn9e1IYQVGaL0RKELxNL5K4TaP1G9esIIes/Sd9wWBDoA+VRvV5+YGrYVD+6QWue4X3YEHfgLwLgP/bgosdURMkQstrqe6l+xo9ghwQTBx+FofmHo3Uqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=i2NveApB; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="i2NveApB"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 155DB40E01CE;
	Tue, 28 Jul 2026 18:20:30 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id AcccxxVkgJBi; Tue, 28 Jul 2026 18:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1785262820; bh=8CnK7b3OTZ846KlpC71LjrQLtB6ehd01yLmJwk1SIFk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i2NveApB2bcpTxHUhfxcBwFN4YZh1p27MCcgVUP2fS8ZtZmrPivBps4btIhHbjFOt
	 J6/xzZWXS+IyFzuEpbSyFqyBQI7CCLk4xF4osEuK6BoScAfU+q+b1eWyPYjCWwEKnG
	 mMrwhKYomIW3UXY3ivGFN4zJyo6Vy5i5wmlyg/jXEjzqJH1/m+Ft/OY2FXEUd/H4o4
	 innjIm9EdrKYFABLrpBtamfKAplHx6Aw6sz9em+DuMtZPmBgfTIrH5/BsUyw5/nCcq
	 RCyzmF93d9Fg1+angkSh/FyO5tet9fM0ccA8zsMxHGI29qPuoSc+Pe1oZtI8hDTjBJ
	 BQPnpod5Siq9dJ8YdCPu1ZF9pSoUOdv8Oi5C3qy+Nfp0aePNw098iK0+ZqYIRWHWsf
	 EWv77BB/Cx8QHGoBg4f/49yinqdRzw/0m2imwG08BW05MA3jCznzrWL/UuSddmfBeC
	 FRtDuSncpasi85S4Ef6KU3wMBXf7WdXUVkJsEotK5lOWmbATBxEUVc1DZlE81UWE+I
	 gK6LF8DvSp4y1UmvZlTqpHleQ5zBDxzGSPyqTOf0/01UIg9d312IiV7h0c2rTqf1kc
	 Kkjsqfr71Ku0UlVRUcybUZUYlKjdc4bPLf7AWHIzCB9SDGl0kZvkOLSUyFDUmlvcsn
	 5jjl+zjT3Y7QyGZSbaMpRsoc=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::43])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8193740E00C3;
	Tue, 28 Jul 2026 18:20:11 +0000 (UTC)
Date: Tue, 28 Jul 2026 11:20:07 -0700
From: Borislav Petkov <bp@alien8.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: x86@kernel.org, linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 1/8] x86/fpu: Check for missing AVX and AVX-512 xstate
 bits
Message-ID: <20260728182007.GBamjy17zynlWm2gQT@fat_crate.local>
References: <20260728021603.79870-1-ebiggers@kernel.org>
 <20260728021603.79870-2-ebiggers@kernel.org>
 <20260728052727.GCamg9v5WxNieTMUwE@fat_crate.local>
 <20260728054532.GA99797@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260728054532.GA99797@sol>

On Mon, Jul 27, 2026 at 10:45:32PM -0700, Eric Biggers wrote:
> *xfeatures* 0, not *xfeature* 0.  It's a bitmask.

That doesn't make it more clear. It does "clear cpu caps with missing
xfeatures 0". I can't parse that code, maybe I don't see it yet.

> Hypervisors that set AVX CPUID bits without their prerequisite
> xfeatures. 

Yeah, those are the ones I don't care about.

> Or the host OS, in the case of the UML patch.

That was because UML didn't have cpu_has_xfeatures(), right?
 
> There are about 25 sites where kernel code is checking for this.  This
> is just checking it at the architectural level instead.

So tglx mentioned another case - firmware. Apparently we can have firmware
which fumbles the configuration of those bits and I can very much see that
happening - it is firmware, doh, ofc.

> We could try taking the position that this is not supported at all and
> just delete all the cpu_has_xfeatures() checks without replacing them
> with anything, and see what bug reports we receive (other than all the
> AI ones which we'd need to just ignore).  This would mean just taking
> patches 3-8.  Is that what you'd prefer?

I had another idea this morning: towards the end of fpu__init_system_xstate(),
we have figured out everything we support, components, buffer sizes, etc.
There we also do a paranoia check on the xfeatures mask.

How about we go through the final xfeatures mask and then clear bits which are
wrong?

This way we'll have all the checking done in one place, if checks pass we can
say the machine is ok to do xstate handling and then we can drop all other
checks around the tree.

How does that sound?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
