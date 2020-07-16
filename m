Return-Path: <SRS0=7zOR=A3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6A14C433E1
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 13:09:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B6052065F
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 13:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594904993;
	bh=gCirQlRgyN3gdbdnfrV1NlDcYeNz1fTLt7wN+Itu1pk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=vwhO2UKlcDr5EOVxGaN3/Ng65heQnE3xAzEv9VYj9uUJtPyEoOiS4HEhshgnwsm5M
	 p64h3KCNVErCdXBZOybsPm9eHl97oYcM3pjWm8CGzgZ+abtTIAjuJlku96Ug+Evs1z
	 A5Zh2bb9kmnqTbt93F+6DJekS+xoz40f2/fcNhJA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgGPNJx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jul 2020 09:09:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:35614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726537AbgGPNJw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jul 2020 09:09:52 -0400
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A60BD2065F
        for <linux-crypto@vger.kernel.org>; Thu, 16 Jul 2020 13:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594904991;
        bh=gCirQlRgyN3gdbdnfrV1NlDcYeNz1fTLt7wN+Itu1pk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ujMe025iRO1aXI1pf8Ti6sUcxlUSNvy9Xl/dP/1Xf2lFkYwCfEvdiTnD5VDxjtHlM
         b4dOPyJeSHUwTE2Qw6NbhPpFIVcTYCjlRgLAHnDjHRP8S1KJdmNMVF0jKDkhQ4t6FK
         bkdJIUepNtKHRfVcfZCMH1n3VyRZZuzBgzxOCi+U=
Received: by mail-oi1-f177.google.com with SMTP id k22so5035163oib.0
        for <linux-crypto@vger.kernel.org>; Thu, 16 Jul 2020 06:09:51 -0700 (PDT)
X-Gm-Message-State: AOAM533dGYMo0LjkZ91pUM+36ObhA3xTa5cLxzucalDQHoeEHuq4O0Kp
        yz23KsebjgARFpH3dhqcT2TcHkygcjH5onv+PHA=
X-Google-Smtp-Source: ABdhPJzZEz7Sf02oUTCag5/azCK8Ee5BZbNltFbo1x9kxjT+12EYlUiPVaMR0jN6Nvykkn4FbFOGDl0bAuU5CdunFEI=
X-Received: by 2002:aca:5516:: with SMTP id j22mr3539716oib.47.1594904990986;
 Thu, 16 Jul 2020 06:09:50 -0700 (PDT)
MIME-Version: 1.0
References: <2543601.mvXUDI8C0e@positron.chronox.de> <5722559.lOV4Wx5bFT@positron.chronox.de>
 <4650810.GXAFRqVoOG@positron.chronox.de> <20200716073032.GA28173@gondor.apana.org.au>
 <CAMj1kXHNM5pwjSuVgxP2SA5juTnVxpj0ULUkjNWuoHqVTjuE8Q@mail.gmail.com> <20200716125002.oxr7yyeehz74mgq4@valinor>
In-Reply-To: <20200716125002.oxr7yyeehz74mgq4@valinor>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 16 Jul 2020 16:09:39 +0300
X-Gmail-Original-Message-ID: <CAMj1kXHBmgaQKDQoVd-wN0JpKunE53QRg6uQ=3fRZmpNw=drYg@mail.gmail.com>
Message-ID: <CAMj1kXHBmgaQKDQoVd-wN0JpKunE53QRg6uQ=3fRZmpNw=drYg@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] lib/mpi: Add mpi_sub_ui()
To:     Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>, nhorman@redhat.com,
        simo@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 16 Jul 2020 at 15:50, Marcelo Henrique Cerri
<marcelo.cerri@canonical.com> wrote:
>
> No. The code is really based on Gnu MP. I used the header from
> lib/mpi/mpi-pow.c as reference and that's source of the mention to
> GnuPG that went unnoticed by me.
>

So where did the file lib/mpi/mpi-sub-ui.c come from? From GnuPG or
from GnuMP? Did you modify the license statement? Because as proposed,
this patch clearly is not acceptable from GPL compliance  point of
view.



