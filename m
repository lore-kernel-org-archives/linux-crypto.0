Return-Path: <SRS0=nWKA=DA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00B10C4363D
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Sep 2020 14:05:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB7D82075B
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Sep 2020 14:05:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbgIWOFy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Sep 2020 10:05:54 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:41525 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgIWOFx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Sep 2020 10:05:53 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Sep 2020 10:05:53 EDT
Received: from mail-qk1-f169.google.com ([209.85.222.169]) by
 mrelayeu.kundenserver.de (mreue010 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1N7zW7-1kXXyV3dYp-0153Ri; Wed, 23 Sep 2020 16:00:49 +0200
Received: by mail-qk1-f169.google.com with SMTP id c2so3247997qkf.10;
        Wed, 23 Sep 2020 07:00:48 -0700 (PDT)
X-Gm-Message-State: AOAM532WbjWFqoPLs5mT9O4vM77pMPOtUCiDGaJU+DjYMwsYVsrSJVJa
        QvT+YVfwuTExOs+2m5n+xs8Eizp/Mbpl6vgN2bY=
X-Google-Smtp-Source: ABdhPJxXESklaivIXzQ968fTEsIrcE3DWT9feSILmcmi8tbGgjtV4HaWGcVIC9yHT4lQ1WgKmXoX5Y9Le1PvsAoXQVA=
X-Received: by 2002:a05:620a:15a7:: with SMTP id f7mr7626qkk.3.1600869647538;
 Wed, 23 Sep 2020 07:00:47 -0700 (PDT)
MIME-Version: 1.0
References: <1600627038-40000-1-git-send-email-clabbe@baylibre.com> <1600627038-40000-5-git-send-email-clabbe@baylibre.com>
In-Reply-To: <1600627038-40000-5-git-send-email-clabbe@baylibre.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 23 Sep 2020 16:00:32 +0200
X-Gmail-Original-Message-ID: <CAK8P3a34V16PUoVJjoUOVCik_rdb6vAy=54qRzWdO+aJcwUwsg@mail.gmail.com>
Message-ID: <CAK8P3a34V16PUoVJjoUOVCik_rdb6vAy=54qRzWdO+aJcwUwsg@mail.gmail.com>
Subject: Re: [PATCH v2 4/7] crypto: sun4i-ss: handle BigEndian for cipher
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:2bpN2sFSxfZKkmsTy1EpAAHr0i+EJ6f146zf4oJiD/jO8k+1DRR
 Cq65zHZFWwl2tpROk+LvM3vYxXI9jFEngmCQ1AaeqvROH3Qf8dUWg7FG803KKQESM+lbkUn
 F2XMqJihQDEQgeEulUhwVJ8DN8Ig0Ir3J4cuAzVjDbIW8YMouN42p16b0szTDgN6NaqAlbI
 7i6JiI7BhhEgx2c2BgYRg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:jKZn2/Q/Wpg=:17DvH8ES/2k1B78qmPr24j
 9Ksf+7lrinLZOEozR5lKnW4/6ZO6IPo5n8+Ktxff3L6tlYaNwyoAYOW7zonTO2NKRBDIj9a8/
 Q4/iRNA/KF1noiCm/CtwGZAq1nvc0miZ/kBwqR5NJ3j9XS29WGLUbGH2uGncN1+PguQnIFhmL
 5yUok0P7wwKevheK5MHKg/V8UsJHguJ5cn58UWMQqLp0G7l9DxIDPoe5axrNVV0pDbbBBzGiC
 VOROFsVuJAmdpeehEaR26DbKK1eQUPhGBnms6a/b+fuCOL+vZg8B0bDFpalMFfW4lWHULbMuX
 6b+6SL4PNsPLGWwxaMBmfA3LjQm/a+9hhCxTenDM9pH9sXPOvdx5dnpL/zLhbpYHlJZf3Moue
 RI91+LDUWwTBOVHEt5DctDq7viaXFkgVaK2p4+AG+u4HTLgeskIjwHWooMC2rYDsgY2we+6c8
 fOcFpfqj0aSjQyELET8pihruGpoYcYc8DBsUbYBiif2SmA9LF8cZtc1ebOBw/dn/Z9gDwSrAv
 PgYyzgxwlXy6D4lYk4j+jV9dTF7eFd81O5uz3L3ZVF6l8U0zuZnAtf3mIcyZEwHnRGdC7vu15
 eOWoHQpvRrKQkcX4IjJ/fCm9A3+7Sr9eU+6ooJT1tzO8KJ2sdw3x8rc+yD9ffLYsMoLApGRkI
 i17ghz/rPkQ/UIsWBE94N+u+eeDfI6XlV1jRfOScUQUhevGE5GGD1UzlvxpWHt6B29zBbQq7o
 8b+26mj50D1Kt3XAuR3UDUdgZE7cuRfrhdGlqMZwO5d0Hzz/HOnsLp9VW87NFwK6nDseiGZgy
 fZeuiB5Up71MIPpOX8FgdwPVjKhNGmD+9U9fGBeKaK/PSn5PLTfIYV+vR1TtOQw1mUWR7/o
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Sep 20, 2020 at 8:37 PM Corentin Labbe <clabbe@baylibre.com> wrote:
>
> Ciphers produce invalid results on BE.
> Key and IV need to be written in LE.
>
> Fixes: 6298e948215f2 ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>  drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
> index c6c25204780d..a05889745097 100644
> --- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
> +++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
> @@ -52,13 +52,13 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
>
>         spin_lock_irqsave(&ss->slock, flags);
>
> -       for (i = 0; i < op->keylen; i += 4)
> -               writel(*(op->key + i / 4), ss->base + SS_KEY0 + i);
> +       for (i = 0; i < op->keylen / 4; i++)
> +               writel(cpu_to_le32(op->key[i]), ss->base + SS_KEY0 + i * 4);

I suspect what you actually want here is writesl() in place of the
loop. This skips the byteswap on big-endian, rather than swapping
each word twice.

The point is that this register seems to act as a FIFO for a byte-stream
rather than a 32-bit fixed-endian register.

     Arnd
