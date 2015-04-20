From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 3/4] crypto: drbg - replace spinlock with mutex
Date: Mon, 20 Apr 2015 02:51:30 +0200
Message-ID: <1710531.pgBfBsv2an@tauon>
References: <1551177.C0RmlOO9iU@myon.chronox.de> <2050637.ShmA9JvV53@tauon> <20150420004855.GA16974@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34218 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185AbbDTAvh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 19 Apr 2015 20:51:37 -0400
In-Reply-To: <20150420004855.GA16974@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 20. April 2015, 08:48:55 schrieb Herbert Xu:

Hi Herbert,

>On Mon, Apr 20, 2015 at 02:45:02AM +0200, Stephan Mueller wrote:
>> I do not want to deviate from the kernel crypto API by adding some
>> additional wrapper. But what we can do is to leave the DRBG unseeded
>> during alloc time. As long as the DRBG is unseeded, it will return EAGAIN
>> to any request for random numbers, forcing the caller to use
>> crypto_rng_reset to activate the DRBG.
>> 
>> When the DRBG receives a reset, it will always obtain the seed and treat
>> any
>> user-provided data as personalization string / additional data.
>
>That's exactly what I was suggesting.  I already have two patches
>that I will post once I finish testing.

Ok, I will wait then for your patches before I send out my patch set for the 
seeding revamp.
>
>Cheers,


Ciao
Stephan
