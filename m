From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: authenc - convert to ahash
Date: Wed, 22 Jul 2009 15:52:00 +0800
Message-ID: <20090722075200.GA30364@gondor.apana.org.au>
References: <20090721090217.GF20288@secunet.com> <20090722070259.GA29808@gondor.apana.org.au> <20090722073211.GI20288@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:58283 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753122AbZGVHwD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jul 2009 03:52:03 -0400
Content-Disposition: inline
In-Reply-To: <20090722073211.GI20288@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 22, 2009 at 09:32:11AM +0200, Steffen Klassert wrote:
> On Wed, Jul 22, 2009 at 03:02:59PM +0800, Herbert Xu wrote:
> > On Tue, Jul 21, 2009 at 11:02:17AM +0200, Steffen Klassert wrote:
> > >
> > > +	err = crypto_ahash_finup(ahreq);
> > > +	if (err == -EINPROGRESS)
> > > +		return;
> > 
> > This is redundant.  All completion functions must expect to be
> > called with EINPROGRESS followed by the actual completion later.
> 
> I copied this from crypto_authenc_encrypt_done(), so this is probaply
> redundant too. If so, I'd send a patch to remove the already existing
> checks too and put the updated ahash convertion patch on top of it.

Hmm this check doesn't exist in my tree.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
