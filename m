From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/6] crypto: serpent-sse2 - use crypto_[un]register_algs
Date: Sat, 25 Feb 2012 20:22:24 +1100
Message-ID: <20120225092224.GA19638@gondor.apana.org.au>
References: <20120217204837.3744.54155.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:56119 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755316Ab2BYJW1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 25 Feb 2012 04:22:27 -0500
Content-Disposition: inline
In-Reply-To: <20120217204837.3744.54155.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 17, 2012 at 10:48:37PM +0200, Jussi Kivilinna wrote:
> Combine all crypto_alg to be registered and use new crypto_[un]register_algs
> functions. Simplifies init/exit code and reduce object size.
> 
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
