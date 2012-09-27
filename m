From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: cast5/avx - fix storing of new IV in CBC
 encryption
Date: Wed, 26 Sep 2012 22:45:06 -0700
Message-ID: <20120927054506.GF22311@gondor.apana.org.au>
References: <20120919112456.12812.51190.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:52620 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752823Ab2I0FpH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 27 Sep 2012 01:45:07 -0400
Content-Disposition: inline
In-Reply-To: <20120919112456.12812.51190.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 19, 2012 at 02:24:57PM +0300, Jussi Kivilinna wrote:
> cast5/avx incorrectly XORs new IV over old IV at end of CBC encryption
> function when it should store. This causes CBC encryption to give
> incorrect output on multi-page encryption requests.
> 
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
