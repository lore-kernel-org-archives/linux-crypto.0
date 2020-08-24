Return-Path: <SRS0=tkOt=CC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FA99C433E1
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Aug 2020 15:12:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37C38206F0
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Aug 2020 15:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598281975;
	bh=0coHQ41UUwFy0hS515PRvj1tSbq5Tcq3YXnqR2p/eds=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=HpWYGA0ccdTthAHJbYraUS+wz/Bb+BPDCtVzZ1J+HpzTKWF/tK5G34fSWr7wtU7jQ
	 zhx1cA5QMcXq4cmnAFgeqGvo7C6HEFKFTqFSOeUoO8JtrZpEBLrPAr4evWFjCJrBgg
	 XhHh3g0lG4x6j3wvYOCeRxuYQJhAoMVhij3g9MaU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbgHXPL6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Aug 2020 11:11:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:37508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727980AbgHXPLr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Aug 2020 11:11:47 -0400
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1938621741
        for <linux-crypto@vger.kernel.org>; Mon, 24 Aug 2020 15:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598281904;
        bh=0coHQ41UUwFy0hS515PRvj1tSbq5Tcq3YXnqR2p/eds=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=c2UnhFSt6ef0hpO57F4+FcnIJPjoiwj+Qzcjc4uvG3yR9+w055ogS+2vqz3tZGL0b
         qALyScAXLS53IuOHkKQbV+uXsgTniRhtkIeY2SzSiwgi4a7tG1vIRcY77Kt7r0Z3K6
         fV2JmstYhVB9Uf5ebF3r4hShBlpUU4mE99kPdzIY=
Received: by mail-ot1-f46.google.com with SMTP id i11so561475otr.5
        for <linux-crypto@vger.kernel.org>; Mon, 24 Aug 2020 08:11:44 -0700 (PDT)
X-Gm-Message-State: AOAM530NYtjwlgcK4ztVF0vQmZIgjvHwXWlSAglex2YOYEa6obDmUot8
        ECr+N9YAsUVzyAAyB1yjuR7v2nkmX/8r2U6duvo=
X-Google-Smtp-Source: ABdhPJwIUuld1o+bRqVVJGlWzTJgLJ4SbJvQSy6Q+fNYjc0PNlRR+VJ8n36imcKiRaWeEoJ9/PB8TwstkOE3FG6yAmg=
X-Received: by 2002:a05:6830:1d8c:: with SMTP id y12mr4064244oti.77.1598281903466;
 Mon, 24 Aug 2020 08:11:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200824140953.5964-1-festevam@gmail.com>
In-Reply-To: <20200824140953.5964-1-festevam@gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 24 Aug 2020 17:11:32 +0200
X-Gmail-Original-Message-ID: <CAMj1kXE2osP2f+45FvOQAta8DOAaejZUZzx-sBiUnhmd8SHRVQ@mail.gmail.com>
Message-ID: <CAMj1kXE2osP2f+45FvOQAta8DOAaejZUZzx-sBiUnhmd8SHRVQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: arm/curve25519 - include <linux/scatterlist.h>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Russell King <linux@armlinux.org.uk>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 24 Aug 2020 at 16:13, Fabio Estevam <festevam@gmail.com> wrote:
>
> Building ARM allmodconfig leads to the following warnings:
>
> arch/arm/crypto/curve25519-glue.c:73:12: error: implicit declaration of function 'sg_copy_to_buffer' [-Werror=implicit-function-declaration]
> arch/arm/crypto/curve25519-glue.c:74:9: error: implicit declaration of function 'sg_nents_for_len' [-Werror=implicit-function-declaration]
> arch/arm/crypto/curve25519-glue.c:88:11: error: implicit declaration of function 'sg_copy_from_buffer' [-Werror=implicit-function-declaration]
>
> Include <linux/scatterlist.h> to fix such warnings
>
> Reported-by: Olof's autobuilder <build@lixom.net>
> Signed-off-by: Fabio Estevam <festevam@gmail.com>

Thanks for the fix - I just hit this as well.

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  arch/arm/crypto/curve25519-glue.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm/crypto/curve25519-glue.c b/arch/arm/crypto/curve25519-glue.c
> index 776ae07e0469..31eb75b6002f 100644
> --- a/arch/arm/crypto/curve25519-glue.c
> +++ b/arch/arm/crypto/curve25519-glue.c
> @@ -16,6 +16,7 @@
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/jump_label.h>
> +#include <linux/scatterlist.h>
>  #include <crypto/curve25519.h>
>
>  asmlinkage void curve25519_neon(u8 mypublic[CURVE25519_KEY_SIZE],
> --
> 2.17.1
>
