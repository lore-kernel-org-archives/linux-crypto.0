Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDE8396585;
	Thu, 30 Jul 2026 16:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785430669; cv=none; b=DXl1nTmuSAX+T1RTgz/G8Vtjlj9QbZLcvI0LpytCQqRZCOyMdGZ5g6xOuM0n8ZzEf3s56laSR7UUkokCKCz5h/7gLYuVHPMQACDfoyQ2ZyMC50Ud5E+DTO/oCoOSCvr94DArIbzKJdrXwjkCo0UrHKjij6/BrOsCGnW5un+3Xgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785430669; c=relaxed/simple;
	bh=jPzLiE7b8sZqF+LkbWCxliO/nX5XaqE88wqjw6DkOnA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R03/5hlQqaXcl7qbEn0UXX4saqJmvaKfbxfBxlDv6h5g/02uaHakIUVvHSIpeIaAzeHc/4SVxRq0si1i8yfhrXZx0+i71NliSVMz7m9w4JuVwD6KJyNBZXGgeRNVxIH2pYOk3yEyGshfClawEh4pIRgWJ3bx2QwOTbQPiEvKv5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=laOLGCZN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="laOLGCZN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 929D51F000E9;
	Thu, 30 Jul 2026 16:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785430668;
	bh=3bcKokUqdPaXoMUDMtvXsTQyT+FZtK1MsnPaQ8OCF1U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=laOLGCZNeVhuQdhow/VEsFBFqK+pW1pZpEZa9T9ygmMDat1UHzlosXnYuCq747la7
	 rX/1TJmeQ8WzDeDXJUvV7u8NspnstPlHy2AdF/pxNd1rDkvBQwGt+tc0gfFh+9b6eI
	 yeS33wUFZcClGJM3JZM/mYpcmrmwPEaVnCTh1pUC2eG0mV6OY0cVr7cNOHoQh5DYLQ
	 noe/su9nQyL0Cv6UsDuDfsdthEbwK3vWbqb8cX9dBfRNJiVTr9EFgI0eWYklWQndoy
	 D7g7+AP0HCanhbPFkl1B5ee7hz29rb/PHdVeCSbAEPyO4Zpq+00xfnjFk0QUEfrQ3T
	 6zoaaS7rYtjQw==
Date: Thu, 30 Jul 2026 09:55:53 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Richard Weinberger <richard@sigma-star.at>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Richard Weinberger <richard@nod.at>, upstream@sigma-star.at,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	demiobenour@gmail.com, davem@davemloft.net,
	upstream+linux@sigma-star.at
Subject: Re: [PATCH] crypto: af_alg: Allow cbc(paes)
Message-ID: <20260730165553.GA3139@sol>
References: <20260726192716.2351505-1-richard@nod.at>
 <5915345.sfYGdeWWPf@nailgun>
 <amsDLRticYiBYeVP@gondor.apana.org.au>
 <4313653.jTJXf6HLCa@nailgun>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4313653.jTJXf6HLCa@nailgun>

On Thu, Jul 30, 2026 at 09:56:41AM +0200, Richard Weinberger wrote:
> On Donnerstag, 30. Juli 2026 09:54 Herbert Xu wrote:
> > On Thu, Jul 30, 2026 at 09:52:44AM +0200, Richard Weinberger wrote:
> > >
> > > Eric asked me to wait a bit before I send a patch for next:
> > > https://lore.kernel.org/linux-crypto/20260727172004.GA877700@google.com/
> > 
> > Well if I'm going to apply your patch I need to know what you want
> > this to do in next.
> > 
> > Are you happy to leave it as denied for next?
> 
> No.
> I'll happily send a patch for next just.
> 
> I just did what Eric told me and waited.
> 
> Thanks,
> //richard

I assumed it would be:
    
    1. patch crypto/master (for 7.2)
    2. merge crypto/master into cryptodev/master
    3. patch cryptodev/master to add an allowlist entry (for the
       algorithm name, not the mask which was already done by (1))

But Herbert maintains this code, so if he wants them to merge in another
order you'll need to do that.

I'm not sure why my email above is linked to.  That email was about the
implementation, not where/when the patches should go.

- Eric
