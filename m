From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 02/15] crypto: Add userspace configuration API
Date: Fri, 2 Sep 2011 11:50:32 +0800
Message-ID: <20110902035031.GA4628@gondor.apana.org.au>
References: <20110817120859.GX16877@secunet.com> <20110817121013.GZ16877@secunet.com> <20110822065901.GA29599@gondor.apana.org.au> <20110829081818.GA1980@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:50965 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757Ab1IBDug (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 1 Sep 2011 23:50:36 -0400
Content-Disposition: inline
In-Reply-To: <20110829081818.GA1980@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 29, 2011 at 10:18:18AM +0200, Steffen Klassert wrote:
> On Mon, Aug 22, 2011 at 02:59:01PM +0800, Herbert Xu wrote:
> > On Wed, Aug 17, 2011 at 02:10:13PM +0200, Steffen Klassert wrote:
> > >
> > > +struct crypto_user_alg {
> > > +	char cru_name[CRYPTO_MAX_ALG_NAME];
> > > +	char cru_driver_name[CRYPTO_MAX_ALG_NAME];
> > > +	__u32 type;
> > > +	__u32 mask;
> > > +};
> > > +
> > > +#define CRYPTO_MAX_NAME CRYPTO_MAX_ALG_NAME
> > > +
> > > +struct crypto_report_base {
> > > +	char name[CRYPTO_MAX_ALG_NAME];
> > > +	char driver_name[CRYPTO_MAX_ALG_NAME];
> > > +	char module_name[CRYPTO_MAX_NAME];
> > > +	char selftest[CRYPTO_MAX_NAME];
> > > +	int priority;
> > > +	int refcnt;
> > > +};
> > 
> > We should use one structure for both creating algorithms and
> > querying them.  User-space can leave the query fields blank
> > when creating them.
> 
> Do you think about merging the two structures above and to
> keep the algorithm specific structures separate, or to
> merge all of them to one big structure?
> 
> I think we would be most flexible if we would merge the two
> structures above and keep the algorithm specific structures
> separate.

As long as we maintain the ability to replay queried results
it should be fine.  That is, by sending the result of a dump
to another system you should be able to recreate the original
configuration state.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
