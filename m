Return-Path: <SRS0=2cET=YT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DBA4CA9EB9
	for <linux-crypto@archiver.kernel.org>; Sat, 26 Oct 2019 15:04:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB17E2070B
	for <linux-crypto@archiver.kernel.org>; Sat, 26 Oct 2019 15:04:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CoKuuHoY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbfJZPEK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 26 Oct 2019 11:04:10 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38000 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbfJZPEK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 26 Oct 2019 11:04:10 -0400
Received: by mail-wr1-f65.google.com with SMTP id v9so5451024wrq.5
        for <linux-crypto@vger.kernel.org>; Sat, 26 Oct 2019 08:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YX9PeBiYB4z6tyZ7g7UzNJLY7tU0ltcTMGRXXHunNtE=;
        b=CoKuuHoY9/J6zlC1CJq/00HJVY+GqBkFupHAwVitwkfOYn72KEdXdOmGEZO0fwrGL9
         ifsJDGncC/0bK5PP96i3oKqOyhqVds8IoRcmXIb8byRTkjPLUjeVSLG+cS7rTILxEnDr
         7+X8uOTMmLFdJf6t2DnvhvyodSpMqAB7Hma9ZjP+qDljRRW6JAlRcc3HSBk1P2BoLGAJ
         uNt1y5+w8/LvqMmUzGxMPM4DVYxcHN6tQ7ATt8aHwo08wAARlCvkFuVSCEHBQB3LmnzA
         DfR6ZopIBPZu03M30K4VnPJcVZqvcLU7oK249kzvKhbkkwJOGyggRu3ESJJcJKIzi9aL
         Vfaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YX9PeBiYB4z6tyZ7g7UzNJLY7tU0ltcTMGRXXHunNtE=;
        b=HNaAVyXgDlBLITyYl4Azz1DnyexccvOJwOCkEWVXbvO4B496pJU0dQ/72wIe8/nMm0
         RSxtQVongLycx+xp82leuQ52AZSm5Tmhr7WLauuooMZ53BUzoIDJUXhH3TXnKl4F5UDk
         KREErt7p4iIs35CMILMgqE0Td+SQCKrCRJhPP7GBwuoCM9+5PBT9LlkoKInoFXX1HOJx
         H8LVlQ9n8SaqyDFtP/WzS3PGPsyBjIrXip27WJG7fu4F7q5c5L4J+JkP89wwLd2UtsR9
         izz+ds84yD4TVXUq6esgYCqbv1CuH1Ar9xTf7nWUa3pcWkzIA/wSxYTk9qW8CTJpeOMN
         7YfA==
X-Gm-Message-State: APjAAAXeDj4gISkGcBaU0lJAryol1g99cemLtTi0SIN1WCyzQFsPenCs
        tYI24CTjYlQrJO1fSlSKQxvNPPtQSM9oM4pJ3383vg==
X-Google-Smtp-Source: APXvYqyG6c7e6ZSbIAiM9TGPkQhultl0mF1e0TmtKI7pMMARHVg6EwZfDkl/T5WfRjuQafTYwq4MhrhpH5YDW0oUb9c=
X-Received: by 2002:adf:9f08:: with SMTP id l8mr7338607wrf.325.1572102246965;
 Sat, 26 Oct 2019 08:04:06 -0700 (PDT)
MIME-Version: 1.0
References: <20191017122549.4634-1-t-kristo@ti.com> <20191017122549.4634-8-t-kristo@ti.com>
In-Reply-To: <20191017122549.4634-8-t-kristo@ti.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sat, 26 Oct 2019 17:04:05 +0200
Message-ID: <CAKv+Gu-4j3yUT7ekPukj1t50WXuNBb+XwwCqP7qHCkH_ZE9ipw@mail.gmail.com>
Subject: Re: [PATCH 07/10] crypto: omap-aes-gcm: fix corner case with only
 auth data
To:     Tero Kristo <t-kristo@ti.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, linux-omap@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 17 Oct 2019 at 14:26, Tero Kristo <t-kristo@ti.com> wrote:
>
> Fix a corner case where only authdata is generated, without any provided
> assocdata / cryptdata. Passing the empty scatterlists to OMAP AES core driver
> in this case would confuse it, failing to map DMAs.
>

So this change appears to be the culprit for causing the remaining
issue that I reported in the cover letter of the followup series that
I sent out.

The logic below does not account for the case where only assocdata is
provided, which is a valid use of an AEAD.

> Signed-off-by: Tero Kristo <t-kristo@ti.com>
> ---
>  drivers/crypto/omap-aes-gcm.c | 22 ++++++++++++++--------
>  1 file changed, 14 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/crypto/omap-aes-gcm.c b/drivers/crypto/omap-aes-gcm.c
> index 9bbedbccfadf..dfd4d1cac421 100644
> --- a/drivers/crypto/omap-aes-gcm.c
> +++ b/drivers/crypto/omap-aes-gcm.c
> @@ -148,12 +148,14 @@ static int omap_aes_gcm_copy_buffers(struct omap_aes_dev *dd,
>         if (req->src == req->dst || dd->out_sg == sg_arr)
>                 flags |= OMAP_CRYPTO_FORCE_COPY;
>
> -       ret = omap_crypto_align_sg(&dd->out_sg, cryptlen,
> -                                  AES_BLOCK_SIZE, &dd->out_sgl,
> -                                  flags,
> -                                  FLAGS_OUT_DATA_ST_SHIFT, &dd->flags);
> -       if (ret)
> -               return ret;
> +       if (cryptlen) {
> +               ret = omap_crypto_align_sg(&dd->out_sg, cryptlen,
> +                                          AES_BLOCK_SIZE, &dd->out_sgl,
> +                                          flags,
> +                                          FLAGS_OUT_DATA_ST_SHIFT, &dd->flags);
> +               if (ret)
> +                       return ret;
> +       }
>
>         dd->in_sg_len = sg_nents_for_len(dd->in_sg, alen + clen);
>         dd->out_sg_len = sg_nents_for_len(dd->out_sg, clen);
> @@ -287,8 +289,12 @@ static int omap_aes_gcm_handle_queue(struct omap_aes_dev *dd,
>                 return err;
>
>         err = omap_aes_write_ctrl(dd);
> -       if (!err)
> -               err = omap_aes_crypt_dma_start(dd);
> +       if (!err) {
> +               if (dd->in_sg_len && dd->out_sg_len)
> +                       err = omap_aes_crypt_dma_start(dd);
> +               else
> +                       omap_aes_gcm_dma_out_callback(dd);
> +       }
>
>         if (err) {
>                 omap_aes_gcm_finish_req(dd, err);
> --
> 2.17.1
>
> --
> Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
