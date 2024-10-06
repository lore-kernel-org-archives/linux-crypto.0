Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F9B28EC;
	Sun,  6 Oct 2024 03:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728183981; cv=none; b=agST9wcficoTIPXKq8JkGXBfHiNbtUjHZAV5V4YyCMpqw36dMFguTjzwk4NJRyMPiZC9YTzNewR0jrB69AASR2jLj+yJUtTmFhvwuSD28CW29ucLz2JqNt2HKKfAHQOpHT40o35s/4mAFVDVZQ5ufhxdmpW3MLksUdhIVV+/GSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728183981; c=relaxed/simple;
	bh=ETNj5oHnep03n1zYQGiydmptlifreHJ4JKWMm0PPgOc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sNMM8+nE7g131Q93rKNt27ijmFmNQ6gOIvT9HOM0ZXErkptejG8+r57ggVbPiPARTEr9h5f+rcSwNgxpCzbij2UoXkzM/eR0jl0Rriv2+jCSkLgSYgPbHxTXeAID5YqZMmyXmA6d6jemEfaqruSZv7lzSRaKSu0MP5AWlX28ByI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hV2G4zpX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hV2G4zpX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69497C4CEC7;
	Sun,  6 Oct 2024 03:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728183980;
	bh=ETNj5oHnep03n1zYQGiydmptlifreHJ4JKWMm0PPgOc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hV2G4zpXb6FS3EYmY1dNy7oN22blnsHgQ6m/M/VOeC5FAHoXgwfS3NNr7uHlPd5xs
	 pJ4tcEZukTm6rKvLbw7Z+m4cw2IetDpX7wJeo14/w3PQkA8crC+EywxkvN8WNG5CHg
	 HBvlAbRNCuojtTRWZ8uiUioVZPHt2n120hQkRXcdDWjP7YZmjOizjk/Y+B9HZHuI8b
	 fTNvNUi59ae11aZ5Aoe41bWi0NABLzyPp8T4YxQIQ+L8AwLJo11T7OQKT///485X3A
	 uFGYSGHJQRbw/ovW87FUXar/vRiYm0Et8a0k3qKTlJS3lTGqupuZ0seIoWSZm7oyjW
	 vOLoerDuHyMDw==
Date: Sat, 5 Oct 2024 20:06:18 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: kernel test robot <oliver.sang@intel.com>, oe-lkp@lists.linux.dev,
	lkp@intel.com, linux-crypto@vger.kernel.org, ltp@lists.linux.it,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Russell King (Oracle)" <linux@armlinux.org.uk>,
	Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: api - Fix generic algorithm self-test races
Message-ID: <20241006030618.GA30755@sol.localdomain>
References: <ZsBJ5H4JExArHGVw@gondor.apana.org.au>
 <ZsBKG0la0m69Dyq3@gondor.apana.org.au>
 <20240827184839.GD2049@sol.localdomain>
 <Zs6SiBOdasO9Thd1@gondor.apana.org.au>
 <20240830175154.GA48019@sol.localdomain>
 <ZtQgVOnK6WzdIDlU@gondor.apana.org.au>
 <20240902170554.GA77251@sol.localdomain>
 <ZtZFOgh3WylktM1E@gondor.apana.org.au>
 <20241005222448.GB10813@sol.localdomain>
 <ZwHfiNsP7fUvDwbH@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZwHfiNsP7fUvDwbH@gondor.apana.org.au>

On Sun, Oct 06, 2024 at 08:53:28AM +0800, Herbert Xu wrote:
> On Sat, Oct 05, 2024 at 03:24:48PM -0700, Eric Biggers wrote:
> >
> > The tests are still failing on upstream:
> > 
> > [    0.343845] alg: self-tests for rfc4106(gcm(aes)) using rfc4106(gcm_base(ctr(aes-generic),ghash-generic)) failed (rc=-2)
> 
> You're right.  I only disabled the warnings at the point of
> allocation, the overall self-test warning is still there.  Let
> me get rid of them too.
> 
> > Besides the test failures, it looks like there's no longer any guarantee that
> > algorithms are actually available now that their module is loaded.
> 
> That would indeed be a bug.  But I haven't seen it in practice.
> Although the s390 folks were reporting some weird errors with
> dm-crypt, they have recently disappeared.
> 
> If you do see an actual failure please report it and then I'll
> consider reverting it until it's fixed.
> 
> > E.g. consider if someone does 'modprobe aesni-intel' and then immediately
> > creates a dm-crypt device.  Now it sounds like the AES-NI algorithms might not
> > have finished being tested yet and the generic algorithms can be used instead,
> > resulting in a performance regression.
> 
> That is not the case.  After modprobe returns, the algorithm is
> guaranteed to have been registered.  Yes it is untested, but that
> should not be a problem because a test larval will have been created
> and all users looking for that algorithm will be waiting on that
> test larval.

I'm not sure about that, since the code that looks up algorithms only looks for
algorithms that already have the CRYPTO_ALG_TESTED flag.

> > I understand that you want to try to fix the edge cases in "fallback" ciphers.
> > But "fallback" ciphers have always seemed like a bad design due to how they use
> > the crypto API recursively.  I think the algorithms that use them should
> > generally be migrated off of them, e.g. as I did in commit f235bc11cc95
> > ("crypto: arm/aes-neonbs - go back to using aes-arm directly").  That fixed the
> > problem in aes-neonbs that seems to have triggered this work in the first place.
> 
> Yes getting rid of fallbacks is nice, but this it not the reason why
> we're making self-test asynchronous.  The primary issue with synchronous
> self-tests is the modprobe dead-lock.

That problem is caused by the use of fallback ciphers, though.

- Eric
