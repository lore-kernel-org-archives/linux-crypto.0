Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21DEFEB64D8
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Jun 2023 09:22:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232242AbjFVJWO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Jun 2023 05:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjFVJVm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Jun 2023 05:21:42 -0400
Received: from mail-vk1-xa36.google.com (mail-vk1-xa36.google.com [IPv6:2607:f8b0:4864:20::a36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A14465B4
        for <linux-crypto@vger.kernel.org>; Thu, 22 Jun 2023 02:12:11 -0700 (PDT)
Received: by mail-vk1-xa36.google.com with SMTP id 71dfb90a1353d-4717a1d07fdso1786023e0c.1
        for <linux-crypto@vger.kernel.org>; Thu, 22 Jun 2023 02:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687425130; x=1690017130;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LAUOQODzdCeUTcrDvoPMBORZt9+ufR2Q6MlQ8V9HqcA=;
        b=mXPKXfCQ5AqfGGN7eLis7zio/LUO4dolZMn9tGoBWo9lQ/0YSYOantIpV+5Aknn1uh
         3J4AAW5FwrtrCjPqExngKvRZGdsEMMnXiWLjxSlxcZ4Z4hrIKAqnf3JGXGjDgW9P3bL1
         pFNgcMjEIcXauA2TF31JXquLUpbL+xqhM2fQ9hmTnukCcFG1Mle2eakMHU8X4YmkO6LO
         bAhMo5m/gWYLFCsmeuIdoTLd4aVKzBQXkX6znVpbHzzsNtQEyUyVQaAV7jfwZ4Hpde4C
         pcPlmHg9x/K3XVnBI0Byou5ihxHLvg+InoKTxxb2YQ/iI8WDHTP84M7mjcSJauXDobPV
         PPNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687425130; x=1690017130;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LAUOQODzdCeUTcrDvoPMBORZt9+ufR2Q6MlQ8V9HqcA=;
        b=VmCwotqRixftTCwS2M8lliDNEXQleODPJhVVnQRu9DXYFkwpbp4zsxo8IuYwEdr8WU
         bileb6PTO7rDC2MmRd44ndlQajL+36nele4gK1X9tbY/MY2xyTO+3+7n95odGOU+eqt2
         oIJL1rZSQvbQnEyGQakSdtEV1bkHULIFrnKqfsfkSE8esZXNJ7EjA+iNfd7Jlufnx7V4
         dj/DLU+PEbJJeB2Zd/+bIFRL6n/7a9iD5RQh2mAfLfeLYg+Z6u9urVCItS2c2P0G92E/
         2QzO6rJrFn5ekbmWQlZahdkNDNS8mnZi0v09xRi/84pS95E7edea8+k6x2XQxdHoeB0O
         pUag==
X-Gm-Message-State: AC+VfDxepLQydQtZ3/oF/5lArVHjB2Z2wrZ1YXALlT7ff3no/JJEi5ds
        x8KvW+iBM1wtevil/Q4l9LgWMkt7PXksNKSIQcCP2A==
X-Google-Smtp-Source: ACHHUZ7Jjoae1j3de5QaDkn+NVntLKV6op75KhbpCaUpXW852Raha07Xg8nXWZ9iLhTkIRdAW16BPNsvDSHUyHVrFYM=
X-Received: by 2002:a1f:4801:0:b0:471:cfa1:5065 with SMTP id
 v1-20020a1f4801000000b00471cfa15065mr4808788vka.3.1687425130628; Thu, 22 Jun
 2023 02:12:10 -0700 (PDT)
MIME-Version: 1.0
References: <20230621093245.78130-1-o.rempel@pengutronix.de> <20230621093245.78130-2-o.rempel@pengutronix.de>
In-Reply-To: <20230621093245.78130-2-o.rempel@pengutronix.de>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Thu, 22 Jun 2023 11:11:33 +0200
Message-ID: <CAPDyKFqYfuQNCTPiEM56jrzUBe2jevY+MuTOj6K-7OkpO0_daA@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] dt-bindings: mmc: fsl-imx-esdhc: Add imx6ul support
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Abel Vesa <abelvesa@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        kernel@pengutronix.de, Peng Fan <peng.fan@nxp.com>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Trimarchi <michael@amarulasolutions.com>,
        Mark Brown <broonie@kernel.org>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        Marek Vasut <marex@denx.de>, linux-clk@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-input@vger.kernel.org, linux-mmc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 21 Jun 2023 at 11:32, Oleksij Rempel <o.rempel@pengutronix.de> wrote:
>
> Add the 'fsl,imx6ul-usdhc' value to the compatible properties list in
> the fsl-imx-esdhc.yaml file. This is required to match the compatible
> strings present in the 'mmc@2190000' node of 'imx6ul-prti6g.dtb'. This
> commit addresses the following dtbs_check warning:
> imx6ul-prti6g.dtb:0:0: /soc/bus@2100000/mmc@2190000: failed to match any schema with compatible: ['fsl,imx6ul-usdhc', 'fsl,imx6sx-usdhc']
>
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Applied for next, thanks!

Kind regards
Uffe


> ---
>  Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.yaml | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.yaml b/Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.yaml
> index fbfd822b92707..82eb7a24c8578 100644
> --- a/Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.yaml
> +++ b/Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.yaml
> @@ -42,6 +42,7 @@ properties:
>            - enum:
>                - fsl,imx6sll-usdhc
>                - fsl,imx6ull-usdhc
> +              - fsl,imx6ul-usdhc
>            - const: fsl,imx6sx-usdhc
>        - items:
>            - const: fsl,imx7d-usdhc
> --
> 2.39.2
>
