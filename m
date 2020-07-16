Return-Path: <SRS0=7zOR=A3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C439C433E5
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 14:24:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE54820787
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 14:24:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbgGPOYA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jul 2020 10:24:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57906 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727044AbgGPOX7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jul 2020 10:23:59 -0400
Received: from mail-qk1-f198.google.com ([209.85.222.198])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <marcelo.cerri@canonical.com>)
        id 1jw4nh-0005G3-Kz
        for linux-crypto@vger.kernel.org; Thu, 16 Jul 2020 14:23:53 +0000
Received: by mail-qk1-f198.google.com with SMTP id a205so3845991qkc.16
        for <linux-crypto@vger.kernel.org>; Thu, 16 Jul 2020 07:23:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NVFRhv8j1iCWpg7zjLtjIgRLpSwWpMe/mNvFCg+va44=;
        b=pmA3wPb8TEsFHu68ZNg13BkSAa9/WR6QEarXhzyAA+k9aNa9XFdmFd7yC+YYkfryHn
         fMYOzQgVW0fhBu57TRnHvzqqKu+m07WQgLwDU/Gt1+5lD/utwGgkkV3iPfgA/3yvextS
         wzoZNNQtEdj2I9+pN4eLsZguMI0df8Zoxgu9ljjq9gYlrEwmZXuUgTc9h3TMbUkRKc7t
         1dOxYqCZkczdlVefNNL9+vbIehx+nGeFvmsSrXTnQeLczXjro4pQvzbO0KJLvaJWy1Oc
         eFsxC1Q6A1tbFpVp1het5yhkUMMGXqjGGIxWHa5ODwzxurv74aTnzm93yxx8szpF2b3S
         Ophg==
X-Gm-Message-State: AOAM533golQl6dbtklGMgnKkoGIg5g2/sWN+AjNs99cmJrITqzwO11/X
        kYvOy038cMuL9+DpeDclCz5CZBRn8mruwdYBs8l37GBjcQHYfWeAW7Eo944ozQw3XhA2PpiB7zo
        frXhF0H68974Zyw4qaXwfZtAjXxgU7mq5liLKYmSB
X-Received: by 2002:a37:a84c:: with SMTP id r73mr4198071qke.0.1594909432480;
        Thu, 16 Jul 2020 07:23:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwjvZwcCes9bmpMt4H8ZS3tK0REUX+y6wUbXtukvyRrKi7nwrbG5e3JM2phdZrTRNZ4nzCStQ==
X-Received: by 2002:a37:a84c:: with SMTP id r73mr4198027qke.0.1594909431893;
        Thu, 16 Jul 2020 07:23:51 -0700 (PDT)
Received: from valinor ([2804:14c:4e6:18:554f:9c7b:d140:fe0d])
        by smtp.gmail.com with ESMTPSA id x189sm6906507qkc.54.2020.07.16.07.23.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 07:23:50 -0700 (PDT)
Date:   Thu, 16 Jul 2020 11:23:45 -0300
From:   Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan =?utf-8?Q?M=C3=BCller?= <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>, nhorman@redhat.com,
        simo@redhat.com
Subject: Re: [PATCH v2 2/5] lib/mpi: Add mpi_sub_ui()
Message-ID: <20200716142345.bpnenw5j6yhrhjq5@valinor>
References: <2543601.mvXUDI8C0e@positron.chronox.de>
 <5722559.lOV4Wx5bFT@positron.chronox.de>
 <4650810.GXAFRqVoOG@positron.chronox.de>
 <20200716073032.GA28173@gondor.apana.org.au>
 <CAMj1kXHNM5pwjSuVgxP2SA5juTnVxpj0ULUkjNWuoHqVTjuE8Q@mail.gmail.com>
 <20200716125002.oxr7yyeehz74mgq4@valinor>
 <CAMj1kXHBmgaQKDQoVd-wN0JpKunE53QRg6uQ=3fRZmpNw=drYg@mail.gmail.com>
 <20200716134128.7br6npd2nsck33qm@valinor>
 <CAMj1kXGJMBLxPX9RuHai9JK_5wQSufEzN4arHLVE_pSnsbGzuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="oaa5r4ivkodb6p6e"
