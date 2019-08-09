Return-Path: <SRS0=Ue/q=WF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC726C31E40
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 17:50:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C20C32171F
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 17:50:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BFAPcueN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbfHIRuM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Aug 2019 13:50:12 -0400
Received: from mail-wm1-f51.google.com ([209.85.128.51]:51566 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407597AbfHIRuM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Aug 2019 13:50:12 -0400
Received: by mail-wm1-f51.google.com with SMTP id 207so6520908wma.1
        for <linux-crypto@vger.kernel.org>; Fri, 09 Aug 2019 10:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aqR+7zgR1rk6o3zDjNdeuOtb9Cv8O6hfrGdvIs0JJsw=;
        b=BFAPcueNZDTZoFmI/ZeUU5NnHFH5IMNrWGOw5hYIF/wiyxlVWsueBvJdFJAl0JS8OI
         IM5zSqwh7ZEzh6xEKWLeCo24I5sqesqtKRR950WPh9+uPJCUZzPgEpP5Lp16pAzlsh1N
         wq5AsObRAW/uwHjiIokSJ6NY0J/WcNdZK5LxpDtz2LOsXqTRZbx1LDVLYPjwxU7cnm/N
         ZCAsOopHodDdWFf7hn2++/UgY4G+DCgcNjdVNPX9CNbsc0GTKdcR/OQFEw+UL2CsUAg4
         mn1mvBFEIkfSr6I8PGx63DWJv2/JhhYmi60VonT1QaoQ8Gl7RRtzi79cMXsw6RLNariW
         B9RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aqR+7zgR1rk6o3zDjNdeuOtb9Cv8O6hfrGdvIs0JJsw=;
        b=lcfzRuWxbZqyKPfvfirXyTgvsa+GibxAuF60tnZTgdiqhZ66aSlY/V4jF0QhoC1SV1
         amUL4miyqgWB/N6FH5cQ10I0BMtW23CCnsyeZgsc7yhzDz8ZvDPlmK5yTIIkdYQ1v6KD
         LRdKnb/AJBHmbCXFjet3EOh6ED9bGDgi16d9lu0cdOs2uilaypwKkAy837DflEl30Th+
         AsruB8wyDg2vNglnWG+QdYUDSUsUcb2oFkJz4GELxH4pJTIujzAsmex1rGoqjU0k5RF/
         IQte+DkBsB9JKC/oPkNssk+v2Sqx9U7EQSnHQqBP5kU83F9VyUABAmwWbOFdou3ZEZ/+
         9f/g==
X-Gm-Message-State: APjAAAVcY3Nw3NQux1qGJjNGM8rVAgziIYoYo90WJnSCRG1t5FlRgegz
        HRPCxfApfeO5mqmeS9vDYRLSPWe7pY+RiYTzfuoo/sD8TDw=
X-Google-Smtp-Source: APXvYqw7dkWCMpM9wD9HvRseblUl2T1rjzuHHbUHeRM3ruvkoiPqh8S3Enmf76uPbufotkeH3RM5d3BB3xMVVjF7q3s=
X-Received: by 2002:a05:600c:2255:: with SMTP id a21mr11288063wmm.119.1565373010033;
 Fri, 09 Aug 2019 10:50:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190809082919.62776-1-yuehaibing@huawei.com>
In-Reply-To: <20190809082919.62776-1-yuehaibing@huawei.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 9 Aug 2019 20:49:59 +0300
Message-ID: <CAKv+Gu88NxkdmKpDm3A4JTQYvOuUvUgz4NgPEAWCbqbuBkUqhg@mail.gmail.com>
Subject: Re: [PATCH -next] crypto: aes-generic - remove unused variable 'rco_tab'
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 9 Aug 2019 at 11:30, YueHaibing <yuehaibing@huawei.com> wrote:
>
> crypto/aes_generic.c:64:18: warning:
>  rco_tab defined but not used [-Wunused-const-variable=]
>
> It is never used, so can be removed.
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  crypto/aes_generic.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/crypto/aes_generic.c b/crypto/aes_generic.c
> index 71a5c19..22e5867 100644
> --- a/crypto/aes_generic.c
> +++ b/crypto/aes_generic.c
> @@ -61,8 +61,6 @@ static inline u8 byte(const u32 x, const unsigned n)
>         return x >> (n << 3);
>  }
>
> -static const u32 rco_tab[10] = { 1, 2, 4, 8, 16, 32, 64, 128, 27, 54 };
> -
>  /* cacheline-aligned to facilitate prefetching into cache */
>  __visible const u32 crypto_ft_tab[4][256] ____cacheline_aligned = {
>         {
> --
> 2.7.4
>
>
