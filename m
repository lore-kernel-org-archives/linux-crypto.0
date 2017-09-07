From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: authenc - cryptlen must be at least AAD len
Date: Thu, 7 Sep 2017 11:54:05 +0800
Message-ID: <20170907035405.GA20751@gondor.apana.org.au>
References: <4634467.01PS30tDXi@positron.chronox.de>
 <2430903.zcKRVmhyml@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: stable@vger.kernel.org, linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2430903.zcKRVmhyml@positron.chronox.de>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Sep 06, 2017 at 10:10:08PM +0200, Stephan Müller wrote:
> Am Mittwoch, 6. September 2017, 21:22:44 CEST schrieb Stephan Müller:
> 
> Hi Herbert,
> 
> > With AF_ALG, AAD len and cryptlen can be set freely by unprivileged
> > user space. The cipher implementation must therefore validate the input
> > data for sanity. For AEAD ciphers, this implies that cryptlen must be
> > at least as large as AAD size.
> > 
> > This fixes a kernel crash that can be triggered via AF_ALG detected by
> > the fuzzing test implemented with libkcapi.
> 
> What is your opinion: should this check be rather added to crypto_aead_encrypt 
> (similar to a sanity check found in crypto_aead_decrypt)?

Doesn't this apply to decryption as well? Perhaps we can simply
truncate assoclen in aead_request_set_ad.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
