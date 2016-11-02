From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] poly1305: generic C can be faster on chips with slow
 unaligned access
Date: Thu, 3 Nov 2016 04:09:59 +0800
Message-ID: <20161102200959.GA23297@gondor.apana.org.au>
References: <20161102175810.18647-1-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Willi <martin@strongswan.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:50821 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755953AbcKBUKJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Nov 2016 16:10:09 -0400
Content-Disposition: inline
In-Reply-To: <20161102175810.18647-1-Jason@zx2c4.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 02, 2016 at 06:58:10PM +0100, Jason A. Donenfeld wrote:
> On MIPS chips commonly found in inexpensive routers, this makes a big
> difference in performance.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Can you give some numbers please? What about other architectures
that your patch impacts?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
