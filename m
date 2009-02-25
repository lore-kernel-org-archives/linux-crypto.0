From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH][trivial] crypto: tcrypt - reduce stack size
Date: Wed, 25 Feb 2009 15:44:02 +0100 (CET)
Message-ID: <alpine.LRH.2.00.0902251542010.15476@vixen.sonytel.be>
References: <49A54C23.8090209@suse.de> <20090225142000.GA4136@gondor.apana.org.au> <49A55499.6090700@suse.de> <20090225142744.GA4331@gondor.apana.org.au> <alpine.LRH.2.00.0902251529440.15476@vixen.sonytel.be> <49A55771.1050408@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux kernel <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, Frank Seidel <frank@f-seidel.de>,
	akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
	nhorman@tuxdriver.com, lho@amcc.com, kaber@trash.net,
	darrenrjenkins@gmail.com, Greg KH <gregkh@suse.de>
To: Frank Seidel <fseidel@suse.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:65338 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752431AbZBYOoF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Feb 2009 09:44:05 -0500
In-Reply-To: <49A55771.1050408@suse.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 25 Feb 2009, Frank Seidel wrote:
> Geert Uytterhoeven wrote:
> > Probably people should be reminded tcrypt can only be a module, not=
 built-in,
> > so it won't waste precious unswappable kernel memory if it's static=
=2E
>=20
> Thats right, but it also doesn't hurt to simply use kmalloc, does it?=
 :-)

Wel...

Using kmalloc() increases code size, makes the code more complex, and i=
ncreases
the risk of introducing a memory leak now or later.

> I just stumbled over tcrypt on the make checkstack output and as also
> the kerneljanitors todo advises to reduce this footprint where possib=
le
> i just wanted to help out here.

Reducing stack usage is fine. However, for a loadable test module witho=
ut
concurrency issues it's far easier to do that by just making the data s=
tatic.

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
