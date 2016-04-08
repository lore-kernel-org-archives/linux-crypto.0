From: "Benedetto, Salvatore" <salvatore.benedetto@intel.com>
Subject: RE: [PATCH V2] crypto: implement DH primitives under akcipher API
Date: Fri, 8 Apr 2016 06:38:57 +0000
Message-ID: <309B30E91F5E2846B79BD9AA9711D0318DD07A@IRSMSX102.ger.corp.intel.com>
References: <1457007345-3412-1-git-send-email-salvatore.benedetto@intel.com>
 <B4E74723-637F-4A0D-9081-0541F1DF64BD@holtmann.org>
 <20160405110837.GA11852@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Benedetto, Salvatore" <salvatore.benedetto@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Marcel Holtmann <marcel@holtmann.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:39430 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957AbcDHGjA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Apr 2016 02:39:00 -0400
In-Reply-To: <20160405110837.GA11852@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

> -----Original Message-----
> From: Herbert Xu [mailto:herbert@gondor.apana.org.au]
> Sent: Tuesday, April 5, 2016 12:09 PM
> To: Marcel Holtmann <marcel@holtmann.org>
> Cc: Benedetto, Salvatore <salvatore.benedetto@intel.com>; linux-
> crypto@vger.kernel.org
> Subject: Re: [PATCH V2] crypto: implement DH primitives under akcipher API
> 
> On Thu, Mar 03, 2016 at 08:23:48AM -0800, Marcel Holtmann wrote:
> > Hi Salvatore,
> >
> > > Implement Diffie-Hellman primitives required by the scheme under the
> > > akcipher API. Here is how it works.
> > > 1) Call set_pub_key() by passing DH parameters (p,g) in PKCS3 format
> > > 2) Call set_priv_key() to set your own private key (xa) in raw
> > > format
> > > 3) Call decrypt() without passing any data as input to get back the
> > >   public part which will be computed as g^xa mod p
> > > 4) Call encrypt() by passing the counter part public key (yb) in raw format
> > >   as input to get back the shared secret calculated as zz = yb^xa
> > > mod p
> >
> > I am still not convinced that akcipher is good match for key exchange
> methods. I think we should try to introduce a new abstraction here.
> >
> > Overloading set_pub_key() with DH params and using decrypt() for
> private/public key pair generation seems not a good fit. It does not really
> match.
> >
> > And as I said before, we know for certain that ECDH has to happen as well.
> So we need to forward look into making that fit as well.
> 
> I agree that akcipher is poor choice for this.  If we are going to add DH to the
> crypto API then it should be of its own type.
> 
> But before we even go there what does the hardware acceleration actually
> look like?
>

I'm not sure what you mean by that, but in the case of DH, the hardware will
receive as input 3 buffers containing base, exponent and module, compute the
value and return it into the given output buffer. That's it. More or less the same
will be for ECDH.

Thanks,
Salvatore
