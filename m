Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9252EC54EE9
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Sep 2022 15:09:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbiIVPJA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Sep 2022 11:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231784AbiIVPI5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Sep 2022 11:08:57 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC913E119A
        for <linux-crypto@vger.kernel.org>; Thu, 22 Sep 2022 08:08:55 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id s10so11363416ljp.5
        for <linux-crypto@vger.kernel.org>; Thu, 22 Sep 2022 08:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=XMagaWj+qsBFjnLrI8sBIja14veXFKrlDQYG7XtfNWE=;
        b=DzHeHLFn//JTk6UMm4OPpr3veynEUt1p2tLF3kaAVSP7dhi51cuhKTE8BKS/jNHgju
         G77Ldz5TYdPY4501O0mvoOWrjRKHaDvf79vQr9UAcGAnaVmYZe1+c4oze5GJnMLO3sdb
         0ocnadIuQIcTB6XmIkT0xruxTHb/LUYjvXN248PkKjx2QUKIIT6yrM2t26YxVV+MVr0S
         J5BHjtdYX935OrxlaGMSJbHRcy4SdJgoZfAoyv3rkJ/QLqHXVz0WiNtLts7slfYBfsRk
         YTJALdwyX/ACqmJUvQiUoJZ/FgKzGR/9V3WMDAH7rxTR5RsMc0SQRrobCJ4bTrlcHdSL
         NkXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=XMagaWj+qsBFjnLrI8sBIja14veXFKrlDQYG7XtfNWE=;
        b=BjJbmhENl8zPR1VJDEAVYgOr4qouzfqArxXQufRTJaDTuFuDRfYmcqm1w+Pji82dHQ
         itlUzeM4AVrEhY7qD4uKN6vvoK4Wo3kUe0AZERFKnRrdFJYwfp+D85t3D7qvdR17x/zL
         Dn6AefsSFVufWkmrsDDt4kB02IlctCPKbNJfcJ5jOx1mliy2qGU2TG0wshtmwanJlbMR
         7dXaya884Q7DrDlfhtKicZ2OgdViQc85AsE8i8TBEy3seHoD1RSIsXT83Q1vWLqvqM69
         gkh4XWOlCs8ggL3jHzrTWvZTttrHh+2JC/sYRF80+F2ru6I5/6rX4SWKfcxX6PhoXUmR
         V9ng==
X-Gm-Message-State: ACrzQf0qx5ZD6QAaTV/an9ytxNzdFJhN9rnCCov4gRAPZTovsQckXZ+y
        Jqli7U32NQhLGr1bVfOjykCKmA==
X-Google-Smtp-Source: AMsMyM6Edu7WLfsqQrPewr8KMaHpm8Q9cLMq8zru4YXuHBvZo74OAhVg37Deu8WkRBA+V2L3rckbCA==
X-Received: by 2002:a2e:a7c7:0:b0:26c:4fa4:47f6 with SMTP id x7-20020a2ea7c7000000b0026c4fa447f6mr1266324ljp.171.1663859334226;
        Thu, 22 Sep 2022 08:08:54 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id b22-20020a05651c033600b00268bfa6ffacsm919565ljp.108.2022.09.22.08.08.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Sep 2022 08:08:53 -0700 (PDT)
Message-ID: <29d54940-997a-865a-b9d0-c043a8c9ce99@linaro.org>
Date:   Thu, 22 Sep 2022 17:08:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v1 1/2] dt-bindings: rng: nuvoton,npcm-rng: Add npcm845
 compatible string
Content-Language: en-US
To:     Tomer Maimon <tmaimon77@gmail.com>, avifishman70@gmail.com,
        tali.perry1@gmail.com, joel@jms.id.au, venture@google.com,
        yuenn@google.com, benjaminfair@google.com, olivia@selenic.com,
        herbert@gondor.apana.org.au, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org
Cc:     openbmc@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
References: <20220922142216.17581-1-tmaimon77@gmail.com>
 <20220922142216.17581-2-tmaimon77@gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220922142216.17581-2-tmaimon77@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 22/09/2022 16:22, Tomer Maimon wrote:
> Add a compatible string for Nuvoton BMC NPCM845 RNG.
> 
> Signed-off-by: Tomer Maimon <tmaimon77@gmail.com>
> ---
>  Documentation/devicetree/bindings/rng/nuvoton,npcm-rng.yaml | 4 +++-


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

