From: Lars Persson <lars.persson@axis.com>
Subject: Re: [PATCH 3/4] crypto: axis: add ARTPEC-6/7 crypto accelerator
 driver
Date: Fri, 21 Jul 2017 08:29:27 +0200
Message-ID: <9a3e69da-bfa2-e47a-49a0-aeb50837308b@axis.com>
References: <cover.1500557664.git.larper@axis.com>
 <b2d7ce4b0fecc4e811c12573f44bd7c45f0147e2.1500557664.git.larper@axis.com>
 <9168085.KJckqYBggK@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8bit
Cc: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>
To: =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>,
        Lars Persson <larper@axis.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bes.se.axis.com ([195.60.68.10]:36793 "EHLO bes.se.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751709AbdGUG3f (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jul 2017 02:29:35 -0400
In-Reply-To: <9168085.KJckqYBggK@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 07/20/2017 04:51 PM, Stephan Müller wrote:
> Am Donnerstag, 20. Juli 2017, 15:44:31 CEST schrieb Lars Persson:
>
> Hi Lars,
>
>> +static int
>> +artpec6_crypto_cipher_set_key(struct crypto_skcipher *cipher, const u8
>> *key, +			      unsigned int keylen)
>> +{
>> +	struct artpec6_cryptotfm_context *ctx =
>> +		crypto_skcipher_ctx(cipher);
>> +
>> +	if (ctx->crypto_type == ARTPEC6_CRYPTO_CIPHER_NULL)
>> +		return 0;
>> +
>> +	switch (keylen) {
>> +	case 16:
>> +	case 24:
>> +	case 32:
>> +		break;
>> +	case 48:
>> +	case 64:
>> +		if (ctx->crypto_type == ARTPEC6_CRYPTO_CIPHER_AES_XTS)
>
> Could you please add xts_check_key for XTS keys?
>
Sure, I will add this in v2.

Thanks,
  Lars
