From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [RFC PATCH] crypto: RSA padding transform
Date: Mon, 7 Sep 2015 07:11:24 -0700
Message-ID: <55ED9B0C.3020905@intel.com>
References: <1441494029-6765-1-git-send-email-andrew.zaborowski@intel.com>
 <35165141.6IIWPIRvUD@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>,
	Andrew Zaborowski <andrew.zaborowski@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:29888 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008AbbIGOND (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Sep 2015 10:13:03 -0400
In-Reply-To: <35165141.6IIWPIRvUD@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09/06/2015 01:34 AM, Stephan Mueller wrote:
>> +static int pkcs1pad_setkey(struct crypto_akcipher *tfm, const void *key,
>> > +		unsigned int keylen)
> Albeit I have nothing to say against the code, but shouldn't we first get the 
> split of the setkey function implemented? The conversion work will increase 
> more and more we merge code that uses that API that was decided to be 
> revamped.
> 
> Tadeusz, what do you think?

It would make it easier for me if this could wait until the split is done.

>> +		akcipher_request_set_crypt(req, NULL, NULL, 0, 0);
>> > +		if (crypto_akcipher_encrypt(req) != -EOVERFLOW)
>> > +			err = -EINVAL;
> I had a chat with Tadesusz already on this code which I need for the 
> algif_akcipher code too (and there I need this check more often as user space 
> may simply change the key under my feet). I feel that it is a waste of CPU 
> cycles to set up a fake encryption request just to get the data length which 
> is based on the used key.
> 
> The value we obtain here is simply a check of the key length. Thus, I would 
> think that we should have a separate akcipher API call for this instead of 
> requiring the caller to allocate a fake request context.
> 
> Tadeusz, are you working on that code or shall I have a look?

I wasn't planning to add this, but yes, I think it's a good idea.
I'll add it.
