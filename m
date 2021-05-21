Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53D70C433ED
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 02:04:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3806A6135B
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 02:04:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238227AbhEUCFh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 May 2021 22:05:37 -0400
Received: from mail-oo1-f46.google.com ([209.85.161.46]:35735 "EHLO
        mail-oo1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234496AbhEUCFg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 May 2021 22:05:36 -0400
Received: by mail-oo1-f46.google.com with SMTP id s20-20020a4ae9940000b02902072d5df239so4251341ood.2;
        Thu, 20 May 2021 19:04:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/OGghJHG106SuqKR1QhblR0v6y3pgFgWrTyUNUTN0wE=;
        b=NHXEz0DlaBFrb9sIhhZj5YxtiqqgFG6Wpjuao9fBL+4uSDvVfKjlsdY8GkOVV0GSZW
         5KS7g5pLhPs04qAzGCfPHax7qNb/7dSDiUuYtqHxEARvc5kZ72TRfdaWdYXBspA7A8Ea
         5mAG1AtvFWvxvGmCKTPYuqeFX5cEXyzvYxfHEdVHlUT/2lZs3ssdST6F0epMcW3q3VYF
         VLQyoBxreQJeakrO8QSv1F3PuA19PdslDsmXxRlB2Qli4Nhwj2Un/r69YcWkUl8LsgLu
         TYCQ+YbXcrVdItmrHn/bNZSyxEnQ+Fij/tEITalmFdFV16jN4P3HfdctQrRRm7amGodF
         WNAw==
X-Gm-Message-State: AOAM530DZB7vAS85jYDUvcIU3KReQVXJn/z88ejzefauhYGCzZIqcpo2
        9RrwQjjMNJ2AzTx7ElOy9A==
X-Google-Smtp-Source: ABdhPJxce3VVn9haIq3nvXcLvbajq9qtS10MN8rsPsS5TeO9pBfLXmkcP8odoYhDzmoUk703Oi1nXQ==
X-Received: by 2002:a4a:d442:: with SMTP id p2mr6077638oos.89.1621562654437;
        Thu, 20 May 2021 19:04:14 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id h59sm991917otb.29.2021.05.20.19.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 19:04:13 -0700 (PDT)
Received: (nullmailer pid 2507565 invoked by uid 1000);
        Fri, 21 May 2021 02:04:12 -0000
Date:   Thu, 20 May 2021 21:04:12 -0500
From:   Rob Herring <robh@kernel.org>
To:     Fabien Parent <fparent@baylibre.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Matt Mackall <mpm@selenic.com>, mkorpershoek@baylibre.com,
        devicetree@vger.kernel.org, linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v2 2/2] dt-bindings: rng: mediatek: add mt8365 to mtk rng
 binding
Message-ID: <20210521020412.GA2507536@robh.at.kernel.org>
References: <20210520111656.66017-1-fparent@baylibre.com>
 <20210520111656.66017-2-fparent@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210520111656.66017-2-fparent@baylibre.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 20 May 2021 13:16:56 +0200, Fabien Parent wrote:
> Add RNG binding for MT8365 SoC.
> 
> Signed-off-by: Fabien Parent <fparent@baylibre.com>
> ---
> 
> v2: Write the compatible in a more compact way
> 
>  Documentation/devicetree/bindings/rng/mtk-rng.yaml | 1 +
>  1 file changed, 1 insertion(+)
> 

Applied, thanks!
