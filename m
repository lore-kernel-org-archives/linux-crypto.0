Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62AB5C83F01
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Aug 2023 22:38:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbjH3Wiu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 30 Aug 2023 18:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234089AbjH3Wiu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Aug 2023 18:38:50 -0400
X-Greylist: delayed 379 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 30 Aug 2023 15:38:24 PDT
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D14ECC2
        for <linux-crypto@vger.kernel.org>; Wed, 30 Aug 2023 15:38:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EAE5FB81FEC
        for <linux-crypto@vger.kernel.org>; Wed, 30 Aug 2023 22:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46DE1C433CA;
        Wed, 30 Aug 2023 22:31:45 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="XWmAn+Hv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1693434701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fD8HpjKgj67OwMGnl/FHpuooQsZVw+irXhKFPMdVsAU=;
        b=XWmAn+HvERNmDlbFehkZo1Vh3fJ/CAISQ1COfhpmRkdHnhRWnhf1ZsX2X7vjZAvnIuhIZI
        gMeevOKN5sq1Qx5/XVNLkB1z6iTfE1kePrCBXzteeDlvN2w5pUF/lze4KhkKitFWAIdUPK
        b2ZwxKROoKQ6Ch2WEwv7F3Q7IJsGLGc=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b6aef0de (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 30 Aug 2023 22:31:40 +0000 (UTC)
Date:   Thu, 31 Aug 2023 00:31:36 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Stefan Wahren <wahrenst@gmx.net>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Olivia Mackall <olivia@selenic.com>,
        Florian Fainelli <florian.fainelli@broadcom.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Mark Brown <broonie@kernel.org>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Phil Elwell <phil@raspberrypi.com>
Subject: Re: [PATCH] hwrng: bcm2835: Fix hwrng throughput regression
Message-ID: <ZO_DSMVGtBle-2UR@zx2c4.com>
References: <20230826112828.58046-1-wahrenst@gmx.net>
 <ZOnxaXtXeL1FFyIj@zx2c4.com>
 <56b5000c-89d9-865e-035c-5baf730a5304@gmx.net>
 <ZOoe0lOR9zpcAw5I@zx2c4.com>
 <317b15be-3bae-5938-8c27-8a44f79b94d3@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <317b15be-3bae-5938-8c27-8a44f79b94d3@gmx.net>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Aug 30, 2023 at 08:05:39PM +0200, Stefan Wahren wrote:
> Hi Jason,
> 
> Am 26.08.23 um 17:48 schrieb Jason A. Donenfeld:
> > On Sat, Aug 26, 2023 at 04:01:58PM +0200, Stefan Wahren wrote:
> >> Hi Jason,
> >>
> >> Am 26.08.23 um 14:34 schrieb Jason A. Donenfeld:
> >>> On Sat, Aug 26, 2023 at 01:28:28PM +0200, Stefan Wahren wrote:
> >>>> The recent RCU stall fix caused a massive throughput regression of the
> >>>> hwrng on Raspberry Pi 0 - 3. So try to restore a similiar throughput
> >>>> as before the RCU stall fix.
> >>>>
> >>>> Some performance measurements on Raspberry Pi 3B+ (arm64/defconfig):
> >>>>
> >>>> sudo dd if=/dev/hwrng of=/dev/null count=1 bs=10000
> >>>>
> >>>> cpu_relax              ~138025 Bytes / sec
> >>>> hwrng_msleep(1000)         ~13 Bytes / sec
> >>>> usleep_range(100,200)   ~92141 Bytes / sec
> >>>>
> >>>> Fixes: 96cb9d055445 ("hwrng: bcm2835 - use hwrng_msleep() instead of cpu_relax()")
> >>>> Link: https://lore.kernel.org/linux-arm-kernel/bc97ece5-44a3-4c4e-77da-2db3eb66b128@gmx.net/
> >>>> Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
> >>>> ---
> >>>>    drivers/char/hw_random/bcm2835-rng.c | 3 ++-
> >>>>    1 file changed, 2 insertions(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
> >>>> index e98fcac578d6..3f1b6aaa98ee 100644
> >>>> --- a/drivers/char/hw_random/bcm2835-rng.c
> >>>> +++ b/drivers/char/hw_random/bcm2835-rng.c
> >>>> @@ -14,6 +14,7 @@
> >>>>    #include <linux/printk.h>
> >>>>    #include <linux/clk.h>
> >>>>    #include <linux/reset.h>
> >>>> +#include <linux/delay.h>
> >>>>
> >>>>    #define RNG_CTRL	0x0
> >>>>    #define RNG_STATUS	0x4
> >>>> @@ -71,7 +72,7 @@ static int bcm2835_rng_read(struct hwrng *rng, void *buf, size_t max,
> >>>>    	while ((rng_readl(priv, RNG_STATUS) >> 24) == 0) {
> >>>>    		if (!wait)
> >>>>    			return 0;
> >>>> -		hwrng_msleep(rng, 1000);
> >>>> +		usleep_range(100, 200);
> >>> I think we still need to use the hwrng_msleep function so that the sleep
> >>> remains cancelable. Maybe just change the 1000 to 100?
> >> i found that other hwrng driver like iproc-rng200 (Raspberry Pi 4) also
> >> use usleep_range().
> >>
> >> Nevertheless here are more numbers:
> >>
> >> usleep_range(200,400) : 47776 bytes / sec
> >> hwrng_msleep(20) : 715 bytes / sec
> >>
> >> Changing to 100 ms won't be a real gain.
> > I'm fine with whatever number you want there. Maybe we need a
> > hwrng_usleep_range() that takes into account rng->dying like
> > hwrng_msleep() does? (And iproc-rng200 should probably use that too?)
> the idea of this patch was to fix the performance regression in upcoming
> mainline and backport the fix to Linux 6.1 LTS. After that i'm fine with
> the introduction of hwrng_usleep_range().

No, you've got it backwards, but maybe it's a bit confusing why that is.

Originally, lots of drivers called variants of the msleep/usleep
functions. But this lead to some subtle bugs when the hwrng subsystem
was changing the active RNG or when the driver was unloading or during
suspend or a couple of other edge cases. In some cases, I believe there
were some interesting deadlocks. The solution to it was to make those
sleep calls cancellable with the &rng->dying completion, so those sleeps
could break, regardless of the time or the state of timekeeping on the
system. The &rng->dying thing was encapsulated in the hwrng_msleep()
function, and now it's a rule that any sleeps in hwrng drivers have got
to go through that.

Now, it sounds like you've come up with a case where hwrng_msleep(1) is
too long of a sleep for your purposes. In that case, indeed a usleep
variant might be called for. But in doing so, don't _reintroduce the
same bug we already fixed_. In other words, don't fix one regression by
adding another. Instead, follow the established pattern, and add a
hwrng_usleep_whatever() that waits on that same &rng->dying.

Jason
