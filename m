Return-Path: <SRS0=7zOR=A3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53B7BC433E3
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 12:50:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 388362074B
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 12:50:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbgGPMuN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jul 2020 08:50:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55129 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728237AbgGPMuN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jul 2020 08:50:13 -0400
Received: from mail-qt1-f199.google.com ([209.85.160.199])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <marcelo.cerri@canonical.com>)
        id 1jw3L0-0004lz-0X
        for linux-crypto@vger.kernel.org; Thu, 16 Jul 2020 12:50:10 +0000
Received: by mail-qt1-f199.google.com with SMTP id r25so3719875qtj.11
        for <linux-crypto@vger.kernel.org>; Thu, 16 Jul 2020 05:50:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i4MkuBqZR1Bl9xlwkU7PqreHLeUcHU3bqZCFq1GJ/qU=;
        b=PfsxViZp2KkoLHVicHIlMYKT9W9Xjl9MNkNVj/KfzC4POJuiSRGs3FeJNdavIrCEck
         cAPBi4508nZ4pXMq66nDjCeNC1lZyFIC+LdFEkTRmCWNeWb0TTTJt6fsryEe581WTBnW
         haFAoUVsGLBgoxWBMBt8+AoYo5Zspj+nN1WJ3X1XseYHBDpURE9lSBLA8lcRY20BkaqH
         O1S3TQz3CB5AQG81pOdLenz4NzFh6FNMkLS2sLo0MxPMk8gfgWAPTI0BN8qWPq+1UsqZ
         V532Aoj9MdtjsXm85kJlbTxYxQfwPuNjotYf4DEz1PVTViinvQUY25mrFOGV8Z43hIWj
         bGMw==
X-Gm-Message-State: AOAM531wsClhJKITAZE1Npm4555uIGIvvc6zA/HECLMJ8tq5o2zBm2ee
        lMZkrSkT68FwYgaPuJgzYAveTDc8ZLgzNfuwE2zrh2JRouDQSivKrSpxaSViYCWk2nIotIZ6N8U
        IkLjHMtK/XtN2Xm+SWTjV4jAhTBRc6QT7qgnRDiyQ
X-Received: by 2002:a05:620a:579:: with SMTP id p25mr3839129qkp.176.1594903808830;
        Thu, 16 Jul 2020 05:50:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz+pNT/wkU58VpNN8iGIPl7qiwBET3fbCGp72SbJZOHE5/FdG2Y3zUtMn44JP1opH+kzYZ4Mw==
X-Received: by 2002:a05:620a:579:: with SMTP id p25mr3839095qkp.176.1594903808388;
        Thu, 16 Jul 2020 05:50:08 -0700 (PDT)
Received: from valinor ([2804:14c:4e6:18:554f:9c7b:d140:fe0d])
        by smtp.gmail.com with ESMTPSA id x3sm7193873qkd.62.2020.07.16.05.50.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 05:50:06 -0700 (PDT)
Date:   Thu, 16 Jul 2020 09:50:02 -0300
From:   Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan =?utf-8?Q?M=C3=BCller?= <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>, nhorman@redhat.com,
        simo@redhat.com
Subject: Re: [PATCH v2 2/5] lib/mpi: Add mpi_sub_ui()
Message-ID: <20200716125002.oxr7yyeehz74mgq4@valinor>
References: <2543601.mvXUDI8C0e@positron.chronox.de>
 <5722559.lOV4Wx5bFT@positron.chronox.de>
 <4650810.GXAFRqVoOG@positron.chronox.de>
 <20200716073032.GA28173@gondor.apana.org.au>
 <CAMj1kXHNM5pwjSuVgxP2SA5juTnVxpj0ULUkjNWuoHqVTjuE8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="e3eyku65czogjifr"
Content-Disposition: inline
In-Reply-To: <CAMj1kXHNM5pwjSuVgxP2SA5juTnVxpj0ULUkjNWuoHqVTjuE8Q@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--e3eyku65czogjifr
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

