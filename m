From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5 1/3] crypto: Key-agreement Protocol Primitives API
 (KPP)
Date: Wed, 8 Jun 2016 10:54:51 +0800
Message-ID: <20160608025451.GB12283@gondor.apana.org.au>
References: <1462830041-7582-1-git-send-email-salvatore.benedetto@intel.com>
 <1462830041-7582-2-git-send-email-salvatore.benedetto@intel.com>
 <20160531064210.GA13948@gondor.apana.org.au>
 <309B30E91F5E2846B79BD9AA9711D031930814@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: "Benedetto, Salvatore" <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42987 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554AbcFHCy4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Jun 2016 22:54:56 -0400
Content-Disposition: inline
In-Reply-To: <309B30E91F5E2846B79BD9AA9711D031930814@IRSMSX102.ger.corp.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 02, 2016 at 12:06:48PM +0000, Benedetto, Salvatore wrote:
>
> Off the top of my head, with ECDH when the user gets a EGAIN, he wants
> to reset the secret key only, not the params.

I don't see any performance benefit in changing one and not the
other.  Besides, you could always check the params in the algo
and only update if necessary.

> > >  * generate_public_key() - It generates the public key to be sent to
> > >    the other counterpart involved in the key-agreement session. The
> > >    function has to be called after set_params() and set_secret()
> > >  * generate_secret() - It generates the shared secret for the session
> > 
> > Ditto, we only need one operation and that is multiplication by the secret.
> 
> Sorry, but I don't understand your point.
> We do always need one math operation with different params.

Look at your actual implementations of DH and ECDH, they are the
same except for the multiplicand, which is fixed to G for the
public key.

Now you could argue that having to reparse G every time could be
bad for performance, but that's easily fixed by making the case
of a zero-length input value an implicit request to use G.

Even better, just drop G from the params and you won't need to
reparse it or do anything special.

The point of all this is to make the lives of future driver authors
simpler, the less they have to do the less that could go wrong.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
