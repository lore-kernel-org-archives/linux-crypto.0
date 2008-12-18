From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH/RFC 2/8] crypto: compress - Add pcomp interface
Date: Fri, 19 Dec 2008 09:12:51 +1100
Message-ID: <20081218221251.GA1304@gondor.apana.org.au>
References: <20081217163634.998961917@vixen.sonytel.be> <20081217164036.539681327@vixen.sonytel.be> <20081218061908.GB27951@gondor.apana.org.au> <Pine.LNX.4.64.0812181820100.25762@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:55096 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753910AbYLRWMz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Dec 2008 17:12:55 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812181820100.25762@vixen.sonytel.be>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 18, 2008 at 06:28:09PM +0100, Geert Uytterhoeven wrote:
>
> Can you please elaborate a bit more?

In the old scheme, each type required you to change crypto_tfm
and crypto_alg since they had the type-specific information
embedded in it.  Starting with crypto_shash, we are now totally
decentralised.  All type-specific information is now added to
the base structures.  Let's take shash_alg as an example, in
the old days we'd put the algorithms into a structure and embed
the structure in crypto_alg, now we instead put crypto_alg in
shash_alg, like this:

struct shash_alg {
	int (*init)(struct shash_desc *desc);
	int (*reinit)(struct shash_desc *desc);
	int (*update)(struct shash_desc *desc, const u8 *data,
		      unsigned int len);
	int (*final)(struct shash_desc *desc, u8 *out);
	int (*finup)(struct shash_desc *desc, const u8 *data,
		     unsigned int len, u8 *out);
	int (*digest)(struct shash_desc *desc, const u8 *data,
		      unsigned int len, u8 *out);
	int (*setkey)(struct crypto_shash *tfm, const u8 *key,
		      unsigned int keylen);

	unsigned int descsize;
	unsigned int digestsize;

	struct crypto_alg base;
};

> You mean pcomp should provide a struct crypto_type?

Yes, it should.  Although starting wish shash crypto_type no
longer needs to be directly visible to the algorithms as each
new type should now provide its own registration function which
can fill in the type object.

> And the underlying algorithms shouldn't use crypto_alg directly anymore?

Right.  Please take a look at include/crypto/hash.h, crypto/shash.c,
and crypto/sha1_generic.c from the cryptodev tree.  This should
provide everything you need to write a new type.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
