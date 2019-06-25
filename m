Return-Path: <SRS0=EEB8=UY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDE88C48BD4
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jun 2019 15:27:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD2382085A
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jun 2019 15:27:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730413AbfFYP1w (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Jun 2019 11:27:52 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:40315 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729673AbfFYP1w (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Jun 2019 11:27:52 -0400
Received: by mail-ot1-f68.google.com with SMTP id e8so17652484otl.7
        for <linux-crypto@vger.kernel.org>; Tue, 25 Jun 2019 08:27:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xXQ5w1P8Mn5zzFDA/nSH+cjZxbQeKF2c5zlTfVxRtY0=;
        b=Od22DokFzw/gKMDW1BeX9M8to1WTxhE5JW0MuUaHoUrUpbfKTANNb0E4AnohllqS9r
         80720jFf1p5vDZoFk4ilDXrvQKgNu6MlNWZfhUkD7fY7EsbvC/Okf6gFvfIXA10RQ7Jb
         tZkab0XwpYJmnq+qtyZ1rQ7EfxcgYWvQjA4VozlmwjCPtn/oCKalO5Zwj5VjjFVJNRiJ
         MAOCMzChlW+UASAKbcrXNnrWpNm53h4Oiwsfl+HdNLsaYQeaOoR/9+8o+h5fW7mipCCz
         nfS2BTjGapUeXO14vb5H1TpRBqbDmPHgAhh2vmtBpFWo0zKmwmlx4GREKdI7GTEI/xLP
         iOLA==
X-Gm-Message-State: APjAAAVk96Eyt9gVSKEgwz+8GkKarguxDOk3zb3L7vl2Htf4dk6E3tro
        fJUxaAM+lZuPe9wf4DGZAZdcr0rnS7KSOLWkzvw=
X-Google-Smtp-Source: APXvYqx4w+Nt/JXnjWGKRETFb8X2jy/hTCkPEvwGoPtCdZjewVhho/Pmc9RPx/f7R1pXUCa3kdyqLvRxTFGw/0K0kwo=
X-Received: by 2002:a05:6830:210f:: with SMTP id i15mr36506527otc.250.1561476471513;
 Tue, 25 Jun 2019 08:27:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190625145254.28510-1-ard.biesheuvel@linaro.org>
In-Reply-To: <20190625145254.28510-1-ard.biesheuvel@linaro.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 25 Jun 2019 17:27:40 +0200
Message-ID: <CAMuHMdUbnHBQoTHVd9YyU_8yn6VHdcC1-8q3GqKftMrvRV_qag@mail.gmail.com>
Subject: Re: [PATCH] crypto: morus - remove generic and x86 implementations
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>, omosnace@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Ard,

On Tue, Jun 25, 2019 at 4:53 PM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> MORUS was not selected as a winner in the CAESAR competition, which
> is not surprising since it is considered to be cryptographically
> broken. (Note that this is not an implementation defect, but a flaw
> in the underlying algorithm). Since it is unlikely to be in use
> currently, let's remove it before we're stuck with it.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Thanks for your patch!

>  arch/m68k/configs/amiga_defconfig     |    2 -
>  arch/m68k/configs/apollo_defconfig    |    2 -
>  arch/m68k/configs/atari_defconfig     |    2 -
>  arch/m68k/configs/bvme6000_defconfig  |    2 -
>  arch/m68k/configs/hp300_defconfig     |    2 -
>  arch/m68k/configs/mac_defconfig       |    2 -
>  arch/m68k/configs/multi_defconfig     |    2 -
>  arch/m68k/configs/mvme147_defconfig   |    2 -
>  arch/m68k/configs/mvme16x_defconfig   |    2 -
>  arch/m68k/configs/q40_defconfig       |    2 -
>  arch/m68k/configs/sun3_defconfig      |    2 -
>  arch/m68k/configs/sun3x_defconfig     |    2 -

For the m68k defconfig changes:
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

(but they would be updated "automatically" during the next defconfig refresh
 anyway)

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
