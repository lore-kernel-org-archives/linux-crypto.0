Return-Path: <SRS0=Vvbd=45=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0059C10DCE
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Mar 2020 05:39:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD3D120691
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Mar 2020 05:39:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387811AbgCLFjT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Mar 2020 01:39:19 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:42962 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387758AbgCLFjT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Mar 2020 01:39:19 -0400
Received: by mail-ed1-f66.google.com with SMTP id n18so5857523edw.9;
        Wed, 11 Mar 2020 22:39:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GyEctpegj5STeTjjZ2lmve0OwmDxyLCYf/jINEN4q7Q=;
        b=L4YO4cPY0MZt2OJG1Eml024G+aab7lkvuJCqVkMfIBN3Pa2GQ11CLyDA7PUMC1C/s5
         8tgeqh1Jpb/Xn2VYMZ0rwp+4UDaqVv15VqoDSKzz3RL4pWeXyBiVQcwiejzHawII9QLi
         vCn7MVOpYNtuQkpUBK1pR96QXx5LobjGnykWGkbOCguxNt6d7O5Uho16eF+oGUk+LY/D
         W+ZgTioirRggWbhjQpsryhr8Hp3805dejQjgmPLAyigDy6FE26RWlVftZhW7XPyNUbpW
         xro2hE+Iu8F6w+Vs6lFhzwKh87JHQHl/XrrZk0E/crUtkR5Xg7Qqbi5Kv68MKAlwgn+J
         c4/A==
X-Gm-Message-State: ANhLgQ1FWznOEjlNcDlmf7jyP948YGU0OzMbxmuHApK8ti6N9lCm812e
        lEGStaX1VmFBx5VMqIvHIIHDEmteH54=
X-Google-Smtp-Source: ADFU+vsVx5bfqJUMOm3tua8s6I123OBOrui2RoI8jFzntkGLTVb+v0zkhJk8eRdaj510XksASOuizA==
X-Received: by 2002:a17:906:130d:: with SMTP id w13mr5340194ejb.114.1583991556925;
        Wed, 11 Mar 2020 22:39:16 -0700 (PDT)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com. [209.85.128.50])
        by smtp.gmail.com with ESMTPSA id z19sm2683472eja.53.2020.03.11.22.39.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2020 22:39:16 -0700 (PDT)
Received: by mail-wm1-f50.google.com with SMTP id 6so4677484wmi.5;
        Wed, 11 Mar 2020 22:39:16 -0700 (PDT)
X-Received: by 2002:a1c:41d6:: with SMTP id o205mr2669040wma.122.1583991556192;
 Wed, 11 Mar 2020 22:39:16 -0700 (PDT)
MIME-Version: 1.0
References: <20191120152833.20443-1-clabbe.montjoie@gmail.com>
In-Reply-To: <20191120152833.20443-1-clabbe.montjoie@gmail.com>
From:   Chen-Yu Tsai <wens@csie.org>
Date:   Thu, 12 Mar 2020 13:39:04 +0800
X-Gmail-Original-Message-ID: <CAGb2v65mTzDo3hBWydQtEfVs1hnw7URWA4HCWRfs3if5MeadtQ@mail.gmail.com>
Message-ID: <CAGb2v65mTzDo3hBWydQtEfVs1hnw7URWA4HCWRfs3if5MeadtQ@mail.gmail.com>
Subject: Re: [linux-sunxi] [PATCH v2 0/3] crypto: sun4i-ss: fix SHA1 on A33 SecuritySystem
To:     LABBE Corentin <clabbe.montjoie@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <mripard@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-crypto@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Nov 20, 2019 at 11:28 PM Corentin Labbe
<clabbe.montjoie@gmail.com> wrote:
>
> Thanks to Igor Pecovnik, I have now in my kernelCI lab, a sun8i-a33-olinuxino.
> Strange behavour, crypto selftests was failling but only for SHA1 on
> this A33 SoC.
>
> This is due to the A33 SS having a difference with all other SS, it give SHA1 digest directly in BE.
> This serie handle this difference.
>
> Changes since v1:
> - removed compatible fallback
>
> Corentin Labbe (3):
>   dt-bindings: crypto: add new compatible for A33 SS
>   ARM: dts: sun8i: a33: add the new SS compatible

Merged these two as fixes for v5.6, as the driver changes made it in v5.6-rc1.
Not sure if they will be accepted though.

ChenYu

>   crypto: sun4i-ss: add the A33 variant of SS
>
>  .../crypto/allwinner,sun4i-a10-crypto.yaml    |  2 ++
>  arch/arm/boot/dts/sun8i-a33.dtsi              |  2 +-
>  .../crypto/allwinner/sun4i-ss/sun4i-ss-core.c | 22 ++++++++++++++++++-
>  .../crypto/allwinner/sun4i-ss/sun4i-ss-hash.c |  5 ++++-
>  drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h  |  9 ++++++++
>  5 files changed, 37 insertions(+), 3 deletions(-)
>
> --
> 2.23.0
>
> --
> You received this message because you are subscribed to the Google Groups "linux-sunxi" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to linux-sunxi+unsubscribe@googlegroups.com.
> To view this discussion on the web, visit https://groups.google.com/d/msgid/linux-sunxi/20191120152833.20443-1-clabbe.montjoie%40gmail.com.
