From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/8] crypto: ARM/arm64 - big endian fixes
Date: Fri, 21 Oct 2016 11:16:04 +0800
Message-ID: <20161021031604.GJ22979@gondor.apana.org.au>
References: <1476209720-21114-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        will.deacon@arm.com, catalin.marinas@arm.com,
        linux@arm.linux.org.uk
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34810 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753416AbcJUDQQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Oct 2016 23:16:16 -0400
Content-Disposition: inline
In-Reply-To: <1476209720-21114-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 11, 2016 at 07:15:12PM +0100, Ard Biesheuvel wrote:
> As it turns out, none of the accelerated crypto routines under arch/arm64/crypto
> currently work, or have ever worked correctly when built for big endian. So this
> series fixes all of them. This v2 now includes a similar fix for 32-bit ARM as
> well, and an additional fix for XTS which escaped my attention before.
> 
> Each of these patches carries a fixes tag, and could be backported to stable.
> However, for patches #1 and #5, the fixes tag denotes the oldest commit that the
> fix is compatible with, not the patch that introduced the algorithm. This is due
> to the fact that the key schedules are incompatible between generic AES and the
> arm64 Crypto Extensions implementation (but only when building for big endian)
> This is not a problem in practice, but it does mean that the AES-CCM and AES in
> EBC/CBC/CTR/XTS mode implementations before v3.19 require a different fix, i.e.,
> one that is compatible with the generic AES key schedule generation code (which
> it currently no longer uses)
> 
> In any case, please apply with cc to stable.
> 
> Ard Biesheuvel (8):
>   crypto: arm64/aes-ce - fix for big endian
>   crypto: arm64/ghash-ce - fix for big endian
>   crypto: arm64/sha1-ce - fix for big endian
>   crypto: arm64/sha2-ce - fix for big endian
>   crypto: arm64/aes-ccm-ce: fix for big endian
>   crypto: arm64/aes-neon - fix for big endian
>   crypto: arm64/aes-xts-ce: fix for big endian
>   crypto: arm/aes-ce - fix for big endian
> 
>  arch/arm/crypto/aes-ce-glue.c       |  5 ++
>  arch/arm64/crypto/aes-ce-ccm-core.S | 53 ++++++++++----------
>  arch/arm64/crypto/aes-ce-cipher.c   | 25 +++++----
>  arch/arm64/crypto/aes-ce.S          |  1 +
>  arch/arm64/crypto/aes-modes.S       |  3 +-
>  arch/arm64/crypto/aes-neon.S        | 25 +++++----
>  arch/arm64/crypto/ghash-ce-core.S   |  6 +--
>  arch/arm64/crypto/sha1-ce-core.S    |  4 +-
>  arch/arm64/crypto/sha2-ce-core.S    |  4 +-
>  9 files changed, 72 insertions(+), 54 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
