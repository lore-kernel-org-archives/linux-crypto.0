Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88080CCA48A
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jul 2022 22:42:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237608AbiGYWl7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jul 2022 18:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237658AbiGYWln (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jul 2022 18:41:43 -0400
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A2C8275EE;
        Mon, 25 Jul 2022 15:39:01 -0700 (PDT)
Received: by mail-oi1-f171.google.com with SMTP id n133so5050748oib.0;
        Mon, 25 Jul 2022 15:39:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=w7FxtvFFf34t5r5MspsAdF6ejzut5rmIbeeWhBNszsk=;
        b=7ofqdrd2DVgHYYm6V3N7ionoTAm83ee0ZGxLIw1cVy8XeloG4tylkOpnEDTamCUt0u
         lZifD4LaoDtVzEdmew6vmOq4TWfHU8DN99vAR7yin5/JaMyGU+csK2prq7DMdF9YvGI4
         T8Yr7nAT3Av8KhTWzdG3lIAxsyleozeFGBY0yddOnrmXBjhSzaXxBXSBTek1VSIJQwMG
         eEd01XrE1xuNpgrDpFHyXgK3fy6tb4e67pKKso+4m+Qc574Qv41JRsECbPnUk95QZnXH
         y3Xk+rE4djKT6LsyPH1aZH6lgLdEVduI+CbpTkOWT8aNxzWrfztU9YaOoLg+tfTP/H91
         G+TA==
X-Gm-Message-State: AJIora8cSSdwkGlmGc80mvQVv/ebjXtUWn3MSsZcDgKWPJtTU7pY4NyB
        6gkzfWZJIo/UIXtYSH+WJA==
X-Google-Smtp-Source: AGRyM1v6/ZFtxGEc5L9KVu1Lgd4C63p2v2JuY18JC+fh1GxnzBafN02CL3keRAK9CglDbihJ7VltAQ==
X-Received: by 2002:a54:458b:0:b0:33a:74a7:4271 with SMTP id z11-20020a54458b000000b0033a74a74271mr6406409oib.287.1658788690861;
        Mon, 25 Jul 2022 15:38:10 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id c17-20020a056870b29100b000e686d1386dsm6847741oao.7.2022.07.25.15.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 15:38:10 -0700 (PDT)
Received: (nullmailer pid 2874904 invoked by uid 1000);
        Mon, 25 Jul 2022 22:38:09 -0000
Date:   Mon, 25 Jul 2022 16:38:09 -0600
From:   Rob Herring <robh@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Lionel Debieve <lionel.debieve@foss.st.com>,
        phone-devel@vger.kernel.org, devicetree@vger.kernel.org,
        Stefan Hansson <newbyte@disroot.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] dt-bindings: crypto: Add ST-Ericsson Ux500 CRYP
Message-ID: <20220725223809.GA2874868-robh@kernel.org>
References: <20220721163010.1060062-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220721163010.1060062-1-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 21 Jul 2022 18:30:10 +0200, Linus Walleij wrote:
> This adds device tree bindings for the Ux500 CRYP block.
> 
> This has been used for ages in the kernel device tree for
> Ux500 but was never documented, so fill in the gap.
> 
> Cc: devicetree@vger.kernel.org
> Cc: Lionel Debieve <lionel.debieve@foss.st.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> The relationship to the existing STM32 CRYP block is pretty
> obvious when looking at the register map. If preferred, I
> can just extend the STM32 bindings with these extra
> (generic) properties and compatibles as well.
> ---
>  .../crypto/stericsson,ux500-cryp.yaml         | 67 +++++++++++++++++++
>  1 file changed, 67 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/stericsson,ux500-cryp.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
