From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/7] arm64: move literal data into .rodata section
Date: Thu, 18 Jan 2018 22:41:12 +1100
Message-ID: <20180118114112.GA20091@gondor.apana.org.au>
References: <20180110121142.18291-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        will.deacon@arm.com, catalin.marinas@arm.com, marc.zyngier@arm.com,
        mark.rutland@arm.com, dann.frazier@canonical.com,
        steve.capper@linaro.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:55290 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1752184AbeARLlV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jan 2018 06:41:21 -0500
Content-Disposition: inline
In-Reply-To: <20180110121142.18291-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 10, 2018 at 12:11:35PM +0000, Ard Biesheuvel wrote:
> Prevent inadvertently creating speculative gadgets by moving literal data
> into the .rodata section.
> 
> Patch #1 enables this for C code, by reverting a change that disables the
> GCC feature implementing this. Note that this conflicts with the mitigation
> of erratum #843419 for Cortex-A53.

Ard, which tree is this supposed to go through?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
