Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51B59C6FA86
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Sep 2022 15:08:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbiIVPIk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Sep 2022 11:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231722AbiIVPIi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Sep 2022 11:08:38 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDFDEE119A
        for <linux-crypto@vger.kernel.org>; Thu, 22 Sep 2022 08:08:37 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id a14so11357561ljj.8
        for <linux-crypto@vger.kernel.org>; Thu, 22 Sep 2022 08:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=W3vQjpL7ZnOEsk11xcAIlC0+5dqOSVrvKlDZwfBKfy0=;
        b=Sy4HPnU+8WeIlCPD1a3QGFYQ+B961P/HPkm5OwWMBlt94OoZG5FSmVTwp22I5HlS4b
         ctDSD5lE9UqypAqzV3Ye2vSeu/qR6hFaWgosV5Cvs6BZR4QSNF+sJMcfgBXL6Nc+HhUH
         rjv0UT7ps7zRElHe2o3+Bt/qJUaoHrxv9ned93Zmkiim4eW/IF7PQivZnpyU/X6TYm3x
         Oh1ifevg6nyKn8raMVC7CsTkJZhlHoyE8tiA7A/rKM9prCbIBmaGyy05vsnNlvWs23sN
         RuehK72x1PFy9EBkbKt+jYGu3oEHCjUeV+8nGz51JPSTnJQEPgfSdVXwlxvTp6W9g1s4
         odrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=W3vQjpL7ZnOEsk11xcAIlC0+5dqOSVrvKlDZwfBKfy0=;
        b=aqquB/EXI0FFYlQSx3NvCnHAKTcu586KYpfUXtvRVbNQQaF1PsIq5WTEswUq1y04cA
         IPcKDckya4LRxiWeIVAZU9uoMVXrp2oMyDWip7zQpv0uRxqCvB7CyNjJyGH29vMuQ/H0
         R9pxrqRkXmhw04AMZR1Mx7GTQMFL6BrMwxcH/HIBD1BLIopMWFNfpo2FPMKRj2zN8iuC
         nrM4N8jS3OB7z+hwtabFvn2gTa7a78P8vVJ/rbzlG/IOMDIfVKPzYTT+PWwveaLO+fE0
         Ekx6/MWaDwQSrZ2h9JjT2MPnc0lkptc4zqpfrcGsahBHS9nizOAvy6SDUk4l2heFT9bO
         yoFw==
X-Gm-Message-State: ACrzQf3Lqwot7VPvliSOvvnhZRA6nKfz6rJPs98zbGnMskjmAHqIprXP
        wUk23aWopw3q6eOJ9xLUmm7AJQ==
X-Google-Smtp-Source: AMsMyM4ZLEtwzvNmvLE0cJjaCdT/ninGxqDvzBTCYY81SoYE7F/67rI94RH0F1rBn1/sklyiISA3JQ==
X-Received: by 2002:a2e:a228:0:b0:26c:5aa5:bdc5 with SMTP id i8-20020a2ea228000000b0026c5aa5bdc5mr1202937ljm.418.1663859316068;
        Thu, 22 Sep 2022 08:08:36 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id 11-20020a05651c128b00b0026c42f67eb8sm963196ljc.7.2022.09.22.08.08.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Sep 2022 08:08:35 -0700 (PDT)
Message-ID: <21cc4e52-d0d9-8f07-fa74-ea62bb01432a@linaro.org>
Date:   Thu, 22 Sep 2022 17:08:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v1 2/2] hwrng: npcm: Add NPCM8XX support
Content-Language: en-US
To:     Tomer Maimon <tmaimon77@gmail.com>, avifishman70@gmail.com,
        tali.perry1@gmail.com, joel@jms.id.au, venture@google.com,
        yuenn@google.com, benjaminfair@google.com, olivia@selenic.com,
        herbert@gondor.apana.org.au, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org
Cc:     openbmc@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
References: <20220922142216.17581-1-tmaimon77@gmail.com>
 <20220922142216.17581-3-tmaimon77@gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220922142216.17581-3-tmaimon77@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 22/09/2022 16:22, Tomer Maimon wrote:
>  static int npcm_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
> @@ -102,6 +103,11 @@ static int npcm_rng_probe(struct platform_device *pdev)
>  	pm_runtime_use_autosuspend(&pdev->dev);
>  	pm_runtime_enable(&pdev->dev);
>  
> +	if (of_device_is_compatible(pdev->dev.of_node, "nuvoton,npcm750-rng"))
> +		priv->clkp = NPCM_RNG_CLK_SET_25MHZ;
> +	if (of_device_is_compatible(pdev->dev.of_node, "nuvoton,npcm845-rng"))
> +		priv->clkp = NPCM_RNG_CLK_SET_62_5MHZ;

No, don't sprinkle compatibles here and there. Driver data is for this.



Best regards,
Krzysztof

