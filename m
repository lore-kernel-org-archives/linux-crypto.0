Return-Path: <SRS0=AJZI=ZP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA5A7C432C3
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Nov 2019 15:29:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A27820706
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Nov 2019 15:29:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kiOJVG2p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfKWP3z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 23 Nov 2019 10:29:55 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:46149 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbfKWP3z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 23 Nov 2019 10:29:55 -0500
Received: by mail-il1-f195.google.com with SMTP id q1so10162927ile.13;
        Sat, 23 Nov 2019 07:29:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8eTkYwKb9m359asPh6Ysgm+Da2MJlqq+l4Sb9nSRTSU=;
        b=kiOJVG2pmpQJ2VN4v4Zl2HquBydhRrN+GM6xHJk0pF0XDNlCcTJDdbFRgcSX3ZAtdX
         0Pk/xBzq0xeLOdOKEL6R16XLXVMxQBImQNJVVQg9f97RIbvPIvKGMY83GyR/10HHsKo9
         nx3P6z9KlUHzpY03/PQawL6RFfHf1XptIRJgBW4vsMQb91eekXOQ4UL1rhzPfKnJcJPW
         H0ljf7CGLauGHG+QyOS6YkH0wjASY8g7AWlwtU+WupkY/WTdH9a30r7fwAvH01sFegkd
         JY9jcgrKXipSRbBkOIhywXMJKu1qgPCA2eY4iuyoDnjTUyJE4lBrh+wMfxC2uHn35uQB
         kslg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8eTkYwKb9m359asPh6Ysgm+Da2MJlqq+l4Sb9nSRTSU=;
        b=CucwiFNS8pLqu8O4CbhevQGoJ/HsE2Mgmod8v8R1GTCPB2YmP79r7FG6oK86UgC+lj
         fSwLOXJUStrsm7IFvqdu39LxcgTR2tsnqXvwN3do9HJeQ5XkyN40YwmPDJAEnB12Xuof
         ZMikHOOibmYbpsR3jNvvzTj8RmLJwoUC15sMJiSz5sLbVLkKrfmfVkuZsMu0hjuP+gqc
         Yk6qGQ3wvHX17YLYb+1IMCNzgxY6TVsFnGNlzXTa5zyBr8ZdI70N66pbjln31fdD7GwU
         NjRdbZ6c3FNLvBKXPYD2UHllj2V14vVMI9xfBQc971edfw/QUfwaIscqt1lzQi3IljQQ
         jypw==
X-Gm-Message-State: APjAAAVkjO00oHQ8XiCiqFH2lKAhSMX7gisQXBuQ/1L2wxt3cB5C15ZF
        +cWGOenTIIF99wl8Rz8h3egbt1EYJtuEHpmv8Ms=
X-Google-Smtp-Source: APXvYqyeE3Pl5UTnhFhCeFBqZT96zgXTOzayS445/qsngeQBnUZzHl5C8tRKJFKD3/2/hNWfkkHcBie3qNPPdLljPpU=
X-Received: by 2002:a92:d7cf:: with SMTP id g15mr23418989ilq.171.1574522994762;
 Sat, 23 Nov 2019 07:29:54 -0800 (PST)
MIME-Version: 1.0
References: <20191121155554.1227-1-andrew.smirnov@gmail.com>
In-Reply-To: <20191121155554.1227-1-andrew.smirnov@gmail.com>
From:   Chris Healy <cphealy@gmail.com>
Date:   Sat, 23 Nov 2019 07:29:43 -0800
Message-ID: <CAFXsbZpjuWnCdzaO0qSa2gw6R-KNi3aDTwqqPHmYrRNqUj_zDw@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] enable CAAM's HWRNG as default
To:     Andrey Smirnov <andrew.smirnov@gmail.com>
Cc:     linux-crypto@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-imx@nxp.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Tested-by: Chris Healy <cphealy@gmail.com>

On Thu, Nov 21, 2019 at 7:56 AM Andrey Smirnov <andrew.smirnov@gmail.com> wrote:
>
> Everyone:
>
> This series is a continuation of original [discussion]. I don't know
> if what's in the series is enough to use CAAMs HWRNG system wide, but
> I am hoping that with enough iterations and feedback it will be.
>
> Changes since [v1]:
>
>     - Original hw_random replaced with the one using output of TRNG directly
>
>     - SEC4 DRNG IP block exposed via crypto API
>
>     - Small fix regarding use of GFP_DMA added to the series
>
> Chagnes since [v2]:
>
>     - msleep in polling loop to avoid wasting CPU cycles
>
>     - caam_trng_read() bails out early if 'wait' is set to 'false'
>
>     - fixed typo in ZII's name
>
> Changes since [v3]:
>
>     - DRNG's .cra_name is now "stdrng"
>
>     - collected Reviewd-by tag from Lucas
>
>     - typo fixes in commit messages of the series
>
> Feedback is welcome!
>
> Thanks,
> Andrey Smirnov
>
> [discussion] https://patchwork.kernel.org/patch/9850669/
> [v1] https://lore.kernel.org/lkml/20191029162916.26579-1-andrew.smirnov@gmail.com
> [v2] https://lore.kernel.org/lkml/20191118153843.28136-1-andrew.smirnov@gmail.com
> [v3] https://lore.kernel.org/lkml/20191120165341.32669-1-andrew.smirnov@gmail.com
>
> Andrey Smirnov (6):
>   crypto: caam - RNG4 TRNG errata
>   crypto: caam - enable prediction resistance in HRWNG
>   crypto: caam - allocate RNG instantiation descriptor with GFP_DMA
>   crypto: caam - move RNG presence check into a shared function
>   crypto: caam - replace DRNG with TRNG for use with hw_random
>   crypto: caam - expose SEC4 DRNG via crypto RNG API
>
>  drivers/crypto/caam/Kconfig   |  15 +-
>  drivers/crypto/caam/Makefile  |   3 +-
>  drivers/crypto/caam/caamrng.c | 358 ----------------------------------
>  drivers/crypto/caam/ctrl.c    |  29 ++-
>  drivers/crypto/caam/desc.h    |   2 +
>  drivers/crypto/caam/drng.c    | 175 +++++++++++++++++
>  drivers/crypto/caam/intern.h  |  32 ++-
>  drivers/crypto/caam/jr.c      |   3 +-
>  drivers/crypto/caam/regs.h    |  14 +-
>  drivers/crypto/caam/trng.c    |  89 +++++++++
>  10 files changed, 338 insertions(+), 382 deletions(-)
>  delete mode 100644 drivers/crypto/caam/caamrng.c
>  create mode 100644 drivers/crypto/caam/drng.c
>  create mode 100644 drivers/crypto/caam/trng.c
>
> --
> 2.21.0
>
