Return-Path: <SRS0=IzQh=TY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF370C282E1
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 21:52:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1F7F21773
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 21:52:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rKXnxENH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404295AbfEXVwS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 May 2019 17:52:18 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:43179 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404252AbfEXVwS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 May 2019 17:52:18 -0400
Received: by mail-lj1-f195.google.com with SMTP id z5so9894777lji.10
        for <linux-crypto@vger.kernel.org>; Fri, 24 May 2019 14:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AuXh008DwPVUoUfJh8xoJEqHVOdqY/Qbo/taZOoVBiw=;
        b=rKXnxENHnVqhPbDV4VvBkDnK3OT4VPP4NjvXLzQbUmbK2h/PlqFdN3lj03wlDO/7vt
         zchANxp1fnJ8nyi3btwcHmckbBrOLWSSWSb7NIOPlSl+XwT02ri6eHwQgaQbi0JE9VPI
         XXhAQ0uVCZ6q4wx7jGLFKQT0OcTr/Er6wOpYOF96naYlmzv6nkLj39EaaC5jPTIFXEhp
         zfxf57LvH3RnjBOTnlGd3i8NloVE7EvbIOw0jBO0CjH/cBiCGc5IbcClFs/+VpkNO5kz
         PYPpGA76IcfeUy49pSbN+0qsKT/0fKyqCwnAbj/sF8oKA/fs+FHViKKZFBVniEYApVnv
         UY5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AuXh008DwPVUoUfJh8xoJEqHVOdqY/Qbo/taZOoVBiw=;
        b=qPBW3/I2yOyEDIgXGcbwR7Jtppq2UiNrEZo2KD3tPOOP4okHFFOFvboVrpQCQtbw9u
         ey5bmt2663hzLwbPbhkuuSDSWsvwkaWyEzhHjGAaCwUfctJaQNwY80wPkM4/lfpxEekX
         qky5316laIkhlrfe0BwlixKRrz0ybA53m6coaQxY/c3vRYyQwSo8XpWrWw19JWbaoOJJ
         Z67rCUNGcAGlIH6Xlb30+Bbgx8B68swGYja7r+UAkm1YKLYBveh2ZEYSLZ2L2jV7uCxM
         WJeb/9Cz/jD7v66J69hABqfn4dpWF1/XKAFtYyBSwzfeyntgkWrZ2RIK5b3euaqJH6Tx
         XmCw==
X-Gm-Message-State: APjAAAWHtFhddfg+SCn996FuMD6roCjrSjLi4/cIwV+oWj2vou5FmOIN
        JWvB8o6wRbSljXl2AN+zTqY/f6Sj7mwMBNHjgOWu2w==
X-Google-Smtp-Source: APXvYqxYfaDDuzHIgfNZpZM+zFfqPwrxJQFe0dNnmRKrUfh2JbZ2ONVVjhKmktDtJe44o6jhdj/R5FccoT2LYVtjOCw=
X-Received: by 2002:a2e:4c7:: with SMTP id a68mr35484221ljf.165.1558734736500;
 Fri, 24 May 2019 14:52:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190524162651.28189-1-ard.biesheuvel@linaro.org> <20190524162651.28189-3-ard.biesheuvel@linaro.org>
In-Reply-To: <20190524162651.28189-3-ard.biesheuvel@linaro.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Fri, 24 May 2019 23:52:04 +0200
Message-ID: <CACRpkdZsd+f6ajGKu71y13D7_6aEM_x6d4bJ0dLtGv7GmUYujg@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] crypto: atmel-ecc: add support for ACPI probing on
 non-AT91 platforms
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 24, 2019 at 6:27 PM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:

> The Atmel/Microchip EC508A is a I2C device that could be wired into
> any platform, and is being used on the Linaro/96boards Secure96
> mezzanine adapter. This means it could be found on any platform, even
> on ones that use ACPI enumeration (via PRP0001 devices). So update the
> code to enable this use case.
>
> This involves tweaking the bus rate discovery code to take ACPI probing
> into account, which records the maximum bus rate as a property of the
> slave device. For the atmel-ecc code, this means that the effective bus
> rate should never exceed the maximum rate, unless we are dealing with
> buggy firmware. Nonetheless, let's just use the existing plumbing to
> discover the bus rate and keep the existing logic intact.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Looks good to me.
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
