From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: AF_ALG broken?
Date: Tue, 9 Aug 2016 18:35:49 +0800
Message-ID: <20160809103549.GA6934@gondor.apana.org.au>
References: <20160808181117.GD1041@n2100.armlinux.org.uk>
 <20160809031820.GA4142@gondor.apana.org.au>
 <20160809070859.GF1041@n2100.armlinux.org.uk>
 <20160809071402.GA5466@gondor.apana.org.au>
 <20160809072717.GG1041@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: noloader@gmail.com, linux-crypto@vger.kernel.org
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38445 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbcHIKf5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 06:35:57 -0400
Content-Disposition: inline
In-Reply-To: <20160809072717.GG1041@n2100.armlinux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 09, 2016 at 08:27:17AM +0100, Russell King - ARM Linux wrote:
>
> From: Russell King <rmk+kernel@armlinux.org.uk>
> Subject: [PATCH] crypto: caam - fix non-hmac hashes
> 
> Since 6de62f15b581 ("crypto: algif_hash - Require setkey before
> accept(2)"), the AF_ALG interface requires userspace to provide a key
> to any algorithm that has a setkey method.  However, the non-HMAC
> algorithms are not keyed, so setting a key is unnecessary.
> 
> Fix this by removing the setkey method from the non-keyed hash
> algorithms.
> 
> Fixes: 6de62f15b581 ("crypto: algif_hash - Require setkey before accept(2)")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
