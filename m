Return-Path: <SRS0=Eks8=4F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDC41C35254
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Feb 2020 09:35:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D05620679
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Feb 2020 09:35:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728743AbgBQJf4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Feb 2020 04:35:56 -0500
Received: from viti.kaiser.cx ([85.214.81.225]:53246 "EHLO viti.kaiser.cx"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728302AbgBQJf4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Feb 2020 04:35:56 -0500
Received: from martin by viti.kaiser.cx with local (Exim 4.89)
        (envelope-from <martin@viti.kaiser.cx>)
        id 1j3cod-0001mS-3d; Mon, 17 Feb 2020 10:35:47 +0100
Date:   Mon, 17 Feb 2020 10:35:47 +0100
From:   Martin Kaiser <martin@kaiser.cx>
To:     PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        NXP Linux Team <linux-imx@nxp.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] hwrng: imx-rngc - use devres for registration
Message-ID: <20200217093547.3an3bzqfutcewe2i@viti.kaiser.cx>
References: <20200128110102.11522-1-martin@kaiser.cx>
 <20200128110102.11522-4-martin@kaiser.cx>
 <CANc+2y6Scy1=S7zeQ4gVowRoWmzsq4wiNXbLVeY1Qvu0oo9cUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANc+2y6Scy1=S7zeQ4gVowRoWmzsq4wiNXbLVeY1Qvu0oo9cUw@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi PrasannaKumar,

Thus wrote PrasannaKumar Muralidharan (prasannatsmkumar@gmail.com):

> After imx_rngc_remove function hwrng_unregister will get called. This
> leaves a window where the clock to rng hardware block is disabled but
> still user space can access it via /dev/hwrng.

thanks for spotting this issue. I see that in __device_release_driver,
the driver's remove function is called before the devres cleanup.

> This does not look right, please revisit the patch.

I checked again how other hwrng drivers use devres. Some don't have to
disable a clock and need no remove function at all. Others enable the
clock in the hwrng init routine and disable it in the cleanup routine.

Both of these approaches don't work here. I should disable the clock
eventually and I need it in the probe function to run the selftest
before hwrng init is called.

Therefore, I suggest to drop this patch, at least for the moment.
Herbert, should I resend the series without this patch or is it ok for
you to take the remaining patches as-is?

BTW, 3e75241be808 ("hwrng: drivers - Use device-managed registration
API") makes the same change that I proposed here for a couple of other
hwrng drivers and seems to introduce the same race condition in som
drivers e.g. drivers/char/hw_random/exynos-trng.c. Should we try to fix
this?

Thanks,
Martin