Content-Disposition: inline
In-Reply-To: <CAMj1kXGJMBLxPX9RuHai9JK_5wQSufEzN4arHLVE_pSnsbGzuQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--oaa5r4ivkodb6p6e
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 16, 2020 at 04:53:24PM +0300, Ard Biesheuvel wrote:
> On Thu, 16 Jul 2020 at 16:41, Marcelo Henrique Cerri
> <marcelo.cerri@canonical.com> wrote:
> >
> > On Thu, Jul 16, 2020 at 04:09:39PM +0300, Ard Biesheuvel wrote:
> > > On Thu, 16 Jul 2020 at 15:50, Marcelo Henrique Cerri
> > > <marcelo.cerri@canonical.com> wrote:
> > > >
> > > > No. The code is really based on Gnu MP. I used the header from
> > > > lib/mpi/mpi-pow.c as reference and that's source of the mention to
> > > > GnuPG that went unnoticed by me.
> > > >
> > >
> > > So where did the file lib/mpi/mpi-sub-ui.c come from? From GnuPG or
> > > from GnuMP? Did you modify the license statement? Because as proposed,
> > > this patch clearly is not acceptable from GPL compliance  point of
> > > view.
> >
> > Sorry for the confusion. The code is from Gnu MP (not GnuPG).
> >
> > Gnu MP is distributed under either LGPLv3 or later or GPLv2 or later
> > (check their license statement on the aors_ui.h file below).
> >
> > For mpi-sub-ui.h I added a SPDX identifier for GPLv2 or later and I
> > kept the FSF copyright line.
> >
> > I also used the header from mpi-powm.c as a reference basically to
> > inform the code was changed from its original form.
> >
> > Here lies my mistake, I didn't notice that part was referring to GnuPG
> > instead of Gnu MP.
> >
> > So mpi-sub-ui.h header was actually intended to be:
> >
> >     // SPDX-License-Identifier: GPL-2.0-or-later
> >     /* mpi-sub-ui.c  -  MPI functions
> >      *      Copyright 1991, 1993, 1994, 1996, 1999-2002, 2004, 2012, 20=
13, 2015
> >      *      Free Software Foundation, Inc.
> >      *
> >      * This file is part of Gnu MP.
> >      *
> >      * Note: This code is heavily based on the GNU MP Library.
> >      *      Actually it's the same code with only minor changes in the
> >      *      way the data is stored; this is to support the abstraction
> >      *      of an optional secure memory allocation which may be used
> >      *      to avoid revealing of sensitive data due to paging etc.
> >      *      The GNU MP Library itself is published under the LGPL;
> >      *      however I decided to publish this code under the plain GPL.
> >      */
> >
> > Or maybe instead of "This file is part of Gnu MP.", "This file is
> > based on Gnu MP" might be more appropriate.
> >
> > Do you have any license concerns considering this updated header?
> >
>=20
> Yes. How can this code be both part of GnuMP *and* be heavily based on
> it, but with changes?
>
> Please avoid making changes to the original header, just add the SPDX
> header in front, and add a clear justification in the commit log where
> the file came from (preferably including git url and commit ID), and
> what you based your assertion on that its license is compatible with
> GPLv2.

The commit message is stating the origin, but I can add a reference to
the mercurial repo with its corresponding id.

>=20
> Ideally, you would import the file *exactly* as it appears in the
> upstream in one patch (with the above justification), and apply any
> necessary changes in a subsequent patch, so it's  crystal clear that
> we are complying with the original license.

I'm not sure that's the ideal approach for this case. The logic is the
same but since naming convention, macros, data types and etc are
pretty different everything was basically re-written to fit the
kernel. Adding the original file and then massively changing will just
add unnecessary noise.

