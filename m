Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57281E748E9
	for <linux-crypto@archiver.kernel.org>; Sun,  1 Oct 2023 08:34:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234601AbjJAIeC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 1 Oct 2023 04:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234603AbjJAId7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 1 Oct 2023 04:33:59 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36644C6;
        Sun,  1 Oct 2023 01:33:56 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qmrtL-002PUo-Ba; Sun, 01 Oct 2023 16:33:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 01 Oct 2023 16:33:35 +0800
Date:   Sun, 1 Oct 2023 16:33:35 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Gatien Chevallier <gatien.chevallier@foss.st.com>
Cc:     Olivia Mackall <olivia@selenic.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Lionel Debieve <lionel.debieve@foss.st.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/9] hwrng: stm32: support STM32MP13x platforms
Message-ID: <ZRku36epapNNQP3b@gondor.apana.org.au>
References: <20230921080301.253563-1-gatien.chevallier@foss.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921080301.253563-1-gatien.chevallier@foss.st.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 21, 2023 at 10:02:52AM +0200, Gatien Chevallier wrote:
> The STM32MP13x platforms have a RNG hardware block that supports
> customization, a conditional reset sequences that allows to
> recover from certain situations and a configuration locking
> mechanism.
> 
> This series adds support for the mentionned features. Note that
> the hardware RNG can and should be managed in the secure world
> for this platform, hence the rng not being default enabled on
> the STM32MP135F-DK board.
> 
> Changes in V2:
> 	- Use pm_ptr() and add __maybe_unused on PM API
> 	- Correct bug using WARN_ON
> 
> Changes in V3:
> 	- Squash of bindings patches
> 	- st,rng-lock-conf property declaration rework
> 	- Fix stm32_rng_pm_ops declaration in patch [5/9]
> 
> Gatien Chevallier (9):
>   dt-bindings: rng: introduce new compatible for STM32MP13x
>   hwrng: stm32 - use devm_platform_get_and_ioremap_resource() API
>   hwrng: stm32 - implement STM32MP13x support
>   hwrng: stm32 - implement error concealment
>   hwrng: stm32 - rework error handling in stm32_rng_read()
>   hwrng: stm32 - restrain RNG noise source clock
>   hwrng: stm32 - support RNG configuration locking mechanism
>   hwrng: stm32 - rework power management sequences
>   ARM: dts: stm32: add RNG node for STM32MP13x platforms
> 
>  .../devicetree/bindings/rng/st,stm32-rng.yaml |  20 +-
>  arch/arm/boot/dts/st/stm32mp131.dtsi          |   8 +
>  drivers/char/hw_random/stm32-rng.c            | 511 +++++++++++++++---
>  3 files changed, 455 insertions(+), 84 deletions(-)
> 
> -- 
> 2.25.1

Patches 1-8 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
