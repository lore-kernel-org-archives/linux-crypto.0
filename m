Return-Path: <SRS0=oCQ2=QT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A13BC282C4
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Feb 2019 11:05:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66E9421773
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Feb 2019 11:05:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="agX03Kic"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728872AbfBLLF5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Feb 2019 06:05:57 -0500
Received: from mail-it1-f196.google.com ([209.85.166.196]:35969 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727976AbfBLLF5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Feb 2019 06:05:57 -0500
Received: by mail-it1-f196.google.com with SMTP id c9so6531705itj.1
        for <linux-crypto@vger.kernel.org>; Tue, 12 Feb 2019 03:05:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G4yDU+hUL+cuj6DpJEHrWPGvDff9Qw8iKrwsFRXi1zw=;
        b=agX03KiczM8PHh7y8RSNeld9k+XhbKRPGLE4eJ7PupCINkl5PDYYTfn6BWbTyUGZkr
         PCP7wq5nLukNXQyZHyZIhfdeYpt0ppijzYkRInwADPWPm5EJh/mdI5eHq3GZTA7iq7Mh
         YUdr3nECdGfAr9ekpUNCyDNm7Aptj2IOvKgUs3XVS9wu7c/t1dzfCHzkefFoojVkc1rX
         o1+GO2Bo1PZTX8N/i1EigjQltO7/uO12ECJVQC0BCPFIH45wl4593NxG9ekjD2KATw9N
         MQWGl6nO4++JJkpb+vZ845w2L/PzasWVvbESjQvRNqzN5Ktf7WMg765Ax+TTctWFAOPI
         /ngA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G4yDU+hUL+cuj6DpJEHrWPGvDff9Qw8iKrwsFRXi1zw=;
        b=SiRe8GOcLmCsydzUAQsaSLkgTVoutVaL2rCoC4A4N2kvXPKnz/JgKhp8Hp6IIZsCmT
         mkf/8FFodQ3yS1jIAXdDoeWnk1zwJJgg/qdVhh0r8ixRZ3uD6HF/80hwET+wcYUeLm9C
         ehUSEqPIAJDiz+Ugxv9rCVVXlbztnsYE4JHG1KP14zjE/uuftoJepCDkRB2CUK72nUPD
         I3N5BebnVGZt65gyjvfjzEnwCcHpjjcp5FqIp1AlQeodU6s8Gd6QI6zxW0A3LtAxMcMm
         CzXjmBVI50gMjCxaDqzyTGMJiS5gbnZ2ZF/MfUYW8ALph/E70Ve/TkukJf21Y6aJaivB
         MGqQ==
X-Gm-Message-State: AHQUAubgReFGWCR97HYTnJr0YYZJ6htoBaAdbM9gH/juemkL6MSDpF/Y
        UpZmNjCbClpBKNrlXKB+AEm13menW6wrSZ6HLdIvvn1dIv0=
X-Google-Smtp-Source: AHgI3IZurgQhEOK+TfyFADPqMafEVmczSCHE2QJq8H0RjEmIvpKswlxl4aSxnV9Ss/xw8xoMOK5r09KiUp/qQwKypUk=
X-Received: by 2002:a6b:6511:: with SMTP id z17mr1447769iob.173.1549969556183;
 Tue, 12 Feb 2019 03:05:56 -0800 (PST)
MIME-Version: 1.0
References: <1548740978-28495-1-git-send-email-sumit.garg@linaro.org>
In-Reply-To: <1548740978-28495-1-git-send-email-sumit.garg@linaro.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 12 Feb 2019 12:05:44 +0100
Message-ID: <CAKv+Gu_RJHb_FwTz+R1bXNQQMsoi0xxcKzn54NF5ib3z2xnH0w@mail.gmail.com>
Subject: Re: [PATCH v6 0/4] Introduce TEE bus driver framework
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     Jens Wiklander <jens.wiklander@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michal Marek <michal.lkml@markovi.net>, mpm@selenic.com,
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

On Tue, 29 Jan 2019 at 06:50, Sumit Garg <sumit.garg@linaro.org> wrote:
>
> This series introduces a generic TEE bus driver concept for TEE based
> kernel drivers which would like to communicate with TEE based devices/
> services.
>
> Patch #1 adds TEE bus concept where devices/services are identified via
> Universally Unique Identifier (UUID) and drivers register a table of
> device UUIDs which they can support. This concept also allows for device
> enumeration to be specific to corresponding TEE implementation like
> OP-TEE etc.
>
> Patch #2 adds supp_nowait flag for non-blocking requests arising via
> TEE internal client interface.
>
> Patch #3 adds TEE bus device enumeration support for OP-TEE. OP-TEE
> provides a pseudo TA to enumerate TAs which can act as devices/services
> for TEE bus.
>
> Patch #4 adds OP-TEE based hwrng driver which act as TEE bus driver.
> On ARM SoC's with TrustZone enabled, peripherals like entropy sources
> might not be accessible to normal world (linux in this case) and rather
> accessible to secure world (OP-TEE in this case) only. So this driver
> aims to provides a generic interface to OP-TEE based random number
> generator service.
>
> Example case is Developerbox based on Socionext's Synquacer SoC [1]
> which provides 7 thermal sensors accessible from secure world only which
> could be used as entropy sources (thermal/measurement noise).
>
> [1] https://www.96boards.org/product/developerbox/
>
> Changes in v6:
>
> 1. Incorporate some nitpicks in patch #1 and #3.
> 2. Bundle all statics in a data structure in patch #4 and use dev_*
>    instead of pr_*.
> 3. Add reviewed-by tags for patch #1, #2 and #3.
>
> Changes in v5:
>
> 1. Add support in module device table for TEE bus devices.
> 2. Correct license for optee-rng module.
>
> Changes in v4:
>
> 1. Use typedef instead of single member tee_client_device_id struct.
> 2. Incorporate TEE bus nitpicks.
>
> Changes in v3:
>
> 1. Fixed bus error path in Patch #1.
> 2. Reversed order of Patch #2 and #3.
> 3. Fixed miscellaneous syntax comments and memory leak.
> 4. Added comments in Patch #2 for supp_nowait flag.
>
> Changes in v2:
>
> Based on review comments, the scope of this series has increased as
> follows:
>
> 1. Added TEE bus driver framework.
> 2. Added OP-TEE based device enumeration.
> 3. Register optee-rng driver as TEE bus driver.
> 4. Removed DT dependency for optee-rng device UUID.
> 5. Added supp_nowait flag.
>
> Sumit Garg (4):
>   tee: add bus driver framework for TEE based devices
>   tee: add supp_nowait flag in tee_context struct
>   tee: optee: add TEE bus device enumeration support
>   hwrng: add OP-TEE based rng driver
>

For this series

Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

although I had to load optee.ko manually in order for the udev
autoload of optee_rng to trigger. Not sure where the discussion went
last time, but could we please add "linaro,optee-tz" as a DT modalias
to the optee.ko module in any case?

>  MAINTAINERS                        |   5 +
>  drivers/char/hw_random/Kconfig     |  15 ++
>  drivers/char/hw_random/Makefile    |   1 +
>  drivers/char/hw_random/optee-rng.c | 298 +++++++++++++++++++++++++++++++++++++
>  drivers/tee/optee/Makefile         |   1 +
>  drivers/tee/optee/core.c           |   4 +
>  drivers/tee/optee/device.c         | 155 +++++++++++++++++++
>  drivers/tee/optee/optee_private.h  |   3 +
>  drivers/tee/optee/supp.c           |  10 +-
>  drivers/tee/tee_core.c             |  67 ++++++++-
>  include/linux/mod_devicetable.h    |   9 ++
>  include/linux/tee_drv.h            |  38 ++++-
>  scripts/mod/devicetable-offsets.c  |   3 +
>  scripts/mod/file2alias.c           |  19 +++
>  14 files changed, 622 insertions(+), 6 deletions(-)
>  create mode 100644 drivers/char/hw_random/optee-rng.c
>  create mode 100644 drivers/tee/optee/device.c
>
> --
> 2.7.4
>