If you agree I will update the commit message with more details about
the original source and then just update the comment header in
mpi-sub-ui.c following closely the original header with minor
adjustments to explain its origin and to fix some checkpatch warnings.

Something like that:

// SPDX-License-Identifier: GPL-2.0-or-later
/* mpi-sub-ui.c - Subtract an unsigned integer from an MPI.
 *
 * Copyright 1991, 1993, 1994, 1996, 1999-2002, 2004, 2012, 2013, 2015
 * Free Software Foundation, Inc.
 *
 * This file was based on the GNU MP Library source file:
 * https://gmplib.org/repo/gmp-6.2/file/tip/mpz/aors_ui.h
 *
 * The GNU MP Library is free software; you can redistribute it and/or modi=
fy
 * it under the terms of either:
 *
 *   * the GNU Lesser General Public License as published by the Free
 *     Software Foundation; either version 3 of the License, or (at your
 *     option) any later version.
 *
 * or
 *
 *   * the GNU General Public License as published by the Free Software
 *     Foundation; either version 2 of the License, or (at your option) any
 *     later version.
 *
 * or both in parallel, as here.
 *
 * The GNU MP Library is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILI=
TY
 * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
 * for more details.
 *
 * You should have received copies of the GNU General Public License and the
 * GNU Lesser General Public License along with the GNU MP Library.  If not,
 * see https://www.gnu.org/licenses/.
 */

