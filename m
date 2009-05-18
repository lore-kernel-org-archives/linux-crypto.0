From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH] crypto: compress - Return produced bytes in
 crypto_{,de}compress_{update,final}()
Date: Mon, 18 May 2009 09:16:49 +0200 (CEST)
Message-ID: <alpine.LRH.2.00.0905180915430.16754@vixen.sonytel.be>
References: <1235569394-15217-3-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-4-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-5-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-6-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1235569394-15217-7-git-send-email-Geert.Uytterhoeven@sonycom.com> <20090307104637.GB8731@gondor.apana.org.au> <49B36A18.5030506@lougher.demon.co.uk> <alpine.LRH.2.00.0903111830540.1040@vixen.sonytel.be> <alpine.LRH.2.00.0903171345040.7595@vixen.sonytel.be>
 <alpine.LRH.2.00.0903241729540.4446@vixen.sonytel.be> <20090420060313.GA891@gondor.apana.org.au> <alpine.LRH.2.00.0904200925290.11211@vixen.sonytel.be> <alpine.LRH.2.00.0905051613070.21255@vixen.sonytel.be>
 <alpine.LRH.2.00.0905111731490.302@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>,
	linux-crypto@vger.kernel.org,
	Linux Kernel Development <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:51249 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755877AbZERHQv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 May 2009 03:16:51 -0400
In-Reply-To: <alpine.LRH.2.00.0905111731490.302@vixen.sonytel.be>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

	Hi Herbert,

On Mon, 11 May 2009, Geert Uytterhoeven wrote:
> If crypto_{,de}compress_{update,final}() succeed, return the actual n=
umber of
> bytes produced instead of zero, so their users don't have to calculat=
e that
> theirselves.
>=20
> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> ---
> As we're already at 2.6.30-rc5, I do not want to delay any longer thi=
s API
> change for a new module introduced for 2.6.30.
>=20
> Herbert, please apply for 2.6.30.
> Thanks!

As I just saw your pull request for Linus, which didn't include this ch=
ange,
I'm wondering if you plan to apply it for 2.6.30?

Thanks again!

With kind regards,

Geert Uytterhoeven
Software Architect
Techsoft Centre

Technology and Software Centre Europe
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
