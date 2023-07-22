Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28F4CC41513
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jul 2023 02:15:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbjGVCPb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Jul 2023 22:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjGVCPa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jul 2023 22:15:30 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B3D130EF;
        Fri, 21 Jul 2023 19:15:29 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qN29F-002D8G-RF; Sat, 22 Jul 2023 12:15:11 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 22 Jul 2023 14:15:03 +1200
Date:   Sat, 22 Jul 2023 14:15:03 +1200
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Thomas BOURGOIN <thomas.bourgoin@foss.st.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Lionel Debieve <lionel.debieve@foss.st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/7] Support of HASH on STM32MP13
Message-ID: <ZLs7p2FiGBtgji5i@gondor.apana.org.au>
References: <20230713151518.1513949-1-thomas.bourgoin@foss.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230713151518.1513949-1-thomas.bourgoin@foss.st.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 13, 2023 at 05:15:11PM +0200, Thomas BOURGOIN wrote:
> From: Thomas Bourgoin <thomas.bourgoin@foss.st.com>
> 
> The STM32MP13 platform introduces a new version of the IP HASH.
> This version of the IP support SHA1, SHA2, SHA3 algorithms and HMAC.
> This serie also add some fixes when using the DMA to feed data to the IP.
> 
> 1. Add new YAML compatible st,stm32mp13-hash.
> 
> 2. Update driver to support SHA2, SHA3 algorithms for the compatible
> st,stm32mp13-hash.
> 
> 3. Argument bufcnt is unused in function stm32_hash_write_ctrl. Removes it
> to simplify the declaration of the function.
> 
> 4-7. DMA fixes
> 
> Changes in v2:
>  - Add SoB in dt-bindings: crypto: add new compatible for stm32-hash
> 
>  - Fix regression in crypto: stm32 - add new algorithms support
>    The macro HASH_CSR_NB_SHA256 was equal to 22 change to 38.
> 
>  - Update commit message of crypto: stm32 - fix MDMAT condition
>        Cc: stable@vger.kernel.org and
>        Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Lionel Debieve (1):
>   dt-bindings: crypto: add new compatible for stm32-hash
> 
> Thomas Bourgoin (6):
>   crypto: stm32 - add new algorithms support
>   crypto: stm32 - remove bufcnt in stm32_hash_write_ctrl.
>   crypto: stm32 - fix loop iterating through scatterlist for DMA
>   crypto: stm32 - check request size and scatterlist size when using
>     DMA.
>   crypto: stm32 - fix MDMAT condition
>   crypto: stm32 - remove flag HASH_FLAGS_DMA_READY
> 
>  .../bindings/crypto/st,stm32-hash.yaml        |   1 +
>  drivers/crypto/stm32/Kconfig                  |   2 +
>  drivers/crypto/stm32/stm32-hash.c             | 710 ++++++++++++++----
>  3 files changed, 566 insertions(+), 147 deletions(-)
> 
> -- 
> 2.25.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
