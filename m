From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [PATCH v2] crypto: add blkcipher implementation of ARC4
Date: Tue, 6 Apr 2010 22:30:02 +0200
Message-ID: <20100406203002.GA1842@Chamillionaire.breakpoint.cc>
References: <1270280969-11357-1-git-send-email-sebastian@breakpoint.cc>
 <1270280969-11357-3-git-send-email-sebastian@breakpoint.cc>
 <20100405084209.GA16788@gondor.apana.org.au>
 <20100405170406.GA24215@Chamillionaire.breakpoint.cc>
 <20100406124412.GA24488@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-ppp@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:53312 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755292Ab0DFUaE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 6 Apr 2010 16:30:04 -0400
Content-Disposition: inline
In-Reply-To: <20100406124412.GA24488@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Herbert Xu | 2010-04-06 20:44:12 [+0800]:

>On Mon, Apr 05, 2010 at 07:04:06PM +0200, Sebastian Andrzej Siewior wrote:
>>
>> +static void arc4_key_to_iv(const u8 *in_key, u32 key_len, struct arc4_iv *iv)
>> +{
>> +	int i, j = 0, k = 0;
>> +
>> +	iv->iv.x = 1;
>> +	iv->iv.y = 0;
>> +
>> +	for (i = 0; i < 256; i++)
>> +		iv->iv.S[i] = i;
>> +
>> +	for (i = 0; i < 256; i++)
>> +	{
>> +		u8 a = iv->iv.S[i];
>> +		j = (j + in_key[k] + a) & 0xff;
>> +		iv->iv.S[i] = iv->iv.S[j];
>> +		iv->iv.S[j] = a;
>> +		if (++k >= key_len)
>> +			k = 0;
>> +	}
>> +}
>> +
>> +static void arc4_ivsetup(struct arc4_iv *iv)
>> +{
>> +	struct arc4_iv tmp_iv;
>> +
>> +	if (iv->type == ARC4_TYPE_IV)
>> +		return;
>> +
>> +	memcpy(&tmp_iv, iv, sizeof(tmp_iv));
>> +	arc4_key_to_iv(tmp_iv.key.key, tmp_iv.key.key_len, iv);
>> +	iv->type = ARC4_TYPE_IV;
>> +}
>
>We need to verify that 1 <= key_len <= 256.
Good point. All arc4 users don't care about return value of setkey so I
think that I just change void to int add the check for the valid key
length.

While we are here, the .setkey() callback could be removed, couldn't it?
It returns 0 even it is doing nothing what looks kinda wrong. However it
shouldn't be called at all since min/max key is 0. Any objections on
that?

>
>Cheers,

Sebastian
