Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CB0EC433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Sep 2021 13:01:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BA8860F5D
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Sep 2021 13:01:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236441AbhITNDE convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Sep 2021 09:03:04 -0400
Received: from mail-vs1-f50.google.com ([209.85.217.50]:46710 "EHLO
        mail-vs1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbhITNDD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Sep 2021 09:03:03 -0400
Received: by mail-vs1-f50.google.com with SMTP id x74so3774700vsx.13;
        Mon, 20 Sep 2021 06:01:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=++i8xJcYeTnDgKmQgi7Yz9d+jrQSAA9oLwPVziAM1C0=;
        b=rEqF+wnm8T1TYVJBThiUxA6vYY9jRg3YrAHaig0K4mMJC+uZ38c5LXykCyf0dh/puJ
         EomaPVgN8/SBrjhNQxfUOh4OvVATAkPjx6GOQPFd56Cfx25azpJ8jB7oTm58DsQVWLht
         5Uei8+lqM8KxiksnAiwA9d14FMbI0THWjikCMixPKJ+SUHx4QjxFHt71T2Df5pMm/Np+
         GGR34Au4+eAkqqr3VlqdXhODejj6pZzuEMDgxByNYfe4p3uK+gsp47+7s3GB3w0lySlp
         Eus3bX7rDmPaRS2ZAnh2MqiBMbB2QuwmdvU6Td4gQ4l832CWpNvZ9TWQVd34tf30el2L
         2XXQ==
X-Gm-Message-State: AOAM531/sBClvqxQHxs3IC0cDqc6J0p6gjLDXEYGuHRbvp36cMTGG/hN
        zFGy/Mt4EZs80rj281uMN+k2nvYg4undu6xNvcA=
X-Google-Smtp-Source: ABdhPJy/M/ANdDNU5+Sl8XEvkvOXVOGmOJk1+6VA+foxZnauYjFVAb9mYIdlMK+bHViTR+fefyC4gnx8Z0vR2afEtWY=
X-Received: by 2002:a67:f147:: with SMTP id t7mr9708448vsm.41.1632142896269;
 Mon, 20 Sep 2021 06:01:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210920080635.253826-1-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20210920080635.253826-1-u.kleine-koenig@pengutronix.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 20 Sep 2021 15:01:25 +0200
Message-ID: <CAMuHMdVAjtF2GKXgHgbmjUnMdWxqSpusKV_EieF2wEWezdqrPQ@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Remove Matt Mackall as his identity is obsolete
To:     =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Olivia Mackall <olivia@selenic.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Uwe,

On Mon, Sep 20, 2021 at 11:52 AM Uwe Kleine-König
<u.kleine-koenig@pengutronix.de> wrote:
> The mails I sent to Matt on September 14 and 20 both were refused by the
> MTA responsible for selenic.com (i.e. waste.org) with:
>
>         554 5.7.1 <mpm@selenic.com>: Recipient address rejected: This identity is obsolete
>
> Also the most recent commit that involved him (ignoring "Cc: Matt
> Mackall <mpm@selenic.com>" footers) is commit 330e0a01d54c (MAINTAINERS:
> Theodore Ts'o is taking over the random driver) where he was removed
> from the entry for random number drivers in 2012.
>
> So drop him completely from the list of maintainers.
>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  MAINTAINERS | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index d7b4f32875a9..805630c67a1f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6812,7 +6812,6 @@ F:        drivers/media/usb/em28xx/
>
>  EMBEDDED LINUX
>  M:     Paul Gortmaker <paul.gortmaker@windriver.com>
> -M:     Matt Mackall <mpm@selenic.com>

Perhaps this should be replaced by
"Olivia Mackall <olivia@selenic.com>" instead?

>  M:     David Woodhouse <dwmw2@infradead.org>
>  L:     linux-embedded@vger.kernel.org
>  S:     Maintained
> @@ -8157,7 +8156,6 @@ F:        include/trace/events/hwmon*.h
>  K:     (devm_)?hwmon_device_(un)?register(|_with_groups|_with_info)
>
>  HARDWARE RANDOM NUMBER GENERATOR CORE
> -M:     Matt Mackall <mpm@selenic.com>
>  M:     Herbert Xu <herbert@gondor.apana.org.au>
>  L:     linux-crypto@vger.kernel.org
>  S:     Odd fixes

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
