Return-Path: <SRS0=0DWe=YJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38ADDFA372A
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 13:02:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1182721848
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 13:02:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="k2uI+8mj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393401AbfJPNCY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Oct 2019 09:02:24 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:38321 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728878AbfJPNCY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Oct 2019 09:02:24 -0400
Received: by mail-qt1-f193.google.com with SMTP id j31so35918463qta.5
        for <linux-crypto@vger.kernel.org>; Wed, 16 Oct 2019 06:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nb+Zwv6A9Mb4GfSnlLYIs35QuTFmhM3ANMKIRmvC9YI=;
        b=k2uI+8mjSnh09Xb8YO7vjSmrVkGwUmx1Mp2fIXodTr8e5zJG/RhUZ9a4R+Ze4LnTtK
         23eqK1hAdLmvlmjfJOSbPS4YfGjjwoWeVeiQ+Xb31T7+BLKRnSsZTG8bubsr/JjuWR8/
         4AoHL4EfhG2bs+gtfdfHzxYOGI6VlOer+aiNFAYVyl0lTx8F9Exqaf+DH5uL1DIBgUWq
         az80mzMXkF5Qj+VH8cvhDzRyTKlq6rMPJ+BBA7Hc+HqVwGTu0TqjW645pYwiPf3AA+0a
         +KCJvGnQa4kJUbsEam72ESp8wY9Nbn1BJVHcrIjHvnYP/AFdzm1XjUN1Ycnd6i+IGoll
         aUyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nb+Zwv6A9Mb4GfSnlLYIs35QuTFmhM3ANMKIRmvC9YI=;
        b=Pg+xjXm9wudIYzc1k916l9FXIaGPJ3BTHgekK+uf/88aNniKKgHnF4aYGyV7FaKPhN
         bg40zLi+bDdE9oFbwvDhSgotWigyCwrZvKwlqHITq9jI02H5ZixMaoGuVpaCp+6Fefb0
         wPRgFvi0hwuIRFxBwrMm660YKsggWpHjeCG53wHLpr5NfYSaSlRKrBsmVFx/10X628TV
         Rw/nZOcb7hNyt5PCLkqftk6eAq4lizdHYRIRlO/Z6jHc6RcMWaIAbDYu7KGx8aSKoM0M
         Qq9Gx3WekbxikgQ2AervlLIzX8CTB8cTso+TtZLB1aNK2ctuQVC3zOZMrD8qBdIfIq/Q
         meBw==
X-Gm-Message-State: APjAAAX4XakdImWKk/d1Hz9eQv/BnX97+YTssPlh3oRzruWEY3YfzKdl
        u267qtlIpPxVJ488v/V7tMFMjiA+Q4C2JwFWWDdFKA==
X-Google-Smtp-Source: APXvYqyW4cbiSWGzBxQIXio3vIu0cmY2K6dYV01TTkd8mDKAjaYz3de0ceDV/3tatxQgqUQRv2lL843vXSRKNrVKh8k=
X-Received: by 2002:ac8:2f9b:: with SMTP id l27mr43816025qta.218.1571230942027;
 Wed, 16 Oct 2019 06:02:22 -0700 (PDT)
MIME-Version: 1.0
References: <20191014121910.7264-1-ard.biesheuvel@linaro.org> <20191014121910.7264-16-ard.biesheuvel@linaro.org>
In-Reply-To: <20191014121910.7264-16-ard.biesheuvel@linaro.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 16 Oct 2019 15:02:10 +0200
Message-ID: <CACRpkdZLha2jExo2dzfxpCLw2SydWxkOw1FDLy+iwY9i7hADpg@mail.gmail.com>
Subject: Re: [PATCH 15/25] crypto: ixp4xx - switch to skcipher API
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linusw@kernel.org>,
        Imre Kaloz <kaloz@openwrt.org>,
        Krzysztof Halasa <khalasa@piap.pl>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 14, 2019 at 2:19 PM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:

> Commit 7a7ffe65c8c5 ("crypto: skcipher - Add top-level skcipher interface")
> dated 20 august 2015 introduced the new skcipher API which is supposed to
> replace both blkcipher and ablkcipher. While all consumers of the API have
> been converted long ago, some producers of the ablkcipher remain, forcing
> us to keep the ablkcipher support routines alive, along with the matching
> code to expose [a]blkciphers via the skcipher API.
>
> So switch this driver to the skcipher API, allowing us to finally drop the
> blkcipher code in the near future.
>
> Cc: Linus Walleij <linusw@kernel.org>
> Cc: Imre Kaloz <kaloz@openwrt.org>
> Cc: Krzysztof Halasa <khalasa@piap.pl>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
