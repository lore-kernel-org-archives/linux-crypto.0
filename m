From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: drbg - set HMAC key only when altered
Date: Tue, 5 Apr 2016 20:50:30 +0800
Message-ID: <20160405125030.GO13048@gondor.apana.org.au>
References: <1989575.kgMrm1hmR5@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54909 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758454AbcDEMud (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Apr 2016 08:50:33 -0400
Content-Disposition: inline
In-Reply-To: <1989575.kgMrm1hmR5@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 28, 2016 at 04:47:55PM +0200, Stephan Mueller wrote:
> The HMAC implementation allows setting the HMAC key independently from
> the hashing operation. Therefore, the key only needs to be set when a
> new key is generated.
> 
> This patch increases the speed of the HMAC DRBG by at least 35% depending
> on the use case.
> 
> The patch is fully CAVS tested.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
