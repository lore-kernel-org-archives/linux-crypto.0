Return-Path: <SRS0=45GR=NR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A38EBC32789
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Nov 2018 14:24:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A3572085B
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Nov 2018 14:24:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="FFR/qRcD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A3572085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388703AbeKFXuC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Nov 2018 18:50:02 -0500
Received: from mail-it1-f196.google.com ([209.85.166.196]:39895 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388493AbeKFXuC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Nov 2018 18:50:02 -0500
Received: by mail-it1-f196.google.com with SMTP id m15so17796433itl.4
        for <linux-crypto@vger.kernel.org>; Tue, 06 Nov 2018 06:24:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=e1u2xEPh7BjjKSzgx162BBVsgAnWyuXMU2Girk922So=;
        b=FFR/qRcDQVDg+Yg5f65+ghAtPi51do0IhGgM8IeWLEbndc9E1RBxwwigBwI944iwd3
         JyZy6l0K++E75SrWWUeJc9VxXAPs03z7dN8Gv/Gh7ELbLRXFjNbuP+sEzbkFCN05m+7P
         4iaDgY/4HtHzmfTWTMZe4o0FdHZaXcYSqiYhA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=e1u2xEPh7BjjKSzgx162BBVsgAnWyuXMU2Girk922So=;
        b=UVZaS2Wul8MOaeFh+BURKZFXOo00nlF1+tApqOXDmf/mFNLRPB7duuLhXXWNfpKY3E
         +y4oli0MO/HSWcznD3JaJ0rYHi7G6eEeUeEat/GsW1hG+i4ofEpftjztPisOFBjoMPsA
         DL4nSlLO2tMWctSSKa3QM25WIxeWjvAnxnTn88xqqVCPT5d5O4s2PSQyS895lE/YtP8k
         im5/ImvsdnJleOT/GWr8KRg7mZyecBSpBbCoSsxI5zQZYSJ/x3iGu5PUIoqq44dCwHPb
         nbegKM+NhuNwLPLSwYL7tZi+g8bVYI5ev6YbUWeRfKt51WlWmHUl7sLNaxCnYgXdFAjG
         eOhw==
X-Gm-Message-State: AGRZ1gKvRBC8YUhgxokQG3cZgqakXV4XhtyvSGx4bFLYpOvZKA1aNGti
        S8naHjTgTUwtaFoxfR8nMNhEqYtAGus/WmDlH48UTch0
X-Google-Smtp-Source: AJdET5fgAzXqpz4O4efMvgYQPCIU/4BVC6jqwQ9kWFZj4OELI97YWK5lujoKqao6Vhjdd0rigxahpp3rVeQ2roZr4VU=
X-Received: by 2002:a02:8449:: with SMTP id l9-v6mr11842524jah.130.1541514274582;
 Tue, 06 Nov 2018 06:24:34 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a6b:4f16:0:0:0:0:0 with HTTP; Tue, 6 Nov 2018 06:24:33 -0800 (PST)
In-Reply-To: <20181106121614.GA1985@hp-pavilion-15-notebook-pc-brajeswar>
References: <20181106121614.GA1985@hp-pavilion-15-notebook-pc-brajeswar>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 6 Nov 2018 15:24:33 +0100
Message-ID:
 <CAKv+Gu-2-DkVCOzVb_dRqr=nfiaPuec5XQT9V7z3RxuBdd-k9g@mail.gmail.com>
Subject: Re: [PATCH] arm/crypto/aes-ce-glue.c: Remove duplicate header
To:     Brajeswar Ghosh <brajeswar.linux@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>, jrdr.linux@gmail.com,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        sabyasachi.linux@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181106142433.1tyFJwYz8xYeIFncffmakS0IaX-SwXJBvTlHb1JYsbw@z>

On 6 November 2018 at 13:16, Brajeswar Ghosh <brajeswar.linux@gmail.com> wrote:
> Remove asm/hwcap.h which is included more than once
>
> Signed-off-by: Brajeswar Ghosh <brajeswar.linux@gmail.com>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  arch/arm/crypto/aes-ce-glue.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/arch/arm/crypto/aes-ce-glue.c b/arch/arm/crypto/aes-ce-glue.c
> index d0a9cec73707..5affb8482379 100644
> --- a/arch/arm/crypto/aes-ce-glue.c
> +++ b/arch/arm/crypto/aes-ce-glue.c
> @@ -10,7 +10,6 @@
>
>  #include <asm/hwcap.h>
>  #include <asm/neon.h>
> -#include <asm/hwcap.h>
>  #include <crypto/aes.h>
>  #include <crypto/internal/simd.h>
>  #include <crypto/internal/skcipher.h>
> --
> 2.17.1
>
