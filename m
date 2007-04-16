From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [0/6] [CRYPTO]: Async blkcipher backend support
Date: Mon, 16 Apr 2007 22:39:42 +1000
Message-ID: <20070416123942.GA11887@gondor.apana.org.au>
References: <20070416105105.GA10188@gondor.apana.org.au> <20070416112842.GA2207@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1537 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030519AbXDPMjo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Apr 2007 08:39:44 -0400
Content-Disposition: inline
In-Reply-To: <20070416112842.GA2207@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

HI Evgeniy:

On Mon, Apr 16, 2007 at 03:28:42PM +0400, Evgeniy Polyakov wrote:
> 
> Good to see async crypto processing is being (a bit slowly - more than a
> year after we talked about it previously :) completed.

Yeah I haven't really been able to put enough time into it unfortunately.

> With this patchset included there will not be requirement for another async levels,
> so I can port HIFN 795x driver from acrypto to this one.

Great!

> Do you have a stable git tree to pull from, so I could prepare a testbed.
> (althugh I can not start right now, but expect to do it soon).

These patches are now in cryptodev-2.6 and they will also show up in
mm soon.

> And, hmm, your documentation really sucks, could you write a draft for
> async api and put it into the tree?

Yes they suck so much that they don't exist :)

Once things settle down a bit I'll write something up.  Of course
patches are welcome too.

For now the best place to start would be to look at the async crypto
users (tcrypt and dm-crypt) and driver (cryptd).

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
