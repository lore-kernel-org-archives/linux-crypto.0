Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BBCAC433EF
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Oct 2021 12:29:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A46560551
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Oct 2021 12:29:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbhJaMbn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 31 Oct 2021 08:31:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:33606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229798AbhJaMbm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 31 Oct 2021 08:31:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0EEA61039;
        Sun, 31 Oct 2021 12:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635683351;
        bh=ph3gBE0UwLAlyx3ipLRKhIarn/rc9a7pyxJUqyXnYE8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=AlSTPonwsVQTS7e6538bAhrsoddx69iTXWdkrXr6iSt+XpMXlvezHzTCflXQ39yZr
         OXas2DnW6jbe82k53YFTnhcdR/Dfe1W5dbrmkZWe2AKWyXi39EJd7gs99EG0zrJ4YA
         Xpev1Vw3s09aDXg61qEWMTVAKFL7NeeehC2vd6sAmYng5egDyFv+BArjzaYVH4JvhM
         L6tmAnOfiZVT0OSCNoMhPNbUslsbB5DWX/ZZjBNvxpUd/y3ZDgzxu6h22cW/guM3q/
         vk0rVuybrU/inRfOTAJWpW1Cv2g71dvomxt7Jtv2+PxHX8V1cAiAPNufDxnzzmHZuJ
         KPWUD7xnP/ECQ==
Received: by mail-ot1-f42.google.com with SMTP id l16-20020a9d6a90000000b0054e7ab56f27so21208322otq.12;
        Sun, 31 Oct 2021 05:29:10 -0700 (PDT)
X-Gm-Message-State: AOAM531Pbo9CzJYU1hAabTxmni2exjSYt4Lo4VA2ewAdEA1daORAheir
        6TKV5pJHDd77w2XVjpNyYTLkjMR4okkHb6/DpdY=
X-Google-Smtp-Source: ABdhPJwgPIx5Ajj0S1T2KjyV/1WG7VBWyhFaagI5h0bGfEPDwtYo8G+a8GQ77xOCXiUmzae1g2e9z77AEw4JstfixnE=
X-Received: by 2002:a05:6830:1d6e:: with SMTP id l14mr16396459oti.147.1635683350134;
 Sun, 31 Oct 2021 05:29:10 -0700 (PDT)
MIME-Version: 1.0
References: <20211029135454.4383-1-nicolas.toromanoff@foss.st.com> <20211029135454.4383-4-nicolas.toromanoff@foss.st.com>
In-Reply-To: <20211029135454.4383-4-nicolas.toromanoff@foss.st.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sun, 31 Oct 2021 13:28:58 +0100
X-Gmail-Original-Message-ID: <CAMj1kXF5_2AnQH8pjgzbeq63iSkdkUVq3wZM_NURotoHj0sJMw@mail.gmail.com>
Message-ID: <CAMj1kXF5_2AnQH8pjgzbeq63iSkdkUVq3wZM_NURotoHj0sJMw@mail.gmail.com>
Subject: Re: [PATCH 3/8] crypto: stm32/cryp - fix CTR counter carry
To:     Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Marek Vasut <marex@denx.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 29 Oct 2021 at 16:01, Nicolas Toromanoff
<nicolas.toromanoff@foss.st.com> wrote:
>
> Fix issue in CTR counter overflow, the carry-over is now properly
> managed.
> Fixes: bbb2832620ac ("crypto: stm32 - Fix sparse warnings")
>
> Signed-off-by: Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>
> ---
>  drivers/crypto/stm32/stm32-cryp.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
> index 7b55ad6d2f1a..6eeeca0d70ce 100644
> --- a/drivers/crypto/stm32/stm32-cryp.c
> +++ b/drivers/crypto/stm32/stm32-cryp.c
> @@ -163,7 +163,7 @@ struct stm32_cryp {
>         struct scatter_walk     in_walk;
>         struct scatter_walk     out_walk;
>
> -       u32                     last_ctr[4];
> +       __be32                  last_ctr[4];
>         u32                     gcm_ctr;
>  };
>
> @@ -1219,25 +1219,26 @@ static void stm32_cryp_check_ctr_counter(struct stm32_cryp *cryp)
>
>         if (unlikely(cryp->last_ctr[3] == 0xFFFFFFFF)) {
>                 cryp->last_ctr[3] = 0;
> -               cryp->last_ctr[2]++;
> +               cryp->last_ctr[2] = cpu_to_be32(be32_to_cpu(cryp->last_ctr[2]) + 1);
>                 if (!cryp->last_ctr[2]) {
> -                       cryp->last_ctr[1]++;
> +                       cryp->last_ctr[1] = cpu_to_be32(be32_to_cpu(cryp->last_ctr[1]) + 1);
>                         if (!cryp->last_ctr[1])
> -                               cryp->last_ctr[0]++;
> +                               cryp->last_ctr[0] = cpu_to_be32(be32_to_cpu(cryp->last_ctr[0]) + 1);
>                 }
>

crypto_inc() ??

>                 cr = stm32_cryp_read(cryp, CRYP_CR);
>                 stm32_cryp_write(cryp, CRYP_CR, cr & ~CR_CRYPEN);
>
> -               stm32_cryp_hw_write_iv(cryp, (__be32 *)cryp->last_ctr);
> +               stm32_cryp_hw_write_iv(cryp, cryp->last_ctr);
>
>                 stm32_cryp_write(cryp, CRYP_CR, cr);
>         }
>
> -       cryp->last_ctr[0] = stm32_cryp_read(cryp, CRYP_IV0LR);
> -       cryp->last_ctr[1] = stm32_cryp_read(cryp, CRYP_IV0RR);
> -       cryp->last_ctr[2] = stm32_cryp_read(cryp, CRYP_IV1LR);
> -       cryp->last_ctr[3] = stm32_cryp_read(cryp, CRYP_IV1RR);
> +       /* The IV registers are BE  */
> +       cryp->last_ctr[0] = cpu_to_be32(stm32_cryp_read(cryp, CRYP_IV0LR));
> +       cryp->last_ctr[1] = cpu_to_be32(stm32_cryp_read(cryp, CRYP_IV0RR));
> +       cryp->last_ctr[2] = cpu_to_be32(stm32_cryp_read(cryp, CRYP_IV1LR));
> +       cryp->last_ctr[3] = cpu_to_be32(stm32_cryp_read(cryp, CRYP_IV1RR));
>  }
>
>  static bool stm32_cryp_irq_read_data(struct stm32_cryp *cryp)
> --
> 2.17.1
>
