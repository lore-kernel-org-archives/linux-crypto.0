Return-Path: <SRS0=3L/o=WO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9E5FC3A59F
	for <linux-crypto@archiver.kernel.org>; Sun, 18 Aug 2019 07:27:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FC492173B
	for <linux-crypto@archiver.kernel.org>; Sun, 18 Aug 2019 07:27:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FTlO+BCf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbfHRH1K (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 18 Aug 2019 03:27:10 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:39944 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725209AbfHRH1K (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 18 Aug 2019 03:27:10 -0400
Received: by mail-io1-f68.google.com with SMTP id t6so14509140ios.7;
        Sun, 18 Aug 2019 00:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hyti0k3I4PddbIsJ2d/2Akjf5/MoSL1kv1XKngBQJOo=;
        b=FTlO+BCfHT5CiogCPtviZJdjXIvZgNtQMnFI7Mo/qCwDB8hRTByMsHXaS9ahXiwLr9
         +JqFS+i9QbweMvitF1EAfFLAXB5uYMlXDFW4GBB0nuvEbcVAWpy7/yfhE6a/qEeHCKGg
         NFk8+aAS3S4lSBiXxcQXJXGKWG6LQNiMTwL4OVTEjOfuFcIgMpjmHU4SlQCOGMnXSHGe
         eDVfmWXf+AfEdLJ7k7sg4r9gsWu3mVMouVWx9SOMSuoqmg+kaSG4ygMMz4/mcN9SrYxP
         YQYgr4ge/WoDgnKNGNSt7Mml3wHwU3OLaFElcqpyq1URLXiy43A/k5alDdf2feaxkuIw
         zxwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hyti0k3I4PddbIsJ2d/2Akjf5/MoSL1kv1XKngBQJOo=;
        b=rk1SPYvR1No/NR0ZrlBNNNMts4HCtmSvLLKchnrjtLVTUPqjfPJXHRISvaBl+d2vv5
         aQY4a3iJPEKZrueHhRPKcUXtoKxXICa8fSSMmsmwxDDMV1b6Oof8/0fmJiT4XyTtYcoG
         7N7Qywo2h/G/KlJIxsagV7oHjz6c5qHRAiWu5fO3fqjHsJRT6E3pv7Gced8ZdsDvtS0r
         e4U8LgL0DDk2QkJKloBeKyh0q14tdoYECJDx+S9GpU8gAGHhEuthdkbFaKUpK049T2kR
         SqfrAL/HRsg8LXwW7JSkro8iJM2ij0SyhBlZMHQq0u7R9JM+ohRzCjq7N7uT/fo7YYCv
         Ib4A==
X-Gm-Message-State: APjAAAVOaVLz88nhNT9g0uLuHKSWGwCzeb90/lTZl3mE1xqktOsmSVT4
        ejSHvMF27mIswd20M5PjMg4qGK/K3uc4DrdBQiHp
X-Google-Smtp-Source: APXvYqxE4N+ukRZoeLACGYSa52461Et2fY/bhWQMNyj5zf+NUxDZpmJdVQSUvr/srmpOXiKfiPFnVZnL7do/dItbTCg=
X-Received: by 2002:a5e:c601:: with SMTP id f1mr19110129iok.57.1566113229392;
 Sun, 18 Aug 2019 00:27:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190722150241.345609-1-tmaimon77@gmail.com> <20190722150241.345609-2-tmaimon77@gmail.com>
 <20190812233623.GA24924@bogus>
In-Reply-To: <20190812233623.GA24924@bogus>
From:   Avi Fishman <avifishman70@gmail.com>
Date:   Sun, 18 Aug 2019 10:26:17 +0300
Message-ID: <CAKKbWA607qZ+LODfYi7yUWOQ3DV4Wxi4VUGkW=waSzzRbHp+OA@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] dt-binding: hwrng: add NPCM RNG documentation
To:     Rob Herring <robh@kernel.org>
Cc:     Tomer Maimon <tmaimon77@gmail.com>, mpm@selenic.com,
        herbert@gondor.apana.org.au, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Tali Perry <tali.perry1@gmail.com>,
        Patrick Venture <venture@google.com>,
        Nancy Yuen <yuenn@google.com>,
        Benjamin Fair <benjaminfair@google.com>, sumit.garg@linaro.org,
        jens.wiklander@linaro.org, vkoul@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Joel Stanley <joel@jms.id.au>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        OpenBMC Maillist <openbmc@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Aug 13, 2019 at 2:36 AM Rob Herring <robh@kernel.org> wrote:
>
> On Mon, Jul 22, 2019 at 06:02:40PM +0300, Tomer Maimon wrote:
> > Added device tree binding documentation for Nuvoton BMC
> > NPCM Random Number Generator (RNG).
> >
> > Signed-off-by: Tomer Maimon <tmaimon77@gmail.com>
> > ---
> >  .../bindings/rng/nuvoton,npcm-rng.txt           | 17 +++++++++++++++++
> >  1 file changed, 17 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/rng/nuvoton,npcm-rng.txt
> >
> > diff --git a/Documentation/devicetree/bindings/rng/nuvoton,npcm-rng.txt b/Documentation/devicetree/bindings/rng/nuvoton,npcm-rng.txt
> > new file mode 100644
> > index 000000000000..a697b4425fb3
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/rng/nuvoton,npcm-rng.txt
> > @@ -0,0 +1,17 @@
> > +NPCM SoC Random Number Generator
> > +
> > +Required properties:
> > +- compatible  : "nuvoton,npcm750-rng" for the NPCM7XX BMC.
> > +- reg         : Specifies physical base address and size of the registers.
> > +
> > +Optional property:
> > +- quality : estimated number of bits of true entropy per 1024 bits
> > +                     read from the rng.
> > +                     If this property is not defined, it defaults to 1000.
>
> This would need a vendor prefix, however, I think it should be implied
> by the compatible string. It is fixed per SoC, right?

Tomer is on vacation, so I answer instead:
This value is the same for all our SoC flavor that contains this RNG HW.


-- 
Regards,
Avi
