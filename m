Return-Path: <SRS0=tT4M=AV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57E9DC433E1
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jul 2020 14:42:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3489E2083B
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jul 2020 14:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594392173;
	bh=fCoShq35GT2+HVkpaCJ6q9szyI8+yYI5r4y2w0ro3/U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=hXPUmORCBGqSGEksGN16oqysJ9MzVkslzJjJTL1qJ67qE3wBdnKTNrwP1tV3I62F2
	 rTZb/P15iiAQtdFSL8nhHlmj8yRe8yA8MdTISg+lcbGgQEF48lJq9UiovgNM1gqXji
	 peTsYJLt3hnss9ieG3U3xKzlC4xN4Bd8/zkzknw4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbgGJOmw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Jul 2020 10:42:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:37506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726820AbgGJOmw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Jul 2020 10:42:52 -0400
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86F97207D0
        for <linux-crypto@vger.kernel.org>; Fri, 10 Jul 2020 14:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594392171;
        bh=fCoShq35GT2+HVkpaCJ6q9szyI8+yYI5r4y2w0ro3/U=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=vZsM5wnXMo/Y4osi+ueGEkWqFpo3piibRcEAjWfWPwJeCeKMvFsZLI8s0rhTFh3QS
         vbAo7aDCtIuE4rAxW9q1J5fGJMPxhrrkDIx8fJYit2vZrETtrT6n4haSGTs2p/OEoA
         xigHQDz3Ydn/2T8iGpm1MjKZD7cyvT3CmSVgQjH4=
Received: by mail-oi1-f169.google.com with SMTP id j11so4941227oiw.12
        for <linux-crypto@vger.kernel.org>; Fri, 10 Jul 2020 07:42:51 -0700 (PDT)
X-Gm-Message-State: AOAM531fjAezAi9v/euQTxbfzxHqBahRRIpwLdywbUQpsLjT81zQSGWv
        flklyn7FzMDZVP1NPbqj7ckm9UMynOYhXL5GWTE=
X-Google-Smtp-Source: ABdhPJxdT5U54hfh8/dYj9a1EQojhSKXc4VNQ5vV7HzmGdgG0R6QNbCa2FquAzinBvW/3dhSVKQHx0qm895qyh4aQ54=
X-Received: by 2002:aca:d643:: with SMTP id n64mr4464027oig.33.1594392170896;
 Fri, 10 Jul 2020 07:42:50 -0700 (PDT)
MIME-Version: 1.0
References: <2543601.mvXUDI8C0e@positron.chronox.de> <4577235.31r3eYUQgx@positron.chronox.de>
In-Reply-To: <4577235.31r3eYUQgx@positron.chronox.de>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 10 Jul 2020 17:42:39 +0300
X-Gmail-Original-Message-ID: <CAMj1kXFjzHphXUt7Hesj_EAOJmar9Du1U6YM9X+davMOB6tcng@mail.gmail.com>
Message-ID: <CAMj1kXFjzHphXUt7Hesj_EAOJmar9Du1U6YM9X+davMOB6tcng@mail.gmail.com>
Subject: Re: [PATCH 2/3] lib/mpi: Add mpi_sub_ui()
To:     =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Marcelo Cerri <marcelo.cerri@canonical.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 10 Jul 2020 at 13:16, Stephan M=C3=BCller <smueller@chronox.de> wro=
te:
>
> Add mpi_sub_ui() based on Gnu PG mpz_sub_ui() from mpz/aors_ui.h
> adapting the code to the kernel's structures and coding style and also
> removing the defines used to produce mpz_sub_ui() and mpz_add_ui()
> from the same code.
>

Isn't GnuPG GPLv3 ?


