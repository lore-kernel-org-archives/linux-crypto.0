From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH] crypto: aesni - make driver-gcm-aes-aesni helper a proper
 aead alg
Date: Mon, 26 Jan 2015 08:58:33 -0800
Message-ID: <54C67239.6010909@intel.com>
References: <20150123223357.15316.72597.stgit@tstruk-mobl1> <10088845.8jngjDYA43@tachyon.chronox.de> <54C5194A.5010208@intel.com> <20150126001003.GA18391@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:5303 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754224AbbAZRCX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 26 Jan 2015 12:02:23 -0500
In-Reply-To: <20150126001003.GA18391@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/25/2015 04:10 PM, Herbert Xu wrote:
> On Sun, Jan 25, 2015 at 08:26:50AM -0800, Tadeusz Struk wrote:
>> > Hi Stephan,
>> > On 01/25/2015 12:58 AM, Stephan Mueller wrote:
>>>> > >> +static int rfc4106_set_key(struct crypto_aead *parent, const u8 *key,
>>>>> > >> > +			   unsigned int key_len)
>>>>> > >> >  {
>>>>> > >> >  	struct aesni_rfc4106_gcm_ctx *ctx = aesni_rfc4106_gcm_ctx_get(parent);
>>>>> > >> >  	struct crypto_aead *cryptd_child = cryptd_aead_child(ctx->cryptd_tfm);
>>>>> > >> > +	struct aesni_rfc4106_gcm_ctx *child_ctx =
>>>>> > >> > +		aesni_rfc4106_gcm_ctx_get(cryptd_child);
>>>>> > >> > +	int ret;
>>>>> > >> > 
>>>>> > >> > +	ret = common_rfc4106_set_key(parent, key, key_len);
>>> > > Shouldn't that one be crypto_aead_setkey, i.e using the regular crypto API 
>>> > > instead of internal calls?
>> > 
>> > No, I don't think so. I think that would create an infinite loop.
> So why does it work for ablk_helper but not for aead?

Here we have two instances of crypto_aead algorithm, one the
rfc4106(gcm(aes)), whose setkey points to rfc4106_set_key(), and the
internal helper __gcm-aes-aesni (wrapped in by the cryptd interface),
whose setkey points to common_rfc4106_set_key(). If we would call
crypto_aead_setkey() on the parent from rfc4106_set_key() then we would
invoke the same rfc4106_set_key() function. It would be ok to call the
crypto_aead_setkey() on the child, but what's the point?
What we really want to do is to setup the context (authsize and key) for
both the top level rfc4106(gcm(aes)) and the helper __gcm-aes-aesni. We
can do it by calling the internal function directly or by the regular
crypto API crypto_aead_setkey()/set_authsize() on the child, but I don't
see any difference or benefit of it.
Hope that make sense.
Thanks,
Tadeusz
