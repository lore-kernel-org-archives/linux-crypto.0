From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH/RFC 0/4] Partial decompression API (was: Re: [patch 1/3]
 crypto: Add a zlib crypto module)
Date: Mon, 24 Nov 2008 17:11:42 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0811241700100.9844@vixen.sonytel.be>
References: <20080829134158.108976037@vixen.sonytel.be>
 <20080829134418.874948211@vixen.sonytel.be> <20080830062315.GA18441@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:51123 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753014AbYKXQLy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Nov 2008 11:11:54 -0500
In-Reply-To: <20080830062315.GA18441@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, 30 Aug 2008, Herbert Xu wrote:
> On Fri, Aug 29, 2008 at 01:41:59PM +0000, Geert Uytterhoeven wrote:
> > From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> >=20
> > Add a (de)compression module for the "zlib" format using the crypto=
 API.
>=20
> I think we can safely conclude that our current compression
> interface sucks for what you're trying to achieve :)
>=20
> > While both the "zlib" and "deflate" crypto modules are implemented =
on top of
> > the zlib library, they differ in the following aspects:
> >   - The "deflate" crypto module (used by IPSec and UBIFS) does not =
support
> >     partial decompression, i.e. all compressed data has to be passe=
d at once.
> >     The "zlib" crypto module does support partial decompression;
> >     zlib_decompress() will return -EAGAIN if not all compressed dat=
a has been
> >     passed.
> >   - The deflate crypto module uses the raw deflate data format (zli=
b is
> >     initialized with a windowBits parameter of -DEFLATE_DEF_WINBITS=
 =3D -11),
> >     while e.g. squashfs and axfs use the zlib data format, with the=
 default
> >     windowBits parameter DEF_WBITS =3D 15.
> >     Both parameters are incompatible with each other due to the dif=
ferent data
> >     formats, as indicated by the sign of the windowbits parameter.
> >     The absolute value of this parameter is the base two logarithm =
of the
> >     maximum window size, and larger values are backwards compatible=
 with
> >     smaller values (as far as decompression is concerned).
>=20
> Therefore I suggest that we change the interface rather than
> mutilate the implementations.
>=20
> So here are a few things we should add:
>=20
> 1) Separate alloc functions for comp/decomp to avoid the memory
>    wastage you've identified.
>=20
> 2) Provide parameters to these alloc functions through an opaque
>    pointer.  The format of the paramters will be determined by the
>    name of the algorithm, i.e., if you want to change the parameters
>    then you should change the name as well (e.g., deflate =3D> deflat=
e2).
>=20
>    This removes the need to dupliate the implementation just because
>    you want 15 instead of -11.
>=20
> 3) Provide init/update/final (one set each for comp and decomp)
>    functions similar to crypto_hash, in addition to the current
>    comp/decomp functions.

Thanks for your suggestions!

I started tackling #3 (init/update/final), as that looks like the most
complicated one.

As a proof-of-concept, I'm sending the following 4 patches, which gives=
 a
working version of SquashFS using the CRYPTO API for decompression:
  - [1/4] crypto: Add partial decompression support to the CRYPTO API.
  - [2/4] crypto: Add a "zlib" crypto module
  - [3/4] crypto: Add a test for the "zlib" crypto module
  - [4/4] squashfs: Make SquashFS 4 use the new "zlib" crypto module

As pointed out in patch [1/4], some underlying (de)compression implemen=
tations
do not support partial (de)compression.  This is the case for e.g. LZO,=
 which
is already supported by a crypto module. While one-shot (de)compression=
 can
easily be implemented on top of a partial (de)compression API, the inve=
rse is
not true.
Hence there should be a way to ask for a "one-shot" vs. "partial" decom=
pression
module at crypto_alloc_comp() time.
Do you have any suggestions how to handle this?
Perhaps by using "oneshot(%s)" and "partial(%s)", cfr. what is done in =
other
parts of the CRYPTO API where orthogonal features are combined?

=46or #1 (Separate alloc functions for comp/decomp), I'm wondering if a=
 similar
scheme be used? "comp(%s)", "decomp(%s)", "both(%s)" (any better name?)=
?
Or crypto_alloc_comp_only(), crypto_alloc_decomp_only(), and
crypto_alloc_comp()?

Or would it be better to use the CRYPTO_ALG_TYPE_* flags in
crypto_alloc_comp()? I'm still a bit puzzled how exactly everything fit=
s
together in the different layers of the CRYPTO API.

Thanks for your comments!

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village =C2=B7 Da Vincilaan 7-D1 =C2=B7 B-1935 Zaventem =C2=
=B7 Belgium

Phone:    +32 (0)2 700 8453
=46ax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 =C2=B7 RPR Brussels
=46ortis =C2=B7 BIC GEBABEBB =C2=B7 IBAN BE41293037680010
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
