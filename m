Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62BADC54EBD
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Jan 2023 11:12:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235371AbjAMLMp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Jan 2023 06:12:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241156AbjAMLLg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Jan 2023 06:11:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D44033C734
        for <linux-crypto@vger.kernel.org>; Fri, 13 Jan 2023 03:05:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D776B82114
        for <linux-crypto@vger.kernel.org>; Fri, 13 Jan 2023 11:05:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A603C433D2
        for <linux-crypto@vger.kernel.org>; Fri, 13 Jan 2023 11:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673607938;
        bh=CU5R9CxJk0q857YapZ8DoxFSGkNduzyQT0JrU2mZHw8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=lFlOzIYYQJn3FONYlKbfuFV7vM3P1Nv74FD3nGHsFF/vra/LCVq5l5chUCWhblJ5Q
         SspIV5DiQ4v638YJ3AlvF11Q/KUhL+V5SAnE0v0aYTope9L/w+g2wwsnN7mDWUTcb7
         POQmBXArD0X7w2Dutau5MjvtlQVK0w5D/EvSWqGvX2AHNhI3YmX1NVIYyA6EKElSiX
         0thkJKZX/NGUbw007JrqNAyUN7pVGE3fQgSVYRn05bH+AEF3Bfn2Zuzpi1s2qTQ0JV
         rH9aKaWix/oRU6M8Fyus3P6eRivKcW/96gzEDuMCbJQDVVxdqkE1ctiLkxVoRk0zbv
         CEZ17DZ7rxL3w==
Received: by mail-lj1-f171.google.com with SMTP id bn6so22108097ljb.13
        for <linux-crypto@vger.kernel.org>; Fri, 13 Jan 2023 03:05:38 -0800 (PST)
X-Gm-Message-State: AFqh2kra91/q32D+RZOVf3cLyS01TgW+OEVLwyQ4TyTMgLPQv6cVAHfU
        8hIqzzPeyCU5L1ZlQ3wrcj8g7TZv5ozLamgBRzk=
X-Google-Smtp-Source: AMrXdXvEznAezv7jdGW4PI5/U3UQGGr08ddl2ETV6rsANIiu4N4qRa1UMM5EIot4yEXipZx8+Ua8gPeIGfdHsJStiTU=
X-Received: by 2002:a2e:a804:0:b0:27f:fb12:6c20 with SMTP id
 l4-20020a2ea804000000b0027ffb126c20mr3581938ljq.152.1673607936284; Fri, 13
 Jan 2023 03:05:36 -0800 (PST)
MIME-Version: 1.0
References: <Y8ExSbhemaU2u+8P@gondor.apana.org.au>
In-Reply-To: <Y8ExSbhemaU2u+8P@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 13 Jan 2023 12:05:24 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHo2JcR3h8FXEiXVCNQHeCKAZHtHK8hWkctk4qBrvMANQ@mail.gmail.com>
Message-ID: <CAMj1kXHo2JcR3h8FXEiXVCNQHeCKAZHtHK8hWkctk4qBrvMANQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: essiv - Handle EBUSY correctly
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 13 Jan 2023 at 11:24, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> As it is essiv only handles the special return value of EINPROGERSS,
> which means that in all other cases it will free data related to the
> request.
>
> However, as the caller of essiv may specify MAY_BACKLOG, we also need
> to expect EBUSY and treat it in the same way.  Otherwise backlogged
> requests will trigger a use-after-free.
>
> Fixes: be1eb7f78aa8 ("crypto: essiv - create wrapper template...")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

>
> diff --git a/crypto/essiv.c b/crypto/essiv.c
> index e33369df9034..307eba74b901 100644
> --- a/crypto/essiv.c
> +++ b/crypto/essiv.c
> @@ -171,7 +171,12 @@ static void essiv_aead_done(struct crypto_async_request *areq, int err)
>         struct aead_request *req = areq->data;
>         struct essiv_aead_request_ctx *rctx = aead_request_ctx(req);
>
> +       if (err == -EINPROGRESS)
> +               goto out;
> +
>         kfree(rctx->assoc);
> +
> +out:
>         aead_request_complete(req, err);
>  }
>
> @@ -247,7 +252,7 @@ static int essiv_aead_crypt(struct aead_request *req, bool enc)
>         err = enc ? crypto_aead_encrypt(subreq) :
>                     crypto_aead_decrypt(subreq);
>
> -       if (rctx->assoc && err != -EINPROGRESS)
> +       if (rctx->assoc && err != -EINPROGRESS && err != -EBUSY)
>                 kfree(rctx->assoc);
>         return err;
>  }
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
