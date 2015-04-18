From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/4] cryoto: drbg - clear all temporary memory
Date: Sat, 18 Apr 2015 18:59:29 +0800
Message-ID: <20150418105929.GA5561@gondor.apana.org.au>
References: <1551177.C0RmlOO9iU@myon.chronox.de>
 <11443550.8lhOr92W5F@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51557 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbbDRK7d (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 18 Apr 2015 06:59:33 -0400
Content-Disposition: inline
In-Reply-To: <11443550.8lhOr92W5F@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Apr 17, 2015 at 02:54:08PM +0200, Stephan Mueller wrote:
> The buffer uses for temporary data must be cleared entirely. In AES192
> the used buffer is drbg_statelen(drbg) + drbg_blocklen(drbg) as
> documented in the comment above drbg_ctr_df.
> 
> This patch ensures that the temp buffer is completely wiped.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
