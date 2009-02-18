From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH] crypto: shash - Handle failures in crypto_alloc_shash()
 correctly
Date: Wed, 18 Feb 2009 14:27:38 +0100 (CET)
Message-ID: <alpine.LRH.2.00.0902181409440.29726@vixen.sonytel.be>
References: <alpine.LRH.2.00.0902171845420.13163@vixen.sonytel.be> <20090218085842.GA28120@gondor.apana.org.au> <alpine.LRH.2.00.0902181005570.28815@vixen.sonytel.be> <20090218094548.GA28420@gondor.apana.org.au> <alpine.LRH.2.00.0902181057490.29726@vixen.sonytel.be>
 <20090218110641.GA28781@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:54124 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751788AbZBRN1k (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Feb 2009 08:27:40 -0500
In-Reply-To: <20090218110641.GA28781@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 18 Feb 2009, Herbert Xu wrote:
> On Wed, Feb 18, 2009 at 10:59:13AM +0100, Geert Uytterhoeven wrote:
> > But if you put stuff in your crypto_* before base, you still need t=
he special
> > translation (and check for IS_ERR()).
>=20
> You've lost me.  With my patch crypto_create_tfm will either
> return the pointer to the start of the area allocated or an error.
>=20
> Why would you need any special translation?

Sorry, I misread your patch. crypto_create_tfm() already takes care of =
the
translation.

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
