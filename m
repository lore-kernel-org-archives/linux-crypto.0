Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98862C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Oct 2021 10:10:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75633611EF
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Oct 2021 10:10:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbhJTKMM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Oct 2021 06:12:12 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:46546
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229555AbhJTKMG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Oct 2021 06:12:06 -0400
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com [209.85.167.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id D0714402E7
        for <linux-crypto@vger.kernel.org>; Wed, 20 Oct 2021 10:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1634724591;
        bh=TR31enh52EtLPemABVvecmv1e4qo03jIZpvpMSfV0QE=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=KF2va3csjYiZqNXFj9G3FSDjdmD7HWdmc6FsDcRIcVzMpse/lub8dB0CkVktImu5A
         0YVjv4VldoGKZkK9NYMOjHOmC7i0B0yYLjxaLr8f/RIq/TrXFe677ULwBCQ22kQAKV
         KSh8kokKCnYsVOq6BngQ8nrDmgWh1iUGG107pIX0rmDIAau6zhZyiVsQ9aOP4Uyh5/
         ryU4nXXDY//S9y4VPTZ0SR/fx9t/gLGqrstt7K+eHI7Z/iCuLd8aKXHD0tRbV+Pnrr
         IVPDxI8ri+54xb3Y7plZIYkM339lFqsbP7AXih6v3PJ1PjlKyiDTHam74X2KWmtEq+
         bpKhiUcsotEQA==
Received: by mail-lf1-f71.google.com with SMTP id h8-20020a056512220800b003fdf2283e82so2910217lfu.10
        for <linux-crypto@vger.kernel.org>; Wed, 20 Oct 2021 03:09:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TR31enh52EtLPemABVvecmv1e4qo03jIZpvpMSfV0QE=;
        b=veVely47kY0kYJHAYgVT+ZIanN7tH5Cda/Hh0v45fWmSnrdf53/41bUhU33+9hbHeX
         Tt6u2gaCSzC2JeCLhEzVqwmOfpJfPnWuVxiADm0Or77g4qh/gRLETke4dZevnpozuYVz
         IThNgl9CRZfgpNldYZLeSTCs/6lZMU6z1VYwwftUAVuEH24jxmcvhJhOJp95J2baYTJq
         Exyz6GOnRx2GbataXTtGaUSErlhFNntiEPgUbQvavjMFabJv6xF4JEHNSwP/8aQXJaTy
         nmfnwyTiJ4mVXDuC6DacNGl3348A7AEgQLpxamfqQiwRVCfHivk7qQOS9UwgJ2DG8Maf
         YC9g==
X-Gm-Message-State: AOAM530dd+FRn8+WKqg+QS+KQ/TwBlqm9ZniKIJ1HY69X+EaNpeyrVMo
        co8IK5KmiDkEICLmoGu9HSuddlflay2aOXMs8anUlVOATy2tGpj2WwAct34UnZVtyl5KQ4XYith
        +up0shXwYdnXKZLoN+QpnvLG+wDeDgQQUcZs9ud4Ouw==
X-Received: by 2002:a2e:8e8a:: with SMTP id z10mr12472199ljk.102.1634724591293;
        Wed, 20 Oct 2021 03:09:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxMw8tmUC2ubi2DJeQzC4XY2GeMIQa1zjfJ9Kr5Qrs7LPCjvfGARNfghc7xWtS7P3kutDdovA==
X-Received: by 2002:a2e:8e8a:: with SMTP id z10mr12472175ljk.102.1634724591039;
        Wed, 20 Oct 2021 03:09:51 -0700 (PDT)
Received: from [192.168.3.161] (89-77-68-124.dynamic.chello.pl. [89.77.68.124])
        by smtp.gmail.com with ESMTPSA id o13sm155571lfl.111.2021.10.20.03.09.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 03:09:50 -0700 (PDT)
Subject: Re: [PATCH] crypto: s5p-sss - Add error handling in s5p_aes_probe()
To:     Tang Bin <tangbin@cmss.chinamobile.com>, vz@mleia.com,
        herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211020100348.42896-1-tangbin@cmss.chinamobile.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <8c043f4e-76e7-0b0b-dda8-c85623709f1f@canonical.com>
Date:   Wed, 20 Oct 2021 12:09:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211020100348.42896-1-tangbin@cmss.chinamobile.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 20/10/2021 12:03, Tang Bin wrote:
> The function s5p_aes_probe() does not perform sufficient error
> checking after executing platform_get_resource(), thus fix it.
> 
> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
> ---
>  drivers/crypto/s5p-sss.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> index 55aa3a711..7717e9e59 100644
> --- a/drivers/crypto/s5p-sss.c
> +++ b/drivers/crypto/s5p-sss.c
> @@ -2171,6 +2171,8 @@ static int s5p_aes_probe(struct platform_device *pdev)
>  
>  	variant = find_s5p_sss_version(pdev);
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res)
> +		return -EINVAL;
>  
>  	/*
>  	 * Note: HASH and PRNG uses the same registers in secss, avoid
> 

You need fixes and cc-stable:
Fixes: c2afad6c6105 ("crypto: s5p-sss - Add HASH support for Exynos")
Cc: <stable@vger.kernel.org>

With above added:
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

Best regards,
Krzysztof
