From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: aesni - make driver-gcm-aes-aesni helper a proper aead alg
Date: Mon, 26 Jan 2015 20:20:47 +0100
Message-ID: <6186402.WdfiYaY5GD@tachyon.chronox.de>
References: <20150123223357.15316.72597.stgit@tstruk-mobl1> <20150126001003.GA18391@gondor.apana.org.au> <54C67239.6010909@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60149 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460AbbAZTUv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 26 Jan 2015 14:20:51 -0500
Received: from tachyon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <S122A5> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Mon, 26 Jan 2015 20:20:47 +0100
In-Reply-To: <54C67239.6010909@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 26. Januar 2015, 08:58:33 schrieb Tadeusz Struk:

Hi Tadeusz,

> On 01/25/2015 04:10 PM, Herbert Xu wrote:
> > On Sun, Jan 25, 2015 at 08:26:50AM -0800, Tadeusz Struk wrote:
> >> > Hi Stephan,
> >> > 
> >> > On 01/25/2015 12:58 AM, Stephan Mueller wrote:
> >>>> > >> +static int rfc4106_set_key(struct crypto_aead *parent, const u8
> >>>> > >> *key,
> >>>> > >> 
> >>>>> > >> > +			   unsigned int key_len)
> >>>>> > >> > 
> >>>>> > >> >  {
> >>>>> > >> >  
> >>>>> > >> >  	struct aesni_rfc4106_gcm_ctx *ctx =
> >>>>> > >> >  	aesni_rfc4106_gcm_ctx_get(parent);
> >>>>> > >> >  	struct crypto_aead *cryptd_child =
> >>>>> > >> >  	cryptd_aead_child(ctx->cryptd_tfm);
> >>>>> > >> > 
> >>>>> > >> > +	struct aesni_rfc4106_gcm_ctx *child_ctx =
> >>>>> > >> > +		aesni_rfc4106_gcm_ctx_get(cryptd_child);
> >>>>> > >> > +	int ret;
> >>>>> > >> > 
> >>>>> > >> > +	ret = common_rfc4106_set_key(parent, key, key_len);
> >>> > > 
> >>> > > Shouldn't that one be crypto_aead_setkey, i.e using the regular
> >>> > > crypto API
> >>> > > instead of internal calls?
> >> > 
> >> > No, I don't think so. I think that would create an infinite loop.
> > 
> > So why does it work for ablk_helper but not for aead?
> 
> Here we have two instances of crypto_aead algorithm, one the
> rfc4106(gcm(aes)), whose setkey points to rfc4106_set_key(), and the
> internal helper __gcm-aes-aesni (wrapped in by the cryptd interface),
> whose setkey points to common_rfc4106_set_key(). If we would call
> crypto_aead_setkey() on the parent from rfc4106_set_key() then we would
> invoke the same rfc4106_set_key() function. It would be ok to call the
> crypto_aead_setkey() on the child, but what's the point?

The point is to maintain an onion style framework that is coherent. All other 
ciphers implement it (look at the generic gcm.c).

> What we really want to do is to setup the context (authsize and key) for
> both the top level rfc4106(gcm(aes)) and the helper __gcm-aes-aesni. We
> can do it by calling the internal function directly or by the regular
> crypto API crypto_aead_setkey()/set_authsize() on the child, but I don't
> see any difference or benefit of it.

Then, why do we register the internal __driver "cipher" at all. On the one 
hand, the kernel crypto API is used for some aspects but not for others. Hm...


> Hope that make sense.
> Thanks,
> Tadeusz
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ciao
Stephan
