Return-Path: <SRS0=EZON=YO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF2B0CA9EAF
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 12:01:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C24FF20700
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 12:01:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DZayBbwz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbfJUMBI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Oct 2019 08:01:08 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37394 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728323AbfJUMBH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Oct 2019 08:01:07 -0400
Received: by mail-wr1-f68.google.com with SMTP id e11so4939048wrv.4
        for <linux-crypto@vger.kernel.org>; Mon, 21 Oct 2019 05:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mWEB9osAQee35AyhlgRxJbWS6irJ5cvGkHpX55XRn1E=;
        b=DZayBbwzidagHXfjzo+vzE7AoicDQbfH28tq6Q3lvonVDXLWmKQFdudte2p5G1rCYp
         RVCcVYLiRDHe1rxz+iGD1bJ19a2LoAC5z0miBg8I788Def1js93fq7drRVXZdNS26R13
         UnnRmVsYQpkMOQqyFLSt6RoynkjorxsG76w0WY9nzHxR3eknHms4r6T1PRRybxDGFUz7
         X6O82uWSVvSR5YTRhUvqJeUZihX/r7KOV478vNKXthZopVovLmhUu5PLjXBG8sTKgQ9m
         amHtltZ0/s0L/DU1nqWZ3iNpJkbb7B6kjHoNQTSeFULE+WdU31YltZ0C/osAUTntiGEl
         l4yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mWEB9osAQee35AyhlgRxJbWS6irJ5cvGkHpX55XRn1E=;
        b=RdYGH7a6726Lr7WZaaoBUJxbOmvLu841Gl9nj3ZOfkjvoh1Ma/wa/aGXlpadeiBH34
         gYkfGFcIEg78M0/dctVTgtCXhwx4kxTpV70OM/f3RQpMu8wgPjYakEh/6o0hKjcKh6Mi
         PYjYcnA9AZ/UkC+a3qu7eF+C160J6V5gV9eokimnNOcYyG1vPkdnQ1C67vDHhKmdaYew
         vpkgBhDhXIUwVXCbpzqngdmw5iHumPfnpld6hun86KN89HIF8YFkVI/wCqMbYCzB1r6D
         0TTxjfS9LESXyhwpiNgVTJLQvVBvFoefdp6gONRf2SDC/jhixTzOrke08JPFG2BEHKCN
         by0w==
X-Gm-Message-State: APjAAAWdYeXuMcI1dONc3WGvTS0OfcGC23OpqUAh1rrqFnIBF7aDOdQi
        6lefIfaEnau9jqKrDdNCEQEC3SLmHVOmX9qBmYY4BA==
X-Google-Smtp-Source: APXvYqyi04G4z3qmQczX0PrqdoD0ePmtzfbw4P+sB+JZvmXhdomvbxqXJ3pHKBiLdD/c9bC+H9OTsi2VKUlpDUvwjCE=
X-Received: by 2002:adf:f685:: with SMTP id v5mr16542105wrp.246.1571659265641;
 Mon, 21 Oct 2019 05:01:05 -0700 (PDT)
MIME-Version: 1.0
References: <20191014121910.7264-1-ard.biesheuvel@linaro.org>
 <20191014121910.7264-8-ard.biesheuvel@linaro.org> <20191021100517.GA1780@pi3>
In-Reply-To: <20191021100517.GA1780@pi3>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 21 Oct 2019 14:00:59 +0200
Message-ID: <CAKv+Gu8AK+oTRw5Q1NMWkxmycAD+tkqeiqBM-kV_oeebu2sYug@mail.gmail.com>
Subject: Re: [PATCH 07/25] crypto: s5p - switch to skcipher API
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Kamil Konieczny <k.konieczny@partner.samsung.com>,
        linux-samsung-soc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 21 Oct 2019 at 12:05, Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> On Mon, Oct 14, 2019 at 02:18:52PM +0200, Ard Biesheuvel wrote:
> > Commit 7a7ffe65c8c5 ("crypto: skcipher - Add top-level skcipher interface")
> > dated 20 august 2015 introduced the new skcipher API which is supposed to
> > replace both blkcipher and ablkcipher. While all consumers of the API have
> > been converted long ago, some producers of the ablkcipher remain, forcing
> > us to keep the ablkcipher support routines alive, along with the matching
> > code to expose [a]blkciphers via the skcipher API.
> >
> > So switch this driver to the skcipher API, allowing us to finally drop the
> > blkcipher code in the near future.
> >
> > Cc: Krzysztof Kozlowski <krzk@kernel.org>
> > Cc: Vladimir Zapolskiy <vz@mleia.com>
> > Cc: Kamil Konieczny <k.konieczny@partner.samsung.com>
> > Cc: linux-samsung-soc@vger.kernel.org
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > ---
> >  drivers/crypto/s5p-sss.c | 191 ++++++++++----------
> >  1 file changed, 91 insertions(+), 100 deletions(-)
> >
> > diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> > index 010f1bb20dad..e6f1d4d5186c 100644
> > --- a/drivers/crypto/s5p-sss.c
> > +++ b/drivers/crypto/s5p-sss.c
> > @@ -303,7 +303,7 @@ struct s5p_aes_dev {
> >       void __iomem                    *aes_ioaddr;
> >       int                             irq_fc;
> >
> > -     struct ablkcipher_request       *req;
> > +     struct skcipher_request *req;
>
> You mix here indentation.
>

Will fix

> Beside that:
>
> Acked-by: Krzysztof Kozlowski <krzk@kernel.org>
>

Thanks!
