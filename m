From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: LRW endian issues?
Date: Wed, 18 Feb 2009 15:14:16 +0100 (CET)
Message-ID: <alpine.LRH.2.00.0902181512570.29726@vixen.sonytel.be>
References: <20090206040124.GA4299@gondor.apana.org.au> <alpine.LRH.2.00.0902061117570.26894@vixen.sonytel.be> <20090210120218.GA23234@gondor.apana.org.au> <alpine.LRH.2.00.0902121629480.29413@vixen.sonytel.be> <20090218134451.GA29520@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: rsnel@cube.dyndns.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:55264 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751928AbZBROOS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Feb 2009 09:14:18 -0500
In-Reply-To: <20090218134451.GA29520@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 18 Feb 2009, Herbert Xu wrote:
> On Thu, Feb 12, 2009 at 04:30:11PM +0100, Geert Uytterhoeven wrote:
> >
> > > Thanks, could you try this patch?
> >=20
> > Unfortunately it doesn't seem to make any difference.
>=20
> Thanks for testing.  I've reproduced the problem here and this
> is the fix I've come up with.
>=20
> commit 6fe4a28d8855e072036f36ee22f0a8f43f44918f
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:   Wed Feb 18 21:41:29 2009 +0800
>=20
>     crypto: testmgr - Test skciphers with no IVs

I can confirm the test no longer hangs on "modprobe tcrypt mode=3D10" (=
after
reverting "crypto: lrw - Fix big endian support").

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
