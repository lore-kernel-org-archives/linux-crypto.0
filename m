From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH/RFC 0/4] Partial decompression API (was: Re: [patch 1/3]
 crypto: Add a zlib crypto module)
Date: Tue, 25 Nov 2008 18:26:04 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0811251819180.10770@vixen.sonytel.be>
References: <20080829134158.108976037@vixen.sonytel.be>
 <20080829134418.874948211@vixen.sonytel.be> <20080830062315.GA18441@gondor.apana.org.au>
 <Pine.LNX.4.64.0811241700100.9844@vixen.sonytel.be> <20081125150000.GA28748@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:41367 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753897AbYKYR0R (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Nov 2008 12:26:17 -0500
In-Reply-To: <20081125150000.GA28748@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 25 Nov 2008, Herbert Xu wrote:
> On Mon, Nov 24, 2008 at 05:11:42PM +0100, Geert Uytterhoeven wrote:
> > As pointed out in patch [1/4], some underlying (de)compression impl=
ementations
> > do not support partial (de)compression.  This is the case for e.g. =
LZO, which
> > is already supported by a crypto module. While one-shot (de)compres=
sion can
> > easily be implemented on top of a partial (de)compression API, the =
inverse is
> > not true.
>=20
> But that's just because lib/lzo didn't implement partial operations,
> which means that we can improve it to perform partial compression and
> decompression, right?

That's right. If the actual algorithm supports it, lib/lzo can be enhan=
ced.

> > Hence there should be a way to ask for a "one-shot" vs. "partial" d=
ecompression
> > module at crypto_alloc_comp() time.
>=20
> If we do find such an algorithm (which I'm sceptical), then we can
> easily add such a flag which can be used at alloc time to choose
> the right type.
>=20
> In fact, even if such algorithm did exist (i.e., one that requires
> all the input to determine the first byte of the output), we can
> always handle it by only ever writing output in the final function.

Indeed. Whether the users can handle it is a different question. Curren=
t
Squashfs assumes the decompressor always consumes all input bytes on ea=
ch and
every call.

> > Do you have any suggestions how to handle this?
> > Perhaps by using "oneshot(%s)" and "partial(%s)", cfr. what is done=
 in other
> > parts of the CRYPTO API where orthogonal features are combined?
>=20
> The standard way is to add a CRYPTO_ALG_FOO flag and use it at
> alloc time.
>=20
> But I really can't imagine how such an algorithm could possibly
> work beyond a fixed size input.
>=20
> Also, I'm not saying that you need to convert lzo yourself since
> you can always add a new compress type alongside the existing
> crypto_comp type.  When someone does finally convert lzo we can
> then kill the old type.  See the shash/digest code for an example=20
> of such a cohabitation.

OK.

On Tue, 25 Nov 2008, Herbert Xu wrote:
> On Mon, Nov 24, 2008 at 05:12:37PM +0100, Geert Uytterhoeven wrote:
> > To solve this, add the following operations that support partial
> > (de)compression:
> >   - crypto_compress_{init,update,final}() for compression,
> >   - crypto_decompress_{init,update,final}() for decompression.
>=20
> Probably best to put this in a new type instead of crypto_comp.
> That way you can still get a bisectable tree without having to
> lump everything into one patch.

OK, I'll create a new crypto_* type.

> Doing that also means that you don't have to convert all the algorith=
ms
> at once (but please do convert them eventually so I don't have to :)

Currently the only (de)compression algorithms supported by crypto/ are
deflate/zlib and lzo, so there's not that much to convert/migrate.
Obviously I'll take care of deflate/zlib.

> To make the conversion happen gradually you'd make all algorithms
> of the new type available through the existing type (crypto_comp).
> See how crypto_shash handles this with regards to the existing
> crypto_hash type.

OK, I'll look into that.

> Once all algorithms are converted then you can convert the existing
> users (new users can begin using the new type immediately).  Finally
> you'd kill the crypto_comp type.

OK.

Thx!

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
