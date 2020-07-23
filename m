Return-Path: <SRS0=6JMd=BC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA55FC433F2
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jul 2020 07:58:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA92122D01
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jul 2020 07:58:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgGWH6t (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Jul 2020 03:58:49 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:34792 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727769AbgGWH6t (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Jul 2020 03:58:49 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jyW6o-0005xk-9A; Thu, 23 Jul 2020 17:57:43 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 23 Jul 2020 17:57:42 +1000
Date:   Thu, 23 Jul 2020 17:57:42 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Matt Mackall <mpm@selenic.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Martin Kaiser <martin@kaiser.cx>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/5] hwrng: add support for i.MX6 rngb
Message-ID: <20200723075742.GD14246@gondor.apana.org.au>
References: <20200715152604.10407-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200715152604.10407-1-horia.geanta@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 15, 2020 at 06:25:59PM +0300, Horia Geantă wrote:
> Add support for RNGB found in some i.MX6 SoCs (6SL, 6SLL, 6ULL, 6ULZ),
> based on RNGC driver (drivers/char/hw_random/imx-rngc.c).
> 
> This driver claims support also for RNGB (besides RNGC),
> and is currently used only by i.MX25.
> 
> Note:
> 
> Several NXP SoC from QorIQ family (P1010, P1023, P4080, P3041, P5020)
> also have a RNGB, however it's part of the CAAM
> (Cryptograhic Accelerator and Assurance Module) crypto accelerator.
> In this case, RNGB is managed in the caam driver
> (drivers/crypto/caam/), since it's tightly related to
> the caam "job ring" interface, not to mention CAAM internally relying on
> RNGB as source of randomness.
> 
> On the other hand, the i.MX6 SoCs with RNGB have a DCP
> (Data Co-Processor) crypto accelerator and this block and RNGB
> are independent.
> 
> Changelog:
> v4
> -remove unneeded compatible strings from the driver
> v3
> -mention in the DT binding the compatibility with "fsl,imx25-rngb"
> -collected Reviewed-by
> v2
> -update rngb DT binding with compatible strings for i.MX6 SoCs
> 
> Horia Geantă (5):
>   dt-bindings: rng: add RNGB compatibles for i.MX6 SoCs
>   ARM: dts: imx6sl: fix rng node
>   ARM: dts: imx6sll: add rng
>   ARM: dts: imx6ull: add rng
>   hwrng: imx-rngc: enable driver for i.MX6
> 
>  Documentation/devicetree/bindings/rng/imx-rng.txt | 3 +++
>  arch/arm/boot/dts/imx6sl.dtsi                     | 2 ++
>  arch/arm/boot/dts/imx6sll.dtsi                    | 7 +++++++
>  arch/arm/boot/dts/imx6ull.dtsi                    | 7 +++++++
>  drivers/char/hw_random/Kconfig                    | 2 +-
>  5 files changed, 20 insertions(+), 1 deletion(-)

Patches 1 and 5 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
