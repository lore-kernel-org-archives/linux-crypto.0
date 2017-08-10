From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: AF_ALG - consolidation of duplicate code
Date: Thu, 10 Aug 2017 16:21:53 +0800
Message-ID: <20170810082153.GA4110@gondor.apana.org.au>
References: <2922624.oQubu9mOmR@positron.chronox.de>
 <20170809135733.GG743@gondor.apana.org.au>
 <3124682.PWyg91A0St@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37794 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751715AbdHJIWC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Aug 2017 04:22:02 -0400
Content-Disposition: inline
In-Reply-To: <3124682.PWyg91A0St@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 10, 2017 at 10:16:48AM +0200, Stephan Mueller wrote:
>
> As now the AIO code path is updated, the bug that I was reporting last 
> September allowing to crash the kernel via AF_ALG is fixed.
> 
> As the patch is very invasive, I am not sure that patch set should be sent to 
> stable. How do you propose we fix the crash bug in older kernels that are due 
> to memory management problems in the AIO code path?

Is it possible to create a minimal fix for the stable kernels?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
