From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH v2 02/15] crypto: Add userspace configuration API
Date: Mon, 29 Aug 2011 10:18:18 +0200
Message-ID: <20110829081818.GA1980@secunet.com>
References: <20110817120859.GX16877@secunet.com>
 <20110817121013.GZ16877@secunet.com>
 <20110822065901.GA29599@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:58582 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031Ab1H2ISV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 29 Aug 2011 04:18:21 -0400
Content-Disposition: inline
In-Reply-To: <20110822065901.GA29599@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 22, 2011 at 02:59:01PM +0800, Herbert Xu wrote:
> On Wed, Aug 17, 2011 at 02:10:13PM +0200, Steffen Klassert wrote:
> >
> > +struct crypto_user_alg {
> > +	char cru_name[CRYPTO_MAX_ALG_NAME];
> > +	char cru_driver_name[CRYPTO_MAX_ALG_NAME];
> > +	__u32 type;
> > +	__u32 mask;
> > +};
> > +
> > +#define CRYPTO_MAX_NAME CRYPTO_MAX_ALG_NAME
> > +
> > +struct crypto_report_base {
> > +	char name[CRYPTO_MAX_ALG_NAME];
> > +	char driver_name[CRYPTO_MAX_ALG_NAME];
> > +	char module_name[CRYPTO_MAX_NAME];
> > +	char selftest[CRYPTO_MAX_NAME];
> > +	int priority;
> > +	int refcnt;
> > +};
> 
> We should use one structure for both creating algorithms and
> querying them.  User-space can leave the query fields blank
> when creating them.

Do you think about merging the two structures above and to
keep the algorithm specific structures separate, or to
merge all of them to one big structure?

I think we would be most flexible if we would merge the two
structures above and keep the algorithm specific structures
separate.

> 
> On another note, all fields specified when creating an algorithm
> should be returned when querying/reporting.  This is so that
> we can recreate the exact configuration after dumping.

Yes, indeed.

> 
> Also, instead of returning selftest as a string, a single bit
> would suffice.  So I'd suggest turning it into flags of type
> __u32.

Ok.

> 
> In fact, let's turn the other two int fields into __u32 too.
> 

Ok.
