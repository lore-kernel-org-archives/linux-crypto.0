From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: authenc - cryptlen must be at least AAD len
Date: Thu, 07 Sep 2017 08:04:25 +0200
Message-ID: <1950183.Or1rzax7nU@tauon.chronox.de>
References: <4634467.01PS30tDXi@positron.chronox.de> <3142753.SSoe9WBuHN@positron.chronox.de> <20170907060108.GA21208@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: stable@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170907060108.GA21208@gondor.apana.org.au>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Donnerstag, 7. September 2017, 08:01:08 CEST schrieb Herbert Xu:

Hi Herbert,

> On Thu, Sep 07, 2017 at 07:48:53AM +0200, Stephan Müller wrote:
> > There is already such check:
> > 
> > static inline int crypto_aead_decrypt(struct aead_request *req)
> > {
> > 
> >         struct crypto_aead *aead = crypto_aead_reqtfm(req);
> >         
> >         if (req->cryptlen < crypto_aead_authsize(aead))
> >         
> >                 return -EINVAL;
> > 
> > ...
> 
> That doesn't check assoclen, does it?

Right, I mixed up the tag and the AAD, sorry for that.
> 
> > > Perhaps we can simply
> > > truncate assoclen in aead_request_set_ad.
> > 
> > I am not sure that would work because at the time we set the AAD len, we
> > may not yet have cryptlen. I.e. aead_request_set_ad may be called before
> > aead_request_set_crypt.
> 
> We can add the truncation in both places.

I sill send a new patch -- shall I first send it excluding stable so that we 
can review it before bothering the stable folks?
> 
> Cheers,



Ciao
Stephan
