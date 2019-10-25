Return-Path: <SRS0=9dQ/=YS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19491CA9EA0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 15:21:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E80B921D7B
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 15:21:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440642AbfJYPVC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Oct 2019 11:21:02 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:35806 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440561AbfJYPVC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Oct 2019 11:21:02 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iO1OE-0001hu-6D; Fri, 25 Oct 2019 23:20:34 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iO1O5-0007pN-BO; Fri, 25 Oct 2019 23:20:25 +0800
Date:   Fri, 25 Oct 2019 23:20:25 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     mpm@selenic.com, arnd@arndb.de, gregkh@linuxfoundation.org,
        nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
        ludovic.desroches@microchip.com, f.fainelli@gmail.com,
        rjui@broadcom.com, sbranden@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, eric@anholt.net,
        wahrenst@gmx.net, l.stelmach@samsung.com, kgene@kernel.org,
        krzk@kernel.org, khilman@baylibre.com, dsaxena@plexity.net,
        patrice.chotard@st.com, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        linux-amlogic@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH -next 00/13] hwrng: use devm_platform_ioremap_resource()
 to simplify code
Message-ID: <20191025152025.qudqaupecsgwkn32@gondor.apana.org.au>
References: <20191016104621.26056-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016104621.26056-1-yuehaibing@huawei.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 16, 2019 at 06:46:08PM +0800, YueHaibing wrote:
> devm_platform_ioremap_resource() internally have platform_get_resource()
> and devm_ioremap_resource() in it. So instead of calling them separately
> use devm_platform_ioremap_resource() directly.
> 
> YueHaibing (13):
>   hwrng: atmel - use devm_platform_ioremap_resource() to simplify code
>   hwrng: bcm2835 - use devm_platform_ioremap_resource() to simplify code
>   hwrng: exynos - use devm_platform_ioremap_resource() to simplify code
>   hwrng: hisi - use devm_platform_ioremap_resource() to simplify code
>   hwrng: ks-sa - use devm_platform_ioremap_resource() to simplify code
>   hwrng: meson - use devm_platform_ioremap_resource() to simplify code
>   hwrng: npcm - use devm_platform_ioremap_resource() to simplify code
>   hwrng: omap - use devm_platform_ioremap_resource() to simplify code
>   hwrng: pasemi - use devm_platform_ioremap_resource() to simplify code
>   hwrng: pic32 - use devm_platform_ioremap_resource() to simplify code
>   hwrng: st - use devm_platform_ioremap_resource() to simplify code
>   hwrng: tx4939 - use devm_platform_ioremap_resource() to simplify code
>   hwrng: xgene - use devm_platform_ioremap_resource() to simplify code
> 
>  drivers/char/hw_random/atmel-rng.c   | 4 +---
>  drivers/char/hw_random/bcm2835-rng.c | 5 +----
>  drivers/char/hw_random/exynos-trng.c | 4 +---
>  drivers/char/hw_random/hisi-rng.c    | 4 +---
>  drivers/char/hw_random/ks-sa-rng.c   | 4 +---
>  drivers/char/hw_random/meson-rng.c   | 4 +---
>  drivers/char/hw_random/npcm-rng.c    | 4 +---
>  drivers/char/hw_random/omap-rng.c    | 4 +---
>  drivers/char/hw_random/pasemi-rng.c  | 4 +---
>  drivers/char/hw_random/pic32-rng.c   | 4 +---
>  drivers/char/hw_random/st-rng.c      | 4 +---
>  drivers/char/hw_random/tx4939-rng.c  | 4 +---
>  drivers/char/hw_random/xgene-rng.c   | 4 +---
>  13 files changed, 13 insertions(+), 40 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
