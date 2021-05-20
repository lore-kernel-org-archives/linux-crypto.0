Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A5E7C433ED
	for <linux-crypto@archiver.kernel.org>; Thu, 20 May 2021 20:05:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16C806121E
	for <linux-crypto@archiver.kernel.org>; Thu, 20 May 2021 20:05:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240212AbhETUHC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 May 2021 16:07:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33214 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232256AbhETUHC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 May 2021 16:07:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621541140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9DvLyWm0oOeUARQQ3t4wGSgOiWrOI/ws7zL/8t6458c=;
        b=WlNL06m+tofv0zwbCC2/EaZ5DXMqaVCKzi93Y5dl17CvFAjUJJIVqcBOzIzPQXKppzS9Uu
        0KgFhrsQqI/SLUpS+Wmz/bGhhDFK/GjQzVm0nkJy2RGIUutp0E5ml2AiCXkU5zqVC8x/f4
        x/F4DTgsuGyTbljYdyzSFqxUrF4l6Uo=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-VRJiBjn1MIOw6GJbYRXtkw-1; Thu, 20 May 2021 16:05:27 -0400
X-MC-Unique: VRJiBjn1MIOw6GJbYRXtkw-1
Received: by mail-qv1-f69.google.com with SMTP id fi6-20020a0562141a46b02901f064172b74so9335894qvb.3
        for <linux-crypto@vger.kernel.org>; Thu, 20 May 2021 13:05:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=9DvLyWm0oOeUARQQ3t4wGSgOiWrOI/ws7zL/8t6458c=;
        b=quurAlrggi6YZTgiXsthmzx3c73xpJ67zF78Qe9xRT8ZOvXylZC0BS5wkK9lIcmRfQ
         uT8/B8gpjBBR34v7r91hAVVWl+ZBLh/1QKjH+tVB0kN11vjj1v28u3iOSVVWuGR4mjJo
         GdXAJDS7FiI31jvP41BbJQCAoHYE/SzLYEMLEc24a4b0AWpxqSzwtAp+g6Di8uJUqjgj
         +TJhsaZ5HSM6vktJK7911/p6ItcYc60ulx2Rt9npt9KAE3WzQgEKIqyXRD6nZXktSC6u
         DNnCHYJqF/dN6zx7+l6dT+G9IyflONN+McW+uF4ia+6ohqoSFTT/3IGiiT8sV/gl3q/C
         BOnw==
X-Gm-Message-State: AOAM533TNpAlP9zh0eQL/jzeDj31WFOpg0Xxdrq88IVaXGijvo6rc47v
        7QUAL1mzy5K2lp6K5Hm8EtxT7NYiQEq0Bp70kLsuUx+wZq1M4b9B8yYTaTI3XHCqCXMB+AODwWk
        MYQIGRvxLwKthw9DD9nSLFJee
X-Received: by 2002:a05:6214:246a:: with SMTP id im10mr7640571qvb.2.1621541127134;
        Thu, 20 May 2021 13:05:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx6a4i1iMK7B4lQbYbDwEGBs22o7nRt3vrvSaxmnCElp4Oa6tv1ZeQM6rsRB2JcQmo/KiOKLA==
X-Received: by 2002:a05:6214:246a:: with SMTP id im10mr7640550qvb.2.1621541126941;
        Thu, 20 May 2021 13:05:26 -0700 (PDT)
Received: from ?IPv6:2603:7000:9400:fe80::baf? (2603-7000-9400-fe80-0000-0000-0000-0baf.res6.spectrum.com. [2603:7000:9400:fe80::baf])
        by smtp.gmail.com with ESMTPSA id k125sm2937407qkf.53.2021.05.20.13.05.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 13:05:26 -0700 (PDT)
Message-ID: <0eced9533d36392b5f8e9540d299631f1a9e1ff8.camel@redhat.com>
Subject: Re: [PATCH] crypto: DRBG - switch to HMAC SHA512 DRBG as default
 DRBG
From:   Simo Sorce <simo@redhat.com>
To:     Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>,
        linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au
Date:   Thu, 20 May 2021 16:05:25 -0400
In-Reply-To: <3171520.o5pSzXOnS6@positron.chronox.de>
References: <3171520.o5pSzXOnS6@positron.chronox.de>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 2021-05-20 at 21:31 +0200, Stephan Müller wrote:
> The default DRBG is the one that has the highest priority. The priority
> is defined based on the order of the list drbg_cores[] where the highest
> priority is given to the last entry by drbg_fill_array.
> 
> With this patch the default DRBG is switched from HMAC SHA256 to HMAC
> SHA512 to support compliance with SP800-90B and SP800-90C (current
> draft).
> 
> The user of the crypto API is completely unaffected by the change.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
>  crypto/drbg.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/crypto/drbg.c b/crypto/drbg.c
> index 1b4587e0ddad..ea85d4a0fe9e 100644
> --- a/crypto/drbg.c
> +++ b/crypto/drbg.c
> @@ -176,18 +176,18 @@ static const struct drbg_core drbg_cores[] = {
>  		.blocklen_bytes = 48,
>  		.cra_name = "hmac_sha384",
>  		.backend_cra_name = "hmac(sha384)",
> -	}, {
> -		.flags = DRBG_HMAC | DRBG_STRENGTH256,
> -		.statelen = 64, /* block length of cipher */
> -		.blocklen_bytes = 64,
> -		.cra_name = "hmac_sha512",
> -		.backend_cra_name = "hmac(sha512)",
>  	}, {
>  		.flags = DRBG_HMAC | DRBG_STRENGTH256,
>  		.statelen = 32, /* block length of cipher */
>  		.blocklen_bytes = 32,
>  		.cra_name = "hmac_sha256",
>  		.backend_cra_name = "hmac(sha256)",
> +	}, {
> +		.flags = DRBG_HMAC | DRBG_STRENGTH256,
> +		.statelen = 64, /* block length of cipher */
> +		.blocklen_bytes = 64,
> +		.cra_name = "hmac_sha512",
> +		.backend_cra_name = "hmac(sha512)",
>  	},
>  #endif /* CONFIG_CRYPTO_DRBG_HMAC */
>  };

We'd like this to ease certification pains.
Acked-by: simo Sorce <simo@redhat.com>

-- 
Simo Sorce
RHEL Crypto Team
Red Hat, Inc




