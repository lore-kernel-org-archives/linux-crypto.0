Return-Path: <SRS0=EtZ3=SR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 963C5C10F11
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Apr 2019 08:55:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67BC420675
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Apr 2019 08:55:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbfDOIz4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Apr 2019 04:55:56 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:46637 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbfDOIz4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Apr 2019 04:55:56 -0400
Received: by mail-ot1-f67.google.com with SMTP id s24so13717460otk.13
        for <linux-crypto@vger.kernel.org>; Mon, 15 Apr 2019 01:55:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0oiIQCoCCRC5mx5ft74gnUwCVLvQLc5GM/L1ynUjG6E=;
        b=WbY7q7SowmD+P9Rjcr3589pcnYwWc4XF1ZogRAxz4B+UUZnWHtPjtXPGJGK1zoutD/
         gQ440ybZzm+8mDHz9E+3DpraszS3cmKiVWAe99pBPIIDnV++MAtERg9HyTn7G9Klrs6B
         smIa0SJ5gJdmsfWDoz5kZRSGflzl9Z5yKMHfdb3CATpyWXg3S4e2Q0CoBm1+kzjVfUoK
         fv6WtwfBYU0127m1bB2ZqfBehofyVXAR2A2G951nmclFgNdMFI0S1hhB5uArEIjqlEyV
         +aRzJYPhXDCEk9nHC+fq61YUMmExvFlRWrppiEBU3OFVQZUHSlYB69I8hl7VLAUKwuD7
         kXrQ==
X-Gm-Message-State: APjAAAWkEdDvMwObLomZv3ad5sUhxrv8i6mpX6HfoubaZ6mJ2q++sWmY
        G2XXNe8QK7YnDCDD13sESUmpEmMc+tNiwLt/D8qH8g==
X-Google-Smtp-Source: APXvYqxwqWUmV4XFZbSXO86xQnfdfe52DEXUR5KygTOYOL9eWac9m4o85FAJNQKMh2LHpc2R0O9p5m6akNk94vtHM4g=
X-Received: by 2002:a9d:27e9:: with SMTP id c96mr47115553otb.206.1555318555140;
 Mon, 15 Apr 2019 01:55:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190414120743.7fy2jckdytdscj72@gondor.apana.org.au> <20190415063733.ayphuy72sasongdr@gondor.apana.org.au>
In-Reply-To: <20190415063733.ayphuy72sasongdr@gondor.apana.org.au>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Mon, 15 Apr 2019 10:55:44 +0200
Message-ID: <CAFqZXNvqQjwNPFF8PSRMxAYAZPOvOrSRjd1Ue=DXoBEhHYg23Q@mail.gmail.com>
Subject: Re: [v2 PATCH] crypto: lrw - Fix atomic sleep when walking skcipher
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Apr 15, 2019 at 8:37 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> When we perform a walk in the completion function, we need to ensure
> that it is atomic.
>
> Fixes: ac3c8f36c31d ("crypto: lrw - Do not use auxiliary buffer")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: Ondrej Mosnacek <omosnace@redhat.com>

>
> diff --git a/crypto/lrw.c b/crypto/lrw.c
> index 0430ccd08728..08a0e458bc3e 100644
> --- a/crypto/lrw.c
> +++ b/crypto/lrw.c
> @@ -212,8 +212,12 @@ static void crypt_done(struct crypto_async_request *areq, int err)
>  {
>         struct skcipher_request *req = areq->data;
>
> -       if (!err)
> +       if (!err) {
> +               struct rctx *rctx = skcipher_request_ctx(req);
> +
> +               rctx->subreq.base.flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
>                 err = xor_tweak_post(req);
> +       }
>
>         skcipher_request_complete(req, err);
>  }
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

-- 
Ondrej Mosnacek <omosnace at redhat dot com>
Software Engineer, Security Technologies
Red Hat, Inc.
