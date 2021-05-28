Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F7A8C2B9F7
	for <linux-crypto@archiver.kernel.org>; Fri, 28 May 2021 13:51:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E027461019
	for <linux-crypto@archiver.kernel.org>; Fri, 28 May 2021 13:51:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235966AbhE1NxR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 May 2021 09:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235676AbhE1NxQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 May 2021 09:53:16 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD72C061574;
        Fri, 28 May 2021 06:51:42 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id r1so2573913pgk.8;
        Fri, 28 May 2021 06:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=St+typHKzUUHCLcGqwo1YuMiqNw+EQW0Fgi4q8xjUjg=;
        b=bucn/0pTL5a01KenTEgCyU+fttb45un1+4uHVJyaTTP3mYo/+uYeKIcn3oQBwdx7aC
         Xaamf8AIFpFWEoZPbNS7cM+9pOPZmgiqOTeX7hfUGX2PdJRDqi8bvHE8eE5/u+x/OaW+
         /6/C1Q8wyDHvf8SccQQCDdm2gNpJlcJ2MC/DyPd336MuH1X3SlLZElATZwdrlsbf11ve
         rwSfO16yl5mMuruIni31qqS7Qxdvpv4Sm+lP93MOxNuCA/i5xMJHGo2fZmpguHHbo6yV
         vyNCQkVBfqMsKCOSGMmDS9re2lTgktZ3xfOikMsm0d7GUsG6yJEHHLtPH3AiYjNiFfze
         vPPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=St+typHKzUUHCLcGqwo1YuMiqNw+EQW0Fgi4q8xjUjg=;
        b=dl8+rJy4frJAMlAF4F3ef6Ro92rM9/c1w5KtSw9Uy+mJCBNAFn9TzimEZ1zD/Bjywk
         qSdHmK5B7tAY/Jm1DvA+YFzO4g1L2PbcTfe9DxDvuHpcLM0Ah7qskTCCh99r6NMfV1ju
         bv925ahU5N8U+RK9KXIZflcXHT7yS5eoBfXS6qD3PZy1kzI5dXY3L0VcIjEkJrigtGxN
         jABMotqqAs9BPFCZP1gLEMXw85SMg2xkQQPOE3OSDQFL5bFojnILem32AUlyVZ/OGjtF
         DMx1V+zlA4F4xUwlKJ+AXFkz2UEXk98coOTLr/uubCupoy+2/UlP5R7NAZUQqMu3Bor8
         nS4Q==
X-Gm-Message-State: AOAM533h0OwWOrpJRFCdQkGMOSAcJZ+QFUONWNOLtTSnCeEAIgoPVkb+
        M+l3grIt0OolYiUkH2zCFt6Z+23w8dKcWMk+I0M=
X-Google-Smtp-Source: ABdhPJx6QLP1NcHNcae4Goasd3V+OI6/Cno3PYqY4cqFiiiwH722T6CrZ1asHkIJeD6N7M4X+1KIUE3+QLJfDbSt85Y=
X-Received: by 2002:a63:b211:: with SMTP id x17mr9001925pge.106.1622209901916;
 Fri, 28 May 2021 06:51:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210527062809.GA1251@raspberrypi> <YK/a8f7MhO2SlrMS@gmail.com>
In-Reply-To: <YK/a8f7MhO2SlrMS@gmail.com>
From:   Austin Kim <austindh.kim@gmail.com>
Date:   Fri, 28 May 2021 22:51:33 +0900
Message-ID: <CADLLry6AfRT6mGXnd66OV57YP4=m2PpOT5tom4QxVrOqGchw4w@mail.gmail.com>
Subject: Re: [PATCH] crypto: arm64/gcm - remove Wunused-const-variable ghash_cpu_feature
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        catalin.marinas@arm.com, will@kernel.org,
        John Johansen <john.johansen@canonical.com>, jmorris@namei.org,
        serge@hallyn.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-security-module@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        =?UTF-8?B?6rmA64+Z7ZiE?= <austin.kim@lge.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

2021=EB=85=84 5=EC=9B=94 28=EC=9D=BC (=EA=B8=88) =EC=98=A4=EC=A0=84 2:46, E=
ric Biggers <ebiggers@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> On Thu, May 27, 2021 at 07:28:09AM +0100, Austin Kim wrote:
> >
> > The variable with MODULE_DEVICE_TABLE() is registered as platform_drive=
r.
>
> What does this mean?  There is no platform_driver involved here at all.
>

What I would like to say is "in many cases, MODULE_DEVICE_TABLE is
registered as struct of platform_driver"
ex) [drivers/char/hw_random/meson-rng.c]
MODULE_DEVICE_TABLE(of, meson_rng_of_match);

static struct platform_driver meson_rng_driver =3D {
.probe =3D meson_rng_probe,
.driver =3D {
.name =3D "meson-rng",
.of_match_table =3D meson_rng_of_match,
},
};

> > But ghash_cpu_feature is not used, so remove ghash_cpu_feature.
>
> It is used when the file is built as a module.
>

Thanks for the information. But it looks like this file is compiled
as built-in with 'CONFIG_CRYPTO_GHASH_ARM64_CE=3Dy' by default.

> > diff --git a/arch/arm64/crypto/ghash-ce-glue.c b/arch/arm64/crypto/ghas=
h-ce-glue.c
> > index 720cd3a58da3..c3f27d0d5329 100644
>>[...]
>
> Probably adding __maybe_unused to ghash_cpu_feature[] is the right thing =
to do.
> That's what module_cpu_feature_match() does.
>
> (Note that module_cpu_feature_match() can't be used here, as it seems the=
 intent
> is for this module to be autoloaded when PMULL is detected, but still be
> loadable without it.  So, that's apparently the reason for using
> MODULE_DEVICE_TABLE() directly.)

Thanks for the valuable idea and feedback.

>
> - Eric
