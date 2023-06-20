Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0574EB64D7
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jun 2023 03:51:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjFTDvb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Jun 2023 23:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbjFTDva (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jun 2023 23:51:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A132010F0
        for <linux-crypto@vger.kernel.org>; Mon, 19 Jun 2023 20:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687233042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZuQmxozj9Icsa+63bIAepWz6gcNGs5RMzXXBV7sDdWc=;
        b=hjif+PiR+G+2BZdJUT1kug3WSvCqb8FgPEnExw/Ukj6nzZEUv5UAbs59oCyyziOdg6dJSv
        NAgS3i/fjT0RYVTu96DNIAbC3VIzJH/y5AZDLN0j4Wr4O2HtMNpfm/LzTNqkoJGT0HNzGi
        yJzhWRCKvbM4IyNiTacNI0+Esa13emA=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-84-BwFimRpXPqSWisHVx2GHWw-1; Mon, 19 Jun 2023 23:50:41 -0400
X-MC-Unique: BwFimRpXPqSWisHVx2GHWw-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-62de823a3aeso42239606d6.1
        for <linux-crypto@vger.kernel.org>; Mon, 19 Jun 2023 20:50:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687233040; x=1689825040;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZuQmxozj9Icsa+63bIAepWz6gcNGs5RMzXXBV7sDdWc=;
        b=jNPNfZqUskgnPrxHSqNBAPtnPvXEhgmQxgshWqfsZymdiiHTA21q9XHZSfA4SaK+cY
         vPMyGDuK/1KhmuBbXoWyGh8+ekvjuyPTRrpUb38yKKDPlh07YToF+RqfnHI9bGRIk5sq
         I0IXDEJa3vqInVAib5OHtehUUD6hzLVhcD+ACZ7lZOVN8Aot/E/9Eo6DmKPUZjUd8yE5
         XWwdSv0EFWekaPRWVEnvKZTH6gHp4LcBOniCzlvMT79DwCRMsFFwGJDIro/0w5pUb2y2
         rSPuLNHxmpuoRybHQGI/HpSMxXtlKtvSV4PnlSvGWZxOjupb6PRikRbvoghcDgk59FZG
         gN9Q==
X-Gm-Message-State: AC+VfDxwHBCX4kmnLg5velr6222WhRlMKmuoxH6tBYX8ZbO4XsfosO4T
        3Fq2KeFEROUo/16uxFMsVCwZT/fpqynPPSff+NYJqKQqEgeYuw76avglVfh/4srgBt6NVmUPD0P
        Oo+Ht8ArNOv5bhOljWZwvOzUQihuLbrvjQANcAMrJKLy2t7VM
X-Received: by 2002:a05:6214:1242:b0:626:169e:7700 with SMTP id r2-20020a056214124200b00626169e7700mr13936227qvv.9.1687233040246;
        Mon, 19 Jun 2023 20:50:40 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7X8Xx9b+vHP1m3x4LAqqkvPq8SugfhCs4swS463YRgCHiXWBI0PieyBx9XTELBd7N5lyL7BsXkkSBgGt4p1Hw=
X-Received: by 2002:a05:6214:1242:b0:626:169e:7700 with SMTP id
 r2-20020a056214124200b00626169e7700mr13936214qvv.9.1687233039934; Mon, 19 Jun
 2023 20:50:39 -0700 (PDT)
MIME-Version: 1.0
References: <20230606173127.4050254-1-ardb@kernel.org> <20230606173127.4050254-3-ardb@kernel.org>
 <ZIQmrj7lh7cCfC_C@debian.me>
In-Reply-To: <ZIQmrj7lh7cCfC_C@debian.me>
From:   Richard Fontana <rfontana@redhat.com>
Date:   Mon, 19 Jun 2023 23:50:29 -0400
Message-ID: <CAC1cPGzQKwXt=2fHT4HLwGmdqDDGCmvY9iBcvoC9OEuW0qFsGw@mail.gmail.com>
Subject: Re: [PATCH 2/3] crypto: arm - add some missing SPDX headers
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
        herbert@gondor.apana.org.au, ebiggers@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Jun 10, 2023 at 3:31=E2=80=AFAM Bagas Sanjaya <bagasdotme@gmail.com=
> wrote:
>
> [also Cc'ing Richard]
>
> On Tue, Jun 06, 2023 at 07:31:26PM +0200, Ard Biesheuvel wrote:
> > Add some missing SPDX headers, and drop the associated boilerplate
> > license text to/from the ARM implementations of ChaCha, CRC-32 and
> > CRC-T10DIF.
> >
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > ---
> >  arch/arm/crypto/chacha-neon-core.S  | 10 +----
> >  arch/arm/crypto/crc32-ce-core.S     | 30 ++-------------
> >  arch/arm/crypto/crct10dif-ce-core.S | 40 +-------------------
> >  3 files changed, 5 insertions(+), 75 deletions(-)
> >
> > diff --git a/arch/arm/crypto/chacha-neon-core.S b/arch/arm/crypto/chach=
a-neon-core.S
> > index 13d12f672656bb8d..46d708118ef948ec 100644
> > --- a/arch/arm/crypto/chacha-neon-core.S
> > +++ b/arch/arm/crypto/chacha-neon-core.S
> > @@ -1,21 +1,13 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> >  /*
> >   * ChaCha/XChaCha NEON helper functions
> >   *
> >   * Copyright (C) 2016 Linaro, Ltd. <ard.biesheuvel@linaro.org>
> >   *
> > - * This program is free software; you can redistribute it and/or modif=
y
> > - * it under the terms of the GNU General Public License version 2 as
> > - * published by the Free Software Foundation.
> > - *
> >   * Based on:
> >   * ChaCha20 256-bit cipher algorithm, RFC7539, x64 SSE3 functions
> >   *
> >   * Copyright (C) 2015 Martin Willi
> > - *
> > - * This program is free software; you can redistribute it and/or modif=
y
> > - * it under the terms of the GNU General Public License as published b=
y
> > - * the Free Software Foundation; either version 2 of the License, or
> > - * (at your option) any later version.
> >   */
>
> I think above makes sense, since I had to pick the most restrictive one
> to satisfy both license option (GPL-2.0+ or GPL-2.0-only).

I am not sure "had to pick the most restrictive one" is necessarily
correct - the kernel could adopt that approach but I don't think
there's any reason why you can't have multiple
SPDX-License-Identifier: lines in a single source file, and it is also
syntactically valid to use
SPDX-License-Identifier: GPL-2.0-only AND GPL-2.0-or-later

Richard