> You can find the original Gnu MP source that I used as reference in
> the file gmp-6.2.0/mpz/aors_ui.h from:
>
> https://gmplib.org/download/gmp/gmp-6.2.0.tar.lz
>
> I'm pasting the contents of gmp-6.2.0/mpz/aors_ui.h below for
> reference. Do you think we should use or adapt the original header
> instead?
>
> That said, assuming the patch set submitted by Tianjia is updated to
> ensure that mpi_sub_ui() and other functions are returning allocation
> errors, we could drop this patch in favor of that patch set that is
> more extensive and also provides an implementation to mpi_sub_ui().
>
>
> --->8---
> /* mpz_add_ui, mpz_sub_ui -- Add or subtract an mpz_t and an unsigned
>    one-word integer.
>
> Copyright 1991, 1993, 1994, 1996, 1999-2002, 2004, 2012, 2013, 2015
> Free Software Foundation, Inc.
>
> This file is part of the GNU MP Library.
>
> The GNU MP Library is free software; you can redistribute it and/or modif=
y
> it under the terms of either:
>
>   * the GNU Lesser General Public License as published by the Free
>     Software Foundation; either version 3 of the License, or (at your
>     option) any later version.
>
> or
>
>   * the GNU General Public License as published by the Free Software
>     Foundation; either version 2 of the License, or (at your option) any
>     later version.
>
> or both in parallel, as here.
>
> The GNU MP Library is distributed in the hope that it will be useful, but
> WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILIT=
Y
> or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
> for more details.
>
> You should have received copies of the GNU General Public License and the
> GNU Lesser General Public License along with the GNU MP Library.  If not,
> see https://www.gnu.org/licenses/.  */
>
> #include "gmp-impl.h"
>
>
> #ifdef OPERATION_add_ui
> #define FUNCTION          mpz_add_ui
> #define FUNCTION2         mpz_add
> #define VARIATION_CMP     >=3D
> #define VARIATION_NEG
> #define VARIATION_UNNEG   -
> #endif
>
> #ifdef OPERATION_sub_ui
> #define FUNCTION          mpz_sub_ui
> #define FUNCTION2         mpz_sub
> #define VARIATION_CMP     <
> #define VARIATION_NEG     -
> #define VARIATION_UNNEG
> #endif
>
> #ifndef FUNCTION
> Error, need OPERATION_add_ui or OPERATION_sub_ui
> #endif
>
>
> void
> FUNCTION (mpz_ptr w, mpz_srcptr u, unsigned long int vval)
> {
>   mp_srcptr up;
>   mp_ptr wp;
>   mp_size_t usize, wsize;
>   mp_size_t abs_usize;
>
> #if BITS_PER_ULONG > GMP_NUMB_BITS  /* avoid warnings about shift amount =
*/
>   if (vval > GMP_NUMB_MAX)
>     {
>       mpz_t v;
>       mp_limb_t vl[2];
>       PTR(v) =3D vl;
>       vl[0] =3D vval & GMP_NUMB_MASK;
>       vl[1] =3D vval >> GMP_NUMB_BITS;
>       SIZ(v) =3D 2;
>       FUNCTION2 (w, u, v);
>       return;
>     }
> #endif
>
>   usize =3D SIZ (u);
>   if (usize =3D=3D 0)
>     {
>       MPZ_NEWALLOC (w, 1)[0] =3D vval;
>       SIZ (w) =3D VARIATION_NEG (vval !=3D 0);
>       return;
>     }
>
>   abs_usize =3D ABS (usize);
>
>   /* If not space for W (and possible carry), increase space.  */
>   wp =3D MPZ_REALLOC (w, abs_usize + 1);
>
>   /* These must be after realloc (U may be the same as W).  */
>   up =3D PTR (u);
>
>   if (usize VARIATION_CMP 0)
>     {
>       mp_limb_t cy;
>       cy =3D mpn_add_1 (wp, up, abs_usize, (mp_limb_t) vval);
>       wp[abs_usize] =3D cy;
>       wsize =3D VARIATION_NEG (abs_usize + cy);
>     }
>   else
>     {
>       /* The signs are different.  Need exact comparison to determine
>          which operand to subtract from which.  */
>       if (abs_usize =3D=3D 1 && up[0] < vval)
>         {
>           wp[0] =3D vval - up[0];
>           wsize =3D VARIATION_NEG 1;
>         }
>       else
>         {
>           mpn_sub_1 (wp, up, abs_usize, (mp_limb_t) vval);
>           /* Size can decrease with at most one limb.  */
>           wsize =3D VARIATION_UNNEG (abs_usize - (wp[abs_usize - 1] =3D=
=3D 0));
>         }
>     }
>
>   SIZ (w) =3D wsize;
> }
> --->*---
>
>
>
> On Thu, Jul 16, 2020 at 11:41:17AM +0300, Ard Biesheuvel wrote:
> > On Thu, 16 Jul 2020 at 10:30, Herbert Xu <herbert@gondor.apana.org.au> =
wrote:
> > >
> > > On Sun, Jul 12, 2020 at 06:39:54PM +0200, Stephan M=C3=BCller wrote:
> > > >
> > > > diff --git a/lib/mpi/mpi-sub-ui.c b/lib/mpi/mpi-sub-ui.c
> > > > new file mode 100644
> > > > index 000000000000..fa6b085bac36
> > > > --- /dev/null
> > > > +++ b/lib/mpi/mpi-sub-ui.c
> > > > @@ -0,0 +1,60 @@
> > > > +// SPDX-License-Identifier: GPL-2.0-or-later
> > > > +/* mpi-sub-ui.c  -  MPI functions
> > > > + *      Copyright 1991, 1993, 1994, 1996, 1999-2002, 2004, 2012, 2=
013, 2015
> > > > + *      Free Software Foundation, Inc.
> > > > + *
> > > > + * This file is part of GnuPG.
> > > > + *
> > > > + * Note: This code is heavily based on the GNU MP Library.
> > > > + *    Actually it's the same code with only minor changes in the
> > > > + *    way the data is stored; this is to support the abstraction
> > > > + *    of an optional secure memory allocation which may be used
> > > > + *    to avoid revealing of sensitive data due to paging etc.
> > > > + *    The GNU MP Library itself is published under the LGPL;
> > > > + *    however I decided to publish this code under the plain GPL.
> > > > + */
> > >
> > > Hmm, you said that this code is from GNU MP.  But this notice clearly
> > > says that it's part of GnuPG and is under GPL.  Though it doesn't
> > > clarify what version of GPL it is.  Can you please clarify this with
> > > the author?
> > >
> >
> > GnuPG was relicensed under GPLv3 in ~2007, IIRC, so given the
> > copyright years and the explicit statements that the file is part of
> > GnuPG and not under the original LGPL license, there is no way we can
> > take this code under the kernel's GPLv2 license.
>
> --
> Regards,
> Marcelo
>
