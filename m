From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: shash - Test for the algorithms import
	function before exporting it
Date: Fri, 24 Jul 2009 13:57:32 +0800
Message-ID: <20090724055732.GA22463@gondor.apana.org.au>
References: <20090722125302.GM20288@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:50702 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751088AbZGXF5e (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jul 2009 01:57:34 -0400
Content-Disposition: inline
In-Reply-To: <20090722125302.GM20288@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 22, 2009 at 02:53:02PM +0200, Steffen Klassert wrote:
> crypto_init_shash_ops_async() tests for setkey and not for import
> before exporting the algorithms import function to ahash.
> This patch fixes this.
> 
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

Patch applied.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
