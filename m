From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto/generic - sha3: deal with oversize stack frames
Date: Fri, 9 Feb 2018 23:50:00 +0800
Message-ID: <20180209155000.GC22273@gondor.apana.org.au>
References: <20180127091832.24435-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, arnd@arndb.de
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:56818 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751031AbeBIPuH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Feb 2018 10:50:07 -0500
Content-Disposition: inline
In-Reply-To: <20180127091832.24435-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Jan 27, 2018 at 09:18:32AM +0000, Ard Biesheuvel wrote:
> As reported by kbuild test robot, the optimized SHA3 C implementation
> compiles to mn10300 code that uses a disproportionate amount of stack
> space, i.e.,
> 
>   crypto/sha3_generic.c: In function 'keccakf':
>   crypto/sha3_generic.c:147:1: warning: the frame size of 1232 bytes is larger than 1024 bytes [-Wframe-larger-than=]
> 
> As kindly diagnosed by Arnd, this does not only occur when building for
> the mn10300 architecture (which is what the report was about) but also
> for h8300, and builds for other 32-bit architectures show an increase in
> stack space utilization as well.
> 
> Given that SHA3 operates on 64-bit quantities, and keeps a state matrix
> of 25 64-bit words, it is not surprising that 32-bit architectures with
> few general purpose registers are impacted the most by this, and it is
> therefore reasonable to implement a workaround that distinguishes between
> 32-bit and 64-bit architectures.
> 
> Arnd figured out that taking the round calculation out of the loop, and
> inlining it explicitly but only on 64-bit architectures preserves most
> of the performance gain achieved by the rewrite, and also gets rid of
> the excessive use of stack space.
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
