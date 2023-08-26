Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A86CCC83F11
	for <linux-crypto@archiver.kernel.org>; Sat, 26 Aug 2023 15:49:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbjHZPtP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 26 Aug 2023 11:49:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbjHZPsq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 26 Aug 2023 11:48:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 501C91BCD
        for <linux-crypto@vger.kernel.org>; Sat, 26 Aug 2023 08:48:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D910761480
        for <linux-crypto@vger.kernel.org>; Sat, 26 Aug 2023 15:48:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C558C433C8;
        Sat, 26 Aug 2023 15:48:40 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="KpHpU7LL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1693064917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OZ8Ie87RIFTn6WUDoZfAiyIGzThKEyDxGHtS6DLKwg0=;
        b=KpHpU7LL7YQhBJSGctzk+yOeLMow33RuVgs1WFsTAfyK79WEiPKlJJedZV9AWN7R4ApWlQ
        HB+E1LgjmEpxEnSHbayUjgkkiDDAYJS0BwMhwy5otNxqfdSQPD+PV+yqF5DqH3HsLViL5V
        /JqMDKWZ6lUrnem+YdlPKajO1txUAws=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id c17e7942 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sat, 26 Aug 2023 15:48:36 +0000 (UTC)
Date:   Sat, 26 Aug 2023 17:48:34 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Stefan Wahren <wahrenst@gmx.net>
Cc:     Olivia Mackall <olivia@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Florian Fainelli <florian.fainelli@broadcom.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Mark Brown <broonie@kernel.org>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com
Subject: Re: [PATCH] hwrng: bcm2835: Fix hwrng throughput regression
Message-ID: <ZOoe0lOR9zpcAw5I@zx2c4.com>
References: <20230826112828.58046-1-wahrenst@gmx.net>
 <ZOnxaXtXeL1FFyIj@zx2c4.com>
 <56b5000c-89d9-865e-035c-5baf730a5304@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <56b5000c-89d9-865e-035c-5baf730a5304@gmx.net>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Aug 26, 2023 at 04:01:58PM +0200, Stefan Wahren wrote:
> Hi Jason,
> 
> Am 26.08.23 um 14:34 schrieb Jason A. Donenfeld:
> > On Sat, Aug 26, 2023 at 01:28:28PM +0200, Stefan Wahren wrote:
> >> The recent RCU stall fix caused a massive throughput regression of the
> >> hwrng on Raspberry Pi 0 - 3. So try to restore a similiar throughput
> >> as before the RCU stall fix.
> >>
> >> Some performance measurements on Raspberry Pi 3B+ (arm64/defconfig):
> >>
> >> sudo dd if=/dev/hwrng of=/dev/null count=1 bs=10000
> >>
> >> cpu_relax              ~138025 Bytes / sec
> >> hwrng_msleep(1000)         ~13 Bytes / sec
> >> usleep_range(100,200)   ~92141 Bytes / sec
> >>
> >> Fixes: 96cb9d055445 ("hwrng: bcm2835 - use hwrng_msleep() instead of cpu_relax()")
> >> Link: https://lore.kernel.org/linux-arm-kernel/bc97ece5-44a3-4c4e-77da-2db3eb66b128@gmx.net/
> >> Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
> >> ---
> >>   drivers/char/hw_random/bcm2835-rng.c | 3 ++-
> >>   1 file changed, 2 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
> >> index e98fcac578d6..3f1b6aaa98ee 100644
> >> --- a/drivers/char/hw_random/bcm2835-rng.c
> >> +++ b/drivers/char/hw_random/bcm2835-rng.c
> >> @@ -14,6 +14,7 @@
> >>   #include <linux/printk.h>
> >>   #include <linux/clk.h>
> >>   #include <linux/reset.h>
> >> +#include <linux/delay.h>
> >>
> >>   #define RNG_CTRL	0x0
> >>   #define RNG_STATUS	0x4
> >> @@ -71,7 +72,7 @@ static int bcm2835_rng_read(struct hwrng *rng, void *buf, size_t max,
> >>   	while ((rng_readl(priv, RNG_STATUS) >> 24) == 0) {
> >>   		if (!wait)
> >>   			return 0;
> >> -		hwrng_msleep(rng, 1000);
> >> +		usleep_range(100, 200);
> >
> > I think we still need to use the hwrng_msleep function so that the sleep
> > remains cancelable. Maybe just change the 1000 to 100?
> i found that other hwrng driver like iproc-rng200 (Raspberry Pi 4) also
> use usleep_range().
> 
> Nevertheless here are more numbers:
> 
> usleep_range(200,400) : 47776 bytes / sec
> hwrng_msleep(20) : 715 bytes / sec
> 
> Changing to 100 ms won't be a real gain.

I'm fine with whatever number you want there. Maybe we need a
hwrng_usleep_range() that takes into account rng->dying like
hwrng_msleep() does? (And iproc-rng200 should probably use that too?)

Jason
