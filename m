From: Mikko Herranen <mikko.herranen@cs.helsinki.fi>
Subject: Re: [PATCH 1/2] Add GCM/GMAC support to cryptoapi
Date: Sun, 30 Dec 2007 07:05:22 +0200 (EET)
Message-ID: <Pine.LNX.4.64.0712300658190.3593@antarct>
References: <Pine.LNX.4.64.0711251601100.3663@antarct>
 <Pine.LNX.4.64.0711251624530.3663@antarct> <20071230034922.GA14536@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pne-smtpout3-sn1.fre.skanova.net ([81.228.11.120]:40893 "EHLO
	pne-smtpout3-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750789AbXL3FF6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 30 Dec 2007 00:05:58 -0500
In-Reply-To: <20071230034922.GA14536@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, 30 Dec 2007, Herbert Xu wrote:

> > @@ -169,6 +172,7 @@ static void test_hash(char *algo, struct hash_testvec *template,
> >  
> >  	/* setup the dummy buffer first */
> >  	memset(xbuf, 0, XBUFSIZE);
> > +	memset(axbuf, 0, XBUFSIZE);
> 
> I was just looking over this code and this line seems to be in the
> wrong function.  I presume it's meant to be in test_aead, right?

Oops. Yes, it should be in test_aead.

-- 
Mikko Herranen
