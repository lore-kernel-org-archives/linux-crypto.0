Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE6A8CCF9E9
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Sep 2023 23:48:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232583AbjIEXs4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Sep 2023 19:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjIEXs4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Sep 2023 19:48:56 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA4F1B7
        for <linux-crypto@vger.kernel.org>; Tue,  5 Sep 2023 16:48:53 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF347C433C8;
        Tue,  5 Sep 2023 23:48:51 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="BDyziGVr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1693957729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jk9/h0XNmZvb10OmrnaDTxy3o+8kt/EjVzu3HzpBsn4=;
        b=BDyziGVrzXO0SD3BqtP5Yl8a8vjBCTOSSWUvB9blT6iiQXV8KPrfUoYdgyo0VlhqTXWbHn
        w1cba/Z1wvyspDTyBD5UDntmscx57xcPsT3QDcGIKOcDGNhWjlJLKjieivoYXYmJPd/BsN
        yzIPUGdxSs/terLAv0d5vBCxA9E5K3g=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d4ef6dc8 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 5 Sep 2023 23:48:49 +0000 (UTC)
Date:   Wed, 6 Sep 2023 01:48:45 +0200
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
Subject: Re: [PATCH V2] hwrng: bcm2835: Fix hwrng throughput regression
Message-ID: <ZPe-XcY6i7Mvst5Q@zx2c4.com>
References: <20230905232757.36459-1-wahrenst@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230905232757.36459-1-wahrenst@gmx.net>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 06, 2023 at 01:27:57AM +0200, Stefan Wahren wrote:
> The last RCU stall fix caused a massive throughput regression of the
> hwrng on Raspberry Pi 0 - 3. hwrng_msleep doesn't sleep precisely enough
> and usleep_range doesn't allow scheduling. So try to restore the
> best possible throughput by introducing hwrng_yield which interruptable
> sleeps for one jiffy.
> 
> Some performance measurements on Raspberry Pi 3B+ (arm64/defconfig):
> 
> sudo dd if=/dev/hwrng of=/dev/null count=1 bs=10000
> 
> cpu_relax              ~138025 Bytes / sec
> hwrng_msleep(1000)         ~13 Bytes / sec
> hwrng_yield              ~2510 Bytes / sec
> 
> Fixes: 96cb9d055445 ("hwrng: bcm2835 - use hwrng_msleep() instead of cpu_relax()")
> Link: https://lore.kernel.org/linux-arm-kernel/bc97ece5-44a3-4c4e-77da-2db3eb66b128@gmx.net/
> Signed-off-by: Stefan Wahren <wahrenst@gmx.net>

Thanks, looks good to me.

Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>
