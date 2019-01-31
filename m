Return-Path: <SRS0=09LE=QH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6271FC169C4
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Jan 2019 08:41:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30605218AF
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Jan 2019 08:41:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="jRlW5tRD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbfAaIlu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Jan 2019 03:41:50 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:33305 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbfAaIlu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Jan 2019 03:41:50 -0500
Received: by mail-lj1-f194.google.com with SMTP id v1-v6so1977404ljd.0
        for <linux-crypto@vger.kernel.org>; Thu, 31 Jan 2019 00:41:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AtIzf0HGZRPgpt0+xARJvlHbAcFWw8amQ5FeEuPrgzo=;
        b=jRlW5tRDQ4ZJJxS99hOwUiq9v4Mm4NAGKIURjNz9Q+Wjn1UXuCWp7xBlyBM8RZDAZQ
         VzT/ZwIaTkbsk/OD08+kbHpAy4/uUt6yj9MQIs7hZ0saWh7Uyd74YXN1kVQ3kEHDng+6
         DEGpY2R3qg311EipfSK64PSVuW1nHDTTsvJNA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AtIzf0HGZRPgpt0+xARJvlHbAcFWw8amQ5FeEuPrgzo=;
        b=TcPht2df3L3jOkU43B7bt6Qa5YEoagEAv7enqnFNYI5patHONMObKW22s+U0poHzyK
         Xb/lD0eRw3YrOD+9N8eSQ4s548X5J1ZO4mennM/Vgq0fOkAiNN8NMoAj5tYj9NBS/9Jl
         RiPlwca7eDXyMgaTTc1qqSoQzMR31MjSQYmUp/nFVT+72G6uWQDMCr7PTGpXUI2112Ve
         IhHd77msFHpiJGUMUQUVCOxtOM5ajxKaLAfqB+8gE/TI8XgMvAg/G405F1xNSpNalZUL
         4bDAb3l4DLLOosPzSsTc7qy+hsEwD0RKutTjolkhrQwRGr9eVTRXKbMfXOZVpkjIcrC3
         TYFQ==
X-Gm-Message-State: AJcUuke5B5l/+hnPUBruzDhJ34/H2wvL6oG6WkdwwrCHWD0jr4qjpaxO
        sMo/qwUtvSlxGjxnd/T5cndTIw==
X-Google-Smtp-Source: ALg8bN7TI6FwVy0odr91FQzGF5FssBBA+RpJVAU+Z3Z7SmuD0Z71r0vxoMxFBDuKjcA0WJjtn7mogw==
X-Received: by 2002:a2e:9059:: with SMTP id n25-v6mr26312168ljg.155.1548924106995;
        Thu, 31 Jan 2019 00:41:46 -0800 (PST)
Received: from jax.urgonet (h-84-105.A175.priv.bahnhof.se. [79.136.84.105])
        by smtp.gmail.com with ESMTPSA id o88sm721489lfk.38.2019.01.31.00.41.45
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 31 Jan 2019 00:41:46 -0800 (PST)
Date:   Thu, 31 Jan 2019 09:41:43 +0100
From:   Jens Wiklander <jens.wiklander@linaro.org>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Olof Johansson <olof@lixom.net>, arnd@arndb.de,
        Sumit Garg <sumit.garg@linaro.org>,
        herbert@gondor.apana.org.au, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        yamada.masahiro@socionext.com, michal.lkml@markovi.net,
        mpm@selenic.com, robh+dt@kernel.org, mark.rutland@arm.com,
        daniel.thompson@linaro.org, ard.biesheuvel@linaro.org,
        bhsharma@redhat.com, tee-dev@lists.linaro.org
Subject: Re: [PATCH v6 0/4] Introduce TEE bus driver framework
Message-ID: <20190131084142.GA21196@jax.urgonet>
References: <1548740978-28495-1-git-send-email-sumit.garg@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1548740978-28495-1-git-send-email-sumit.garg@linaro.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Matt and Herbert,

On Tue, Jan 29, 2019 at 11:19:34AM +0530, Sumit Garg wrote:
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

I think this patch series is good now. It has received comments which
has been addressed and have also gathered a few R-B tags.

All patches but "hwrng: add OP-TEE based rng driver" covers what I
normally send pull requests to arm-soc for.

Matt, Herbert, are you fine with the patch
"hwrng: add OP-TEE based rng driver"?
If so, is it also OK if I take it via my tree which I then will include
in a pull request to arm-soc? An Acked-By tag would be nice to have.

Thanks,
Jens
