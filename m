From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 0/8] crypto: ARM/arm64 - big endian fixes
Date: Tue, 18 Oct 2016 12:49:32 +0100
Message-ID: <20161018114932.GG10115@e104818-lin.cambridge.arm.com>
References: <1476209720-21114-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        herbert@gondor.apana.org.au, will.deacon@arm.com,
        linux@arm.linux.org.uk
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:58344 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756892AbcJRLth (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Oct 2016 07:49:37 -0400
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
> fix is compatible with, not the patch that introduced the algorithm.

I think for future reference, the Fixes tag should denote the commit
that introduced the issue. An explicit Cc: stable tag would state how
far back it should be applied.

> Ard Biesheuvel (8):
>   crypto: arm64/aes-ce - fix for big endian
>   crypto: arm64/ghash-ce - fix for big endian
>   crypto: arm64/sha1-ce - fix for big endian
>   crypto: arm64/sha2-ce - fix for big endian
>   crypto: arm64/aes-ccm-ce: fix for big endian
>   crypto: arm64/aes-neon - fix for big endian
>   crypto: arm64/aes-xts-ce: fix for big endian
>   crypto: arm/aes-ce - fix for big endian

The changes look fine to me but I can't claim I fully understand these
algorithms. FWIW:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

(Will may pick them up for 4.9-rcX)