>=20
>=20
>=20
> >
> > >
> > >
> > >
> > > > You can find the original Gnu MP source that I used as reference in
> > > > the file gmp-6.2.0/mpz/aors_ui.h from:
> > > >
> > > > https://gmplib.org/download/gmp/gmp-6.2.0.tar.lz
> > > >
> > > > I'm pasting the contents of gmp-6.2.0/mpz/aors_ui.h below for
> > > > reference. Do you think we should use or adapt the original header
> > > > instead?
> > > >
> > > > That said, assuming the patch set submitted by Tianjia is updated to
> > > > ensure that mpi_sub_ui() and other functions are returning allocati=
on
> > > > errors, we could drop this patch in favor of that patch set that is
> > > > more extensive and also provides an implementation to mpi_sub_ui().
> > > >
> > > >
> > > > --->8---
> > > > /* mpz_add_ui, mpz_sub_ui -- Add or subtract an mpz_t and an unsign=
ed
> > > >    one-word integer.
> > > >
> > > > Copyright 1991, 1993, 1994, 1996, 1999-2002, 2004, 2012, 2013, 2015
> > > > Free Software Foundation, Inc.
> > > >
> >
> >
> > Gnu MP license -.
> >                 V
> >
> >
> > > > This file is part of the GNU MP Library.
> > > >
> > > > The GNU MP Library is free software; you can redistribute it and/or=
 modify
> > > > it under the terms of either:
> > > >
> > > >   * the GNU Lesser General Public License as published by the Free
> > > >     Software Foundation; either version 3 of the License, or (at yo=
ur
> > > >     option) any later version.
> > > >
> > > > or
> > > >
> > > >   * the GNU General Public License as published by the Free Software
> > > >     Foundation; either version 2 of the License, or (at your option=
) any
> > > >     later version.
> > > >
> > > > or both in parallel, as here.
> > > >
> > > > The GNU MP Library is distributed in the hope that it will be usefu=
l, but
> > > > WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANT=
ABILITY
> > > > or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public Li=
cense
> > > > for more details.
> > > >
> > > > You should have received copies of the GNU General Public License a=
nd the
> > > > GNU Lesser General Public License along with the GNU MP Library.  I=
f not,
> > > > see https://www.gnu.org/licenses/.  */
> > > >
> > > > #include "gmp-impl.h"
> > > >
> > > >
> > > > #ifdef OPERATION_add_ui
> > > > #define FUNCTION          mpz_add_ui
> > > > #define FUNCTION2         mpz_add
> > > > #define VARIATION_CMP     >=3D
> > > > #define VARIATION_NEG
> > > > #define VARIATION_UNNEG   -
> > > > #endif
> > > >
> > > > #ifdef OPERATION_sub_ui
> > > > #define FUNCTION          mpz_sub_ui
> > > > #define FUNCTION2         mpz_sub
> > > > #define VARIATION_CMP     <
> > > > #define VARIATION_NEG     -
> > > > #define VARIATION_UNNEG
> > > > #endif
> > > >
> > > > #ifndef FUNCTION
> > > > Error, need OPERATION_add_ui or OPERATION_sub_ui
> > > > #endif
> > > >
> > > >
> > > > void
> > > > FUNCTION (mpz_ptr w, mpz_srcptr u, unsigned long int vval)
> > > > {
> > > >   mp_srcptr up;
> > > >   mp_ptr wp;
> > > >   mp_size_t usize, wsize;
> > > >   mp_size_t abs_usize;
> > > >
> > > > #if BITS_PER_ULONG > GMP_NUMB_BITS  /* avoid warnings about shift a=
mount */
> > > >   if (vval > GMP_NUMB_MAX)
> > > >     {
> > > >       mpz_t v;
> > > >       mp_limb_t vl[2];
> > > >       PTR(v) =3D vl;
> > > >       vl[0] =3D vval & GMP_NUMB_MASK;
> > > >       vl[1] =3D vval >> GMP_NUMB_BITS;
> > > >       SIZ(v) =3D 2;
> > > >       FUNCTION2 (w, u, v);
> > > >       return;
> > > >     }
> > > > #endif
> > > >
> > > >   usize =3D SIZ (u);
> > > >   if (usize =3D=3D 0)
> > > >     {
> > > >       MPZ_NEWALLOC (w, 1)[0] =3D vval;
> > > >       SIZ (w) =3D VARIATION_NEG (vval !=3D 0);
> > > >       return;
> > > >     }
> > > >
> > > >   abs_usize =3D ABS (usize);
> > > >
> > > >   /* If not space for W (and possible carry), increase space.  */
> > > >   wp =3D MPZ_REALLOC (w, abs_usize + 1);
> > > >
> > > >   /* These must be after realloc (U may be the same as W).  */
> > > >   up =3D PTR (u);
> > > >
> > > >   if (usize VARIATION_CMP 0)
> > > >     {
> > > >       mp_limb_t cy;
> > > >       cy =3D mpn_add_1 (wp, up, abs_usize, (mp_limb_t) vval);
> > > >       wp[abs_usize] =3D cy;
> > > >       wsize =3D VARIATION_NEG (abs_usize + cy);
> > > >     }
> > > >   else
> > > >     {
> > > >       /* The signs are different.  Need exact comparison to determi=
ne
> > > >          which operand to subtract from which.  */
> > > >       if (abs_usize =3D=3D 1 && up[0] < vval)
> > > >         {
> > > >           wp[0] =3D vval - up[0];
> > > >           wsize =3D VARIATION_NEG 1;
> > > >         }
> > > >       else
> > > >         {
> > > >           mpn_sub_1 (wp, up, abs_usize, (mp_limb_t) vval);
> > > >           /* Size can decrease with at most one limb.  */
> > > >           wsize =3D VARIATION_UNNEG (abs_usize - (wp[abs_usize - 1]=
 =3D=3D 0));
> > > >         }
> > > >     }
> > > >
> > > >   SIZ (w) =3D wsize;
> > > > }
> > > > --->*---
> > > >
> > > >
> > > >
> > > > On Thu, Jul 16, 2020 at 11:41:17AM +0300, Ard Biesheuvel wrote:
> > > > > On Thu, 16 Jul 2020 at 10:30, Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
> > > > > >
> > > > > > On Sun, Jul 12, 2020 at 06:39:54PM +0200, Stephan M=FCller wrot=
e:
> > > > > > >
> > > > > > > diff --git a/lib/mpi/mpi-sub-ui.c b/lib/mpi/mpi-sub-ui.c
> > > > > > > new file mode 100644
> > > > > > > index 000000000000..fa6b085bac36
> > > > > > > --- /dev/null
> > > > > > > +++ b/lib/mpi/mpi-sub-ui.c
> > > > > > > @@ -0,0 +1,60 @@
> > > > > > > +// SPDX-License-Identifier: GPL-2.0-or-later
> > > > > > > +/* mpi-sub-ui.c  -  MPI functions
> > > > > > > + *      Copyright 1991, 1993, 1994, 1996, 1999-2002, 2004, 2=
012, 2013, 2015
> > > > > > > + *      Free Software Foundation, Inc.
> > > > > > > + *
> > > > > > > + * This file is part of GnuPG.
> > > > > > > + *
> > > > > > > + * Note: This code is heavily based on the GNU MP Library.
> > > > > > > + *    Actually it's the same code with only minor changes in=
 the
> > > > > > > + *    way the data is stored; this is to support the abstrac=
tion
> > > > > > > + *    of an optional secure memory allocation which may be u=
sed
> > > > > > > + *    to avoid revealing of sensitive data due to paging etc.
> > > > > > > + *    The GNU MP Library itself is published under the LGPL;
> > > > > > > + *    however I decided to publish this code under the plain=
 GPL.
> > > > > > > + */
> > > > > >
> > > > > > Hmm, you said that this code is from GNU MP.  But this notice c=
learly
> > > > > > says that it's part of GnuPG and is under GPL.  Though it doesn=
't
> > > > > > clarify what version of GPL it is.  Can you please clarify this=
 with
