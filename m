From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 1/8] crypto: support (de)compression API that doesn't
 require tfm object
Date: Thu, 20 Aug 2015 14:47:28 +0800
Message-ID: <20150820064728.GA26840@gondor.apana.org.au>
References: <1440052504-15442-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1440052504-15442-2-git-send-email-iamjoonsoo.kim@lge.com>
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
Received: from helcar.hengli.com.au ([209.40.204.226]:51155 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbbHTGrl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 20 Aug 2015 02:47:41 -0400
Content-Disposition: inline
In-Reply-To: <1440052504-15442-2-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 20, 2015 at 03:34:57PM +0900, Joonsoo Kim wrote:
> Until now, tfm object embeds (de)compression context in it and
> (de)compression in crypto API requires tfm object to use
> this context. But, there are some algorithms that doesn't need
> such context to operate. Therefore, this patch introduce new crypto
> compression API that call (de)compression function via crypto_alg,
> instead of tfm object. crypto_alg is required to get appropriate
> (de)compression function pointer. This can reduce overhead of
> maintaining multiple tfm if (de)compression doesn't require
> any context to operate.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

This isn't going to fly I'm afraid.  The main purpose of a tfm
is not to allocate memory but to track the crypto_alg object
which could be a hardware device.

So you're not going to get away with not allocating it.

What you can do for these contextless algorithms (and by definition
every compression algorithm is conxteless) is to allocate a system-
wide tfm that is used by everybody, or at least by every one within
your subsystem.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
