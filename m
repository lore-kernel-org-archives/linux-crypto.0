Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89069C433DB
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Feb 2021 19:35:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AECA64E61
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Feb 2021 19:35:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234049AbhBWTe5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Feb 2021 14:34:57 -0500
Received: from mail-ot1-f45.google.com ([209.85.210.45]:34324 "EHLO
        mail-ot1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234041AbhBWTe4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Feb 2021 14:34:56 -0500
Received: by mail-ot1-f45.google.com with SMTP id b16so16819478otq.1;
        Tue, 23 Feb 2021 11:34:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=jzoiYbxpGL9e8WsQqrLwB9sTS+xjumdfM5quc7WjraA=;
        b=JgZQFB/0HbPE4LIHjD2xvXj3RJ/8nMk0r0FsWiC2P0j9Gd04UYm4ARdvm6za/PGD5f
         RIqm2qLxFppfb2okqG3VEV4Blzjjh/Ls33bocdzbw21myZ6kEYNcMT+w3snN4zWHNMdF
         ecqAWmBvYw5Xu3cFss5Aw2U58SUvSne+dvCGgXc9vvLR2rO36m++vIFJdnXk5/mylNqf
         I9XldAWuGHwP5ySwPJZsa4EkK2oKtp7Tu+9Cs944xNynmexNbnN3zB4Sp1vk31FmCPBN
         4AiLfl1kTKRhwDlinBpmoeq8we+PDIJl0/u/KsNzSCBm91/aQcWf7qFSWJ+iymD2iGBQ
         SqOg==
X-Gm-Message-State: AOAM531ltxDrKsVnfZkD/YT/PCEDYxNu7p7QabJoajHWFk+Atnb7wili
        ij9OppLDUWL0WQCEeFObEg==
X-Google-Smtp-Source: ABdhPJwj76JeAWZQEdKJSqs6KXqu/e1xzLx2WR5ir1KgpkRjXIMDERCdN92Jr+TLNAQe0oqLmlaClw==
X-Received: by 2002:a9d:618a:: with SMTP id g10mr20959934otk.34.1614108855332;
        Tue, 23 Feb 2021 11:34:15 -0800 (PST)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id j5sm4445295oij.48.2021.02.23.11.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 11:34:14 -0800 (PST)
Received: (nullmailer pid 4116107 invoked by uid 1000);
        Tue, 23 Feb 2021 19:34:10 -0000
From:   Rob Herring <robh@kernel.org>
To:     =?utf-8?q?=C3=81lvaro_Fern=C3=A1ndez_Rojas?= <noltari@gmail.com>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        linux-rpi-kernel@lists.infradead.org,
        Matt Mackall <mpm@selenic.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        =?utf-8?b?TsOtY29sYXMgRi4gUi4gQS4gUHJhZG8=?= 
        <nfraprado@protonmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        linux-crypto@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        linux-arm-kernel@lists.infradead.org,
        Scott Branden <sbranden@broadcom.com>,
        Mark Brown <broonie@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Stefan Wahren <stefan.wahren@i2se.com>
In-Reply-To: <20210223170006.29558-2-noltari@gmail.com>
References: <20210222194510.14004-1-noltari@gmail.com> <20210223170006.29558-1-noltari@gmail.com> <20210223170006.29558-2-noltari@gmail.com>
Subject: Re: [PATCH v3 1/2] dt-bindings: rng: bcm2835: document reset support
Date:   Tue, 23 Feb 2021 13:34:10 -0600
Message-Id: <1614108850.556529.4116106.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 23 Feb 2021 18:00:05 +0100, Álvaro Fernández Rojas wrote:
> Some devices may need to perform a reset before using the RNG, such as the
> BCM6368.
> 
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
> ---
>  v3: make resets required if brcm,bcm6368-rng.
>  v2: document reset support.
> 
>  .../devicetree/bindings/rng/brcm,bcm2835.yaml   | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 

My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/rng/brcm,bcm2835.example.dt.yaml: rng@10004180: 'resets' does not match any of the regexes: 'pinctrl-[0-9]+'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml

See https://patchwork.ozlabs.org/patch/1443582

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

