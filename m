From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH V2] crypto: implement DH primitives under akcipher API
Date: Tue, 5 Apr 2016 19:08:37 +0800
Message-ID: <20160405110837.GA11852@gondor.apana.org.au>
References: <1457007345-3412-1-git-send-email-salvatore.benedetto@intel.com>
 <B4E74723-637F-4A0D-9081-0541F1DF64BD@holtmann.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Salvatore Benedetto <salvatore.benedetto@intel.com>,
	linux-crypto@vger.kernel.org
To: Marcel Holtmann <marcel@holtmann.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60802 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756369AbcDELIq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Apr 2016 07:08:46 -0400
Content-Disposition: inline
In-Reply-To: <B4E74723-637F-4A0D-9081-0541F1DF64BD@holtmann.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 03, 2016 at 08:23:48AM -0800, Marcel Holtmann wrote:
> Hi Salvatore,
> 
> > Implement Diffie-Hellman primitives required by the scheme under the
> > akcipher API. Here is how it works.
> > 1) Call set_pub_key() by passing DH parameters (p,g) in PKCS3 format
> > 2) Call set_priv_key() to set your own private key (xa) in raw format
> > 3) Call decrypt() without passing any data as input to get back the
> >   public part which will be computed as g^xa mod p
> > 4) Call encrypt() by passing the counter part public key (yb) in raw format
> >   as input to get back the shared secret calculated as zz = yb^xa mod p
> 
> I am still not convinced that akcipher is good match for key exchange methods. I think we should try to introduce a new abstraction here.
> 
> Overloading set_pub_key() with DH params and using decrypt() for private/public key pair generation seems not a good fit. It does not really match.
> 
> And as I said before, we know for certain that ECDH has to happen as well. So we need to forward look into making that fit as well.

I agree that akcipher is poor choice for this.  If we are going
to add DH to the crypto API then it should be of its own type.

But before we even go there what does the hardware acceleration
actually look like?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
