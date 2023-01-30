Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 210F1C54EAA
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Jan 2023 10:43:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235825AbjA3KnB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Jan 2023 05:43:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235264AbjA3KnA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Jan 2023 05:43:00 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6469AEC63
        for <linux-crypto@vger.kernel.org>; Mon, 30 Jan 2023 02:42:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 691F0CE1272
        for <linux-crypto@vger.kernel.org>; Mon, 30 Jan 2023 10:42:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B208CC4339C
        for <linux-crypto@vger.kernel.org>; Mon, 30 Jan 2023 10:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675075374;
        bh=rs//LFP9FyuJnYlpHkc8FXkwpXn94EpylTdi36ZadJY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=rojViMfhjQO+jXoGUAt+1o/jQzC3yEbLiaNC8ybhBXsD6LmPvcAFP+EWUyLP2j/dj
         9JYKgj/fLskJbjFffmRmIClIzpdZgb7r2gRoqb3GwNlUIjagf9vl9I1ogL2JM8LUwJ
         ZoAZO9W7J30tS08k/KTaYHHicnQayhzAgCM8Di6SkKzLgzIxDtdqHx6VJdmHprIGmd
         cixfsqn3lsA/+cakxIWZ93e3gOuOI4klACdtUR/n6uyXfD1QxIsn1VqHrOA27PmtPE
         Vutp/ByRVpGzAyiG/NfhoAHFAIwighRGUTAbL2RyEeYbLUy2C5K+Lwqt+xzu1DRWYf
         swjfKInn/uFWg==
Received: by mail-lj1-f176.google.com with SMTP id b13so2188341ljf.8
        for <linux-crypto@vger.kernel.org>; Mon, 30 Jan 2023 02:42:54 -0800 (PST)
X-Gm-Message-State: AO0yUKWtHdEcrLqhXr7mAg/s0zdDD1T1gngJCbZ/GwfKpqMM3eLur+SH
        +we3SsCFksMiZ2D6eWJI5rw9pGgQv06pJWK1hYQ=
X-Google-Smtp-Source: AK7set8StQI37rpoLRJM0PBZLWJ56AnXnl+zSEqgXGZ/TJN+VnSmLwXv61qQgvRbwtEJYKbf57UdEmNMzAojoaj0MG0=
X-Received: by 2002:a2e:9109:0:b0:290:66b3:53e5 with SMTP id
 m9-20020a2e9109000000b0029066b353e5mr272135ljg.57.1675075372686; Mon, 30 Jan
 2023 02:42:52 -0800 (PST)
MIME-Version: 1.0
References: <Y9eGyzZ+JAqRQvtm@gondor.apana.org.au>
In-Reply-To: <Y9eGyzZ+JAqRQvtm@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 30 Jan 2023 11:42:41 +0100
X-Gmail-Original-Message-ID: <CAMj1kXE55nxow37PEBWv8qTa8BcWwmwN2nwEwi1sQGTCkRsx9Q@mail.gmail.com>
Message-ID: <CAMj1kXE55nxow37PEBWv8qTa8BcWwmwN2nwEwi1sQGTCkRsx9Q@mail.gmail.com>
Subject: Re: [PATCH] crypto: arm64/aes-ccm - Rewrite skcipher walker loop
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

()

On Mon, 30 Jan 2023 at 09:58, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> An often overlooked aspect of the skcipher walker API is that an
> error is not just indicated by a non-zero return value, but by the
> fact that walk->nbytes is zero.
>
> Thus it is an error to call skcipher_walk_done after getting back
> walk->nbytes == 0 from the previous interaction with the walker.
>
> This is because when walk->nbytes is zero the walker is left in
> an undefined state and any further calls to it may try to free
> uninitialised stack memory.
>
> The arm64 ccm code has to deal with zero-length messages, and
> it needs to process data even when walk->nbytes == 0 is returned.
> It doesn't have this bug because there is an explicit check for
> walk->nbytes != 0 prior to the skcipher_walk_done call.
>
> However, the loop is still sufficiently different from the usual
> layout and it appears to have been copied into other code which
> then ended up with this bug.  This patch rewrites it to follow the
> usual convention of checking walk->nbytes.
>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>

This works fine with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y so

Tested-by: Ard Biesheuvel <ardb@kernel.org>

