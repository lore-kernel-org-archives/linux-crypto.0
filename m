From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: x86/glue_helper - fix storing of new IV in CBC
 encryption
Date: Wed, 26 Sep 2012 22:31:45 -0700
Message-ID: <20120927053145.GA22225@gondor.apana.org.au>
References: <20120919064030.10037.69526.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:49743 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754825Ab2I0Fbs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 27 Sep 2012 01:31:48 -0400
Content-Disposition: inline
In-Reply-To: <20120919064030.10037.69526.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 19, 2012 at 09:40:30AM +0300, Jussi Kivilinna wrote:
> Glue_helper incorrectly XORs new IV over old IV at end of CBC encryption
> function when it should store. This causes CBC encryption to give
> incorrect output on multi-page encryption requests.
> 
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

Patch applied to crypto.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
