From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [PATCH v3 9/9] zram: use crypto decompress_noctx API
Date: Fri, 25 Sep 2015 16:51:14 +0900
Message-ID: <20150925075114.GC865@swordfish>
References: <1442553564-3476-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1442553564-3476-10-git-send-email-iamjoonsoo.kim@lge.com>
 <20150921035128.GD27729@bbox>
 <20150925054647.GG7158@js1304-P5Q-DELUXE>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Minchan Kim <minchan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nitin Gupta <ngupta@vflare.org>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:32784 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369AbbIYHu2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 Sep 2015 03:50:28 -0400
Content-Disposition: inline
In-Reply-To: <20150925054647.GG7158@js1304-P5Q-DELUXE>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On (09/25/15 14:46), Joonsoo Kim wrote:
[..]
> > >  struct zcomp_strm *zcomp_decompress_begin(struct zcomp *comp)
> > >  {
> > > +	if (comp->tfm_noctx)
> > > +		return NULL;
> > 
> > Hmm,, I understand why returns NULL but it seems to be awkward to use NULL
> > to express meaningful semantic and following functions relies on.
> > If I have a time, I will think over.
> 
> I also think that it's not good thing but I can't think any better
> idea. Please let me know if you have better one.

yeah, me neither.

	-ss
