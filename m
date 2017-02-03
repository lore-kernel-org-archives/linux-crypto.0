From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 00/10] crypto - AES for ARM/arm64 updates for v4.11
 (round #2)
Date: Fri, 3 Feb 2017 18:22:12 +0800
Message-ID: <20170203102212.GG2632@gondor.apana.org.au>
References: <1485645939-17126-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45033 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753003AbdBCKWp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Feb 2017 05:22:45 -0500
Content-Disposition: inline
In-Reply-To: <1485645939-17126-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Jan 28, 2017 at 11:25:29PM +0000, Ard Biesheuvel wrote:
> Patch #1 is a fix for the CBC chaining issue that was discussed on the
> mailing list. The driver itself is queued for v4.11, so this fix can go
> right on top.
> 
> Patches #2 - #6 clear the cra_alignmasks of various drivers: all NEON
> capable CPUs can perform unaligned accesses, and the advantage of using
> the slightly faster aligned accessors (which only exist on ARM not arm64)
> is certainly outweighed by the cost of copying data to suitably aligned
> buffers.
> 
> NOTE: patch #5 won't apply unless 'crypto: arm64/aes-blk - honour iv_out
> requirement in CBC and CTR modes' is applied first, which was sent out
> separately as a bugfix for v3.16 - v4.9. If this is a problem, this patch
> can wait.
> 
> Patch #7 and #8 are minor tweaks to the new scalar AES code.
> 
> Patch #9 improves the performance of the plain NEON AES code, to make it
> more suitable as a fallback for the new bitsliced NEON code, which can
> only operate on 8 blocks in parallel, and needs another driver to perform
> CBC encryption or XTS tweak generation.
> 
> Patch #10 updates the new bitsliced AES NEON code to switch to the plain
> NEON driver as a fallback.
> 
> Patches #9 and #10 improve the performance of CBC encryption by ~35% on
> low end cores such as the Cortex-A53 that can be found in the Raspberry Pi3
> 
> Changes since v2:
> - use polynomial multiply NEON instruction for multiplication by x^2, this
>   eliminates 4 instructions from the decrypt path (#9)
> 
> Changes since v1:
> - shave off another few cycles from the sequential AES NEON code (patch #9)

Patches 2-10 applied.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
