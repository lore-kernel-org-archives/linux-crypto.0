Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 295FBCA5537
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Sep 2023 15:56:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbjIMP4G (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Sep 2023 11:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjIMP4F (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Sep 2023 11:56:05 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD52592
        for <linux-crypto@vger.kernel.org>; Wed, 13 Sep 2023 08:56:00 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-52a5c0d949eso8802276a12.0
        for <linux-crypto@vger.kernel.org>; Wed, 13 Sep 2023 08:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694620559; x=1695225359; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tv7XJDdl6834GzjvqOGD358bBmTKqyHRIi14XwGDvOI=;
        b=J2ZjKir7vSkCqej4qUKm9JqDXFoT3PvKmsv/mv6U/czvSP7bf8ftGLzee73NxJP+gk
         muLEKF7m7KNI9Wl3TpPNyJDuj5qZOXESe4jSSvqmC0dDtmLD1QEvu7j66M+8VIYtlQ0j
         dR45cjAK0vNDU8gNLOzk6nJ/NDneEnoH3nRwWL/TX1hrVpolaWE6XFhuPQj6uffCvGJ8
         uH6eSAio+IAKamfGng+FrJ3AzOwZ1kviURh2oMu6xO9qLZPWyorsKXW7fEs88BQq95f1
         FZaErb1KZSIxGD/C5QtttikCfdUbyEmBfICeKi9FR9ECMkVcgWQWxwFHIJgzvWn18h2h
         vX8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694620559; x=1695225359;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tv7XJDdl6834GzjvqOGD358bBmTKqyHRIi14XwGDvOI=;
        b=eKqBP4kqINotL3gLBEHMuVJA2sWJhaulx86BOgfIUk9JbAYpWTH5hUjb068Im1rWz/
         Gh6dJQLkPQ6jKscrsOs3k6XrpGauOe/Q9dO2Ci51H1739WP/bRCKgreTFxLrHg8GcSrc
         /EVtDkGz+H6W5CppyQo5omQBBxxTGvpsvXJXdiv0G39pXagJOpFSeTQp202Nj6KwVMDG
         v+WCdlA6x9ZLDH1A0a6ihGCQfkWPgZUOKtilvebywDk9BtpSJzP+uMyOpqT/syW5OZzd
         1dOs0tpi3CkYP1IqHbYm5TtvitDf86606pbKaHtbLHAwDbKdSBx1IUG0jQ6eP+Iqr4xT
         2ysw==
X-Gm-Message-State: AOJu0Yy6NvBGLx70QSFhJQYFh7vjA5q6UIUmV5/Pg2iHf2Lt28UUNJ/Y
        ocpz4Rce9OGOnUGIA1f4GQ+v/A==
X-Google-Smtp-Source: AGHT+IHBr64ssqYpCba2U1MbEZa4hifW1e1oF7df36c+VnVjR01KmwawFQH8SGOjBmUtG5VCp8p4kw==
X-Received: by 2002:aa7:c90c:0:b0:523:1ce9:1f41 with SMTP id b12-20020aa7c90c000000b005231ce91f41mr2521929edt.18.1694620559143;
        Wed, 13 Sep 2023 08:55:59 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.214.188])
        by smtp.gmail.com with ESMTPSA id m16-20020aa7c490000000b005236410a16bsm7565230edq.35.2023.09.13.08.55.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Sep 2023 08:55:58 -0700 (PDT)
Message-ID: <c574c47e-9ceb-ef83-cc92-cdc6cd4982e5@linaro.org>
Date:   Wed, 13 Sep 2023 17:55:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH 1/2] dt-bindings: crypto: ice: document the sa8775p inline
 crypto engine
Content-Language: en-US
To:     Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230913153529.32777-1-bartosz.golaszewski@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230913153529.32777-1-bartosz.golaszewski@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 13/09/2023 17:35, Bartosz Golaszewski wrote:
> Add the compatible string for QCom ICE on sa8775p SoCs.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> ---

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

