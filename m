Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CFF3C433F5
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Mar 2022 21:10:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239413AbiCBVLX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Mar 2022 16:11:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233430AbiCBVLW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Mar 2022 16:11:22 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D61B18A3
        for <linux-crypto@vger.kernel.org>; Wed,  2 Mar 2022 13:10:38 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id i66so1954494wma.5
        for <linux-crypto@vger.kernel.org>; Wed, 02 Mar 2022 13:10:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=dQsFhF1/hV1naVDlbcCm3YVz6Er9ziLGvWW482VtK3Q=;
        b=K/eASSZiHGsNk3WKGGcy7BgI65UgOtLPWPoWEFkbEMo59l5HNvPWcYR35FHdrlShr4
         5xFuug7BnHoGw67glt0a72xAbnihBvVm6v+CuFacgR2DF6phuBwCBp8u2pN830W67Jhw
         3Wpt24zx6BQWyRtJWnXmuKtir+/oesk7s9JaRJkv0KH4bkO8kf2AexzLLYUKRHrZUlNE
         6l6MffU3UWBbLsCVN3VLYsUSHIJoUe/FAJ4k9riNqikL1KcZw4EXoSHKM54vc/0sZQ7B
         Phh2Aks98ecZihS5NKjdgM+5BtRC0PggapwU7Y91IhVOOp0euvhRplyo8KdN5EFph8+d
         kHHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=dQsFhF1/hV1naVDlbcCm3YVz6Er9ziLGvWW482VtK3Q=;
        b=h+awAPKnkb4QN2YNGE3NceoOIzJ5dszaE/MurRWn0wCelwDKc/2kf1HBTVtwI+j/W3
         IWLA11Jh5EdNN/TTJXQA1aJ3nUTo345J1LG5zsLGN8V17Rcj5h1CIah8Xs1sMnOLZJy7
         57ASPXklDH42yD7R1ILzDyAwhpndP1O6psDBqsLs82KPGDsCMKxAQUQQ5OaNWabQkrje
         bjL/N7gpc37J+50G1u9l/k7Fq+WyxWjV2HAiUb6bxE0yvURSRrtqoZFvxFCNj8Kb5tlI
         HDWRPzhblNGYJ3kk3Rw0JCpF4YQqymcl43dXM5oe7OpyR8/FUxtbDXH7xkABsNMGII1N
         QlUA==
X-Gm-Message-State: AOAM530pvmGAwrNgF3Q62ThJ/jBdd06Sf0LHxoOP1ydojvgdHbqdSyP8
        MhtWM6XlWGtshOQFa/gUSjD5GQ==
X-Google-Smtp-Source: ABdhPJz3l7hSdXw5FPBP4h5QrTtNeUrO/cpc7nHx9qcYgH+e/DxuEe7f9waYf+ZJ40PnOn5vzrIFQA==
X-Received: by 2002:a05:600c:5118:b0:381:71f6:bb93 with SMTP id o24-20020a05600c511800b0038171f6bb93mr1342536wms.169.1646255437350;
        Wed, 02 Mar 2022 13:10:37 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id b13-20020a05600c4e0d00b003816cb4892csm12624945wmq.0.2022.03.02.13.10.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 13:10:36 -0800 (PST)
Date:   Wed, 2 Mar 2022 22:10:35 +0100
From:   LABBE Corentin <clabbe@baylibre.com>
To:     John Keeping <john@metanate.com>
Cc:     heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski@canonical.com, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Subject: Re: [PATCH 00/16] crypto: rockchip: permit to pass self-tests
Message-ID: <Yh/dS1LBmUlM2zPD@Red>
References: <20220228194037.1600509-1-clabbe@baylibre.com>
 <Yh4Y99KCi+1lbrve@donbot>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yh4Y99KCi+1lbrve@donbot>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Tue, Mar 01, 2022 at 01:00:39PM +0000, John Keeping a écrit :
> On Mon, Feb 28, 2022 at 07:40:21PM +0000, Corentin Labbe wrote:
> > The rockchip crypto driver is broken and do not pass self-tests.
> > This serie's goal is to permit to become usable and pass self-tests.
> > 
> > This whole serie is tested on a rk3328-rock64 with selftests (with
> > CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y)
> 
> I previously noticed this breakage on rk3288 but never got time to
> investigate (disabling the driver was quicker).
> 
> This series fixes everything on rk3288 as well, thanks!
> 
> I hit the same warnings as the kernel test robot as well as a missing
> new kconfig dependency (see separate reply to patch 10), but this is
> 
> Tested-by: John Keeping <john@metanate.com>
> 

Thanks for the test, but since I have added some code in v2, could you re-test it ?

Regards
