From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: DRBG: do not call drbg_instantiate in healt test
Date: Tue, 16 Aug 2016 17:49:42 +0800
Message-ID: <20160816094942.GA27104@gondor.apana.org.au>
References: <6079382.fWeFLzBGfE@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: TSarangi@trustwave.com, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60254 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbcHPJuh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Aug 2016 05:50:37 -0400
Content-Disposition: inline
In-Reply-To: <6079382.fWeFLzBGfE@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Stephan Mueller <smueller@chronox.de> wrote:
> Am Dienstag, 9. August 2016, 19:52:46 CEST schrieb Stephan Mueller:
> 
> Hi Tapas,
> 
> I think I found the issue. Can you please test the attached patch?
> 
> ---8<---
> 
> When calling the DRBG health test in FIPS mode, the Jitter RNG is not
> yet present in the kernel crypto API which will cause the instantiation
> to fail and thus the health test to fail.
> 
> As the health tests cover the enforcement of various thresholds, invoke
> the functions that are supposed to enforce the thresholds directly.
> 
> This patch also saves precious seed.
> 
> Reported-by: Tapas Sarangi <TSarangi@trustwave.com>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
