Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C9ABC6FD19
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Mar 2023 06:40:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbjCFGkM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 Mar 2023 01:40:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjCFGkL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Mar 2023 01:40:11 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5393ECC0B
        for <linux-crypto@vger.kernel.org>; Sun,  5 Mar 2023 22:40:10 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id da10so34185736edb.3
        for <linux-crypto@vger.kernel.org>; Sun, 05 Mar 2023 22:40:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678084809;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g0uHF9zbKg9xgGKwpWcbugNvxA7barkTYqPCS14uJCo=;
        b=VbE4JMgrkkl1MBtWejm+B80EuU0h9oiIsNHafwLTvSN6MDfwod2pHIbSFlOhkxSq5Z
         InHrMN7yCJvx+qXa0zoSe16OEzVamDvSbfeohWZHc9QRx/rFJ8JAvK9ceYSYasN2t1Sf
         PlZdn566afyWm6RvagBWWBCUDxPld3nUGPzdk6rVC0ez2Tc5LuADp14mJVt4lRF8hgIH
         mYMwUI1N7Voe+9VKEKwfgyWkH7AnmRGc5iuLsq22KaEe65km2y3oCe4+kCp3PPJGjCRl
         kRTpB/Tt6WcHWGH0AF+JGFyvEh4N1gwPaYeZf1BX5HH7nPIuiQIfOwLGtPP48+vv2gVa
         VrFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678084809;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g0uHF9zbKg9xgGKwpWcbugNvxA7barkTYqPCS14uJCo=;
        b=M06+ZSUehOWxAzNzmX4c28B7EQZq1FNkf37VTNyXSwgGM1HmXTOysBEDhen2IFoghF
         kxwMJd4I10O6N726g3WQD57t6WMWdTJysQlOoGT+4pN0LjvfgvqyVQpNMx3sRGc3c9uS
         xwj1XKU0fwFC/aHvRYq03SpRRxNvmrxcxt2WsT/ktKZLx73OkMwpuFJO8Fx1BvtxlRjx
         U1GBJ2KuyshPbCUp5Scyt1wehgGzGGNgKq36oejJLeyZ8KgoVSkJK9Rs5/5uyrDvpROi
         kTxCblz21ciZWAbYRqKOO4mRfxPiZIdD1Wk79JLkHBfxUH4/FZNANVmY9a6yXo111SA8
         qQkA==
X-Gm-Message-State: AO0yUKUEiYK+761B7m9a5RWAHjvYD+3R33Fs0Y7xMqqoo4b9nikIOSE7
        3paDy0AO+VJ44A02rFi1HDitFOfPg4fZGoxahag=
X-Google-Smtp-Source: AK7set+6bC7/gAUXyQTO7c8DnH6zWltFHUoEf51GIWHyj5fNPnCguigPLn4YgHzvAa/+o6mgAp4Lzw==
X-Received: by 2002:a17:906:9451:b0:8e1:d996:dca2 with SMTP id z17-20020a170906945100b008e1d996dca2mr8961058ejx.64.1678084808873;
        Sun, 05 Mar 2023 22:40:08 -0800 (PST)
Received: from ?IPV6:2a02:810d:15c0:828:d85d:5a4b:9830:fcfe? ([2a02:810d:15c0:828:d85d:5a4b:9830:fcfe])
        by smtp.gmail.com with ESMTPSA id f3-20020a170906738300b008cf377e8795sm4125659ejl.199.2023.03.05.22.40.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Mar 2023 22:40:08 -0800 (PST)
Message-ID: <a5db2529-6f45-1267-bc08-019059cf29d2@linaro.org>
Date:   Mon, 6 Mar 2023 07:40:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 4/6] ARM: dts: imx6ul: Fix second GPT compatible
Content-Language: en-US
To:     Stefan Wahren <stefan.wahren@i2se.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>
Cc:     linux-imx@nxp.com, Marek Vasut <marex@denx.de>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        linux-crypto@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20230305225901.7119-1-stefan.wahren@i2se.com>
 <20230305225901.7119-5-stefan.wahren@i2se.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230305225901.7119-5-stefan.wahren@i2se.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 05/03/2023 23:58, Stefan Wahren wrote:
> According to the imxgpt DT schema all i.MX6 GPT IP is

That's not true... you just changed the bindings to say that.

> derived from imx6dl. So fix the imx6ul DTS accordingly
> and avoid dtbs_check warnings.
> 
> Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
> ---
>  arch/arm/boot/dts/imx6ul.dtsi | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/imx6ul.dtsi b/arch/arm/boot/dts/imx6ul.dtsi
> index f0a9139748b8..65b2c6c131b3 100644
> --- a/arch/arm/boot/dts/imx6ul.dtsi
> +++ b/arch/arm/boot/dts/imx6ul.dtsi
> @@ -448,7 +448,7 @@ can2: can@2094000 {
>  			};
>  
>  			gpt1: timer@2098000 {
> -				compatible = "fsl,imx6ul-gpt", "fsl,imx6sx-gpt";
> +				compatible = "fsl,imx6ul-gpt", "fsl,imx6dl-gpt";


Best regards,
Krzysztof

