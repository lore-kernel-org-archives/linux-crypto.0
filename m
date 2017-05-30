From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH v2 00/12] ARM: sun5i: cryptographic engine support
Date: Tue, 30 May 2017 13:52:06 +0200
Message-ID: <20170530115206.GB26229@Red>
References: <20170529202738.2167-1-antoine.tenart@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        maxime.ripard@free-electrons.com, wens@csie.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Antoine Tenart <antoine.tenart@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36556 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750992AbdE3LwJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 May 2017 07:52:09 -0400
Received: by mail-wm0-f67.google.com with SMTP id k15so24752971wmh.3
        for <linux-crypto@vger.kernel.org>; Tue, 30 May 2017 04:52:09 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170529202738.2167-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 29, 2017 at 10:27:26PM +0200, Antoine Tenart wrote:
> Hello,
> 
> This series adds the cryptographic engine support to sun5i SoCs. This is
> based on top of v4.12-rc1 and was tested on a CHIP. The series begins
> with fixes and improvements. The series is available at:
> https://github.com/atenart/linux v4.12-rc1/sun5i-crypto
> 
> The 8 first patches are reworks and cosmetic improvements.
> 
> Patch 9 moves the cipher part of the sun4i-ss driver from the ablkcipher
> API to the newer skcipher API.
> 
> Patch 10 adds the CRYPTO_ALG_KERN_DRIVER_ONLY flag for ciphers exposed
> by the sun4i-ss driver.
> 
> Patch 11 fixes the crypto framework selftests on the CHIP. It might fix
> other users too.
> 
> Patch 12 adds a cryptographic engine node for sun5i SoCs.
> 
> Thanks,
> Antoine
> 
> Since v1:
>   - Fixed a typo.
>   - Made the CRYPTO_ALG_KERN_DRIVER_ONLY flag addition in a dedicated
>     patch.
> 
> Antoine Tenart (12):
>   crypto: sun4i-ss: group variable definitions in sun4i_hash()
>   crypto: sun4i-ss: remove conditional checks against 0
>   crypto: sun4i-ss: use lower/upper_32_bits helpers
>   crypto: sun4i-ss: cannot use DMA is the request is 0 length
>   crypto: sun4i-ss: do not dynamically set parts of the last buffer to 0
>   crypto: sun4i-ss: simplify the pad length calculation
>   crypto: sun4i-ss: simplify the appended bit assignment
>   crypto: sun4i-ss: use GENMASK to generate masks
>   crypto: sun4i-ss: move from ablkcipher to skcipher API
>   crypto: sun4i-ss: add the CRYPTO_ALG_KERN_DRIVER_ONLY flag
>   crypto: sun4i-ss: fix large block size support
>   ARM: sun5i: add a cryptographic engine node
> 
>  arch/arm/boot/dts/sun5i.dtsi              |   8 +
>  drivers/crypto/sunxi-ss/sun4i-ss-cipher.c | 213 ++++++++++++++-------------
>  drivers/crypto/sunxi-ss/sun4i-ss-core.c   | 237 +++++++++++++++---------------
>  drivers/crypto/sunxi-ss/sun4i-ss-hash.c   | 138 ++++++++---------
>  drivers/crypto/sunxi-ss/sun4i-ss.h        |  34 +++--
>  5 files changed, 321 insertions(+), 309 deletions(-)
> 

Hello

Thanks for the work

For the whole serie:
Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>
