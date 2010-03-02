From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: authenc - Use correct ahash complete
	functions
Date: Tue, 2 Mar 2010 22:08:34 +0800
Message-ID: <20100302140834.GA3808@gondor.apana.org.au>
References: <20100223062109.GD29013@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:39522 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752362Ab0CBOIh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Mar 2010 09:08:37 -0500
Content-Disposition: inline
In-Reply-To: <20100223062109.GD29013@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 23, 2010 at 07:21:09AM +0100, Steffen Klassert wrote:
> We accidentally assigned the ahash update complete function to
> the wrong function pointer in crypto_authenc_verify.
> This patch fixes this.
> 
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

Patch applied.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
