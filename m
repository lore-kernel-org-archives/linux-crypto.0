From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 3/4] crypto: drbg - replace spinlock with mutex
Date: Mon, 20 Apr 2015 02:45:02 +0200
Message-ID: <2050637.ShmA9JvV53@tauon>
References: <1551177.C0RmlOO9iU@myon.chronox.de> <1695105.vT0DvueDZS@myon.chronox.de> <20150420002709.GB16750@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34215 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633AbbDTApJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 19 Apr 2015 20:45:09 -0400
In-Reply-To: <20150420002709.GB16750@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 20. April 2015, 08:27:09 schrieb Herbert Xu:

Hi Herbert,

>On Sun, Apr 19, 2015 at 05:37:21PM +0200, Stephan Mueller wrote:
>> I am not sure I understand you correctly: shall the DRBG have these
>> precautions? If so, wouldn't we break the requirements in SP800-90A where
>> the DRBG is intended to seed itself?
>> 
>> Or would you want to update the crypto_alloc_rng routine?
>
>No.  Our API doesn't provide the Instantiate_function obviously.
>If you really want to have an explicit instantiate function then
>you can provide a wrapper:
>
>crypto_instantiate_drbg(...)
>{
>	struct crypto_rng *drbg;
>
>	drbg = crypto_alloc_rng(...);
>	crypto_rng_reset(drbg, ...);
>	return drbg;
>}
>
>The fact that crypto_alloc_rng currently instantiates the RNG
>is wrong because there is no provision for the personalisation
>string.

I do not want to deviate from the kernel crypto API by adding some additional 
wrapper. But what we can do is to leave the DRBG unseeded during alloc time. 
As long as the DRBG is unseeded, it will return EAGAIN to any request for 
random numbers, forcing the caller to use crypto_rng_reset to activate the 
DRBG.

When the DRBG receives a reset, it will always obtain the seed and treat any 
user-provided data as personalization string / additional data.

Such change is straight forward. I would like to roll that one into the 
patchset for the discussed seeding revamp as this issue is definitely 
noticeable there. That patch set is already complete, I am just doing the 
final testing before airing it.

Ciao
Stephan
