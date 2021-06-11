Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C2AFC48BE0
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jun 2021 07:18:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26E54613AD
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jun 2021 07:18:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbhFKHUO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Jun 2021 03:20:14 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:50550 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230288AbhFKHUO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Jun 2021 03:20:14 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1lrbQX-0005A7-Ly; Fri, 11 Jun 2021 15:18:01 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1lrbQ6-0002Kj-2m; Fri, 11 Jun 2021 15:17:34 +0800
Date:   Fri, 11 Jun 2021 15:17:34 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     davem@davemloft.net, linus.walleij@linaro.org,
        linux@armlinux.org.uk, robh+dt@kernel.org,
        ulli.kroll@googlemail.com, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] crypto: add gemini/sl3516 crypto driver
Message-ID: <20210611071733.GC23016@gondor.apana.org.au>
References: <20210601151132.1893443-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210601151132.1893443-1-clabbe@baylibre.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 01, 2021 at 03:11:27PM +0000, Corentin Labbe wrote:
> The gemini SL3516 SoC has a crypto IP.
> This serie had support for it.
> 
> It was tested with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y.
> Furthermore, it survives hours and gigs of write/read to a luks2 using xts(ecb-aes-sl3516).
> 
> Performance is quite good.
> On a luks2 partition (2To with bs=4096), a fsck comes from 14m26(without CE) to 8m48(with CE).
> So it is really usefull.
> 
> With bs=512, the performance is similar with software.
> 
> Changes since v1:
> - reworded dt-binding subject patch
> - fixed build with CRYPTO_DEV_SL3516_DEBUG
> 
> Corentin Labbe (5):
>   dt-bindings: crypto: Add documentation for sl3516-ce
>   crypto: Add sl3516 crypto engine
>   ARM: dts: gemini: add crypto node
>   ARM: gemini_config: enable sl3516-ce crypto
>   MAINTAINERS: add gemini crypto sl3516-ce
> 
>  .../crypto/cortina,sl3516-crypto.yaml         |  50 ++
>  MAINTAINERS                                   |   7 +
>  arch/arm/boot/dts/gemini.dtsi                 |   8 +
>  arch/arm/configs/gemini_defconfig             |   1 +
>  drivers/crypto/Kconfig                        |  19 +
>  drivers/crypto/Makefile                       |   1 +
>  drivers/crypto/gemini/Makefile                |   2 +
>  drivers/crypto/gemini/sl3516-ce-cipher.c      | 388 +++++++++++++
>  drivers/crypto/gemini/sl3516-ce-core.c        | 535 ++++++++++++++++++
>  drivers/crypto/gemini/sl3516-ce-rng.c         |  61 ++
>  drivers/crypto/gemini/sl3516-ce.h             | 347 ++++++++++++
>  11 files changed, 1419 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/cortina,sl3516-crypto.yaml
>  create mode 100644 drivers/crypto/gemini/Makefile
>  create mode 100644 drivers/crypto/gemini/sl3516-ce-cipher.c
>  create mode 100644 drivers/crypto/gemini/sl3516-ce-core.c
>  create mode 100644 drivers/crypto/gemini/sl3516-ce-rng.c
>  create mode 100644 drivers/crypto/gemini/sl3516-ce.h

Patches 1,2,5 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
