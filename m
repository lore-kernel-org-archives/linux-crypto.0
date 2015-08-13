From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: export crypto_alg_list and rwsem
Date: Thu, 13 Aug 2015 14:38:23 +0800
Message-ID: <20150813063823.GA20830@gondor.apana.org.au>
References: <1439432654-23322-1-git-send-email-iamjoonsoo.kim@lge.com>
 <20150813031954.GA19481@gondor.apana.org.au>
 <20150813063755.GA13352@js1304-P5Q-DELUXE>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>,
	Nitin Gupta <ngupta@vflare.org>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43957 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbbHMGjx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Aug 2015 02:39:53 -0400
Content-Disposition: inline
In-Reply-To: <20150813063755.GA13352@js1304-P5Q-DELUXE>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 13, 2015 at 03:37:55PM +0900, Joonsoo Kim wrote:
>
> Is there any way to access netlink interface and get the output from
> kernel-side? I'd like to show information through
> "/sys/block/zramX/comp_algorithm", because some user program can be
> broken if we change output of userspace exposed interface.

You could simply deprecate that interface but keep it for existing
algorithms.  Any new algorithms can then be queried through the
crypto_user interface.

The other option is to have a defined list of algorithms which is
independent of the crypto API.  For example, have a look at what
IPsec does in net/xfrm/xfrm_algo.c.  IPsec needs its own list
because they come with annotations.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
