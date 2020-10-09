Return-Path: <SRS0=BuJA=DQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48B25C433E7
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Oct 2020 18:39:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8931222B9
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Oct 2020 18:39:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uU0VX1vh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731999AbgJISj3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Oct 2020 14:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728317AbgJISj3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Oct 2020 14:39:29 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4D5C0613D2;
        Fri,  9 Oct 2020 11:39:28 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id h7so11324677wre.4;
        Fri, 09 Oct 2020 11:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Mi7YxYl7fncx/CgSsE/zWObG9IGsSmppAk4/JwJE34A=;
        b=uU0VX1vhzcQbZZaCjfERaymnhJnHhYexxv9Sl+OgwKUWxNj8cnvuFQUM+QL9SuC7tT
         J/W5tvL2ovuSbX/TJUVHT9qWttvI4vNajh3ucM1ibsG71niC2bZvqmveVb+E1g3Bd6zd
         oK1CTUzK1vPX6metLey1s3IziBaGV2EypsBkD9w5cRnWPnLSEgNwLXj1Lcxf2e/LA+SF
         Odaq0bmv4lMR3T6Vvxj3oBRdwOOYYcIa7Nn4wED/dThOwKHXHn54SU4VXoGD1ddpirsh
         YUFyqvhnB/8A38MADlX31e0D8KsUW9y/9eINPPaa/UWkeFJv+2321cmnHtL9q/1PTYW6
         GEwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Mi7YxYl7fncx/CgSsE/zWObG9IGsSmppAk4/JwJE34A=;
        b=OyXLUSWcwgtPLOsMYfrQfBkFVTmOdm63K0WXeypo77JBKb2+gfVsW/Hhj4uXWr3zF7
         otXRceTLaArJPCO06hx2b/+zV6fF3+fIJ3r4KblQI4Grhx2mtC1/+nl4Q3vEiTWrwtwm
         hP5HMjQhsrSi/d26lR+67HTRQcXcwaHNMHIsqx3sUPtiIHhtSxWPvj8G53W9GxazIT+t
         akPppyDUFMClsNmXvcAfp26vJLzxwSh/DJ+zZZMwSvhknG41MWUs6Lk9ge3sOtoE4+9v
         kD4lAncovGPfAKWVCYha785xlSoHvgXlNmqegU5IYOgIq+UJR/qcVGsRWyEDhZtLk38T
         J2Hw==
X-Gm-Message-State: AOAM531RgATn2vuoB4L2Z8OuJWtSIypEzcLECMH6ELcrBzudD/4PfUFq
        5YQdjWKQX9VockYni+Rix+WZAS00Vwc=
X-Google-Smtp-Source: ABdhPJwKl+htZFdhKjXQFLoVpVIXG9karKGrnrIsyrzjTHaBar561ScrKxkhrdDU8GDHKFuWqhtzvA==
X-Received: by 2002:a5d:468f:: with SMTP id u15mr2515121wrq.154.1602268767638;
        Fri, 09 Oct 2020 11:39:27 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id d4sm13352875wrp.47.2020.10.09.11.39.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 11:39:27 -0700 (PDT)
Date:   Fri, 9 Oct 2020 20:39:25 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Chen-Yu Tsai <wens@csie.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Maxime Ripard <mripard@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] crypto: sun8x-ce*: update entries to its
 documentation
Message-ID: <20201009183925.GA25856@Red>
References: <cover.1602245659.git.mchehab+huawei@kernel.org>
 <52bfc99d585587cf4eaeb0b2ba85f7da751f7f33.1602245659.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52bfc99d585587cf4eaeb0b2ba85f7da751f7f33.1602245659.git.mchehab+huawei@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 09, 2020 at 02:15:31PM +0200, Mauro Carvalho Chehab wrote:
> The README file was converted to ReST format. Update the
> references for it accordingly.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c | 2 +-
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c | 2 +-
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
> index fa2f1b4fad7b..a94bf28f858a 100644
> --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
> +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
> @@ -7,7 +7,7 @@
>   *
>   * This file add support for MD5 and SHA1/SHA224/SHA256/SHA384/SHA512.
>   *
> - * You could find the datasheet in Documentation/arm/sunxi/README
> + * You could find the datasheet in Documentation/arm/sunxi.rst
>   */
>  #include <linux/dma-mapping.h>
>  #include <linux/pm_runtime.h>
> diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c
> index 78503006949c..cfde9ee4356b 100644
> --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c
> +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c
> @@ -7,7 +7,7 @@
>   *
>   * This file handle the PRNG
>   *
> - * You could find a link for the datasheet in Documentation/arm/sunxi/README
> + * You could find a link for the datasheet in Documentation/arm/sunxi.rst
>   */
>  #include "sun8i-ce.h"
>  #include <linux/dma-mapping.h>
> diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c
> index 654328160d19..5b7af4498bd5 100644
> --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c
> +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c
> @@ -7,7 +7,7 @@
>   *
>   * This file handle the TRNG
>   *
> - * You could find a link for the datasheet in Documentation/arm/sunxi/README
> + * You could find a link for the datasheet in Documentation/arm/sunxi.rst
>   */
>  #include "sun8i-ce.h"
>  #include <linux/dma-mapping.h>
> -- 
> 2.26.2
> 

Hello

Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>

Thanks
