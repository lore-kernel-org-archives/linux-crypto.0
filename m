Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E960BC43215
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 04:58:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5A7F2245F
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 04:58:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727428AbfKTE6f (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Nov 2019 23:58:35 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:39724 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727395AbfKTE6f (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Nov 2019 23:58:35 -0500
X-Greylist: delayed 496 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Nov 2019 23:58:35 EST
Received: from tarshish (unknown [10.0.8.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id EB6BA440428;
        Wed, 20 Nov 2019 06:50:16 +0200 (IST)
References: <20191120031622.88949-1-stephen@brennan.io> <20191120031622.88949-2-stephen@brennan.io>
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
        Eric Anholt <eric@anholt.net>,
        Rob Herring <robh+dt@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com,
        Stefan Wahren <wahrenst@gmx.net>,
        Matt Mackall <mpm@selenic.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3 1/4] dt-bindings: rng: add BCM2711 RNG compatible
In-reply-to: <20191120031622.88949-2-stephen@brennan.io>
Date:   Wed, 20 Nov 2019 06:50:16 +0200
Message-ID: <87ftijgnhz.fsf@tarshish>
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
> The BCM2711 has a RNG200 block, so document its compatible string.
>
> Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
> Signed-off-by: Stephen Brennan <stephen@brennan.io>

Isn't that duplicate of Florian's commit 6223949a1531?

> ---
>  Documentation/devicetree/bindings/rng/brcm,iproc-rng200.txt | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/Documentation/devicetree/bindings/rng/brcm,iproc-rng200.txt b/Documentation/devicetree/bindings/rng/brcm,iproc-rng200.txt
> index c223e54452da..802523196ee5 100644
> --- a/Documentation/devicetree/bindings/rng/brcm,iproc-rng200.txt
> +++ b/Documentation/devicetree/bindings/rng/brcm,iproc-rng200.txt
> @@ -2,6 +2,7 @@ HWRNG support for the iproc-rng200 driver
>  
>  Required properties:
>  - compatible : Must be one of:
> +	       "brcm,bcm2711-rng200"
>  	       "brcm,bcm7211-rng200"

Isn't this clear text duplication? Am I missing something obvious?

I was looking at versions of this patch series wondering why no one
noticed that.

baruch

>  	       "brcm,bcm7278-rng200"
>  	       "brcm,iproc-rng200"

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
