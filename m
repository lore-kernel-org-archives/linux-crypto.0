Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFA336AB77;
	Mon, 15 Jun 2026 23:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781567627; cv=none; b=TkMrOIOt2FEnr4iB5edlK3xtyDQrlhFZ8ynWQEA1s+JepNQ/LYa3SxntmQ6oDUCtSQ0ZgNzgNnSEyonBm/gqb98ZLiH+41td+/ZTD88EMD8GK+fCDphXJ5RZWOUhQk2e5MUJmv44rOAhizjSqqzU/qxrtm4xOVYLXvqgThwpQ6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781567627; c=relaxed/simple;
	bh=1Gd1E2gPrjOnwLuGZcpzYjFgFcJ5vek864QssXvdmqw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZUPq0Nupvv6rOgIKHCXF6tnCWMmfXH0M5txDedTrXCUWjp/mEn+RWr9wM5+debIFt/IOUuCuf/sezWg8fdVzUWFzX+YHiT+JcxfqfAhSZU1tcvzbMwV6Pyp1R2YkWu9vnMjL/qsRTxVP9GoveeWLMboRmw9WmnRYhAe47QgXrRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=cIj93yTW; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="cIj93yTW"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id A1C2A40E01CE;
	Mon, 15 Jun 2026 23:53:42 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 2Q7h6KcO9Y6T; Mon, 15 Jun 2026 23:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1781567612; bh=w1+VZxJhd9auI1O1Pph/8OjTinmdD4Jdgbh6toXfWag=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cIj93yTWCM9xvi+L0if5BU9IMKyb2zDaEukgg61A33Wzaf3PfOXb9KE9S8rXAeBC8
	 3iLDtaiWe5A6N0VleIUKi8WmHUEjv5ua0Pb8lrR1G7wB7kVHWniiiuTWt2KNl4aFvl
	 q58y2ihqQcGAufG0LVn2/UrY77Ga0CMTVsoxJFnKgkSAZc2lnCGSRe7iiTonrTgBjx
	 f6qUyip+KqtPB7I7BZLM2jMlVm9pPuYUP5CdJbetYwAzHD3d7LlkbhRosCXyUg/NAg
	 HgyYYnTQDZAW+k4+kpZpNBxuUlI4aokKwM87KLd+ZQ/xYMcy3VjcgpmTIN+bQ7snpo
	 1d2Uu23jWr1XyRvjjnIykfYzQ6QTkNWGi1sjcwkybzWtw40ttdOLoGkRk/UFbidFpC
	 pAa6FGOeRZuzI1nZ/fC6tQr5MtTByevsF7XAFzG0WEqYZpES0hX3kWweU3lulOYila
	 LVLg1lh1vHJp1ZUPhyMuL3F1wwud/I/8CCFht0UwiA1Zg4xz9hTthfdjVP/ZQ1SkYJ
	 UWVgD0OW8Hd4ZR1MIGbAOLN4f0e+cu/xQuaz6h059dMCuRZYX1vALCTPs5BKQMhv33
	 y3IMxXbykTz89TrxJNLqz4f1bysk6kzai5JOpOlXM1DoC4qKqvwbDbIRA9qVa62aB1
	 hbH4tVwKfd2rBib9Zy+0s+6s=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 192B540E01B4;
	Mon, 15 Jun 2026 23:53:21 +0000 (UTC)
Date: Mon, 15 Jun 2026 16:53:18 -0700
From: Borislav Petkov <bp@alien8.de>
To: Eric Biggers <ebiggers@kernel.org>, Richard Weinberger <richard@nod.at>
Cc: x86@kernel.org, Christoph Hellwig <hch@lst.de>,
	linux-crypto@vger.kernel.org,
	David Laight <david.laight.linux@gmail.com>,
	linux-raid@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-um@lists.infradead.org
Subject: Re: [PATCH v3] lib/raid/xor: x86: Add AVX-512 optimized xor_gen()
Message-ID: <20260615235318.GBajCQbuy9dBgKH8L_@fat_crate.local>
References: <20260615190338.26581-1-ebiggers@kernel.org>
 <20260615201050.GB1764@quark>
 <255CAE3E-7FD3-4DC2-B3DE-46BE67EF22A8@alien8.de>
 <20260615212922.GA28589@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260615212922.GA28589@quark>

On Mon, Jun 15, 2026 at 02:29:22PM -0700, Eric Biggers wrote:
> On Mon, Jun 15, 2026 at 09:16:55PM +0000, Borislav Petkov wrote:
> > On June 15, 2026 8:10:50 PM UTC, Eric Biggers <ebiggers@kernel.org> wrote:
> > >
> > >But I wanted to ask: do we really care about the case where features are
> > >"supported" but their XCR0 bits aren't set?  Perhaps the kernel just
> > >doesn't/shouldn't support weird cases like "-cpu max,xsave=off"?
> > >
> > 
> > Yes, our aim is to support only configurations which are actually
> > present in real hardware and not a "oh, it would be good if it did
> > that, just because..."
> 
> Seems reasonable to me.  Would the same apply to UML here?

Good question.

Richi?

> > >If this case indeed needs to be handled, could we make things easier for
> > >the kernel's AVX and AVX-512 optimized code?  Currently AVX-512 needs:
> > >
> > >        if (boot_cpu_has(X86_FEATURE_AVX512F) &&
> > >            cpu_has_xfeatures(XFEATURE_MASK_FP | XFEATURE_MASK_SSE |
> > >                              XFEATURE_MASK_YMM | XFEATURE_MASK_AVX512, NULL))
> > >
> > >How about we make X86_FEATURE_AVX512F depend on XCR0=111xx111, and
> > >X86_FEATURE_AVX depend on XCR0=xxxxx111?  Then the cpu_has_xfeatures()
> > >check wouldn't be needed.  Is there any reason not to do that?
> > 
> >  How do you want to accomplish that? Very early during boot on the BSP
> >  you sanity-check XCR0 and clear feature flags if components are not
> >  set? 
> 
> That would be the idea.  Something similar to what
> arch/x86/kernel/cpu/cpuid-deps.c does. 

Yap.

> Except that seems to only enforce the dependencies when the kernel itself is
> disabling things; if the hypervisor is broken then it just warns.

Not the kernel's problem. We deliberately don't want to maintain a zoo of
options which are not present in real hw. If HV is doing funny things, oh
well...


> In any case, I'd like these to go away:
> 
>     $ git grep cpu_has_xfeatures | wc -l
>     31

Yeah, all in crypto. I can certainly see why.

@dhansen, any other thoughts?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
