From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] Add GCM/GMAC support to cryptoapi
Date: Sun, 30 Dec 2007 17:18:55 +1100
Message-ID: <20071230061855.GA19638@gondor.apana.org.au>
References: <Pine.LNX.4.64.0711251601100.3663@antarct> <Pine.LNX.4.64.0711251624530.3663@antarct> <20071230034922.GA14536@gondor.apana.org.au> <Pine.LNX.4.64.0712300658190.3593@antarct>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Mikko Herranen <mikko.herranen@cs.helsinki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2993 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751334AbXL3GS6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 30 Dec 2007 01:18:58 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712300658190.3593@antarct>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Dec 30, 2007 at 07:05:22AM +0200, Mikko Herranen wrote:
> On Sun, 30 Dec 2007, Herbert Xu wrote:
> 
> > > @@ -169,6 +172,7 @@ static void test_hash(char *algo, struct hash_testvec *template,
> > >  
> > >  	/* setup the dummy buffer first */
> > >  	memset(xbuf, 0, XBUFSIZE);
> > > +	memset(axbuf, 0, XBUFSIZE);
> > 
> > I was just looking over this code and this line seems to be in the
> > wrong function.  I presume it's meant to be in test_aead, right?
> 
> Oops. Yes, it should be in test_aead.

OK I'll fix it up.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