> diff --git a/arch/arm64/crypto/aes-ce-ccm-glue.c b/arch/arm64/crypto/aes-ce-ccm-glue.c
> index c4f14415f5f0..25cd3808ecbe 100644
> --- a/arch/arm64/crypto/aes-ce-ccm-glue.c
> +++ b/arch/arm64/crypto/aes-ce-ccm-glue.c
> @@ -161,43 +161,39 @@ static int ccm_encrypt(struct aead_request *req)
>         memcpy(buf, req->iv, AES_BLOCK_SIZE);
>
>         err = skcipher_walk_aead_encrypt(&walk, req, false);
> -       if (unlikely(err))
> -               return err;
>

Should we keep this? No point in carrying on, and calling
ce_aes_ccm_final() and scatterwalk_map_and_copy() in this state is
best avoided.


>         kernel_neon_begin();
>
>         if (req->assoclen)
>                 ccm_calculate_auth_mac(req, mac);
>
> -       do {
> +       while (walk.nbytes) {
>                 u32 tail = walk.nbytes % AES_BLOCK_SIZE;
> +               bool final = walk.nbytes == walk.total;
>
> -               if (walk.nbytes == walk.total)
> +               if (final)
>                         tail = 0;
>
>                 ce_aes_ccm_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
>                                    walk.nbytes - tail, ctx->key_enc,
>                                    num_rounds(ctx), mac, walk.iv);
>
> -               if (walk.nbytes == walk.total)
> -                       ce_aes_ccm_final(mac, buf, ctx->key_enc, num_rounds(ctx));
> +               if (!final)
> +                       kernel_neon_end();
> +               err = skcipher_walk_done(&walk, tail);
> +               if (!final)
> +                       kernel_neon_begin();
> +       }
>
> -               kernel_neon_end();
> +       ce_aes_ccm_final(mac, buf, ctx->key_enc, num_rounds(ctx));
>
> -               if (walk.nbytes) {
> -                       err = skcipher_walk_done(&walk, tail);
> -                       if (unlikely(err))
> -                               return err;
> -                       if (unlikely(walk.nbytes))
> -                               kernel_neon_begin();
> -               }
> -       } while (walk.nbytes);
> +       kernel_neon_end();
>
>         /* copy authtag to end of dst */
>         scatterwalk_map_and_copy(mac, req->dst, req->assoclen + req->cryptlen,
>                                  crypto_aead_authsize(aead), 1);
>
> -       return 0;
> +       return err;
>  }
>
>  static int ccm_decrypt(struct aead_request *req)
> @@ -219,37 +215,36 @@ static int ccm_decrypt(struct aead_request *req)
>         memcpy(buf, req->iv, AES_BLOCK_SIZE);
>
>         err = skcipher_walk_aead_decrypt(&walk, req, false);
> -       if (unlikely(err))
> -               return err;
>
>         kernel_neon_begin();
>
>         if (req->assoclen)
>                 ccm_calculate_auth_mac(req, mac);
>
> -       do {
> +       while (walk.nbytes) {
>                 u32 tail = walk.nbytes % AES_BLOCK_SIZE;
> +               bool final = walk.nbytes == walk.total;
>
> -               if (walk.nbytes == walk.total)
> +               if (final)
>                         tail = 0;
>
>                 ce_aes_ccm_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
>                                    walk.nbytes - tail, ctx->key_enc,
>                                    num_rounds(ctx), mac, walk.iv);
>
> -               if (walk.nbytes == walk.total)
> -                       ce_aes_ccm_final(mac, buf, ctx->key_enc, num_rounds(ctx));
> +               if (!final)
> +                       kernel_neon_end();
> +               err = skcipher_walk_done(&walk, tail);
> +               if (!final)
> +                       kernel_neon_begin();
> +       }
>
> -               kernel_neon_end();
> +       ce_aes_ccm_final(mac, buf, ctx->key_enc, num_rounds(ctx));
>
> -               if (walk.nbytes) {
> -                       err = skcipher_walk_done(&walk, tail);
> -                       if (unlikely(err))
> -                               return err;
> -                       if (unlikely(walk.nbytes))
> -                               kernel_neon_begin();
> -               }
> -       } while (walk.nbytes);
> +       kernel_neon_end();
> +
> +       if (unlikely(err))
> +               return err;
>
>         /* compare calculated auth tag with the stored one */
>         scatterwalk_map_and_copy(buf, req->src,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
