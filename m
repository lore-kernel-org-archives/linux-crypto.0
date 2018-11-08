Return-Path: <SRS0=HYoH=NT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCD3DC43441
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Nov 2018 23:33:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F33D20840
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Nov 2018 23:33:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="JAM7F0Wc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7F33D20840
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727203AbeKIJLS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Nov 2018 04:11:18 -0500
Received: from mail-it1-f193.google.com ([209.85.166.193]:51758 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbeKIJLR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Nov 2018 04:11:17 -0500
Received: by mail-it1-f193.google.com with SMTP id m34-v6so705433iti.1
        for <linux-crypto@vger.kernel.org>; Thu, 08 Nov 2018 15:33:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=Q+TcwQ79yZGZTrrH51lAdeB4giK3tANm5wluM/I4Crc=;
        b=JAM7F0Wc9MIYo0Hd1+Ez44rX6Hx+KcsQeAMDjcTq5tD5yWVVetqQKet1n1j2+sIsZB
         qC3nnQDzBVC1PMgb+IJM/QQastj3tQXc0I0za0ElvI5bOTK6X2oiVAK2l28mwr/ZgYB1
         wYa/sYJQMNQhilBF5D/iA/29mGvTNuAZo7hmY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=Q+TcwQ79yZGZTrrH51lAdeB4giK3tANm5wluM/I4Crc=;
        b=VzS9UHmp/ID52DoJB3osowCMbh9of63uiYHbRxxXousGUBmVoG2A4TqzBrcMFsiyeZ
         mlPxbb3dB0uDUi+vFBtrRcF51wa/ksXdZFs4C97Ej0aAUthcA6HPPXnwPfUEFcGD7D6j
         R4wp0qVqXjxg7VTqAdnA5SvKh+B0MiJhs541JmExgu3Mz6woaGVEhH4XpilxcJ4gNnSJ
         ik0au3oYl/9U7BHthu5kYkn2TH5j9YjcZhbX7KybOSmk8o7Oa2nD1EJuZ3w8gtJ36QB1
         8+XOurNPOuUEJYH72j+OXnI3Io1umbKT6ZivLfjahP9EHov0rumc2LrRZe8p/XIYUshm
         oPBA==
X-Gm-Message-State: AGRZ1gLTweDAMLxEhTVHr/sYVORTAnEl1QPWIpL6sOKvbmbefDFZro1v
        1lNFjy/p8fAYKPrqitcFamMxCqT05pq6GJJrU3wlfKWgiUg=
X-Google-Smtp-Source: AJdET5eqUNhGUJYyYElfS6wNWYjzcq18dlB6zrl4tHBn8zvuKl33lJtFNNYGIFNg9blDMFkG5QLBQMo0jTrC2m2sHSs=
X-Received: by 2002:a24:2190:: with SMTP id e138-v6mr381849ita.71.1541720004173;
 Thu, 08 Nov 2018 15:33:24 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a6b:4f16:0:0:0:0:0 with HTTP; Thu, 8 Nov 2018 15:33:23 -0800 (PST)
In-Reply-To: <20181108225516.9967-1-ard.biesheuvel@linaro.org>
References: <20181108225516.9967-1-ard.biesheuvel@linaro.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 9 Nov 2018 00:33:23 +0100
Message-ID:
 <CAKv+Gu_7M+A5OiCOsOd7_e5+GH7VkrOZ33iSexd2oacyzUNKEA@mail.gmail.com>
Subject: Re: [PATCH] crypto/simd: correctly take reqsize of wrapped skcipher
 into account
To:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>, Qian Cai <cai@gmx.us>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181108233323.6blt4D3ePM8-LFVR_iqG-74ZgFsbpwlRGtak9KQAoAk@z>

On 8 November 2018 at 23:55, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> The simd wrapper's skcipher request context structure consists
> of a single subrequest whose size is taken from the subordinate
> skcipher. However, in simd_skcipher_init(), the reqsize that is
> retrieved is not from the subordinate skcipher but from the
> cryptd request structure, whose size is completely unrelated to
> the actual wrapped skcipher.
>
> Reported-by: Qian Cai <cai@gmx.us>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  crypto/simd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/crypto/simd.c b/crypto/simd.c
> index ea7240be3001..2f3d6e897afc 100644
> --- a/crypto/simd.c
> +++ b/crypto/simd.c
> @@ -125,7 +125,7 @@ static int simd_skcipher_init(struct crypto_skcipher *tfm)
>         ctx->cryptd_tfm = cryptd_tfm;
>
>         reqsize = sizeof(struct skcipher_request);
> -       reqsize += crypto_skcipher_reqsize(&cryptd_tfm->base);
> +       reqsize += crypto_skcipher_reqsize(cryptd_skcipher_child(cryptd_tfm));
>

This should be

reqsize += max(crypto_skcipher_reqsize(&cryptd_tfm->base);
       crypto_skcipher_reqsize(cryptd_skcipher_child(cryptd_tfm)));

since the cryptd path in simd still needs some space in the subreq for
the completion.
