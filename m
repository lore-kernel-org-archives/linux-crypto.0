Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B02F7C61DA4
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Feb 2023 13:53:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbjBBNx6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Feb 2023 08:53:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbjBBNxz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Feb 2023 08:53:55 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E24625E18
        for <linux-crypto@vger.kernel.org>; Thu,  2 Feb 2023 05:53:54 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id q5so1821250wrv.0
        for <linux-crypto@vger.kernel.org>; Thu, 02 Feb 2023 05:53:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x6jPPRzCymygBdtkYK+PVPRo7vQuaUfKjd8hJMNHQBs=;
        b=c9PQ9kV/8Paq3Y3yhbFzRBhrvjoelncuq/NevOVnVfPB6kIwAU3sMzwb8nTaq4ZY1J
         92YonJrjz47xmBSMIpyCebNbH3+krAkk+lZYnzREX2mulIZku5wFqirdHqvSB7bPyqFM
         dvVixQZrlews8F+sKpabikRVbVVe5jtO8t2K4tJpNDTHOfmHYdfhy4u3jNonsN0GYYtT
         y1oLBLbo3uBydgUjf6aK4N9+hbKJel9yOj3qbbwpAH4DDUlRv/5qxvSX3ZQ1RiwxvJvl
         YdVz9onEiMBA/0Z+mgB6piNQfCETSJ7yHrbc4k1lFwtt5V8R6tLo9OoXmwENIXS5NTBS
         Qzfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x6jPPRzCymygBdtkYK+PVPRo7vQuaUfKjd8hJMNHQBs=;
        b=RDRV7MdP7p0KgGVmzCIBgF0EBajA5OmkrfhBFTg6Go09dgrimPt+VWpnT5fKhh+3vc
         xJEd8VBzZnC60EHKkH4XuGTT+akx++99wNLRGAntoo5fWr9iQVGlvkNKPDnVY6ED5wls
         XHetoOphVfgGrfkSDkFXSbDFn7P55jZ4lRfTxu7ledvStUi0zm1RtP3ijgLmiM9UW1CI
         ISNtAnbVp19SqsBqwYG4ts81ybYcOloQdT4mzFtltAJYfeRnlZUlqR7yFdThVQ2O0a1R
         IfnwuD0wOMUWb41qbw3kK7lbm7ifZUUdy6nnC8MGPDAiKVPcg6qaZWgEE6O8GBwTVHhl
         TJ/w==
X-Gm-Message-State: AO0yUKVGGbDfT4dGnwtpbLFF/svK1swNCWJ/yV7tjnj+Oj2FdmTNMnip
        TTvPxiNgkwl+8PZ+xPjC8wbcqg==
X-Google-Smtp-Source: AK7set/MPPeZpuw7Mk30vtkJlm8zPLV7xBjKZzvi3W5HtgEcuaIs0nclq0JE/8HvZTbi7b+P8nYJPA==
X-Received: by 2002:a5d:67cd:0:b0:2bf:b0e6:f463 with SMTP id n13-20020a5d67cd000000b002bfb0e6f463mr4661026wrw.13.1675346032814;
        Thu, 02 Feb 2023 05:53:52 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id n5-20020a5d4c45000000b002be4ff0c917sm19874807wrt.84.2023.02.02.05.53.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Feb 2023 05:53:52 -0800 (PST)
Message-ID: <32c23da1-45f0-82a4-362d-ae5c06660e20@linaro.org>
Date:   Thu, 2 Feb 2023 14:53:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v8 5/9] dt-bindings: qcom-qce: document clocks and
 clock-names as optional
Content-Language: en-US
To:     Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Andy Gross <agross@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Neil Armstrong <neil.armstrong@linaro.org>
References: <20230202135036.2635376-1-vladimir.zapolskiy@linaro.org>
 <20230202135036.2635376-6-vladimir.zapolskiy@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230202135036.2635376-6-vladimir.zapolskiy@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 02/02/2023 14:50, Vladimir Zapolskiy wrote:
> From: Neil Armstrong <neil.armstrong@linaro.org>
> 
> On certain Snapdragon processors, the crypto engine clocks are enabled by
> default by security firmware.

Then probably we should not require them only on these variants.

Best regards,
Krzysztof

