From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Converting mac80211 CCMP to packet-at-a-time processing
Date: Thu, 18 Mar 2010 16:19:26 +0800
Message-ID: <20100318081926.GA11566@gondor.apana.org.au>
References: <1268720474.26820.36.camel@mj>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: roberto.sassu@polito.it, linux-crypto@vger.kernel.org
To: Pavel Roskin <proski@gnu.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:32934 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750835Ab0CRIUN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Mar 2010 04:20:13 -0400
Content-Disposition: inline
In-Reply-To: <1268720474.26820.36.camel@mj>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Pavel Roskin <proski@gnu.org> wrote:
>
>> You won't have to deal with completions if you allocate your
>> algorithm with the CRYPTO_ALG_ASYNC bit off.  Of course you won't
>> be able to use most hardware accelerations either.
> 
> Actually, I thought using CRYPTO_ALG_ASYNC in the mask meant to
> _exclude_ asynchronous algorithms.

That's what I just said, no?

> Is there any documentation for Linux crypto API that documents use of
> CRYPTO_ALG_ASYNC?  Also, I'd like to know meanings of
> CRYPTO_TFM_REQ_MAY_BACKLOG and CRYPTO_TFM_REQ_MAY_SLEEP.

Normally an async driver will simply drop requests and return
EBUSY when the hardware queue is full.  MAY_BACKLOG allows the
caller to place a single request on a backlog queue.  When that
request moves onto the hardware queue the caller will be notified
through the completion function with err set to EINPROGRESS.

This is used by drivers/md/dm-crypt.

MAY_SLEEP is only relevant for synchronous algorithms, it allows
the API to sleep which is useful if you are making a single large
request which would take an extended period of time to process.

> The crypto API feels like a minefield to me - I should check everything
> in the code or even experiment to figure out how the public API works.

Well patches to improve the API and/or documentation are welcome.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
