From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/6] crypto: arm64 - big endian fixes
Date: Tue, 11 Oct 2016 10:12:47 +0800
Message-ID: <20161011021247.GA10976@gondor.apana.org.au>
References: <1476034945-9186-1-git-send-email-ard.biesheuvel@linaro.org>
 <CAKv+Gu9Nj5ccpRpgqg9Ohif4=k5+dAVuP8tKtNEj9_z7BQ_jjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59969 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753010AbcJKCMz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Oct 2016 22:12:55 -0400
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9Nj5ccpRpgqg9Ohif4=k5+dAVuP8tKtNEj9_z7BQ_jjQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Oct 10, 2016 at 12:26:00PM +0100, Ard Biesheuvel wrote:
> 
> /* This piece of crap needs to disappear into per-type test hooks. */
> if (!((type ^ CRYPTO_ALG_TYPE_BLKCIPHER) &
>      CRYPTO_ALG_TYPE_BLKCIPHER_MASK) && !(type & CRYPTO_ALG_GENIV) &&
>    ((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
>     CRYPTO_ALG_TYPE_BLKCIPHER ? alg->cra_blkcipher.ivsize :
> alg->cra_ablkcipher.ivsize))
> type |= CRYPTO_ALG_TESTED;
> 
> This causes cbc(aes), ctr(aes) and xts(aes) to remain untested, unless
> I add CRYPTO_ALG_GENIV to their cra_flags. Is this expected behavior?
> What would be your recommended way to ensure these algos are covered
> by the boottime tests?

This is a leftover from the old blkcipher/ablkcipher interface.
I've got a patch pending which will remove this if clause.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
