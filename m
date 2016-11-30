From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/4] crypto: arm/aes-ce: fix broken monolithic build
Date: Wed, 30 Nov 2016 21:18:28 +0800
Message-ID: <20161130131827.GB4126@gondor.apana.org.au>
References: <1480424733-10797-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33367 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752786AbcK3NSf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Nov 2016 08:18:35 -0500
Content-Disposition: inline
In-Reply-To: <1480424733-10797-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 29, 2016 at 01:05:30PM +0000, Ard Biesheuvel wrote:
> When building the arm64 kernel with both CONFIG_CRYPTO_AES_ARM64_CE_BLK=y
> and CONFIG_CRYPTO_AES_ARM64_NEON_BLK=y configured, the build breaks with
> the following error:
> 
> arch/arm64/crypto/aes-neon-blk.o:(.bss+0x0): multiple definition of `aes_simd_algs'
> arch/arm64/crypto/aes-ce-blk.o:(.bss+0x0): first defined here
> 
> Fix this by making aes_simd_algs 'static'.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Patches 1,2 and 4 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
