From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFT PATCH] crypto: arm64 - implement SHA-512 using special
 instructions
Date: Thu, 18 Jan 2018 23:01:59 +1100
Message-ID: <20180118120159.GB20717@gondor.apana.org.au>
References: <20180109182302.11521-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-arm-kernel@lists.infradead.org, peter.maydell@linaro.org,
        will.deacon@arm.com, catalin.marinas@arm.com,
        steve.capper@linaro.org, linux-crypto@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:55332 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S932411AbeARMCv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jan 2018 07:02:51 -0500
Content-Disposition: inline
In-Reply-To: <20180109182302.11521-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 09, 2018 at 06:23:02PM +0000, Ard Biesheuvel wrote:
> Implement the SHA-512 using the new special instructions that have
> been introduced as an optional extension in ARMv8.2.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
