Return-Path: <SRS0=7zOR=A3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13606C433E5
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 13:53:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D490A20760
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 13:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594907622;
	bh=RnPjMrcsQsMuF3ZJDypOuUl2a/5i5b2XMYviro5MCzk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=0QQ1mkikfDe3tH0+c3zTyAkbFO9MibpE+WvvNGSTdqMKWgm55X3bh8toCCZtLTgjH
	 B+CRrGUITlkKKQD2H04MwL4fZ96ne3MI7d78gGg/a+kuYutiRHljh16T0Cd3iFEDdi
	 oDsbWP1n0nSdAy5VDHFAqQB68lJlFHtZaTAB7Ox8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728479AbgGPNxm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jul 2020 09:53:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726986AbgGPNxi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jul 2020 09:53:38 -0400
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C32E220842
        for <linux-crypto@vger.kernel.org>; Thu, 16 Jul 2020 13:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594907616;
        bh=RnPjMrcsQsMuF3ZJDypOuUl2a/5i5b2XMYviro5MCzk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=grJGP2QWdErBgeMIMXnofNz0jLhuSEXWOM3ljQ76o9rIVMrOQWzuey8CTRj1sFgoO
         pclJaj24+orNCBjdmwDmnoOgo395tZI+67jZiej71P2k6PA2G4MpOacMk3T96kA9p9
         qvWfvfrhT612ikC3X0qe8h5y/PLqhhfFoERnq1Jc=
Received: by mail-ot1-f46.google.com with SMTP id 18so4234481otv.6
        for <linux-crypto@vger.kernel.org>; Thu, 16 Jul 2020 06:53:36 -0700 (PDT)
X-Gm-Message-State: AOAM5334h8Z10P3sJGvs9eFaIBbKPokalNZWbpqMDi0lJADMbJzZZnFi
        SIdBHRnpm17+GJHVdKgGMlMqD6DDWOFtau8A718=
X-Google-Smtp-Source: ABdhPJzaqsgAeZlpBFNPpWBc2jtNHL6pPrluM9//iyHAP3gza3VZnEtX1Opc/CKrB30C+ogrGssLs9cZkj/eIVx50n8=
X-Received: by 2002:a9d:688:: with SMTP id 8mr4502112otx.108.1594907615876;
 Thu, 16 Jul 2020 06:53:35 -0700 (PDT)
MIME-Version: 1.0
References: <2543601.mvXUDI8C0e@positron.chronox.de> <5722559.lOV4Wx5bFT@positron.chronox.de>
 <4650810.GXAFRqVoOG@positron.chronox.de> <20200716073032.GA28173@gondor.apana.org.au>
 <CAMj1kXHNM5pwjSuVgxP2SA5juTnVxpj0ULUkjNWuoHqVTjuE8Q@mail.gmail.com>
 <20200716125002.oxr7yyeehz74mgq4@valinor> <CAMj1kXHBmgaQKDQoVd-wN0JpKunE53QRg6uQ=3fRZmpNw=drYg@mail.gmail.com>
 <20200716134128.7br6npd2nsck33qm@valinor>
In-Reply-To: <20200716134128.7br6npd2nsck33qm@valinor>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 16 Jul 2020 16:53:24 +0300
X-Gmail-Original-Message-ID: <CAMj1kXGJMBLxPX9RuHai9JK_5wQSufEzN4arHLVE_pSnsbGzuQ@mail.gmail.com>
Message-ID: <CAMj1kXGJMBLxPX9RuHai9JK_5wQSufEzN4arHLVE_pSnsbGzuQ@mail.gmail.com>
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

On Thu, 16 Jul 2020 at 16:41, Marcelo Henrique Cerri
<marcelo.cerri@canonical.com> wrote:
>
> On Thu, Jul 16, 2020 at 04:09:39PM +0300, Ard Biesheuvel wrote:
> > On Thu, 16 Jul 2020 at 15:50, Marcelo Henrique Cerri
> > <marcelo.cerri@canonical.com> wrote:
> > >
> > > No. The code is really based on Gnu MP. I used the header from
> > > lib/mpi/mpi-pow.c as reference and that's source of the mention to
> > > GnuPG that went unnoticed by me.
> > >
> >
> > So where did the file lib/mpi/mpi-sub-ui.c come from? From GnuPG or
> > from GnuMP? Did you modify the license statement? Because as proposed,
> > this patch clearly is not acceptable from GPL compliance  point of
> > view.
>
> Sorry for the confusion. The code is from Gnu MP (not GnuPG).
>
> Gnu MP is distributed under either LGPLv3 or later or GPLv2 or later
> (check their license statement on the aors_ui.h file below).
>
> For mpi-sub-ui.h I added a SPDX identifier for GPLv2 or later and I
> kept the FSF copyright line.
>
> I also used the header from mpi-powm.c as a reference basically to
> inform the code was changed from its original form.
>
> Here lies my mistake, I didn't notice that part was referring to GnuPG
> instead of Gnu MP.
>
> So mpi-sub-ui.h header was actually intended to be:
>
>     // SPDX-License-Identifier: GPL-2.0-or-later
>     /* mpi-sub-ui.c  -  MPI functions
>      *      Copyright 1991, 1993, 1994, 1996, 1999-2002, 2004, 2012, 2013=
, 2015
>      *      Free Software Foundation, Inc.
>      *
>      * This file is part of Gnu MP.
>      *
>      * Note: This code is heavily based on the GNU MP Library.
>      *      Actually it's the same code with only minor changes in the
>      *      way the data is stored; this is to support the abstraction
>      *      of an optional secure memory allocation which may be used
>      *      to avoid revealing of sensitive data due to paging etc.
>      *      The GNU MP Library itself is published under the LGPL;
>      *      however I decided to publish this code under the plain GPL.
>      */
>
> Or maybe instead of "This file is part of Gnu MP.", "This file is
> based on Gnu MP" might be more appropriate.
>
> Do you have any license concerns considering this updated header?
>

