Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE764219E1
	for <linux-crypto@vger.kernel.org>; Fri,  9 Aug 2024 04:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723178459; cv=none; b=HQ/Jh+inO8YC9eF5ZcnpgMP/r5KgQknzLd/ZIXT+0a8pJMN41/hr5gtaMn0tk3o0iqoR+4AWlbpRZNZ2wAzxM0yIlL7j6Qjrruh2wgtC/q/XzW6tLWpK9QkTRHRwCJdnQLpqyn9OJUOEf18zhcnS+xChTiY7RC4dcFPmBCjNq9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723178459; c=relaxed/simple;
	bh=ZCS7VJryxpjUdYt7COo+g0Ymu4UajtqPGOBQwqWqX7A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fg3gLDJ/rg7zYAy4ee33BQZCyIAbIkD5ysJpu/J8nRE+BZXBboM1u8sqNkF/2wkjN87G4i9sxKJDg1cZXrntYTWgOLb+r/g9kHWrS5YGjtbbYTfzBkvHaaZ1Hq/7c+/vuxnAQSPFMiB5jXPPanQPpaSaP8AWBbmnW0DAX3w9vac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1scHIA-003TPe-0Q;
	Fri, 09 Aug 2024 12:40:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 09 Aug 2024 12:40:39 +0800
Date: Fri, 9 Aug 2024 12:40:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>,
	Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Subject: Re: [BUG] More issues with arm/aes-neonbs
Message-ID: <ZrWdx5cL1vKrMBbs@gondor.apana.org.au>
References: <ZrFHLqvFqhzykuYw@shell.armlinux.org.uk>
 <ZrH8Wf2Fgb_qS8N4@gondor.apana.org.au>
 <ZrRjDHKHUheXkYTH@gondor.apana.org.au>
 <CAHk-=wjLFeE_kT5YHfHsX9+Mn10d2p+PQ0S-wK0M3kTFe37o_Q@mail.gmail.com>
 <CAHk-=wgzTrrpY3Z2881FAtz=oLYzAPhbVxd8hdiPopsF-pWG=w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgzTrrpY3Z2881FAtz=oLYzAPhbVxd8hdiPopsF-pWG=w@mail.gmail.com>

On Thu, Aug 08, 2024 at 12:54:10PM -0700, Linus Torvalds wrote:
>
> I don't know the crypto registration API enough to even guess at what
> the fix to break the recursion is.
> 
> Herbert?

Yes my plan is to fix this in the Crypto API and not do any recursive
loads as we used to do.

The immediate cause of the recursive load is the self-test system
(if it is not disabled through Kconfig).  The algorithm registration
does not return until after the self-test has successfully executed.
For the algorithm in question, that involves loading a fallback
algorithm which is what triggered the recursive module load.

We had an issue when algorithms were built into the kernel, where
due to the random of registration calls, a self-test may invoke
an algorithm which is built into the kernel but not yet registered.
There it was resolved by postponing all self-tests until all
algorithms had been registered (or when an algorithm was first used,
which would trigger the self-test for that algorithm there and then).

I will extend this to modules and let the registration return
as soon as the new algorithm can be looked up.  The self-test
can then complete asynchronously.

Russell, is it OK with you if we only resolve this in the mainline
kernel or do you want a solution that can be backported as well?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