> Signed-off-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
>  include/linux/mpi.h  |  3 +++
>  lib/mpi/Makefile     |  1 +
>  lib/mpi/mpi-sub-ui.c | 60 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 64 insertions(+)
>  create mode 100644 lib/mpi/mpi-sub-ui.c
>
> diff --git a/include/linux/mpi.h b/include/linux/mpi.h
> index 7bd6d8af0004..5d906dfbf3ed 100644
> --- a/include/linux/mpi.h
> +++ b/include/linux/mpi.h
> @@ -63,6 +63,9 @@ int mpi_powm(MPI res, MPI base, MPI exp, MPI mod);
>  int mpi_cmp_ui(MPI u, ulong v);
>  int mpi_cmp(MPI u, MPI v);
>
> +/*-- mpi-sub-ui.c --*/
> +int mpi_sub_ui(MPI w, MPI u, unsigned long vval);
> +
>  /*-- mpi-bit.c --*/
>  void mpi_normalize(MPI a);
>  unsigned mpi_get_nbits(MPI a);
> diff --git a/lib/mpi/Makefile b/lib/mpi/Makefile
> index d5874a7f5ff9..43b8fce14079 100644
> --- a/lib/mpi/Makefile
> +++ b/lib/mpi/Makefile
> @@ -16,6 +16,7 @@ mpi-y =3D \
>         mpicoder.o                      \
>         mpi-bit.o                       \
>         mpi-cmp.o                       \
> +       mpi-sub-ui.o                    \
>         mpih-cmp.o                      \
>         mpih-div.o                      \
>         mpih-mul.o                      \
> diff --git a/lib/mpi/mpi-sub-ui.c b/lib/mpi/mpi-sub-ui.c
> new file mode 100644
> index 000000000000..fa6b085bac36
> --- /dev/null
> +++ b/lib/mpi/mpi-sub-ui.c
> @@ -0,0 +1,60 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/* mpi-sub-ui.c  -  MPI functions
> + *      Copyright 1991, 1993, 1994, 1996, 1999-2002, 2004, 2012, 2013, 2=
015
> + *      Free Software Foundation, Inc.
> + *
> + * This file is part of GnuPG.
> + *
> + * Note: This code is heavily based on the GNU MP Library.
> + *      Actually it's the same code with only minor changes in the
> + *      way the data is stored; this is to support the abstraction
> + *      of an optional secure memory allocation which may be used
> + *      to avoid revealing of sensitive data due to paging etc.
> + *      The GNU MP Library itself is published under the LGPL;
> + *      however I decided to publish this code under the plain GPL.
> + */
> +
> +#include "mpi-internal.h"
> +
> +int mpi_sub_ui(MPI w, MPI u, unsigned long vval)
> +{
> +       if (u->nlimbs =3D=3D 0) {
> +               if (mpi_resize(w, 1) < 0)
> +                       return -ENOMEM;
> +               w->d[0] =3D vval;
> +               w->nlimbs =3D (vval !=3D 0);
> +               w->sign =3D (vval !=3D 0);
> +               return 0;
> +       }
> +
> +       /* If not space for W (and possible carry), increase space. */
> +       if (mpi_resize(w, u->nlimbs + 1))
> +               return -ENOMEM;
> +
> +       if (u->sign) {
> +               mpi_limb_t cy;
> +
> +               cy =3D mpihelp_add_1(w->d, u->d, u->nlimbs, (mpi_limb_t) =
vval);
> +               w->d[u->nlimbs] =3D cy;
> +               w->nlimbs =3D u->nlimbs + cy;
> +               w->sign =3D 1;
> +       } else {
> +               /* The signs are different.  Need exact comparison to det=
ermine
> +                * which operand to subtract from which.
> +                */
> +               if (u->nlimbs =3D=3D 1 && u->d[0] < vval) {
> +                       w->d[0] =3D vval - u->d[0];
> +                       w->nlimbs =3D 1;
> +                       w->sign =3D 1;
> +               } else {
> +                       mpihelp_sub_1(w->d, u->d, u->nlimbs, (mpi_limb_t)=
 vval);
> +                       /* Size can decrease with at most one limb. */
> +                       w->nlimbs =3D (u->nlimbs - (w->d[u->nlimbs - 1] =
=3D=3D 0));
> +                       w->sign =3D 0;
> +               }
> +       }
> +
> +       mpi_normalize(w);
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(mpi_sub_ui);
> --
> 2.26.2
>
>
>
>
