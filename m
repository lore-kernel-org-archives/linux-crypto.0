From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: aesni - make driver-gcm-aes-aesni helper a
 proper aead alg
Date: Mon, 26 Jan 2015 11:10:03 +1100
Message-ID: <20150126001003.GA18391@gondor.apana.org.au>
References: <20150123223357.15316.72597.stgit@tstruk-mobl1>
 <10088845.8jngjDYA43@tachyon.chronox.de>
 <54C5194A.5010208@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:49065 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbbAZAKN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 25 Jan 2015 19:10:13 -0500
Content-Disposition: inline
In-Reply-To: <54C5194A.5010208@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jan 25, 2015 at 08:26:50AM -0800, Tadeusz Struk wrote:
> Hi Stephan,
> On 01/25/2015 12:58 AM, Stephan Mueller wrote:
> >> +static int rfc4106_set_key(struct crypto_aead *parent, const u8 *key,
> >> > +			   unsigned int key_len)
> >> >  {
> >> >  	struct aesni_rfc4106_gcm_ctx *ctx = aesni_rfc4106_gcm_ctx_get(parent);
> >> >  	struct crypto_aead *cryptd_child = cryptd_aead_child(ctx->cryptd_tfm);
> >> > +	struct aesni_rfc4106_gcm_ctx *child_ctx =
> >> > +		aesni_rfc4106_gcm_ctx_get(cryptd_child);
> >> > +	int ret;
> >> > 
> >> > +	ret = common_rfc4106_set_key(parent, key, key_len);
> > Shouldn't that one be crypto_aead_setkey, i.e using the regular crypto API 
> > instead of internal calls?
> 
> No, I don't think so. I think that would create an infinite loop.

So why does it work for ablk_helper but not for aead?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
