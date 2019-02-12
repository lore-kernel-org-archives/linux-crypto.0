Return-Path: <SRS0=oCQ2=QT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E616EC282CA
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Feb 2019 12:09:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A938920821
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Feb 2019 12:09:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PnIpKnqo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729051AbfBLMJW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Feb 2019 07:09:22 -0500
Received: from mail-vk1-f194.google.com ([209.85.221.194]:35063 "EHLO
        mail-vk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729282AbfBLMJW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Feb 2019 07:09:22 -0500
Received: by mail-vk1-f194.google.com with SMTP id l136so550311vke.2
        for <linux-crypto@vger.kernel.org>; Tue, 12 Feb 2019 04:09:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/8borfXFXUtsgWvVyYCJHuRlDH0LFUbY/ZsGpOyyTUs=;
        b=PnIpKnqobzJ+JsyGUh/5jzBGImaL9pHVMyjD6+mEDhK7vwr1eRbsZH4aav9dL96B71
         H8n/0be9IFr5i96qlRyBiFRORtc4sHw5Dt2bGp0IDKc3kmeS9qvIgSVUJIvGFMZ9DNbK
         JGbw/XhVEIbKuoMJZJfIUti5ViQiuTOxAuq4IVcjAmObR+HLaMb1AWDViJgZCi+CmeCl
         sTlA7ynzYVvcJ8F4djjZMA7HqXc7i+/3Ntb+e1Wn60qL+NmZTGoiuRsWjmVact/hOs2X
         a5xtsEgOq06cLr9meJ/oegu6Q9YzuDdoeYPMofdnu701rlMXxJbtfa50FY7gXPnPp3mu
         Qf0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/8borfXFXUtsgWvVyYCJHuRlDH0LFUbY/ZsGpOyyTUs=;
        b=aiqEUQ/PYiyY4lJYYAMJVN8TFWbBUyEo+hdtusp/WTG22Ebgu15UiEN1Orv/cdFluX
         Q7W/80Udnb4gz4MPS8L/DG8awI6GUatQiCXqHRYEDaFidJ67Rm1kBeaA3cVgd8Om1osk
         jcR/BsEbfP1ExE0PbsPLtIa/JF6SW51PPB4JQgnOh0deGpmVvhG3/KIMNMQSknEIv/Kr
         f9RNfsru89tLxAfhIgIopnQhN7bYODMQdLcPIYh3Ka1roh3HrPY9GMc64q7YF/HtvU8m
         MznQTSDMOlQAkHQ21G/3UJNum8FhREI37oU2VNA3L4UYE/ncKqWGfZ85W+jupcN7YSuZ
         NELQ==
X-Gm-Message-State: AHQUAua/P/8yu5qTVJuF7VAUy2tTOs3halYpdERbuhJLcxls2xsBUxVp
        GnLHMcfYdJ+SF70XOs0mKNx5LVmf7eeKLaAwfLGwJA==
X-Google-Smtp-Source: AHgI3IZObimc66CCNWVY5u/xE7YCCSPwvJZgB9SEOCzJpgyGsLRP6hx+MZG8OjmabVlyqywJuZAyau5/isRcxXW7rbw=
X-Received: by 2002:a1f:8901:: with SMTP id l1mr1392074vkd.66.1549973360623;
 Tue, 12 Feb 2019 04:09:20 -0800 (PST)
MIME-Version: 1.0
References: <1548740978-28495-1-git-send-email-sumit.garg@linaro.org> <CAKv+Gu_RJHb_FwTz+R1bXNQQMsoi0xxcKzn54NF5ib3z2xnH0w@mail.gmail.com>
In-Reply-To: <CAKv+Gu_RJHb_FwTz+R1bXNQQMsoi0xxcKzn54NF5ib3z2xnH0w@mail.gmail.com>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Tue, 12 Feb 2019 17:39:09 +0530
Message-ID: <CAFA6WYMXSZPz2qi9+g=EW3+Lm_vuNAOE_M2zWQ_RkfwLfkwjyQ@mail.gmail.com>
Subject: Re: [PATCH v6 0/4] Introduce TEE bus driver framework
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Jens Wiklander <jens.wiklander@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Matt Mackall <mpm@selenic.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Bhupesh Sharma <bhsharma@redhat.com>, tee-dev@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 12 Feb 2019 at 16:35, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> On Tue, 29 Jan 2019 at 06:50, Sumit Garg <sumit.garg@linaro.org> wrote:
> >
> > This series introduces a generic TEE bus driver concept for TEE based
> > kernel drivers which would like to communicate with TEE based devices/
> > services.
> >
> > Patch #1 adds TEE bus concept where devices/services are identified via
> > Universally Unique Identifier (UUID) and drivers register a table of
> > device UUIDs which they can support. This concept also allows for device
> > enumeration to be specific to corresponding TEE implementation like
> > OP-TEE etc.
> >
> > Patch #2 adds supp_nowait flag for non-blocking requests arising via
> > TEE internal client interface.
> >
> > Patch #3 adds TEE bus device enumeration support for OP-TEE. OP-TEE
> > provides a pseudo TA to enumerate TAs which can act as devices/services
> > for TEE bus.
> >
> > Patch #4 adds OP-TEE based hwrng driver which act as TEE bus driver.
> > On ARM SoC's with TrustZone enabled, peripherals like entropy sources
> > might not be accessible to normal world (linux in this case) and rather
> > accessible to secure world (OP-TEE in this case) only. So this driver
> > aims to provides a generic interface to OP-TEE based random number
> > generator service.
> >
> > Example case is Developerbox based on Socionext's Synquacer SoC [1]
> > which provides 7 thermal sensors accessible from secure world only which
> > could be used as entropy sources (thermal/measurement noise).
> >
> > [1] https://www.96boards.org/product/developerbox/
> >
> > Changes in v6:
> >
> > 1. Incorporate some nitpicks in patch #1 and #3.
> > 2. Bundle all statics in a data structure in patch #4 and use dev_*
> >    instead of pr_*.
> > 3. Add reviewed-by tags for patch #1, #2 and #3.
> >
> > Changes in v5:
> >
> > 1. Add support in module device table for TEE bus devices.
> > 2. Correct license for optee-rng module.
> >
> > Changes in v4:
> >
> > 1. Use typedef instead of single member tee_client_device_id struct.
> > 2. Incorporate TEE bus nitpicks.
> >
> > Changes in v3:
> >
> > 1. Fixed bus error path in Patch #1.
> > 2. Reversed order of Patch #2 and #3.
> > 3. Fixed miscellaneous syntax comments and memory leak.
> > 4. Added comments in Patch #2 for supp_nowait flag.
> >
> > Changes in v2:
> >
> > Based on review comments, the scope of this series has increased as
> > follows:
> >
> > 1. Added TEE bus driver framework.
> > 2. Added OP-TEE based device enumeration.
> > 3. Register optee-rng driver as TEE bus driver.
> > 4. Removed DT dependency for optee-rng device UUID.
> > 5. Added supp_nowait flag.
> >
> > Sumit Garg (4):
> >   tee: add bus driver framework for TEE based devices
> >   tee: add supp_nowait flag in tee_context struct
> >   tee: optee: add TEE bus device enumeration support
> >   hwrng: add OP-TEE based rng driver
> >
>
> For this series
>
> Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>

Thanks. BTW, Jens has created a GIT PULL[1] to incorporate this patch-set.

> although I had to load optee.ko manually in order for the udev
> autoload of optee_rng to trigger.

Did you built OP-TEE module as out-of-tree? OP-TEE by-default is
built-in kernel module as per following configs in default defconfig:

CONFIG_TEE=y
CONFIG_OPTEE=y

> Not sure where the discussion went
> last time, but could we please add "linaro,optee-tz" as a DT modalias
> to the optee.ko module in any case?
>

This change is already part of your RFC patch [2] and I agree to make
OP-TEE as platform driver.

[1] https://lkml.org/lkml/2019/2/4/104
[2] https://lkml.org/lkml/2018/12/27/196

-Sumit

> >  MAINTAINERS                        |   5 +
> >  drivers/char/hw_random/Kconfig     |  15 ++
> >  drivers/char/hw_random/Makefile    |   1 +
> >  drivers/char/hw_random/optee-rng.c | 298 +++++++++++++++++++++++++++++++++++++
> >  drivers/tee/optee/Makefile         |   1 +
> >  drivers/tee/optee/core.c           |   4 +
> >  drivers/tee/optee/device.c         | 155 +++++++++++++++++++
> >  drivers/tee/optee/optee_private.h  |   3 +
> >  drivers/tee/optee/supp.c           |  10 +-
> >  drivers/tee/tee_core.c             |  67 ++++++++-
> >  include/linux/mod_devicetable.h    |   9 ++
> >  include/linux/tee_drv.h            |  38 ++++-
> >  scripts/mod/devicetable-offsets.c  |   3 +
> >  scripts/mod/file2alias.c           |  19 +++
> >  14 files changed, 622 insertions(+), 6 deletions(-)
> >  create mode 100644 drivers/char/hw_random/optee-rng.c
> >  create mode 100644 drivers/tee/optee/device.c
> >
> > --
> > 2.7.4
> >
