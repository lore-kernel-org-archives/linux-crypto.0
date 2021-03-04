Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6609C433DB
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 20:49:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE1D764F77
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 20:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235644AbhCDUs4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Mar 2021 15:48:56 -0500
Received: from mail-ot1-f50.google.com ([209.85.210.50]:32832 "EHLO
        mail-ot1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233550AbhCDUs3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Mar 2021 15:48:29 -0500
Received: by mail-ot1-f50.google.com with SMTP id j8so3214699otc.0;
        Thu, 04 Mar 2021 12:48:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=5AWDMa0Ub2tddxjvezSReCn39zZbL35lDyXyuobd+Vw=;
        b=snk/8ZVSiOZxSWFpQYv10CqqP68BXRaJclgzuEBlNgJmyJJ8q/ownUnQzyri6cp2g3
         ZoRVnDn4ClhugESxffgluFxF7LkQjJ7n5+ZEfjPAEH7vtaiw4WKFmGOcKUds0rakSwXA
         oUAze5aYnxpWHK/9bIiFfITpJmqB4QFjZciAgwTJ7MYUpSUtPeGqUKCEekwP+tA1r3hY
         C2bDNQcMO9wIigg5t14urlnkhxzm1x5X68HrsW2QUz98ldLvQfsFdlil+Hysusnn4kIg
         Yt+wSBDLmGL/uysX/gWG0UAe4+3hmNE5ybJl4N4L+TSMCdpaGUFaG9qe+qIAzaGHKqj5
         VaRg==
X-Gm-Message-State: AOAM53023i7N5juF6JrHCmcFIq3jRq/Hk5PCgFBzakODIF3WKTSwpn56
        DvwiqwQgyBOZtiDyFViipwpjkHlWaQ==
X-Google-Smtp-Source: ABdhPJzNMjwXzRMUqriEzvqRxgRAqHXrkgrZR8sUIgJTVkbNvEoJPHJyiSN926Ze26yiDV78te7z1A==
X-Received: by 2002:a9d:1785:: with SMTP id j5mr5294120otj.31.1614890868679;
        Thu, 04 Mar 2021 12:47:48 -0800 (PST)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id u110sm130280otb.32.2021.03.04.12.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 12:47:46 -0800 (PST)
Received: (nullmailer pid 2778959 invoked by uid 1000);
        Thu, 04 Mar 2021 20:47:29 -0000
From:   Rob Herring <robh@kernel.org>
To:     =?utf-8?q?=C3=81lvaro_Fern=C3=A1ndez_Rojas?= <noltari@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com, Ray Jui <rjui@broadcom.com>,
        Rob Herring <robh+dt@kernel.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        devicetree@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        linux-rpi-kernel@lists.infradead.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Matt Mackall <mpm@selenic.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210304073308.25906-2-noltari@gmail.com>
References: <20210304073308.25906-1-noltari@gmail.com> <20210304073308.25906-2-noltari@gmail.com>
Subject: Re: [PATCH v5 1/2] dt-bindings: rng: bcm2835: document reset support
Date:   Thu, 04 Mar 2021 14:47:29 -0600
Message-Id: <1614890849.112497.2778958.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 04 Mar 2021 08:33:07 +0100, Álvaro Fernández Rojas wrote:
> Some devices may need to perform a reset before using the RNG, such as the
> BCM6368.
> 
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
> ---
>  v5: no changes.
>  v4: pass dt_binding_check.
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

See https://patchwork.ozlabs.org/patch/1447144

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

