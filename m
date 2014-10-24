From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: drbg - use crypto_inc
Date: Fri, 24 Oct 2014 22:54:22 +0800
Message-ID: <20141024145422.GB21055@gondor.apana.org.au>
References: <1838543.MpsGos9GAS@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:38528 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932374AbaJXOy0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Oct 2014 10:54:26 -0400
Content-Disposition: inline
In-Reply-To: <1838543.MpsGos9GAS@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 14, 2014 at 09:50:13PM +0200, Stephan Mueller wrote:
> The DRBG internal buffer addition function is replaced with crypto_inc when
> a buffer is to be incremented by one.
> 
> The function drbg_add_buf is moved to the CONFIG_CRYPTO_DRBG_HASH ifdef
> area as it is now only needed for the Hash DRBG.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
