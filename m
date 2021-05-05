Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2D61C433ED
	for <linux-crypto@archiver.kernel.org>; Wed,  5 May 2021 19:46:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C05A3613B4
	for <linux-crypto@archiver.kernel.org>; Wed,  5 May 2021 19:46:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233368AbhEETrj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 May 2021 15:47:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36825 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233309AbhEETrj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 May 2021 15:47:39 -0400
Received: from mail-qt1-f197.google.com ([209.85.160.197])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1leNTl-0003Sh-QB
        for linux-crypto@vger.kernel.org; Wed, 05 May 2021 19:46:41 +0000
Received: by mail-qt1-f197.google.com with SMTP id g21-20020ac86f150000b02901c94e794dd7so1797211qtv.7
        for <linux-crypto@vger.kernel.org>; Wed, 05 May 2021 12:46:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lkpUTCzONKczERA2MujskvwtonF4g3uvpRrfwyRJotc=;
        b=A0RFpp6XYDPa94vKrgWuDkMhhHE2MhKaWsPDwtIYL+cXQnPH735gaJ2LWdYjW2Sd9I
         BxZrs+HiR4QovSS+Kzaaifl8z79O6y/NqHl+OXx8KroaBJPPsBVNQqocHu1lblnmxX48
         PcYKLt+vpdDBiGF8qlBjydpZbcGpapNjwtct4VDeHI9Ri0ktu0DQDoN4zTF8/CYeH8xI
         6yr4Ehoh+QPS825oBm0rdAI1krO8GAQmo+XihuIQePSQwJ9Fr2/139mC8PsPdFZL5BrE
         H4AU/+DaaF1bQ1to7iOen8TTIP+N9ufUGit26XLb+U9fBv0pLHyCSXz4YxwW4PS33cTI
         /Xyw==
X-Gm-Message-State: AOAM530pCvmasjLgtBtdEnfuOfUpCSJKavgV8htqX1viwNj3IL2Snu2C
        MtqIdPGQcIjS3Svr0kCCo4zzYB77y/YM3XTVJrvS1zD0t2GulA/XvDToaIqTQ+8X09hPSA+bw0s
        rUssv9wOSRlJTzWdc+e6MIyIt9n+1bZPP0Qcl7gMn/A==
X-Received: by 2002:a05:6214:c2e:: with SMTP id a14mr692625qvd.34.1620244001060;
        Wed, 05 May 2021 12:46:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzo54am7dCSTCUr1Fbs7xBAu8XLuOcYBZXQNDB/ZmBfA2ofYNrXpFqpSQZWtXpuBGcTtVkATQ==
X-Received: by 2002:a05:6214:c2e:: with SMTP id a14mr692615qvd.34.1620244000913;
        Wed, 05 May 2021 12:46:40 -0700 (PDT)
Received: from [192.168.1.4] ([45.237.49.2])
        by smtp.gmail.com with ESMTPSA id r16sm211492qtx.36.2021.05.05.12.46.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 May 2021 12:46:40 -0700 (PDT)
Subject: Re: [PATCH v3] hwrng: exynos - Fix runtime PM imbalance on error
To:     =?UTF-8?Q?=c5=81ukasz_Stelmach?= <l.stelmach@samsung.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     =?UTF-8?Q?Bart=c5=82omiej_=c5=bbolnierkiewicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
References: <CGME20210505182918eucas1p18a11263e5d214e3356ac65d79504e430@eucas1p1.samsung.com>
 <20210505182914.13394-1-l.stelmach@samsung.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <5c6702a0-dd9e-dc76-6f8b-449d52fea210@canonical.com>
Date:   Wed, 5 May 2021 15:46:37 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210505182914.13394-1-l.stelmach@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 05/05/2021 14:29, Łukasz Stelmach wrote:
> pm_runtime_resume_and_get() wraps around pm_runtime_get_sync() and
> decrements the runtime PM usage counter in case the latter function
> fails and keeps the counter balanced.
> 
> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
> ---
> Changes in v3:
>   - use pm_runtime_resume_and_get()
> 
> Changes in v2:
>   - removed Change-Id from the commit message
> 
>  drivers/char/hw_random/exynos-trng.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

Best regards,
Krzysztof
