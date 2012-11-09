From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1] crypto: s5p-sss: Fix compilation error
Date: Fri, 9 Nov 2012 17:35:43 +0800
Message-ID: <20121109093543.GE25720@gondor.apana.org.au>
References: <1352355720-31685-1-git-send-email-sachin.kamat@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
	patches@linaro.org
To: Sachin Kamat <sachin.kamat@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:49890 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750976Ab2KIJfp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Nov 2012 04:35:45 -0500
Content-Disposition: inline
In-Reply-To: <1352355720-31685-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 08, 2012 at 11:52:00AM +0530, Sachin Kamat wrote:
> struct s3c2410_dma_client gets defined multiple times as it is defined
> in more than one header file. Changing it at the header file level causes
> many more build breakages as they are interdependent in a complex way.
> Hence fixing this problem by using the mach version of the header file.
> 
> Without this patch, following build error is observed:
> arch/arm/plat-samsung/include/plat/dma-pl330.h:106:27: error:
> redefinition of struct s3c2410_dma_client
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
