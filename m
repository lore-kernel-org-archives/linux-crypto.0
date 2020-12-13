Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 703B0C433FE
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Dec 2020 16:26:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C04C233CE
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Dec 2020 16:26:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390595AbgLMQ0J (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Dec 2020 11:26:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbgLMQ0J (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Dec 2020 11:26:09 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B1FC0613D6
        for <linux-crypto@vger.kernel.org>; Sun, 13 Dec 2020 08:25:28 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id d26so784020wrb.12
        for <linux-crypto@vger.kernel.org>; Sun, 13 Dec 2020 08:25:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jamieiles-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Rf+b9N2htku5WJ9Hu0NGJ+c4uKlPgFBYFEnRhIM8Uhs=;
        b=S2Ty7Lhn1rwak6hdqcbPARjAEnxxvMgu6mXc9eqNXbZ4hVjaGEqQB8pMUoe4zTi1a7
         9K5iVrrFK26itWqBcEUcsB426J87wE6+0bdUwlzGPyaQAK7WJ2mi8EEN38iGxMFmnrsP
         RvAbxMjbqNfxeOib8SiOEhiZQlK2QiETI6lZECSO98DeQC4x86MPTvAar80gTr8fHlo9
         Me754RKBSGlMI4siQAk6QGOOJKPhpOHTAHbm+6yPlQO+KD153S9F2Nau3c/43mdt5Cbk
         efxE27ZeDqsyw9BQh3/7tvmX/sjx5PrOfXZJKnEygqAclqItBdi4Ow5kpP0d/zx2xj9h
         cClA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Rf+b9N2htku5WJ9Hu0NGJ+c4uKlPgFBYFEnRhIM8Uhs=;
        b=TE8N9rF2aBF/n3yEKjuAUF4zdbrzWPgg88T9QnKIaBhRn5SnaODKETobHvmkXoU86M
         x5EyrWp/guSWBWatA1FkEfCGfU7hSvqHLr3yRJQfCx/S2f2Rp5i1n6DwfXGJ07kdss0D
         OIjTf3oWr0yjV+OIq49cYdLkSDxKnSZQijL6oczI7/34PMTHjKjxp7zRuLSFClmWTkUo
         Xfy8f0T4wpFIW2d53BUE4n8ghOl4YAzBzfJpdPxiA12p7rW6EmKb1Lv/NQgOEcq/SagR
         hbXumuqfD6uGrcg4lvNeJq8cYNq6tETXUB8tP/ptWo1DZaPwP4m6ep/oRHQhT29shMnI
         L6bg==
X-Gm-Message-State: AOAM532Wjk9WL41t+GKwj8eDKqLeWtbHvvJ8lovuQdFcdoG1nAFjEP23
        D7K7rOVqvzz+s/SOmZcYbu+g5A==
X-Google-Smtp-Source: ABdhPJzLE3t6E6T+7CANIDVOP3RTPKz+wUMY/WJbm93kEjoOQjfqOkI5aZIByNISKdCoVp6ig7p5VA==
X-Received: by 2002:a5d:5005:: with SMTP id e5mr24119814wrt.279.1607876727343;
        Sun, 13 Dec 2020 08:25:27 -0800 (PST)
Received: from localhost ([82.44.17.50])
        by smtp.gmail.com with ESMTPSA id z2sm27245655wml.23.2020.12.13.08.25.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Dec 2020 08:25:26 -0800 (PST)
Date:   Sun, 13 Dec 2020 16:25:25 +0000
From:   Jamie Iles <jamie@jamieiles.com>
To:     Rob Herring <robh@kernel.org>
List-Id: <soc.lore.kernel.org>
Cc:     Jamie Iles <jamie@jamieiles.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, soc@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 0/4] Remove PicoXcell
Message-ID: <20201213162525.GA223635@willow>
References: <20201210200315.2965567-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201210200315.2965567-1-robh@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Acked-by: Jamie Iles <jamie@jamieiles.com>

for the series.  Intel EOLd this product now, good idea to remove it.

Thanks,

Jamie

On Thu, Dec 10, 2020 at 02:03:11PM -0600, Rob Herring wrote:
> PicoXcell has had nothing but treewide cleanups for at least the last 8
> years and no signs of activity. The most recent activity is a yocto vendor
> kernel based on v3.0 in 2015.
> 
> These patches can go via the respective maintainers' trees.
> 
> Rob
> 
> Rob Herring (4):
>   ARM: dts: Remove PicoXcell platforms
>   ARM: Remove PicoXcell platform support
>   crypto: Remove PicoXcell driver
>   dt-bindings: Remove PicoXcell bindings
> 
>  .../devicetree/bindings/arm/picoxcell.txt     |   24 -
>  .../bindings/crypto/picochip-spacc.txt        |   21 -
>  .../devicetree/bindings/net/macb.txt          |    2 -
>  .../bindings/timer/snps,dw-apb-timer.yaml     |    7 -
>  MAINTAINERS                                   |    9 -
>  arch/arm/Kconfig                              |    2 -
>  arch/arm/Kconfig.debug                        |   13 +-
>  arch/arm/Makefile                             |    1 -
>  arch/arm/boot/dts/Makefile                    |    3 -
>  arch/arm/boot/dts/picoxcell-pc3x2.dtsi        |  239 ---
>  arch/arm/boot/dts/picoxcell-pc3x3.dtsi        |  355 ----
>  arch/arm/boot/dts/picoxcell-pc7302-pc3x2.dts  |   78 -
>  arch/arm/boot/dts/picoxcell-pc7302-pc3x3.dts  |   84 -
>  arch/arm/mach-picoxcell/Kconfig               |    9 -
>  arch/arm/mach-picoxcell/Makefile              |    2 -
>  arch/arm/mach-picoxcell/common.c              |   81 -
>  drivers/crypto/Kconfig                        |   18 -
>  drivers/crypto/Makefile                       |    1 -
>  drivers/crypto/picoxcell_crypto.c             | 1806 -----------------
>  drivers/crypto/picoxcell_crypto_regs.h        |  115 --
>  20 files changed, 1 insertion(+), 2869 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/arm/picoxcell.txt
>  delete mode 100644 Documentation/devicetree/bindings/crypto/picochip-spacc.txt
>  delete mode 100644 arch/arm/boot/dts/picoxcell-pc3x2.dtsi
>  delete mode 100644 arch/arm/boot/dts/picoxcell-pc3x3.dtsi
>  delete mode 100644 arch/arm/boot/dts/picoxcell-pc7302-pc3x2.dts
>  delete mode 100644 arch/arm/boot/dts/picoxcell-pc7302-pc3x3.dts
>  delete mode 100644 arch/arm/mach-picoxcell/Kconfig
>  delete mode 100644 arch/arm/mach-picoxcell/Makefile
>  delete mode 100644 arch/arm/mach-picoxcell/common.c
>  delete mode 100644 drivers/crypto/picoxcell_crypto.c
>  delete mode 100644 drivers/crypto/picoxcell_crypto_regs.h
> 
> --
> 2.25.1
