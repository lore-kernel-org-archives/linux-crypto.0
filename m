Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4703BEB64DD
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jul 2023 15:51:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232870AbjGFPvZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Jul 2023 11:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232814AbjGFPvG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Jul 2023 11:51:06 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2A126A1
        for <linux-crypto@vger.kernel.org>; Thu,  6 Jul 2023 08:50:32 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-51e28cac164so3241589a12.1
        for <linux-crypto@vger.kernel.org>; Thu, 06 Jul 2023 08:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1688658622; x=1691250622;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XUhfDmggsn5eqK33qgGT6h59DblDFC/G1j0z4SZy8Ck=;
        b=zxr7ERCrDF1RetXZAxvNWoKt4JCwmRD+F7+ab+4uaw9SW9WaCbko3t5b8Ew7vhHlKF
         y/ypmKf9yxgOoqMRvZWTDUcidgZC6ywWzLBF5Itq1qzq0MfVeoDV2jc5TQVpQNjOQjPV
         R+JI78aOEH2PwA5NbGzI1XRtIUFMMeP/GQjkDpiIpnHi0UlmHqFCtk/DOX5L0jZjZPVA
         gL83rWs36sX9zj9hLZf0mWgDY7NGjPg88Wvfbp2ArAI8/+CI+wb5vTuBGUQwFKNSTxad
         bYWlNr2BjvrJaCoq6bbaPvb1cGdjbiZabUizqX5DSuLO4XyxXGmU04fBtwwpDXv4zwRy
         n6bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688658622; x=1691250622;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XUhfDmggsn5eqK33qgGT6h59DblDFC/G1j0z4SZy8Ck=;
        b=kz2m2zb3EAtq7oMeR2b5hci6WtA4dG9dWqKKCv7kUt77Hc/NZvEmCG/d7CQTOC0ViV
         DmcMyruHocHwnLum/m5+LC4fozGxPEjeRIJaAzqu7f44DZPE0A8L52v5Nwz1ujBb7Kc3
         Tgw05Z9gL+ReAwFIY+W0QkjRwBtV0CKgyWsTGN8EEHeRqWOFsoRzksm1fvayzPzuxigF
         C8m+Aan/b6J6Tc/xNRhuJWmc9fshHX6oCLQGmJ21djJsyLIA07By+NSMzxJIWjBLcm42
         znb/VEtUeA7iyosVLyysrZKww1wT1UawW/rDdc2aLRZCLThmif5ralCsetZk0ajfp4rK
         +DPQ==
X-Gm-Message-State: ABy/qLYLbA20KiJ9VfPDZ3zd3+2FSNmVZ6VYnlbDBOgIK1jOsr2OxA2a
        ABGbsnysBTlugVthjDrb+dm0jQ==
X-Google-Smtp-Source: APBJJlHaa8zI+ZK8HBkcP1KU9kxKBZritHwYfobLjVsnf/vocePla9ck7Sg9U8FFsnEDpg6QnVoX9w==
X-Received: by 2002:a17:907:1b1d:b0:98e:1729:aeee with SMTP id mp29-20020a1709071b1d00b0098e1729aeeemr5637800ejc.2.1688658622587;
        Thu, 06 Jul 2023 08:50:22 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id o26-20020a17090608da00b00992f1a3b9bfsm979463eje.170.2023.07.06.08.50.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Jul 2023 08:50:22 -0700 (PDT)
Message-ID: <fc6c219d-1ef2-f59f-ebb1-0a749fbbbc81@linaro.org>
Date:   Thu, 6 Jul 2023 17:50:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 1/7] dt-bindings: crypto: add new compatible for
 stm32-hash
Content-Language: en-US
To:     Thomas BOURGOIN <thomas.bourgoin@foss.st.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Lionel Debieve <lionel.debieve@foss.st.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20230706073719.1156288-1-thomas.bourgoin@foss.st.com>
 <20230706073719.1156288-2-thomas.bourgoin@foss.st.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230706073719.1156288-2-thomas.bourgoin@foss.st.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 06/07/2023 09:37, Thomas BOURGOIN wrote:
> From: Lionel Debieve <lionel.debieve@foss.st.com>
> 
> Add a new compatible for stm32mp13 support.
> 
> Signed-off-by: Lionel Debieve <lionel.debieve@foss.st.com>

Your SoB is missing.

Best regards,
Krzysztof

