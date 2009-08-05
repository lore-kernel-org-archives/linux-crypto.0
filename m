From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3] crypto: authenc - convert to ahash
Date: Wed, 5 Aug 2009 19:35:21 +1000
Message-ID: <20090805093521.GA12479@gondor.apana.org.au>
References: <20090722094951.GK20288@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53147 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932964AbZHEJfX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Aug 2009 05:35:23 -0400
Content-Disposition: inline
In-Reply-To: <20090722094951.GK20288@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 22, 2009 at 11:49:51AM +0200, Steffen Klassert wrote:
> This patch converts authenc to the new ahash interface.
> 
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

Applied to cryptodev.  Thanks a lot Steffen!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
