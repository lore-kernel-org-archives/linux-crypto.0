Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BA34ECAAA3
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Aug 2022 12:04:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbiHZMEx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Aug 2022 08:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238990AbiHZMEw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Aug 2022 08:04:52 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A223271A
        for <linux-crypto@vger.kernel.org>; Fri, 26 Aug 2022 05:04:49 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id d5so766064wms.5
        for <linux-crypto@vger.kernel.org>; Fri, 26 Aug 2022 05:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc;
        bh=lMuxh+u8ZPUuuV+VRYCxHMNst2wA1aZBaMHjBXf1Wb0=;
        b=NrIlwDogoVusrYeDER/Y5XzVSP4Pyy5GaReZjXsbBM2a/WBgohQZDG/pTrfMNVS/9/
         zqtgJMl867mtXkfUTf0I9Uyk4aIBvLoGVj1U4rhUwkgECfq6XpxqAAv1408SJb58WhOn
         b377kg7MetcN4dta8H9PB4kfFDFnrI96fB/610X6BfZQj3f77Sg0ohGDlczirT5r7Vtz
         UTJaf6K7pG7Quah6fX1CBvJKuR8X6Y1TAxo0xz8JgR9iEkhWWyDgsQomfAb+vFURw1sb
         pQ2Vj9AhXkysV0J1J0Ld64Z0YJDb4GUFZIc65shH/o9q3rW8Wh+7D9Ax/eYqU4d85yml
         nkvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=lMuxh+u8ZPUuuV+VRYCxHMNst2wA1aZBaMHjBXf1Wb0=;
        b=YDfR6sMMLcuoWS+ba1tfKfEujogb9bZ/fgDnLUQ1kFAz4JAUgzeYLrlrh12Mha55x4
         WDLaRgQpHm4LM95NWkuloBBKg4EnwI60Z79YdSD+LulNTHhj24SqUC3daE5FZGvGIb4Y
         v2aDjgviDnWoHtRyIOoF5MSmZ7GFMmdbeGBpFfuijmB0EYPF4CMJ3nDBVsMcrSbTP/xe
         5/SVasG+AzNG5nIFGqHb9PelE//zbwQYJQ8pRoVxBfQVtrAco3lHvbh3SaiJMBqU8vtX
         kiBsWXEAwcV8U3RwVZn2cysvXDl4gghEt7/Nah5EkU0np+Hmr80yNirxAqvOvS57ls1G
         9KdA==
X-Gm-Message-State: ACgBeo0nkAqMysFZGYXWDzfdXknwCGjSdypDmTvfet/dZsetQhpzeTyv
        ifCruHn4sqpr6K+wP4HzyBrlpg==
X-Google-Smtp-Source: AA6agR5qfYBnZ9sYPzunh5Co458jPKXXzym9qls5FamksX7v+4s/g+oCqH9kYnmDPnjxUZ4rHPfVmQ==
X-Received: by 2002:a7b:c391:0:b0:3a5:de98:f559 with SMTP id s17-20020a7bc391000000b003a5de98f559mr5078641wmj.157.1661515488133;
        Fri, 26 Aug 2022 05:04:48 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id j18-20020a05600c191200b003a5c1e916c8sm16903433wmq.1.2022.08.26.05.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Aug 2022 05:04:47 -0700 (PDT)
Date:   Fri, 26 Aug 2022 14:04:45 +0200
From:   LABBE Corentin <clabbe@baylibre.com>
To:     Jack Wang <jinpu.wang@ionos.com>
Cc:     linux-kernel@vger.kernel.org,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v1 07/19] crypto: gemin: Fix error check for dma_map_sg
Message-ID: <Ywi23cKqPcJEWxHB@Red>
References: <20220819060801.10443-1-jinpu.wang@ionos.com>
 <20220819060801.10443-8-jinpu.wang@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220819060801.10443-8-jinpu.wang@ionos.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Fri, Aug 19, 2022 at 08:07:49AM +0200, Jack Wang a écrit :
> dma_map_sg return 0 on error.
> 
> Cc: Corentin Labbe <clabbe@baylibre.com>
> Cc: Hans Ulli Kroll <ulli.kroll@googlemail.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/crypto/gemini/sl3516-ce-cipher.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 

Hello

There is a typo in subject gemin -> gemini.

Acked-by: Corentin Labbe <clabbe@baylibre.com>
Tested-by: Corentin Labbe <clabbe@baylibre.com>

Thanks
Regards
