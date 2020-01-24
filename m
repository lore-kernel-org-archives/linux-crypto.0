Return-Path: <SRS0=iQPq=3N=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9199AC32771
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Jan 2020 16:24:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 658C520838
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Jan 2020 16:24:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ragnatech-se.20150623.gappssmtp.com header.i=@ragnatech-se.20150623.gappssmtp.com header.b="1mGfJTx6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388168AbgAXQY4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Jan 2020 11:24:56 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36516 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388009AbgAXQY4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Jan 2020 11:24:56 -0500
Received: by mail-lj1-f194.google.com with SMTP id r19so3158501ljg.3
        for <linux-crypto@vger.kernel.org>; Fri, 24 Jan 2020 08:24:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=2ZKQV9EUYn6O4Dwbxq9ZK3GxrnLNGiu/KoVo8Ur0eNc=;
        b=1mGfJTx6KGaWGxumVkRlwu8JFX/T7ZxAi/ZPOibqWqzJC0d3Q6qE/tOOl1kSg0+arG
         D+PfJu2DBY2lwp7fRrB9iFZ8Kr5f8m1MnAXwgNUfBLiHhOplxnUQLiRv/XHQI6S+EYuH
         rpbt9IJH9DSh8+FVausrel1GvuhSQ6rZXs5HYp/wKDRdwASexD4MFTHeJ/MlErj+G0Dl
         KFa4TU/4uMQL8oFQEGVlSczqhIBQiIhhNyMfoLHbPL6rVEBHh/jdu4mapAPNAS/p5I6M
         VQgNDC1USFdKJQfbBnSsLWvtMEcip/ygylNCs8Vloj9hboY9ZfPNvoEYtqHp2P4ZcRCK
         D51A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=2ZKQV9EUYn6O4Dwbxq9ZK3GxrnLNGiu/KoVo8Ur0eNc=;
        b=lr2gZZR7tELP1FJYlNFun2/B9SSl9IQp55PxfG6fH7SLf8GNTvVPGVapwuIdS3dKQJ
         aOOrxNBs8Nduoat67RfwHirqUk07hdwnM6GswORa6h2huKRD4FS/oC7A+rtnxzlKMD1n
         blebHDo3E4GwsSs7omGaXWZzRMhhTSxpORMg2hq43cZhRwYZLvEb7clZjB44neYYJAI9
         AYfeBM9CvDn8E1QNSsEmplEmlkRz9e88kxOJhYjiRxEKQO1vxKeFohkUJBTPwVsXFRox
         Oa4JXVysf2BJKj3PSbufN7+Qnp7YT8iVf8eMEjNtJEltP0H8uj4FWJXpaOdIPyG+ziaF
         l20Q==
X-Gm-Message-State: APjAAAVTjOJuxU+T7MX+0S7rBFacTm6fQV3DCz3vDb16z9Idz4ux1nXl
        gtu77evyADQvIRiTkvP0bCHJdg==
X-Google-Smtp-Source: APXvYqwD3R6qmy6UAfp7uxu+afZInN2SHuLh7/0SKxfwyTm+CAMduCTdKlx73HrpU5r6GS5WWyvYzQ==
X-Received: by 2002:a2e:3a13:: with SMTP id h19mr2778997lja.16.1579883094015;
        Fri, 24 Jan 2020 08:24:54 -0800 (PST)
Received: from localhost (h-93-159.A463.priv.bahnhof.se. [46.59.93.159])
        by smtp.gmail.com with ESMTPSA id q14sm2974605lfc.60.2020.01.24.08.24.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 08:24:53 -0800 (PST)
Date:   Fri, 24 Jan 2020 17:24:52 +0100
From:   Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Rob Clark <robdclark@gmail.com>, Sean Paul <sean@poorly.run>,
        Felipe Balbi <balbi@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Bin Liu <b-liu@ti.com>, linux-crypto@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Fix debugfs register access while suspended
Message-ID: <20200124162452.GC286344@oden.dyn.berto.se>
References: <20200124132957.15769-1-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200124132957.15769-1-geert+renesas@glider.be>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Geert,

Thanks for your series.

On 2020-01-24 14:29:55 +0100, Geert Uytterhoeven wrote:
> 	Hi all,
> 
> While comparing register values read from debugfs files under
> /sys/kernel/debug/ccree/, I noticed some oddities.
> Apparently there is no guarantee these registers are read from the
> device while it is resumed.  This may lead to bogus values, or crashes
> and lock-ups.
> 
> This patch series:
>   1. Allows debugfs_create_regset32() to be used for devices whose
>      registers must be accessed when resumed,
>   2. Fixes the CCREE driver to make use of this.
> 
> I have identified several other drivers that may be affected (i.e.
> using debugfs_create_regset32() and pm_runtime_*()):
>   - drivers/gpu/drm/msm/disp/dpu1
>   - drivers/usb/dwc3
>   - drivers/usb/host/ehci-omap.c
>   - drivers/usb/host/ehci-tegra.c
>   - drivers/usb/host/ohci-platform.c
>   - drivers/usb/host/xhci.c
>   - drivers/usb/host/xhci-dbgcap.c
>   - drivers/usb/host/xhci-histb.c
>   - drivers/usb/host/xhci-hub.c
>   - drivers/usb/host/xhci-mtk.c
>   - drivers/usb/host/xhci-pci.c
>   - drivers/usb/host/xhci-plat.c
>   - drivers/usb/host/xhci-tegra.c
>   - drivers/usb/mtu3
>   - drivers/usb/musb
> 
> Some of these call pm_runtime_forbid(), but given the comment "users
> should enable runtime pm using power/control in sysfs", this can be
> overridden from userspace, so these are unsafe, too?
> 
> Thanks for your comments!

Looks good to me,

Reviewed-by: Niklas Söderlund <niklas.soderlund@ragnatech.se>

> 
> Geert Uytterhoeven (2):
>   debugfs: regset32: Add Runtime PM support
>   crypto: ccree - fix debugfs register access while suspended
> 
>  drivers/crypto/ccree/cc_debugfs.c | 2 ++
>  fs/debugfs/file.c                 | 8 ++++++++
>  include/linux/debugfs.h           | 1 +
>  3 files changed, 11 insertions(+)
> 
> -- 
> 2.17.1
> 
> Gr{oetje,eeting}s,
> 
> 						Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
> 							    -- Linus Torvalds

-- 
Regards,
Niklas Söderlund
