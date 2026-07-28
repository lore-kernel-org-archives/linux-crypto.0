Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881A632B104;
	Tue, 28 Jul 2026 05:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785217648; cv=none; b=uHrodP19W4yNjyLZ57/wLdSaR11nytlbuhCotY7GGVXFq1T6ZnuYLf9KSrvPvSFTDAkT1uX5/JpCDNHVQEXcTPbIVwcjFPr+3/4yRI2Yjo9deVjAPU1jfztmfcNA6WLMUPQOKwdJnp0X50baA6dV7w2TM3ejj0JrOaDdOD0zrT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785217648; c=relaxed/simple;
	bh=tUeWwdzdbYHQUY1CsHfvb3cHSENA5Lhs/60BQz8RitU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VNwwoN3fkQFwVecinNx7cpzROwTIrcf09ElbREteZtT3bRcICWSPEWfsyVbKtal/pNoSmNFivkdd1s3yNEPe4aF6MPixbhMkWmPdqxvFfrtmdcqIXqRFihxjcG8UNcQD34Af09od6WnZxmWgpdQ9cNo7o2dDWA92XfPJEiGhuvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J/wFEFj+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J/wFEFj+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEEF31F000E9;
	Tue, 28 Jul 2026 05:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785217647;
	bh=/WvQzs9YepCJcng+hHY8F+2scwCSw2dfE4FzGWyO5dg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=J/wFEFj+O0iRwvaDbNvQ5HxxU5s7m3c1yqItx22/2mL56DTnTev0+GIpWnab3sNzA
	 phXBUloWblfcosZe357mj2tNsXZzwvHHpeaOyq1I9kEoCPua2xTzz1AMCG5bfOlWm4
	 7o95g3wZ615OORPKnPnuBjMR1/TL2rekOe+BtYMzzPZgbtPtkpw2U95cMwHFnt+1zT
	 9nJ9X1/2/zq8EPe1MdOGRCOnnnXqQyJ+sFO3HL94K+iIj3PqZM0ukmKhcOKq9mVR5p
	 +HVUaYWCfTEzBwbwVpnJreQany677gtBW5mPk8Xr9YjFLKI8BExrKcqIAPtJbYyQs1
	 0q5dIWiM9BRrg==
Date: Mon, 27 Jul 2026 22:45:32 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org, linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 1/8] x86/fpu: Check for missing AVX and AVX-512 xstate
 bits
Message-ID: <20260728054532.GA99797@sol>
References: <20260728021603.79870-1-ebiggers@kernel.org>
 <20260728021603.79870-2-ebiggers@kernel.org>
 <20260728052727.GCamg9v5WxNieTMUwE@fat_crate.local>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728052727.GCamg9v5WxNieTMUwE@fat_crate.local>

On Mon, Jul 27, 2026 at 10:27:27PM -0700, Borislav Petkov wrote:
> > @@ -812,12 +829,14 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
> >  
> >  	if (!boot_cpu_has(X86_FEATURE_FPU)) {
> >  		pr_info("x86/fpu: No FPU detected\n");
> > +		clear_cpu_caps_with_missing_xfeatures(0);
> >  		return;
> >  	}
> >  
> >  	if (!boot_cpu_has(X86_FEATURE_XSAVE)) {
> >  		pr_info("x86/fpu: x87 FPU will use %s\n",
> >  			boot_cpu_has(X86_FEATURE_FXSR) ? "FXSAVE" : "FSAVE");
> > +		clear_cpu_caps_with_missing_xfeatures(0);
> 
> Also, I'm not really clear on the usage here: if the CPU doesn't have FPU or
> XSAVE, we pass in xfeature 0 which is XFEATURE_FP in both cases. And then we
> clear AVX and AVX-512.
> 
> The 0 is basically forcing the checks in the function to match, i.e., it looks
> to me like we're defining a new interface but then we're misusing it so that
> those basic CPU flags are cleared.

*xfeatures* 0, not *xfeature* 0.  It's a bitmask.

> What are we even protecting against here?
> 
> AVX and AVX-512 code needs to check whether it has FPU and XSAVE support?
> 
> I.e., we're protecting against some weird guests?
> 
> I wanna say, we should not protect but let them crash'n'burn in big big flames
> which can be seen from a mile away.
> 
> Or do you have a sensible use case in mind which we really wanna protect
> against and this all actually makes sense?

Hypervisors that set AVX CPUID bits without their prerequisite
xfeatures.  Or the host OS, in the case of the UML patch.

There are about 25 sites where kernel code is checking for this.  This
is just checking it at the architectural level instead.

We could try taking the position that this is not supported at all and
just delete all the cpu_has_xfeatures() checks without replacing them
with anything, and see what bug reports we receive (other than all the
AI ones which we'd need to just ignore).  This would mean just taking
patches 3-8.  Is that what you'd prefer?

- Eric
