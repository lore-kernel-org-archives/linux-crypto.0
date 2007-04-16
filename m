From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [0/6] [CRYPTO]: Async blkcipher backend support
Date: Mon, 16 Apr 2007 15:28:42 +0400
Message-ID: <20070416112842.GA2207@2ka.mipt.ru>
References: <20070416105105.GA10188@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:44697 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030456AbXDPL3P (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Apr 2007 07:29:15 -0400
Content-Disposition: inline
In-Reply-To: <20070416105105.GA10188@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Apr 16, 2007 at 08:51:05PM +1000, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> Hi:
> 
> This series of patches adds the backend support for asynchronous blkcipher
> implementations.  This includes the ablkcipher crypto type, generic crypto
> request queueing, as well as a sample cryptd implementation that turns any
> sync blkcipher algorithm into an async one by processing requests in a
> dedicated kernel thread.
> 
> This allows drivers for hardware blkcipher devices to be written.

Hi Herbert.

Good to see async crypto processing is being (a bit slowly - more than a
year after we talked about it previously :) completed.
With this patchset included there will not be requirement for another async levels,
so I can port HIFN 795x driver from acrypto to this one.

Do you have a stable git tree to pull from, so I could prepare a testbed.
(althugh I can not start right now, but expect to do it soon).

And, hmm, your documentation really sucks, could you write a draft for
async api and put it into the tree?

Thanks for the work.

-- 
	Evgeniy Polyakov
