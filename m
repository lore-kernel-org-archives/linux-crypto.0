From: "Loc Ho" <locnho@sbcglobal.net>
Subject: RE: New Crypto Hardware
Date: Thu, 17 Jan 2008 10:37:20 -0800
Message-ID: <001c01c85937$ff3313f0$5c05420a@amcc.com>
References: <E1IrkmY-0007gp-00@gondolin.me.apana.org.au> <0CA0A16855646F4FA96D25A158E299D603EB866F@SDCEXCHANGE01.ad.amcc.com> <20071225073202.GA31076@gondor.apana.org.au> <0CA0A16855646F4FA96D25A158E299D603FCC15D@SDCEXCHANGE01.ad.amcc.com> <20080117112314.GC9020@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>
To: "'Herbert Xu'" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:22610 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751754AbYAQSoE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Jan 2008 13:44:04 -0500
In-Reply-To: <20080117112314.GC9020@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

The current hash_alg struct is:

struct hash_alg {
	int (*init)(struct hash_desc *desc);
	int (*update)(struct hash_desc *desc, struct scatterlist *sg,
		      unsigned int nbytes);
	int (*final)(struct hash_desc *desc, u8 *out);
	int (*digest)(struct hash_desc *desc, struct scatterlist *sg,
		      unsigned int nbytes, u8 *out);
	int (*setkey)(struct crypto_hash *tfm, const u8 *key,
		      unsigned int keylen);

	unsigned int digestsize;
}; 

It looks like update and final functions are used for continuous hashing.
And digest function is used for single hashing. I was thing changing to this
for async:

struct ahash_alg {
	int (*init)(struct ahash_request *req);
	int (*digest)(struct ahash_request *req);
	int (*setkey)(struct crypto_ahash *tfm, const u8 *key,
		unsigned int keylen);

	unsigned int digestsize;
};

But it seems like there is still a need to support continuation hashing as
well as just single hash. 

Questions:
1. Is my assume about update/final and digest function correct? 
2. What is the difference between digest and hash type besides one operation
on transformation structure (tfm) and the other on descriptor (desc)? 
3. Currently, cryptodev-2.6 git doesn't work under PPC4xx development board
but Denx linux latest works. Have anyone tested on PPC4xx board?

The context between update and final function will be moved into the request
just like ablkcipher.

-Loc

-----Original Message-----
From: Herbert Xu [mailto:herbert@gondor.apana.org.au] 
Sent: Thursday, January 17, 2008 3:23 AM
To: Loc Ho
Cc: linux-crypto@vger.kernel.org
Subject: Re: New Crypto Hardware

On Wed, Jan 16, 2008 at 10:19:04AM -0800, Loc Ho wrote:
> Hi,
> 
> For hashing, there are HMAC key if HMAC and digest size. As digest 
> size is part of the algorithm, there is only HMAC key. Are you 
> referring to moving the HMAC key from transformation into the request 
> structure? As I am modeled after ablkcipher_request structure, there 
> will be a context point 'void *__ctx[] CRYPTO_MINALIGN_ATTR;' for the
request operation.

No I meant the context that has to be stored between calls to
crypto_hash_update and crypto_hash_final.

Cheers,
--
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au> Home Page:
http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
