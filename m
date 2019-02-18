Return-Path: <SRS0=tWXW=QZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A501C43381
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Feb 2019 08:48:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F3A021479
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Feb 2019 08:48:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728690AbfBRIsT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Feb 2019 03:48:19 -0500
Received: from mail-vs1-f68.google.com ([209.85.217.68]:37120 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727423AbfBRIsT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Feb 2019 03:48:19 -0500
Received: by mail-vs1-f68.google.com with SMTP id s16so9202586vsk.4;
        Mon, 18 Feb 2019 00:48:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EHl4v02YyC8ucW3zOPfnDXE8fKCHewZdmpg50OilTkA=;
        b=MMRdOsgFRz6dMjv4o0CjjgjVQeLwTwQzCTfb+Rwfh9KBEGVgcHZbypIiiHc//swqzo
         a35zCcxprQILgxV3JxadLzZgjVmrN7S1Zrrjd84HTAtRrPNcIHaun1KoECK2oAZ1wulg
         URbwfKldOtJuCXqdUXr+snnrHfX99Gknk2gUH01XNeRXTevDOkA1Fn7aITA+vCm47bXN
         Dk55vsuldzk3nWJqYJ3sHG9FxI44NyDXDiVE/E/Op5P57So4xormTCKSCm6jskn6QdYs
         S9szEawwWgG/8qrTcRJA8TxioXaVh4GwFWenWcuCJTxB0RR1358XJmQ1X6rDgrnsr9w4
         i+eA==
X-Gm-Message-State: AHQUAuaAz0jnpIj+g/F7/YMSpE3clC7JxF7nj/9fnNWahbX9Sfwe/+Z+
        O9eXP3vv/pO+A88g5fLw7Vtcwyfg9nqvIHKPHZU=
X-Google-Smtp-Source: AHgI3Ibuz7PVLjPrRSCP05dVX++N0nnICcjU/7Xtw7YF229ArPLKOui0LaCbTMNZ5kxxpM/v55mtADJ8ucZU1pvO6+E=
X-Received: by 2002:a67:e3d3:: with SMTP id k19mr10222097vsm.96.1550479698653;
 Mon, 18 Feb 2019 00:48:18 -0800 (PST)
MIME-Version: 1.0
References: <20190211142758.16718-1-gilad@benyossef.com>
In-Reply-To: <20190211142758.16718-1-gilad@benyossef.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 18 Feb 2019 09:48:07 +0100
Message-ID: <CAMuHMdUXAY7wBjCYH94V2NV7+MXdOKufnWpi=B1vAWkNFysxpg@mail.gmail.com>
Subject: Re: [PATCH] crypto: ccree: add missing inline qualifier
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drag <ofir.drang@arm.com>, stable <stable@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Feb 11, 2019 at 3:29 PM Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> Commit 1358c13a48c4 ("crypto: ccree - fix resume race condition on init")
> was missing a "inline" qualifier for stub function used when CONFIG_PM
> is not set causing a build warning.
>
> Fixes: 1358c13a48c4 ("crypto: ccree - fix resume race condition on init")
> Cc: stable@kernel.org # v4.20

# v5.0

However, I believe the version comment is not necessary, as the same
version is indicated by the Fixes tag.

> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
