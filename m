From: Salvatore Benedetto <salvatore.benedetto@intel.com>
Subject: Re: [PATCH v5 1/3] crypto: Key-agreement Protocol Primitives API
 (KPP)
Date: Wed, 8 Jun 2016 12:45:47 +0100
Message-ID: <20160608114547.GA26661@sbenedet-virtual-machine>
References: <1462830041-7582-1-git-send-email-salvatore.benedetto@intel.com>
 <1462830041-7582-2-git-send-email-salvatore.benedetto@intel.com>
 <20160531064210.GA13948@gondor.apana.org.au>
 <309B30E91F5E2846B79BD9AA9711D031930814@IRSMSX102.ger.corp.intel.com>
 <20160608025451.GB12283@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:17097 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753651AbcFHMPk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Jun 2016 08:15:40 -0400
Content-Disposition: inline
In-Reply-To: <20160608025451.GB12283@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 08, 2016 at 10:54:51AM +0800, Herbert Xu wrote:
> On Thu, Jun 02, 2016 at 12:06:48PM +0000, Benedetto, Salvatore wrote:
> >
> > Off the top of my head, with ECDH when the user gets a EGAIN, he wants
> > to reset the secret key only, not the params.
> 
> I don't see any performance benefit in changing one and not the
> other.  Besides, you could always check the params in the algo
> and only update if necessary.
>

I'm OK with merging set_params and set_key and allow the user to
pass either both, or only the key in which case params previously
set are reused, although I don't see any particular benefit with this.

> > > >  * generate_public_key() - It generates the public key to be sent to
> > > >    the other counterpart involved in the key-agreement session. The
> > > >    function has to be called after set_params() and set_secret()
> > > >  * generate_secret() - It generates the shared secret for the session
> > > 
> > > Ditto, we only need one operation and that is multiplication by the secret.
> > 
> > Sorry, but I don't understand your point.
> > We do always need one math operation with different params.
> 
> Look at your actual implementations of DH and ECDH, they are the
> same except for the multiplicand, which is fixed to G for the
> public key.
> 
> Now you could argue that having to reparse G every time could be
> bad for performance, but that's easily fixed by making the case
> of a zero-length input value an implicit request to use G.
> 
> Even better, just drop G from the params and you won't need to
> reparse it or do anything special.
> 
> The point of all this is to make the lives of future driver authors
> simpler, the less they have to do the less that could go wrong.

I really would like to keep the interface as it is because it's
very clear what each function does. I'm OK with remapping both
function to the same one, and if src is zero, g/G will be used.

Keep in mind that while for DH g is always provided by the user,
for ECDH G is a public value which we already have and I don't see
why the user should pass that.

Having said that, are you OK with as far as the interface goes
to only merge set_param and set_key, and keeping the rest as it is?
For the implementation of DH and ECDH I'll merge the two operations
functions into one as you suggested. If so, I'll send a new version.

Thanks for your inputs.

Regards,
Salvatore

> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
