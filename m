Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9214623D28F;
	Tue,  6 May 2025 13:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746537553; cv=none; b=fMuraMF6XFT0ckt5/jf6UR1YVGQhesMKLydsNClPFr8ryScC1xUHyp8qZGLoCQL6FQk9N2ncBpn+YZLplbH31cmsLJ8toopS5LWGd3k5wxHSddRiLG6kB0nH1OS3LItlN85GO2z29hPe29CssudnKFUSF+6X5VU5jBjxrCgKhYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746537553; c=relaxed/simple;
	bh=iUzddKqL0iIvG6UutN1G6gNVWdgxVSxIUnXyf4QycaU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QMo83O4OZdHIctTSuWZm6nKpNxVRXbwX5FVHMQ3H1UqOucrV74jYDjGs1pi43ViEAYVmb/kUJxJNCF3HX+hld9XGH7eyCGl7PGJSeCYsZtMkYOfvTYb2PGd6l9ag/SYJenKjg5X6q9XhHMsPYO9LKNRb/Q7jy7NEJxHXWOy9RMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=k/vn7zxc; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="k/vn7zxc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=kHR2Y14bKRrsW5EJnr2zMkLPuETcVkgoZdQEZZ47vSE=; b=k/vn7zxcxor1/UJyd8b3ED6c6Z
	2WbLB6yu4YlPVHMb11J69ZG3daWi7WPctkWSF00cnzAAfBy70+fuY2717t7ZLYomDVd682NtZrn6X
	QwyenJE/BpAc35Mm/f1CaU0nzBp4BfB7Vx7EdudUL4fMl5Lp6YlRKly7I+U9hishlxdBgIY94qFOA
	W9jGO6pC4QYjDqs/qC8JUAXw8XJWy145TviuaK8h91ecFu2SP3Cs1GgpdydJs1D4ShM2iMcE6CziW
	2gbDDKBS7davfZrmTG0X0/6mDWJpaAlKWPaJg8qBchiIvS4OXnVbjJGRPFULvhiUDkrG7j0Xl2Mb+
	EadVEoDg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uCICO-003y4w-2N;
	Tue, 06 May 2025 21:19:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 06 May 2025 21:19:04 +0800
Date: Tue, 6 May 2025 21:19:04 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Klaus Kudielka <klaus.kudielka@gmail.com>
Cc: regressions@lists.linux.dev, linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>,
	Romain Perier <romain.perier@free-electrons.com>
Subject: Re: [REGRESSION] alg: ahash: Several tests fail during boot on
 Turris Omnia
Message-ID: <aBoMSHEMYj6FbH8o@gondor.apana.org.au>
References: <ZwObXYVHJlBaKuj2@gondor.apana.org.au>
 <38a275a4e0224266ceb9ce822e3860fe9209d50c.camel@gmail.com>
 <ZwZAExmK52txvHE8@gondor.apana.org.au>
 <7e38e34adddb14d0a23a13cf738b6b7cccbfce6f.camel@gmail.com>
 <ZwduxHxQtHdzz-kl@gondor.apana.org.au>
 <ZwePSPG8aWm6mwKK@gondor.apana.org.au>
 <15fadc356b73a1e8e24183f284b5c0a44a53e679.camel@gmail.com>
 <Zw31JIEyh28vK9q7@gondor.apana.org.au>
 <5db212655dc98945fa3f529925821879a03ff554.camel@gmail.com>
 <Zw9AsgqKHJfySScx@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zw9AsgqKHJfySScx@gondor.apana.org.au>

On Wed, Oct 16, 2024 at 12:27:30PM +0800, Herbert Xu wrote:
> On Tue, Oct 15, 2024 at 07:38:27PM +0200, Klaus Kudielka wrote:
> >
> > So, I applied the TDMA-disable patch, and I saw the same errors.
> > Then, I applied the printk patch on top of that, and here is the result.
> > 
> > Not sure, whether this makes any sense...
> 
> Interesting, I think this shows that the non-TDMA path doesn't
> work at all :)

So I'm looking at this driver again as part of my partial block
work to eliminate partial block handling from drivers.

I haven't figured out exactly what's wrong with tdma, although
the chaining IRQ completion handling looks a bit fragile in that
if something goes wrong it'll simply mark all queued requests as
complete, corrupting any requests that have not yet been sent to
the hardware.

However, I think I know what's wrong with the non-DMA path.  I
dug up the old mv_cesa driver and it's clear that it simply can't
handle zero-length final updates like a lot of other hardware drivers.
This matches with what you sent me where all the test vectors that
failed was test 0 which is a zero-length update.

There used to be a fallback path but during the move to tdma
that appears to have been lost.

So if you're still interested I can create some patches for you
to test.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
