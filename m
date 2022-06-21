Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 386A3C43334
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jun 2022 08:06:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347295AbiFUIGC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Jun 2022 04:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345991AbiFUIGB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Jun 2022 04:06:01 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C09359598
        for <linux-crypto@vger.kernel.org>; Tue, 21 Jun 2022 01:05:59 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id z9so6998409wmf.3
        for <linux-crypto@vger.kernel.org>; Tue, 21 Jun 2022 01:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=GsCQyeSS9WqgWVTSCSRei8+jKy0pNjIeX7QnW7mozH8=;
        b=jibc9DU08V3+hmlKpMeuFBDRViUNOmAqhLv6bBMBvot6Y1y5fIwWhHP50ijPfYjSkP
         dofNHKktUMXyQWgFL3kXgkNcCMI2EyGV7jpxsE895xWHEcXseYPy3ALYyk3QO/N0mUp0
         vdtIIlaM3jdF4mNnqhGbeiMjdwIE1RoqzlR0jkpN01OXtm8YiT2z6tDuzLLchasFD2w2
         Mkh6LtyCFJWejhKMxgykZsEQj/x8fiEINVD1qJbJOxZgN2YH/UWuZMuMZW32iBeGtvQq
         /lW7BLRvhMJx91EGYj8g/3IgB34BAKrk4wE5Qh21ccOj72gocm1+GPBZgzZ2TTnx2Dna
         r2Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=GsCQyeSS9WqgWVTSCSRei8+jKy0pNjIeX7QnW7mozH8=;
        b=mql7bxd9SqrCbfmDOApu2HScVpW02taXZRL2InLpeCDWl1MbBa+asHHIBcEDF2thq7
         xaEmGcTsBtB80Vp1jo1sWcyDO80yemhcg6QlKDIISb/xMq2myN5x/ijCfNDDwd1rBk52
         NkrcXnAfnYDLuJIRFDGFemAHtZD2DhUc1XpjGxwLpBgCcIKJiYp23wGHbXRGB65QVBeX
         SGkDexII8Rvug/rG0Y08bez+/IFB5No5pCCDgRpG8ZOD59fjl2Pk9X0HOq9ewL5jzpHS
         fsTLSeAc1NIn8yyuYpPL1OXcMJE6IndFgbYhYrCBN0WrwZCw5n08mgKK50Np3jpDK+H0
         /o0Q==
X-Gm-Message-State: AJIora9eANrtmbAwtIEvOFcqcVa6UtPZxRT1grlG7EpRp527oXs3XySn
        kJ/OOeQ5b0NoH2zuqVZTEePkfEzjFsxRIQ==
X-Google-Smtp-Source: AGRyM1uyuBI4yQO8I87mv5kU872kiOSXmbKPq5Tg/yiYqqbU8VShLy0QcRaY062PjM90XL8FvpDVSQ==
X-Received: by 2002:a05:600c:1c10:b0:39c:4708:648d with SMTP id j16-20020a05600c1c1000b0039c4708648dmr28938957wms.85.1655798758346;
        Tue, 21 Jun 2022 01:05:58 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id t5-20020a05600001c500b0020d106c0386sm7043231wrx.89.2022.06.21.01.05.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 01:05:57 -0700 (PDT)
Date:   Tue, 21 Jun 2022 10:05:54 +0200
From:   LABBE Corentin <clabbe@baylibre.com>
To:     John Keeping <john@metanate.com>
Cc:     heiko@sntech.de, ardb@kernel.org, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Subject: Re: [PATCH v7 14/33] crypto: rockchip: handle reset also in PM
Message-ID: <YrF74tmA9qc+I3JF@Red>
References: <20220508185957.3629088-1-clabbe@baylibre.com>
 <20220508185957.3629088-15-clabbe@baylibre.com>
 <YrBUODGF51oUsF1f@donbot>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YrBUODGF51oUsF1f@donbot>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Mon, Jun 20, 2022 at 12:04:24PM +0100, John Keeping a écrit :
> On Sun, May 08, 2022 at 06:59:38PM +0000, Corentin Labbe wrote:
> > reset could be handled by PM functions.
> 
> Is there any further rationale for this?
> 
> After this change there is no longer a guaranteed reset pulse on probe
> since the reset control may already be de-asserted.  This is normally
> the most important case for a reset as it's the only time when the state
> of the hardware is unknown.
> 
> The original use of devm_add_action_or_reset() seems a bit weird already
> since there doesn't seem to be any need to assert reset when the driver
> is unloaded.
> 

I am not an hw engineer, so my knowledge on reset is low.
So why not having a reset pulse on probe is a problem ?

Do you mean I must put reset asserted on probe ?

