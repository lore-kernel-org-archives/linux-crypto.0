From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto - ablk_helper: add module parameter to allow
 testing cryptd redirection of requests
Date: Wed, 24 Oct 2012 21:17:02 +0800
Message-ID: <20121024131702.GE3251@gondor.apana.org.au>
References: <20121021174529.11043.15034.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:33160 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756487Ab2JXNRF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Oct 2012 09:17:05 -0400
Content-Disposition: inline
In-Reply-To: <20121021174529.11043.15034.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Oct 21, 2012 at 08:45:29PM +0300, Jussi Kivilinna wrote:
> Add module parameter to allow forcing redirection of crypto requests to
> cryptd worker threads. This allows these code paths to be actually tested
> (easier).
> 
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

Wouldn't this be applicable in other spots too? Perhaps we need
something that just makes irq_fpu_usable return false?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
