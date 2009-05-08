From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: pcomp for lzma for later use with squashfs
Date: Fri, 8 May 2009 14:14:18 +0200 (CEST)
Message-ID: <alpine.LRH.2.00.0905081410170.7964@vixen.sonytel.be>
References: <4A041EE5.4000008@hiramoto.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, phillip@lougher.demon.co.uk
To: Karl Hiramoto <karl@hiramoto.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:58212 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752178AbZEHMOT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 May 2009 08:14:19 -0400
In-Reply-To: <4A041EE5.4000008@hiramoto.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 8 May 2009, Karl Hiramoto wrote:
> Was wondering if there are any patches for pcomp lzma. it it just a m=
atter of
> adding crypto/lzma to make the calls to lib/decompress_unlzma.c ?

I'm afraid not, as lib/decompress_unlzma.c seems to use a `pull' framew=
ork (the
`fill' function pointer), complicating partial decompression.

> I just started looking at this, my end goal is to use your pcomp patc=
h for
> squashfs and get lzma squahsfs.

That would be great, thx!

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
