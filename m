From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH] crypto: shash - Handle failures in crypto_alloc_shash()
 correctly
Date: Wed, 18 Feb 2009 10:07:38 +0100 (CET)
Message-ID: <alpine.LRH.2.00.0902181005570.28815@vixen.sonytel.be>
References: <alpine.LRH.2.00.0902171845420.13163@vixen.sonytel.be> <20090218085842.GA28120@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:49350 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751315AbZBRJHl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Feb 2009 04:07:41 -0500
In-Reply-To: <20090218085842.GA28120@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 18 Feb 2009, Herbert Xu wrote:
> On Tue, Feb 17, 2009 at 06:46:40PM +0100, Geert Uytterhoeven wrote:
> > crypto_alloc_tfm() returns an error-valued pointer in case of failu=
re,
> > which must not be translated using __crypto_shash_cast().
> >=20
> > Currently everything works fine because __crypto_shash_cast() is a =
no-op
> > (crypto_shash.base is at offset zero).
> >=20
> > Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
>=20
> Thanks for the patch.  I think it's easier to just do the casting
> in the underlying functions directly, like this:

Yep, I haven't tried it yet, but it looks OK.

The only caveat is that crypto_*.base must always be at offset zero now=
=2E

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village =B7 Da Vincilaan 7-D1 =B7 B-1935 Zaventem =B7 Bel=
gium

Phone:    +32 (0)2 700 8453
=46ax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 =B7 RPR Brussels
=46ortis =B7 BIC GEBABEBB =B7 IBAN BE41293037680010
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
