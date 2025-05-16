Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186F526C38E;
	Fri, 16 May 2025 17:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747415006; cv=none; b=puyBnLuS93I/MMaATjqzbs7OnXH51rLIvv0rfEStZzYTAMjwB/EpXMbC8HzC0A7oOZXk1kW525A7kbYHNGn7BSYqmHBedGt5j+Fy4a9QFUK/dPzkIug5hjWTozfBt3xf7XJhQ7d3C3yNmAMFMJo7DKGLpHqQCg2CkBhrkHrqXmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747415006; c=relaxed/simple;
	bh=t7L/mDLEjwlOUNwI2tKMC7EU8XgkPK5SpHN+h9gxzcg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SLKIbwX5Lkd18KoRg1I0UwvgSksOVsdNnvDde62QtldnZWBABQAPnu2eH9oglR7SFpd4oSmIqeeh8zmZ+UOQFmQGJzCWNPWVgSG35XeQasI0b1ieUZVgvlWRAKL7LmI7uGCYz0vMxeOfTghEnDIhSXqmVaQdv02BLwNCvsrdtvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=awYfYYzu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="awYfYYzu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A1AC4CEE4;
	Fri, 16 May 2025 17:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747415005;
	bh=t7L/mDLEjwlOUNwI2tKMC7EU8XgkPK5SpHN+h9gxzcg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=awYfYYzugx8Cc6kViojDPfxwYr8R4s7Zn/4EXllQCYeWVuJdNd0KQMh+6e1UKZ8c9
	 DkZEq9H2Rgg78pjXrGJvNp4hEP5/Qn3D2IIPUuE22LSGYFj2P10aFcumf0XJHQIyz7
	 szmK3V1L05l0kxOcc7vPIUZaAVaAuKVWbslOy5CmPWcFc83pKLKNsYnuHnja1GuTcX
	 HPzAkpqrH7BgEK1aYx2y1hR42LLH0PxKiD5FZwP479Qbzv//lBzHFGfCqoGuynowBS
	 DesAi2wkCX85ZXYIz62x45SjEiYxF7ARYL6cgOX/Bg00r66P1LOznboT3kv5gFP8Op
	 peAylNkPKouTw==
Date: Fri, 16 May 2025 10:03:16 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Borislav Petkov <bp@alien8.de>, Jain@formenos.rohan.me.apana.org.au,
	Ayush <Ayush.Jain3@amd.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, x86-ml <x86@kernel.org>,
	lkml <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: lib/sha256 - Disable SIMD
Message-ID: <20250516170316.GD1241@sol>
References: <20250516112217.GBaCcf6Yoc6LkIIryP@fat_crate.local>
 <aCcirrsFFrrRqf5A@gondor.apana.org.au>
 <aCcmJGuCnuyHmHbx@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCcmJGuCnuyHmHbx@gondor.apana.org.au>

On Fri, May 16, 2025 at 07:48:52PM +0800, Herbert Xu wrote:
> On Fri, May 16, 2025 at 07:34:06PM +0800, Herbert Xu wrote:
> > 
> > So what's happened is that previously if you call sha256_update
> > from lib/crypto it would only use the generic C code to perform
> > the operation.
> > 
> > This has now been changed to automatically use SIMD instructions
> > which obviously blew up in your case.
> 
> In the interim you can go back to the old ways and disable SIMD
> for lib/crypto sha256 with this patch:
> 
> ---8<---
> Disable SIMD usage in lib/crypto sha256 as it is causing crashes.
> 
> Reported-by: Borislav Petkov <bp@alien8.de>
> Fixes: 950e5c84118c ("crypto: sha256 - support arch-optimized lib and expose through shash")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

That's silly.  We should just fix x86's irq_fpu_usable() to return false before
the CPU is properly initialized.  It already checks a per-cpu bool, so it
shouldn't be too hard to fit that in.

Using the generic SHA-256 code explicitly is also an option, but ideally the
regular functions would just work.

- Eric
