From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: authenc - cryptlen must be at least AAD len
Date: Thu, 7 Sep 2017 14:01:08 +0800
Message-ID: <20170907060108.GA21208@gondor.apana.org.au>
References: <4634467.01PS30tDXi@positron.chronox.de>
 <2430903.zcKRVmhyml@positron.chronox.de>
 <20170907035405.GA20751@gondor.apana.org.au>
 <3142753.SSoe9WBuHN@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: stable@vger.kernel.org, linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3142753.SSoe9WBuHN@positron.chronox.de>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Sep 07, 2017 at 07:48:53AM +0200, Stephan Müller wrote:
>
> There is already such check:
> 
> static inline int crypto_aead_decrypt(struct aead_request *req)
> {
>         struct crypto_aead *aead = crypto_aead_reqtfm(req);
> 
>         if (req->cryptlen < crypto_aead_authsize(aead))
>                 return -EINVAL;
> ...

That doesn't check assoclen, does it?

> > Perhaps we can simply
> > truncate assoclen in aead_request_set_ad.
> 
> I am not sure that would work because at the time we set the AAD len, we may 
> not yet have cryptlen. I.e. aead_request_set_ad may be called before 
> aead_request_set_crypt.

We can add the truncation in both places.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
