From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH v2 1/8] crypto: support (de)compression API that doesn't
 require tfm object
Date: Thu, 20 Aug 2015 17:05:48 +0900
Message-ID: <20150820080547.GB30260@js1304-P5Q-DELUXE>
References: <1440052504-15442-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1440052504-15442-2-git-send-email-iamjoonsoo.kim@lge.com>
 <20150820064728.GA26840@gondor.apana.org.au>
 <20150820075217.GA30260@js1304-P5Q-DELUXE>
 <20150820075035.GA27535@gondor.apana.org.au>
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
Received: from lgeamrelo02.lge.com ([156.147.1.126]:39859 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbbHTH7m (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 20 Aug 2015 03:59:42 -0400
Content-Disposition: inline
In-Reply-To: <20150820075035.GA27535@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 20, 2015 at 03:50:35PM +0800, Herbert Xu wrote:
> On Thu, Aug 20, 2015 at 04:52:17PM +0900, Joonsoo Kim wrote:
> > 
> > Hmm... I guess there is no problem. crypto_alg object fetched by
> > crypto_get_comp() introduced in this patch could be hardware device
> > algorithm which is same one that we can eventually fetch from tfm object.
> > So, this approach would correctly track the crypto_alg regardless
> > it is a hardware one or not. If there is some dependency between
> > algorithm and tfm, it can't support _noctx API. Am I missing
> > something?
> 
> Your approach limits what hardware devices we can support in
> future.  It is fairly common for hardware drivers to only allocate
> resources when a tfm is created.  With your tfmless interface,
> the driver would have to unconditionally allocate resources.

Ah...Okay. thanks for clarifying.

> 
> It is essentially a global tfm without the tfm.
> 
> > Yes, I thought this way before, but, current way is much simpler so
> > I try it first. If it is not acceptable, I will implement this
> > approach.
> 
> Please go with a global tfm.

Okay. Will do that in next spin.

Thanks.
