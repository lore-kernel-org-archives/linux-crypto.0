From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH v3 9/9] zram: use crypto decompress_noctx API
Date: Fri, 25 Sep 2015 14:47:45 +0900
Message-ID: <20150925054744.GH7158@js1304-P5Q-DELUXE>
References: <1442553564-3476-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1442553564-3476-10-git-send-email-iamjoonsoo.kim@lge.com>
 <20150921075600.GA511@swordfish>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>,
	Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>
To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from LGEAMRELO11.lge.com ([156.147.23.51]:54262 "EHLO
	lgeamrelo11.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889AbbIYFqk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 Sep 2015 01:46:40 -0400
Content-Disposition: inline
In-Reply-To: <20150921075600.GA511@swordfish>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Sep 21, 2015 at 04:56:00PM +0900, Sergey Senozhatsky wrote:
> On (09/18/15 14:19), Joonsoo Kim wrote:
> [..]
> > +	/*
> > +	 * Prepare to use crypto decompress_noctx API. One tfm is required
> > +	 * to initialize crypto algorithm properly and fetch corresponding
> > +	 * function pointer. But, it is sharable for multiple concurrent
> > +	 * decompress users.
> > +	 */
> 
> if comp algorithm require zstrm for both compression and decompression,
> then there seems to be no need in allocating sharable ->tfm_noctx, we
> will never use it.
> 

Yes, in that case, NULL will be returned. I should describe it on
somewhere.

Thanks.