Yes. How can this code be both part of GnuMP *and* be heavily based on
it, but with changes?

Please avoid making changes to the original header, just add the SPDX
header in front, and add a clear justification in the commit log where
the file came from (preferably including git url and commit ID), and
what you based your assertion on that its license is compatible with
GPLv2.

Ideally, you would import the file *exactly* as it appears in the
upstream in one patch (with the above justification), and apply any
necessary changes in a subsequent patch, so it's  crystal clear that
we are complying with the original license.



>
> >
> >
> >
> > > You can find the original Gnu MP source that I used as reference in
> > > the file gmp-6.2.0/mpz/aors_ui.h from:
> > >
> > > https://gmplib.org/download/gmp/gmp-6.2.0.tar.lz
> > >
> > > I'm pasting the contents of gmp-6.2.0/mpz/aors_ui.h below for
> > > reference. Do you think we should use or adapt the original header
> > > instead?
> > >
> > > That said, assuming the patch set submitted by Tianjia is updated to
> > > ensure that mpi_sub_ui() and other functions are returning allocation
> > > errors, we could drop this patch in favor of that patch set that is
> > > more extensive and also provides an implementation to mpi_sub_ui().
> > >
> > >
> > > --->8---
> > > /* mpz_add_ui, mpz_sub_ui -- Add or subtract an mpz_t and an unsigned
> > >    one-word integer.
> > >
> > > Copyright 1991, 1993, 1994, 1996, 1999-2002, 2004, 2012, 2013, 2015
> > > Free Software Foundation, Inc.
> > >
>
>
> Gnu MP license -.
>                 V
>
>
> > > This file is part of the GNU MP Library.
> > >
> > > The GNU MP Library is free software; you can redistribute it and/or m=
odify
> > > it under the terms of either:
> > >
> > >   * the GNU Lesser General Public License as published by the Free
> > >     Software Foundation; either version 3 of the License, or (at your
> > >     option) any later version.
> > >
> > > or
> > >
> > >   * the GNU General Public License as published by the Free Software
> > >     Foundation; either version 2 of the License, or (at your option) =
any
> > >     later version.
> > >
> > > or both in parallel, as here.
> > >
> > > The GNU MP Library is distributed in the hope that it will be useful,=
 but
> > > WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTAB=
ILITY
> > > or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public Lice=
nse
> > > for more details.
> > >
> > > You should have received copies of the GNU General Public License and=
 the
> > > GNU Lesser General Public License along with the GNU MP Library.  If =
not,
> > > see https://www.gnu.org/licenses/.  */
> > >
> > > #include "gmp-impl.h"
> > >
> > >
> > > #ifdef OPERATION_add_ui
> > > #define FUNCTION          mpz_add_ui
> > > #define FUNCTION2         mpz_add
> > > #define VARIATION_CMP     >=3D
> > > #define VARIATION_NEG
> > > #define VARIATION_UNNEG   -
> > > #endif
> > >
> > > #ifdef OPERATION_sub_ui
> > > #define FUNCTION          mpz_sub_ui
> > > #define FUNCTION2         mpz_sub
> > > #define VARIATION_CMP     <
> > > #define VARIATION_NEG     -
> > > #define VARIATION_UNNEG
> > > #endif
> > >
> > > #ifndef FUNCTION
> > > Error, need OPERATION_add_ui or OPERATION_sub_ui
> > > #endif
> > >
> > >
> > > void
> > > FUNCTION (mpz_ptr w, mpz_srcptr u, unsigned long int vval)
> > > {
> > >   mp_srcptr up;
> > >   mp_ptr wp;
> > >   mp_size_t usize, wsize;
> > >   mp_size_t abs_usize;
> > >
> > > #if BITS_PER_ULONG > GMP_NUMB_BITS  /* avoid warnings about shift amo=
unt */
> > >   if (vval > GMP_NUMB_MAX)
> > >     {
> > >       mpz_t v;
> > >       mp_limb_t vl[2];
> > >       PTR(v) =3D vl;
> > >       vl[0] =3D vval & GMP_NUMB_MASK;
> > >       vl[1] =3D vval >> GMP_NUMB_BITS;
> > >       SIZ(v) =3D 2;
> > >       FUNCTION2 (w, u, v);
> > >       return;
> > >     }
> > > #endif
> > >
> > >   usize =3D SIZ (u);
> > >   if (usize =3D=3D 0)
> > >     {
> > >       MPZ_NEWALLOC (w, 1)[0] =3D vval;
> > >       SIZ (w) =3D VARIATION_NEG (vval !=3D 0);
> > >       return;
> > >     }
> > >
> > >   abs_usize =3D ABS (usize);
> > >
> > >   /* If not space for W (and possible carry), increase space.  */
> > >   wp =3D MPZ_REALLOC (w, abs_usize + 1);
> > >
> > >   /* These must be after realloc (U may be the same as W).  */
> > >   up =3D PTR (u);
> > >
> > >   if (usize VARIATION_CMP 0)
> > >     {
> > >       mp_limb_t cy;
> > >       cy =3D mpn_add_1 (wp, up, abs_usize, (mp_limb_t) vval);
> > >       wp[abs_usize] =3D cy;
> > >       wsize =3D VARIATION_NEG (abs_usize + cy);
> > >     }
> > >   else
> > >     {
> > >       /* The signs are different.  Need exact comparison to determine
> > >          which operand to subtract from which.  */
> > >       if (abs_usize =3D=3D 1 && up[0] < vval)
> > >         {
> > >           wp[0] =3D vval - up[0];
> > >           wsize =3D VARIATION_NEG 1;
> > >         }
> > >       else
> > >         {
> > >           mpn_sub_1 (wp, up, abs_usize, (mp_limb_t) vval);
> > >           /* Size can decrease with at most one limb.  */
> > >           wsize =3D VARIATION_UNNEG (abs_usize - (wp[abs_usize - 1] =
=3D=3D 0));
> > >         }
> > >     }
> > >
> > >   SIZ (w) =3D wsize;
> > > }
> > > --->*---
> > >
> > >
> > >
> > > On Thu, Jul 16, 2020 at 11:41:17AM +0300, Ard Biesheuvel wrote:
> > > > On Thu, 16 Jul 2020 at 10:30, Herbert Xu <herbert@gondor.apana.org.=
au> wrote:
> > > > >
> > > > > On Sun, Jul 12, 2020 at 06:39:54PM +0200, Stephan M=C3=BCller wro=
te:
> > > > > >
> > > > > > diff --git a/lib/mpi/mpi-sub-ui.c b/lib/mpi/mpi-sub-ui.c
> > > > > > new file mode 100644
> > > > > > index 000000000000..fa6b085bac36
> > > > > > --- /dev/null
> > > > > > +++ b/lib/mpi/mpi-sub-ui.c
> > > > > > @@ -0,0 +1,60 @@
> > > > > > +// SPDX-License-Identifier: GPL-2.0-or-later
> > > > > > +/* mpi-sub-ui.c  -  MPI functions
> > > > > > + *      Copyright 1991, 1993, 1994, 1996, 1999-2002, 2004, 201=
2, 2013, 2015
> > > > > > + *      Free Software Foundation, Inc.
> > > > > > + *
> > > > > > + * This file is part of GnuPG.
> > > > > > + *
> > > > > > + * Note: This code is heavily based on the GNU MP Library.
> > > > > > + *    Actually it's the same code with only minor changes in t=
he
> > > > > > + *    way the data is stored; this is to support the abstracti=
on
> > > > > > + *    of an optional secure memory allocation which may be use=
d
> > > > > > + *    to avoid revealing of sensitive data due to paging etc.
> > > > > > + *    The GNU MP Library itself is published under the LGPL;
> > > > > > + *    however I decided to publish this code under the plain G=
PL.
> > > > > > + */
> > > > >
> > > > > Hmm, you said that this code is from GNU MP.  But this notice cle=
arly
> > > > > says that it's part of GnuPG and is under GPL.  Though it doesn't
> > > > > clarify what version of GPL it is.  Can you please clarify this w=
ith
> > > > > the author?
> > > > >
> > > >
> > > > GnuPG was relicensed under GPLv3 in ~2007, IIRC, so given the
> > > > copyright years and the explicit statements that the file is part o=
f
> > > > GnuPG and not under the original LGPL license, there is no way we c=
an
> > > > take this code under the kernel's GPLv2 license.
> > >
> > > --
> > > Regards,
> > > Marcelo
> > >
>
> --
> Regards,
> Marcelo
>
