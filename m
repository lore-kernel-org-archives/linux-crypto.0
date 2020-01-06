Return-Path: <SRS0=95aS=23=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCB00C3F68F
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Jan 2020 09:38:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F491215A4
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Jan 2020 09:38:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20150623.gappssmtp.com header.i=@bgdev-pl.20150623.gappssmtp.com header.b="D1o966Mx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbgAFJiR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 Jan 2020 04:38:17 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:43919 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgAFJiR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Jan 2020 04:38:17 -0500
Received: by mail-io1-f66.google.com with SMTP id n21so46387237ioo.10
        for <linux-crypto@vger.kernel.org>; Mon, 06 Jan 2020 01:38:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=k2+obkL6rebOtdriVSVT+QmM5oPrNk9dBLg/jYY+wfo=;
        b=D1o966MxyHxQctJ7rWTwJMt3NjGv7Dvvox7er9lgSNNvWFHHGJwcWONCfWtZi6gN+G
         sRs4vR0DB2EcpFyAOnNBrO6Ga7QtFeR72FBTF9427T+497Qzcfm+8pl2pbBszlc9JvVQ
         5lkYYgLVWA+odDpMbgsGqK5RaUIs7BmqtrPT75mjcq5Cps8QL2hw57ZZN4r24h+9vHFL
         a+0FUA2QZ2/EndxTc3PDJardW9IZ7lhDOn+2+dkqYDe/IvqXD733Uy0eoMyHFCObNslD
         T6Kj74zvZbASdqOn7QT7jqwZ2Hbx2etpk6CtUIx5rIfvpbv2lv5teqA/qj36BoqxsUw4
         LIzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=k2+obkL6rebOtdriVSVT+QmM5oPrNk9dBLg/jYY+wfo=;
        b=H2yKSuRDbaGkcN0/osCG7ax01qXY6mfyq+8k0tstA16vC/L8FrkQ7RCeyrLUItxBTY
         18JefOclyXY6dSGBC18nWz7vzD+hankoD/O9Nx6BUsU1eydkMDZa4TDdZ5biTqXXHQNf
         kBmCOXywy/gpwgJUy7HduZnS2a5Or2HKGL2xH5avGnZeU4swLnzymw39Sb2Vuizf8WX6
         jqKGUZChd3oJ7shmqPzC7uKpOEZrFsYVUKT3yS3TUnkMdL0ZjqUAhuifRv5HaDYqpQwx
         wJoHNnLc6bhFoC1surmLDmbckzrJtLyYbmgjiCb2+HJ4kiEEpU86XiQx3IBWvbO0HL3D
         HheA==
X-Gm-Message-State: APjAAAUymKDRGyGkljfC2Zuql0vtQm2VIrhAdJ5Rc33Jk9MUouoYewpg
        6h82AGf16dH2Pwk37MmdqYDP17VViVKeH6pXBbwlFg==
X-Google-Smtp-Source: APXvYqzE32XYz3+At4KghXnJsLBu7odv7vp28Pnk5lZat2Vp4MBrZzHnDvUV6gAXMdReOEfzJCGFp0QdxKmkLf29OSM=
X-Received: by 2002:a5d:9dd9:: with SMTP id 25mr58696986ioo.287.1578303496369;
 Mon, 06 Jan 2020 01:38:16 -0800 (PST)
MIME-Version: 1.0
References: <20200106045833.1725-1-masahiroy@kernel.org>
In-Reply-To: <20200106045833.1725-1-masahiroy@kernel.org>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Mon, 6 Jan 2020 10:38:05 +0100
Message-ID: <CAMRc=MeTC8X9wDV7bowEvjPxjUNH8hXSJC79iy9s9W9Yn6Fh8A@mail.gmail.com>
Subject: Re: [PATCH] treewide: remove redundent IS_ERR() before error code check
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        devicetree <devicetree@vger.kernel.org>,
        alsa-devel@alsa-project.org, linux-acpi@vger.kernel.org,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Julia Lawall <julia.lawall@lip6.fr>,
        "open list:MEMORY TECHNOLOGY..." <linux-mtd@lists.infradead.org>,
        linux-crypto@vger.kernel.org,
        linux-clk <linux-clk@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-i2c <linux-i2c@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

pon., 6 sty 2020 o 06:00 Masahiro Yamada <masahiroy@kernel.org> napisa=C5=
=82(a):
>
> 'PTR_ERR(p) =3D=3D -E*' is a stronger condition than IS_ERR(p).
> Hence, IS_ERR(p) is unneeded.
>
> The semantic patch that generates this commit is as follows:
>
> // <smpl>
> @@
> expression ptr;
> constant error_code;
> @@
> -IS_ERR(ptr) && (PTR_ERR(ptr) =3D=3D - error_code)
> +PTR_ERR(ptr) =3D=3D - error_code
> // </smpl>
>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>

For GPIO:

Acked-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
