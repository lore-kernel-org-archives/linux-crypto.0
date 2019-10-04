Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2A23C4360C
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 16:04:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B777222C9
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 16:04:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389131AbfJDQEb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 12:04:31 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:42710 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390091AbfJDQEb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 12:04:31 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1iGPhH-0001FJ-3M; Sat, 05 Oct 2019 01:40:48 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 05 Oct 2019 01:40:41 +1000
Date:   Sat, 5 Oct 2019 01:40:41 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tony Lindgren <tony@atomide.com>
Cc:     Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-crypto@vger.kernel.org,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Adam Ford <aford173@gmail.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Tero Kristo <t-kristo@ti.com>, devicetree@vger.kernel.org
Subject: Re: [PATCHv2 0/7] Non-urgent fixes and improvments for omap3-rom-rng
Message-ID: <20191004154041.GL5148@gondor.apana.org.au>
References: <20190914210300.15836-1-tony@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190914210300.15836-1-tony@atomide.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Sep 14, 2019 at 02:02:53PM -0700, Tony Lindgren wrote:
> Hi all,
> 
> Here are fixes and improvments for omap3-rom-rng that's been broken for
> a while.
> 
> The first four patches get it working, and then the last two patches add
> support for runtime PM.
> 
> I did not add Sebastian's acks from v1 set as many of the patches
> changed. Please review again :)
> 
> Regards,
> 
> Tony
> 
> Changes since v1:
> - Use clk_prepare_enable() as pointed out by Sebastian
> - Simplify runtime PM changes patch
> - Add a new patch for devm changes as suggested by Sebastian
> 
> 
> Tony Lindgren (7):
>   ARM: OMAP2+: Check omap3-rom-rng for GP device instead of HS device
>   hwrng: omap3-rom - Fix missing clock by probing with device tree
>   hwrng: omap3-rom - Call clk_disable_unprepare() on exit only if not
>     idled
>   hwrng: omap3-rom - Initialize default quality to get data
>   hwrng: omap3-rom - Update to use standard driver data
>   hwrng: omap3-rom - Use runtime PM instead of custom functions
>   hwrng: omap3-rom - Use devm hwrng and runtime PM
> 
>  .../devicetree/bindings/rng/omap3_rom_rng.txt |  27 +++
>  arch/arm/boot/dts/omap3-n900.dts              |   6 +
>  arch/arm/mach-omap2/pdata-quirks.c            |  14 +-
>  drivers/char/hw_random/omap3-rom-rng.c        | 168 +++++++++++-------
>  4 files changed, 139 insertions(+), 76 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/rng/omap3_rom_rng.txt

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
