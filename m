Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DATE_IN_PAST_24_48,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D3FFC43619
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 21:08:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F130F6143F
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 21:08:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345729AbhELVIK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 May 2021 17:08:10 -0400
Received: from mail-oi1-f176.google.com ([209.85.167.176]:41872 "EHLO
        mail-oi1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385272AbhELUH6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 May 2021 16:07:58 -0400
Received: by mail-oi1-f176.google.com with SMTP id c3so23335039oic.8;
        Wed, 12 May 2021 13:06:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=oIC6fjBsBBa/9DolC8gyU2fnbDGV0M3iOztTJzuBJgE=;
        b=CxBFzn5IoQkgQbuHlDPq70+IJ2IkIY+NT/S3u38kjoN2JAW3EyzhTBoCWmRtpTxOZY
         MuvuXrfqWMxYjqAlfz9oh3bmVYJPVU+2h90GMdw0RKGknhXSEO2WYm/mY1u4x8qXdU1e
         Ryki3ptA3J2t9OXpPo0oEuhWLDFsy2dmzeRGLMYar8/sKvUZCnTGnWsfJhvC3ZvmzTE3
         y55a+wA30/HPAKiEO1qnK5ehblK3udUUKXjl0I9sxl3888Kw6ZTGfi2mXd/V1pRqWOgZ
         FN70lrMBasHod+3GKViUgMFQ4xv0w9jzM4A7XXKIJQP7/SdYexP8iuYC5SewT7tTg27m
         3LfA==
X-Gm-Message-State: AOAM530FV9WYgVfVQFNxe/skssiCeyeMamfKo1ZLbUk5v5PLtgYskb5x
        SSSUcZY6TPidpTVzraMnUQ==
X-Google-Smtp-Source: ABdhPJxs6DaOjZ5AP9Q5L742mIrNt1lpTK8EPddVNEA2s1v1SdOWBuSFcVGkSZhJ9FtL8Un0pJqaFQ==
X-Received: by 2002:aca:ac58:: with SMTP id v85mr27314598oie.1.1620850009660;
        Wed, 12 May 2021 13:06:49 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id k20sm189762otb.15.2021.05.12.13.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 13:06:48 -0700 (PDT)
Received: (nullmailer pid 2020685 invoked by uid 1000);
        Tue, 11 May 2021 13:40:20 -0000
From:   Rob Herring <robh@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>, Imre Kaloz <kaloz@openwrt.org>,
        linux-arm-kernel@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Krzysztof Halasa <khalasa@piap.pl>
In-Reply-To: <20210510213634.600866-2-linus.walleij@linaro.org>
References: <20210510213634.600866-1-linus.walleij@linaro.org> <20210510213634.600866-2-linus.walleij@linaro.org>
Subject: Re: [PATCH 2/3] crypto: ixp4xx: Add DT bindings
Date:   Tue, 11 May 2021 08:40:20 -0500
Message-Id: <1620740420.942104.2020684.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 10 May 2021 23:36:33 +0200, Linus Walleij wrote:
> This adds device tree bindings for the ixp4xx crypto engine.
> 
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> Herbert, David: This can be applied separately once we are
> happy with the bindings, alternatively it can be merged
> with the support code into ARM SoC.
> ---
>  .../bindings/crypto/intel,ixp4xx-crypto.yaml  | 59 +++++++++++++++++++
>  1 file changed, 59 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/intel,ixp4xx-crypto.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/crypto/intel,ixp4xx-crypto.example.dt.yaml: npe@c8006000: 'crypto' does not match any of the regexes: 'pinctrl-[0-9]+'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/firmware/intel,ixp4xx-network-processing-engine.yaml

See https://patchwork.ozlabs.org/patch/1476741

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

