Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7E3CC6FA8B
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Sep 2022 09:24:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbiIPJYa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Sep 2022 05:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiIPJY1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Sep 2022 05:24:27 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B7667CB8
        for <linux-crypto@vger.kernel.org>; Fri, 16 Sep 2022 02:24:25 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-3454e58fe53so252798777b3.2
        for <linux-crypto@vger.kernel.org>; Fri, 16 Sep 2022 02:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=ICLxIYLKXePaeX7uqOrK23uRDuhGBueBgNNfHGZTbYo=;
        b=iKuPoaJFZuGpISn2LNxjPZDTYltZp2yYz7EjsSDOTMSrsmWKISyQWE+8R0W3Noaxdh
         J67WD0GhPNbs2ZfwpPxNgbFMM4v//+o2m6W92oNOWGoQp8Pm2HMq1js5UI1sFo87fUI9
         MvqGeHVFn9D1YGWApSlPSYmnXrGlHwaLfjdQFN0BwObXO3DUgO3RrA6T3xaQqEPGLzXQ
         0EXws5GnRh/SMbPaMkkyLZ+getRmmxwYdyMEUYQYwgzjcGGlv3ejcfImrZFEFoXl2eih
         RHAeAef5dhW/OI5ZfMGUohaRMTire37kk8EJdr2qZumLOUhrmXM2g5T6Apj/GBOEG16z
         rgaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ICLxIYLKXePaeX7uqOrK23uRDuhGBueBgNNfHGZTbYo=;
        b=OhM779S3C31sgrLV6ueMEXgGnVt+Ux8L2K+oY0Ua20pYZGXxfIr3XF9sJmDcW/b1Fr
         ANyw9XZmREHKus1J1mCP17i0wm9tmVk3BQAB+8x04iJiv05W0J/EmRiDVyI5+B9BUfCG
         sLTT6oASZ52MS6magfn3ukLH49jMI86AhNR8x/9R7SDdMPScaURwnb8Zz2EhNi5gRFhn
         COXKQ7GRPMAJhmq7EIgETGx+SHWGbHu1iXcZS8c7wSp37crk9bS7VIveZhCPxQycBg9G
         Na7JfjboTRBMmXat8mU9ptUWR6X5luaeMhWJ07TYocK2jcAF5s17ExFHO1Ts2rfd5cZt
         vouw==
X-Gm-Message-State: ACrzQf2pB3Z4S4OgbwLhuH3HGOn0E/yFoDPFc+0PpF02cG9ZLuS/1+98
        noz/CTGvDcWGYSZFthHcpyp+dGYo4YRdPQlUj2igKA==
X-Google-Smtp-Source: AMsMyM4IEyu4SELoiPZYqJXqFSsxD8xWUmDmdqx1BOynAfW+NapM9J/HLecVe0kFGIteirFbOOlJXPKdVbsta53L3Cs=
X-Received: by 2002:a0d:d64b:0:b0:345:2455:a1c with SMTP id
 y72-20020a0dd64b000000b0034524550a1cmr3593259ywd.295.1663320264035; Fri, 16
 Sep 2022 02:24:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220909095811.2166073-1-glider@google.com> <20220909095811.2166073-2-glider@google.com>
In-Reply-To: <20220909095811.2166073-2-glider@google.com>
From:   Alexander Potapenko <glider@google.com>
Date:   Fri, 16 Sep 2022 11:23:47 +0200
Message-ID: <CAG_fn=UT24yoY=amdXF5gXQjM9jw8bMamjC-mqJndiXNtNhvLA@mail.gmail.com>
Subject: Re: [PATCH -next 2/2] crypto: x86: kmsan: disable accelerated configs
 in KMSAN builds
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Robert Elliott <elliott@hpe.com>,
        Linux Crypto List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        Alexander Potapenko <glider@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Stephen,

Please use this patch to replace "crypto: x86: kmsan: disable
accelerated configs in KMSAN builds" when merging linux-mm into
linux-next (assuming arch/x86/crypto/Kconfig is still in -next).

On Fri, Sep 9, 2022 at 11:58 AM Alexander Potapenko <glider@google.com> wro=
te:
>
> KMSAN is unable to understand when initialized values come from assembly.
> Disable accelerated configs in KMSAN builds to prevent false positive
> reports.
>
> Signed-off-by: Alexander Potapenko <glider@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Robert Elliott <elliott@hpe.com>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-next@vger.kernel.org
> ---
>  crypto/Kconfig | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 40423a14f86f5..4a2915bd40d1f 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -1430,7 +1430,9 @@ endif
>  if SPARC
>  source "arch/sparc/crypto/Kconfig"
>  endif
> -if X86
> +# KMSAN is unable to understand when initialized values come from assemb=
ly.
> +# Disable accelerated configs to prevent false positive reports.
> +if X86 && !KMSAN
>  source "arch/x86/crypto/Kconfig"
>  endif
>
> --
> 2.37.2.789.g6183377224-goog
>


--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Liana Sebastian
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