No. The code is really based on Gnu MP. I used the header from
lib/mpi/mpi-pow.c as reference and that's source of the mention to
GnuPG that went unnoticed by me.

You can find the original Gnu MP source that I used as reference in
the file gmp-6.2.0/mpz/aors_ui.h from:

https://gmplib.org/download/gmp/gmp-6.2.0.tar.lz

I'm pasting the contents of gmp-6.2.0/mpz/aors_ui.h below for
reference. Do you think we should use or adapt the original header
instead?

That said, assuming the patch set submitted by Tianjia is updated to
ensure that mpi_sub_ui() and other functions are returning allocation
errors, we could drop this patch in favor of that patch set that is
more extensive and also provides an implementation to mpi_sub_ui().


--->8---
/* mpz_add_ui, mpz_sub_ui -- Add or subtract an mpz_t and an unsigned
   one-word integer.

Copyright 1991, 1993, 1994, 1996, 1999-2002, 2004, 2012, 2013, 2015
Free Software Foundation, Inc.

This file is part of the GNU MP Library.

The GNU MP Library is free software; you can redistribute it and/or modify
it under the terms of either:

  * the GNU Lesser General Public License as published by the Free
    Software Foundation; either version 3 of the License, or (at your
    option) any later version.

or

  * the GNU General Public License as published by the Free Software
    Foundation; either version 2 of the License, or (at your option) any
    later version.

or both in parallel, as here.

The GNU MP Library is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
for more details.

You should have received copies of the GNU General Public License and the
GNU Lesser General Public License along with the GNU MP Library.  If not,
see https://www.gnu.org/licenses/.  */

#include "gmp-impl.h"


#ifdef OPERATION_add_ui
#define FUNCTION          mpz_add_ui
#define FUNCTION2         mpz_add
#define VARIATION_CMP     >=3D
#define VARIATION_NEG
#define VARIATION_UNNEG   -
#endif

#ifdef OPERATION_sub_ui
#define FUNCTION          mpz_sub_ui
#define FUNCTION2         mpz_sub
#define VARIATION_CMP     <
#define VARIATION_NEG     -
#define VARIATION_UNNEG
#endif

#ifndef FUNCTION
Error, need OPERATION_add_ui or OPERATION_sub_ui
#endif


void
FUNCTION (mpz_ptr w, mpz_srcptr u, unsigned long int vval)
{
  mp_srcptr up;
  mp_ptr wp;
  mp_size_t usize, wsize;
  mp_size_t abs_usize;

#if BITS_PER_ULONG > GMP_NUMB_BITS  /* avoid warnings about shift amount */
  if (vval > GMP_NUMB_MAX)
    {
      mpz_t v;
      mp_limb_t vl[2];
      PTR(v) =3D vl;
      vl[0] =3D vval & GMP_NUMB_MASK;
      vl[1] =3D vval >> GMP_NUMB_BITS;
      SIZ(v) =3D 2;
      FUNCTION2 (w, u, v);
      return;
    }
#endif

  usize =3D SIZ (u);
  if (usize =3D=3D 0)
    {
      MPZ_NEWALLOC (w, 1)[0] =3D vval;
      SIZ (w) =3D VARIATION_NEG (vval !=3D 0);
      return;
    }

  abs_usize =3D ABS (usize);

  /* If not space for W (and possible carry), increase space.  */
  wp =3D MPZ_REALLOC (w, abs_usize + 1);

  /* These must be after realloc (U may be the same as W).  */
  up =3D PTR (u);

  if (usize VARIATION_CMP 0)
    {
      mp_limb_t cy;
      cy =3D mpn_add_1 (wp, up, abs_usize, (mp_limb_t) vval);
      wp[abs_usize] =3D cy;
      wsize =3D VARIATION_NEG (abs_usize + cy);
    }
  else
    {
      /* The signs are different.  Need exact comparison to determine
	 which operand to subtract from which.  */
      if (abs_usize =3D=3D 1 && up[0] < vval)
	{
	  wp[0] =3D vval - up[0];
	  wsize =3D VARIATION_NEG 1;
	}
      else
	{
	  mpn_sub_1 (wp, up, abs_usize, (mp_limb_t) vval);
	  /* Size can decrease with at most one limb.  */
	  wsize =3D VARIATION_UNNEG (abs_usize - (wp[abs_usize - 1] =3D=3D 0));
	}
    }

  SIZ (w) =3D wsize;
}
--->*---



