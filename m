From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 2/2] crypto: algapi - annotate expected branch
 behavior in crypto_inc()
Date: Thu, 9 Mar 2017 18:46:34 +0800
Message-ID: <20170309104634.GC7185@gondor.apana.org.au>
References: <1487109062-3419-1-git-send-email-ard.biesheuvel@linaro.org>
 <1487109062-3419-2-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55541 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932845AbdCISS3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Mar 2017 13:18:29 -0500
Content-Disposition: inline
In-Reply-To: <1487109062-3419-2-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 14, 2017 at 09:51:02PM +0000, Ard Biesheuvel wrote:
> To prevent unnecessary branching, mark the exit condition of the
> primary loop as likely(), given that a carry in a 32-bit counter
> occurs very rarely.
> 
> On arm64, the resulting code is emitted by GCC as
> 
>      9a8:   cmp     w1, #0x3
>      9ac:   add     x3, x0, w1, uxtw
>      9b0:   b.ls    9e0 <crypto_inc+0x38>
>      9b4:   ldr     w2, [x3,#-4]!
>      9b8:   rev     w2, w2
>      9bc:   add     w2, w2, #0x1
>      9c0:   rev     w4, w2
>      9c4:   str     w4, [x3]
>      9c8:   cbz     w2, 9d0 <crypto_inc+0x28>
>      9cc:   ret
> 
> where the two remaining branch conditions (one for size < 4 and one for
> the carry) are statically predicted as non-taken, resulting in optimal
> execution in the vast majority of cases.
> 
> Also, replace the open coded alignment test with IS_ALIGNED().
> 
> Cc: Jason A. Donenfeld <Jason@zx2c4.com>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
