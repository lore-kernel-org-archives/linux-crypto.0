Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07EA5C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Sep 2021 11:08:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEFF461168
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Sep 2021 11:08:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbhIULJo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Sep 2021 07:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbhIULJm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Sep 2021 07:09:42 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E11C061574
        for <linux-crypto@vger.kernel.org>; Tue, 21 Sep 2021 04:08:13 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id e15so40992266lfr.10
        for <linux-crypto@vger.kernel.org>; Tue, 21 Sep 2021 04:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5iuoccNuNPTh1vd9i5rBkiS412ZPROosikNDuKSSQY4=;
        b=ZFBe7EomdtKLSSKTtwIrcihqt5w2Ume8E/+yWYjic1y0KOGBK8NIce4kZ7CyFLdAkE
         RS8ib5+o7TsKs6JJ7F1uiKrafdpUmQh3OF5cBFq63x8tFHEUPKERg57DTGQNVu99WKKD
         uDyiSy4U0xEQN2WShXOeZPr6H1MUJGCLAOrR2d5gL/otBRP4S6B2F3SHzMR0hJ6MzjL9
         A/Exni3yVJYC/R8UQEJisrRP0QKVg7anaFYosgtWSF/+JxdI4ToO7NjpJ37VVEhaXGCw
         XUsjCUbheoz2cqCCmH7j9avxReAMfmndnOSEIJOokmMl5qCBe3IlfuYo/V3q6znr/NKL
         ARUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5iuoccNuNPTh1vd9i5rBkiS412ZPROosikNDuKSSQY4=;
        b=qqhA4J5Hq/hchwE0UDbimpfqsoGYH94s3CmcVsq45NtDh2/VvugZ4KbLtmXeuFW58g
         6LPfZxu/A0geIQyamSP9tu9WSmF9EAwVsFjHqX9irYVFNel+GeAvzwwlm1LvVKZSgshw
         eySqizTITkXpdkhgBRNqOKD9tS8iMlqtZX99sYkx3WeMVROG4Jgo2gMCZwfrzd/xHtGb
         hGVq1wxaSdcUzVrx25rvnVdeJIIs2/WXfjaYBVKWZBL19H2P8rMKzHm9/0eEVd0PYpYL
         73xn0y4zZSPu1fi8AuUJQeA84fXyEjehJiziQTdEycx6sj5fF2I62T6Boj+a8hcfJBW2
         qUsQ==
X-Gm-Message-State: AOAM533PH+Oyt1UEP+/EUp+7Q4M+wt4B4lJxXiwjzMA1BIpPwL/tpA5C
        wa0TbMl1gdIAObjDV0qjWsfsDu1OiDwbtmRgMVZfWA6K/eE=
X-Google-Smtp-Source: ABdhPJycAM090c7n1X3s96D/54EnmrmnXusKItrXrZOjBc1BLQL1Az9xujGW3jwA0pjc2qC0PyakwoCBEEXH1NMYBmU=
X-Received: by 2002:a05:6512:10d0:: with SMTP id k16mr22800018lfg.530.1632222491951;
 Tue, 21 Sep 2021 04:08:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210916134154.8764-1-marex@denx.de> <441a7e2e-7ac8-5000-72e0-3793ae7e58d5@canonical.com>
 <08afb147-07c7-9fbb-4a0c-8a79717b06b7@denx.de> <ea7e5aae-be43-057a-2710-fbcb57d40ddc@nxp.com>
 <a8900033-d84d-d741-7d72-b266f973e0d6@canonical.com> <bc94681c-58e5-8c6f-42d3-0e51ddd060c7@nxp.com>
 <77467cbf-afad-d7e1-5042-569d5a276c20@canonical.com> <b1a68e04-b0ce-9610-9992-6eb2f110d36f@canonical.com>
 <04c9705b-9fd8-dde1-33ee-fa58aad96d4a@denx.de> <a690721b-072b-203f-3b30-f2d2b8ba6996@denx.de>
In-Reply-To: <a690721b-072b-203f-3b30-f2d2b8ba6996@denx.de>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Tue, 21 Sep 2021 08:08:00 -0300
Message-ID: <CAOMZO5Bq4wSreYOjB6A86MpZVtudQN7ypJVsL93NsU40S4sN9A@mail.gmail.com>
Subject: Re: [RFC][PATCH] crypto: caam - Add missing MODULE_ALIAS
To:     Claudius Heine <ch@denx.de>
Cc:     Marek Vasut <marex@denx.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Claudius,

On Mon, Sep 20, 2021 at 1:54 PM Claudius Heine <ch@denx.de> wrote:

> Here are the uevent entries without this RFC patch applied:
>
> ```
> # udevadm info -q all -p devices/platform/soc@0/30800000.bus/30900000.crypto
> P: /devices/platform/soc@0/30800000.bus/30900000.crypto
> L: 0
> E: DEVPATH=/devices/platform/soc@0/30800000.bus/30900000.crypto
> E: DRIVER=caam
> E: OF_NAME=crypto
> E: OF_FULLNAME=/soc@0/bus@30800000/crypto@30900000
> E: OF_COMPATIBLE_0=fsl,sec-v4.0
> E: OF_COMPATIBLE_N=1
> E: MODALIAS=of:NcryptoT(null)Cfsl,sec-v4.0
> E: SUBSYSTEM=platform
> E: USEC_INITIALIZED=4468986
> E: ID_PATH=platform-30900000.crypto
> E: ID_PATH_TAG=platform-30900000_crypto

Looking at the addresses above, it looks like you have a device from
the i.MX8M family.

caam module is being correctly autoloaded on imx8mn-evk, for example
on kernel 5.14.6:
https://storage.kernelci.org/stable/linux-5.14.y/v5.14.6/arm64/defconfig/gcc-8/lab-baylibre/baseline-imx8mn-ddr4-evk.html

It works on 5.10.67 too:
https://storage.kernelci.org/stable/linux-5.10.y/v5.10.67/arm64/defconfig/gcc-8/lab-baylibre/baseline-imx8mn-ddr4-evk.html

Which kernel version do you use?

Regards,

Fabio Estevam
