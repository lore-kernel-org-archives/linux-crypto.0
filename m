From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH v2 1/8] crypto: support (de)compression API that doesn't
 require tfm object
Date: Thu, 20 Aug 2015 16:52:17 +0900
Message-ID: <20150820075217.GA30260@js1304-P5Q-DELUXE>
References: <1440052504-15442-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1440052504-15442-2-git-send-email-iamjoonsoo.kim@lge.com>
 <20150820064728.GA26840@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>,
	Nitin Gupta <ngupta@vflare.org>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:44334 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbbHTHqL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 20 Aug 2015 03:46:11 -0400
Content-Disposition: inline
In-Reply-To: <20150820064728.GA26840@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 20, 2015 at 02:47:28PM +0800, Herbert Xu wrote:
> On Thu, Aug 20, 2015 at 03:34:57PM +0900, Joonsoo Kim wrote:
> > Until now, tfm object embeds (de)compression context in it and
> > (de)compression in crypto API requires tfm object to use
> > this context. But, there are some algorithms that doesn't need
> > such context to operate. Therefore, this patch introduce new crypto
> > compression API that call (de)compression function via crypto_alg,
> > instead of tfm object. crypto_alg is required to get appropriate
> > (de)compression function pointer. This can reduce overhead of
> > maintaining multiple tfm if (de)compression doesn't require
> > any context to operate.
> > 
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> This isn't going to fly I'm afraid.  The main purpose of a tfm
> is not to allocate memory but to track the crypto_alg object
> which could be a hardware device.
> 
> So you're not going to get away with not allocating it.

Hmm... I guess there is no problem. crypto_alg object fetched by
crypto_get_comp() introduced in this patch could be hardware device
algorithm which is same one that we can eventually fetch from tfm object.
So, this approach would correctly track the crypto_alg regardless
it is a hardware one or not. If there is some dependency between
algorithm and tfm, it can't support _noctx API. Am I missing
something?

> 
> What you can do for these contextless algorithms (and by definition
> every compression algorithm is conxteless) is to allocate a system-
> wide tfm that is used by everybody, or at least by every one within
> your subsystem.

Yes, I thought this way before, but, current way is much simpler so
I try it first. If it is not acceptable, I will implement this
approach.

Thanks.
