From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [RFC] [PATCH 2/5] aead: Add generic aead wrapper interface
Date: Wed, 3 Jun 2009 11:32:16 +0200
Message-ID: <20090603093216.GK20366@secunet.com>
References: <20090513130618.GD20366@secunet.com> <20090513130818.GF20366@secunet.com> <20090602035041.GB22831@gondor.apana.org.au> <20090602092151.GJ20366@secunet.com> <20090602092815.GA26832@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:51634 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050AbZFCJ3v (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Jun 2009 05:29:51 -0400
Content-Disposition: inline
In-Reply-To: <20090602092815.GA26832@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 02, 2009 at 07:28:15PM +1000, Herbert Xu wrote:
> On Tue, Jun 02, 2009 at 11:21:51AM +0200, Steffen Klassert wrote:
> > 
> > The reason for the wrap work is to have a possibility to choose a
> > certain version of an algorithm as the system default. The advantage
> > e.g. for pcrypt is that we can turn over the whole system to pcrypt,
> > or we can choose for pcrypt by the algorithm name if we want to use
> > it just for a subset of transforms. In particular we have a possibility
> > to use pcrypt without touching other subsystems (like networking) and
> > userspace tools for now.
> 
> Yes but what you're creating is a user-space API.  IMHO we don't
> want to have ad-hoc APIs such as this scattered around the place.
> pcrypt is certainly not the only algorithm that needs to be able
> to decide whether it should serve as the system default.

Hm, I have not considered this as an user-space API. It just adds the
possibility to wrap an arbitrary crypto template arround a given aead
type algorithm, similar than aead_geniv wraps a IV generator template
arround a nivaead type algorithm.

The thing that connects this to user-space is the authenc patch by
adding the possibility to set a wrapper name with a module parameter.
This is probaply such an ad-hoc API that you want to avoid, right?

> 
> So what I suggest is that you make pcrypt take a higher priority
> for now, so that it always is the default once instantiated.
> After all if you instantiate it then you probably want to use it
> as the default.

Yes, in fact the instantiating is my problem. E.g. esp asks for an
authenc(...,...) algorithm, so the crypto manager tries to instantiate
a template with name authenc. If I don't want to touch the network
subsystem I can't change the name to pcrypt(authenc(...,...)) easy.
So one solution was to add a default wrapper template arround authenc
that will be instantiated along with authenc.

I'm not insisting on that wap work. I just want to have a easy possibility
to instantiate pcrypt on the users choice for now, at best without the
need to touch other subsystems.
 
