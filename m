Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F594C433FE
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Apr 2022 07:41:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245534AbiDKHnM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Apr 2022 03:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245585AbiDKHmj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Apr 2022 03:42:39 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62BCC3882
        for <linux-crypto@vger.kernel.org>; Mon, 11 Apr 2022 00:40:24 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id l9-20020a05600c4f0900b0038ccd1b8642so8462373wmq.0
        for <linux-crypto@vger.kernel.org>; Mon, 11 Apr 2022 00:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=3oyYPOVpIkmBff/7EiYsTw/AJNyS2XGBHLuSoNlzrgc=;
        b=d2HH6ugGb0vTvfwTwMnns8hVdf/MUzdBfmAd2yVAKdDr2qmC2I4QGziGamzcNN/+9f
         YOdBw38xMBcFMdWpAcm47rjnaQ5BtsqtpHPBFM5y+HRbuzodRgolmmh8G/7t79sE61Ag
         E0wavwZcosleiwSBQ/FEJkd0Tj/jS3tQ8hiLcIBKfyWki2f3j3MPx5brenieHJUtOPYj
         rLIyDl/FbFINnAhhgL5v6xZzsAsgpa2QCbvGShcAl9DyBcB8jsro+CW4Hp9LEWhmq69X
         /AK3KdaoYoOaw72iDO6Noqe0rQGpksMvP+9cPpoE1ESrXmaDlxYBi2JEGsjgaSjVnNbf
         Nx4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=3oyYPOVpIkmBff/7EiYsTw/AJNyS2XGBHLuSoNlzrgc=;
        b=RwCjhbvSFnznABY92ynmJ02OmZ57keEIr/OHtytvpgdEbTfrn660hA30/g1rGumiWc
         bwwUp9gF1AYT6xG7bFaTrjl9mKxfntGtVeGGuw4Lmh1u8UkMZJrY/HS0xUlKRdLCgtWo
         abbbIhstnsm5HthR87SNu08edGplzUp2TZfmv7ZVMDHiR6sHa+X4acB7mcmjW/Xc8WaS
         c+tbXteC48ATQL+D0kVvcONpCA0F0nQPy8YigTYSshXQP3nyPETP7RcjBoN0chH/Fhh0
         LcTP9pwESrPJqSShhRyBqUSMNL8uQGva4kxpfq9w/RZrvZTBQ8g4OzzeffUCz+yTznoh
         3T+w==
X-Gm-Message-State: AOAM530vWbahDFyg9lN2XO9+HTk3jAvK8WD8s48fYaAV2xNnhkaLhDKG
        5Qu2+rdbLle8K5V7p575oux5lw==
X-Google-Smtp-Source: ABdhPJx62ggZUG3BXe7S+CQUxyEq/166nIQzx3Hblm5hVassqt37mQgy9+cc9KMTOtKbn3qxxPImrw==
X-Received: by 2002:a7b:c057:0:b0:37b:ebad:c9c8 with SMTP id u23-20020a7bc057000000b0037bebadc9c8mr27467966wmc.61.1649662822962;
        Mon, 11 Apr 2022 00:40:22 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id v13-20020adfe28d000000b0020375f27a5asm26909964wri.4.2022.04.11.00.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 00:40:22 -0700 (PDT)
Date:   Mon, 11 Apr 2022 09:40:20 +0200
From:   LABBE Corentin <clabbe@baylibre.com>
To:     John Keeping <john@metanate.com>
Cc:     heiko@sntech.de, herbert@gondor.apana.org.au, krzk+dt@kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org
Subject: Re: [PATCH v4 18/33] crypto: rockchip: fix style issue
Message-ID: <YlPbZGt3mVk25CWi@Red>
References: <20220401201804.2867154-1-clabbe@baylibre.com>
 <20220401201804.2867154-19-clabbe@baylibre.com>
 <YkrY/9xE702mqKR/@donbot>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YkrY/9xE702mqKR/@donbot>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Mon, Apr 04, 2022 at 12:39:43PM +0100, John Keeping a écrit :
> On Fri, Apr 01, 2022 at 08:17:49PM +0000, Corentin Labbe wrote:
> > This patch fixes some warning reported by checkpatch
> > 
> > Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> > ---
> >  drivers/crypto/rockchip/rk3288_crypto_ahash.c | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> There's also a badly indented comment in rk_hash_run() which could be
> fixed in this patch.

Hello

Thanks, I will fix it.

Regards
