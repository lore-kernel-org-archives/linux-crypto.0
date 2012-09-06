From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/4] crypto: crypto_user - fix sparse warnings (symbol
 was not declared, should be static?)
Date: Thu, 6 Sep 2012 13:22:17 -0700
Message-ID: <20120906202217.GH24269@gondor.apana.org.au>
References: <20120828134654.7113.67137.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:35083 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759795Ab2IFUWS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Sep 2012 16:22:18 -0400
Content-Disposition: inline
In-Reply-To: <20120828134654.7113.67137.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 28, 2012 at 04:46:54PM +0300, Jussi Kivilinna wrote:
> Fix "symbol 'x' was not declared. Should it be static?" sparse warnings.
> 
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

All four patches applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
