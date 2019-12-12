Return-Path: <SRS0=MXL1=2C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F6FAC2D0C9
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 06:23:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F285122527
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 06:23:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j5SWiyDV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbfLLGXZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Dec 2019 01:23:25 -0500
Received: from mail-io1-f41.google.com ([209.85.166.41]:37432 "EHLO
        mail-io1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726833AbfLLGXZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Dec 2019 01:23:25 -0500
Received: by mail-io1-f41.google.com with SMTP id k24so1499930ioc.4;
        Wed, 11 Dec 2019 22:23:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v6NmxBZ8vV201dlBtVW07bjKFin+mwj/uirkjZ9u0AY=;
        b=j5SWiyDVBNqZT1PcE6iXH6kE4RXdm62NrmqGIGv09+lSo4LTU5s7rWwFFmSGdpfUNi
         sukpKFsgP7aFXfbDSo7gsCtzYOPCJbv4q4vWY41dBTOabdpeSYTXBy/5+BMQEItJ15Sy
         y09om1CxA57hk3TMln3XC75K+AYNnnV77NfqUChNDt1uXAAZ8M3dDrpgwaDVin3vILWY
         5RhPY8iXSQ6NpUwvysBTC2YAUy5KsFKZcjVT/rzBCfpILNNiqZf0DlCEupx7Mc3WCoUP
         QkifWL5/1ME7tcmUiqm0xDlRvNYzSVtT/CW4k6muK0LK6CZCnxvYuOVBQdpJXln2+9kU
         bFWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v6NmxBZ8vV201dlBtVW07bjKFin+mwj/uirkjZ9u0AY=;
        b=ZFQS+nT7n0SzJlD/BIj391vJ+EpDB0D/FgsCo5PJKUw9Hx0rc8/kjYdBfDI5jqdPK3
         C5wEN76Qy7+CpI7gkOXhn4whvQpJyWd750+mIZjW28tHiwwD4eqWRWhacTiwCN/b0JDM
         QEiPTab749iF1bAwex0JI7e55syp0Q8mj0gOxTFxHnmnSR1VeLP0gZGEbWcvJV64KZpg
         gP138NNb/HpgYvGYy8sMz7UBiV4O3OUw1Li8oDieIBEEwftxqQBRsjkMUoL3sY9kQoeK
         4arDmMiAIkPKpBy4+2Qrd9TofdfUZcmnqf21uMeJeQnKJI5A/acPSUmGrjIQ1rfpA51p
         eLOw==
X-Gm-Message-State: APjAAAVyRhvHl7RH7yPDVGTy/duLXNxq5kj+V6wx7/efbUvU1y7w12UF
        fd4d1kosZlIAsvSXrl9sbhaWwk3NcPAXOsiiVfU=
X-Google-Smtp-Source: APXvYqwX8wJ8S7PF+1+fB9M3X5vS3O9OPKaGmpvdWd2oR7M6q2o4l+sGHZnsLdxEECGes2O5N5+2Naz6XZS/VC/A84o=
X-Received: by 2002:a6b:4401:: with SMTP id r1mr1649395ioa.243.1576131803998;
 Wed, 11 Dec 2019 22:23:23 -0800 (PST)
MIME-Version: 1.0
References: <20191211084112.971-1-linux.amoon@gmail.com> <a4610efc-844a-2d43-5db1-cf813102e701@baylibre.com>
 <CANAwSgQOTA0mSvFW5otaCzFPHidhY7VFcrXZHjCD-1XkQpcx3w@mail.gmail.com>
 <20191211095043.3kngq7wh77xvadge@gondor.apana.org.au> <CANAwSgR-fT21uBSP747MVkXf2GYqm_6kcne059pX-OegftLSZA@mail.gmail.com>
 <CAKv+Gu8HQ7RY9WSYZrLUR7tNjuybF5sp7xe94VLQpJrDSRg4NA@mail.gmail.com>
 <1229236701.11947072.1576070229564@mail.yahoo.com> <CAFBinCAxq-uW+gsmb-8wqxHGXt2W+4w9iD++2fL=FQ7S-RsAkw@mail.gmail.com>
In-Reply-To: <CAFBinCAxq-uW+gsmb-8wqxHGXt2W+4w9iD++2fL=FQ7S-RsAkw@mail.gmail.com>
From:   Anand Moon <linux.amoon@gmail.com>
Date:   Thu, 12 Dec 2019 11:53:12 +0530
Message-ID: <CANAwSgR0nrVJKGxO3_Tv6g=1dKgnSJN3VJ0WxAdxGhzhWx1jkg@mail.gmail.com>
Subject: Re: [PATCHv1 0/3] Enable crypto module on Amlogic GXBB SoC platform
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     Anand Moon <moon.linux@yahoo.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree <devicetree@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Corentin Labbe <clabbe@baylibre.com>,
        linux-amlogic@lists.infradead.org,
        "David S . Miller" <davem@davemloft.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Martin,

On Thu, 12 Dec 2019 at 05:00, Martin Blumenstingl
<martin.blumenstingl@googlemail.com> wrote:
>
> Hi Anand,
>
> On Wed, Dec 11, 2019 at 2:17 PM Anand Moon <moon.linux@yahoo.com> wrote:
> [...]
> > Sorry once again I send my logs too early.
> > I still having some issue with the Hardware glx cryto module.
> I'm surprised to see that you managed to get the GXL crypto driver to
> load at all on GXBB
> as far as I know GXBB uses an older crypto IP block (BLKMV) than GXL
> (and newer SoCs, called "DMA"): [0]
>
> so my understanding is that a new crypto driver is needed for GXBB
> (BLKMV registers) support.
> the 32-bit SoCs use the same BLKMV IP block as far as I can tell, so
> these would also benefit from this other driver.
> (I don't know if anyone is working on a BLKMV crypto driver - all I
> can tell is that I'm not working on one)
>
>
> Martin
>
>
> [0] https://github.com/khadas/linux/blob/195ea69f96d9bddc1386737e89769ff350762aea/drivers/amlogic/crypto/Kconfig

*You are absolutely correct. current crypto GLX driver might not work for GXBB*
Yes new crypto driver is needed for this board. I will try to study on
this feature.

But both S805 and S905 share the same crypto IP block for.sure see below link.
[0]  https://github.com/khadas/linux/blob/195ea69f96d9bddc1386737e89769ff350762aea/Documentation/devicetree/bindings/crypto/aml-crypto.txt#L1-L61

It's not working see the debug logs.
[alarm@alarm ~]$ sudo modprobe tcrypt sec=1 mode=500
[sudo] password for alarm:
[   39.567302] tcrypt:
[   39.567302] testing speed of async ecb(aes) (ecb-aes-gxl) encryption
[   39.570171] tcrypt: test 0 (128 bit key, 16 byte blocks):
[   39.570229] gxl-crypto c8832000.crypto: meson_cipher ecb(aes) 16 1
IV(0) key=16 flow=1
[   41.598687] gxl-crypto c8832000.crypto: DMA timeout for flow 1
[   41.598900] tcrypt: encryption() failed flags=0
[   41.603383] tcrypt: test 0 (192 bit key, 16 byte blocks):
[   41.603424] gxl-crypto c8832000.crypto: meson_cipher ecb(aes) 16 1
IV(0) key=24 flow=0
[   43.646686] gxl-crypto c8832000.crypto: DMA timeout for flow 0
[   43.646900] tcrypt: encryption() failed flags=0
[   43.651378] tcrypt: test 0 (256 bit key, 16 byte blocks):
[   43.651419] gxl-crypto c8832000.crypto: meson_cipher ecb(aes) 16 1
IV(0) key=32 flow=1
[   45.694691] gxl-crypto c8832000.crypto: DMA timeout for flow 1
[   45.694902] tcrypt: encryption() failed flags=0
[   45.699419] tcrypt:
[   45.699419] testing speed of async ecb(aes) (ecb-aes-gxl) decryption
[   45.707838] tcrypt: test 0 (128 bit key, 16 byte blocks):
[   45.707872] gxl-crypto c8832000.crypto: meson_cipher ecb(aes) 16 0
IV(0) key=16 flow=0
[   47.742677] gxl-crypto c8832000.crypto: DMA timeout for flow 0
[   47.742879] tcrypt: decryption() failed flags=0
[   47.747366] tcrypt: test 0 (192 bit key, 16 byte blocks):
[   47.747402] gxl-crypto c8832000.crypto: meson_cipher ecb(aes) 16 0
IV(0) key=24 flow=1
[   49.790684] gxl-crypto c8832000.crypto: DMA timeout for flow 1
[   49.790898] tcrypt: decryption() failed flags=0
[   49.795380] tcrypt: test 0 (256 bit key, 16 byte blocks):
[   49.795420] gxl-crypto c8832000.crypto: meson_cipher ecb(aes) 16 0
IV(0) key=32 flow=0
[   51.838680] gxl-crypto c8832000.crypto: DMA timeout for flow 0
[   51.838894] tcrypt: decryption() failed flags=0
[   51.852005] tcrypt:
[   51.852005] testing speed of async cbc(aes) (cbc-aes-gxl) encryption
[   51.854903] tcrypt: test 0 (128 bit key, 16 byte blocks):
[   51.854941] gxl-crypto c8832000.crypto: meson_cipher cbc(aes) 16 1
IV(16) key=16 flow=1
[   53.886678] gxl-crypto c8832000.crypto: DMA timeout for flow 1
[   53.886882] tcrypt: encryption() failed flags=0
[   53.891385] tcrypt: test 0 (192 bit key, 16 byte blocks):
[   53.891428] gxl-crypto c8832000.crypto: meson_cipher cbc(aes) 16 1
IV(16) key=24 flow=0
[   55.934686] gxl-crypto c8832000.crypto: DMA timeout for flow 0
[   55.934901] tcrypt: encryption() failed flags=0
[   55.939410] tcrypt: test 0 (256 bit key, 16 byte blocks):
[   55.939447] gxl-crypto c8832000.crypto: meson_cipher cbc(aes) 16 1
IV(16) key=32 flow=1
[   57.982684] gxl-crypto c8832000.crypto: DMA timeout for flow 1
[   57.982899] tcrypt: encryption() failed flags=0
[   57.987429] tcrypt:
[   57.987429] testing speed of async cbc(aes) (cbc-aes-gxl) decryption
[   57.995832] tcrypt: test 0 (128 bit key, 16 byte blocks):
[   57.995864] gxl-crypto c8832000.crypto: meson_cipher cbc(aes) 16 0
IV(16) key=16 flow=0
[   60.030680] gxl-crypto c8832000.crypto: DMA timeout for flow 0
[   60.030880] tcrypt: decryption() failed flags=0
[   60.035369] tcrypt: test 0 (192 bit key, 16 byte blocks):
[   60.035406] gxl-crypto c8832000.crypto: meson_cipher cbc(aes) 16 0
IV(16) key=24 flow=1
[   62.078678] gxl-crypto c8832000.crypto: DMA timeout for flow 1
[   62.078888] tcrypt: decryption() failed flags=0
[   62.083377] tcrypt: test 0 (256 bit key, 16 byte blocks):
[   62.083416] gxl-crypto c8832000.crypto: meson_cipher cbc(aes) 16 0
IV(16) key=32 flow=0
[   64.126684] gxl-crypto c8832000.crypto: DMA timeout for flow 0
[   64.126899] tcrypt: decryption() failed flags=0
[   64.143285] tcrypt: failed to load transform for lrw(aes): -2
[   64.155243] tcrypt: failed to load transform for lrw(aes): -2
[   64.167318] tcrypt:

-Anand
