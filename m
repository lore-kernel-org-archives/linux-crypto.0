From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH] crypto: authenc - cryptlen must be at least AAD len
Date: Thu, 07 Sep 2017 07:48:53 +0200
Message-ID: <3142753.SSoe9WBuHN@positron.chronox.de>
References: <4634467.01PS30tDXi@positron.chronox.de> <2430903.zcKRVmhyml@positron.chronox.de> <20170907035405.GA20751@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: stable@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170907035405.GA20751@gondor.apana.org.au>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Donnerstag, 7. September 2017, 05:54:05 CEST schrieb Herbert Xu:

Hi Herbert,
> > 
> > What is your opinion: should this check be rather added to
> > crypto_aead_encrypt (similar to a sanity check found in
> > crypto_aead_decrypt)?
> 
> Doesn't this apply to decryption as well?

There is already such check:

static inline int crypto_aead_decrypt(struct aead_request *req)
{
        struct crypto_aead *aead = crypto_aead_reqtfm(req);

        if (req->cryptlen < crypto_aead_authsize(aead))
                return -EINVAL;
...

> Perhaps we can simply
> truncate assoclen in aead_request_set_ad.

I am not sure that would work because at the time we set the AAD len, we may 
not yet have cryptlen. I.e. aead_request_set_ad may be called before 
aead_request_set_crypt.


Ciao
Stephan
