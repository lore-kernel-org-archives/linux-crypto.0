From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH 1/2] crypto: export crypto_alg_list and rwsem
Date: Thu, 13 Aug 2015 16:30:31 +0900
Message-ID: <20150813073031.GC13352@js1304-P5Q-DELUXE>
References: <1439432654-23322-1-git-send-email-iamjoonsoo.kim@lge.com>
 <20150813031954.GA19481@gondor.apana.org.au>
 <20150813063755.GA13352@js1304-P5Q-DELUXE>
 <20150813063823.GA20830@gondor.apana.org.au>
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
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:34750 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbbHMHYv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Aug 2015 03:24:51 -0400
Content-Disposition: inline
In-Reply-To: <20150813063823.GA20830@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 13, 2015 at 02:38:23PM +0800, Herbert Xu wrote:
> On Thu, Aug 13, 2015 at 03:37:55PM +0900, Joonsoo Kim wrote:
> >
> > Is there any way to access netlink interface and get the output from
> > kernel-side? I'd like to show information through
> > "/sys/block/zramX/comp_algorithm", because some user program can be
> > broken if we change output of userspace exposed interface.
> 
> You could simply deprecate that interface but keep it for existing
> algorithms.  Any new algorithms can then be queried through the
> crypto_user interface.
> 
> The other option is to have a defined list of algorithms which is
> independent of the crypto API.  For example, have a look at what
> IPsec does in net/xfrm/xfrm_algo.c.  IPsec needs its own list
> because they come with annotations.

Hmm... they looks suboptimal.

How about introducing new functions to search supported algorithm in
kernel-side? As crypto API is used in more places, this interface
would be requested more. Defined list weaken the advantage of strong
point of generic crypto API.

Thanks.
