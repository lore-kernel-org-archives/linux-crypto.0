Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D53F5C433E0
	for <linux-crypto@archiver.kernel.org>; Sun, 24 Jan 2021 14:31:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A65CD22795
	for <linux-crypto@archiver.kernel.org>; Sun, 24 Jan 2021 14:31:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725984AbhAXOb3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 24 Jan 2021 09:31:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:56052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725798AbhAXOb2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 24 Jan 2021 09:31:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6E6D22CF6;
        Sun, 24 Jan 2021 14:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611498647;
        bh=KmPAS31taHTfH4O3bae4PST2emZ0cyqJDYQxNK0cLzE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=dIgY2v7uRPRLhKSUs6EyBDK23uk5lT2X2MbPS/4fZC0jb+wmzYSFmZMBF8PMJcf67
         3igBzhPP6dNIetIiyCopT9RWISsR7JocqVKVmqxFoTjiSRVgET4tzFR68NXKxHcteq
         C4Xw1ibqg/e6EcX240by4mcw9RU5fDwSWwoAx1rAVWaGPNZQngy7ZLranCpXI5FOZM
         8JDsqWzww4LGCp32PIFvtXJ+gZ/cdL6BrJSGB17yotwfeX6B+fhfYJrzOeW/TJv4Bg
         TS8vsvu/eNQql8x1UmBhL10+QGQHHwJ5ZpMTxitTEExMGd0e0y2/XXg+m9RGDjHBlp
         lGYdHVT+HyJzg==
Received: by mail-oo1-f49.google.com with SMTP id j8so2661159oon.3;
        Sun, 24 Jan 2021 06:30:47 -0800 (PST)
X-Gm-Message-State: AOAM5321mFLSK1UTI3+RMv00ykVa8DANh3iyP588ibf+ZIFJNz6btkeX
        6We2k7+eSOgxPSsrGHnQt5JARXJT5QbiUjz37aI=
X-Google-Smtp-Source: ABdhPJx69NceotqqbgFwSF84K0FaafFE9UfYetMtmIsKznfyHD6o6ubxIjSP4QsaUc+2ZHqsKVqrTqJkbx9i/oRB/po=
X-Received: by 2002:a05:6820:283:: with SMTP id q3mr2867813ood.13.1611498647131;
 Sun, 24 Jan 2021 06:30:47 -0800 (PST)
MIME-Version: 1.0
References: <20210124142806.GA29180@ls3530.fritz.box>
In-Reply-To: <20210124142806.GA29180@ls3530.fritz.box>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sun, 24 Jan 2021 15:30:36 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEfw2a7QAfFUGemV-uiXF1oSeWnBzWouXFbp2u6g7rojQ@mail.gmail.com>
Message-ID: <CAMj1kXEfw2a7QAfFUGemV-uiXF1oSeWnBzWouXFbp2u6g7rojQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: xor - avoid division by zero crash
To:     Helge Deller <deller@gmx.de>
Cc:     Douglas Anderson <dianders@chromium.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:PARISC ARCHITECTURE" <linux-parisc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, 24 Jan 2021 at 15:28, Helge Deller <deller@gmx.de> wrote:
>
> On some of my parisc machines, this patch c055e3eae0f1 ("crypto: xor -
> use ktime for template benchmarking") triggers a dividy-by-zero
> exception because "min" becomes zero, which then leads to a kernel
> crash.
>
> It's not clear yet, why I see the issue only on some machines. At least
> on those the measured time to run the xor speed tests becomes zero
> nanoseconds. Maybe it's because gcc-10 optimizes the speed test out, or
> because of some other changes in the time keeping routines.
>
> In either case, the kernel should not crash.
>
> This patch adds a workaround by reporting such cases with a kernel
> warning and continues as if the xor tests would have run in 1 ns.
>
> Signed-off-by: Helge Deller <deller@gmx.de>
> Cc: stable@vger.kernel.org # 5.10+
>
> ---
>
> diff --git a/crypto/xor.c b/crypto/xor.c
> index eacbf4f93990..3639341bac7e 100644
> --- a/crypto/xor.c
> +++ b/crypto/xor.c
> @@ -100,6 +100,8 @@ do_xor_speed(struct xor_block_template *tmpl, void *b1, void *b2)
>                         mb();
>                 }
>                 diff = ktime_sub(ktime_get(), start);
> +               if (WARN_ON(diff == 0))
> +                       diff = 1;
>                 if (diff < min)
>                         min = diff;
>         }

This should already be fixed in mainline - please check whether that
fix works for you.
