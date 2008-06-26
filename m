From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: "deflate" crypto module questions
Date: Thu, 26 Jun 2008 09:14:51 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0806260912120.9465@vixen.sonytel.be>
References: <Pine.LNX.4.64.0806251916240.8685@vixen.sonytel.be>
 <20080625191457.GA30142@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-1236677975-1214464491=:9465"
Cc: James Morris <jmorris@namei.org>, linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:36292 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750862AbYFZHOx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 Jun 2008 03:14:53 -0400
In-Reply-To: <20080625191457.GA30142@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-1236677975-1214464491=:9465
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 25 Jun 2008, Sebastian Siewior wrote:
> * Geert Uytterhoeven | 2008-06-25 19:26:28 [+0200]:
> >I have a few questions about the "deflate" crypto module (crypto/deflate.c).
> >
> >  1. Why does it support decompression of full chunks only (i.e. all compressed
> >     data has to be passed at once)?  Is there a specific reason for that?
> >     Or is it just because so far nobody needed partial decompression?
> I guess the latter. The only user is ipcomp_decompress() as far as I can

IC.

> see. Other zlib users like ppp or jffs2 user zlib directly. However, the
> crypto API is the only place in kernel which provides you a generic
> interface for compression.

Indeed. So if a hardware-assisted deflate would be available as a crypto
module, "deflate" crypto module users would benefit from it automatically,
right? While direct zlib users are out of luck.

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

Sony Technology and Software Centre Europe
A division of Sony Service Centre (Europe) N.V.
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium
VAT BE 0413.825.160 · RPR Brussels
Fortis 293-0376800-10 GEBA-BE-BB
---584349381-1236677975-1214464491=:9465--
