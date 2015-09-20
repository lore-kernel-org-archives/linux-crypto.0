From: Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v3 6/9] zram: make stream find and release functions
 static
Date: Mon, 21 Sep 2015 08:39:17 +0900
Message-ID: <20150920233854.GA27729@bbox>
References: <1442553564-3476-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1442553564-3476-7-git-send-email-iamjoonsoo.kim@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Nitin Gupta <ngupta@vflare.org>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>,
	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Joonsoo Kim <js1304@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:33606 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445AbbITXhy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 20 Sep 2015 19:37:54 -0400
Content-Disposition: inline
In-Reply-To: <1442553564-3476-7-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Sep 18, 2015 at 02:19:21PM +0900, Joonsoo Kim wrote:
> From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> 
> Hide (make static) zstrm find and release function and introduce
> zcomp_compress_begin()/zcomp_compress_end(). We will have begin
> and end functions around compression (this patch) and decompression
> (next patch). So the work flow is evolving to:
> 
> 	zstrm = foo_begin();
> 	foo(zstrm);
> 	foo_end(zstrm);
> 
> where foo is compress or decompress zcomp functions.
> 
> This patch is a preparation to make crypto API-powered zcomp
> possible. The reasoning is that some crypto compression backends
> require zstrm for decompression.
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Minchan Kim <minchan@kernel.org>
