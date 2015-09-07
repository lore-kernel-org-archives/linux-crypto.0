From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [RFC PATCH] crypto: RSA padding transform
Date: Mon, 07 Sep 2015 17:07:53 +0200
Message-ID: <2868809.KTUGSjxIxs@tauon.atsec.com>
References: <1441494029-6765-1-git-send-email-andrew.zaborowski@intel.com> <35165141.6IIWPIRvUD@myon.chronox.de> <55ED9B0C.3020905@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Andrew Zaborowski <andrew.zaborowski@intel.com>,
	linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:33790 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599AbbIGPH6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Sep 2015 11:07:58 -0400
In-Reply-To: <55ED9B0C.3020905@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 7. September 2015, 07:11:24 schrieb Tadeusz Struk:

Hi Tadeusz,

>On 09/06/2015 01:34 AM, Stephan Mueller wrote:
>>> +static int pkcs1pad_setkey(struct crypto_akcipher *tfm, const void *key,
>>> 
>>> > +		unsigned int keylen)
>> 
>> Albeit I have nothing to say against the code, but shouldn't we first get
>> the split of the setkey function implemented? The conversion work will
>> increase more and more we merge code that uses that API that was decided
>> to be revamped.
>> 
>> Tadeusz, what do you think?
>
>It would make it easier for me if this could wait until the split is done.

Sure, I will wait with posting of my new version of AF_ALG until that dust 
settled.
>
>>> +		akcipher_request_set_crypt(req, NULL, NULL, 0, 0);
>>> 
>>> > +		if (crypto_akcipher_encrypt(req) != -EOVERFLOW)
>>> > +			err = -EINVAL;
>> 
>> I had a chat with Tadesusz already on this code which I need for the
>> algif_akcipher code too (and there I need this check more often as user
>> space may simply change the key under my feet). I feel that it is a waste
>> of CPU cycles to set up a fake encryption request just to get the data
>> length which is based on the used key.
>> 
>> The value we obtain here is simply a check of the key length. Thus, I would
>> think that we should have a separate akcipher API call for this instead of
>> requiring the caller to allocate a fake request context.
>> 
>> Tadeusz, are you working on that code or shall I have a look?
>
>I wasn't planning to add this, but yes, I think it's a good idea.
>I'll add it.

Thanks a lot. I would think that the API call really is just a one-liner 
returning the size of the key.


Ciao
Stephan
