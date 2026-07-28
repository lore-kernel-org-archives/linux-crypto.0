Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79CBA3D76;
	Tue, 28 Jul 2026 23:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785282028; cv=none; b=lgpCuDoCxb+iviM6vefR75rPXhX0TEo2sb0MIpmw2fe7ztb+1dC7qALg1gWOFTwZ0u1THefUtxRLOfJSkJ37eFAZYxxY8l2hzGlKMxxuhTeJVkz+s6uBFtkqyAXTM+NcFKvp6i1lBFFX3zxRWSkY/QunmRjSP010u2cxF0hYEGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785282028; c=relaxed/simple;
	bh=mItnlyrePsLuQXRUXNCnM5G0mjVKe6EAT4hx66FqgwE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lyaNscSTC6Z7tgJN+SioS4/Qs0dGdBdxJv/FqpfAkP3IK4bzhYgPV3cjNUIvXO+Uvtyy3CQuVTI4yuhdX9SqyQShN4gbZaAEkxSQptLrJk47jAV+RzNP9QqKeb5adqTTyiNlalMmtGr7AZ2wnRTgvV+2/zUFMc5Xp9gysR22Vf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OfFsplAd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OfFsplAd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8BC21F000E9;
	Tue, 28 Jul 2026 23:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785282027;
	bh=7Rf8r0g+YlfII72vupDIEDYAxSFoTywGzyQaBsA2xuc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OfFsplAdU70PzXIlVdB0Es0e0zUjLgTMe8cWC98F+PBq7CLjij+Vx4rfhjM7IdRM6
	 /xzGeQTnzeunHj3LNDV9/ORKghm9DzEkAWDd5t4UpZ3lMbg8ZU0Nij3OdRXqG+ZJ6C
	 N9eW4mWM0zZBfomBhDhfghGKh20i0aHqZazmCcoXjzjM6pYoSHz1zaUV2OsM0CgBQS
	 74myIJiY+C6Lk6ppdVbBESRLFNs9GM85MV6zttNl8EC1f2vgu7KxoT7i0hCBL5rcUG
	 6SWMxaCpIUMibtroSoUxaycBDOanVMc8/pj2D2NiApLnm2BZk4yIo6q1wGWku7pn/a
	 je+c9fA9YcsOw==
Date: Tue, 28 Jul 2026 16:40:25 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: x86@kernel.org, linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 3/8] crypto: x86 - Stop using cpu_has_xfeatures()
Message-ID: <20260728234025.GB3277@quark>
References: <20260728021603.79870-1-ebiggers@kernel.org>
 <20260728021603.79870-4-ebiggers@kernel.org>
 <20260728103018.00938ac6@pumpkin>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728103018.00938ac6@pumpkin>

On Tue, Jul 28, 2026 at 10:30:18AM +0100, David Laight wrote:
> On Mon, 27 Jul 2026 19:15:58 -0700
> Eric Biggers <ebiggers@kernel.org> wrote:
> 
> > Checking both boot_cpu_has(X86_FEATURE_AVX*) and cpu_has_xfeatures() has
> > never really been needed in practice, and it's never been universally
> > done (e.g., lib/raid/ omits cpu_has_xfeatures()).  Nevertheless, both
> > x86 and UML now explicitly clear the AVX and AVX-512 flags if their
> > xfeatures are missing, which should remove any remaining doubts.
> > 
> > Thus, remove all the calls to cpu_has_xfeatures(), as well as the
> > related checks of boot_cpu_has(X86_FEATURE_OSXSAVE).
> > 
> > In a few cases there was no corresponding boot_cpu_has(X86_FEATURE_AVX*)
> > check, so add the missing ones.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> > ---
> ...
> > --- a/arch/x86/crypto/aria_gfni_avx512_glue.c
> > +++ b/arch/x86/crypto/aria_gfni_avx512_glue.c
> > @@ -196,24 +196,15 @@ static struct skcipher_alg aria_algs[] = {
> >  
> >  static int __init aria_avx512_init(void)
> >  {
> > -	const char *feature_name;
> > -
> >  	if (!boot_cpu_has(X86_FEATURE_AVX) ||
> >  	    !boot_cpu_has(X86_FEATURE_AVX2) ||
> 
> Doesn't AVX2 require AVX support?
> 
> >  	    !boot_cpu_has(X86_FEATURE_AVX512F) ||
> >  	    !boot_cpu_has(X86_FEATURE_AVX512VL) ||
> 
> And (less sure) AVX512xxx require AVX2?
> 
> So the extra checks could be reduced.

Yes, but this patch is just intended to clean up the xfeatures and
OSXSAVE checks.  Further cleanups would be separate patches.

- Eric
