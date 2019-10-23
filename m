Return-Path: <SRS0=Ux5j=YQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53C8CCA9EB6
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 14:39:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33D3C2173B
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 14:39:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392216AbfJWOjl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Oct 2019 10:39:41 -0400
Received: from muru.com ([72.249.23.125]:39286 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389921AbfJWOjl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Oct 2019 10:39:41 -0400
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id B4C7480CF;
        Wed, 23 Oct 2019 14:40:14 +0000 (UTC)
Date:   Wed, 23 Oct 2019 07:39:36 -0700
From:   Tony Lindgren <tony@atomide.com>
To:     Sebastian Reichel <sre@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Adam Ford <aford173@gmail.com>,
        Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>,
        Tero Kristo <t-kristo@ti.com>, Rob Herring <robh@kernel.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: omap3-rom - Fix unused function warnings
Message-ID: <20191023143936.GH5610@atomide.com>
References: <20191022142741.1794378-1-arnd@arndb.de>
 <20191023131452.2rilepif7x5lpfma@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023131452.2rilepif7x5lpfma@earth.universe>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

* Sebastian Reichel <sre@kernel.org> [191023 13:15]:
> Hi,
> 
> On Tue, Oct 22, 2019 at 04:27:31PM +0200, Arnd Bergmann wrote:
> > When runtime-pm is disabled, we get a few harmless warnings:
> > 
> > drivers/char/hw_random/omap3-rom-rng.c:65:12: error: unused function 'omap_rom_rng_runtime_suspend' [-Werror,-Wunused-function]
> > drivers/char/hw_random/omap3-rom-rng.c:81:12: error: unused function 'omap_rom_rng_runtime_resume' [-Werror,-Wunused-function]
> > 
> > Mark these functions as __maybe_unused so gcc can drop them
> > silently.
> > 
> > Fixes: 8d9d4bdc495f ("hwrng: omap3-rom - Use runtime PM instead of custom functions")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> 
> Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>

Thanks for fixing these similar issues again:

Reviewwed-by: Tony Lindgren <tony@atomide.com>
