Return-Path: <SRS0=tkOt=CC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86DE4C433E1
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Aug 2020 19:42:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B395206BE
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Aug 2020 19:42:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="gK6niUpd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbgHXTmW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Aug 2020 15:42:22 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:56583 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbgHXTmW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Aug 2020 15:42:22 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 3d31c39f
        for <linux-crypto@vger.kernel.org>;
        Mon, 24 Aug 2020 19:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=eOMZfUA7l6dzbemv4WBqCno2B8A=; b=gK6niU
        pdmfgJzQ6q9iQ3Fjw9AwKs/8cPxK5/5RiAalPg1mSLnFHY9e2KvgMRWgjomRdyIP
        0JD6QlA749xoc/H2i83BwkqryGsDs2NgVZG4ioVgqbKWEeduVSJ737cwBJKsuF5d
        59ZJpbje5PGJYLTjxZUJPNwMXqzqFKm4iHDrfNvHLhCJpgjoESo79YwaUvm6m9cq
        9jrip4teeMBUP4Z4/eefj1PojC+IQykwlIYq4kKLlXgKaSRfDkFmskB3rlZT4ouX
        u9cc/5vTdCDIpXTP2KJdQOhdHgfFEm2u2TK2pHjrHmKidGOuKoct8tKdohlVDiBV
        9kJNA0kUUv849dLQ==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id eedc3019 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Mon, 24 Aug 2020 19:15:19 +0000 (UTC)
Received: by mail-il1-f173.google.com with SMTP id q14so8356726ilm.2
        for <linux-crypto@vger.kernel.org>; Mon, 24 Aug 2020 12:42:18 -0700 (PDT)
X-Gm-Message-State: AOAM531GMrdYfM3ck7HbKaS9qOB1pUzrF4rvJow5UIRI0WXdo+0rXkaB
        nJj5eCXn9Bi8KNUYQr/J6TSQLIz9YZIIuxowzas=
X-Google-Smtp-Source: ABdhPJyFImB+L67imy01Hsvk7ZRsOEiFu+Gk2IpiLdPv3JPr+9WuaEPNYk7lZwrvjhGLHFPEaQyIblgQ8peqWh1rC00=
X-Received: by 2002:a92:d0c7:: with SMTP id y7mr6491908ila.224.1598298138150;
 Mon, 24 Aug 2020 12:42:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200824140953.5964-1-festevam@gmail.com>
In-Reply-To: <20200824140953.5964-1-festevam@gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 24 Aug 2020 21:42:07 +0200
X-Gmail-Original-Message-ID: <CAHmME9oYMto3JHZeTQkNuc=kLX4dvcBG5meUEUEC0_mXW=jLiw@mail.gmail.com>
Message-ID: <CAHmME9oYMto3JHZeTQkNuc=kLX4dvcBG5meUEUEC0_mXW=jLiw@mail.gmail.com>
Subject: Re: [PATCH] crypto: arm/curve25519 - include <linux/scatterlist.h>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Aug 24, 2020 at 4:13 PM Fabio Estevam <festevam@gmail.com> wrote:
>
> Building ARM allmodconfig leads to the following warnings:
>
> arch/arm/crypto/curve25519-glue.c:73:12: error: implicit declaration of function 'sg_copy_to_buffer' [-Werror=implicit-function-declaration]
> arch/arm/crypto/curve25519-glue.c:74:9: error: implicit declaration of function 'sg_nents_for_len' [-Werror=implicit-function-declaration]
> arch/arm/crypto/curve25519-glue.c:88:11: error: implicit declaration of function 'sg_copy_from_buffer' [-Werror=implicit-function-declaration]
>
> Include <linux/scatterlist.h> to fix such warnings

This patch seems correct to me -- sg_copy_to_buffer, sg_nents_for_len.
I wonder what header dependency chain caused us to miss this before.
Either way,

Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>
