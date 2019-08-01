Return-Path: <SRS0=q4N3=V5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69E92C32754
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Aug 2019 20:17:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E7F92084C
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Aug 2019 20:17:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="a/tboTaT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbfHAURT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Aug 2019 16:17:19 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37684 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388952AbfHAURT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Aug 2019 16:17:19 -0400
Received: by mail-wm1-f65.google.com with SMTP id f17so64277404wme.2
        for <linux-crypto@vger.kernel.org>; Thu, 01 Aug 2019 13:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+2f47S9TyynfRuvT0EIxN+x9IBMjQklZO2mS15S/FPM=;
        b=a/tboTaTAA7U22KkiWKgcpqovbFR9fW6T4w9RnlkV/wOd6gST44QEqb4yVG5gUCf8T
         VKsiuLwjP12EZaBqZJgQVqIOxyqSUdGaesaxmdc0GJ/DwZyS9YnxwbvNcyKjFCLKvC+7
         5qwm5D9v32NxrJ7KD9ZiqZ94kwN98X2/ARO3KD9f/Ff8B6r0fZG/9CZBqCVfn78/bVRg
         kr0v59xk1JjQj+ubScHK5ATwO/AScFIAUSyd+qURaHSc4GMwa7hHqVPzAj9Q80XQ4oB0
         uJij8u+NeJk4Nqx268L6gEG+OCtAV4eNU/kuMqn4F1zw2YSkdxfOXdu+4VTEoXqTB9I3
         Syuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+2f47S9TyynfRuvT0EIxN+x9IBMjQklZO2mS15S/FPM=;
        b=PzAIXrDcOnJWbwlxGZ4mcmm8xYbvxQmJM1Vwy1th6/TpQLoiUu4xBldClw9ygUWRUK
         Id+wnZvm5tK6L8Bbo9OwamFiw/eLNDapeYxis1vhweuRoRmSDoyPfuHYY3I9pL4lryDh
         wnEx33f9RdvPmrCvp/JqpNTCz/Av1g0LYhoXamb342DfWl+VKFJFMqTioaPJh31Dr1wU
         SGZZnvLoORKhdMizoOkP4TbTdAxpAtsbV2VZOJ4FEZd+kVhfCJMjLdtOMFjAhzWt0W5o
         xPS9I7RNv4BoYugSPAflh7Z0iI/2/MItwXbNh8wK5yqboJQu8dg9ohjqoV16A91zC/tA
         igEA==
X-Gm-Message-State: APjAAAU3Ix5wALnCpHFSpdV4pG8mHe7bu2E9GaIYR5iyBgFKsSvKc11m
        YgVl195NqnRAaUCTkuhDmKyx8ZsRMvC05pxl3RlP3g==
X-Google-Smtp-Source: APXvYqzs3BOEDM3w9OuhJ4FQl4f2puNY9YafhpkAs2qld4bMQQtf2+HUV0DluaeoOIMugNCx0V3PFA4aCCtffsdiVE8=
X-Received: by 2002:a1c:720e:: with SMTP id n14mr339413wmc.53.1564690637336;
 Thu, 01 Aug 2019 13:17:17 -0700 (PDT)
MIME-Version: 1.0
References: <13353.1564635114@turing-police> <CAKv+Gu8EF3R05hLWHh7mgbgkUyzBwELctdVvSFMq+6Crw6Tf4A@mail.gmail.com>
 <32521.1564638419@turing-police> <CAKv+Gu_zEO75s6o8bv4TXPxibSH-dCe-V46AYjL-dOEAvpQaqw@mail.gmail.com>
 <1166.1564639726@turing-police>
In-Reply-To: <1166.1564639726@turing-police>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 1 Aug 2019 23:17:05 +0300
Message-ID: <CAKv+Gu8oK22Su5mq=i3pnKrkPq85a3hX-kyog9xwAVYa705iYg@mail.gmail.com>
Subject: Re: [PATCH] linux-next 20190731 - aegis128-core.c fails to build
To:     =?UTF-8?Q?Valdis_Kl=C4=93tnieks?= <valdis.kletnieks@vt.edu>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 1 Aug 2019 at 09:08, Valdis Kl=C4=93tnieks <valdis.kletnieks@vt.edu=
> wrote:
>
> On Thu, 01 Aug 2019 09:04:11 +0300, Ard Biesheuvel said:
>
> > The fact that crypto_aegis128_have_simd() does get optimized away, but
> > crypto_aegis128_update_simd() doesn't (which is only called directly
> > and not via a function pointer like the other two routines) makes me
> > suspicious that this is some pathology in the compiler. Is this a
> > distro build of gcc? Also, which architecture are you compiling for?
>
> It's the Fedora Rawhide build on x86_64.
>
>  [/usr/src/linux-next] gcc --version
> gcc (GCC) 9.1.1 20190605 (Red Hat 9.1.1-2)
> Copyright (C) 2019 Free Software Foundation, Inc.
> This is free software; see the source for copying conditions.  There is N=
O
> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOS=
E.
>

Strange.

Does the following patch make any difference?

https://lore.kernel.org/linux-crypto/20190729074434.21064-1-ard.biesheuvel@=
linaro.org/
