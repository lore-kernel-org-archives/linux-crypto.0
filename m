Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41EA5C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 24 May 2022 06:32:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233946AbiEXGcf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 24 May 2022 02:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbiEXGce (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 24 May 2022 02:32:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F142A7522D
        for <linux-crypto@vger.kernel.org>; Mon, 23 May 2022 23:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653373952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nrMEoijBijbNU22Jw7uLctg18ZKd9qcLuQqiF8bfzeA=;
        b=fXO71OyqL0A8NAcIZ9DIoyn00OR47o0aPp/z3tYulZoJpYJYQ4MiMthNoAe7jQJG7uKPd1
        MoxjUZOUw0g7vt7b++rdPxix9UMzDJ/pR+RGlrJV5CyK2XjmHKrKYGantbXRUtaSrhPhdn
        o+oep6nJ9TS/S+0NiAqnnLnUSK1T+II=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-582-7oMdbz8ZMs6lCf8idI79EQ-1; Tue, 24 May 2022 02:32:30 -0400
X-MC-Unique: 7oMdbz8ZMs6lCf8idI79EQ-1
Received: by mail-lj1-f197.google.com with SMTP id y10-20020a2e95ca000000b00253d689f32fso2557814ljh.5
        for <linux-crypto@vger.kernel.org>; Mon, 23 May 2022 23:32:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nrMEoijBijbNU22Jw7uLctg18ZKd9qcLuQqiF8bfzeA=;
        b=5J3WWqotLCrBPWf6zHOFp3FvtelaaVLS0RwtoQkbbkS1rEbnjg5KFgqWCHc/iNa8TK
         H6Qfm0qRoxOkmVgg2TYLkDOHKDIlXCnDZxMEc4W5nL/nkvdsRVhR62uSaBSBejIdg273
         QjwAyeJGmhptBYJjkOKMWWQ3KmykwwjoBsQcHgTgaS/64WhhRVanEl4I5z7RY71Poqzf
         uTCE+7YExByL/reKkQ8ClO0tgmw+9jwmH/JLb3aFNJ6rS9rNt4yZR5kKw8bjd7/mCkSN
         uIOd44JVbbnjJR2dY/fF/j+NJEBwS9vqfe2AjNoMcDlYtQbE9Dw6uREip8b/rYq/IJFN
         l6EA==
X-Gm-Message-State: AOAM530+mofe/8y2dU+UW/hoMbqDgNadWqkkQpCBY4mhmdJ5KbDM6txI
        +By6MygEB8w887P5majvaMxF6ukUSQUvpYMvvKJcMeVLYdiXtMkMnvNIwe+aQ9+v+WMmD5zXGdd
        gdwcr5h637JBMrV1AoHkOAgYl2eEGlAE6WzbHADED
X-Received: by 2002:a05:6512:1395:b0:446:d382:79a5 with SMTP id p21-20020a056512139500b00446d38279a5mr18397494lfa.210.1653373947662;
        Mon, 23 May 2022 23:32:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPr5MZulLAmUF36ndBcQvv5GpAsz3ZbjIsNO7uECdQvD1+fXPY2pDSbULh5wOJKZ1HOh0Jhzb32Huft5Msonw=
X-Received: by 2002:a05:6512:1395:b0:446:d382:79a5 with SMTP id
 p21-20020a056512139500b00446d38279a5mr18397473lfa.210.1653373947411; Mon, 23
 May 2022 23:32:27 -0700 (PDT)
MIME-Version: 1.0
References: <068d2824cf592748cbd9b75cf4cb6c29600e213c.1653224817.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <068d2824cf592748cbd9b75cf4cb6c29600e213c.1653224817.git.christophe.jaillet@wanadoo.fr>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 24 May 2022 14:32:16 +0800
Message-ID: <CACGkMEtAP_8vNS_JeqOa+ezL=Ngsvk0-B-Pth=nw9rA8g=C10Q@mail.gmail.com>
Subject: Re: [PATCH] virtio-crypto: Fix an error handling path in virtio_crypto_alg_skcipher_close_session()
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Gonglei <arei.gonglei@huawei.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        zhenwei pi <pizhenwei@bytedance.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        virtualization <virtualization@lists.linux-foundation.org>,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, May 22, 2022 at 9:07 PM Christophe JAILLET
<christophe.jaillet@wanadoo.fr> wrote:
>
> Now that a private buffer is allocated (see commit in the Fixes tag),
> it must be released in all error handling paths.
>
> Add the missing goto to avoid a leak in the error handling path.
>
> Fixes: 42e6ac99e417 ("virtio-crypto: use private buffer for control request")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Acked-by: Jason Wang <jasowang@redhat.com>

> ---
>  drivers/crypto/virtio/virtio_crypto_skcipher_algs.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
> index e553ccadbcbc..e5876286828b 100644
> --- a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
> +++ b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
> @@ -239,7 +239,8 @@ static int virtio_crypto_alg_skcipher_close_session(
>                 pr_err("virtio_crypto: Close session failed status: %u, session_id: 0x%llx\n",
>                         ctrl_status->status, destroy_session->session_id);
>
> -               return -EINVAL;
> +               err = -EINVAL;
> +               goto out;
>         }
>
>         err = 0;
> --
> 2.34.1
>