On Thu, Jul 16, 2020 at 11:41:17AM +0300, Ard Biesheuvel wrote:
> On Thu, 16 Jul 2020 at 10:30, Herbert Xu <herbert@gondor.apana.org.au> wr=
ote:
> >
> > On Sun, Jul 12, 2020 at 06:39:54PM +0200, Stephan M=FCller wrote:
> > >
> > > diff --git a/lib/mpi/mpi-sub-ui.c b/lib/mpi/mpi-sub-ui.c
> > > new file mode 100644
> > > index 000000000000..fa6b085bac36
> > > --- /dev/null
> > > +++ b/lib/mpi/mpi-sub-ui.c
> > > @@ -0,0 +1,60 @@
> > > +// SPDX-License-Identifier: GPL-2.0-or-later
> > > +/* mpi-sub-ui.c  -  MPI functions
> > > + *      Copyright 1991, 1993, 1994, 1996, 1999-2002, 2004, 2012, 201=
3, 2015
> > > + *      Free Software Foundation, Inc.
> > > + *
> > > + * This file is part of GnuPG.
> > > + *
> > > + * Note: This code is heavily based on the GNU MP Library.
> > > + *    Actually it's the same code with only minor changes in the
> > > + *    way the data is stored; this is to support the abstraction
> > > + *    of an optional secure memory allocation which may be used
> > > + *    to avoid revealing of sensitive data due to paging etc.
> > > + *    The GNU MP Library itself is published under the LGPL;
> > > + *    however I decided to publish this code under the plain GPL.
> > > + */
> >
> > Hmm, you said that this code is from GNU MP.  But this notice clearly
> > says that it's part of GnuPG and is under GPL.  Though it doesn't
> > clarify what version of GPL it is.  Can you please clarify this with
> > the author?
> >
>=20
> GnuPG was relicensed under GPLv3 in ~2007, IIRC, so given the
> copyright years and the explicit statements that the file is part of
> GnuPG and not under the original LGPL license, there is no way we can
> take this code under the kernel's GPLv2 license.

--=20
Regards,
Marcelo


--e3eyku65czogjifr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEExJjLjAfVL0XbfEr56e82LoessAkFAl8QTPoACgkQ6e82Loes
sAnZDAwAsQ1WLrX2I5JbtdACsPs+Lemwbu49eRS5b/QsIVSJ+twfUbC+ddgIy/8r
g9YnwiFvK1M7RJby28MPBNC85cfq6n4k1vacwoOpkf7kyQtaGTzWclh8IOQMxIit
WFzBRLMVdMzAv91G7rf9J3OlpTqeL7qfEcMR+ZaoiC93cGBxmzVfa1BVrRnxs8qo
halgZJcBWhkiVUODdQIuOID5pkiptkV25KNX4obWgSAOvt/7KSPBtttUeSqbwK2k
bb/eBlqbcYhYEdjcMAJjnybBfZGNpoFxerG2fNrXHb035s1ThbvBrQe5e8+Yq6OG
ORcyEaji7r4sBKXIFE8AKnHRhsfWznvLjiGno0egHErpS+U2wIJ3T+YujlV+nQpH
P/Ig0iNOGj7KatgYCUxdawga1PQeX/M/H41lbvcECEnIrM7QyUdXmiKTbLL01CFf
yBpwUDB05tQ/G9NZYVZ4QRhfcGrfRKjSzfD6pIpOrQ+djBPW74C4V6P2A83v+s6q
l/pDIV3M
=g2Zx
-----END PGP SIGNATURE-----

--e3eyku65czogjifr--
