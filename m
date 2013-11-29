From: Cristian Stoica <cristian.stoica@freescale.com>
Subject: RE: [PATCH] crypto: remove unnecessary includes
Date: Fri, 29 Nov 2013 08:49:42 +0000
Message-ID: <1628287275CAA9409F1E349DEF3C6CCE77CB99@039-SN2MPN1-012.039d.mgd.msft.net>
References: <1385658987-16012-1-git-send-email-cristian.stoica@freescale.com>
 <20131129020657.GA5650@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:19090
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751016Ab3K2Itq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Nov 2013 03:49:46 -0500
In-Reply-To: <20131129020657.GA5650@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

>From what I could see there is nothing from those includes that is used inside authenc.c.
The build passes without them.

Cristian S.

> > diff --git a/crypto/authenc.c b/crypto/authenc.c
> > index 1875e70..7d4bfaa 100644
> > --- a/crypto/authenc.c
> > +++ b/crypto/authenc.c
> > @@ -17,11 +17,8 @@
> >  #include <crypto/scatterwalk.h>
> >  #include <linux/err.h>
> >  #include <linux/init.h>
> > -#include <linux/kernel.h>
> >  #include <linux/module.h>
> >  #include <linux/rtnetlink.h>
> > -#include <linux/slab.h>
> > -#include <linux/spinlock.h>
> >
> >  typedef u8 *(*authenc_ahash_t)(struct aead_request *req, unsigned int
> flags);
> 
> Why are these includes unnecessary?
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
