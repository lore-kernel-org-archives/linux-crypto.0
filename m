From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: scompress - eliminate percpu scratch buffers
Date: Fri, 21 Jul 2017 20:42:55 +0800
Message-ID: <20170721124255.GA19913@gondor.apana.org.au>
References: <20170720114000.13840-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, giovanni.cabiddu@intel.com
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:34392 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750835AbdGUMnd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jul 2017 08:43:33 -0400
Content-Disposition: inline
In-Reply-To: <20170720114000.13840-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 20, 2017 at 12:40:00PM +0100, Ard Biesheuvel wrote:
> The scompress code unconditionally allocates 2 per-CPU scratch buffers
> of 128 KB each, in order to avoid allocation overhead in the async
> wrapper that encapsulates the synchronous compression algorithm, since
> it may execute in atomic context.

The whole point of pre-allocation is that we cannot allocate 128K
(or 64K as it was before scomp) at run-time, and in particular,
for IPsec which runs in softirq path.  Am I missing something?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
