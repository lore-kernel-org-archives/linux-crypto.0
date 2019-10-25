Return-Path: <SRS0=9dQ/=YS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DDF3CA9EA0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 15:25:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F138A21D7F
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 15:25:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439061AbfJYPZE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Oct 2019 11:25:04 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:36016 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731226AbfJYPZE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Oct 2019 11:25:04 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iO1SQ-0001q4-Ix; Fri, 25 Oct 2019 23:24:54 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iO1SK-0007sB-Ir; Fri, 25 Oct 2019 23:24:48 +0800
Date:   Fri, 25 Oct 2019 23:24:48 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     davem@davemloft.net, khilman@baylibre.com, mark.rutland@arm.com,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] crypto: add amlogic crypto offloader driver
Message-ID: <20191025152448.y3d45bt22gaavede@gondor.apana.org.au>
References: <1571288786-34601-1-git-send-email-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571288786-34601-1-git-send-email-clabbe@baylibre.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Oct 17, 2019 at 05:06:22AM +0000, Corentin Labbe wrote:
> Hello
> 
> This serie adds support for the crypto offloader present on amlogic GXL
> SoCs.
> 
> Tested on meson-gxl-s905x-khadas-vim and meson-gxl-s905x-libretech-cc
> 
> Regards
> 
> Changes since v2:
> - fixed some spelling in kconfig
> - Use devm_platform_ioremap_resource
> 
> Changes since v1:
> - renamed files and algo with gxl
> - removed unused reset handlings
> - splited the probe functions
> - splited meson_cipher fallback in need_fallback() and do_fallback()
> 
> 
> Corentin Labbe (4):
>   dt-bindings: crypto: Add DT bindings documentation for amlogic-crypto
>   MAINTAINERS: Add myself as maintainer of amlogic crypto
>   crypto: amlogic: Add crypto accelerator for amlogic GXL
>   ARM64: dts: amlogic: adds crypto hardware node
> 
>  .../bindings/crypto/amlogic,gxl-crypto.yaml   |  52 +++
>  MAINTAINERS                                   |   7 +
>  arch/arm64/boot/dts/amlogic/meson-gxl.dtsi    |  10 +
>  drivers/crypto/Kconfig                        |   2 +
>  drivers/crypto/Makefile                       |   1 +
>  drivers/crypto/amlogic/Kconfig                |  24 ++
>  drivers/crypto/amlogic/Makefile               |   2 +
>  drivers/crypto/amlogic/amlogic-gxl-cipher.c   | 381 ++++++++++++++++++
>  drivers/crypto/amlogic/amlogic-gxl-core.c     | 331 +++++++++++++++
>  drivers/crypto/amlogic/amlogic-gxl.h          | 170 ++++++++
>  10 files changed, 980 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
>  create mode 100644 drivers/crypto/amlogic/Kconfig
>  create mode 100644 drivers/crypto/amlogic/Makefile
>  create mode 100644 drivers/crypto/amlogic/amlogic-gxl-cipher.c
>  create mode 100644 drivers/crypto/amlogic/amlogic-gxl-core.c
>  create mode 100644 drivers/crypto/amlogic/amlogic-gxl.h

Patches 1-3 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
