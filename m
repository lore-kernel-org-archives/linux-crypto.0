Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0A40C433EF
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Apr 2022 06:21:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbiDEGXN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Apr 2022 02:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbiDEGXN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Apr 2022 02:23:13 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA5C30F49
        for <linux-crypto@vger.kernel.org>; Mon,  4 Apr 2022 23:21:15 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id bh17so24485502ejb.8
        for <linux-crypto@vger.kernel.org>; Mon, 04 Apr 2022 23:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=dFScsEWOIQMzMNWYs3fFmAJMFFVGjdTXWlfZ6OzACcM=;
        b=ThW/SFaboNZtHF1joXB0EOfD3+A0oYJ68xb8vJwAGJJiAGdr5v9cOdv2Dn66J/LFyu
         tDNav6AsyulSZuGIEw7SaLofwLqlZpeX62mUTRZP80YMIBFpCdQj2Z9FyiN3CqOSYQm2
         LalCB5F1uP33hNg9iwBf7oB6uMrnWQNDoPsglXr10xJOBqkYwAjCgqnqd3jj45MnEqDa
         Lg30iUzsG5H5ep1/kiOcndp8nAfuZgbCulVghu/RP2S+rGF53vYqBWYVeYqdV6ixfuza
         RiDXrjpU+PItsGYrqSpREsv+U6svzjtGW0w42psnSUBOu1BB8eBwq0W9Bp7xR8totzeV
         8KAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dFScsEWOIQMzMNWYs3fFmAJMFFVGjdTXWlfZ6OzACcM=;
        b=laNbTcnV8dNEs4euIFI3sXaP8NQuz3CjzrnBfQ04RceONkSRnHs9QKdawMpSrJvQvm
         V9vr74/5GHN0DeW5hIzjAEFLxbcAuJYV5pOX3+XehXzqyNFgCIewEog1X+yAz9Rva7v1
         2ndRsFMn/Da0w2HzztSJaa5QpYFle3RsQDx6TuMtM4Xm60XtZRxk1JHbeW/bo17P+pH4
         uUBgk6dEriEkViSk9uPGwiuIy8FPyokG8vTpOsZmuAyUOSskRyyBqUnD/tOr3lcY1NQ6
         CC2jg+kngaOCgvrddUWwK3bUnQ542ySHTKpxzS8GKVYt7A4lEUJYIGJEPVQ1Q+CLFqu0
         O5CA==
X-Gm-Message-State: AOAM530WVBIx2zT8899Hkzc0R+BH+gsrbKnBlQbogczJHgi96qmQ+FJ3
        3cVR7kEthYTCMud2N7l7qVXmJg==
X-Google-Smtp-Source: ABdhPJyYwzqhusFM2acIFejF6DscmAD/F8UQ9YmVdk9ycgo6D64esQZRZXphTaTK1r5QecxoV/dc7Q==
X-Received: by 2002:a17:906:c145:b0:6da:aaaf:770c with SMTP id dp5-20020a170906c14500b006daaaaf770cmr1919863ejc.504.1649139674388;
        Mon, 04 Apr 2022 23:21:14 -0700 (PDT)
Received: from [192.168.0.179] (xdsl-188-155-201-27.adslplus.ch. [188.155.201.27])
        by smtp.gmail.com with ESMTPSA id f13-20020a50bf0d000000b0041cdd9c9147sm1051481edk.40.2022.04.04.23.21.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Apr 2022 23:21:13 -0700 (PDT)
Message-ID: <12b2cd08-f296-1c48-4ea4-0d119597854e@linaro.org>
Date:   Tue, 5 Apr 2022 08:21:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] dt-bindings: white-space cleanups
Content-Language: en-US
To:     Rob Herring <robh+dt@kernel.org>
Cc:     Krzysztof Kozlowski <krzk+dt@kernel.org>,
        devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Corentin Labbe <clabbe@baylibre.com>
References: <20220402192819.154691-1-krzysztof.kozlowski@linaro.org>
 <CAL_JsqKuFAY4QENRb3dKETKcaJm-fcguoCFOgUnzf0Pwmf1Ezg@mail.gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <CAL_JsqKuFAY4QENRb3dKETKcaJm-fcguoCFOgUnzf0Pwmf1Ezg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 04/04/2022 23:18, Rob Herring wrote:
> On Sat, Apr 2, 2022 at 2:28 PM Krzysztof Kozlowski
> <krzysztof.kozlowski@linaro.org> wrote:
>>
>> Remove trailing white-spaces and trailing blank lines (yamllint when run
>> manually does not like them).
> 
> I assume you mean run without our configuration file. I probably
> disabled the check because I didn't want to go fix everywhere. If we
> are going to fix, then we should enable the check to not get more.

Yes, just "yamllint *yaml".


Best regards,
Krzysztof
