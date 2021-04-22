Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A26C7C43460
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Apr 2021 10:46:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BAFC613D8
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Apr 2021 10:46:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235796AbhDVKrW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Apr 2021 06:47:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59782 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235455AbhDVKrW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Apr 2021 06:47:22 -0400
Received: from mail-wr1-f72.google.com ([209.85.221.72])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lZWr9-00068R-3r
        for linux-crypto@vger.kernel.org; Thu, 22 Apr 2021 10:46:47 +0000
Received: by mail-wr1-f72.google.com with SMTP id t18-20020adfdc120000b02900ffe4432d8bso13662416wri.6
        for <linux-crypto@vger.kernel.org>; Thu, 22 Apr 2021 03:46:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ChgsWVHouphJpIEvBcUP4TDV1Lb1Y7MqOzirYiGZuls=;
        b=DBezJGxR4Alx1Q9z7XDieZk7RWm19q0dSLbbaKvoCh01USJEFboniTsKRe2X9Ew1kA
         YT/7oyMlcn/+w+64a6aRSB9R7n3k3hfXeTbhWlySepnTijq2WHoaoT/IZK2HXCpqnhLx
         ZPtcfDnye0Jw0dxsO5RALGyyAbmogkKGn6CqhVCrzg/Vfpfi8g5op0mzLIQ/B44ZIrU4
         0QDNcoVXKVkt4ZEqAbLaRXbod7NZ8S07iuqTyN85TRG6/Rg1fHuGqH2oRg514A7LpCgw
         NguDoN6fiyVLOBQwyefnYzOaXQTFozqI5XFTQ4w12XjLJKwzxP2c5SPS0+rfbPKko5+t
         AdAw==
X-Gm-Message-State: AOAM532Ds2NBBHbunp9q5A3hGrj4jR5W2MRtnGXZXYRnQBuaWEy2ATsd
        l4v1WI/QnB92obcn0JzAQBz8VhFDw+6A1U5RvL5K5Bj6vZh1E0nF+tXaaRXKGyUDJ884pUbPsLm
        e982ZMkqxiyo6EWCjpRHFlNZDEyIgqx5MI+W6EK6BCA==
X-Received: by 2002:a7b:c454:: with SMTP id l20mr14904423wmi.65.1619088406323;
        Thu, 22 Apr 2021 03:46:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwriIvSyixOuWHVrmtzdeZk8A0gu9EIEm+2/cX2GME4GssfKx9dIbuacbeZx9u7Rg6czj93yA==
X-Received: by 2002:a7b:c454:: with SMTP id l20mr14904416wmi.65.1619088406202;
        Thu, 22 Apr 2021 03:46:46 -0700 (PDT)
Received: from [192.168.1.115] (xdsl-188-155-180-75.adslplus.ch. [188.155.180.75])
        by smtp.gmail.com with ESMTPSA id h17sm2936241wru.67.2021.04.22.03.46.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 03:46:44 -0700 (PDT)
Subject: Re: [PATCH v2] hwrng: exynos - Fix runtime PM imbalance on error
To:     =?UTF-8?Q?=c5=81ukasz_Stelmach?= <l.stelmach@samsung.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     =?UTF-8?Q?Bart=c5=82omiej_=c5=bbolnierkiewicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
References: <CGME20210422104145eucas1p17f46c95b72f3568761a9f7911bf072e1@eucas1p1.samsung.com>
 <20210422104141.17668-1-l.stelmach@samsung.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <bc20ae4c-3e62-7b07-506c-ce8d90f65754@canonical.com>
Date:   Thu, 22 Apr 2021 12:46:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210422104141.17668-1-l.stelmach@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 22/04/2021 12:41, Łukasz Stelmach wrote:
> pm_runtime_get_sync() increments the runtime PM usage counter even
> the call returns an error code. Thus a pairing decrement is needed
> on the error handling path to keep the counter balanced.

It's exactly the same as Dinghao's patch:
https://lore.kernel.org/linux-samsung-soc/20200522011659.26727-1-dinghao.liu@zju.edu.cn/
which you reviewed. It has even the same commit msg
(although it's difficult to be creative here).

I think it's better to resend his patch instead.



Best regards,
Krzysztof
