From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] [PATCH 2/5] aead: Add generic aead wrapper interface
Date: Tue, 2 Jun 2009 19:28:15 +1000
Message-ID: <20090602092815.GA26832@gondor.apana.org.au>
References: <20090513130618.GD20366@secunet.com> <20090513130818.GF20366@secunet.com> <20090602035041.GB22831@gondor.apana.org.au> <20090602092151.GJ20366@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:47711 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753185AbZFBJ2T (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Jun 2009 05:28:19 -0400
Content-Disposition: inline
In-Reply-To: <20090602092151.GJ20366@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 02, 2009 at 11:21:51AM +0200, Steffen Klassert wrote:
> 
> The reason for the wrap work is to have a possibility to choose a
> certain version of an algorithm as the system default. The advantage
> e.g. for pcrypt is that we can turn over the whole system to pcrypt,
> or we can choose for pcrypt by the algorithm name if we want to use
> it just for a subset of transforms. In particular we have a possibility
> to use pcrypt without touching other subsystems (like networking) and
> userspace tools for now.

Yes but what you're creating is a user-space API.  IMHO we don't
want to have ad-hoc APIs such as this scattered around the place.
pcrypt is certainly not the only algorithm that needs to be able
to decide whether it should serve as the system default.

So what I suggest is that you make pcrypt take a higher priority
for now, so that it always is the default once instantiated.
After all if you instantiate it then you probably want to use it
as the default.

We can then work on the generic user-space API to control crypto
API algorithms, in particular, allow the user to change their
priorities so as to determine the system default.

This has been on my todo list for years, but it has never risen
to the top.  What I have in mind is a netlink protocol not unlike
xfrm which controls crypto algorithm properties (and queries them
so we can obsolete /proc/crypto).

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
