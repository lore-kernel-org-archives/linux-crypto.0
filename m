From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 1/9] crypto: introduce decompression API that can be
 called via sharable tfm object
Date: Fri, 25 Sep 2015 15:58:29 +0800
Message-ID: <20150925075829.GA6464@gondor.apana.org.au>
References: <1442553564-3476-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1442553564-3476-2-git-send-email-iamjoonsoo.kim@lge.com>
 <20150921061817.GC5313@swordfish>
 <20150925052617.GB7158@js1304-P5Q-DELUXE>
 <20150925075610.GD865@swordfish>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>,
	Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>
To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:49232 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571AbbIYH6n (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 Sep 2015 03:58:43 -0400
Content-Disposition: inline
In-Reply-To: <20150925075610.GD865@swordfish>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Sep 25, 2015 at 04:56:10PM +0900, Sergey Senozhatsky wrote:
>
> so you want to go with _noctx() callbacks implementation?
> that CRYPTO_ALG_TFM_MAY_SHARE flag looks quite simple to
> me. or you guys hate it?

I think we should just replace crypto_pcomp with a new interface
that does what you guys want.  The current crypto_compress interface
is simply broken because it stores per-request state in the tfm.
This runs counter to every other crypto type, e.g., hash or aead.

The tfm should only hold shared data, e.g., compression algorithm
parameters but not per-request state.

As the original pcomp author has disappeared I think you could
even drop the partial stuff and just do a straight compression
interface.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
