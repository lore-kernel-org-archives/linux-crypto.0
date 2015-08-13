From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH 1/2] crypto: export crypto_alg_list and rwsem
Date: Thu, 13 Aug 2015 16:43:24 +0900
Message-ID: <20150813074323.GB14553@js1304-P5Q-DELUXE>
References: <1439432654-23322-1-git-send-email-iamjoonsoo.kim@lge.com>
 <20150813031954.GA19481@gondor.apana.org.au>
 <20150813063755.GA13352@js1304-P5Q-DELUXE>
 <20150813063823.GA20830@gondor.apana.org.au>
 <20150813073031.GC13352@js1304-P5Q-DELUXE>
 <20150813072917.GA21449@gondor.apana.org.au>
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
Received: from lgeamrelo01.lge.com ([156.147.1.125]:57655 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbbHMHhq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Aug 2015 03:37:46 -0400
Content-Disposition: inline
In-Reply-To: <20150813072917.GA21449@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 13, 2015 at 03:29:18PM +0800, Herbert Xu wrote:
> On Thu, Aug 13, 2015 at 04:30:31PM +0900, Joonsoo Kim wrote:
> >
> > How about introducing new functions to search supported algorithm in
> > kernel-side? As crypto API is used in more places, this interface
> > would be requested more. Defined list weaken the advantage of strong
> > point of generic crypto API.
> 
> You're only getting the list so you can immediately reexport
> it to user-space, with no added value whatsoever.  As I said
> we already have an interface for that so you should use it.
> 
> If more genuine uses come up then I will reconsider.

Okay. I will think this issue more and come back with better
solution.

Thanks.
