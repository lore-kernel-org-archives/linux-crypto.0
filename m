From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: export crypto_alg_list and rwsem
Date: Thu, 13 Aug 2015 11:19:54 +0800
Message-ID: <20150813031954.GA19481@gondor.apana.org.au>
References: <1439432654-23322-1-git-send-email-iamjoonsoo.kim@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>,
	Nitin Gupta <ngupta@vflare.org>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Joonsoo Kim <js1304@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55100 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbbHMDUK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 12 Aug 2015 23:20:10 -0400
Content-Disposition: inline
In-Reply-To: <1439432654-23322-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 13, 2015 at 11:24:13AM +0900, Joonsoo Kim wrote:
> Until now, zram uses compression algorithm through direct call
> to core algorithm function, but, it has drawback that we need to add
> compression algorithm manually to zram. If we don't do that, we cannot
> utilize various compression algorithms in the system. To improve this
> situation, zram will be changed to use crypto subsystem in following
> patch. There is one problem with this change. Zram has a interface
> that what compression algorithm it can support. Although crypto subsystem
> has /proc interface to search all of crypto algorithm, but, there is
> no way to get just compression algorithm in cryto subsystem. To implement
> it on zram-side, crypto_alg_list and rwsem should be exported so
> this patch do it.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Nack.  We already have a netlink interface that can be used to
query algorithms and the type information is present in the report.
The interface is crypto_user and should be used instead of exporting
the raw list.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
