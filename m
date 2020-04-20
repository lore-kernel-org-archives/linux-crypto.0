Return-Path: <SRS0=BVES=6E=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AE66C3815B
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Apr 2020 09:34:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7505620CC7
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Apr 2020 09:34:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbgDTJes (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Apr 2020 05:34:48 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:37697 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbgDTJes (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Apr 2020 05:34:48 -0400
Received: by mail-oi1-f194.google.com with SMTP id r25so8200939oij.4;
        Mon, 20 Apr 2020 02:34:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eIHG2hswjdFUq6BQvkp32Ue0/YbEmfyh/aX7pW2WSwE=;
        b=df/f0wXMqMQ/asmO882ff5sDTPHwvyCE6F6aQh7Q3jeamWaJD/qeugpyDWa3ZIy+Mp
         F1o6E3Uc85WU/6gRHwPgfMaCrYj6ytySZezpeH55x5KpUFNGzJkxb1UHrFmOJP/uWejf
         2Vk0Zuq1sQguvo9ach9fTGdpkc6fUFGFGNmeuP+ecjazlUjy2twgH0IzepDTnQi0nS2I
         wWJ2fQybV7BZTywNUk07Dp31nk2FFYHxtKAxKA/ptGeuKvvP5AmAVnO0Rm2xLVk7dfTF
         U4xpdlBeIk+0rj4OKnJeCtji6CVkaHI0apFm4XL7jBazu9CQJBBhJQIYYhFsWKj7m9EH
         2AVQ==
X-Gm-Message-State: AGi0PuaEboCNB34bgFSOKnGUSiMExJf9ShbiF+jO1ZLwzlAxdoJZh0tX
        mSmS9pWZx7KCG+k8esj7TUJph7u02QI8TZ2CaZo=
X-Google-Smtp-Source: APiQypJhtSqdbmt4Os/Es5ncR9fFGF++rUVXcvOktw5ZpykEPOD7HqSq/stpq9bTaXkwjfzwVUVmxZsjM6O+gYBO63g=
X-Received: by 2002:aca:d50f:: with SMTP id m15mr3538156oig.54.1587375285693;
 Mon, 20 Apr 2020 02:34:45 -0700 (PDT)
MIME-Version: 1.0
References: <1585289423-18440-1-git-send-email-hadar.gat@arm.com>
In-Reply-To: <1585289423-18440-1-git-send-email-hadar.gat@arm.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 20 Apr 2020 11:34:34 +0200
Message-ID: <CAMuHMdUUJATs+G-hvty=fgyrhyx1EafpFHoWfcm=V_tVLn3q2A@mail.gmail.com>
Subject: Re: [PATCH v7 0/3] hw_random: introduce Arm CryptoCell TRNG driver
To:     Hadar Gat <hadar.gat@arm.com>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ofir Drang <ofir.drang@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Hadar,

On Fri, Mar 27, 2020 at 7:11 AM Hadar Gat <hadar.gat@arm.com> wrote:
> The Arm CryptoCell is a hardware security engine.
> This patch introduces driver for its TRNG (True Random Number Generator)
> engine.

Thanks for your series!

I am wondering what is the relation between this and
Documentation/devicetree/bindings/crypto/arm-cryptocell.txt?

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
