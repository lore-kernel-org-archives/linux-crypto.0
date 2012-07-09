From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: testmgr - make the assoc data and iv
 contiguous for aead tests
Date: Mon, 9 Jul 2012 16:19:35 +0800
Message-ID: <20120709081935.GA12103@gondor.apana.org.au>
References: <1341821863-16074-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Kim Phillips <kim.phillips@freescale.com>
To: Horia Geanta <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:35761 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751783Ab2GIITk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Jul 2012 04:19:40 -0400
Content-Disposition: inline
In-Reply-To: <1341821863-16074-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 09, 2012 at 11:17:43AM +0300, Horia Geanta wrote:
> In case of AEAD, some crypto engines expect assoc data and iv to be contiguous.
> This is how native IPsec works; make testmgr's behaviour the same.
> (Alternative would be to fix this in the crypto engine drivers, but this is
> pricy since it would involve memory allocation and copy in the hot path.)
> 
> Signed-off-by: Horia Geanta <horia.geanta@freescale.com>

I think we should fix the buggy driver instead.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
