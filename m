Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3F4AC433FE
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Mar 2022 13:07:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244125AbiCWNJD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Mar 2022 09:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244140AbiCWNJA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Mar 2022 09:09:00 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 001687CDD7
        for <linux-crypto@vger.kernel.org>; Wed, 23 Mar 2022 06:07:29 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id d7so2045027wrb.7
        for <linux-crypto@vger.kernel.org>; Wed, 23 Mar 2022 06:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=/7GPfWTScrdUPxYCfpF4p4gmdocaWvB3DedYIkySiRQ=;
        b=7EDiYHM0/mHUHNh2nAcUtV8Mo87BBMJDjh2R3QaAEXuxurVdInHyGhkLnwH6gL3bPY
         ftLMYfyygow8mzkD5Dev2Iq+3cB/DbsVL3VVzYv3NYkRy77gO07thxxfnDuE/5vvFwiB
         SnNZc9jBzd7JxXBaPe5MmyMhQ/dZvf5IJrjHbztF2VDxy+YSXfGCFsGy91bzu0dpwUVD
         vLLzZ2UR7OCpthmgXf0+rBDgwrScxpIXhhh0aF66G9+NvYfooCnN6Ac965njTsu7vX7H
         5rK015KemhcLQmxFbNnPmlRfVnVllLsShyU6SyQvhK65gIf9XVzlSMG1ZoK1rbNLFDgk
         2K8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=/7GPfWTScrdUPxYCfpF4p4gmdocaWvB3DedYIkySiRQ=;
        b=x9wqMN71+sE9DZmv0W3TB8t/E83b9wdISFwfgaQungCd7KeHOcl/kq8NBvrE+PFvS7
         NvUJVJSzMuDZt7dpAO6y1fpj1Iw4wUFRCmfuUD2Eg2vTpQUA/Pv1Iy4CRA1Dn6ePFKuj
         FUDAB2WnVfpCWfyJGUTu3X4XL77HmGpXuhGCUXcyDkRRYhqDNXePwLcpDbbMQ2pYifx4
         vQfjZ2iZcItfnMyxIZnW9CniDgHMzxJhhr4YSVCf8KR7Q8VRRFTksY8dans0n4TV6ZJA
         xYRjmpj9AJLelkXJkIh3epOigYmWvEjW9zOwqagbQj1Iv37pmJTSOX9KnbLVqjkwgfNl
         3iTg==
X-Gm-Message-State: AOAM530Yz/Rfg+R57UokNHuwsX/umkhxET02gQkSW2CNeUjxiJyZ3nGB
        mpc2Ixnrxl/wnYFZo0fQhlpXLg==
X-Google-Smtp-Source: ABdhPJwlHTs/jXded6YR+bEyG9ABUfL/AlSP0pBeJMmhWDxUYvyYfFnDLfkgPcSrNXyLqFblB0f+cw==
X-Received: by 2002:a5d:5509:0:b0:204:f77:c2d with SMTP id b9-20020a5d5509000000b002040f770c2dmr13533390wrv.432.1648040848448;
        Wed, 23 Mar 2022 06:07:28 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id n20-20020a05600c4f9400b0038cbd13e06esm2794951wmq.2.2022.03.23.06.07.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 06:07:27 -0700 (PDT)
Date:   Wed, 23 Mar 2022 14:07:25 +0100
From:   LABBE Corentin <clabbe@baylibre.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     heiko@sntech.de, herbert@gondor.apana.org.au, krzk+dt@kernel.org,
        mturquette@baylibre.com, robh+dt@kernel.org, sboyd@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org
Subject: Re: [PATCH v3 06/26] crypto: rockchip: add fallback for cipher
Message-ID: <YjsbjaQrj2Y+cLmL@Red>
References: <20220321200739.3572792-1-clabbe@baylibre.com>
 <20220321200739.3572792-7-clabbe@baylibre.com>
 <c643c8a0-3ebc-519b-bc6e-f95362d43a69@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c643c8a0-3ebc-519b-bc6e-f95362d43a69@arm.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Tue, Mar 22, 2022 at 11:25:25AM +0000, Robin Murphy a écrit :
> On 2022-03-21 20:07, Corentin Labbe wrote:
> > The hardware does not handle 0 size length request, let's add a
> > fallback.
> > Furthermore fallback will be used for all unaligned case the hardware
> > cannot handle.
> > 
> > Fixes: ce0183cb6464b ("crypto: rockchip - switch to skcipher API")
> > Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> > ---
> >   drivers/crypto/Kconfig                        |   4 +
> >   drivers/crypto/rockchip/rk3288_crypto.h       |   2 +
> >   .../crypto/rockchip/rk3288_crypto_skcipher.c  | 105 +++++++++++++++---
> >   3 files changed, 98 insertions(+), 13 deletions(-)
> > 
> > diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> > index 7b2d138bc83e..84ab14afcbd9 100644
> > --- a/drivers/crypto/Kconfig
> > +++ b/drivers/crypto/Kconfig
> > @@ -784,6 +784,10 @@ config CRYPTO_DEV_IMGTEC_HASH
> >   config CRYPTO_DEV_ROCKCHIP
> >   	tristate "Rockchip's Cryptographic Engine driver"
> >   	depends on OF && ARCH_ROCKCHIP
> > +	depends on PM
> 
> This appears to belong to patch #13 rather than this one.
> 

Hello

Yes this is an error, I will move it this line on the right patch.

> My initial thought was that it probably shouldn't be something for 
> random consumers to care about at all, but there do seem to be a handful 
> of other drivers relying on pm_runtime_resume to enable their clocks, so 
> I guess maybe it's an acceptable idiom :/
> 

Depending on PM made the driver easier to understand (no more if PM/if not PM).
And anyway, since it's embedded device, PM should be always enabled.

Thanks
