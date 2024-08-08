Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F9B4A1E
	for <linux-crypto@vger.kernel.org>; Thu,  8 Aug 2024 06:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723097894; cv=none; b=QlYLhgmPboafAHlt6CCy1+HAib/bLaTm5RV6ehe+8kJ0taQ4HdKPx1ldfPZwK+KS8VJn3SSaLKwrKRtOSWTANj/7jTacRxGPResylkaPitOYnI6PJNY2doOeXuqi2J3DYY4coMQ7WczKLPZF12MF2tahpDUv7KLn603OQWC60g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723097894; c=relaxed/simple;
	bh=FtyhJIavrVDQ+Z1IjR1Tdo19yNmHRlkUc1RHk5qOQSk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FvVvFc9Nenb5psByg76WYc9/tYxdJTyN/0m3NZO1qijcEJLFmQIE7Kf+U8f74ZfMZNEOgk7WCN3Rk/NWunBMdxXGj8oYR4wDhgRguZECCj7/vqoO4Oc6+PU/GHaf4P8FEEkPnxK+194R+ju+yZJy4t/HUKc4QsvfmU67KZa8mEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sbwKd-003Ega-07;
	Thu, 08 Aug 2024 14:17:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 08 Aug 2024 14:17:48 +0800
Date: Thu, 8 Aug 2024 14:17:48 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Subject: Re: [BUG] More issues with arm/aes-neonbs
Message-ID: <ZrRjDHKHUheXkYTH@gondor.apana.org.au>
References: <ZrFHLqvFqhzykuYw@shell.armlinux.org.uk>
 <ZrH8Wf2Fgb_qS8N4@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZrH8Wf2Fgb_qS8N4@gondor.apana.org.au>

On Tue, Aug 06, 2024 at 06:35:05PM +0800, Herbert Xu wrote:
> On Mon, Aug 05, 2024 at 10:42:06PM +0100, Russell King (Oracle) wrote:
> >
> > We get to the __cbc(aes) entry, and this one seems to trigger the
> > larval_wait thing. With debug in crypto_alg_mod_lookup(), I find
> > this:
> > 
> > [   25.131852] modprobe:613: crypto_alg_mod_lookup: name=cbc(aes) type=0x5 mask=0x218e ok=32769
> > ...
> > [   87.015070]   name=cbc(aes) alg=0xffffff92
> > 
> > and 0xffffff92 is an error-pointer for ETIMEDOUT.
> 
> Looks like something has gone wrong during the instantiation of
> the fallback cbc algorithm.  I'm looking into it.

OK I tracked it down to a recursive module load that hangs because
of this commit:

commit 9b9879fc03275ffe0da328cf5b864d9e694167c8
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon May 29 21:39:51 2023 -0400

    modules: catch concurrent module loads, treat them as idempotent

So what's happening here is that the first modprobe tries to load
a fallback CBC implementation, in doing so it triggers a load of
the exact same module due to module aliases.

IOW we're loading aes-arm-bs which provides cbc(aes).  However, this
needs a fallback of cbc(aes) to operate, which is made out of the
generic cbc module + any implementation of aes, or ecb(aes).  The
latter happens to also be provided by aes-arm-cb so that's why it
tries to load the same module again.

Now I presume this used to just fail immediately which is OK because
user-space would then try to load other aliases of ecb(aes).  But it
now hangs which causes the whole thing to freeze until a timeout
hits somwhere along the line.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
