From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] code cleanups for crypto/blkcipher.c
Date: Sat, 25 Jul 2015 09:56:11 +0800
Message-ID: <20150725015611.GB29321@gondor.apana.org.au>
References: <1437746672.19489.2.camel@My-Computer>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Ahmed Mohamed Abd EL Mawgood <ahmedsoliman0x666@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44452 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928AbbGYB4Q (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jul 2015 21:56:16 -0400
Content-Disposition: inline
In-Reply-To: <1437746672.19489.2.camel@My-Computer>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 24, 2015 at 04:04:32PM +0200, Ahmed Mohamed Abd EL Mawgood wrote:
>
> @@ -68,6 +68,7 @@ static inline void blkcipher_unmap_dst(struct blkcipher_walk *walk)
>  static inline u8 *blkcipher_get_spot(u8 *start, unsigned int len)
>  {
>  	u8 *end_page = (u8 *)(((unsigned long)(start + len - 1)) & PAGE_MASK);
> +
>  	return max(start, end_page);
>  }

Nack.  This makes the code less readable.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
