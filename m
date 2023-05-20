Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D0E0C77B7A
	for <linux-crypto@archiver.kernel.org>; Sat, 20 May 2023 17:39:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbjETRjx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 20 May 2023 13:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjETRjx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 20 May 2023 13:39:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B94F119
        for <linux-crypto@vger.kernel.org>; Sat, 20 May 2023 10:39:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 730FE609FE
        for <linux-crypto@vger.kernel.org>; Sat, 20 May 2023 17:39:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED16C433EF
        for <linux-crypto@vger.kernel.org>; Sat, 20 May 2023 17:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684604390;
        bh=6P8/lVWQpovLRgNVksE4mLA77F+U+8OUJHrd/WGg2qw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=vEMWJTV7sWJ7gL1RtZvlC8ruLD7gn36lPkF3UpMX1BbrYHJV+JbnrO+Q/RkU+Z02O
         7eYztg/v5LIdiwmiMB6fLSNyChtDx88ZZ/dIeIgR80PZl2Ro8UEV3li0W5Y0KFvwkU
         BehxjabzB0/zZNZFLBqiOSVaf+zSUoirYCFbhQcxAiJv4KY2RP6iAL1j98tNGwCPGN
         +IhUbdXDXB3OYEd0fmI5SMe5TRW1K/pyfpVvJmCF2OmBgdiyH3+qiWES5yKhnK08NE
         mUog0BN2xDPNHQf4m/QLe/OPW4bOympNY+JY7jbyLEBeaDEvqbOLI5BFAwVMRFsfKf
         z/6Jjjb63xDGQ==
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-4f00c33c3d6so5190930e87.2
        for <linux-crypto@vger.kernel.org>; Sat, 20 May 2023 10:39:50 -0700 (PDT)
X-Gm-Message-State: AC+VfDy1w4b5vOwTgBg28eEBdoWprqBcARBrwFrmki8ZOXgwaCeEM8Td
        kD065cTAw09hz4fDi5L+CMH2ZH9lA8KW76iyBAE=
X-Google-Smtp-Source: ACHHUZ5sj0GySKWTOK7pkQ1rvIRJlPg6++vEb7qfNCjeS7SXWz+871O2l/VsZcBCOO++9vXcS9XllOSuL6yQuuyF5Q4=
X-Received: by 2002:a05:6512:376d:b0:4ef:ed49:fcc2 with SMTP id
 z13-20020a056512376d00b004efed49fcc2mr1920720lft.26.1684604388884; Sat, 20
 May 2023 10:39:48 -0700 (PDT)
MIME-Version: 1.0
References: <20230520173105.8562-1-ebiggers@kernel.org>
In-Reply-To: <20230520173105.8562-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sat, 20 May 2023 19:39:37 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGkbOZ0hBr4Q3=MNoh+YrVV_fdq=banHJ-+0pO_NPw2Ww@mail.gmail.com>
Message-ID: <CAMj1kXGkbOZ0hBr4Q3=MNoh+YrVV_fdq=banHJ-+0pO_NPw2Ww@mail.gmail.com>
Subject: Re: [PATCH] crypto/Kconfig: warn about performance overhead of CRYPTO_STATS
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 20 May 2023 at 19:31, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Make the help text for CRYPTO_STATS explicitly mention that it reduces
> the performance of the crypto API.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  crypto/Kconfig | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 42751d63cd4d9..fdf3742f1106b 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -1393,6 +1393,9 @@ config CRYPTO_STATS
>         help
>           Enable the gathering of crypto stats.
>
> +         Enabling this option reduces the performance of the crypto API.  It
> +         should only be enabled when there is actually a use case for it.
> +
>           This collects data sizes, numbers of requests, and numbers
>           of errors processed by:
>           - AEAD ciphers (encrypt, decrypt)
>
> base-commit: f573db7aa528f11820dcc811bc7791b231d22b1c
> --
> 2.40.1
>
