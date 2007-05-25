From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [1/1] HIFN: preliminary HIFN 795x driver for new async cryptoapi.
Date: Fri, 25 May 2007 21:35:32 +1000
Message-ID: <E1HrY4y-0007Xf-00@gondolin.me.apana.org.au>
References: <20070525102035.GA10069@2ka.mipt.ru>
Cc: linux-crypto@vger.kernel.org
To: johnpol@2ka.mipt.ru (Evgeniy Polyakov)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4270 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750936AbXEYLfe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 May 2007 07:35:34 -0400
In-Reply-To: <20070525102035.GA10069@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
>
> So, dm-crypt will fail and will not try to process that block again, 
> if crypto returns error. In acrypto I put a queue length as parameter 
> to crypto device (crypto_alg in cryptoapi) structure, and acrypto 
> load balancer always selected device which does have a space in the 
> queue. I think something similar should be created for cryptoapi, so 
> that even if device has higher prio it should not be selected until 
> there is a place in its queue. Software implementation has infinite 
> queue of course. In such case we do not need to have backlog queue,
> which can be overflown too.

The way I've solved is using the MAY_BACKLOG flag.  It's basically
an emergency reserve queue of length 1.  So for each tfm object,
you're guaranteed to be able to queue at least one request which
is sufficient.

This reminds me, I need to refresh my dm-crypt patch and repost it.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
