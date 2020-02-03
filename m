Return-Path: <SRS0=nOCY=3X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8418AC33CAC
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Feb 2020 10:11:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56D8E20658
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Feb 2020 10:11:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gNXtJhDN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbgBCKLV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Feb 2020 05:11:21 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:52922 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727308AbgBCKLV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Feb 2020 05:11:21 -0500
Received: by mail-pj1-f66.google.com with SMTP id ep11so6105811pjb.2;
        Mon, 03 Feb 2020 02:11:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4dC5vZjnr8IWvufmlwLWuCfxRjV7yLvgDjVS1/z103Q=;
        b=gNXtJhDNv08S4fJzniL6YYfHrPochu1S78UL6QYeJlnVpLV0vinCkGwH8B/gzyBZO5
         QauncyeOmUrcZWzAcCxAxLmhc+gz/CJG3ii4UPaf55f6uCqNr4pFmaksaV/qOlR3mG2X
         V5kfb6rS7WifHScLmVAKmVI3NqpIEADkgfjFxcaXCT784raeWl5jM2OFkuc9N3csCDxd
         e4ywrFJnDdI8XhyHGMYiYFtUg0ZzdEGFKR5eiX8k2IFDiYwmTI/9rcDJvLCrv7KdfnyB
         rdmCRsu/g7OQNvg7OSJHJfxbeRLnDKswIwnDFBgK8cRlJvSQhCNIk5iI7xrHex0RwEkp
         GEHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4dC5vZjnr8IWvufmlwLWuCfxRjV7yLvgDjVS1/z103Q=;
        b=RB433vD2Av/bjgcjNrA9hohzgzsELN7eGT75BVeeEanEU2qXmPVb9tig0z+l6IvIq5
         KhsbLVn/r9+PMaexCso1bIBs/NtqqzM0BuIFu7+Ty7duAyz5SgxK6oMZpmVtnDv81GQE
         oQmEfIUimYPlmDkcp64Cbq4QF09CsTokxiGqMvOjjGw1iBvRKm851aPlENVAKnFn2AQm
         MWp4Ghr1tHPv2i/zk6T25s5hQ0WqYxeNlFGhyCzCosk+G7pb4UozpGoZ65Mam5Bla+yg
         k263PHx1a5uJXCZtzB10TlMNE6u6yiwnxRTu2kWywFL6Rb+OQS2JmiJzNKIoR7V+j5v1
         /Rcw==
X-Gm-Message-State: APjAAAW83r6a4WGqTaIrSe1e7YHeIdwyAvD2Xu8LyIgEKdw2eW4R5DXC
        01msxfnwcRefKgHjUl4heWsBu+85/BFeydWdlBU=
X-Google-Smtp-Source: APXvYqwvSk3kyzFEkF16zgVr87wi9kTgBo74pIIZQvaZ95Y0VScXP+UxOQwValhzbgbSNpxG+b6SSg+VgL3Dcl7uSbE=
X-Received: by 2002:a17:90b:3109:: with SMTP id gc9mr28494608pjb.30.1580724681048;
 Mon, 03 Feb 2020 02:11:21 -0800 (PST)
MIME-Version: 1.0
References: <1580650021-8578-1-git-send-email-hadar.gat@arm.com> <1580650021-8578-4-git-send-email-hadar.gat@arm.com>
In-Reply-To: <1580650021-8578-4-git-send-email-hadar.gat@arm.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 3 Feb 2020 12:11:13 +0200
Message-ID: <CAHp75Vd4VYJD9kSgMU+iKOC5FOarPtMG4eG3Jbnf7OeebWuC7w@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] MAINTAINERS: add HG as cctrng maintainer
To:     Hadar Gat <hadar.gat@arm.com>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Stefan Wahren <wahrenst@gmx.net>,
        Sumit Garg <sumit.garg@linaro.org>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Weili Qian <qianweili@huawei.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ofir Drang <ofir.drang@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Feb 2, 2020 at 3:29 PM Hadar Gat <hadar.gat@arm.com> wrote:
>
> I work for Arm on maintaining the TrustZone CryptoCell TRNG driver.

> +CCTRNG ARM TRUSTZONE CRYPTOCELL TRUE RANDOM NUMBER GENERATOR (TRNG) DRIVER
> +M:     Hadar Gat <hadar.gat@arm.com>
> +L:     linux-crypto@vger.kernel.org
> +S:     Supported
> +F:     drivers/char/hw_random/cctrng.c
> +F:     drivers/char/hw_random/cctrng.h
> +F:     Documentation/devicetree/bindings/rng/arm-cctrng.txt
> +W:     https://developer.arm.com/products/system-ip/trustzone-cryptocell/cryptocell-700-family
> +

Had you run parse-maintainers.pl afterwards to be sure everything is okay?

-- 
With Best Regards,
Andy Shevchenko
