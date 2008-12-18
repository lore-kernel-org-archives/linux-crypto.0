From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH/RFC 2/8] crypto: compress - Add pcomp interface
Date: Thu, 18 Dec 2008 18:28:09 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0812181820100.25762@vixen.sonytel.be>
References: <20081217163634.998961917@vixen.sonytel.be>
 <20081217164036.539681327@vixen.sonytel.be> <20081218061908.GB27951@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:56222 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752423AbYLRR2R (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Dec 2008 12:28:17 -0500
In-Reply-To: <20081218061908.GB27951@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 18 Dec 2008, Herbert Xu wrote:
> On Wed, Dec 17, 2008 at 05:36:37PM +0100, Geert Uytterhoeven wrote:
> > @@ -3,7 +3,7 @@
> >  #
> > =20
> >  obj-$(CONFIG_CRYPTO) +=3D crypto.o
> > -crypto-objs :=3D api.o cipher.o digest.o compress.o
> > +crypto-objs :=3D api.o cipher.o digest.o compress.o pcompress.o
>=20
> Sorry, you modelled it on the wrong type.  These are the original
> and obsolete types.  You should model it on one of the others.  I
> recommend the crypto_shash type which is most recent.

Can you please elaborate a bit more?

You mean pcomp should provide a struct crypto_type?
And the underlying algorithms shouldn't use crypto_alg directly anymore=
?

Thanks!

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
