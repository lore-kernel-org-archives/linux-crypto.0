From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: cmac - allow usage in FIPS mode
Date: Wed, 19 Aug 2015 23:11:43 +0800
Message-ID: <20150819151143.GB20201@gondor.apana.org.au>
References: <2773400.HYW9KrTIf6@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39342 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001AbbHSPLr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Aug 2015 11:11:47 -0400
Content-Disposition: inline
In-Reply-To: <2773400.HYW9KrTIf6@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 19, 2015 at 08:42:07AM +0200, Stephan Mueller wrote:
> CMAC is an approved cipher in FIPS 140-2. The patch allows the use
> of CMAC with TDES and AES in FIPS mode.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
