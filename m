Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3956C38159
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Jan 2023 05:53:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbjATFxw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Jan 2023 00:53:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbjATFxr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Jan 2023 00:53:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DFB4ABC1
        for <linux-crypto@vger.kernel.org>; Thu, 19 Jan 2023 21:53:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ABCD4B82162
        for <linux-crypto@vger.kernel.org>; Thu, 19 Jan 2023 09:50:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6FEC433D2
        for <linux-crypto@vger.kernel.org>; Thu, 19 Jan 2023 09:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674121839;
        bh=cwfGxQaG+URthgCetdxt06MgdLxrxjNtdHKT4FtVIT0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=hlQ5sHkwGpxp76mYavwbSbYa0wcZbK2DMUE47wRwDl/FwveFfL7GhDWBh+juEyKdE
         YNGFq7w8PRa9YiUFqQd+XUf58+ANaqIR8cnEBW1d3FW1lxUtgoHrhZ3MmwAvwhSLTF
         8KJ6qs59cI2oeFred6/nvib95qF/W32v1dinVLQg+AzreS47BSLv+GHptzfzdul+BU
         Pw08LDBaECNWVY4FHWrw1mMmJdeZZvw8W3Zax/rFRfCKhmeg9VcEx4yC2sCGAUpf0z
         vynXFwz9ekxQGNT7qX5Knm9sfqi+OKzkYNHfSHbykDAaZ6rcxQudNQyuOYVRP5xZpV
         HCcoXthi3A3Jw==
Received: by mail-lf1-f45.google.com with SMTP id bf43so2421846lfb.6
        for <linux-crypto@vger.kernel.org>; Thu, 19 Jan 2023 01:50:39 -0800 (PST)
X-Gm-Message-State: AFqh2krrPK2HYpDxnuGlBL0l1Lv8XP3YRpnEdnf4KNQgoOJrYxINElIM
        EFvenZJ+ViaRXkXSwPKG5oMLIpUqIRbaLL6kvdA=
X-Google-Smtp-Source: AMrXdXt4IT8RfX3IWSdEFxQCEdVF49MM0CHnPNl2cpxloyFDP06h895QQvcsL/4qkvjTzMhfNkh9aoiLIw2R2xTcFTY=
X-Received: by 2002:ac2:4ade:0:b0:4d0:7b7:65dc with SMTP id
 m30-20020ac24ade000000b004d007b765dcmr457752lfp.122.1674121837337; Thu, 19
 Jan 2023 01:50:37 -0800 (PST)
MIME-Version: 1.0
References: <Y8kInrsuWybCTgK0@gondor.apana.org.au>
In-Reply-To: <Y8kInrsuWybCTgK0@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 19 Jan 2023 10:50:26 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGPqHsHSkj+hV_AcwPZxmWMi_=sVBHQWckUPomh6D7uGg@mail.gmail.com>
Message-ID: <CAMj1kXGPqHsHSkj+hV_AcwPZxmWMi_=sVBHQWckUPomh6D7uGg@mail.gmail.com>
Subject: Re: [PATCH] crypto: xts - Handle EBUSY correctly
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 19 Jan 2023 at 10:08, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> As it is xts only handles the special return value of EINPROGERSS,

EINPROGRESS

> which means that in all other cases it will free data related to the
> request.
>
> However, as the caller of xts may specify MAY_BACKLOG, we also need
> to expect EBUSY and treat it in the same way.  Otherwise backlogged
> requests will trigger a use-after-free.
>
> Fixes: 8083b1bf8163 ("crypto: xts - add support for ciphertext stealing")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> diff --git a/crypto/xts.c b/crypto/xts.c
> index 63c85b9e64e0..de6cbcf69bbd 100644
> --- a/crypto/xts.c
> +++ b/crypto/xts.c
> @@ -203,12 +203,12 @@ static void xts_encrypt_done(struct crypto_async_request *areq, int err)
>         if (!err) {
>                 struct xts_request_ctx *rctx = skcipher_request_ctx(req);
>
> -               rctx->subreq.base.flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
> +               rctx->subreq.base.flags &= CRYPTO_TFM_REQ_MAY_BACKLOG;

I don't get this bit. We used to preserve CRYPTO_TFM_REQ_MAY_BACKLOG
before (along with all other flags except MAY_SLEEP), but now, we
*only* preserve CRYPTO_TFM_REQ_MAY_BACKLOG.

So how is this related? Why are we clearing
CRYPTO_TFM_REQ_FORBID_WEAK_KEYS here for instance?


>                 err = xts_xor_tweak_post(req, true);
>
>                 if (!err && unlikely(req->cryptlen % XTS_BLOCK_SIZE)) {
>                         err = xts_cts_final(req, crypto_skcipher_encrypt);
> -                       if (err == -EINPROGRESS)
> +                       if (err == -EINPROGRESS || err == -EBUSY)

Apologies for the noob questions about this aspect of the crypto API,
but I suppose this means that, if CRYPTO_TFM_REQ_MAY_BACKLOG was
specified, it is up to the skcipher implementation to queue up the
request and return -EBUSY, as opposed to starting the request
asynchronously and returning -EINPROGRESS?

So why the distinction? If the skcipher signals that the request is
accepted and will complete asynchronously, couldn't it use EINPROGRESS
for both cases? Or is the EBUSY interpreted differently by the caller,
for providing back pressure to the source?

>                                 return;
>                 }
>         }
> @@ -223,12 +223,12 @@ static void xts_decrypt_done(struct crypto_async_request *areq, int err)
>         if (!err) {
>                 struct xts_request_ctx *rctx = skcipher_request_ctx(req);
>
> -               rctx->subreq.base.flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
> +               rctx->subreq.base.flags &= CRYPTO_TFM_REQ_MAY_BACKLOG;
>                 err = xts_xor_tweak_post(req, false);
>
>                 if (!err && unlikely(req->cryptlen % XTS_BLOCK_SIZE)) {
>                         err = xts_cts_final(req, crypto_skcipher_decrypt);
> -                       if (err == -EINPROGRESS)
> +                       if (err == -EINPROGRESS || err == -EBUSY)
>                                 return;
>                 }
>         }
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
