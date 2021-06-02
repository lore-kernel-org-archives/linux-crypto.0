Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20B8BC47083
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Jun 2021 18:52:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F316B613BF
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Jun 2021 18:52:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbhFBSy3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Jun 2021 14:54:29 -0400
Received: from mail-ot1-f47.google.com ([209.85.210.47]:41792 "EHLO
        mail-ot1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhFBSy2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Jun 2021 14:54:28 -0400
Received: by mail-ot1-f47.google.com with SMTP id 36-20020a9d0ba70000b02902e0a0a8fe36so3373092oth.8;
        Wed, 02 Jun 2021 11:52:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BhkU5f+tJ+hSqyFg7ErezVn0Ivl+y2gxQbjvzlVBV9U=;
        b=tXMbBOBSHAnXGji+QdEextkeE7G9I0qXxD4PBAbNwUzn+csKC4RJqPTOghWi3nnUPc
         PbFlTRJSXqmC0YOjDoEHx24y7xaFM+TgW1uX/IzF0vEO0SLjts9xWIGbxAEjlh2Vecvz
         Y5OvxP//cQ6tZ6HIP4Tm+C5+JbSIaVT1GBQXNwcrdzs4r9bgDsTuZZFUxr+1RxXlNKPk
         rRWHMt1pTYE1fc8Knycx1yZu2qEOhRiYvO1+TbOphi4qs8YaKBMmjccQThTx716m6/At
         BD2ukTwqNAIMoTP5u0DcW4GA3aO8jWKELAg+TgiYkF8kFpFoiwubrz747h6NgEUXt79F
         oZRw==
X-Gm-Message-State: AOAM530JTYeqrq2be1jyEkSbNVUD63RH6kDZOrUb7wXqAOsIFTjXlXB2
        AVjBOcZUzBhdzTEeFxwRNw==
X-Google-Smtp-Source: ABdhPJyTq9Ep3tasx2cPI0M7AL1pDymMTdQjNXN9Hn/furYIOYtA3s2pfZN94oDn02txTz/itqN7dg==
X-Received: by 2002:a9d:7384:: with SMTP id j4mr27822121otk.268.1622659965025;
        Wed, 02 Jun 2021 11:52:45 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id x24sm157365otq.34.2021.06.02.11.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 11:52:43 -0700 (PDT)
Received: (nullmailer pid 3768255 invoked by uid 1000);
        Wed, 02 Jun 2021 18:52:42 -0000
Date:   Wed, 2 Jun 2021 13:52:42 -0500
From:   Rob Herring <robh@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "David S . Miller" <davem@davemloft.net>,
        Krzysztof Halasa <khalasa@piap.pl>, devicetree@vger.kernel.org,
        Imre Kaloz <kaloz@openwrt.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Corentin Labbe <clabbe@baylibre.com>
Subject: Re: [PATCH 2/3 v4] crypto: ixp4xx: Add DT bindings
Message-ID: <20210602185242.GA3768191@robh.at.kernel.org>
References: <20210525084846.1114575-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210525084846.1114575-1-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 25 May 2021 10:48:46 +0200, Linus Walleij wrote:
> This adds device tree bindings for the ixp4xx crypto engine.
> 
> Cc: Corentin Labbe <clabbe@baylibre.com>
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v3->v4:
> - Revert back to the phandle to the NPE with the instance
>   in the cell as in v1. Use intel,npe-handle just like
>   the ethernet driver does.
> - Drop the other changes related to using an u32 or reg
>   and revert back to v1.
> - Keep the other useful stuff from v2 and v3.
> ChangeLog v2->v3:
> - Use the reg property to set the NPE instance number for
>   the crypto engine.
> - Add address-cells and size-cells to the NPE bindings
>   consequently.
> - Use a patternProperty to match the cryto engine child
>   "crypto@N".
> - Define as crypto@2 in the example.
> - Describe the usage of the queue instance cell for the
>   queue manager phandles.
> ChangeLog v1->v2:
> - Drop the phandle to self, just add an NPE instance number
>   instead.
> - Add the crypto node to the NPE binding.
> - Move the example over to the NPE binding where it appears
>   in context.
> ---
>  .../bindings/crypto/intel,ixp4xx-crypto.yaml  | 47 +++++++++++++++++++
>  ...ntel,ixp4xx-network-processing-engine.yaml | 22 +++++++--
>  2 files changed, 65 insertions(+), 4 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/crypto/intel,ixp4xx-crypto.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
