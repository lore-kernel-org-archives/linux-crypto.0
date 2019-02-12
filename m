Return-Path: <SRS0=oCQ2=QT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5D80C282CE
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Feb 2019 12:55:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF1302084E
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Feb 2019 12:55:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RhSFa4SB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729140AbfBLMzY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Feb 2019 07:55:24 -0500
Received: from mail-vs1-f65.google.com ([209.85.217.65]:44387 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727312AbfBLMzX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Feb 2019 07:55:23 -0500
Received: by mail-vs1-f65.google.com with SMTP id r201so1467862vsc.11
        for <linux-crypto@vger.kernel.org>; Tue, 12 Feb 2019 04:55:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DIKige9dZTqFRJNAYb0OrMSYW+c/EwZN2KD7sQCZWWk=;
        b=RhSFa4SBU71AwfbOX/ckWSqd1dgUUFcc5nU+Y1fM2ZFY09PPQSBu8JvXQ9IB15vtyR
         FEr5zx8sf/niYS3KPCOXKURMizWaGwgRRODuX15K8z+jPV6Mfw2j9XIytne7mrj6wG73
         +OPtMwZk/VzFzVduhu5lyWus85ODvwbFCNm65B6UGfh9GnatRF4Sib16XV1x4mf6rMNc
         yaoDp7NUXNICrry8ivgjQzKd8odQjY0Nr16G8P0cvTSkOls/YlxgJ0KAhBvqGWhyYo8Z
         T/Jtqiz/xadhFpsFP0DCYvB8SiE0fWRoz3x+k1fD5GtXvMPUUZmgmHCVywmWInxk+TnA
         4iIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DIKige9dZTqFRJNAYb0OrMSYW+c/EwZN2KD7sQCZWWk=;
        b=RbALVYCU4FuAxT5BHGqOKSOhHDVRKuakq36EQXQS0rz4+5yJOX1u+h2E1jiQfWClHB
         9LMYElyhKmFvVIR9/MZK1Y/v1eisyTEBaosp7f+0zy7CehudjR7fPtJWGZEzF4rjq9wh
         ptraoIY0f1tpQhXEKne3ePhtSaVhjXzx9NwAKb4l4LTCwOJGtAn0M/sOujSMxeflzznm
         Yty0XVQytwusMACvyTkKd9dRZzZ5I/mr0IraaUChjTfvNIVMxeeIIqdft8mak8iRFHeh
         GItrpkIJ+czllc/bK+KZDeqrpcTfxrTwj1LB+LtTMBrRmYaBtzFuGTbcdTijiYYHc3/B
         Towg==
X-Gm-Message-State: AHQUAuZZMOc5qNvHo/ey3WXQXiZY0+vlMbD8JPqP1I3B1TZYJpHKWod3
        DNqJVfyz5BQXjbwftKWmMbbRfRhHyUCOiiwPYH4GTg==
X-Google-Smtp-Source: AHgI3IbDIthD0Ym9Rg/49mRggo17etucCnnaz65WXx6Em8M/NOOTNU5hTHN03iuXg7bvLt7l7QnzIbv1kTCc+LoiitU=
X-Received: by 2002:a67:8cc2:: with SMTP id o185mr1384485vsd.55.1549976122034;
 Tue, 12 Feb 2019 04:55:22 -0800 (PST)
MIME-Version: 1.0
References: <1548740978-28495-1-git-send-email-sumit.garg@linaro.org>
 <CAKv+Gu_RJHb_FwTz+R1bXNQQMsoi0xxcKzn54NF5ib3z2xnH0w@mail.gmail.com>
 <CAFA6WYMXSZPz2qi9+g=EW3+Lm_vuNAOE_M2zWQ_RkfwLfkwjyQ@mail.gmail.com> <CAKv+Gu-aHENw3xO8E4UrxWONL+xccTt=no0o8xVWfCO0k35p0w@mail.gmail.com>
In-Reply-To: <CAKv+Gu-aHENw3xO8E4UrxWONL+xccTt=no0o8xVWfCO0k35p0w@mail.gmail.com>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Tue, 12 Feb 2019 18:25:11 +0530
Message-ID: <CAFA6WYNbLMOdR6mQSC=ywS0EpfCTSGQ16Qr_xBc13AzW_d-FGA@mail.gmail.com>
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

On Tue, 12 Feb 2019 at 17:41, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> On Tue, 12 Feb 2019 at 13:09, Sumit Garg <sumit.garg@linaro.org> wrote:
> >
> > On Tue, 12 Feb 2019 at 16:35, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> > >
> > > On Tue, 29 Jan 2019 at 06:50, Sumit Garg <sumit.garg@linaro.org> wrote:
> > > >
> > > > This series introduces a generic TEE bus driver concept for TEE based
> > > > kernel drivers which would like to communicate with TEE based devices/
> > > > services.
> > > >
> > > > Patch #1 adds TEE bus concept where devices/services are identified via
> > > > Universally Unique Identifier (UUID) and drivers register a table of
> > > > device UUIDs which they can support. This concept also allows for device
> > > > enumeration to be specific to corresponding TEE implementation like
> > > > OP-TEE etc.
> > > >
> > > > Patch #2 adds supp_nowait flag for non-blocking requests arising via
> > > > TEE internal client interface.
> > > >
> > > > Patch #3 adds TEE bus device enumeration support for OP-TEE. OP-TEE
> > > > provides a pseudo TA to enumerate TAs which can act as devices/services
> > > > for TEE bus.
> > > >
> > > > Patch #4 adds OP-TEE based hwrng driver which act as TEE bus driver.
> > > > On ARM SoC's with TrustZone enabled, peripherals like entropy sources
> > > > might not be accessible to normal world (linux in this case) and rather
> > > > accessible to secure world (OP-TEE in this case) only. So this driver
> > > > aims to provides a generic interface to OP-TEE based random number
> > > > generator service.
> > > >
> > > > Example case is Developerbox based on Socionext's Synquacer SoC [1]
> > > > which provides 7 thermal sensors accessible from secure world only which
> > > > could be used as entropy sources (thermal/measurement noise).
> > > >
> > > > [1] https://www.96boards.org/product/developerbox/
> > > >
> > > > Changes in v6:
> > > >
> > > > 1. Incorporate some nitpicks in patch #1 and #3.
> > > > 2. Bundle all statics in a data structure in patch #4 and use dev_*
> > > >    instead of pr_*.
> > > > 3. Add reviewed-by tags for patch #1, #2 and #3.
> > > >
> > > > Changes in v5:
> > > >
> > > > 1. Add support in module device table for TEE bus devices.
> > > > 2. Correct license for optee-rng module.
> > > >
> > > > Changes in v4:
> > > >
> > > > 1. Use typedef instead of single member tee_client_device_id struct.
> > > > 2. Incorporate TEE bus nitpicks.
> > > >
> > > > Changes in v3:
> > > >
> > > > 1. Fixed bus error path in Patch #1.
> > > > 2. Reversed order of Patch #2 and #3.
> > > > 3. Fixed miscellaneous syntax comments and memory leak.
> > > > 4. Added comments in Patch #2 for supp_nowait flag.
> > > >
> > > > Changes in v2:
> > > >
> > > > Based on review comments, the scope of this series has increased as
> > > > follows:
> > > >
> > > > 1. Added TEE bus driver framework.
> > > > 2. Added OP-TEE based device enumeration.
> > > > 3. Register optee-rng driver as TEE bus driver.
> > > > 4. Removed DT dependency for optee-rng device UUID.
> > > > 5. Added supp_nowait flag.
> > > >
> > > > Sumit Garg (4):
> > > >   tee: add bus driver framework for TEE based devices
> > > >   tee: add supp_nowait flag in tee_context struct
> > > >   tee: optee: add TEE bus device enumeration support
> > > >   hwrng: add OP-TEE based rng driver
> > > >
> > >
> > > For this series
> > >
> > > Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > >
> >
> > Thanks. BTW, Jens has created a GIT PULL[1] to incorporate this patch-set.
> >
> > > although I had to load optee.ko manually in order for the udev
> > > autoload of optee_rng to trigger.
> >
> > Did you built OP-TEE module as out-of-tree? OP-TEE by-default is
> > built-in kernel module as per following configs in default defconfig:
> >
> > CONFIG_TEE=y
> > CONFIG_OPTEE=y
> >
>
> Yes, but the distros will carry it as a module.
>

Hmm, I see. So in this case OP-TEE module needs to be loaded manually
due to missing modalias for udev autoload.

-Sumit

> > > Not sure where the discussion went
> > > last time, but could we please add "linaro,optee-tz" as a DT modalias
> > > to the optee.ko module in any case?
> > >
> >
> > This change is already part of your RFC patch [2] and I agree to make
> > OP-TEE as platform driver.
> >
> > [1] https://lkml.org/lkml/2019/2/4/104
> > [2] https://lkml.org/lkml/2018/12/27/196
> >
>
> Indeed, but iirc there was a question from Jens and I wasn't sure it
> had been answered in the mean time.
