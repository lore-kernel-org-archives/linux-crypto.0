Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2ED3242C0;
	Mon, 12 Jan 2026 19:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768246511; cv=none; b=gaOvj3zkc3PNuw/KdC1xswGAwYbB5mRjDCBkviBTRcLwOMBTSXkdqSSvLu+1rJO2+SIryHdpScZZsSbHwyrTJVjpHbbhaTnIFLG4FJENjFYk5gnBAXolP9B8robLN+1z45hZjdUMWolGbLDqjWPQx43uxC7JQ3+OZkJxqOcSDcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768246511; c=relaxed/simple;
	bh=ZUv9WOpoHSeCX9aDulOlpT8OUBsrCsexexznfgOSVEo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ODXdHNou1n43qRrl1IWW1of1bp/FTEsjOlYcjtv3Fnwb2qaqalFms/GRXSUcqOpnRxRbNyqVzE2OslfPg9+oIAdKp6X2hv0XWeii48LXLFgKjEHVlf0B80o2tRgRiRonAnKGNI0nirU2rEyU7gq5+EqUWLS4cn96wtBFX1hpW48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qkEcPXJW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qkEcPXJW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB19C116D0;
	Mon, 12 Jan 2026 19:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768246511;
	bh=ZUv9WOpoHSeCX9aDulOlpT8OUBsrCsexexznfgOSVEo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qkEcPXJWfvwYKw+qy3NDNf7Z/OyAoDvn3EtR2/iOKYwezSds2lZ/qOklle1QZf/RS
	 0n0M/se6V2RScgyCVWHzoKqAuHBkLG+npgnZ/hkQNaUmdEMS8SMqc5iNRI3hM305pe
	 5G4XuZI2hC2R2kGkAuwkn1s2N+qZuxDVtg0X7ixCwoqRSly1h/nTzUF/ZDmv7lOLzh
	 3kpZQAFEhWTeMBp5aqTUXVSShJkCmIDCZqoj1MUyTL0F8E1sBOlG+e1Qkq99awf+XC
	 L3aF8KO7N2Glp16xy++xBV238ItTYL3GJZmfRQvhL2B+JiGkP6QbxCBCuNGy5JTRtn
	 bv/7KB6FxaUjA==
Date: Mon, 12 Jan 2026 11:34:45 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: AlanSong-oc <AlanSong-oc@zhaoxin.com>
Cc: herbert@gondor.apana.org.au, Jason@zx2c4.com, ardb@kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	CobeChen@zhaoxin.com, TonyWWang-oc@zhaoxin.com, YunShen@zhaoxin.com,
	GeorgeXue@zhaoxin.com, LeoLiu-oc@zhaoxin.com, HansHu@zhaoxin.com,
	x86@kernel.org
Subject: Re: [PATCH v2 1/2] lib/crypto: x86/sha1: PHE Extensions optimized
 SHA1 transform function
Message-ID: <20260112193445.GA1952@sol>
References: <cover.1766131281.git.AlanSong-oc@zhaoxin.com>
 <aa8ed72a109480887bdb3f3b36af372eadf0e499.1766131281.git.AlanSong-oc@zhaoxin.com>
 <20251219181805.GA1797@sol>
 <7aa1603d-6520-414a-a2a1-3a5289724814@zhaoxin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7aa1603d-6520-414a-a2a1-3a5289724814@zhaoxin.com>

On Mon, Jan 12, 2026 at 05:12:01PM +0800, AlanSong-oc wrote:
> > Is it supported in both 32-bit and 64-bit modes?  Your patch doesn't
> > check for CONFIG_64BIT.  Should it?  New optimized assembly code
> > generally should be 64-bit only.
> 
> The XSHA1 and XSHA256 are supported in both 32-bit and 64-bit modes.
> Since newly optimized assembly code is typically 64-bit only, and XSHA1
> and XSHA256 fully support 64-bit mode, an explicit CONFIG_64BIT check
> should not required.

Right, all the x86-optimized SHA-1 and SHA-256 code is already 64-bit
specific, due to CONFIG_CRYPTO_LIB_SHA1_ARCH and
CONFIG_CRYPTO_LIB_SHA256_ARCH being enabled only when CONFIG_x86_64=y.
So there's no need to check for 64-bit again.

> > What is the difference between X86_FEATURE_PHE and X86_FEATURE_PHE_EN,
> > and why are both needed?
> 
> The X86_FEATURE_PHE indicates the presence of the XSHA1 and XSHA256
> instructions, whereas the X86_FEATURE_PHE_EN indicates that these
> instructions are enabled for normal use.

I still don't understand the difference.

If you look at the other CPU feature flags, like X86_FEATURE_SHA_NI for
example, there's just a single flag for the feature.  We don't have
X86_FEATURE_SHA_NI and X86_FEATURE_SHA_NI_EN.  If the CPU supports the
feature but the kernel decides it can't or shouldn't be used for
whatever reason, the kernel just doesn't set the flag.  There's no
separate flag that tracks the CPU support independently.

Why can't the PHE flag work the same way?

- Eric
