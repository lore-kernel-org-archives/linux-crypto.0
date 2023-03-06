Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9353C61DA4
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Mar 2023 06:39:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjCFGjd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 Mar 2023 01:39:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjCFGjc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Mar 2023 01:39:32 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C04FB464
        for <linux-crypto@vger.kernel.org>; Sun,  5 Mar 2023 22:39:31 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id j11so14570894edq.4
        for <linux-crypto@vger.kernel.org>; Sun, 05 Mar 2023 22:39:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678084769;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QoODGAop32C8lwG/ZsAF6/KbEr4EiEI2mPCbHIBExeA=;
        b=OSpM28SUK7Y9KkB6/Cyi4I9Sng13qxn1E48hWvDY/t8kEoh4msfcl+slmTe/OKYEOd
         h1BBrdXbCtHkolhmHz5n8yymlwaGJSgJ0KNG+UhrvFqrYaBH0Ya0MprrtQkQnGoiiVM0
         QCZi+4K4t2T6nYkwJyiv/iKun3+B+qToTYd1IZhtvuityr4rEmqCw0a9sw/H3EV2nmAN
         Oh9pcDKe+3v9r5mTnR00RV2nb/QNS8cxA9m8eBDq/Ka2VJKVR1F136Q6Pw72zQmoHYqy
         nmHQFHRwVundmmohCSGA7umVz5BLMRgue+GEy2k+g9HR7O2NKKKzReXcxvzV3p4ZLvgA
         337g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678084769;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QoODGAop32C8lwG/ZsAF6/KbEr4EiEI2mPCbHIBExeA=;
        b=0LyjS0Qyf1m2GwJ+s/2sOzXoktRtY0SkxHIoirRCHaxNP6/NRRvuvEliqIzjEMVHBn
         631hkK13jK2MEhmytE6cv7kALYZJRMdZHg6uMOVub3hxMutvmhnft6Q4/07ub7i1PTVH
         y7PyFxNC3jNx6uTn9vAGg5zfxR7Kb7h3iWuvjly81jfS9a6TyuaTbzYaMkKxMA296FHr
         3E/JedP9j2R/1LhFYN7Mc1D0Rh2gQD9jAqKcbnwUpNSdqpqlw0Vrgj3MNXSPSMQZmAwt
         UNg1Fs2lfUxHgge0KXU3lg4Xyq+MXvJFjPjldritBVfwMUz8tepBlk6v9YOpydIhPiuW
         SBPQ==
X-Gm-Message-State: AO0yUKXJnCxnWbyrO/jsChMdxHjChLtKp4WTB/NzIayY1oXQaj0w7zaH
        km5MXoAzXKd9D12zEAtivrizSg==
X-Google-Smtp-Source: AK7set8wx3sQVDbbd21KAFPmnVn3+XIqLcYK5H3vlap2MJ7SgypT5S30lBimrsYR3AbFnllpwGbKEw==
X-Received: by 2002:aa7:db53:0:b0:4b0:616d:48a8 with SMTP id n19-20020aa7db53000000b004b0616d48a8mr9223875edt.16.1678084769732;
        Sun, 05 Mar 2023 22:39:29 -0800 (PST)
Received: from ?IPV6:2a02:810d:15c0:828:d85d:5a4b:9830:fcfe? ([2a02:810d:15c0:828:d85d:5a4b:9830:fcfe])
        by smtp.gmail.com with ESMTPSA id d25-20020a50cd59000000b004bc422b58a2sm4606059edj.88.2023.03.05.22.39.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Mar 2023 22:39:29 -0800 (PST)
Message-ID: <1032d552-e69e-632f-be1c-b8f6972b6f61@linaro.org>
Date:   Mon, 6 Mar 2023 07:39:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 3/6] dt-bindings: imxgpt: add imx6ul compatible
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
 <20230305225901.7119-4-stefan.wahren@i2se.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230305225901.7119-4-stefan.wahren@i2se.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 05/03/2023 23:58, Stefan Wahren wrote:
> Currently the dtbs_check for imx6ul generates warnings like this:
> 
> ['fsl,imx6ul-gpt', 'fsl,imx6sx-gpt'] is too long
> 
> Since the imx6ul GPT IP is compatible to imx6dl, add the compatible
> to the enum. The mentioned warning also needs adjustment of the
> affected DTS, but this should be done in a different patch.
> 

Unfortunately I do not understand it. Your next commit says - according
to DT schema - while the bindings do not suggest any compatibility here
for imx6ul. It seems you make a change and then justify with it another
change (next commit). Instead please justify both commits - this and
next - with proper real explanation, what is compatible with what.

Best regards,
Krzysztof

