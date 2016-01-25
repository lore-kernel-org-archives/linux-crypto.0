From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: drbg - remove FIPS 140-2 continuous test
Date: Mon, 25 Jan 2016 22:49:28 +0800
Message-ID: <20160125144928.GK8840@gondor.apana.org.au>
References: <1788690.PnFbicKICx@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto <linux-crypto@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Stephan Mueller <sm@eperm.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54094 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757130AbcAYOte (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Jan 2016 09:49:34 -0500
Content-Disposition: inline
In-Reply-To: <1788690.PnFbicKICx@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 22, 2016 at 09:52:28AM +0100, Stephan Mueller wrote:
> Hi,
> 
> the following patch is fully CAVS tested on 64 bit and 32 bit.
> 
> Note, this change cannot be made for random.c or ansi_cprng.c, unfortunately.
> 
> ---8<---
> The newly released FIPS 140-2 IG 9.8 specifies that for SP800-90A
> compliant DRBGs, the FIPS 140-2 continuous random number generator test
> is not required any more.
> 
> This patch removes the test and all associated data structures.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
