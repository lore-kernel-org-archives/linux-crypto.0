From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: "deflate" crypto module questions
Date: Wed, 25 Jun 2008 19:26:28 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0806251916240.8685@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-273319450-1214414788=:8685"
Cc: linux-crypto@vger.kernel.org,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: James Morris <jmorris@namei.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:58307 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752348AbYFYR0b (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Jun 2008 13:26:31 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-273319450-1214414788=:8685
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

	Hi,

I have a few questions about the "deflate" crypto module (crypto/deflate.c).

  1. Why does it support decompression of full chunks only (i.e. all compressed
     data has to be passed at once)?  Is there a specific reason for that?
     Or is it just because so far nobody needed partial decompression?

  2. Why was the lazy allocation removed back in 2004?
     If you're interested in decompression only, it's a bit wasteful to
     allocate 262 KiB of memory for compression and never use it.

Thanks for your answers!

Please CC me, as I'm not subscribed, and
http://vger.kernel.org/vger-lists.html#linux-crypto doesn't list any archives.

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
---584349381-273319450-1214414788=:8685--
