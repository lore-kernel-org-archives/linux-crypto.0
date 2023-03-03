Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A58BC64EC4
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Mar 2023 10:00:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjCCKAu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Mar 2023 05:00:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjCCKAt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Mar 2023 05:00:49 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C06A05B5F5
        for <linux-crypto@vger.kernel.org>; Fri,  3 Mar 2023 02:00:47 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id o12so7987235edb.9
        for <linux-crypto@vger.kernel.org>; Fri, 03 Mar 2023 02:00:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1677837646;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x7ZZKx3KyHfLs8tx//0Kd7ENhPGl8+MuIEtu9zybv2g=;
        b=eY9+aK6YUtdny+sVn2scXcootpBZCveeyIqyzOgqEQzc1QcsiRQYLD5v9212Itif0V
         6rsqLvcqCDalNR/WyY7LajIEsnrNCd1o1E4aoBQjHY5jO5dg90YP19/lqitMl4+o/P5c
         nbY6kb37+Z6k5s62axePcleBSkyiGHAR+f4PqPlLKJbjQFmHuREI/nd/9Yzehianz8p5
         LDsG/7yKQrIT+WaSjzEi/yo6ODAAT8W/RYqK7h5SDUURkq15MnYqKpmmpcrVDF2PGtRh
         Ty2Bc+UMCExD0103c6pEGzOrBJdrG6T9XJzi7AiK//uJ8hpcJVal+LI3l8a9LCDx2pqk
         wICQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677837646;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x7ZZKx3KyHfLs8tx//0Kd7ENhPGl8+MuIEtu9zybv2g=;
        b=M5iY3SNWZ01zMYL4iWYG/ChKAo2sl8xexiVPGIrIhfsIqyRvzJEpugHZGvuRTKEg2o
         cjYF4N1mmucMyL0nPbRmMdBCUu91wRQKCIQj/h1fbPZTii4HLmdlqMhYOHRjJtrr+o3N
         vz1Sprp3cYIqpf3Af/ge1jQcWUiQQVMXeHQ4xf/daGIAcfiDOdt29hm/8wnswOdj1wCY
         EcTBNviIIG3IjSK9fioBxMXTYAAJYe1yAOJI1FtEqhmpSal5hvMLsTOS5oGuzXGZXrcu
         Iqb2AVU9g8c5FcAMDzBYsqhPysEAZHuDv3nBA9Z0EGGGMdnx/t7zCXM1Gghs6MagEI7g
         0sog==
X-Gm-Message-State: AO0yUKX+GdkFj1JwyST45Nx2WOf1jteOTJjS4PR1+FAXQlDFQ077i0su
        NKKu3d2WTm0tUx1+GenbqAcBHg==
X-Google-Smtp-Source: AK7set+vo0njO58meUIbCNRrpMKX4L7lQD1hlqnNFnHEHIkwMN3qm6vEcokdlhXgRr5BieE4o865xQ==
X-Received: by 2002:a17:906:da89:b0:8b1:7de6:e292 with SMTP id xh9-20020a170906da8900b008b17de6e292mr1346342ejb.9.1677837646256;
        Fri, 03 Mar 2023 02:00:46 -0800 (PST)
Received: from [192.168.1.20] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id ay24-20020a170906d29800b0090953b9da51sm761159ejb.194.2023.03.03.02.00.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Mar 2023 02:00:45 -0800 (PST)
Message-ID: <3f147048-4cce-2c5e-6468-db46cd1e8f11@linaro.org>
Date:   Fri, 3 Mar 2023 11:00:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 5/9] dt-bindings: crypto: fsl-sec4-snvs: add simple-mfd
 compatible
Content-Language: en-US
To:     "Peng Fan (OSS)" <peng.fan@oss.nxp.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        horia.geanta@nxp.com, pankaj.gupta@nxp.com, gaurav.jain@nxp.com,
        shawnguo@kernel.org, s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, stefan@agner.ch,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Peng Fan <peng.fan@nxp.com>
References: <20230301015702.3388458-1-peng.fan@oss.nxp.com>
 <20230301015702.3388458-6-peng.fan@oss.nxp.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230301015702.3388458-6-peng.fan@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 01/03/2023 02:56, Peng Fan (OSS) wrote:
> From: Peng Fan <peng.fan@nxp.com>
> 
> All the current vfxxx and i.MX device tree has simple-mfd as compatible,
> and it indeed supports RTC and ON/OFF key multi function, so add the
> compatible.

Paste it to Google Doc or Google GMail (with extended language
spellcheck/suggestions) and fix the grammar, please. Can be also any
other service, dunno.


Best regards,
Krzysztof

