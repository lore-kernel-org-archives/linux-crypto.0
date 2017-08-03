From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH resend 00/18] crypto: ARM/arm64 roundup for v4.14
Date: Thu, 3 Aug 2017 13:16:19 +0800
Message-ID: <20170803051619.GA11594@gondor.apana.org.au>
References: <20170724102820.16534-1-ard.biesheuvel@linaro.org>
 <20170802144613.GH6321@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>
To: Dave Martin <Dave.Martin@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:58132 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750850AbdHCFQd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Aug 2017 01:16:33 -0400
Content-Disposition: inline
In-Reply-To: <20170802144613.GH6321@e103592.cambridge.arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 02, 2017 at 03:46:16PM +0100, Dave Martin wrote:
> Hi Herbert,
> 
> This series from Ard is a prerequisite for an arm64 series [1] that I'd
> like to get merged this cycle (because it is in turn a prerequisite for
> another major series I want to progress).
> 
> [1] without this series will break the kernel, whereas this series
> without [1] won't break the kernel, but will cause performance
> regressions in the arm64 crypto code due to unnecessary execution of C
> fallbacks.
> 
> So it would be good to get both merged this cycle.
> 
> Can Ard's series be merged for v4.14, do you think?

I don't see any issues with this making 4.14.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
