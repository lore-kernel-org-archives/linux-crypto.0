Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6F86C77B60
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Mar 2023 11:01:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbjC1LBS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Mar 2023 07:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbjC1LBR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Mar 2023 07:01:17 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC9037A8F
        for <linux-crypto@vger.kernel.org>; Tue, 28 Mar 2023 04:01:14 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-54606036bb3so56558207b3.6
        for <linux-crypto@vger.kernel.org>; Tue, 28 Mar 2023 04:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680001274;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+fgeMetkUHl5uF0RC5fOFpwZWWL0WPLVzX+x0gJMhjk=;
        b=FNjdZIOSPlXF6+ZBjpZXVTK3KrDZjuECOPHp0Z4AFMBhownpN1aIv7BS+d7vR544mP
         xTlTmPPvS6NHSKB6V7URLEdFefrFwql0OyZoaKik2cuU397pIgBMQXZsvM517UZ4DzDC
         5DJvrnK4h5V484cMJh4SpW/K84HnR/AU8fofYZ+R93fouP+m5cFTj2G+71JleBTW41R3
         Pit+25cPIFSlmqU+4cB/jBPntBxoP9sBULFfmJl2ImekZyVKCEVlHaBWgzo0AgMMfU0t
         9T3AQ4EHfMu3XZXJJ/315bdXtU8wg8SLHdZ3u7DKfJRVkRIXUBenuX/exOHX55D9MueN
         rXcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680001274;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+fgeMetkUHl5uF0RC5fOFpwZWWL0WPLVzX+x0gJMhjk=;
        b=mYbVTam2E1S8WXO/ZHAbjg5iytzSzYTqEnOJF4Xr0qKJ9uwPUhznULt+r92jHo0siJ
         HTB4oFr6Gz5mYlT4O1hpCsCE4LcY32YNiwnkoed6UyoFHcLdJByi4fpn5B94PpTB4+Jh
         vlY45xopE1NG1QSCOmjZ+qHOzFahLpOb1Pc/kUqKRq4UJRg9NDhXwK8B3+m4SFwqWVUC
         EzEAsmoqU8ICaGtELezY92XWcTWJ+a6Jxcco96Q6A082jimW2q3OSXA8KAvFgnb+kP2q
         w2FAmgPwLyE7antEnjiU0rSz2QTGxHbPnOioV5wKx96mp4u0M9ayt2VHkimEDL3rx9el
         Vx8Q==
X-Gm-Message-State: AAQBX9fR9PXcd6IhcyHcsfuT6lntgYO5gSBHPeBqwkvaTmUQoKKBPFxk
        +was3RLA3ijuTW/oJ+G6oaNnRP5N5Jv3xXPc1URe2ARm
X-Google-Smtp-Source: AKy350avqf3y8y/lYar+0FtL5NnWHb471GTkrJFku4XdelFS/5mLRwWuxKjQaWey2iVWz9WSKNmDcJlD6nuHSaxyTe0=
X-Received: by 2002:a81:d30b:0:b0:545:64d7:5086 with SMTP id
 y11-20020a81d30b000000b0054564d75086mr7121397ywi.1.1680001273515; Tue, 28 Mar
 2023 04:01:13 -0700 (PDT)
MIME-Version: 1.0
References: <ZCJk8JQV+0N3VwPS@gondor.apana.org.au>
In-Reply-To: <ZCJk8JQV+0N3VwPS@gondor.apana.org.au>
From:   =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Date:   Tue, 28 Mar 2023 13:01:01 +0200
Message-ID: <CAAUqJDtqmXOBNY0YzkuzfaK-zvzhHqazc+=vs=OouKLBAZ90Pw@mail.gmail.com>
Subject: Re: [PATCH] crypto: algif_hash - Allocate hash state with kmalloc
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas BOURGOIN <thomas.bourgoin@foss.st.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 28, 2023 at 5:58=E2=80=AFAM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> Allocating the hash state on the stack limits its size.  Change
> this to use kmalloc so the limit can be removed for new drivers.
>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
> index 1d017ec5c63c..63af72e19fa8 100644
> --- a/crypto/algif_hash.c
> +++ b/crypto/algif_hash.c
> @@ -235,24 +235,31 @@ static int hash_accept(struct socket *sock, struct =
socket *newsock, int flags,
>         struct alg_sock *ask =3D alg_sk(sk);
>         struct hash_ctx *ctx =3D ask->private;
>         struct ahash_request *req =3D &ctx->req;
> -       char state[HASH_MAX_STATESIZE];
> +       struct crypto_ahash *tfm;
>         struct sock *sk2;
>         struct alg_sock *ask2;
>         struct hash_ctx *ctx2;
> +       char *state;
>         bool more;
>         int err;
>
> +       tfm =3D crypto_ahash_reqtfm(req);
> +       state =3D kmalloc(crypto_ahash_statesize(tfm), GFP_KERNEL);

Shouldn't sock_kmalloc() be used instead?

> +       err =3D -ENOMEM;
> +       if (!state)
> +               goto out;
> +
>         lock_sock(sk);
>         more =3D ctx->more;
>         err =3D more ? crypto_ahash_export(req, state) : 0;
>         release_sock(sk);
>
>         if (err)
> -               return err;
> +               goto out_free_state;
>
>         err =3D af_alg_accept(ask->parent, newsock, kern);
>         if (err)
> -               return err;
> +               goto out_free_state;
>
>         sk2 =3D newsock->sk;
>         ask2 =3D alg_sk(sk2);
> @@ -260,7 +267,7 @@ static int hash_accept(struct socket *sock, struct so=
cket *newsock, int flags,
>         ctx2->more =3D more;
>
>         if (!more)
> -               return err;
> +               goto out_free_state;
>
>         err =3D crypto_ahash_import(&ctx2->req, state);
>         if (err) {
> @@ -268,6 +275,10 @@ static int hash_accept(struct socket *sock, struct s=
ocket *newsock, int flags,
>                 sock_put(sk2);
>         }
>
> +out_free_state:
> +       kfree_sensitive(state);
> +
> +out:
>         return err;
>  }
>
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
