From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH] crypto: aesni - make driver-gcm-aes-aesni helper a proper
 aead alg
Date: Mon, 26 Jan 2015 12:38:46 -0800
Message-ID: <54C6A5D6.1080909@intel.com>
References: <20150123223357.15316.72597.stgit@tstruk-mobl1> <20150126001003.GA18391@gondor.apana.org.au> <54C67239.6010909@intel.com> <6186402.WdfiYaY5GD@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:54835 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568AbbAZUmP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 26 Jan 2015 15:42:15 -0500
In-Reply-To: <6186402.WdfiYaY5GD@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/26/2015 11:20 AM, Stephan Mueller wrote:
>> > Here we have two instances of crypto_aead algorithm, one the
>> > rfc4106(gcm(aes)), whose setkey points to rfc4106_set_key(), and the
>> > internal helper __gcm-aes-aesni (wrapped in by the cryptd interface),
>> > whose setkey points to common_rfc4106_set_key(). If we would call
>> > crypto_aead_setkey() on the parent from rfc4106_set_key() then we would
>> > invoke the same rfc4106_set_key() function. It would be ok to call the
>> > crypto_aead_setkey() on the child, but what's the point?
> The point is to maintain an onion style framework that is coherent. All other 
> ciphers implement it (look at the generic gcm.c).
> 

Hi Stephan,
Ok, to keep it consistent is a good enough reason. I'll send v2 soon.
Thanks,
Tadeusz
