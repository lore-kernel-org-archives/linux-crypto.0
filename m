Return-Path: <SRS0=7zOR=A3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36C02C433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 14:57:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12496207BC
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 14:57:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728054AbgGPO5E (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jul 2020 10:57:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58662 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbgGPO5E (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jul 2020 10:57:04 -0400
Received: from mail-qt1-f198.google.com ([209.85.160.198])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <marcelo.cerri@canonical.com>)
        id 1jw5Jh-0000TM-B4
        for linux-crypto@vger.kernel.org; Thu, 16 Jul 2020 14:56:57 +0000
Received: by mail-qt1-f198.google.com with SMTP id 71so3984957qte.5
        for <linux-crypto@vger.kernel.org>; Thu, 16 Jul 2020 07:56:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fBxp8USRr+6ndu7qzHCImjn5nbfExJgYoCT3uCaH4CI=;
        b=McATdKCNaXXT7lmn1s+g9qy6MnJUXN+BtjtezTTbaXZfz7FGG+qsNBHCFK8ttj1kCH
         HLW3fPinm/Xaf4oV5Y9r7KH+T0VwFenlR+gMTNAf52ZVoNxAbE8WuZ65Tn4lAjnpHF0b
         BL7wM8NhQcBnAwYuS0ATYxz9slvD+74LP5nhAMXzQ5yBU0V0d5MEtTUefUKaUT38iqNg
         nnAkOnRbQF8ZWNbYNTJ2+qVKcvDqkfOdAIV2G+DhIn3uPb6kwKa0ESaEffSWo/iQPagK
         8efvGhDfNs2l9t3KWtNR3gxFtmaVsFojqLhzECh4eBSoficTG9v1WJ5DtnkiXPJ2a0bJ
         WQsQ==
X-Gm-Message-State: AOAM531Ya6pJ4B0Kyhv4RjIHuATN5rG+CIKYME3YAHCobO+uS1M3NtpE
        sDRPWRkoA6omOH8MA7AjUxvhqc/iVae4ECMqbcdGcaz7arpAV8zHCqPgZmqmkdJw6JMTjJ9bpZY
        bZ4SshUuzsiaxfqYi4xshsu6egNasnSDg+AaeTgm7
X-Received: by 2002:a05:620a:22cc:: with SMTP id o12mr4302804qki.230.1594911415772;
        Thu, 16 Jul 2020 07:56:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzXlz/tpdBU+AiLJQW5HzTuPHPxSfD00w6hhnUqgxSrCjt63fnGJG9oFT1GctHdrj7oDXpU3w==
X-Received: by 2002:a05:620a:22cc:: with SMTP id o12mr4302750qki.230.1594911415168;
        Thu, 16 Jul 2020 07:56:55 -0700 (PDT)
Received: from valinor ([2804:14c:4e6:18:554f:9c7b:d140:fe0d])
        by smtp.gmail.com with ESMTPSA id 1sm7133706qki.122.2020.07.16.07.56.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 07:56:53 -0700 (PDT)
Date:   Thu, 16 Jul 2020 11:56:49 -0300
From:   Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan =?utf-8?Q?M=C3=BCller?= <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>, nhorman@redhat.com,
        simo@redhat.com
Subject: Re: [PATCH v2 2/5] lib/mpi: Add mpi_sub_ui()
Message-ID: <20200716145649.zjhccwgty5i5pfpp@valinor>
References: <5722559.lOV4Wx5bFT@positron.chronox.de>
 <4650810.GXAFRqVoOG@positron.chronox.de>
 <20200716073032.GA28173@gondor.apana.org.au>
 <CAMj1kXHNM5pwjSuVgxP2SA5juTnVxpj0ULUkjNWuoHqVTjuE8Q@mail.gmail.com>
 <20200716125002.oxr7yyeehz74mgq4@valinor>
 <CAMj1kXHBmgaQKDQoVd-wN0JpKunE53QRg6uQ=3fRZmpNw=drYg@mail.gmail.com>
 <20200716134128.7br6npd2nsck33qm@valinor>
 <CAMj1kXGJMBLxPX9RuHai9JK_5wQSufEzN4arHLVE_pSnsbGzuQ@mail.gmail.com>
 <20200716142345.bpnenw5j6yhrhjq5@valinor>
 <CAMj1kXHD4_nXydFnCwsjV_fyvmiD=L8QPBVudmnQfAJYfhu82g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="a5ymaevc5jz34abo"
Content-Disposition: inline
In-Reply-To: <CAMj1kXHD4_nXydFnCwsjV_fyvmiD=L8QPBVudmnQfAJYfhu82g@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--a5ymaevc5jz34abo
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 16, 2020 at 05:37:32PM +0300, Ard Biesheuvel wrote:
> On Thu, 16 Jul 2020 at 17:23, Marcelo Henrique Cerri
> <marcelo.cerri@canonical.com> wrote:
> >
> > On Thu, Jul 16, 2020 at 04:53:24PM +0300, Ard Biesheuvel wrote:
> > > On Thu, 16 Jul 2020 at 16:41, Marcelo Henrique Cerri
> > > <marcelo.cerri@canonical.com> wrote:
> > > >
> > > > On Thu, Jul 16, 2020 at 04:09:39PM +0300, Ard Biesheuvel wrote:
> > > > > On Thu, 16 Jul 2020 at 15:50, Marcelo Henrique Cerri
> > > > > <marcelo.cerri@canonical.com> wrote:
> > > > > >
> > > > > > No. The code is really based on Gnu MP. I used the header from
> > > > > > lib/mpi/mpi-pow.c as reference and that's source of the mention=
 to
> > > > > > GnuPG that went unnoticed by me.
> > > > > >
> > > > >
> > > > > So where did the file lib/mpi/mpi-sub-ui.c come from? From GnuPG =
or
> > > > > from GnuMP? Did you modify the license statement? Because as prop=
osed,
> > > > > this patch clearly is not acceptable from GPL compliance  point of
> > > > > view.
> > > >
> > > > Sorry for the confusion. The code is from Gnu MP (not GnuPG).
> > > >
> > > > Gnu MP is distributed under either LGPLv3 or later or GPLv2 or later
> > > > (check their license statement on the aors_ui.h file below).
> > > >
> > > > For mpi-sub-ui.h I added a SPDX identifier for GPLv2 or later and I
> > > > kept the FSF copyright line.
> > > >
> > > > I also used the header from mpi-powm.c as a reference basically to
> > > > inform the code was changed from its original form.
> > > >
> > > > Here lies my mistake, I didn't notice that part was referring to Gn=
uPG
> > > > instead of Gnu MP.
> > > >
> > > > So mpi-sub-ui.h header was actually intended to be:
> > > >
> > > >     // SPDX-License-Identifier: GPL-2.0-or-later
> > > >     /* mpi-sub-ui.c  -  MPI functions
> > > >      *      Copyright 1991, 1993, 1994, 1996, 1999-2002, 2004, 2012=
, 2013, 2015
> > > >      *      Free Software Foundation, Inc.
> > > >      *
> > > >      * This file is part of Gnu MP.
> > > >      *
> > > >      * Note: This code is heavily based on the GNU MP Library.
> > > >      *      Actually it's the same code with only minor changes in =
the
> > > >      *      way the data is stored; this is to support the abstract=
ion
> > > >      *      of an optional secure memory allocation which may be us=
ed
> > > >      *      to avoid revealing of sensitive data due to paging etc.
> > > >      *      The GNU MP Library itself is published under the LGPL;
> > > >      *      however I decided to publish this code under the plain =
GPL.
> > > >      */
> > > >
> > > > Or maybe instead of "This file is part of Gnu MP.", "This file is
> > > > based on Gnu MP" might be more appropriate.
> > > >
> > > > Do you have any license concerns considering this updated header?
> > > >
> > >
> > > Yes. How can this code be both part of GnuMP *and* be heavily based on
> > > it, but with changes?
> > >

The final mpi-sub-ui.c is not part of Gnu MP, but heavily based on it
sounds very accurate to me.

>
> You haven't answered this question yet. I suppose you just slapped a
> different license text on this file, one that already existed in
> lib/mpi?

Correct. The copyright line I used matches the original copyright from
Gnu MP.

The "This file is part..." line and the Note is the same from
mpi/lib/mpi-powm.c.

However I'm proposing the removal of that part in favor of the new
header I listed below based on Gnu MP header.

>
> > > Please avoid making changes to the original header, just add the SPDX
> > > header in front, and add a clear justification in the commit log where
> > > the file came from (preferably including git url and commit ID), and
> > > what you based your assertion on that its license is compatible with
> > > GPLv2.
> >
> > The commit message is stating the origin, but I can add a reference to
> > the mercurial repo with its corresponding id.
> >
>=20
> Yes, please.
>=20
> > >
> > > Ideally, you would import the file *exactly* as it appears in the
> > > upstream in one patch (with the above justification), and apply any
> > > necessary changes in a subsequent patch, so it's  crystal clear that
> > > we are complying with the original license.
> >
> > I'm not sure that's the ideal approach for this case. The logic is the
> > same but since naming convention, macros, data types and etc are
> > pretty different everything was basically re-written to fit the
> > kernel. Adding the original file and then massively changing will just
> > add unnecessary noise.
> >
>=20
> Do any of these modifications resemble the changes made to the GnuPG
> versions of these routines?

I haven't looked at the GnuPG code at all. Neither while I was
preparing this patch, neither after or before. So I can affirm this
patch has no influence of GnuPG code at all.

But if you want to be sure I can check that. Please let me know.

As I said, the GnuPG reference came from me trying to re-use the
header from kernel's lib/mpi/mpi-powm.c file.

>=20
> > If you agree I will update the commit message with more details about
> > the original source and then just update the comment header in
> > mpi-sub-ui.c following closely the original header with minor
> > adjustments to explain its origin and to fix some checkpatch warnings.
> >
>=20
> That is fine, provided that none of our modifications were taken from
> the GnuPG version of this file without giving credit.

I can assure I haven't used any code from GnuPG at all.

>=20
>=20
> > Something like that:
> >
> > // SPDX-License-Identifier: GPL-2.0-or-later
> > /* mpi-sub-ui.c - Subtract an unsigned integer from an MPI.
> >  *
> >  * Copyright 1991, 1993, 1994, 1996, 1999-2002, 2004, 2012, 2013, 2015
> >  * Free Software Foundation, Inc.
> >  *
> >  * This file was based on the GNU MP Library source file:
> >  * https://gmplib.org/repo/gmp-6.2/file/tip/mpz/aors_ui.h
> >  *
> >  * The GNU MP Library is free software; you can redistribute it and/or =
modify
> >  * it under the terms of either:
> >  *
> >  *   * the GNU Lesser General Public License as published by the Free
> >  *     Software Foundation; either version 3 of the License, or (at your
> >  *     option) any later version.
> >  *
> >  * or
> >  *
> >  *   * the GNU General Public License as published by the Free Software
> >  *     Foundation; either version 2 of the License, or (at your option)=
 any
> >  *     later version.
> >  *
> >  * or both in parallel, as here.
> >  *
> >  * The GNU MP Library is distributed in the hope that it will be useful=
, but
> >  * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTA=
BILITY
> >  * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public Lic=
ense
> >  * for more details.
> >  *
> >  * You should have received copies of the GNU General Public License an=
d the
> >  * GNU Lesser General Public License along with the GNU MP Library.  If=
 not,
> >  * see https://www.gnu.org/licenses/.
> >  */
> >
> > >
> > >
> > >
> > > >
> > > > >
> > > > >
> > > > >
> > > > > > You can find the original Gnu MP source that I used as referenc=
e in
> > > > > > the file gmp-6.2.0/mpz/aors_ui.h from:
> > > > > >
> > > > > > https://gmplib.org/download/gmp/gmp-6.2.0.tar.lz
> > > > > >
> > > > > > I'm pasting the contents of gmp-6.2.0/mpz/aors_ui.h below for
> > > > > > reference. Do you think we should use or adapt the original hea=
der
> > > > > > instead?
> > > > > >
> > > > > > That said, assuming the patch set submitted by Tianjia is updat=
ed to
> > > > > > ensure that mpi_sub_ui() and other functions are returning allo=
cation
> > > > > > errors, we could drop this patch in favor of that patch set tha=
t is
> > > > > > more extensive and also provides an implementation to mpi_sub_u=
i().
> > > > > >
> > > > > >
> > > > > > --->8---
> > > > > > /* mpz_add_ui, mpz_sub_ui -- Add or subtract an mpz_t and an un=
signed
> > > > > >    one-word integer.
> > > > > >
> > > > > > Copyright 1991, 1993, 1994, 1996, 1999-2002, 2004, 2012, 2013, =
2015
> > > > > > Free Software Foundation, Inc.
> > > > > >
> > > >
> > > >
> > > > Gnu MP license -.
> > > >                 V
> > > >
> > > >
> > > > > > This file is part of the GNU MP Library.
> > > > > >
> > > > > > The GNU MP Library is free software; you can redistribute it an=
d/or modify
> > > > > > it under the terms of either:
> > > > > >
> > > > > >   * the GNU Lesser General Public License as published by the F=
ree
> > > > > >     Software Foundation; either version 3 of the License, or (a=
t your
> > > > > >     option) any later version.
> > > > > >
> > > > > > or
> > > > > >
> > > > > >   * the GNU General Public License as published by the Free Sof=
tware
> > > > > >     Foundation; either version 2 of the License, or (at your op=
tion) any
> > > > > >     later version.
> > > > > >
> > > > > > or both in parallel, as here.
> > > > > >
> > > > > > The GNU MP Library is distributed in the hope that it will be u=
seful, but
> > > > > > WITHOUT ANY WARRANTY; without even the implied warranty of MERC=
HANTABILITY
> > > > > > or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Publi=
c License
> > > > > > for more details.
> > > > > >
> > > > > > You should have received copies of the GNU General Public Licen=
se and the
> > > > > > GNU Lesser General Public License along with the GNU MP Library=
=2E  If not,
> > > > > > see https://www.gnu.org/licenses/.  */
> > > > > >
> > > > > > #include "gmp-impl.h"
> > > > > >
> > > > > >
> > > > > > #ifdef OPERATION_add_ui
> > > > > > #define FUNCTION          mpz_add_ui
> > > > > > #define FUNCTION2         mpz_add
> > > > > > #define VARIATION_CMP     >=3D
> > > > > > #define VARIATION_NEG
> > > > > > #define VARIATION_UNNEG   -
> > > > > > #endif
> > > > > >
> > > > > > #ifdef OPERATION_sub_ui
> > > > > > #define FUNCTION          mpz_sub_ui
> > > > > > #define FUNCTION2         mpz_sub
> > > > > > #define VARIATION_CMP     <
> > > > > > #define VARIATION_NEG     -
> > > > > > #define VARIATION_UNNEG
> > > > > > #endif
> > > > > >
> > > > > > #ifndef FUNCTION
> > > > > > Error, need OPERATION_add_ui or OPERATION_sub_ui
> > > > > > #endif
> > > > > >
> > > > > >
> > > > > > void
> > > > > > FUNCTION (mpz_ptr w, mpz_srcptr u, unsigned long int vval)
> > > > > > {
> > > > > >   mp_srcptr up;
> > > > > >   mp_ptr wp;
> > > > > >   mp_size_t usize, wsize;
> > > > > >   mp_size_t abs_usize;
> > > > > >
> > > > > > #if BITS_PER_ULONG > GMP_NUMB_BITS  /* avoid warnings about shi=
ft amount */
> > > > > >   if (vval > GMP_NUMB_MAX)
> > > > > >     {
> > > > > >       mpz_t v;
> > > > > >       mp_limb_t vl[2];
> > > > > >       PTR(v) =3D vl;
> > > > > >       vl[0] =3D vval & GMP_NUMB_MASK;
> > > > > >       vl[1] =3D vval >> GMP_NUMB_BITS;
> > > > > >       SIZ(v) =3D 2;
> > > > > >       FUNCTION2 (w, u, v);
> > > > > >       return;
> > > > > >     }
> > > > > > #endif
> > > > > >
> > > > > >   usize =3D SIZ (u);
> > > > > >   if (usize =3D=3D 0)
> > > > > >     {
> > > > > >       MPZ_NEWALLOC (w, 1)[0] =3D vval;
> > > > > >       SIZ (w) =3D VARIATION_NEG (vval !=3D 0);
> > > > > >       return;
> > > > > >     }
> > > > > >
> > > > > >   abs_usize =3D ABS (usize);
> > > > > >
> > > > > >   /* If not space for W (and possible carry), increase space.  =
*/
> > > > > >   wp =3D MPZ_REALLOC (w, abs_usize + 1);
> > > > > >
> > > > > >   /* These must be after realloc (U may be the same as W).  */
> > > > > >   up =3D PTR (u);
> > > > > >
> > > > > >   if (usize VARIATION_CMP 0)
> > > > > >     {
> > > > > >       mp_limb_t cy;
> > > > > >       cy =3D mpn_add_1 (wp, up, abs_usize, (mp_limb_t) vval);
> > > > > >       wp[abs_usize] =3D cy;
> > > > > >       wsize =3D VARIATION_NEG (abs_usize + cy);
> > > > > >     }
> > > > > >   else
> > > > > >     {
> > > > > >       /* The signs are different.  Need exact comparison to det=
ermine
> > > > > >          which operand to subtract from which.  */
> > > > > >       if (abs_usize =3D=3D 1 && up[0] < vval)
> > > > > >         {
> > > > > >           wp[0] =3D vval - up[0];
> > > > > >           wsize =3D VARIATION_NEG 1;
> > > > > >         }
> > > > > >       else
> > > > > >         {
> > > > > >           mpn_sub_1 (wp, up, abs_usize, (mp_limb_t) vval);
> > > > > >           /* Size can decrease with at most one limb.  */
> > > > > >           wsize =3D VARIATION_UNNEG (abs_usize - (wp[abs_usize =
- 1] =3D=3D 0));
> > > > > >         }
> > > > > >     }
> > > > > >
> > > > > >   SIZ (w) =3D wsize;
> > > > > > }
> > > > > > --->*---
> > > > > >
> > > > > >
> > > > > >
> > > > > > On Thu, Jul 16, 2020 at 11:41:17AM +0300, Ard Biesheuvel wrote:
> > > > > > > On Thu, 16 Jul 2020 at 10:30, Herbert Xu <herbert@gondor.apan=
a.org.au> wrote:
> > > > > > > >
> > > > > > > > On Sun, Jul 12, 2020 at 06:39:54PM +0200, Stephan M=FCller =
wrote:
> > > > > > > > >
> > > > > > > > > diff --git a/lib/mpi/mpi-sub-ui.c b/lib/mpi/mpi-sub-ui.c
> > > > > > > > > new file mode 100644
> > > > > > > > > index 000000000000..fa6b085bac36
> > > > > > > > > --- /dev/null
> > > > > > > > > +++ b/lib/mpi/mpi-sub-ui.c
> > > > > > > > > @@ -0,0 +1,60 @@
> > > > > > > > > +// SPDX-License-Identifier: GPL-2.0-or-later
> > > > > > > > > +/* mpi-sub-ui.c  -  MPI functions
> > > > > > > > > + *      Copyright 1991, 1993, 1994, 1996, 1999-2002, 200=
4, 2012, 2013, 2015
> > > > > > > > > + *      Free Software Foundation, Inc.
> > > > > > > > > + *
> > > > > > > > > + * This file is part of GnuPG.
> > > > > > > > > + *
> > > > > > > > > + * Note: This code is heavily based on the GNU MP Librar=
y.
> > > > > > > > > + *    Actually it's the same code with only minor change=
s in the
> > > > > > > > > + *    way the data is stored; this is to support the abs=
traction
> > > > > > > > > + *    of an optional secure memory allocation which may =
be used
> > > > > > > > > + *    to avoid revealing of sensitive data due to paging=
 etc.
> > > > > > > > > + *    The GNU MP Library itself is published under the L=
GPL;
> > > > > > > > > + *    however I decided to publish this code under the p=
lain GPL.
> > > > > > > > > + */
> > > > > > > >
> > > > > > > > Hmm, you said that this code is from GNU MP.  But this noti=
ce clearly
> > > > > > > > says that it's part of GnuPG and is under GPL.  Though it d=
oesn't
> > > > > > > > clarify what version of GPL it is.  Can you please clarify =
this with
> > > > > > > > the author?
> > > > > > > >
> > > > > > >
> > > > > > > GnuPG was relicensed under GPLv3 in ~2007, IIRC, so given the
> > > > > > > copyright years and the explicit statements that the file is =
part of
> > > > > > > GnuPG and not under the original LGPL license, there is no wa=
y we can
> > > > > > > take this code under the kernel's GPLv2 license.
> > > > > >
> > > > > > --
> > > > > > Regards,
> > > > > > Marcelo
> > > > > >
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


--a5ymaevc5jz34abo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEExJjLjAfVL0XbfEr56e82LoessAkFAl8QarAACgkQ6e82Loes
sAliFgv9Fvym9Ikw/PZTErN4FOFblTL9qOqdDlYUR506my1it0BnrqCDmqh/zHhd
wC92VfesharEam/XTAWRVtbFI6tSkXH/F93Q3CiB/zf5iYVSxgiWy9T103J+emzp
XqWWoLuLg8YIjq+CoJJtD6SVG3yzMhIRcmTqG6q/XegBzJd1DkRN3orAbxnjcPdO
/8LLFd2mfr8m8PsxcpusSBD4MPr3lHgjn7M9wP9S6pbaRce1433hWs3M8wx0bXrM
rERkqbPpnaTHOgBf/ueASaWSs5FT9SBQ9MhI4bGpoImi9xxOIcJloOLUEnfz+Mqw
RKJV5C4hk6JBaRK5u0oL7crtozXKGZidWwaAZzP6W1T1eVvSXP4x1d1UtEY5OKPL
5zGjmkKve5/TkZKvqoC+72/jv6vJOjw16alKnfDmmNir2+UcFjTYiliJ15B5Fec8
ctxu578doPGNh/IT2mK9Hlpfp50cKBnCnenMkO+b9Wq4L+ZPtOcEjdN+532I1pEc
7oU5XJIq
=7Nwe
-----END PGP SIGNATURE-----

--a5ymaevc5jz34abo--
