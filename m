Return-Path: <SRS0=bFPd=CD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FDD0C433E1
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Aug 2020 14:00:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EEF020665
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Aug 2020 14:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598364042;
	bh=7VoAAPVacUCZkfNz/3lvK/x0OA/mKGggQ0/VQkY6OOg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=SMuGT33aB0hkkbiFwX9gj0CY/D4RMyON/3ARafmYcE3yt4Kge109ZqiG0v09skUEq
	 1Foaal+HfiHTTOWOnTzITaXD0dgW+IdAnvXNeSXfaDgtgMAZzs4RFnLekjGygeZfhx
	 z0nvwHHDGf5eIXIsAHX6H7suKv55wxspI8DR1mA4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgHYOAf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Aug 2020 10:00:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:42770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726432AbgHYOAI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Aug 2020 10:00:08 -0400
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F24C20786
        for <linux-crypto@vger.kernel.org>; Tue, 25 Aug 2020 14:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598364007;
        bh=7VoAAPVacUCZkfNz/3lvK/x0OA/mKGggQ0/VQkY6OOg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Cew30mprZTIbpRmFGXVz1Lqj++QL/82eIgehdnW9HjfN7JPUGbC7yonutV9mVC/aT
         6aOZYjpeRmVUrQSgyot3lX+U5c5v41Zzbyiwn0yzfKFAzJ2UhkQFVj6wmxYwgurMgy
         cw3ZBDwedIK98Xm2cvSVAdrbDparIsCcFUcmkEu8=
Received: by mail-oi1-f173.google.com with SMTP id u24so11669916oic.7
        for <linux-crypto@vger.kernel.org>; Tue, 25 Aug 2020 07:00:07 -0700 (PDT)
X-Gm-Message-State: AOAM533KKsMGs4APfDf5ZzbnhZKMRt3dEGA0N1c4TQ6Wxs4O3vDQr84H
        +1oeeDnnYyaR7Jhd7T5LVpyU3ETrEwPGxivRrxE=
X-Google-Smtp-Source: ABdhPJx5AVoLXFkNIgo/21dGo9p4oyrvumZGDLUOS8Asdqkn3cjCoRZ7hWwM/7nHyM3081o0BPG4p6CSIyIu6n3nvgw=
X-Received: by 2002:aca:5401:: with SMTP id i1mr1083017oib.33.1598364006802;
 Tue, 25 Aug 2020 07:00:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200825013428.GA14497@gondor.apana.org.au>
In-Reply-To: <20200825013428.GA14497@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 25 Aug 2020 15:59:56 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEWyWZBVLubUqZn0Gutu4VQ7Pe6PXsPZZWbh7HX8wi=9w@mail.gmail.com>
Message-ID: <CAMj1kXEWyWZBVLubUqZn0Gutu4VQ7Pe6PXsPZZWbh7HX8wi=9w@mail.gmail.com>
Subject: Re: [PATCH] crypto: arm64/sha - Add declarations for assembly variables
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Matthias Kaehlcke <mka@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 25 Aug 2020 at 03:41, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> This patch adds declarations for variables only used by assembly
> code to silence compiler warnings:
>
>   CC [M]  arch/arm64/crypto/sha1-ce-glue.o
>   AS [M]  arch/arm64/crypto/sha1-ce-core.o
>   CC [M]  arch/arm64/crypto/sha2-ce-glue.o
>   AS [M]  arch/arm64/crypto/sha2-ce-core.o
>   CHECK   ../arch/arm64/crypto/sha1-ce-glue.c
>   CHECK   ../arch/arm64/crypto/sha2-ce-glue.c
> ../arch/arm64/crypto/sha1-ce-glue.c:38:11: warning: symbol 'sha1_ce_offsetof_count' was not declared. Should it be static?
> ../arch/arm64/crypto/sha1-ce-glue.c:39:11: warning: symbol 'sha1_ce_offsetof_finalize' was not declared. Should it be static?
> ../arch/arm64/crypto/sha2-ce-glue.c:38:11: warning: symbol 'sha256_ce_offsetof_count' was not declared. Should it be static?
> ../arch/arm64/crypto/sha2-ce-glue.c:40:11: warning: symbol 'sha256_ce_offsetof_finalize' was not declared. Should it be static?
>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

>
> diff --git a/arch/arm64/crypto/sha1-ce-glue.c b/arch/arm64/crypto/sha1-ce-glue.c
> index 565ef604ca04..c63b99211db3 100644
> --- a/arch/arm64/crypto/sha1-ce-glue.c
> +++ b/arch/arm64/crypto/sha1-ce-glue.c
> @@ -25,6 +25,9 @@ struct sha1_ce_state {
>         u32                     finalize;
>  };
>
> +extern const u32 sha1_ce_offsetof_count;
> +extern const u32 sha1_ce_offsetof_finalize;
> +
>  asmlinkage void sha1_ce_transform(struct sha1_ce_state *sst, u8 const *src,
>                                   int blocks);
>
> diff --git a/arch/arm64/crypto/sha2-ce-glue.c b/arch/arm64/crypto/sha2-ce-glue.c
> index 9450d19b9e6e..5e956d7582a5 100644
> --- a/arch/arm64/crypto/sha2-ce-glue.c
> +++ b/arch/arm64/crypto/sha2-ce-glue.c
> @@ -25,6 +25,9 @@ struct sha256_ce_state {
>         u32                     finalize;
>  };
>
> +extern const u32 sha256_ce_offsetof_count;
> +extern const u32 sha256_ce_offsetof_finalize;
> +
>  asmlinkage void sha2_ce_transform(struct sha256_ce_state *sst, u8 const *src,
>                                   int blocks);
>
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