> > > > > > the author?
> > > > > >
> > > > >
> > > > > GnuPG was relicensed under GPLv3 in ~2007, IIRC, so given the
> > > > > copyright years and the explicit statements that the file is part=
 of
> > > > > GnuPG and not under the original LGPL license, there is no way we=
 can
> > > > > take this code under the kernel's GPLv2 license.
> > > >
> > > > --
> > > > Regards,
> > > > Marcelo
> > > >
> >
> > --
> > Regards,
> > Marcelo
> >

--=20
Regards,
Marcelo


--oaa5r4ivkodb6p6e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEExJjLjAfVL0XbfEr56e82LoessAkFAl8QYvEACgkQ6e82Loes
sAnGPAv/YFPfAYHMzNU/2sA9QmnCGxqAuyFXfa5v6nj6o6XnOtYI9xXxczzZVC3O
jMB8A3tll9f0Jor1MY4iVAB811RZK/hBmEQ87oOXnWv7nGFsoQESs7JTRMijujOB
TDIRD8Am9ouF4p7G+rWNG4SMEG5eF6mQPBY8Rv0IO+s82ZRODVZIRnMWDVH0cXy0
V//c3Z61rp2ArzNtSHakj9sEuy1JW1v7NJo0BzNoKndC0YNU39JwipqYMVCAxrDR
J+myiWf334gJCEHWe62J7UZGBq/VhuU+zXtDeb8GSXd9bVCxDQ77sITBVZNH+Ozs
2mWvknK808tcVUNEf18wHUy6sH+hQQ6Z66G8q0jIzpHElLfbmZjPpX/qGf7Ea03q
FGAvHcEkNbVQLtGivFV7l2KZB4xXpLnM0bOhC/9XZuAhgmHWDAM30DsSoCQ1U4YW
wFAGgGHQF49cy5v6hnNLJVbQ0fQ73jPNw1vHEvUgHtmKZWL3xYOh7hIQ6tanLNzl
h2VDjWHj
=7zvI
-----END PGP SIGNATURE-----

--oaa5r4ivkodb6p6e--
