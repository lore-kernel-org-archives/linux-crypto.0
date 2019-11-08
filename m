Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0BB5FA372C
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 08:51:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9327C2075C
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 08:51:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EdU4w6aA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727649AbfKHIvr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 03:51:47 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36536 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfKHIvr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 03:51:47 -0500
Received: by mail-wr1-f67.google.com with SMTP id r10so6090923wrx.3
        for <linux-crypto@vger.kernel.org>; Fri, 08 Nov 2019 00:51:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RqoRZnWQGHNYKjEHFSAUc6XzTWpxo+kDLam/5PYLXLk=;
        b=EdU4w6aAQm65gGI/6/X2Z0CqJJJCQIqgir4bPjeeOko6D56E3u32k7Ukk3GoFWx/pG
         n/vEemzttYQYQB96OYK+6hqhyH5pgBATD1nV8SI6Z7lz4+1pbHco375XKsdMbLa6KOWk
         Z8yhl38reh5XMAs9Oio/6k5Rf98/08zbGE9uiWuloHL15fvzg9zRrK0sX/LaAdAxHfdh
         pvgxX8HrhlC/ic+36PNP4MWBy7p38+f+94KNvFxuj3/oZxusxKSp5qbWurILvE9Cap8U
         iq4bmzuNCfkzjKQ2UDOsvHIa7y42jkiF5UdPrgt9AYKeNBOBsc0SzdSZKeEsINZ592Cf
         Y2ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RqoRZnWQGHNYKjEHFSAUc6XzTWpxo+kDLam/5PYLXLk=;
        b=Mxfj4Bl8g71oaU6LeQ1ygWdc4E4zgAtKo/DVr6l1nIPxmRWBDMakwPJ0kAbliOy6Of
         ZzbulX5aOe+klA6u3CCJUHMoqrwtIm6qGkZA1iHRAjh1VbvBdvwbmEz4G38DoMmCu9Gj
         n84AdIceAeUOcbIsfhq/cQHPaza9pR+VJWUsCNPetgbgRJEkgJ454cbtXeGJjibcE/gH
         PPjEj+KDKqbi85kF/CzYuzSZjtljTyUzE5gEjYgT7ueNmM1A4LHATRCP8eJZjBQvShid
         yI2P1MMg3yX53uNpjK8nzEbiWeAZDLhZTGyKC7djZ5IjSIdnbr+eMzN9v+oGeGZoK6WK
         iEyQ==
X-Gm-Message-State: APjAAAX14qmSgyPRjDXOwZfKj44IgCPDrazfd7bS06OrB6FEWo66YeYL
        HWJ2Xg90JtTz2641oVWTvVKKmWbvd95TotWazmh2Lg==
X-Google-Smtp-Source: APXvYqxeqa+rnWV5zlRupgCDs4uvZRumxoFp1vg/qtg12xUqoE4HhXayXMfhhXoCft3V+xounajW+rJwp3Q0yMSatHU=
X-Received: by 2002:adf:f685:: with SMTP id v5mr7611440wrp.246.1573203102921;
 Fri, 08 Nov 2019 00:51:42 -0800 (PST)
MIME-Version: 1.0
References: <1573202847-8292-1-git-send-email-pvanleeuwen@verimatrix.com>
In-Reply-To: <1573202847-8292-1-git-send-email-pvanleeuwen@verimatrix.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 8 Nov 2019 09:51:31 +0100
Message-ID: <CAKv+Gu-eefG-=g2v4g8fF+2unL6tyceN0S6JGkJnq4tuuPAgUw@mail.gmail.com>
Subject: Re: [PATCHv2] crypto: inside-secure - Fixed authenc w/ (3)DES fails
 on Macchiatobin
To:     Pascal van Leeuwen <pascalvanl@gmail.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 8 Nov 2019 at 09:50, Pascal van Leeuwen <pascalvanl@gmail.com> wrote:
>
> Fixes: 13a1bb93f7b1c9 ("crypto: inside-secure - Fixed warnings on
> inconsistent byte order handling")
>

Please put the fixes tag with the tags (S-o-b etc)

> Fixed 2 copy-paste mistakes in the abovementioned commit that caused
> authenc w/ (3)DES to consistently fail on Macchiatobin (but strangely
> work fine on x86+FPGA??).
> Now fully tested on both platforms.
>
> changes since v1:
> - added Fixes: tag
>

Please put your changelog below the ---

> Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
> ---
>  drivers/crypto/inside-secure/safexcel_cipher.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
> index 98f9fc6..c029956 100644
> --- a/drivers/crypto/inside-secure/safexcel_cipher.c
> +++ b/drivers/crypto/inside-secure/safexcel_cipher.c
> @@ -405,7 +405,8 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
>
>         if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma) {
>                 for (i = 0; i < keys.enckeylen / sizeof(u32); i++) {
> -                       if (le32_to_cpu(ctx->key[i]) != aes.key_enc[i]) {
> +                       if (le32_to_cpu(ctx->key[i]) !=
> +                           ((u32 *)keys.enckey)[i]) {
>                                 ctx->base.needs_inv = true;
>                                 break;
>                         }
> @@ -459,7 +460,7 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
>
>         /* Now copy the keys into the context */
>         for (i = 0; i < keys.enckeylen / sizeof(u32); i++)
> -               ctx->key[i] = cpu_to_le32(aes.key_enc[i]);
> +               ctx->key[i] = cpu_to_le32(((u32 *)keys.enckey)[i]);
>         ctx->key_len = keys.enckeylen;
>
>         memcpy(ctx->ipad, &istate.state, ctx->state_sz);
> --
> 1.8.3.1
>
