From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 04/10] crypto/compress: add asynchronous compression
 support
Date: Wed, 27 Jan 2016 16:03:55 +0800
Message-ID: <20160127080355.GA31330@gondor.apana.org.au>
References: <1453796112-14273-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1453796112-14273-5-git-send-email-iamjoonsoo.kim@lge.com>
 <20160127074140.GA30335@gondor.apana.org.au>
 <56A878C9.8050202@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Joonsoo Kim <js1304@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	Minchan Kim <minchan@kernel.org>,
	Dan Streetman <ddstreet@ieee.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: "Li, Weigang" <weigang.li@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46387 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbcA0IEO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Jan 2016 03:04:14 -0500
Content-Disposition: inline
In-Reply-To: <56A878C9.8050202@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 27, 2016 at 03:59:05PM +0800, Li, Weigang wrote:
>
> The acomp is also SG-based, while scomp only accepts flat buffer.

Right, but do we need a pointer-based scomp at all? IPComp would
certainly be better off with an SG-based interface.  Any other
users of compression are presumably dealing with large amounts
of data where an SG interface would make more sense.

A pointer interface makes sense for shash because you may be hashing
16 bytes at a time.  Nobody sane is going to be compressing 16 bytes,
or are they?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
