From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH] crypto: aesni - make driver-gcm-aes-aesni helper a proper
 aead alg
Date: Sun, 25 Jan 2015 08:26:50 -0800
Message-ID: <54C5194A.5010208@intel.com>
References: <20150123223357.15316.72597.stgit@tstruk-mobl1> <10088845.8jngjDYA43@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:28079 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480AbbAYQaS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 25 Jan 2015 11:30:18 -0500
In-Reply-To: <10088845.8jngjDYA43@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,
On 01/25/2015 12:58 AM, Stephan Mueller wrote:
>> +static int rfc4106_set_key(struct crypto_aead *parent, const u8 *key,
>> > +			   unsigned int key_len)
>> >  {
>> >  	struct aesni_rfc4106_gcm_ctx *ctx = aesni_rfc4106_gcm_ctx_get(parent);
>> >  	struct crypto_aead *cryptd_child = cryptd_aead_child(ctx->cryptd_tfm);
>> > +	struct aesni_rfc4106_gcm_ctx *child_ctx =
>> > +		aesni_rfc4106_gcm_ctx_get(cryptd_child);
>> > +	int ret;
>> > 
>> > +	ret = common_rfc4106_set_key(parent, key, key_len);
> Shouldn't that one be crypto_aead_setkey, i.e using the regular crypto API 
> instead of internal calls?
> 

No, I don't think so. I think that would create an infinite loop.

>> +static int rfc4106_set_authsize(struct crypto_aead *parent,
>> > +				unsigned int authsize)
>> > +{
>> > +	struct aesni_rfc4106_gcm_ctx *ctx = aesni_rfc4106_gcm_ctx_get(parent);
>> > +	struct crypto_aead *cryptd_child = cryptd_aead_child(ctx->cryptd_tfm);
>> > +	int ret;
>> > +
>> > +	ret = common_rfc4106_set_authsize(parent, authsize);
> Same here, shouldn't that one be crypto_aead_setauthsize?
> 

Same here.

Thanks,
Tadeusz
