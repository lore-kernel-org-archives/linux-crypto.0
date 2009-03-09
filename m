From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: dm/crypt oops in 2.6.28.5 ... but nvidia users aren't supposed
 to report?
Date: Mon, 9 Mar 2009 10:13:49 +0100 (CET)
Message-ID: <alpine.LRH.2.00.0903091013090.18346@vixen.sonytel.be>
References: <200903070135.28847@rk-nord.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: bugme-admin@linux-foundation.org, linux-crypto@vger.kernel.org
To: Melchior FRANZ <mfranz@aon.at>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:61312 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754117AbZCIJOE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Mar 2009 05:14:04 -0400
In-Reply-To: <200903070135.28847@rk-nord.at>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, 7 Mar 2009, Melchior FRANZ wrote:
> I was about to report an oops in the crypt module (NULL pointer
> dereferencing), but when I was half-way through entering the bug
> in bugzilla, I read that people with nvidia tainted kernels aren't
> supposed to file bug reports.
>=20
> So the bug is going to remain unfixed!? Sounds like a smart move ...

Can you reproduce the problem if the proprietary modules are not loaded=
?
If yes, you can file a bug report.

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
