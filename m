Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 130C6C43215
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 05:03:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E258722466
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 05:03:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725832AbfKTFDg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Nov 2019 00:03:36 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:39726 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbfKTFDg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Nov 2019 00:03:36 -0500
Received: from tarshish (unknown [10.0.8.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 0C5144407C6;
        Wed, 20 Nov 2019 06:52:48 +0200 (IST)
References: <20191120031622.88949-1-stephen@brennan.io> <20191120031622.88949-3-stephen@brennan.io>
User-agent: mu4e 1.2.0; emacs 26.1
From:   Baruch Siach <baruch@tkos.co.il>
To:     Stephen Brennan <stephen@brennan.io>,
        linux-arm-kernel@lists.infradead.org
Cc:     stephen@brennan.io, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Scott Branden <sbranden@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ray Jui <rjui@broadcom.com>, linux-kernel@vger.kernel.org,
        Matthias Brugger <mbrugger@suse.com>,
        Eric Anholt <eric@anholt.net>,
        Rob Herring <robh+dt@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com,
        Stefan Wahren <wahrenst@gmx.net>,
        Matt Mackall <mpm@selenic.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3 2/4] hwrng: iproc-rng200: Add support for BCM2711
In-reply-to: <20191120031622.88949-3-stephen@brennan.io>
Date:   Wed, 20 Nov 2019 06:52:47 +0200
Message-ID: <87eey3gnds.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Stephen, Stefan,

On Wed, Nov 20 2019, Stephen Brennan wrote:
> From: Stefan Wahren <wahrenst@gmx.net>
>
> BCM2711 features a RNG200 hardware random number generator block.
> So make the driver available.
>
> Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
> Signed-off-by: Stephen Brennan <stephen@brennan.io>
> Reviewed-by: Matthias Brugger <mbrugger@suse.com>
> ---
>  drivers/char/hw_random/Kconfig        | 2 +-
>  drivers/char/hw_random/iproc-rng200.c | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
> index 7c7fecfa2fb2..77e848fca531 100644
> --- a/drivers/char/hw_random/Kconfig
> +++ b/drivers/char/hw_random/Kconfig
> @@ -90,7 +90,7 @@ config HW_RANDOM_BCM2835
>  
>  config HW_RANDOM_IPROC_RNG200
>  	tristate "Broadcom iProc/STB RNG200 support"
> -	depends on ARCH_BCM_IPROC || ARCH_BRCMSTB
> +	depends on ARCH_BCM_IPROC || ARCH_BCM2835 || ARCH_BRCMSTB
>  	default HW_RANDOM
>  	---help---
>  	  This driver provides kernel-side support for the RNG200
> diff --git a/drivers/char/hw_random/iproc-rng200.c b/drivers/char/hw_random/iproc-rng200.c
> index 899ff25f4f28..32d9fe61a225 100644
> --- a/drivers/char/hw_random/iproc-rng200.c
> +++ b/drivers/char/hw_random/iproc-rng200.c
> @@ -213,6 +213,7 @@ static int iproc_rng200_probe(struct platform_device *pdev)
>  }
>  
>  static const struct of_device_id iproc_rng200_of_match[] = {
> +	{ .compatible = "brcm,bcm2711-rng200", },
>  	{ .compatible = "brcm,bcm7211-rng200", },

Again, duplicate of commit 1fa6d053b2a5.

>  	{ .compatible = "brcm,bcm7278-rng200", },
>  	{ .compatible = "brcm,iproc-rng200", },

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
