Return-Path: <SRS0=iGjW=WT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 608CDC3A5A2
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Aug 2019 07:33:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 333C52341F
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Aug 2019 07:33:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YasCd7++"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbfHWHdv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 23 Aug 2019 03:33:51 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55135 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726142AbfHWHdu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Aug 2019 03:33:50 -0400
Received: by mail-wm1-f67.google.com with SMTP id p74so7944785wme.4
        for <linux-crypto@vger.kernel.org>; Fri, 23 Aug 2019 00:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CVd2YxYlV+hAUr5di3QkHjA5oeiQ7cjNTJm0OwYC52k=;
        b=YasCd7++P3ol+vjtVvUoz2WWfb0tg7dsBw+//RXYzc/xYzTXsyACaLTvgZ9tiVnfvO
         m61afa8DWrS92I/CSJO1SPQE2l34zPExCTXg6+vgHf8EuCDcdjWmEaM09g2jgCvKF4JY
         MWrMAQ/kh0LkNoDNH8o3mOcmsYzW4Kl8HcME4G7xZFPGbLlXSaTO4FJSys3v2FCxdQUX
         Aq2iimLeYJbyjghOucN+a8caHTFS0vJvbOE9XIGAMcCPbxHpwTKiAS6MiqqRHXAuoJaR
         rC5Lqvxf3zeRVUPqD3RxgOKs9IhYBcRSwYJCxmyYqQ87+Cax6YuUC3Gtg7w5bmz4UbG1
         xv4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CVd2YxYlV+hAUr5di3QkHjA5oeiQ7cjNTJm0OwYC52k=;
        b=Tvwp7j3tAQoUiQZ+fdg16ir30d7nQ8Zw3gj20cXTw4KeqXAYcVDUffXBDWV+sCl1Vg
         rSAd+g9b1sEVZJxcgWo6yI5g9jAUPiu/0qqLeBSvGq2tCP35KbUDLMAAGYaaZSlZYI7w
         mpv+JVpgZ6EZRlflbbgURt8oMRCsAsbzI80RrkKmgoKErGN8E0+pJauXgAp/IY93AzdI
         uzrlFqzW/dtUlmSweKmCi/3DG6bJw9bY4awGu2QG/ObOvizsk0hvS32ca5HYCfMFSWUq
         7Cni7qwjjyqLAmHPWVV5GrRO1B4F5pU6UCps0DHYXL3+0epNnfZ/vHu39IqqhwmQKbzt
         GkpQ==
X-Gm-Message-State: APjAAAVD6VH1eApd/n1ykwMP7zBMvNL9iZxcdtXWwByTabkWIaegUbLu
        wk1AqkkF/uwajOGESV+YO/x1Y2rT6G6j6jyU4ltElw==
X-Google-Smtp-Source: APXvYqyK0alS6xNLzoRmTVLb/pZP8aeHeIg+E/mcATBx+i86FPwdNbepcSXOchdgUgW2Xo2MoqekL2cosh6NXtpnh9c=
X-Received: by 2002:a1c:4b15:: with SMTP id y21mr3404846wma.53.1566545628536;
 Fri, 23 Aug 2019 00:33:48 -0700 (PDT)
MIME-Version: 1.0
References: <CAKv+Gu8mjM7o+CuP9VrGX+cuix_zRupfozUoDbEWXHVGsW8syw@mail.gmail.com>
 <cdf08891-3b55-e123-1e13-23866af3b289@rock-chips.com>
In-Reply-To: <cdf08891-3b55-e123-1e13-23866af3b289@rock-chips.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 23 Aug 2019 10:33:36 +0300
Message-ID: <CAKv+Gu-MdY_OizZBNrAt15hr8NSyDG5rDSE65OV6TDmbTLJymw@mail.gmail.com>
Subject: Re: cbc mode broken in rk3288 driver
To:     Elon Zhang <zhangzj@rock-chips.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 23 Aug 2019 at 10:10, Elon Zhang <zhangzj@rock-chips.com> wrote:
>
> Hi Ard,
>
> I will try to fix this bug.

Good

> Furthermore, I will submit a patch to  set
> crypto node default disable in rk3288.dtsi.
>

Please don't. The ecb mode works fine, and 'fixing' the DT only helps
if you use the one that ships with the kernel, which is not always the
case.



> On 8/20/2019 23:45, Ard Biesheuvel wrote:
> > Hello all,
> >
> > While playing around with the fuzz tests on kernelci.org (which has a
> > couple of rk3288 based boards for boot testing), I noticed that the
> > rk3288 cbc mode driver is still broken (both AES and DES fail).
> >
> > For instance, one of the runs failed with
> >
> >   alg: skcipher: cbc-aes-rk encryption test failed (wrong result) on
> > test vector \"random: len=6848 klen=32\", cfg=\"random: may_sleep
> > use_digest src_divs=[93.41%@+1655, 2.19%@+3968, 4.40%@+22]\"
> >
> > (but see below for the details of a few runs)
> >
> > However, more importantly, it looks like the driver violates the
> > scatterlist API, by assuming that sg entries are always mapped and
> > that sg_virt() and/or page_address(sg_page()) can always be called on
> > arbitrary scatterlist entries
> >
> > The failures in question all occur with inputs whose size > PAGE_SIZE,
> > so it looks like the PAGE_SIZE limit is interacting poorly with the
> > way the next IV is obtained.
> >
> > Broken CBC is a recipe for disaster, and so this should really be
> > fixed, or the driver disabled.
> >
>
>
